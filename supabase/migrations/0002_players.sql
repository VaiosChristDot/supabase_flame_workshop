-- Banana kart: one row per racer with their lifetime stats.
-- Positions, laps in progress, and the bananas lying on the track are live
-- state on Realtime (Broadcast and Presence), so they have no tables.
create table public.players (
  id uuid primary key references auth.users (id) on delete cascade,
  name text not null,
  bananas_owned integer not null default 0 check (bananas_owned >= 0),
  bananas_collected integer not null default 0 check (bananas_collected >= 0),
  laps_finished integer not null default 0 check (laps_finished >= 0),
  times_slipped integer not null default 0 check (times_slipped >= 0),
  points integer generated always as (bananas_collected + laps_finished * 10) stored,
  updated_at timestamptz not null default now()
);

comment on table public.players is
  'One row per racer with their banana and lap stats';
comment on column public.players.bananas_owned is
  'Bananas held right now, ready to throw behind the kart';
comment on column public.players.bananas_collected is
  'Every banana ever picked up, thrown or not';

create index players_points_idx on public.players (points desc);

alter table public.players enable row level security;

create policy "Players are readable by everyone"
  on public.players for select
  using (true);

create policy "Players can insert their own row"
  on public.players for insert
  with check (auth.uid() = id);

create policy "Players can update their own row"
  on public.players for update
  using (auth.uid() = id)
  with check (auth.uid() = id);
