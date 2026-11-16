# PHPStan for WordPress Development

Use this reference when setting up, running, or resolving static analysis issues in WordPress plugins (`nh-core`, `teducas-core`) and themes with PHPStan.

---

## 1. Essential Setup

Install PHPStan and WordPress stubs via Composer:

```bash
composer require --dev phpstan/phpstan szepeviktor/phpstan-wordpress phpstan/extension-installer
```

---

## 2. Recommended `phpstan.neon`

```neon
includes:
    - vendor/szepeviktor/phpstan-wordpress/extension.neon

parameters:
    level: 6
    paths:
        - includes/
        - nh-core.php
    excludePaths:
        - vendor/
        - node_modules/
    scanFiles:
        # Include stubs if external plugins (like Elementor or ACF) are required
        # - tests/stubs/elementor-stubs.php
    ignoreErrors:
        # Ignore common dynamic hook false positives if needed
        # - '#Constant WP_DEBUG not found.#'
```

---

## 3. Common WordPress PHPStan Patterns

### A. Documenting Hooks and `$wpdb`
PHPStan does not know dynamic database return types by default:

```php
/** @var \wpdb $wpdb */
global $wpdb;

/** @var array<int, object{id: int, email: string}> $leads */
$leads = $wpdb->get_results(
    $wpdb->prepare("SELECT id, email FROM {$wpdb->prefix}nh_leads WHERE status = %s", 'new')
);
```

### B. Function Arguments & Nullable Returns
Always document return types on filters:

```php
/**
 * @param array<string, mixed> $settings
 * @return array<string, mixed>
 */
function nh_core_filter_settings(array $settings): array {
    $settings['active'] = true;
    return $settings;
}
add_filter('nh_core/settings', 'nh_core_filter_settings');
```

---

## 4. Baselines for Legacy Codebases

When introducing PHPStan to an existing plugin without stopping current development to fix hundreds of legacy notices:

```bash
# Generate baseline file
vendor/bin/phpstan analyse --generate-baseline=phpstan-baseline.neon
```

Include it in `phpstan.neon`:
```neon
includes:
    - phpstan-baseline.neon
```
New code will be held to strict standards while existing code passes.
