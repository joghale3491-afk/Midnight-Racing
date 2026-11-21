-- Midnight Racing v37: secure invite-only private lobbies.
-- Run this AFTER the existing Midnight Racing v36 database setup.
-- This is additive: it does not remove player accounts, saves, or leaderboard rows.

begin;

create table if not exists public.mr_private_lobbies (
  room_code text primary key check (room_code ~ '^[A-HJ-NP-Z2-9]{8}$'),
  host_user_id uuid not null references auth.users(id) on delete cascade,
  status text not null default 'open' check (status in ('open','racing')),
  max_players integer not null default 6 check (max_players between 2 and 6),
  created_at timestamptz not null default now(),
  expires_at timestamptz not null default (now() + interval '3 hours')
);

create table if not exists public.mr_private_lobby_members (
  room_code text not null references public.mr_private_lobbies(room_code) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  username text not null default 'RACER',
  is_host boolean not null default false,
  is_ready boolean not null default false,
  joined_at timestamptz not null default now(),
  primary key (room_code, user_id)
);

create index if not exists mr_private_lobby_members_user_idx
  on public.mr_private_lobby_members(user_id);
create index if not exists mr_private_lobbies_expiry_idx
  on public.mr_private_lobbies(expires_at);

alter table public.mr_private_lobbies enable row level security;
alter table public.mr_private_lobby_members enable row level security;
revoke all on public.mr_private_lobbies from anon, authenticated;
revoke all on public.mr_private_lobby_members from anon, authenticated;
grant select on public.mr_private_lobby_members to authenticated;

drop policy if exists "mr_private_members_read_own_membership" on public.mr_private_lobby_members;
create policy "mr_private_members_read_own_membership"
  on public.mr_private_lobby_members for select to authenticated
  using (user_id = (select auth.uid()));

create or replace function public.mr_create_private_lobby(p_room_code text, p_username text)
returns jsonb
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_user uuid := auth.uid();
  v_code text := upper(regexp_replace(coalesce(p_room_code,''), '[^A-Z0-9]', '', 'g'));
  v_name text := left(coalesce(nullif(trim(p_username),''),'RACER'),18);
begin
  if v_user is null then raise exception 'Sign in before creating a private room.'; end if;
  if v_code !~ '^[A-HJ-NP-Z2-9]{8}$' then raise exception 'Invalid room code. Use 8 characters and avoid O, I, 0 and 1.'; end if;

  delete from public.mr_private_lobbies where expires_at < now();
  insert into public.mr_private_lobbies(room_code,host_user_id,status,max_players,expires_at)
  values(v_code,v_user,'open',6,now()+interval '3 hours');

  insert into public.mr_private_lobby_members(room_code,user_id,username,is_host,is_ready)
  values(v_code,v_user,v_name,true,false);

  return jsonb_build_object('room_code',v_code,'status','open','host_user_id',v_user,'max_players',6);
exception when unique_violation then
  raise exception 'That room code is already in use. Please create another room.';
end;
$$;

create or replace function public.mr_join_private_lobby(p_room_code text, p_username text)
returns jsonb
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_user uuid := auth.uid();
  v_code text := upper(regexp_replace(coalesce(p_room_code,''), '[^A-Z0-9]', '', 'g'));
  v_name text := left(coalesce(nullif(trim(p_username),''),'RACER'),18);
  v_lobby public.mr_private_lobbies%rowtype;
  v_count integer;
begin
  if v_user is null then raise exception 'Sign in before joining a private room.'; end if;
  if v_code !~ '^[A-HJ-NP-Z2-9]{8}$' then raise exception 'Invalid room code.'; end if;

  select * into v_lobby
  from public.mr_private_lobbies
  where room_code=v_code and expires_at > now()
  for update;
  if not found then raise exception 'Room not found or expired. Check the code and ask the host to create a new room.'; end if;
  if v_lobby.status <> 'open' then raise exception 'This room has already started and is no longer accepting drivers.'; end if;

  select count(*) into v_count from public.mr_private_lobby_members where room_code=v_code;
  if exists(select 1 from public.mr_private_lobby_members where room_code=v_code and user_id=v_user) then
    update public.mr_private_lobby_members set username=v_name where room_code=v_code and user_id=v_user;
    return jsonb_build_object('room_code',v_code,'status',v_lobby.status,'already_joined',true);
  end if;
  if v_count >= v_lobby.max_players then raise exception 'This private room is full (6/6).'; end if;

  insert into public.mr_private_lobby_members(room_code,user_id,username,is_host,is_ready)
  values(v_code,v_user,v_name,false,false);
  return jsonb_build_object('room_code',v_code,'status',v_lobby.status,'already_joined',false,'players',v_count+1);
end;
$$;

create or replace function public.mr_set_private_lobby_ready(p_room_code text, p_ready boolean)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare v_user uuid := auth.uid(); v_code text := upper(regexp_replace(coalesce(p_room_code,''), '[^A-Z0-9]', '', 'g'));
begin
  if v_user is null then raise exception 'Sign in first.'; end if;
  update public.mr_private_lobby_members m
  set is_ready=coalesce(p_ready,false)
  from public.mr_private_lobbies l
  where m.room_code=v_code and m.user_id=v_user and l.room_code=m.room_code and l.status='open';
  if not found then raise exception 'You are no longer a member of this open room.'; end if;
end;
$$;

create or replace function public.mr_start_private_lobby(p_room_code text)
returns jsonb
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_user uuid := auth.uid();
  v_code text := upper(regexp_replace(coalesce(p_room_code,''), '[^A-Z0-9]', '', 'g'));
  v_lobby public.mr_private_lobbies%rowtype;
  v_count integer;
  v_unready integer;
begin
  if v_user is null then raise exception 'Sign in first.'; end if;
  select * into v_lobby from public.mr_private_lobbies where room_code=v_code for update;
  if not found then raise exception 'This room no longer exists.'; end if;
  if v_lobby.host_user_id <> v_user then raise exception 'Only the room host can start the race.'; end if;
  if v_lobby.status <> 'open' then raise exception 'This room has already started.'; end if;
  select count(*), count(*) filter (where not is_ready)
    into v_count,v_unready
    from public.mr_private_lobby_members where room_code=v_code;
  if v_count < 2 then raise exception 'At least two drivers must join before starting.'; end if;
  if v_count > 6 then raise exception 'The room exceeds its six-driver limit.'; end if;
  if v_unready > 0 then raise exception 'Every driver must press I AM READY before the race starts.'; end if;
  update public.mr_private_lobbies set status='racing' where room_code=v_code;
  return jsonb_build_object('room_code',v_code,'status','racing','players',v_count);
end;
$$;

create or replace function public.mr_leave_private_lobby(p_room_code text)
returns jsonb
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_user uuid := auth.uid();
  v_code text := upper(regexp_replace(coalesce(p_room_code,''), '[^A-Z0-9]', '', 'g'));
  v_was_host boolean := false;
  v_next_host uuid;
  v_count integer;
begin
  if v_user is null then raise exception 'Sign in first.'; end if;
  delete from public.mr_private_lobby_members
   where room_code=v_code and user_id=v_user
   returning is_host into v_was_host;
  select count(*) into v_count from public.mr_private_lobby_members where room_code=v_code;
  if v_count=0 then
    delete from public.mr_private_lobbies where room_code=v_code;
    return jsonb_build_object('room_code',v_code,'closed',true);
  end if;
  if coalesce(v_was_host,false) then
    select user_id into v_next_host
      from public.mr_private_lobby_members
      where room_code=v_code
      order by joined_at,user_id
      limit 1;
    update public.mr_private_lobbies set host_user_id=v_next_host where room_code=v_code;
    update public.mr_private_lobby_members
       set is_host=(user_id=v_next_host), is_ready=false
       where room_code=v_code;
  end if;
  return jsonb_build_object('room_code',v_code,'closed',false,'new_host',v_next_host);
end;
$$;

revoke all on function public.mr_create_private_lobby(text,text) from public, anon;
revoke all on function public.mr_join_private_lobby(text,text) from public, anon;
revoke all on function public.mr_set_private_lobby_ready(text,boolean) from public, anon;
revoke all on function public.mr_start_private_lobby(text) from public, anon;
revoke all on function public.mr_leave_private_lobby(text) from public, anon;
grant execute on function public.mr_create_private_lobby(text,text) to authenticated;
grant execute on function public.mr_join_private_lobby(text,text) to authenticated;
grant execute on function public.mr_set_private_lobby_ready(text,boolean) to authenticated;
grant execute on function public.mr_start_private_lobby(text) to authenticated;
grant execute on function public.mr_leave_private_lobby(text) to authenticated;

-- Private Realtime channels: only users who have joined this room may read/send
-- its broadcasts and presence events. The game subscribes to private-race:<CODE>.
drop policy if exists "mr_private_race_members_read" on realtime.messages;
drop policy if exists "mr_private_race_members_send" on realtime.messages;
create policy "mr_private_race_members_read"
  on realtime.messages for select to authenticated
  using (
    (select realtime.topic()) like 'private-race:%'
    and exists (
      select 1 from public.mr_private_lobby_members m
      where m.room_code=split_part((select realtime.topic()),':',2)
        and m.user_id=(select auth.uid())
    )
  );
create policy "mr_private_race_members_send"
  on realtime.messages for insert to authenticated
  with check (
    (select realtime.topic()) like 'private-race:%'
    and exists (
      select 1 from public.mr_private_lobby_members m
      where m.room_code=split_part((select realtime.topic()),':',2)
        and m.user_id=(select auth.uid())
    )
  );

commit;

-- Verification: each should be true after the SQL completes.
select
  (not has_table_privilege('authenticated','public.mr_private_lobbies','SELECT')) as direct_lobby_table_read_is_denied,
  has_table_privilege('authenticated','public.mr_private_lobby_members','SELECT') as membership_policy_can_check,
  has_function_privilege('authenticated','public.mr_create_private_lobby(text,text)','EXECUTE') as can_create_private_room,
  has_function_privilege('authenticated','public.mr_join_private_lobby(text,text)','EXECUTE') as can_join_private_room,
  has_function_privilege('authenticated','public.mr_start_private_lobby(text)','EXECUTE') as can_start_private_room,
  has_function_privilege('authenticated','public.mr_leave_private_lobby(text)','EXECUTE') as can_leave_private_room;
