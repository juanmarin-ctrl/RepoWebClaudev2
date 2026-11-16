#!/usr/bin/env node
// WordPress local (WordPress Playground) con Hello Elementor + Elementor + Site Maestro montado.
// Uso: node tools/playground.mjs [puerto]   →   http://localhost:9400  (admin / password, solo local)
//
// Opcional: si existe la carpeta TeducasCore/ en la raíz del repo (plugin interno, no incluido),
// también se monta y se activa.
import { spawn } from 'node:child_process';
import { existsSync, writeFileSync, readFileSync } from 'node:fs';
import { resolve, dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const repo = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const port = Number(process.argv[2] || process.env.PORT || 9400);
const blueprint = JSON.parse(readFileSync(join(repo, 'tools', 'wp-playground', 'blueprint.json'), 'utf8'));

// Rutas RELATIVAS a la raíz del repo: la CLI no acepta "C:\..." en --mount y así
// evitamos problemas con espacios en la ruta (se ejecuta con cwd = raíz del repo).
const mounts = ['--mount=engine/site-maestro:/wordpress/wp-content/plugins/site-maestro'];
if (existsSync(join(repo, 'TeducasCore', 'teducas-core.php'))) {
  mounts.push('--mount=TeducasCore:/wordpress/wp-content/plugins/teducas-core');
  blueprint.steps.push({ step: 'activatePlugin', pluginPath: 'teducas-core/teducas-core.php' });
  console.log('TeducasCore detectado: se montará y activará.');
}

// Si la web activa necesita WooCommerce o Tutor LMS (versiones gratuitas de wordpress.org), se instalan también.
let requires = [];
try {
  requires = JSON.parse(readFileSync(join(repo, 'engine', 'site-maestro', 'payload', 'site.json'), 'utf8').replace(/^﻿/, '')).requires || [];
} catch {}
const at = blueprint.steps.findIndex((s) => s.step === 'activatePlugin');
for (const slug of ['woocommerce', 'tutor']) {
  if (!requires.includes(slug)) continue;
  blueprint.steps.splice(at, 0, { step: 'installPlugin', pluginData: { resource: 'wordpress.org/plugins', slug }, options: { activate: true } });
  console.log(`La web usa ${slug}: se instalará en el WordPress de prueba.`);
}
if (requires.some((r) => r === 'elementor-pro' || r === 'tutor-pro')) {
  console.log('Aviso: Elementor Pro / Tutor Pro son de pago y no se instalan en la prueba local.');
}

const bpRel = 'tools/wp-playground/.blueprint.generated.json';
writeFileSync(join(repo, bpRel), JSON.stringify(blueprint, null, 2));

const args = ['-y', '@wp-playground/cli@latest', 'server', `--port=${port}`, ...mounts, `--blueprint=${bpRel}`];
console.log(`WordPress Playground → http://localhost:${port}  (admin / password)`);
const child = spawn('npx', args, { cwd: repo, stdio: 'inherit', shell: process.platform === 'win32' });
child.on('exit', (code) => process.exit(code ?? 0));
