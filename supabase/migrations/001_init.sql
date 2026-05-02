-- Run this in the Supabase SQL Editor (Dashboard → SQL Editor → New Query)

-- ── profiles ────────────────────────────────────────────────────────────────
create table if not exists public.profiles (
  id      uuid references auth.users (id) on delete cascade primary key,
  email   text not null,
  name    text,
  created_at timestamptz default now()
);

alter table public.profiles enable row level security;

create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);

-- Auto-create a profile row whenever a new user signs up
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, email, name)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'name'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ── watchlist_items ─────────────────────────────────────────────────────────
create table if not exists public.watchlist_items (
  id         uuid default gen_random_uuid() primary key,
  user_id    uuid references auth.users (id) on delete cascade not null,
  symbol     text not null,
  created_at timestamptz default now(),
  unique (user_id, symbol)
);

alter table public.watchlist_items enable row level security;

create policy "Users can manage own watchlist"
  on public.watchlist_items
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
