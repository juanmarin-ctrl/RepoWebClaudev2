# WordPress Core Plugin Architecture (nh-core, teducas-core)

When developing foundation plugins (such as `nh-core`, `teducas-core`) that power business logic, custom post types, integrations, and services across both Elementor and standard WordPress environments, follow these architectural standards.

---

## 1. Modular Architecture & Service Registry

Avoid putting business logic into procedural files or huge god-classes. Use a modular service-oriented architecture:

```
my-core/
├── my-core.php              # Main bootstrap & entrypoint
├── composer.json            # Autoloader & dependencies
├── includes/
│   ├── Plugin.php           # Singleton/Container orchestration
│   ├── PostTypes/           # CPT registrations (Courses, Services, Leads)
│   ├── Taxonomies/          # Custom taxonomy definitions
│   ├── Api/                 # REST API controllers & routes
│   ├── Integrations/
│   │   ├── Elementor/       # Widgets, Dynamic Tags, Forms webhooks
│   │   └── Gutenberg/       # Block registrations & server render
│   ├── Database/            # Migrations & custom table handling
│   └── Services/            # Business logic (Auth, Mailer, CRM sync)
└── assets/                  # CSS, JS, build output
```

### Clean Bootstrap Pattern:
```php
<?php
/**
 * Plugin Name: TEDUCAS Core
 * Plugin URI:  https://github.com/500Byte/teducas-core
 * Description: Core business logic, custom entities, and integrations.
 * Version:     1.16.2
 * Author:      Diego N. (@500Byte)
 * Text Domain: teducas-core
 */

namespace Teducas\Core;

defined('ABSPATH') || exit;

// Autoloader (Composer or PSR-4 fallback)
if (file_exists(__DIR__ . '/vendor/autoload.php')) {
    require_once __DIR__ . '/vendor/autoload.php';
}

final class Plugin {
    private static ?Plugin $instance = null;

    public static function instance(): Plugin {
        return self::$instance ??= new self();
    }

    private function __construct() {
        $this->init_hooks();
    }

    private function init_hooks(): void {
        add_action('plugins_loaded', [$this, 'on_plugins_loaded']);
        add_action('init', [$this, 'on_init']);
        add_action('rest_api_init', [$this, 'on_rest_api_init']);
    }

    public function on_plugins_loaded(): void {
        load_plugin_textdomain('nh-core', false, dirname(plugin_basename(__FILE__)) . '/languages');

        // Initialize Elementor integration only if Elementor is loaded
        if (did_action('elementor/loaded')) {
            Integrations\Elementor\Bootstrap::init();
        }
    }

    public function on_init(): void {
        PostTypes\CoursePostType::register();
        PostTypes\LeadPostType::register();
    }

    public function on_rest_api_init(): void {
        (new Api\LeadController())->register_routes();
    }
}

Plugin::instance();
```

---

## 2. Collision Avoidance & Prefixing Rules

Foundation plugins exist alongside many third-party plugins. Collisions cause fatal errors on production.

1. **PHP Namespaces**: Always use a unique top-level namespace (`namespace NH\Core;` or `namespace Teducas\Core;`).
2. **Global Functions**: If procedural helpers are needed, prefix them: `nh_core_get_option()`.
3. **Database Options & Transients**: Prefix option names: `nh_core_settings`, `_transient_nh_core_cache_*`.
4. **Action & Filter Hooks**: Always prefix custom hooks:
   ```php
   do_action('nh_core/lead/created', $lead_id, $lead_data);
   $price = apply_filters('nh_core/course/price', $price, $course_id);
   ```
5. **Enqueued Assets**: Prefix handles: `wp_enqueue_script('nh-core-checkout', ...)`.

---

## 3. Database Schema Versioning & Migrations

When your core plugin creates or modifies custom tables:

```php
const DB_VERSION = '1.0.2';

public static function check_migrations(): void {
    $current_version = get_option('nh_core_db_version', '0.0.0');

    if (version_compare($current_version, self::DB_VERSION, '<')) {
        self::run_migrations($current_version);
        update_option('nh_core_db_version', self::DB_VERSION);
    }
}

private static function run_migrations(string $from_version): void {
    global $wpdb;
    require_once ABSPATH . 'wp-admin/includes/upgrade.php';

    $charset_collate = $wpdb->get_charset_collate();
    $table_name = $wpdb->prefix . 'nh_leads';

    $sql = "CREATE TABLE {$table_name} (
        id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
        user_id bigint(20) unsigned NULL,
        email varchar(191) NOT NULL,
        status varchar(50) NOT NULL DEFAULT 'new',
        created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY  (id),
        KEY email (email),
        KEY status (status)
    ) {$charset_collate};";

    dbDelta($sql);
}
```

---

## 4. Bridging Elementor & Gutenberg in a Core Plugin

Foundation plugins frequently provide components to **both** page builders.

### A. Exposing Elementor Widgets & Dynamic Tags:
```php
namespace NH\Core\Integrations\Elementor;

class Bootstrap {
    public static function init(): void {
        // Register custom widgets
        add_action('elementor/widgets/register', function($widgets_manager) {
            $widgets_manager->register(new Widgets\CourseCardWidget());
        });

        // Register custom dynamic tags (e.g. course price, current member points)
        add_action('elementor/dynamic_tags/register', function($dynamic_tags_manager) {
            $dynamic_tags_manager->register(new Tags\MemberPointsTag());
        });
    }
}
```

### B. Exposing Gutenberg Blocks:
```php
namespace NH\Core\Integrations\Gutenberg;

class Bootstrap {
    public static function init(): void {
        add_action('init', function() {
            register_block_type(__DIR__ . '/build/course-summary');
        });
    }
}
```

---

## 5. Background Jobs & Asynchronous Tasks

For heavy operations (sending webhook batches, syncing external CRMs, regenerating assets):
- Do **NOT** run heavy synchronous operations during frontend page loads or form submissions.
- Use **Action Scheduler** (`as_enqueue_async_action` / `as_schedule_recurring_action`) or WP-Cron with transients to prevent execution timeout:
```php
// Enqueue background processing
as_enqueue_async_action('nh_core_sync_crm_lead', ['lead_id' => $lead_id]);

// Handle asynchronously
add_action('nh_core_sync_crm_lead', function($lead_id) {
    CRMClient::push_lead($lead_id);
});
```
