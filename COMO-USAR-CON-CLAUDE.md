# Cómo crear la web de una academia

Todos los clientes son academias, y todas las webs llevan el mismo stack:
- **Elementor Pro**;
- tienda con **WooCommerce**;
- cursos con **Tutor LMS Pro** y certificados.

Los plugins Pro son licencias de Teducas. Detalle en `design/wordpress-stack.md`.

## Con Claude Code (lo normal)

1. Dentro de `proyectos/`, crea una carpeta con el **nombre de la academia**.
2. Copia ahí **todo lo que te mandó la academia**, en cualquier formato: información de la empresa, acerca, cursos, manual de marca, logos y fotos. Puede ser Word, PDF, imágenes o un ZIP. No hace falta renombrar ni ordenar nada.
3. Escribe en Claude Code: **Crea la web de *nombre de la academia***.

Claude sigue `.claude/skills/crear-web/SKILL.md`:

| Paso | Qué ves tú |
|------|------------|
| Ordena el material | Una lista corta de lo que falta, como el teléfono o las fotos del equipo. |
| Concepto | La idea de la web en 3 o 4 frases. |
| Maqueta | La web en la vista previa, en escritorio y en móvil. Pide cambios con tus palabras. |
| WordPress de prueba | La web instalada en un WordPress dentro de tu equipo. |
| Entrega | `proyectos/<cliente>/site-maestro.zip` y los pasos para instalarlo. |

## Instalar en el WordPress de la academia

1. **Apariencia → Temas:** instala y activa **Hello Elementor**.
2. **Plugins:** Elementor y **Elementor Pro** (de Teducas), luego **WooCommerce**, **Tutor LMS**, **Tutor LMS Pro** y **Certificate Builder** (de Teducas). Los asistentes se pueden saltar.
3. **Plugins → Añadir nuevo → Subir plugin:** sube `site-maestro.zip` y actívalo.
4. Menú **Site Maestro → Instalar sitio completo**.
5. Cuando diga que todo está correcto, puedes borrar el plugin Site Maestro: la web se queda.
6. **Pagos:** instala *WooCommerce Stripe Gateway* y conéctalo con la cuenta de la academia.
7. **Cursos:** créalos en Tutor LMS y ponles precio; el producto de la tienda se crea solo.

---

## Con otras IA (Cursor, Copilot…)

Abre la raíz del kit y pega:

```
Lee CLAUDE.md y AGENTS.md.
Cliente: proyectos/nombre-del-cliente/ (el material está suelto en esa carpeta: ordénalo en brief/).
Ejecuta prompts/PIPELINE.md completo. Obligatorio design/anti-template.md.
Al final deja el payload en engine/site-maestro/payload/ y una copia en proyectos/nombre-del-cliente/payload/.
```

## Qué garantiza (y qué no)

| Garantiza el kit | Lo inventa la IA cada vez |
|------------------|---------------------------|
| Material del cliente ordenado | Layout, tipografía y atmósfera |
| Motor de instalación con un clic | Plantillas de Elementor |
| La web sigue funcionando después de borrar el plugin | CSS y JS de la marca |
| Reglas para que dos webs no se parezcan | Experiencia según el rubro |

Si dos webs se parecen, el fallo está en saltarse `design/anti-template.md`, no en el motor.
