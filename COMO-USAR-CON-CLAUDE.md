# Cómo crear la web de un cliente

## Con Claude Code (lo normal)

1. Dentro de `proyectos/`, crea una carpeta con el **nombre del cliente**.
2. Copia ahí **todo lo que te mandó el cliente**, en cualquier formato: información de la empresa, acerca, oferta o servicios, manual de marca, logos y fotos. Puede ser Word, PDF, imágenes o un ZIP. No hace falta renombrar ni ordenar nada.
3. Escribe en Claude Code: **Crea la web de *nombre del cliente***.

Claude sigue `.claude/skills/crear-web/SKILL.md`:

| Paso | Qué ves tú |
|------|------------|
| Ordena el material | Una lista corta de lo que falta, como el teléfono o las fotos del equipo. |
| Concepto | La idea de la web en 3 o 4 frases. |
| Maqueta | La web en la vista previa, en escritorio y en móvil. Pide cambios con tus palabras. |
| WordPress de prueba | La web instalada en un WordPress dentro de tu equipo. |
| Entrega | `proyectos/<cliente>/site-maestro.zip` y los pasos para instalarlo. |

## Instalar en el WordPress del cliente

1. **Apariencia → Temas:** instala y activa **Hello Elementor**.
2. **Plugins → Añadir nuevo:** instala y activa **Elementor** (Pro, si hay licencia).
3. **Plugins → Añadir nuevo → Subir plugin:** sube `site-maestro.zip` y actívalo.
4. Menú **Site Maestro → Instalar sitio completo**.
5. Cuando diga que todo está correcto, puedes borrar el plugin Site Maestro: la web se queda.

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
