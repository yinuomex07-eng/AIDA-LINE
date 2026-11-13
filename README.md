# AIDA LINE

Tienda en línea de ropa de paca seleccionada en San Cristóbal de las Casas, Chiapas: básicas, de primera y premium. Los pedidos llegan por WhatsApp.

Es un sitio estático: todo está en `index.html`, sin instalar nada.

## Cómo editar

Dentro de `index.html`, en el bloque `<script>`:

- `STORE`: número de WhatsApp (formato `52` + 10 dígitos, sin espacios) y costo de entrega a domicilio.
- `TIERS`: nombres y descripciones de las calidades.
- `PRODUCTS`: el inventario. Cada prenda lleva nombre, marca, tipo, calidad, departamento, talla, precio y estado.
  Para usar una foto, súbela a la carpeta `fotos/` y agrega `foto: "fotos/nombre.jpg"` a la prenda.

## Publicar con GitHub Pages

Settings → Pages → Source: *Deploy from a branch* → Branch: `main`, carpeta `/ (root)`.
