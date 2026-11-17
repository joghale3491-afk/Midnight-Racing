-- Run in Supabase SQL Editor. Uses Supabase Auth identities and row-level security.
create table if not exists public.player_saves (
  user_id uuid primary key references auth.users(id) on delete cascade,
  save_data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.player_saves enable row level security;
create policy "Players read own save" on public.player_saves for select using (auth.uid() = user_id);
create policy "Players insert own save" on public.player_saves for insert with check (auth.uid() = user_id);
create policy "Players update own save" on public.player_saves for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
-- Realtime room broadcasts use Supabase Realtime channels. Keep channels private in production
-- and add authorization policies before enabling public matchmaking.
