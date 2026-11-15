# AIDA LINE

Tienda en línea de ropa de paca seleccionada en San Cristóbal de las Casas, Chiapas: básicas, de primera y premium. Los pedidos y apartados llegan por WhatsApp.

## Páginas

- `index.html`: la tienda. Muestra solo las prendas que subes desde el panel.
- `admin.html`: el panel de administración (entra con tu correo y contraseña de Supabase).

## Base de datos

Las prendas y las fotos viven en Supabase (proyecto `iahjtvxunrdzhjnpozsx`).
El esquema está en `supabase/esquema.sql`. La clave que aparece en el código es la publicable: es pública por diseño
y la seguridad la ponen las reglas de la base de datos (solo los correos de la tabla `admins` pueden editar).

## Ajustes de la tienda

En `index.html`, dentro del bloque `<script>`, el objeto `STORE` tiene el número de WhatsApp, el costo de entrega
a domicilio y las reglas del apartado (porcentaje, días y política).

## Publicar con GitHub Pages

Settings → Pages → Source: *Deploy from a branch* → Branch: `main`, carpeta `/ (root)`.
