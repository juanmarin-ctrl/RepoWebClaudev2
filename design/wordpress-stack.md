# Stack WordPress TEDUCAS: Elementor, WooCommerce y Tutor LMS

Conocimiento probado en sitios reales de TEDUCAS. Léelo en la **fase 4 (payload)** y al dar las instrucciones de instalación.

## 1. Qué stack usa cada web

| Tipo de web | Plugins (en este orden) | `requires` del payload |
|---|---|---|
| Informativa (empresa, servicios, portafolio) | Hello Elementor → Elementor (+ Pro si hay licencia) | `[]` o `["elementor-pro"]` |
| Academia que **vende cursos** | Hello Elementor → Elementor (+ Pro) → **WooCommerce** → **Tutor LMS** (+ Tutor Pro y Certificate Builder si hay licencia) → pasarela de pago (Stripe: *WooCommerce Stripe Gateway*) | `["woocommerce", "tutor"]` (+ `"tutor-pro"` si se usan certificados u otros addons Pro) |
| Tienda (productos, sin cursos) | Hello Elementor → Elementor (+ Pro) → WooCommerce → pasarela | `["woocommerce"]` |

Plugins gratuitos de wordpress.org que también usa TEDUCAS y se pueden recomendar:
- **GTranslate:** web en varios idiomas.
- **SEOPress:** SEO.

No los instala Site Maestro: se mencionan en las instrucciones de entrega si el cliente los necesita.

**Site Maestro se sube siempre al final**, con los demás plugins ya activos: así puede configurarlos.

## 2. Ajustes base (bloque `wordpress` del payload)

Valores estándar de TEDUCAS. Cámbialos solo si el brief dice otra cosa (otro país u otro idioma):

```json
"wordpress": { "language": "es_MX", "timezone": "America/New_York", "comments": false, "remove_sample_content": true }
```

Site Maestro ya hace el resto (no lo repitas en el payload):
- enlaces permanentes `/%postname%/`;
- portada y página del blog;
- nombre, lema, logo y favicon;
- desactivar los esquemas de color y tipografía por defecto de Elementor, para que no pisen la marca.

## 3. Academias: Tutor LMS cobrando con WooCommerce

Para webs con cursos de pago, el payload lleva:

```json
"requires": ["woocommerce", "tutor"],
"woocommerce": { "currency": "USD", "country": "US:FL" },
"tutor": { "sell_with_woocommerce": true, "guest_checkout": false, "certificates": true,
           "certificate_title": "Obtén tu certificado al completar el curso",
           "certificate_text": "Al finalizar el curso recibirás un certificado digital verificable que puedes añadir a tu CV o LinkedIn." }
```

Estándar de TEDUCAS:
- moneda `USD`, tienda en `US:FL` (Miami) y zona horaria `America/New_York`;
- cuenta obligatoria para comprar (`guest_checkout: false`);
- pedidos de cursos completados automáticamente, con factura y redirección a los cursos (Site Maestro lo activa con `sell_with_woocommerce`).

### Trampas conocidas (Site Maestro ya las evita; no las «corrijas»)
- **El motor de pago de Tutor se guarda como `wc`, no como `woocommerce`.** Con `woocommerce`, Tutor no lo reconoce y el editor de cursos solo ofrece cursos gratis: la opción de curso de pago no aparece.
- **Los interruptores de Tutor se guardan como `'on'`/`'off'`**, no como `1`/`0`. Con `1`, la opción funciona pero el panel la muestra apagada.
- **El producto de WooCommerce de cada curso lo crea Tutor** al ponerle precio al curso. Nunca se crea a mano.
- **Certificados:** el addon `tutor-certificate` (Tutor Pro) es requisito de *Tutor LMS Certificate Builder*; sin él, el constructor no arranca. Con `certificates: true`, Site Maestro lo activa.
- **Páginas de Tutor** (panel del alumno, registro de alumno e instructor): las crea Tutor al activarse. No las incluyas en `pages` ni las dupliques. Si la web necesita enlazarlas, usa sus rutas (`/dashboard/`, `/student-registration/`), o cópialas del panel de Tutor tras instalar.
- **Contenido de cursos:** los cursos, lecciones y precios se crean en Tutor después de instalar la web. El payload diseña las páginas (landing de cursos, catálogo, etc.), no el contenido del LMS. Si un curso necesita su propia cabecera o pie, usa `chrome_posts` (solo con Elementor Pro).

## 4. Elementor: nativo primero, HTML cuando no es viable

Orden de preferencia en los templates: **widget nativo > CSS de página (con clases en los ajustes del widget) > widget HTML**.
- **Nativo:** usa widgets nativos siempre que exista equivalente: heading, image, button, icon-list, icon-box, accordion, form, counter, divider… Así el cliente edita textos e imágenes desde el panel.
- **HTML permitido:** se puede usar el widget HTML para lo que no es viable de forma nativa:
  - SVG ilustrativos o dibujados (diagramas, marcos, sellos);
  - comportamientos con JS propio (animaciones ligadas al scroll, marquesinas, contadores propios);
  - markup estructural que Elementor no puede expresar.

  No es un defecto: no propongas migrarlo.
- **Textos editables:** los textos que el cliente querrá cambiar (titulares, párrafos, botones, precios) siempre en widgets nativos.
- **Detalle del JSON:** para claves de controles, contenedores flex y grid, colores globales y formularios, consulta la skill `wordpress-elementor` (`.claude/skills/wordpress-elementor/references/`). Sus partes sobre EMCP Tools (edición en vivo por MCP) no aplican al kit, y las reglas de este documento y de `anti-template.md` mandan sobre las suyas.

## 5. Entrega a una academia (instrucciones para el diseñador)

En el WordPress del cliente, en este orden:
1. **Tema:** Hello Elementor.
2. **Plugins:** Elementor (y Elementor Pro si hay licencia), luego WooCommerce, luego Tutor LMS (y Tutor Pro y Certificate Builder si hay licencia).
3. **Asistentes:** al activar WooCommerce y Tutor aparecen asistentes de configuración. Se pueden **saltar**: Site Maestro aplica la configuración.
4. **Site Maestro:** subir `site-maestro.zip`, activarlo y pulsar **Instalar sitio completo**. Revisar el registro: si falta un plugin, lo dice.
5. **Pagos:** instalar la pasarela (Stripe) y conectarla en WooCommerce → Ajustes → Pagos, con la cuenta del cliente.
6. **Cursos:** crear los cursos en Tutor LMS y ponerles precio. El producto de WooCommerce se crea solo.
