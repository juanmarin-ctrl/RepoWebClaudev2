# TEDUCAS Site Kit: una web distinta para cada academia

Le das a Claude lo que te mandó la academia: documentos, cursos, manual de marca, logos y fotos, en cualquier formato. Claude diseña una web **única** para esa academia y te la entrega lista para instalar en WordPress **con un clic**.

No es una plantilla con colores cambiados: cada web tiene su propia estructura, tipografía y ambiente. Y todas llevan el stack de Teducas:
- **Elementor Pro**;
- tienda con **WooCommerce**;
- plataforma de cursos con **Tutor LMS Pro** y certificados.

Todo queda configurado para cobrar.

---

## Lo que necesitas

- Un computador con **Windows o Mac**.
- **Claude Code**, la app de escritorio de Claude (pestaña *Code*).
- **En Mac, Google Chrome.** En Windows ya viene Edge, que también sirve. Claude lo usa para revisar las maquetas.
- Conexión a internet.

Nada más: lo demás (Node.js y WordPress de prueba) lo instala el kit.

Para el WordPress de cada academia usarás además los **plugins de pago de Teducas**: Elementor Pro, Tutor LMS Pro y Tutor LMS Certificate Builder. Son licencias de la empresa: la academia no compra nada y se instalan siempre. No están en este repositorio, que es público: te los da Teducas.

## Instalación (una vez)

1. **Descarga el kit:** en esta página, pulsa el botón verde **Code** y luego **Download ZIP**. No necesitas cuenta de GitHub.
2. **Descomprímelo:**
   - **Windows:** clic derecho en el ZIP y **Extraer todo**.
   - **Mac:** doble clic en el ZIP.

   Después mueve la carpeta donde quieras, por ejemplo a Documentos.
3. **Abre Claude Code en esa carpeta:** la que tiene dentro el archivo `README.md` y la carpeta `engine`. Si ves una carpeta dentro de otra con el mismo nombre, entra en la de dentro.
4. Escribe:

   > **INSTALAR**

Claude revisa tu equipo, instala lo que falte y te dice cuándo está todo listo. La primera vez tarda unos minutos.

## Crear la web de una academia

1. Dentro de la carpeta `proyectos`, crea una carpeta con el **nombre de la academia**.
2. Copia ahí **todo lo que te mandó**, tal como te llegó: Word, PDF, manual de marca, logos, fotos, el listado de cursos o un ZIP. No hace falta renombrar ni ordenar nada.
3. Escribe en Claude Code:

   > Crea la web de *nombre de la academia*

Claude:
- ordena el material y te dice qué falta (por ejemplo, el teléfono o fotos del equipo);
- te explica la idea de la web y te enseña una **maqueta** en la vista previa: pide cambios con tus palabras;
- deja preparadas la tienda y la plataforma de cursos sin que lo pidas: en dólares (o la moneda de la academia), con cuenta obligatoria para comprar, pedidos automáticos y certificados;
- la prueba en un **WordPress de prueba** dentro de tu equipo;
- te entrega el archivo `site-maestro.zip` y los pasos para instalarlo.

## Instalar la web en el WordPress de la academia

Siempre en este orden:

1. **Apariencia → Temas:** instala y activa **Hello Elementor**.
2. **Plugins → Añadir nuevo:** instala y activa **Elementor**. Después, en **Subir plugin**, sube y activa **Elementor Pro** (el de Teducas).
3. **Plugins → Añadir nuevo:** instala y activa **WooCommerce** y luego **Tutor LMS**.
4. **Subir plugin:** sube y activa **Tutor LMS Pro** y **Tutor LMS Certificate Builder** (los de Teducas).
5. Los asistentes de configuración que aparecen se pueden **saltar**: Site Maestro configura todo.
6. **Subir plugin:** sube `site-maestro.zip`, actívalo y pulsa **Site Maestro → Instalar sitio completo**. Si falta algún plugin, el registro te dice cuál.
7. Cuando diga que todo está correcto, puedes borrar el plugin Site Maestro: la web se queda.
8. **Pagos:** instala *WooCommerce Stripe Gateway* y conéctalo con la cuenta de la academia (WooCommerce → Ajustes → Pagos).
9. **Cursos:** crea los cursos en Tutor LMS y ponles precio. El producto de la tienda aparece solo: no lo crees a mano.

Los textos y las imágenes se editan después en Elementor, como en cualquier web.

## Si algo no sale

Pregúntale a Claude con tus palabras, por ejemplo *«no veo la maqueta»* o *«el ZIP no se sube»*. Conoce todo el proceso.

Para **actualizar el kit**, descarga el ZIP otra vez y copia tu carpeta `proyectos` a la versión nueva.

---

<details><summary>Para el equipo técnico</summary>

### Estructura

```
├── CLAUDE.md / AGENTS.md     ← instrucciones para la IA
├── .claude/skills/           ← instalar, crear-web y las skills de diseño (impeccable, design-taste-frontend)
├── .claude/launch.json       ← vistas previas: mockups (4173) y WordPress Playground (9400)
├── setup.ps1 / setup.sh      ← instalador (Windows / Mac); lo ejecuta Claude al escribir INSTALAR
├── design/                   ← anti-template, schema y rubros
├── prompts/PIPELINE.md       ← fases de generación
├── engine/site-maestro/      ← plugin WordPress genérico (instalación con un clic)
├── tools/                    ← setup, servidor de mockups, Playground, empaquetado
└── proyectos/                ← una carpeta por academia (no se sube a git)
```

### Principio

```
MOTOR (igual siempre)     engine/site-maestro/
PAYLOAD (único/cliente)   generado por la IA desde el brief
```

### Comandos

```bash
node tools/setup.mjs --warm        # comprobación del kit
node tools/serve.mjs               # mockups → http://localhost:4173/<slug>/mockup/
node tools/playground.mjs          # WordPress → http://localhost:9400 (admin/password, solo local)
node tools/package.mjs <slug>      # ZIP instalable → proyectos/<slug>/site-maestro.zip
```

Con git: `git clone`, y para actualizar, `git pull`. `proyectos/<cliente>/` está en `.gitignore`. Si tu equipo quiere versionar clientes, hazlo en un fork.

Más detalle: [INSTALAR.md](INSTALAR.md) · [COMO-USAR-CON-CLAUDE.md](COMO-USAR-CON-CLAUDE.md) · [prompts/PIPELINE.md](prompts/PIPELINE.md)
</details>
