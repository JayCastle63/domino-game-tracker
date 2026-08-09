-- One-time setup for the Tournament Bracket feature.
--
-- This app's other shared-session tables were created for this project already. This
-- table is new (added for tournament brackets) and needs to be created once by whoever
-- owns the Supabase project, the same way the original shared-sessions tables were set
-- up. Paste this whole file into the Supabase SQL editor for this project and run it.
--
-- Like the rest of this app, there's no auth: anyone with a tournament's code can view
-- and update it (RLS policy below is intentionally open, matching sessions/session_*).

create table if not exists public.tournaments (
  code text primary key,
  host_id text,
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.tournaments enable row level security;

drop policy if exists "tournaments_open_access" on public.tournaments;
create policy "tournaments_open_access" on public.tournaments
  for all
  to anon
  using (true)
  with check (true);

alter publication supabase_realtime add table public.tournaments;
