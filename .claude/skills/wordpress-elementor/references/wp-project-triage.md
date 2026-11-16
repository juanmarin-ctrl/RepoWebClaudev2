# WordPress Project Triage & Routing

Use this procedure at the start of any WordPress task to detect the codebase structure, active stack, and route to the correct workflow.

---

## 1. Automated Detection Script

Run the included triage script from the project root:

```bash
node <skill-path>/scripts/detect_wp_project.mjs
```

The script examines:
- Project kind: Full site (`wp-site`), plugin (`wp-plugin`), block theme (`wp-block-theme`), classic theme (`wp-theme`), or Elementor site (`wp-elementor-site`).
- Tooling: Composer, npm/yarn/pnpm/bun, `@wordpress/scripts`, PHPUnit, wp-env, Playwright.
- Constants in `wp-config.php`: `WP_DEBUG`, `SAVEQUERIES`, `DISABLE_WP_CRON`, `WP_CACHE`.
- Drop-ins & caching: `object-cache.php`, `advanced-cache.php`, `db.php`.
- Elementor & EMCP Presence: `elementor`, `elementor-pro`, Hello Elementor theme, or `.mcp.json` server configurations.

---

## 2. Decision Tree & Workflow Routing

```
                          [WordPress Codebase]
                                   │
               ┌───────────────────┴───────────────────┐
               ▼                                       ▼
     [Elementor / EMCP Stack]                 [Core / Block / Plugin Stack]
               │                                       │
      ┌────────┴────────┐                     ┌────────┴────────┐
      ▼                 ▼                     ▼                 ▼
[Page Building /   [Custom Code /       [Block Themes /    [Custom Plugins /
 Layout Refactor]   Integrations]        theme.json]        REST / WP-CLI]
      │                 │                     │                 │
• Native Catalog   • Custom Widgets     • theme.json       • wp-plugin-and-security
• Flex Containers  • Dynamic Tags       • block.json       • wp-rest-api
• Kit Styles       • wp-plugin-security • FSE Templates    • wp-ops-and-cli
• Visual QA Loop   • wp-rest-api        • Interactivity    • wp-performance
```

### Match Criteria:

1. **Elementor Page Building (`emcp-tools-*` or `elementor-mcp-*` available, or page requested)**
   - Check if Elementor plugin is active: `wp plugin is-active elementor`.
   - Verify tool gate (v3.1 has 39 tools disabled by default: see `references/onboarding.md`).
   - Follow native catalog flow: `list-widgets` → `get-widget-schema` → `add-free-widget` / `add-pro-widget` → `update-element`.
   - Never default to raw HTML widgets; use native widgets so pages stay client-editable.

2. **WordPress Operations & Server Maintenance (`wp search-replace`, DB, backups, cache)**
   - Read `references/wp-ops-and-cli.md`.
   - Verify environment (local vs staging vs production) before running destructive commands.
   - Always export DB before running migrations or search-replace.

3. **Plugin Architecture, Hooks, or Security Fixes**
   - Read `references/wp-plugin-and-security.md`.
   - Hook on appropriate actions (`plugins_loaded`, `init`, `admin_init`).
   - Validate nonces, check capabilities (`current_user_can`), sanitize input, escape output, and use `$wpdb->prepare()`.

4. **REST API Routes & Endpoint Creation**
   - Read `references/wp-rest-api.md`.
   - Define custom namespace, register routes via `rest_api_init`, provide strict `permission_callback`, and declare schema.

5. **Performance, Query Bottlenecks & Caching**
   - Read `references/wp-performance.md`.
   - Profile using Query Monitor or Server-Timing.
   - Inspect autoloaded options and transient lifecycles.
   - Optimize Elementor DOM depth and asset loading.
