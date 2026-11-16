# Instalador del Site Kit TEDUCAS (Windows).
# Lo normal es no ejecutarlo a mano: abre Claude Code en esta carpeta y escribe INSTALAR.
# A mano (desde la carpeta del kit):  powershell -ExecutionPolicy Bypass -File setup.ps1
# Es idempotente: si Node.js ya está, lo salta.
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
function Have($c) { [bool](Get-Command $c -ErrorAction SilentlyContinue) }
function Reload-Path { $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User") }
function Node-Ok { if (-not (Have node)) { return $false }; $v = (& node -p "process.versions.node.split('.')[0]") 2>$null; return ([int]$v -ge 18) }

Write-Host "`n==> Node.js 18+" -ForegroundColor Cyan
if (-not (Node-Ok)) {
    if (Have winget) {
        Write-Host "Instalando Node.js LTS con winget..."
        winget install -e --id OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements --disable-interactivity
        Reload-Path
        if (-not (Have node) -and (Test-Path "C:\Program Files\nodejs\node.exe")) { $env:Path = "C:\Program Files\nodejs;" + $env:Path }
    }
    if (-not (Node-Ok)) { Write-Host "INSTALAR_FALLO node: instala Node.js LTS desde https://nodejs.org y vuelve a escribir INSTALAR." -ForegroundColor Red; exit 1 }
}
Write-Host "OK: Node.js $(& node --version)"

Write-Host "`n==> Comprobación del kit (la primera vez descarga WordPress Playground, 1-3 min)" -ForegroundColor Cyan
& node tools/setup.mjs --warm
if ($LASTEXITCODE -ne 0) { Write-Host "`nINSTALAR_INCOMPLETO: revisa las líneas con ✘." -ForegroundColor Yellow; exit 2 }
Write-Host "`nINSTALAR_OK" -ForegroundColor Green
