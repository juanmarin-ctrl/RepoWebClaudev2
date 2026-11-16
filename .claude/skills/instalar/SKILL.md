---
name: instalar
description: Instala el Site Kit TEDUCAS en este equipo (Windows o Mac) de principio a fin: Node.js, comprobación del kit, skills de diseño y vistas previas. Usar cuando el usuario escriba "INSTALAR", "instálalo", "instala todo", "configura el kit" o cuando `node tools/setup.mjs` falle.
---

# INSTALAR: dejar el Site Kit listo en este equipo

El usuario solo ha escrito «INSTALAR». Hazlo todo tú, sin pedirle que ejecute comandos. Háblale en español y sin tecnicismos: es diseñador, no programador.

## 1. Comprobar que estás en la carpeta correcta
Tienen que existir `CLAUDE.md`, `engine/site-maestro/site-maestro.php` y `.claude/skills/`.

Si no existen, probablemente abrió la carpeta de fuera: al extraer el ZIP queda una carpeta dentro de otra con el mismo nombre. Busca la de dentro y dile que abra Claude Code en esa.

## 2. Instalar
Dile en una línea que empieza y que la primera vez tarda unos minutos.

| Windows | Mac |
|---|---|
| `powershell -ExecutionPolicy Bypass -File setup.ps1` | `bash setup.sh` |

- Instala Node.js si falta: en Windows con winget; en Mac con Homebrew.
- Comprueba el kit y descarga WordPress Playground, que tarda de 1 a 3 minutos.
- Puede tardar varios minutos. Ejecútalo en segundo plano (o con el tiempo de espera máximo) y no lo lances dos veces.

### Si falta Node.js y no se puede instalar solo
Pasa en Mac sin Homebrew o en Windows sin winget. Pídele que lo instale él:
1. Que abra **nodejs.org**, descargue la versión **LTS** y la instale con las opciones por defecto. En Mac le pedirá su contraseña.
2. Que cierre y vuelva a abrir Claude Code en la carpeta del kit.
3. Que escriba **INSTALAR** otra vez.

## 3. Lee el resultado
- **`INSTALAR_OK`:** todo bien.
- **`INSTALAR_FALLO …`:** explica qué falta con la solución que da el mensaje.
- **`INSTALAR_INCOMPLETO`:** explica cada línea con ✘. Las líneas con ⚠ no bloquean.

## 4. Comprobar las skills de diseño
`design-taste-frontend` e `impeccable` tienen que aparecer entre tus skills. Si no aparecen, la sesión se abrió en otra carpeta. Pídele que cierre y vuelva a abrir Claude Code en la carpeta del kit.

## 5. Probar la vista previa
Arranca el servidor `mockups` de `.claude/launch.json`, comprueba que `http://localhost:4173` responde y detenlo.

WordPress local (`wp-playground`) no se prueba ahora: se usa al crear la primera web.

## 6. Cierre
Responde con un resumen corto, sin tablas técnicas:
- Qué quedó instalado y si falta algo.
- Cómo empezar: «Crea una carpeta con el nombre del cliente dentro de `proyectos`, copia ahí todo lo que te mandó (en cualquier formato) y escríbeme: *Crea la web de <cliente>*».
