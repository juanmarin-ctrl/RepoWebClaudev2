#!/usr/bin/env bash
# Instalador del Site Kit TEDUCAS (Mac).
# Lo normal es no ejecutarlo a mano: abre Claude Code en esta carpeta y escribe INSTALAR.
# A mano (desde la carpeta del kit):  bash setup.sh
# Es idempotente: si Node.js ya está, lo salta.
set -u
cd "$(dirname "$0")"
for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [ -x "$b" ]; then eval "$("$b" shellenv)"; break; fi
done
have() { command -v "$1" >/dev/null 2>&1; }
node_ok() { have node && [ "$(node -p "process.versions.node.split('.')[0]" 2>/dev/null || echo 0)" -ge 18 ]; }

printf '\n==> Node.js 18+\n'
if ! node_ok; then
  if have brew; then
    echo "Instalando Node.js con Homebrew..."
    brew install node || true
  fi
  if ! node_ok; then
    printf '\nINSTALAR_FALLO node: falta Node.js. Instálalo desde https://nodejs.org (botón LTS, pide la contraseña del Mac) o instala Homebrew (https://brew.sh) y vuelve a escribir INSTALAR.\n'
    exit 1
  fi
fi
echo "OK: Node.js $(node --version)"

printf '\n==> Comprobación del kit (la primera vez descarga WordPress Playground, 1-3 min)\n'
if node tools/setup.mjs --warm; then
  printf '\nINSTALAR_OK\n'
else
  printf '\nINSTALAR_INCOMPLETO: revisa las líneas con ✘.\n'; exit 2
fi
