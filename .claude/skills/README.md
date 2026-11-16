# Skills del kit

Claude Code carga automáticamente las skills de esta carpeta al abrir el repo (skills de proyecto).

| Skill | Versión | Licencia / origen | Cómo llega | Uso en el kit |
|-------|---------|-------------------|------------|---------------|
| `instalar` | — | propia del kit | en el repo | Instalación al escribir INSTALAR |
| `crear-web` | — | propia del kit | en el repo | Flujo «Crea la web de <cliente>» |
| `design-taste-frontend` | tasteskill v2 (commit `af8a897`) | MIT, [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | la **descarga el instalador** (`tools/setup.mjs`) | Dirección de arte del concepto y del mockup |
| `impeccable` | 4.8.0 | Apache 2.0, [pbakaus/impeccable](https://github.com/pbakaus/impeccable) (ver `LICENSE` y `NOTICE.md`) | en el repo | Pulido, crítica y auditoría del mockup |

**`design-taste-frontend`:**
- No se sube al repo (está en `.gitignore`). El instalador la descarga fijada al commit probado con el kit.
- Para actualizarla, cambia `TASTE.sha` en `tools/setup.mjs`, borra la carpeta y vuelve a ejecutar la instalación.

No edites las skills de terceros para meter reglas del kit: las reglas propias van en `CLAUDE.md`, `AGENTS.md` y `design/`.
