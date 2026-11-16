---
name: crear-web
description: Crea la web WordPress de una academia (siempre con tienda WooCommerce y cursos en Tutor LMS Pro, construida con Elementor Pro) a partir de lo que el diseñador copió en proyectos/<academia>/, en cualquier formato (Word, PDF, imágenes, logos, manual de marca, listado de cursos, ZIP). Ordena el material, ejecuta el pipeline del kit, enseña el concepto y el mockup para aprobar, lo prueba en WordPress local y entrega el ZIP con instrucciones sencillas. Usar cuando digan "crea la web de…", "ya copié los documentos de…", "haz la web de la academia…".
---

# Crear la web de una academia (sin tecnicismos)

**Todos los clientes son academias**, y todas las webs llevan el mismo stack:
- Elementor Pro;
- tienda con WooCommerce;
- plataforma de cursos con Tutor LMS Pro y certificados.

Los plugins de pago son licencias de Teducas: la academia no compra nada. Detalle en `design/wordpress-stack.md`.

El diseñador **solo** ha copiado lo que le mandó la academia en `proyectos/<academia>/`, tal como le llegó, y te ha escrito «Crea la web de <academia>».
- No le pidas renombrar archivos, copiar plantillas, rellenar Markdown ni pegar prompts.
- No le hables de payload, schema, slug ni JSON.
- Las reglas de diseño de `CLAUDE.md`, `AGENTS.md` y `design/anti-template.md` mandan siempre.

## 1. Encontrar el material
- Busca en `proyectos/` la carpeta que corresponde al nombre que dijo, sin importar mayúsculas, acentos ni espacios.
- **No existe la carpeta:** créala con un nombre en minúsculas y con guiones, por ejemplo `academia-norte`. Dile: «Copia aquí todo lo de la academia y avísame».
- **El material está en otro sitio** (Descargas, Escritorio, un ZIP): cópialo tú a esa carpeta.
- **El nombre de la carpeta tiene espacios o mayúsculas:** renómbrala tú al formato del kit y avísale en una línea.

## 2. Ordenar (lo haces tú)
1. Crea las subcarpetas que falten, con la misma estructura que `proyectos/_plantilla-proyecto/`: `brief/`, `brief/imagenes/`, `mockup/` y `payload/`.
2. Mueve los documentos sueltos a `brief/`, y las imágenes y logos a `brief/imagenes/`.
3. Descomprime los ZIP y ponles nombres legibles a las imágenes (`logo.png`, `hero-01.jpg`…).
4. Lo que no puedas leer (`.indd`, `.ai` sin PDF, `.heic`…) se lo pides en PDF, PNG o SVG.

## 3. Pipeline del kit
Sigue `prompts/PIPELINE.md` (fases 1 a 4) con las skills `design-taste-frontend`, `impeccable` y `wordpress-elementor`.

Después de la fase 1, cuéntale qué falta en una lista corta en lenguaje normal («falta el teléfono de contacto», «no hay fotos del equipo», «no tengo el precio de los cursos»). Lo que falte se marca como `TODO-CLIENTE` y se sigue adelante.

## 4. Enseñar y aprobar (antes del payload)
1. **Concepto:** explica la idea de la web en 3 o 4 frases (sensación, estructura de la home, tipografía y colores), sin jerga. Incluye cómo se presentan los cursos: catálogo, landing de curso, etc.
2. **Mockup:** arranca el servidor `mockups` y ábrelo en la vista previa (`http://localhost:4173/<slug>/mockup/`). Revisa escritorio y móvil.
3. **Pregunta:** «¿Te gusta o cambio algo?». Acepta cambios dichos con sus palabras («más aire en la portada», «el azul más oscuro», «quita esa sección») y vuelve a enseñarlo.

## 5. WordPress de prueba
- Genera el payload (fase 4) siguiendo `design/wordpress-stack.md`. Siempre lleva `requires`, `wordpress`, `woocommerce` y `tutor` con los valores estándar. No le preguntes por la tienda ni por los cursos: van siempre.
- Arranca `wp-playground` y abre `http://localhost:9400` en la vista previa.
  - Es un WordPress que solo existe en su equipo, con usuario `admin` y contraseña `password`.
  - Instala WooCommerce y Tutor LMS gratuitos. Elementor Pro y Tutor Pro no están en la prueba, porque son de pago: díselo si algo Pro no se ve igual que en la maqueta.
- Pulsa tú **Site Maestro → Instalar sitio completo** y enséñale el resultado.

## 6. Entregar
1. Empaqueta con `node tools/package.mjs <slug>`. El resultado es `proyectos/<slug>/site-maestro.zip`.
2. Dale las instrucciones de la sección 5 de `design/wordpress-stack.md`, en lenguaje sencillo y siempre en el mismo orden:
   1. Hello Elementor.
   2. Elementor y Elementor Pro (ZIP de Teducas).
   3. WooCommerce y Tutor LMS.
   4. Tutor LMS Pro y Certificate Builder (ZIP de Teducas).
   5. Los asistentes se pueden saltar.
   6. `site-maestro.zip` → **Instalar sitio completo**: revisar el registro y, al final, borrar Site Maestro.
   7. Conectar Stripe con la cuenta de la academia.
   8. Crear los cursos en Tutor y ponerles precio: el producto de la tienda se crea solo.
3. Recuérdale que los textos y las imágenes se editan después en Elementor y en Medios, como en cualquier web.
