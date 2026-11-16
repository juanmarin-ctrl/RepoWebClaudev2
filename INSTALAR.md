# Instalar el Site Kit

**Abre Claude Code en la carpeta del kit y escribe `INSTALAR`.** Claude lo hace todo. El procedimiento que sigue está en `.claude/skills/instalar/SKILL.md`.

## Qué hace
1. Instala **Node.js** si falta: en Windows con winget; en Mac con Homebrew. Si no puede, te pide instalarlo desde nodejs.org (botón LTS).
2. Comprueba el kit (`node tools/setup.mjs --warm`) y descarga WordPress Playground para las pruebas locales. La primera vez tarda de 1 a 3 minutos.
3. Descarga la skill de diseño `design-taste-frontend` (licencia MIT, fijada a la versión probada con el kit) y comprueba que las skills de diseño están cargadas.
4. Prueba la vista previa de maquetas (`http://localhost:4173`).

Git **no** es necesario si descargaste el ZIP.

## A mano, sin Claude

En Windows:

```bash
powershell -ExecutionPolicy Bypass -File setup.ps1
```

En Mac:

```bash
bash setup.sh
```

## Problemas frecuentes

| Síntoma | Solución |
|---------|----------|
| Claude no ve las skills | Abre Claude Code en la carpeta del kit: la que tiene dentro `README.md` y `engine`. |
| Tarda mucho la primera vez | Es normal: está descargando WordPress Playground. |
| Puerto 4173 o 9400 ocupado | `node tools/serve.mjs 4180` / `node tools/playground.mjs 9500` |
| El ZIP no se instala en el hosting | Genera el ZIP con `node tools/package.mjs <cliente>`, no con «Enviar a carpeta comprimida». Pídeselo a Claude. |
| Las funciones de idioma (`language_chrome`) no hacen nada | Necesitan el plugin interno Teducas Core ≥ 1.17 en el WordPress, que no viene incluido. Para probarlo en local, copia `TeducasCore/` a la raíz del kit. |
