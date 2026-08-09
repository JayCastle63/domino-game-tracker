-- One-time setup for online (multiplayer) table play.
--
-- Like tournament_schema.sql, this is a new table that isn't part of the original
-- shared-sessions setup. Paste this whole file into the Supabase SQL editor for this
-- project and run it once.
--
-- No auth, same as the rest of this app: anyone with the session's code can read/update
-- the live game state for that session (RLS policy below is intentionally open).

create table if not exists public.session_live_game (
  session_code text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.session_live_game enable row level security;

drop policy if exists "session_live_game_open_access" on public.session_live_game;
create policy "session_live_game_open_access" on public.session_live_game
  for all
  to anon
  using (true)
  with check (true);

alter publication supabase_realtime add table public.session_live_game;
