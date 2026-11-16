# Proyectos: una carpeta por cliente

**Crea aquí una carpeta con el nombre del cliente y copia dentro todo lo que te mandó, tal como te llegó.** Luego escribe en Claude Code: *Crea la web de nombre del cliente*.

```
proyectos/
  _plantilla-proyecto/     ← estructura de referencia (Claude la usa; no hace falta tocarla)
  academia-norte/          ← un cliente
  clinica-sol/             ← otro cliente
```

Claude ordena el material en `brief/` y genera `concepto.md`, `mockup/`, `payload/` y `site-maestro.zip` dentro de la carpeta del cliente.

> Las carpetas de clientes no se suben al repositorio compartido (ver `.gitignore`).

## Regla
Cada cliente tiene una experiencia distinta. Nunca se reutiliza el `payload/` ni el `mockup/` de un proyecto como base visual de otro.
