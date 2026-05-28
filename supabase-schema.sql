create table if not exists public.grupos (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  nome text not null,
  icone text not null default '',
  ordem int not null default 0,
  colapsado boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists public.produtos (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  grupo_id text not null references public.grupos(id) on delete cascade,
  nome text not null,
  estoque_ideal int not null default 0,
  estoque_atual int not null default 0,
  no_carrinho boolean not null default false,
  updated_at timestamptz not null default now()
);

create index if not exists idx_grupos_user on public.grupos(user_id);
create index if not exists idx_produtos_user on public.produtos(user_id);
create index if not exists idx_produtos_grupo on public.produtos(grupo_id);

alter table public.grupos enable row level security;
alter table public.produtos enable row level security;

drop policy if exists grupos_owner_all on public.grupos;
drop policy if exists produtos_owner_all on public.produtos;

create policy grupos_owner_all on public.grupos for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy produtos_owner_all on public.produtos for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
