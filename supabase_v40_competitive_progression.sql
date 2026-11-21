-- Midnight Racing v40: ranked ladder, server-side result validation and achievements.
-- Run this as a NEW query after the v36 base setup AND v37 private-room setup.
-- Additive migration: preserves existing auth users, saves, and race_leaderboard rows.

begin;

create table if not exists public.mr_player_stats (
  user_id uuid primary key references auth.users(id) on delete cascade,
  username text not null default 'RACER',
  rating integer not null default 1000 check (rating between 100 and 3000),
  ranked_matches integer not null default 0 check (ranked_matches >= 0),
  ranked_wins integer not null default 0 check (ranked_wins >= 0),
  ranked_losses integer not null default 0 check (ranked_losses >= 0),
  total_races integer not null default 0 check (total_races >= 0),
  wins integer not null default 0 check (wins >= 0),
  podiums integer not null default 0 check (podiums >= 0),
  online_races integer not null default 0 check (online_races >= 0),
  updated_at timestamptz not null default now()
);

create index if not exists mr_player_stats_rating_idx
  on public.mr_player_stats (rating desc, ranked_wins desc, ranked_matches asc);

create table if not exists public.mr_user_achievements (
  user_id uuid not null references auth.users(id) on delete cascade,
  achievement_id text not null,
  unlocked_at timestamptz not null default now(),
  primary key (user_id, achievement_id),
  constraint mr_user_achievement_id_safe check (achievement_id ~ '^[a-z0-9_]{2,48}$')
);

create index if not exists mr_user_achievements_public_idx
  on public.mr_user_achievements (achievement_id, unlocked_at desc);

create table if not exists public.mr_ranked_match_results (
  match_id text not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  placement integer not null check (placement between 1 and 6),
  rating_before integer not null,
  rating_after integer not null,
  rating_change integer not null,
  human_opponents integer not null default 0,
  created_at timestamptz not null default now(),
  primary key (match_id, user_id),
  constraint mr_ranked_match_id_length check (length(match_id) between 6 and 80)
);

alter table public.mr_player_stats enable row level security;
alter table public.mr_user_achievements enable row level security;
alter table public.mr_ranked_match_results enable row level security;

revoke all on table public.mr_player_stats from anon, authenticated;
revoke all on table public.mr_user_achievements from anon, authenticated;
revoke all on table public.mr_ranked_match_results from anon, authenticated;
grant select on table public.mr_player_stats to anon, authenticated;
grant select on table public.mr_user_achievements to authenticated;
grant select on table public.mr_ranked_match_results to authenticated;

drop policy if exists "mr public ranked stats read" on public.mr_player_stats;
create policy "mr public ranked stats read"
  on public.mr_player_stats for select to anon, authenticated using (true);

drop policy if exists "mr public achievement badges read" on public.mr_user_achievements;
create policy "mr players read own achievement badges"
  on public.mr_user_achievements for select to authenticated
  using (user_id = (select auth.uid()));

drop policy if exists "mr players read own ranked history" on public.mr_ranked_match_results;
create policy "mr players read own ranked history"
  on public.mr_ranked_match_results for select to authenticated
  using (user_id = (select auth.uid()));

-- Ranked results must now go through the validation RPC, not direct table inserts.
revoke insert, update, delete on table public.race_leaderboard from anon, authenticated;
grant select on table public.race_leaderboard to anon, authenticated;

create or replace function public.mr_ensure_player_stats()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_name text;
begin
  if v_user is null then raise exception 'Sign in to initialize your racer profile.'; end if;
  select coalesce(
    (select nullif(left(trim(p.username),18),'') from public.player_profiles p where p.user_id=v_user),
    nullif(left(trim((select u.raw_user_meta_data ->> 'username' from auth.users u where u.id=v_user)),18),''),
    'RACER'
  ) into v_name;
  insert into public.mr_player_stats(user_id,username)
  values(v_user,coalesce(v_name,'RACER'))
  on conflict(user_id) do update set username=excluded.username,updated_at=now();
end;
$$;

create or replace function public.mr_set_player_username(p_username text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_name text := left(trim(coalesce(p_username,'')),18);
begin
  if v_user is null then raise exception 'Sign in first.'; end if;
  if v_name !~ '^[A-Za-z0-9_ -]{3,18}$' then raise exception 'Use 3–18 letters, numbers, spaces or underscores.'; end if;
  insert into public.player_profiles(user_id,username,updated_at)
  values(v_user,v_name,now())
  on conflict(user_id) do update set username=excluded.username,updated_at=now();
  insert into public.mr_player_stats(user_id,username)
  values(v_user,v_name)
  on conflict(user_id) do update set username=excluded.username,updated_at=now();
end;
$$;

create or replace function public.mr_submit_race_result(
  p_track text,
  p_mode text,
  p_race_time double precision,
  p_placement integer,
  p_credits_earned integer,
  p_online boolean default false,
  p_match_id text default null,
  p_opponent_ids uuid[] default '{}'::uuid[]
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_mode text := lower(coalesce(p_mode,''));
  v_track text := left(coalesce(p_track,'Unknown'),48);
  v_name text;
  v_rating_before integer := 1000;
  v_rating_after integer := 1000;
  v_rating_change integer := 0;
  v_avg_opponent_rating numeric;
  v_human_opponents integer := 0;
  v_expected numeric;
  v_actual numeric;
  v_races integer;
  v_wins integer;
  v_podiums integer;
  v_online_races integer;
  v_ranked_matches integer;
  v_ranked_wins integer;
  v_ranked_losses integer;
  v_match_id text := nullif(left(trim(coalesce(p_match_id,'')),80),'');
  v_new_achievements text[] := array[]::text[];
  v_achievement text;
begin
  if v_user is null then raise exception 'Sign in before submitting a race result.'; end if;
  if v_mode not in ('street','duel','ghost','checkpoint','drift','traffic','time','infected','police','ranked','tournament','random') then
    raise exception 'This race mode is not recognized.';
  end if;
  if v_track !~ '^[A-Za-z0-9 _-]{1,48}$' then raise exception 'Track name is invalid.'; end if;
  if p_race_time is null or p_race_time < 5 or p_race_time > 2400 then raise exception 'Race time failed validation.'; end if;
  if p_placement is null or p_placement < 1 or p_placement > 6 then raise exception 'Race placement failed validation.'; end if;
  if p_credits_earned is null or p_credits_earned < 0 or p_credits_earned > 5000 then raise exception 'Credit reward failed validation.'; end if;
  if v_mode in ('ranked','tournament') and not coalesce(p_online,false) then raise exception 'Competitive results must come from an online race.'; end if;
  if v_mode in ('ranked','tournament') and p_race_time < 20 then raise exception 'Competitive race time failed minimum-duration validation.'; end if;
  if v_mode='ranked' and v_match_id is null then raise exception 'Ranked match reference is missing. This result was not rated.'; end if;
  if v_mode='ranked' and length(v_match_id)<6 then raise exception 'Ranked match reference is invalid.'; end if;

  select coalesce(nullif(left(trim(p.username),18),''),'RACER') into v_name
  from public.player_profiles p where p.user_id=v_user;
  v_name := coalesce(v_name,'RACER');
  insert into public.mr_player_stats(user_id,username)
  values(v_user,v_name)
  on conflict(user_id) do nothing;

  select rating into v_rating_before from public.mr_player_stats where user_id=v_user for update;
  v_rating_before := coalesce(v_rating_before,1000);
  v_rating_after := v_rating_before;

  if v_mode='ranked' then
    if exists(select 1 from public.mr_ranked_match_results where match_id=v_match_id and user_id=v_user) then
      raise exception 'This ranked result has already been submitted.';
    end if;
    select count(*),avg(s.rating)::numeric into v_human_opponents,v_avg_opponent_rating
    from public.mr_player_stats s
    where s.user_id = any(coalesce(p_opponent_ids,'{}'::uuid[])) and s.user_id <> v_user;
    if coalesce(v_human_opponents,0)>0 and v_avg_opponent_rating is not null then
      v_expected := 1.0 / (1.0 + power(10.0, ((v_avg_opponent_rating-v_rating_before)::numeric / 400.0)));
      v_actual := case p_placement when 1 then 1.0 when 2 then 0.75 when 3 then 0.60 when 4 then 0.40 when 5 then 0.25 else 0.10 end;
      v_rating_change := round(32.0 * (v_actual-v_expected))::integer;
      v_rating_after := greatest(100,least(3000,v_rating_before+v_rating_change));
    else
      -- AI-only ranked fillers do not alter ELO. Results and career stats are still recorded.
      v_rating_change := 0;
    end if;
    insert into public.mr_ranked_match_results(match_id,user_id,placement,rating_before,rating_after,rating_change,human_opponents)
    values(v_match_id,v_user,p_placement,v_rating_before,v_rating_after,v_rating_change,coalesce(v_human_opponents,0));
  end if;

  insert into public.race_leaderboard(user_id,username,track,mode,race_time,placement,credits_earned)
  values(v_user,v_name,v_track,v_mode,p_race_time,p_placement,p_credits_earned);

  update public.mr_player_stats
  set username=v_name,
      rating=v_rating_after,
      total_races=total_races+1,
      wins=wins+case when p_placement=1 then 1 else 0 end,
      podiums=podiums+case when p_placement<=3 then 1 else 0 end,
      online_races=online_races+case when coalesce(p_online,false) then 1 else 0 end,
      ranked_matches=ranked_matches+case when v_mode='ranked' then 1 else 0 end,
      ranked_wins=ranked_wins+case when v_mode='ranked' and p_placement=1 then 1 else 0 end,
      ranked_losses=ranked_losses+case when v_mode='ranked' and p_placement<>1 then 1 else 0 end,
      updated_at=now()
  where user_id=v_user
  returning total_races,wins,podiums,online_races,ranked_matches,ranked_wins,ranked_losses
  into v_races,v_wins,v_podiums,v_online_races,v_ranked_matches,v_ranked_wins,v_ranked_losses;

  -- Server-controlled achievement unlocks based on server-recorded race/ranked stats.
  for v_achievement in
    select x.achievement_id from (values
      ('first_race',v_races>=1),
      ('street_regular',v_races>=10),
      ('road_veteran',v_races>=50),
      ('first_win',v_wins>=1),
      ('ten_wins',v_wins>=10),
      ('podium_ten',v_podiums>=10),
      ('online_debut',v_online_races>=1),
      ('online_ten',v_online_races>=10),
      ('ranked_first',v_ranked_matches>=1),
      ('ranked_win',v_ranked_wins>=1),
      ('ranked_ten',v_ranked_wins>=10),
      ('silver_rating',v_rating_after>=1200),
      ('gold_rating',v_rating_after>=1400),
      ('platinum_rating',v_rating_after>=1600)
    ) as x(achievement_id,is_earned)
    where x.is_earned
  loop
    insert into public.mr_user_achievements(user_id,achievement_id)
    values(v_user,v_achievement)
    on conflict(user_id,achievement_id) do nothing;
    if found then v_new_achievements := array_append(v_new_achievements,v_achievement); end if;
  end loop;

  return jsonb_build_object(
    'rating',v_rating_after,
    'rating_change',v_rating_change,
    'ranked_matches',v_ranked_matches,
    'ranked_wins',v_ranked_wins,
    'ranked_losses',v_ranked_losses,
    'total_races',v_races,
    'wins',v_wins,
    'podiums',v_podiums,
    'online_races',v_online_races,
    'new_achievements',to_jsonb(v_new_achievements)
  );
end;
$$;

revoke all on function public.mr_ensure_player_stats() from public, anon;
revoke all on function public.mr_set_player_username(text) from public, anon;
revoke all on function public.mr_submit_race_result(text,text,double precision,integer,integer,boolean,text,uuid[]) from public, anon;
grant execute on function public.mr_ensure_player_stats() to authenticated;
grant execute on function public.mr_set_player_username(text) to authenticated;
grant execute on function public.mr_submit_race_result(text,text,double precision,integer,integer,boolean,text,uuid[]) to authenticated;

commit;

-- Verify the migration. Expected: all values true.
select
  has_table_privilege('authenticated','public.mr_player_stats','SELECT') as can_read_ranked_profiles,
  has_table_privilege('authenticated','public.mr_user_achievements','SELECT') as can_read_achievements,
  has_function_privilege('authenticated','public.mr_ensure_player_stats()','EXECUTE') as can_initialize_stats,
  has_function_privilege('authenticated','public.mr_submit_race_result(text,text,double precision,integer,integer,boolean,text,uuid[])','EXECUTE') as can_submit_validated_results,
  not has_table_privilege('authenticated','public.race_leaderboard','INSERT') as direct_leaderboard_insert_blocked;
