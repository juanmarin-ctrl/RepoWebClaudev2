# Stack WordPress TEDUCAS: academias con Elementor Pro, WooCommerce y Tutor LMS Pro

**Todos los clientes del kit son academias, y todas las webs llevan el mismo stack.** No hay webs «informativas» ni tiendas sin cursos.
Este conocimiento está probado en sitios reales de TEDUCAS. Léelo en la **fase 4 (payload)** y al dar las instrucciones de instalación.

## 1. Stack fijo (todas las webs, en este orden)

| # | Pieza | De dónde sale |
|---|---|---|
| 1 | Tema **Hello Elementor** | wordpress.org (gratis) |
| 2 | **Elementor** | wordpress.org (gratis) |
| 3 | **Elementor Pro** | ZIP de **Teducas** (licencia de la empresa) |
| 4 | **WooCommerce** | wordpress.org (gratis) |
| 5 | **Tutor LMS** | wordpress.org (gratis) |
| 6 | **Tutor LMS Pro** | ZIP de **Teducas** (licencia de la empresa) |
| 7 | **Tutor LMS Certificate Builder** | ZIP de **Teducas** (licencia de la empresa) |
| 8 | **Site Maestro** (`site-maestro.zip`) | lo genera el kit |
| 9 | Pasarela de pago: *WooCommerce Stripe Gateway* | wordpress.org (gratis); se conecta con la cuenta de la academia |

- **Licencias:** los plugins de pago son **licencias de Teducas**. La academia no compra nada; el diseñador los instala siempre, en todos los proyectos. Los ZIP no están en este repo, que es público: los da Teducas.
- **Recomendables:** GTranslate (varios idiomas) y SEOPress (SEO), gratuitos de wordpress.org. Menciónalos en la entrega solo si la academia los necesita.
- **Site Maestro, siempre al final:** se sube con los demás plugins ya activos, para que pueda configurarlos.

**Payload, siempre:**

```json
"requires": ["elementor-pro", "woocommerce", "tutor", "tutor-pro"]
```

Puedes usar widgets Pro de Elementor (Nav Menu, Formulario, Theme Builder) y `chrome_posts`.

## 2. Ajustes base (bloque `wordpress` del payload)

Valores estándar de TEDUCAS. Cámbialos solo si el brief dice otra cosa (otro país u otro idioma):

```json
"wordpress": { "language": "es_MX", "timezone": "America/New_York", "comments": false, "remove_sample_content": true }
```

Site Maestro ya hace el resto (no lo repitas en el payload):
- enlaces permanentes `/%postname%/`;
- portada y página del blog;
- nombre, lema, logo y favicon;
- desactivar los esquemas de color y tipografía por defecto de Elementor.

## 3. Tienda y cursos: Tutor LMS Pro cobrando con WooCommerce

Bloques que lleva **siempre** el payload:

```json
"woocommerce": { "currency": "USD", "country": "US:FL" },
"tutor": { "sell_with_woocommerce": true, "guest_checkout": false, "certificates": true,
           "certificate_title": "Obtén tu certificado al completar el curso",
           "certificate_text": "Al finalizar el curso recibirás un certificado digital verificable que puedes añadir a tu CV o LinkedIn.",
           "pro_addons": ["tutor-certificate", "tutor-email", "tutor-report", "course-attachments", "course-preview", "gradebook", "enrollments", "prerequisites", "assignments"] }
```

Estándar de TEDUCAS:
- moneda `USD`, tienda en `US:FL` (Miami) y zona horaria `America/New_York`;
- cuenta obligatoria para comprar (`guest_checkout: false`);
- pedidos de cursos completados automáticamente, con factura y redirección a los cursos (Site Maestro lo activa con `sell_with_woocommerce`);
- certificados y los addons Pro base activados.

Cambia la moneda o el país solo si el brief lo pide.

### Trampas conocidas (Site Maestro ya las evita; no las «corrijas»)
- **El motor de pago de Tutor se guarda como `wc`, no como `woocommerce`.** Con `woocommerce`, Tutor no lo reconoce y el editor de cursos solo ofrece cursos gratis: la opción de curso de pago no aparece.
- **Los interruptores de Tutor se guardan como `'on'`/`'off'`**, no como `1`/`0`. Con `1`, la opción funciona pero el panel la muestra apagada.
- **El producto de WooCommerce de cada curso lo crea Tutor** al ponerle precio al curso. Nunca se crea a mano.
- **Certificados:** el addon `tutor-certificate` (Tutor Pro) es requisito de *Tutor LMS Certificate Builder*; sin él, el constructor no arranca.
- **Páginas de Tutor** (panel del alumno, registro de alumno e instructor): las crea Tutor al activarse. No las incluyas en `pages` ni las dupliques. Para enlazarlas, usa sus rutas (`/dashboard/`, `/student-registration/`).
- **Contenido de cursos:** los cursos, lecciones y precios se crean en Tutor después de instalar la web. El payload diseña las páginas (landing de cursos, catálogo, etc.), no el contenido del LMS. Si un curso necesita su propia cabecera o pie, usa `chrome_posts`.

## 4. Elementor: nativo primero, HTML cuando no es viable

Orden de preferencia en los templates: **widget nativo (incluidos los Pro) > CSS de página (con clases en los ajustes del widget) > widget HTML**.
- **Nativo:** usa widgets nativos siempre que exista equivalente: heading, image, button, icon-list, icon-box, accordion, form, nav-menu, counter, divider… Así la academia edita textos e imágenes desde el panel.
- **HTML permitido:** se puede usar el widget HTML para lo que no es viable de forma nativa:
  - SVG ilustrativos o dibujados (diagramas, marcos, sellos);
  - comportamientos con JS propio (animaciones ligadas al scroll, marquesinas, contadores propios);
  - markup estructural que Elementor no puede expresar.

  No es un defecto: no propongas migrarlo.
- **Textos editables:** los textos que la academia querrá cambiar (titulares, párrafos, botones, precios) siempre en widgets nativos.
- **Detalle del JSON:** para claves de controles, contenedores flex y grid, colores globales y formularios, consulta la skill `wordpress-elementor` (`.claude/skills/wordpress-elementor/references/`). Sus partes sobre EMCP Tools no aplican al kit, y las reglas de este documento y de `anti-template.md` mandan sobre las suyas.

## 5. Entrega (instrucciones para el diseñador, siempre las mismas)

En el WordPress de la academia, en este orden:
1. **Apariencia → Temas:** instala y activa **Hello Elementor**.
2. **Plugins → Añadir nuevo:** instala y activa **Elementor**. Después, en **Subir plugin**, sube y activa **Elementor Pro** (el ZIP de Teducas).
3. **Plugins → Añadir nuevo:** instala y activa **WooCommerce** y luego **Tutor LMS**.
4. **Subir plugin:** sube y activa **Tutor LMS Pro** y **Tutor LMS Certificate Builder** (los ZIP de Teducas).
5. **Asistentes:** al activar WooCommerce y Tutor aparecen asistentes de configuración. Se pueden **saltar**: Site Maestro hace la configuración.
6. **Site Maestro:** **Subir plugin** → `site-maestro.zip` → Activar → menú **Site Maestro** → **Instalar sitio completo**. Revisar el registro: si falta un plugin, lo dice por su nombre; se instala y se vuelve a pulsar.
7. Cuando todo esté correcto, se puede **borrar Site Maestro**: la web se queda.
8. **Pagos:** instala *WooCommerce Stripe Gateway* y conéctalo con la cuenta de la academia en WooCommerce → Ajustes → Pagos.
9. **Cursos:** crea los cursos en Tutor LMS, con sus lecciones, y ponles precio. El producto de WooCommerce se crea solo: no lo hagas a mano.
