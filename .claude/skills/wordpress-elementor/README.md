# wp-elementor-agent-skill

A unified [Agent Skill](https://agentskills.io) merging the official [WordPress Agent Skills](https://github.com/WordPress/agent-skills) standard with the battle-tested [Elementor MCP Skill](https://github.com/mwender/elementor-mcp-skill) workflow.

Designed for AI assistants (Claude Code, Antigravity, Cursor, Codex) to build, refactor, and operate full-stack WordPress sites, develop core foundation plugins (`nh-core`, `teducas-core`), implement Gutenberg blocks and Block Themes, and build pixel-perfect Elementor layouts via EMCP Tools.

---

## What It Covers

1. **Foundation & Core Plugin Development (`nh-core`, `teducas-core`)**:
   - PSR-4 modular architecture (services, containers, entities).
   - Collision avoidance (prefixed functions, classes, hooks, options).
   - Database migrations and table versioning (`dbDelta`).
   - Clean bridging between Elementor (widgets/dynamic tags) and Gutenberg (blocks/REST).
2. **Gutenberg Block Development & Block Themes**:
   - `block.json` (API v3) schema, attributes, and supports.
   - Dynamic blocks (`render.php`) vs static blocks with serialization.
   - Block deprecations to prevent "invalid content" errors on markup changes.
   - InnerBlocks templates and locking.
   - `theme.json` v3 Global Styles, templates, parts, and block patterns.
3. **Frontend Interactivity & REST API**:
   - WordPress Interactivity API (`data-wp-*` directives and reactive stores).
   - REST API controllers, versioned namespaces, schemas, and mandatory `permission_callback`.
4. **Elementor Page Building Fluency (EMCP Tools v3+)**:
   - Native widget catalog flow (`list-widgets` → `get-widget-schema` → `add-free-widget` / `add-pro-widget` → `batch-update`).
   - Elimination of raw HTML widgets so all content remains panel-editable.
   - Container Flexbox & Grid rules (preventing boxed collapse, `flex_gap` vs `gap`, `padding` vs `_padding`).
   - Global Kit safety (preventing kit wiping, `__globals__` tokens).
   - Pro forms, webhooks, ACF dynamic tags, and visual QA with `agent-browser`.
5. **Server Operations & Code Quality**:
   - Safe WP-CLI domain migrations (`wp search-replace --precise --skip-columns=guid`).
   - Performance profiling (Query Monitor, autoload bloat, caching).
   - Static analysis with PHPStan (`szepeviktor/phpstan-wordpress`).

---

## Directory Structure

```
wp-elementor-agent-skill/
├── SKILL.md                          # Master instruction document with decision routing
├── README.md                         # Project overview and installation guide
├── scripts/
│   ├── detect_wp_project.mjs         # Multi-signal WP, Elementor, and Block detector
│   ├── wpcli_inspect.mjs             # Deterministic WP-CLI inspector
│   ├── perf_inspect.mjs              # Performance & cache inspector
│   ├── list_blocks.mjs               # Gutenberg block scanner
│   ├── detect_block_themes.mjs       # Block theme inspector
│   └── phpstan_inspect.mjs           # PHPStan configuration inspector
└── references/
    ├── wp-core-plugin-architecture.md # Foundation plugins (nh-core, teducas-core)
    ├── wp-block-development.md       # Gutenberg blocks (block.json, deprecations)
    ├── wp-block-themes.md            # Block themes and theme.json v3
    ├── wp-interactivity-api.md       # Interactivity API (data-wp-* directives)
    ├── wp-phpstan.md                 # PHPStan static analysis and baselines
    ├── wp-project-triage.md          # Project classification and decision tree
    ├── wp-ops-and-cli.md             # Safe WP-CLI, backups, and search-replace
    ├── wp-plugin-and-security.md     # Plugin architecture, hooks, and security
    ├── wp-rest-api.md                # REST routes, schemas, and permissions
    ├── wp-performance.md             # Query Monitor, autoload options, and caching
    ├── onboarding.md                 # EMCP Tools setup, .mcp.json, tool gating
    ├── site-settings.md              # Global colors, typography, and __globals__
    ├── kit-css.md                    # Kit baseline CSS and corruption recovery
    ├── layout-patterns.md            # Flexbox/grid recipes, badges, cards, refactoring
    ├── form-widget.md                # Pro form widget styling, webhooks, phone masks
    ├── dynamic-tags.md               # ACF integration and dynamic copyright year
    ├── diagnostics.md                # Browser eval recipes and visual review workflows
    ├── maintenance-mode.md           # Maintenance mode templates and configuration
    └── reference-site-analysis.md    # Token extraction from reference websites
```

---

## Installation

### Global Installation for Antigravity & Claude Code

```bash
# Clone to your projects folder
git clone https://github.com/500Byte/wp-elementor-agent-skill.git ~/Documents/GitHub/wp-elementor-agent-skill

# Link to ~/.agents/skills (discovered by Antigravity and Claude Code)
ln -s ~/Documents/GitHub/wp-elementor-agent-skill ~/.agents/skills/wordpress-elementor

# Link to ~/.claude/skills (for Claude Code)
ln -s ~/Documents/GitHub/wp-elementor-agent-skill ~/.claude/skills/wordpress-elementor
```

---

## Credits & Attribution

This skill builds upon and unifies two core open-source foundations:

- **[WordPress Agent Skills](https://github.com/WordPress/agent-skills)** — Official WordPress standards, WP-CLI automation, project triage, security guidelines, and PHPStan patterns developed by WordPress.org and the WordPress contributor community.
- **[Elementor MCP Skill](https://github.com/mwender/elementor-mcp-skill)** — Pioneer Elementor MCP integration patterns and widget workflows created by Michael Wender.

**Unified Architecture, Foundation Plugin Patterns & TEDUCAS Standards:**  
Designed, unified, and maintained by Diego N. ([@500Byte](https://github.com/500Byte)).

---

## License

MIT License.
