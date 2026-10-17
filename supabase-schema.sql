-- Execute no SQL Editor do projeto Supabase.
-- Um único registro JSON mantém a estrutura de dados do dashboard existente.
create table if not exists public.panel_state (
  id text primary key check (id = 'main'),
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.panel_state enable row level security;

-- Somente usuários autenticados podem ler ou alterar o painel.
drop policy if exists "panel_state_authenticated_select" on public.panel_state;
create policy "panel_state_authenticated_select"
  on public.panel_state for select to authenticated using (true);

drop policy if exists "panel_state_authenticated_insert" on public.panel_state;
create policy "panel_state_authenticated_insert"
  on public.panel_state for insert to authenticated with check (id = 'main');

drop policy if exists "panel_state_authenticated_update" on public.panel_state;
create policy "panel_state_authenticated_update"
  on public.panel_state for update to authenticated using (true) with check (id = 'main');

-- Não crie políticas para anon. Desative o cadastro público em Authentication > Sign In / Providers
-- e crie manualmente as contas autorizadas em Authentication > Users.
