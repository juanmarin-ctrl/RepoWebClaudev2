---
name: wordpress-elementor
description: >-
  Use this skill whenever working on WordPress sites, core plugins (e.g. nh-core,
  teducas-core), themes, and server operations, and especially when building or
  refactoring pages with Elementor / Elementor Pro via EMCP Tools (`emcp-tools-*`
  or legacy `elementor-mcp-*`) or developing Gutenberg blocks and Block Themes.
  Combines official WordPress development standards (project triage, safe WP-CLI
  operations, modular plugin architecture, Gutenberg blocks, Interactivity API,
  REST API, security, PHPStan, performance profiling) with the battle-tested
  Elementor fluent page-building methodology (native widgets over raw HTML,
  flexbox/grid container rules, kit settings, Pro forms, dynamic tags, and visual review).
---

# WordPress, Core Plugins & Elementor Master Skill

A unified, production-grade guide for building, extending, and operating WordPress sites. This skill bridges WordPress backend engineering (core plugin architecture, security, WP-CLI, REST, blocks, PHPStan) with Elementor page-building fluency (native widgets, flexbox containers, kit styles, dynamic tags).

---

## Core Engineering Principles

1. **Native Over Raw HTML**: In Elementor, dropping into raw HTML widgets defeats the purpose of a visual builder. Pages must remain 100% editable from the Elementor panel UI by non-technical clients.
2. **Schema-First Discipline**: Elementor silently stores any key you invent and silently ignores wrong keys. Always verify control keys against `get-widget-schema` or `get-container-schema`.
3. **Foundation Plugin Architecture**: In core plugins (`nh-core`, `teducas-core`), keep business logic modular with PSR-4 namespaces, service classes, and clean separation between entities, REST endpoints, and UI integrations (Elementor & Gutenberg).
4. **Safety-First Operations**: WP-CLI writes and database migrations carry blast radius. Always verify targeting (`siteurl`/`home`), back up the database before mutating operations, and use safe serialization (`wp search-replace`).
5. **Security by Default**: Never write an unauthenticated REST route or unvalidated admin action. Always check nonces, verify capabilities (`current_user_can`), sanitize input, escape late, and use `$wpdb->prepare()`.

---

## 1. Quick Triage & Workflow Routing

At the beginning of any WordPress task, run the triage script to classify the project:

```bash
node <skill-path>/scripts/detect_wp_project.mjs
```

| Project Context / Intent | Primary Workflow Track | Deep Dive Reference |
|---|---|---|
| **Elementor Page Building / Redesign** (`emcp-tools-*` or `elementor-mcp-*` available, landing pages, sales pages, theme templates) | **Track A: Elementor Fluent Page Building** | [`references/layout-patterns.md`](references/layout-patterns.md)<br>[`references/site-settings.md`](references/site-settings.md)<br>[`references/form-widget.md`](references/form-widget.md) |
| **Server Operations & WP-CLI** (Migrations, domain changes, DB backup/import, plugin updates, cron, cache) | **Track B: WP-CLI & Operations** | [`references/wp-ops-and-cli.md`](references/wp-ops-and-cli.md)<br>[`references/maintenance-mode.md`](references/maintenance-mode.md) |
| **Core Plugin Development** (`nh-core`, `teducas-core`, services, CPTs, migrations, custom add-ons) | **Track C: Core Plugin Architecture** | [`references/wp-core-plugin-architecture.md`](references/wp-core-plugin-architecture.md)<br>[`references/wp-plugin-and-security.md`](references/wp-plugin-and-security.md) |
| **Gutenberg Block Development** (Custom blocks, `block.json`, attributes, deprecations, InnerBlocks) | **Track D: Gutenberg Blocks** | [`references/wp-block-development.md`](references/wp-block-development.md) |
| **Block Themes & theme.json** (FSE templates, Global Styles, color palettes, patterns) | **Track E: Block Themes** | [`references/wp-block-themes.md`](references/wp-block-themes.md) |
| **Interactivity API** (Reactive directives `data-wp-*`, stores, state, client hydration) | **Track F: Interactivity API** | [`references/wp-interactivity-api.md`](references/wp-interactivity-api.md) |
| **REST API Routes & Endpoints** (Custom controllers, schema validation, permissions, webhooks) | **Track G: REST API** | [`references/wp-rest-api.md`](references/wp-rest-api.md) |
| **Performance & Slow Queries** (TTFB optimization, autoload bloat, caching, Elementor DOM reduction) | **Track H: Performance & Caching** | [`references/wp-performance.md`](references/wp-performance.md) |
| **Static Analysis & Quality** (PHPStan configuration, baselines, type annotations) | **Track I: PHPStan** | [`references/wp-phpstan.md`](references/wp-phpstan.md) |

---

## 2. Track A: Elementor Fluent Page Building (EMCP Tools v3+)

### A. Plugin Version & Tool Gate
Tool names use the v3 prefix (`emcp-tools-<tool>`).
- **`mcp__*__emcp-tools-*`**: Plugin v3.0+ (current standard).
- **`mcp__*__elementor-mcp-*`**: Legacy plugin (pre-3.0). Requires upgrading or using two-step `add-*` + `update-element` calls.
- **The v3 Tool Gate**: In EMCP Tools v3.1, **39 abilities are disabled by default**, including 6 critical capabilities: `add-custom-css`, `set-dynamic-tag`, `list-dynamic-tags`, `add-pro-widget`, `create-theme-template`, and `set-template-conditions`.
  
Check and unlock required tools via WP-CLI:
```bash
wp eval '
  $d = get_option("emcp_tools_disabled_tools", []);
  $enable = ["emcp-tools/add-custom-css","emcp-tools/set-dynamic-tag","emcp-tools/list-dynamic-tags",
             "emcp-tools/add-pro-widget","emcp-tools/create-theme-template","emcp-tools/set-template-conditions"];
  update_option("emcp_tools_disabled_tools", array_values(array_diff($d, $enable)));
'
```

### B. Standard 7-Step Page Building Procedure
1. **Analyze Source First**: Extract exact tokens from briefs, Figma, or reference URLs using `agent-browser` + `eval` (`getComputedStyle`). See [`references/reference-site-analysis.md`](references/reference-site-analysis.md).
2. **Fetch Brand Kit**: Call `emcp-tools-get-global-settings` before creating containers. Use refs inside the nested `__globals__` map (e.g. `{"__globals__": {"title_color": "globals/colors?id=accent"}}`). See [`references/site-settings.md`](references/site-settings.md) and §G.
3. **Verify Kit Baseline CSS**: Ensure paragraph margin resets and accessibility rings exist (`skill-baseline: applied`). See [`references/kit-css.md`](references/kit-css.md).
4. **Narrate Layout**: Outline containers, widgets, and direction in prose before calling build tools.
5. **Create Page Draft**: Call `emcp-tools-create-page` with `status: "draft"` and appropriate `template` (`elementor_canvas` for landing pages; `default` or `elementor_header_footer` for integrated chrome).
6. **Build Incrementally**:
   - Always label section containers: `"_title": "Hero — Section"`.
   - Use the **Catalog Flow**: `list-widgets` → `get-widget-schema` → `add-free-widget` / `add-pro-widget` (passing content + styling in one call).
   - Use `batch-update` for multi-element iteration.
7. **Publish & Visual QA**: Set `agent-browser set viewport 1280 800`, screenshot, and diagnose with eval recipes. See [`references/diagnostics.md`](references/diagnostics.md).

### C. Critical Flexbox & Grid Container Rules
- **The Boxed Width Collapse Trap**: Flex children that have explicit widths (e.g. 33% or 340px) MUST have `"content_width": "full"`. If left at default `"boxed"`, Elementor applies `.e-con-boxed` which forces `width: 100%`, collapsing the row into a vertical stack.
- **2-Column Ratio Splits (Flex-Native)**: A 2-column split with a proportion (57/43, 42/58, etc.) does NOT need grid or CSS. Use default flex (`flex_direction: "row"`) + `width: {"unit": "%", "size": N}` on each child. Stack on mobile with `flex_direction_mobile: "column"`. Native and panel-editable.
- **Multi-Track Grid CSS**: Reserve CSS grid tracks (`80px 1fr 2fr auto` with `!important`) only for complex multi-track templates flex cannot reproduce. Note: containers do not expose `_grid_column` spans in schema.
- **Global `container_width` Alignment**: Define `container_width` on the kit (e.g. 1440px) so Theme Builder templates (header/footer) and page sections share the exact same boundary. Never set `boxed_width` only on page sections, or the logo/gutter will misalign with the header.
- **Container Spacing**: Always use **`flex_gap`** (not `gap`). Elementor CSS generator reads `flex_gap`; `gap` is silently ignored.
- **Container Padding**: Always use **`padding`** (not `_padding`). `_padding` is silently ignored.
- **Flex Sizing Pairs**: When one flex child grows (`_flex_size: "grow"` + `_flex_grow: "1"`), its fixed-width siblings MUST have **`_flex_size: "none"`**, otherwise they shrink to zero width.
- **Column Container Alignment**: Column containers default to `flex_align_items: "center"`. Always set **`flex_align_items: "stretch"`** if children should fill full width.
- **Grid Container Rows**: `grid_columns_grid` and `grid_rows_grid` take an object `{"unit": "fr", "size": N, "sizes": []}` where `size` is an integer count. Always set `grid_rows_grid` explicitly to avoid an empty second row.
- **Responsive Grid Columns**: `grid_columns_grid_tablet` / `grid_columns_grid_mobile` (`{"unit":"fr","size":N}`) **DO emit native CSS** (e.g. 4 desktop → 2 tablet → 1 mobile). Never write `@media` CSS for simple column count shifts.

### D. Navigation Menu (Pro) & Header Layout Gotchas
- Select menus by slug via **`menu`** (not `menu_name`). Typography switch is `menu_typography_typography: "yes"`.
- `pointer_width` only emits CSS when `pointer` is `underline`, `overline`, `double-line`, or `framed`.
- `animation_line: "grow"` resting state measures 0px (`height:0; width:0`) and expands on hover. This is intended behavior, not broken CSS.
- If kit `__globals__` override explicit menu typography/colors, clear the widget's `__globals__` object.
- To align a header CTA button with the page's right margin, set the button's column container to `flex_justify_content: "flex-end"`.

### E. Scoping Custom CSS (Where CSS Goes)
Pick the narrowest scope that applies:
1. **Single Page**: `update-page-settings(post_id, {"custom_css": "..."})` (only loads on that page).
2. **Theme Builder Template (Header/Footer)**: Put CSS in that template's own `custom_css` post. Styling a footer on a scratch page means it renders unstyled across the rest of the site!
3. **Site-Wide / Shared CSS**: Customizer's **Additional CSS** (`wp_update_custom_css_post()`), rendered globally in `wp_head` as `<style id="wp-custom-css">`. Handled via `wp eval` (replace-not-append, so read + concatenate first):
   ```php
   $css = trim( wp_get_custom_css() ) . "\n\n" . "/* ... your rules ... */";
   wp_update_custom_css_post( $css );
   ```
   *(With DDEV: `ddev wp eval '...'` or `ddev wp eval-file public_html/archivo.php`). After moving page CSS to Additional CSS, clear the page's block (`update-page-settings {"custom_css": ""}`) to prevent duplication.*

### F. Brand Kit Safety Rule
> ⚠️ **NEVER execute `update-page-settings` on the kit post ID.** This executes a full replace on `_elementor_page_settings` and destroys the entire brand kit.
- For custom palette colors or typography: use `emcp-tools-update-global-colors` and `emcp-tools-update-global-typography` (they merge).
- For system slots (`primary`, `secondary`, `text`, `accent`): use safe `wp eval` read-modify-write only. See [`references/kit-css.md`](references/kit-css.md) and [`references/site-settings.md`](references/site-settings.md).

### G. Global Typography & Font Loading
- **Global typography is all-or-nothing**: linking `<group>_typography` to `globals/typography?id=<preset>` replaces family + size + weight + line-height + tracking and **discards the element's local `font-size`** (verified: H1 120px → 72px on link). You cannot "link only the family and keep the size".
- **Preset-per-style recipe**: create one global typography preset in the kit for every distinct style (family, weight, style, transform, desktop/tablet/mobile size, line-height, tracking) and link each group to its preset. Presets **do** store responsive sizes (`typography_font_size_tablet`, `_mobile` — verified 120/84/58).
- **Storage format (critical)**: refs live in a nested map `settings.__globals__`, never as sibling keys:
  ```json
  "__globals__": { "title_color": "globals/colors?id=accent",
                   "typography_typography": "globals/typography?id=fortuna-typo-xxxx" }
  ```
  Sibling `X__globals__` keys (e.g. `title_color__globals__`) **save but are silently ignored** — the CSS keeps the literal value. The key is `<typography control>_typography` (e.g. `typography_typography`, `menu_typography_typography`, `icon_typography`).
- **Google Fonts loading**: WordPress `kses` strips `<link>` and `<style>` from HTML widgets on save (the `<style>` body leaks as visible text). Load fonts with `@import url('https://fonts.googleapis.com/css2?family=...&family=...&display=swap');` at the **top of the Customizer's Additional CSS** (site-wide), never in a widget.
- **Scripted `_elementor_data` refactor gotcha**: backing up by copying the value through `update_post_meta(...)` **without `wp_slash`** corrupts the JSON (backslashes are lost). Store the backup with `wp_slash()` (or to a file), mutate via `json_decode` → walk → `wp_slash(wp_json_encode())`, re-validate with `json_decode`, then run `wp elementor flush_css`.

### H. Global Color Remapping & Palette Migration
Recoloring a live site (rebrand, light→dark, dark→light) is a **property-aware migration**, not a find-and-replace. The same global token is often used as both a background and as text, so changing token values in bulk produces light-on-light text.
- **Audit first**: build a `token × property` matrix from `__globals__` and literal hex values. Property wins over token semantics (`background` → background, `border`/`divider` → border, everything else → text; `icon_secondary_color` on social icons is a **background**).
- **Conflict tokens** (used as both bg and text) get the dominant role's value; remap the minority role to a correctly-semantic token.
- **Persist with `$wpdb->update`**, not `update_post_meta` — on managed hosting the latter can return `true` and silently revert. Then `wp_cache_delete($id,'post_meta')`.
- **Full CSS flush**: `wp elementor flush-css` alone is insufficient; also delete `_elementor_css` meta and `uploads/elementor/css/*.css`.
- **Atomic widgets** (nested accordion, v4) color via CSS variables (`--n-accordion-*`), not element settings; override with `body .elementor-widget-n-accordion{...}` because widget CSS loads later at the same specificity.
- **Verify with a browser**: computed contrast `<3` and `<4.5`, plus 0 occurrences of the old brand hex.
- Full workflow, code, palette math and traps: [`references/global-color-remapping.md`](references/global-color-remapping.md).

---

## 3. Track B: WordPress Operations & WP-CLI

### A. Blast Radius & Environment Checklist
1. Verify site targeting before running destructive commands:
   ```bash
   wp option get siteurl && wp option get home
   ```
2. If working from outside root, pass `--path=/path/to/wordpress`.
3. Always create an immediate DB backup prior to updates or migrations:
   ```bash
   wp db export backup-$(date +%Y%m%d%H%M%S).sql
   ```

### B. Safe Domain & URL Migrations (`search-replace`)
Never use raw SQL `REPLACE()` because WordPress stores serialized arrays in postmeta and options. Use `wp search-replace`:
```bash
# 1. Dry run inspection
wp search-replace "http://old-domain.com" "https://new-domain.com" --dry-run --precise --skip-columns=guid

# 2. Execute replacement
wp search-replace "http://old-domain.com" "https://new-domain.com" --precise --skip-columns=guid

# 3. Invalidate caches and flush rewrites
wp cache flush
wp rewrite flush
```

---

## 4. Track C: Core Plugin Architecture & Security (`nh-core`, `teducas-core`)

- **PSR-4 Namespaces**: Organize by domain (`NH\Core\PostTypes`, `NH\Core\Api`, `NH\Core\Integrations`).
- **Conditional Elementor Hooking**: Check `did_action('elementor/loaded')` before registering custom widgets or dynamic tags.
- **Database Migrations**: Track schema versions with `get_option('nh_core_db_version')` and use `dbDelta()`.
- **Security Guardrails**:
  - CSRF nonces (`check_ajax_referer()`, `wp_verify_nonce()`).
  - Capabilities (`current_user_can()`).
  - Sanitization (`sanitize_text_field()`, `absint()`, `esc_url_raw()`).
  - Escaping (`esc_html()`, `esc_attr()`, `wp_kses_post()`).
  - SQL preparation (`$wpdb->prepare()`).
See [`references/wp-core-plugin-architecture.md`](references/wp-core-plugin-architecture.md).

---

## 5. Track D & E: Gutenberg Blocks & Block Themes

- **Block Declaration (v3)**: Always declare blocks via `block.json` with strict attributes and supports.
- **Dynamic Blocks**: Prefer dynamic blocks (`render.php` with `save: () => null`) for data-driven entities.
- **Deprecations**: When changing static block markup, provide deprecations in `deprecated.js` to avoid invalid content errors.
- **Block Themes**: Structure templates in `templates/`, parts in `parts/`, and configure global tokens in `theme.json` v3.
See [`references/wp-block-development.md`](references/wp-block-development.md) and [`references/wp-block-themes.md`](references/wp-block-themes.md).

---

## 6. Track F & G: Interactivity API & REST API

- **Interactivity Directives**: Use `data-wp-interactive`, `data-wp-context`, `data-wp-on--click`, `data-wp-bind`, and client stores for lightweight reactive UI.
- **REST Endpoints**: Register inside `rest_api_init`, always provide explicit `permission_callback`, and define validation/sanitization in `args`.
See [`references/wp-interactivity-api.md`](references/wp-interactivity-api.md) and [`references/wp-rest-api.md`](references/wp-rest-api.md).

---

## 7. Track H & I: Performance & PHPStan Static Analysis

- **Autoload Options**: Check total autoload size; keep under 800 KB (`wp db query "SELECT SUM(LENGTH(option_value)) FROM wp_options WHERE autoload='yes'"`).
- **Elementor DOM**: Prefer Flexbox containers over nested legacy sections; enable External CSS print method.
- **PHPStan Setup**: Use `szepeviktor/phpstan-wordpress` at level 6+ and maintain baseline files for legacy plugin code.
See [`references/wp-performance.md`](references/wp-performance.md) and [`references/wp-phpstan.md`](references/wp-phpstan.md).

---

## 8. Master Anti-Patterns & Pitfalls

| Anti-Pattern | Correct Practice |
|---|---|
| **Falling back to HTML widgets in Elementor** | Use `add-free-widget` / `add-pro-widget` with native widgets; iterate with `update-element` or `batch-update`. |
| **Parallel write calls to the same post in EMCP** | EMCP write calls are read-modify-write. Writes issued in parallel clobber each other. Write serially or use `batch-update`. |
| **Passing `_css_classes` on a container** | Containers use `css_classes` (no underscore). Widgets use `_css_classes`. |
| **Using `gap` on a container** | Use `flex_gap`. The `gap` key is stored but ignored by Elementor's CSS generator. |
| **Calling `update-page-settings` on a kit post** | Full replace wipes the kit. Use `wp eval` read-modify-write or `update-global-colors/typography` for custom tokens. |
| **Modifying serialized database rows with SQL `REPLACE()`** | Always use `wp search-replace --precise` to preserve byte lengths in serialized strings. |
| **Omitting `permission_callback` in REST routes** | REST API requires `permission_callback` for all endpoints. Never leave undefined. |
| **Concatenating variables into `$wpdb->query`** | Always use `$wpdb->prepare("... WHERE id = %d", $id)`. |
| **Setting `content_width: "boxed"` on flex children** | Flex children with explicit widths must have `content_width: "full"` to prevent 100% width collapse. |
| **Using grid + track CSS for a 2-column ratio split** | Use default flex container (`flex_direction: "row"`) + `width: {"unit": "%", "size": N}` per child (`flex_direction_mobile: "column"` to stack) — native and panel-editable. |
| **Theme Builder header/footer logo/gutter offset** | Define kit's global `container_width` (e.g. 1440px) so templates and sections inherit the same boundary. Do not set `boxed_width` only on page sections. |
| **Leaving shared / Theme Builder CSS in page `custom_css`** | Only loads on that page (header/footer unstyled site-wide). Move to Additional CSS (`wp_update_custom_css_post`) or template's own `custom_css`. |
| **Writing `@media` CSS for grid column counts** | Use native controls `grid_columns_grid_tablet` / `_mobile` (`{"unit":"fr","size":N}`); they emit native CSS. |
| **Linking global typography to keep the local `font-size`** | It is all-or-nothing (overwrites family, size, weight, line-height, tracking). Create one preset per style, with responsive sizes, and link each group. |
| **Writing `X__globals__` as a sibling key** | Global refs belong inside the nested `settings.__globals__` map; sibling keys are saved but silently ignored. |
| **Loading Google Fonts from an HTML widget** | `kses` strips `<link>`/`<style>` (filtering the text as visible content). Use `@import` at the top of the Customizer's Additional CSS. |
| **Modifying static block markup without deprecations** | Always add a deprecation entry in `deprecated.js` to preserve existing posts. |
| **Bulk-changing global color values for a rebrand or dark mode** | The same token is often used as background *and* text. Build a `token × property` matrix, remap by property role. See `references/global-color-remapping.md`. |
| **Trusting `update_post_meta` on `_elementor_data` in managed hosting** | It can return `true` and silently revert. Use `$wpdb->update()` + `wp_cache_delete($id,'post_meta')`, then validate the JSON. |
| **Running only `wp elementor flush-css` after a data migration** | Stale `_elementor_css` meta and CSS files persist. Delete both, flush object cache, then request the page. |

---

## 9. Complete Reference Library

- **Core Plugins & Architecture**: [`references/wp-core-plugin-architecture.md`](references/wp-core-plugin-architecture.md) & [`references/wp-plugin-and-security.md`](references/wp-plugin-and-security.md)
- **Gutenberg Blocks & FSE**: [`references/wp-block-development.md`](references/wp-block-development.md) & [`references/wp-block-themes.md`](references/wp-block-themes.md)
- **Interactivity API**: [`references/wp-interactivity-api.md`](references/wp-interactivity-api.md)
- **REST API Routes & Endpoints**: [`references/wp-rest-api.md`](references/wp-rest-api.md)
- **Server Ops & WP-CLI**: [`references/wp-ops-and-cli.md`](references/wp-ops-and-cli.md) & [`references/maintenance-mode.md`](references/maintenance-mode.md)
- **Performance & Profiling**: [`references/wp-performance.md`](references/wp-performance.md)
- **Static Analysis**: [`references/wp-phpstan.md`](references/wp-phpstan.md)
- **Global Color Remapping**: [`references/global-color-remapping.md`](references/global-color-remapping.md)
- **Elementor Page Building**: [`references/layout-patterns.md`](references/layout-patterns.md), [`references/site-settings.md`](references/site-settings.md), [`references/kit-css.md`](references/kit-css.md), [`references/form-widget.md`](references/form-widget.md), [`references/dynamic-tags.md`](references/dynamic-tags.md), [`references/diagnostics.md`](references/diagnostics.md), [`references/onboarding.md`](references/onboarding.md)
