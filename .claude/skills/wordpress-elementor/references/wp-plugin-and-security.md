# WordPress Plugin Architecture & Security Standards

This guide defines the engineering conventions for building clean, maintainable, and secure WordPress plugins, custom post types, and extensions (including Elementor integrations).

---

## 1. Plugin Architecture & Bootstrap

Follow single-responsibility bootstrap principles:
- **Single Bootstrap File**: Main plugin file with standard WordPress header.
- **No Early Execution**: Do not execute database queries, instantiate heavy objects, or call API endpoints during file load. Wait for hooks.
- **Hook Lifecycle Order**:
  1. `plugins_loaded`: Early setup, text domain loading, checking active dependency plugins (e.g. Elementor, WooCommerce).
  2. `init`: Post type registration, taxonomy registration, rewrite rules, block registration.
  3. `rest_api_init`: REST API route registrations.
  4. `admin_init`: Admin-only settings, options registration, schema migrations.
  5. `wp_enqueue_scripts` / `admin_enqueue_scripts`: Style and script enqueues.

```php
<?php
/**
 * Plugin Name: Custom Elementor Extensions
 * Description: Custom widgets and business logic.
 * Version: 1.0.0
 * Author: Development Team
 * License: GPL-2.0-or-later
 */

defined('ABSPATH') || exit;

// Verify Elementor is loaded before hooking into Elementor APIs
add_action('plugins_loaded', function() {
    if (!did_action('elementor/loaded')) {
        return;
    }
    
    // Register custom Elementor widgets
    add_action('elementor/widgets/register', function($widgets_manager) {
        require_once __DIR__ . '/widgets/custom-card-widget.php';
        $widgets_manager->register(new \Custom_Card_Widget());
    });
});
```

---

## 2. Security Imperatives (Non-Negotiable)

Every WordPress plugin or endpoint must implement defensive security:

### A. Nonce Verification (CSRF Protection)
- In Admin Forms:
  ```php
  // Generate
  wp_nonce_field('my_custom_action_nonce', 'my_nonce_field');
  
  // Verify on POST
  if (!isset($_POST['my_nonce_field']) || !wp_verify_nonce(sanitize_key($_POST['my_nonce_field']), 'my_custom_action_nonce')) {
      wp_die(__('Invalid security token', 'textdomain'), 403);
  }
  ```
- In AJAX handlers:
  ```php
  check_ajax_referer('my_ajax_nonce_action', 'security');
  ```

### B. Authorization & Capability Checks
Never assume a user is authorized because they reached an admin URL:
```php
if (!current_user_can('manage_options')) {
    wp_die(__('Unauthorized action', 'textdomain'), 403);
}
```

### C. Input Sanitization (Before DB / Use)
Always unslash before sanitizing:
```php
$raw_title = wp_unslash($_POST['title'] ?? '');
$clean_title = sanitize_text_field($raw_title);

$clean_id = absint($_POST['item_id'] ?? 0);
$clean_url = esc_url_raw($_POST['website'] ?? '');
$clean_html = wp_kses_post(wp_unslash($_POST['content'] ?? ''));
```

### D. Output Escaping (At Time of Output)
Escape late, right before rendering:
```php
echo esc_html($user_name);
echo esc_attr($attribute_value);
echo esc_url($target_url);
echo wp_kses_post($rich_html);
```

### E. Safe SQL Queries (SQL Injection Prevention)
**NEVER concatenate variables directly into SQL queries.** Always use `$wpdb->prepare()`:
```php
global $wpdb;

// Correct: explicit type placeholders (%s = string, %d = integer, %f = float)
$post_title = $wpdb->get_var(
    $wpdb->prepare(
        "SELECT post_title FROM {$wpdb->posts} WHERE ID = %d AND post_status = %s",
        $post_id,
        'publish'
    )
);
```

---

## 3. Activation, Deactivation & Safe Uninstall

- **Activation Hook (`register_activation_hook`)**:
  - Run database migrations or initial option setup.
  - If registering CPTs, call `flush_rewrite_rules()` **only once** on activation.
- **Deactivation Hook (`register_deactivation_hook`)**:
  - Clear scheduled crons (`wp_clear_scheduled_hook`).
  - Flush rewrite rules.
  - **Do NOT delete user data on deactivation.**
- **Safe Uninstall (`uninstall.php`)**:
  - Only executed when user clicks "Delete" in the WordPress admin.
  - Verify constant `WP_UNINSTALL_PLUGIN` before running.
  - Clean up options, transients, and custom database tables.

```php
// uninstall.php
if (!defined('WP_UNINSTALL_PLUGIN')) {
    exit;
}

delete_option('my_custom_plugin_settings');
delete_transient('my_custom_cache_key');
```

---

## 4. Integration with Elementor APIs

When creating custom Elementor add-ons or extending widgets:
1. **Custom Widget Registration**: Hook into `elementor/widgets/register` and extend `\Elementor\Widget_Base`.
2. **Custom Controls**: Hook into `elementor/controls/register`.
3. **Dynamic Tags**: Hook into `elementor/dynamic_tags/register` and extend `\Elementor\Core\DynamicTags\Tag`.
4. **Theme Locations**: Hook into `elementor/theme/register_locations` to allow Elementor Pro Theme Builder to target custom header/footer areas.
