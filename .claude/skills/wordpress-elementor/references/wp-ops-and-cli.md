# WordPress Operations & WP-CLI Best Practices

This guide establishes safety-first rules and deterministic workflows for managing WordPress sites, databases, and servers via WP-CLI (`wp`).

---

## 1. Safety Guardrails & Blast Radius

WP-CLI commands run with the permissions of the database user and shell user. Careless executions can overwrite production databases or wipe directories.

### Before Any Write/Destructive Command:
1. **Confirm Environment:**
   ```bash
   wp option get siteurl
   wp option get home
   ```
   Verify you are not accidentally pointing to production or the wrong multisite subsite (`--url`).
2. **Deterministic Targeting:**
   Always pass `--path=/path/to/wordpress` if executing from outside the document root.
3. **Backup First:**
   Never run migrations, batch updates, or deletions without a fresh database backup:
   ```bash
   wp db export backup-pre-operation-$(date +%Y%m%d%H%M%S).sql
   ```

---

## 2. Safe URL & Domain Migration (`search-replace`)

WordPress serializes arrays and objects in `wp_options` and `wp_postmeta`. Plain SQL replace strings (`REPLACE()`) will corrupt serialized data by breaking byte counts. `wp search-replace` safely unpacks, modifies, recalculates lengths, and re-serializes.

### Safe 4-Step Sequence:

```bash
# 1. Back up database
wp db export pre-search-replace.sql

# 2. Dry run with summary
wp search-replace "http://old-domain.com" "https://new-domain.com" --dry-run --precise --skip-columns=guid

# 3. Execute the replacement
wp search-replace "http://old-domain.com" "https://new-domain.com" --precise --skip-columns=guid

# 4. Flush rewrites and caches
wp cache flush
wp rewrite flush
```

### Critical Flags:
- `--skip-columns=guid`: **Never change GUIDs on existing posts** unless migrating a local fresh dev site, as RSS feed readers will treat every post as new.
- `--precise`: Ensures exact multibyte string safety.
- `--all-tables`: Searches custom tables as well as standard core tables.
- `--network`: Runs across all sites in a WordPress Multisite network.

---

## 3. Database Management & Inspections

```bash
# Check database connection and basic tables
wp db check

# Optimize database tables
wp db optimize

# Execute ad-hoc query safely
wp db query "SELECT option_name, LENGTH(option_value) AS len FROM wp_options WHERE autoload = 'yes' ORDER BY len DESC LIMIT 10;"

# Import database
wp db import dump.sql

# Reset database (Deletes all tables! Local dev only)
wp db reset --yes
```

---

## 4. Plugins & Themes Lifecycle

```bash
# Check plugin status
wp plugin list --status=active

# Check if specific plugin is active
wp plugin is-active elementor && echo "Elementor active"

# Update plugins safely
wp plugin update --all --dry-run
wp plugin update <plugin-slug>

# Install and activate specific plugin
wp plugin install <slug> --activate

# Verify theme status
wp theme list
wp theme is-active hello-elementor && echo "Hello Elementor active"
```

---

## 5. Cron, Transients & Cache Management

```bash
# Flush object cache
wp cache flush

# List upcoming WP-Cron scheduled events
wp cron event list

# Run next due cron events
wp cron event run --due-now

# Delete all expired transients
wp transient delete --expired

# Flush rewrite rules (after CPT or taxonomy changes)
wp rewrite flush --hard
```

---

## 6. Maintenance Mode

When performing risky updates or imports, toggle maintenance mode cleanly:

```bash
# Activate maintenance mode
wp maintenance-mode activate

# Deactivate maintenance mode
wp maintenance-mode deactivate

# Check status
wp maintenance-mode status
```
*(For Elementor-specific custom maintenance mode templates, see `references/maintenance-mode.md`.)*
