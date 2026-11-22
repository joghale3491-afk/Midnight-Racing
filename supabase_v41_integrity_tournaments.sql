-- Midnight Racing v41: competitive result integrity and server-saved tournaments.
-- Apply AFTER the v36/base setup, v37 private-room setup and v40 competitive progression migration.
-- Additive: does not delete or reset existing accounts, saves, profiles or leaderboard rows.

begin;

create table if not exists public.mr_competitive_match_players_v41 (
  match_id text not null check (match_id ~ '^[A-Za-z0-9_-]{6,80}$'),
  user_id uuid not null references auth.users(id) on delete cascade,
  mode text not null check (mode in ('ranked','tournament')),
  joined_at timestamptz not null default now(),
  primary key (match_id,user_id)
);
create index if not exists mr_competitive_players_user_v41_idx
  on public.mr_competitive_match_players_v41(user_id,joined_at desc);

-- One authenticated entrant can report only one placement in a match; two entrants
-- cannot claim the same human placement for the same match.
create table if not exists public.mr_competitive_result_claims_v41 (
  match_id text not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  mode text not null check (mode in ('ranked','tournament')),
  placement integer not null check (placement between 1 and 6),
  created_at timestamptz not null default now(),
  primary key (match_id,user_id),
  unique (match_id,placement)
);

create table if not exists public.mr_tournament_entries_v41 (
  season_key date not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  username text not null default 'RACER',
  current_round integer not null default 1 check (current_round between 1 and 3),
  total_points integer not null default 0 check (total_points >= 0),
  completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (season_key,user_id)
);
create index if not exists mr_tournament_entries_score_v41_idx
  on public.mr_tournament_entries_v41(season_key,total_points desc,completed desc,updated_at asc);

create table if not exists public.mr_tournament_round_results_v41 (
  season_key date not null,
  round_no integer not null check (round_no between 1 and 3),
  match_id text not null check (match_id ~ '^[A-Za-z0-9_-]{6,80}$'),
  user_id uuid not null references auth.users(id) on delete cascade,
  username text not null,
  placement integer not null check (placement between 1 and 6),
  race_time numeric(10,2) not null check (race_time >= 20 and race_time <= 2400),
  points integer not null check (points between 0 and 10),
  created_at timestamptz not null default now(),
  primary key (season_key,round_no,user_id),
  unique (match_id,user_id),
  unique (match_id,placement)
);
create index if not exists mr_tournament_round_results_user_v41_idx
  on public.mr_tournament_round_results_v41(user_id,season_key,round_no);

alter table public.mr_competitive_match_players_v41 enable row level security;
alter table public.mr_competitive_result_claims_v41 enable row level security;
alter table public.mr_tournament_entries_v41 enable row level security;
alter table public.mr_tournament_round_results_v41 enable row level security;
revoke all on table public.mr_competitive_match_players_v41 from anon,authenticated;
revoke all on table public.mr_competitive_result_claims_v41 from anon,authenticated;
revoke all on table public.mr_tournament_entries_v41 from anon,authenticated;
revoke all on table public.mr_tournament_round_results_v41 from anon,authenticated;

create or replace function public.mr_join_competitive_match_v41(
  p_match_id text,
  p_mode text,
  p_season_key date default null,
  p_round integer default null
) returns jsonb
language plpgsql security definer set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_mode text := lower(coalesce(p_mode,''));
  v_match text := trim(coalesce(p_match_id,''));
  v_existing_mode text;
  v_count integer;
begin
  if v_user is null then raise exception 'Sign in before joining a competitive race.'; end if;
  if v_mode not in ('ranked','tournament') then raise exception 'Unsupported competitive match mode.'; end if;
  if v_match !~ '^[A-Za-z0-9_-]{6,80}$' then raise exception 'Invalid competitive match reference.'; end if;
  if v_mode='tournament' then
    if p_season_key is null or p_round is null or p_round not between 1 and 3 then raise exception 'Tournament season or round is missing.'; end if;
    if not exists(select 1 from public.mr_tournament_entries_v41 e where e.season_key=p_season_key and e.user_id=v_user and e.current_round=p_round and not e.completed) then
      raise exception 'Join the current tournament round before entering its race.';
    end if;
  end if;
  select m.mode into v_existing_mode from public.mr_competitive_match_players_v41 m where m.match_id=v_match and m.user_id=v_user;
  if found and v_existing_mode<>v_mode then raise exception 'This match reference is already registered for another mode.'; end if;
  insert into public.mr_competitive_match_players_v41(match_id,user_id,mode)
  values(v_match,v_user,v_mode)
  on conflict(match_id,user_id) do nothing;
  select count(*) into v_count from public.mr_competitive_match_players_v41 m where m.match_id=v_match and m.mode=v_mode;
  return jsonb_build_object('match_id',v_match,'mode',v_mode,'registered_players',v_count);
end;
$$;

create or replace function public.mr_get_tournament_status_v41(p_season_key date)
returns jsonb
language plpgsql security definer set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_entry jsonb;
  v_results jsonb;
begin
  if v_user is null then raise exception 'Sign in to view tournament progress.'; end if;
  select to_jsonb(e) into v_entry from public.mr_tournament_entries_v41 e
   where e.season_key=p_season_key and e.user_id=v_user;
  select coalesce(jsonb_agg(jsonb_build_object(
    'round_no',r.round_no,'placement',r.placement,'points',r.points,'race_time',r.race_time,'created_at',r.created_at
  ) order by r.round_no),'[]'::jsonb)
  into v_results from public.mr_tournament_round_results_v41 r
  where r.season_key=p_season_key and r.user_id=v_user;
  return jsonb_build_object('entry',v_entry,'results',v_results);
end;
$$;

create or replace function public.mr_join_tournament_v41(p_season_key date,p_username text)
returns jsonb
language plpgsql security definer set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_name text := left(trim(coalesce(p_username,'RACER')),18);
begin
  if v_user is null then raise exception 'Sign in to enter the tournament.'; end if;
  if p_season_key is null or p_season_key <> date_trunc('week',now())::date then
    raise exception 'This tournament season is out of date. Refresh the Tournament tab.';
  end if;
  if v_name !~ '^[A-Za-z0-9_ -]{3,18}$' then v_name := 'RACER'; end if;
  insert into public.mr_tournament_entries_v41(season_key,user_id,username)
  values(p_season_key,v_user,v_name)
  on conflict(season_key,user_id) do update set username=excluded.username,updated_at=now();
  return public.mr_get_tournament_status_v41(p_season_key);
end;
$$;



create or replace function public.mr_tournament_standings_v41(p_season_key date)
returns table("position" bigint,username text,total_points integer,current_round integer,completed boolean)
language sql stable security definer set search_path = ''
as $$
  select row_number() over(order by e.total_points desc,e.completed desc,e.updated_at asc,e.username asc),
         e.username,e.total_points,e.current_round,e.completed
  from public.mr_tournament_entries_v41 e
  where e.season_key=p_season_key
  order by e.total_points desc,e.completed desc,e.updated_at asc,e.username asc
  limit 50;
$$;

create or replace function public.mr_submit_game_result_v41(
  p_track text,
  p_mode text,
  p_race_time double precision,
  p_placement integer,
  p_credits_earned integer,
  p_online boolean default false,
  p_match_id text default null,
  p_season_key date default null,
  p_round integer default null
) returns jsonb
language plpgsql security definer set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_mode text := lower(coalesce(p_mode,''));
  v_match text := trim(coalesce(p_match_id,''));
  v_players uuid[] := array[]::uuid[];
  v_player_count integer := 0;
  v_result jsonb;
  v_points integer := 0;
  v_tournament_status jsonb;
  v_entry public.mr_tournament_entries_v41%rowtype;
begin
  if v_user is null then raise exception 'Sign in before submitting a race result.'; end if;
  if v_mode in ('ranked','tournament') then
    if not coalesce(p_online,false) then raise exception 'Competitive results must come from an online match.'; end if;
    if v_match !~ '^[A-Za-z0-9_-]{6,80}$' then raise exception 'Competitive match registration is missing.'; end if;
    select coalesce(array_agg(m.user_id order by m.joined_at,m.user_id),'{}'::uuid[]),count(*)
      into v_players,v_player_count
    from public.mr_competitive_match_players_v41 m
    where m.match_id=v_match and m.mode=v_mode;
    if not (v_user=any(v_players)) then raise exception 'This account was not registered as a participant in that match.'; end if;
    if v_mode='ranked' and p_race_time < 20 then raise exception 'Ranked race time failed minimum-duration validation.'; end if;
    if v_mode='tournament' then
      if p_season_key is null or p_round is null or p_round not between 1 and 3 then raise exception 'Tournament season or round is missing.'; end if;
      if v_player_count < 2 then raise exception 'A tournament round needs at least two registered human racers.'; end if;
      select * into v_entry from public.mr_tournament_entries_v41 e
       where e.season_key=p_season_key and e.user_id=v_user for update;
      if not found or v_entry.completed or v_entry.current_round<>p_round then
        raise exception 'This tournament round is already complete or is not your current round.';
      end if;
    end if;
    if exists(select 1 from public.mr_competitive_result_claims_v41 c where c.match_id=v_match and c.user_id=v_user) then
      raise exception 'This account has already submitted a result for this match.';
    end if;
    if exists(select 1 from public.mr_competitive_result_claims_v41 c where c.match_id=v_match and c.placement=p_placement) then
      raise exception 'That finishing position has already been recorded for this match.';
    end if;
    insert into public.mr_competitive_result_claims_v41(match_id,user_id,mode,placement)
    values(v_match,v_user,v_mode,p_placement);
  end if;

  -- v40's protected procedure still performs the profile/stat/achievement update.
  -- Opponent IDs come only from the server-registered match roster, never from the browser.
  v_result := public.mr_submit_race_result(
    p_track,v_mode,p_race_time,p_placement,
    case when v_mode in ('ranked','tournament') then 0 else p_credits_earned end,
    coalesce(p_online,false),nullif(v_match,''),v_players
  );

  if v_mode='tournament' then
    v_points := case p_placement when 1 then 10 when 2 then 7 when 3 then 5 when 4 then 3 when 5 then 2 when 6 then 1 else 0 end;
    insert into public.mr_tournament_round_results_v41(season_key,round_no,match_id,user_id,username,placement,race_time,points)
    values(p_season_key,p_round,v_match,v_user,coalesce((select p.username from public.player_profiles p where p.user_id=v_user),'RACER'),p_placement,p_race_time,v_points);
    update public.mr_tournament_entries_v41 e
      set total_points=e.total_points+v_points,
          current_round=case when p_round>=3 then 3 else p_round+1 end,
          completed=(p_round>=3),
          updated_at=now()
    where e.season_key=p_season_key and e.user_id=v_user;
    v_tournament_status := public.mr_get_tournament_status_v41(p_season_key);
    v_result := v_result || jsonb_build_object('tournament',v_tournament_status,'tournament_points_earned',v_points);
  end if;
  return v_result;
end;
$$;

-- Clients must use the v41 wrapper; direct calls to the older parameter-trusting RPC are blocked.
revoke all on function public.mr_submit_race_result(text,text,double precision,integer,integer,boolean,text,uuid[]) from public,anon,authenticated;
revoke all on function public.mr_join_competitive_match_v41(text,text,date,integer) from public,anon,authenticated;
revoke all on function public.mr_join_tournament_v41(date,text) from public,anon,authenticated;
revoke all on function public.mr_get_tournament_status_v41(date) from public,anon,authenticated;
revoke all on function public.mr_tournament_standings_v41(date) from public,anon,authenticated;
revoke all on function public.mr_submit_game_result_v41(text,text,double precision,integer,integer,boolean,text,date,integer) from public,anon,authenticated;
grant execute on function public.mr_join_competitive_match_v41(text,text,date,integer) to authenticated;
grant execute on function public.mr_join_tournament_v41(date,text) to authenticated;
grant execute on function public.mr_get_tournament_status_v41(date) to authenticated;
grant execute on function public.mr_tournament_standings_v41(date) to anon,authenticated;
grant execute on function public.mr_submit_game_result_v41(text,text,double precision,integer,integer,boolean,text,date,integer) to authenticated;

commit;

-- Verification: expected values are true after this migration.
select
  has_table_privilege('authenticated','public.mr_competitive_match_players_v41','SELECT') as direct_match_roster_read_is_denied,
  has_table_privilege('authenticated','public.mr_tournament_entries_v41','SELECT') as direct_tournament_table_read_is_denied,
  has_function_privilege('authenticated','public.mr_join_tournament_v41(date,text)','EXECUTE') as can_join_tournaments,
  has_function_privilege('authenticated','public.mr_submit_game_result_v41(text,text,double precision,integer,integer,boolean,text,date,integer)','EXECUTE') as can_submit_v41_result,
  not has_function_privilege('authenticated','public.mr_submit_race_result(text,text,double precision,integer,integer,boolean,text,uuid[])','EXECUTE') as legacy_unverified_result_rpc_blocked;
