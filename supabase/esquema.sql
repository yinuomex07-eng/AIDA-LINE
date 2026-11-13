-- AIDA LINE: base de datos de la tienda
-- Pega todo esto en Supabase → SQL Editor → New query, cambia el correo de la línea marcada y toca "Run".

-- 1) Administradoras: solo estos correos pueden usar el panel
create table if not exists public.admins (email text primary key);
alter table public.admins enable row level security;
insert into public.admins (email) values ('TU_CORREO@ejemplo.com')   -- ← CAMBIA POR EL CORREO CON EL QUE ENTRARÁS AL PANEL
on conflict do nothing;

create or replace function public.es_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.admins where email = (auth.jwt() ->> 'email'));
$$;

-- 2) Prendas
create table if not exists public.productos (
  id            bigint generated always as identity primary key,
  creado        timestamptz not null default now(),
  nombre        text not null,
  marca         text not null default 'Sin marca',
  tipo          text not null,
  calidad       text not null check (calidad in ('basica','primera','premium')),
  departamento  text not null check (departamento in ('mujer','hombre','ninos','accesorios')),
  talla         text not null default '',
  precio        integer not null check (precio >= 0),
  condicion     text not null default 'Muy bueno',
  descripcion   text not null default '',
  fotos         text[] not null default '{}',
  foto_real     smallint,
  nuevo         boolean not null default true,
  estado        text not null default 'disponible' check (estado in ('disponible','apartada','vendida','oculta'))
);
alter table public.productos enable row level security;
drop policy if exists "Todos ven prendas a la venta" on public.productos;
create policy "Todos ven prendas a la venta" on public.productos
  for select using (estado in ('disponible','apartada'));
drop policy if exists "Admin administra prendas" on public.productos;
create policy "Admin administra prendas" on public.productos
  for all to authenticated using (public.es_admin()) with check (public.es_admin());

-- 3) Apartados (50% de anticipo, 7 días)
create table if not exists public.apartados (
  id           bigint generated always as identity primary key,
  creado       timestamptz not null default now(),
  producto_id  bigint not null references public.productos(id) on delete cascade,
  cliente      text not null,
  telefono     text not null,
  total        integer not null,
  anticipo     integer not null,
  inicio       date not null default current_date,
  vence        date not null default (current_date + 7),
  estado       text not null default 'activo' check (estado in ('activo','liquidado','vencido','cancelado')),
  notas        text not null default ''
);
alter table public.apartados enable row level security;
drop policy if exists "Admin administra apartados" on public.apartados;
create policy "Admin administra apartados" on public.apartados
  for all to authenticated using (public.es_admin()) with check (public.es_admin());

-- 4) Fotos: cualquiera las ve, solo la admin las sube o borra
insert into storage.buckets (id, name, public) values ('fotos', 'fotos', true)
on conflict (id) do nothing;
drop policy if exists "Admin sube fotos" on storage.objects;
create policy "Admin sube fotos" on storage.objects
  for insert to authenticated with check (bucket_id = 'fotos' and public.es_admin());
drop policy if exists "Admin cambia fotos" on storage.objects;
create policy "Admin cambia fotos" on storage.objects
  for update to authenticated using (bucket_id = 'fotos' and public.es_admin());
drop policy if exists "Admin borra fotos" on storage.objects;
create policy "Admin borra fotos" on storage.objects
  for delete to authenticated using (bucket_id = 'fotos' and public.es_admin());
