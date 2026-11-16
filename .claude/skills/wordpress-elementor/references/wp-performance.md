# WordPress & Elementor Performance Optimization

This guide outlines performance measurement, caching strategies, and DOM reduction techniques specifically tailored for high-performance WordPress and Elementor environments.

---

## 1. Measurement First (Do Not Guess)

Never optimize without baseline measurements.

### A. Server-Timing & Query Monitor
- Install Query Monitor (`wp plugin install query-monitor --activate`).
- Inspect slow queries, duplicate queries, and object cache hit rates.
- Check database query count per page load. Target: under 50 queries for standard cached pages.

### B. Headless Query Inspection via WP-CLI
```bash
# Check size of autoloaded options (major cause of slow TTFB)
wp db query "SELECT SUM(LENGTH(option_value)) / 1024 / 1024 AS autoload_mb FROM wp_options WHERE autoload = 'yes';"

# Identify top 10 largest autoloaded options
wp db query "SELECT option_name, LENGTH(option_value) AS bytes FROM wp_options WHERE autoload = 'yes' ORDER BY bytes DESC LIMIT 10;"
```
If total autoload size exceeds 800 KB, clean up orphaned plugin settings and transients.

---

## 2. Elementor-Specific Performance Hardening

Elementor's historical reputation for DOM bloat is largely resolved by proper container architecture and feature configuration:

### A. Flexbox Containers over Legacy Sections
- Ensure Flexbox Containers experiment is active (`elementor_experiment-container = active`).
- **Never nest containers unnecessarily**:
  - Legacy pattern: Section > Column > Inner Section > Column > Widget (5 wrapper divs).
  - Modern pattern: Container (Row) > Widget (1 wrapper div).
- Keep total DOM elements under 800 per page where feasible.

### B. Disable Unused Elementor Features
In WP-CLI or Elementor Settings > Features:
```bash
# Enable CSS Print Method: External File (improves caching)
wp option update elementor_css_print_method "external"

# Enable Optimized Asset Loading & DOM Output
wp option update elementor_experiment-e_dom_optimization "active"
wp option update elementor_experiment-e_optimized_assets_loading "active"
wp option update elementor_experiment-e_optimized_css_loading "active"
```

### C. Image Optimization & Lazy Loading
- Use modern formats (WebP / AVIF).
- Explicit `width` and `height` attributes on images to prevent Cumulative Layout Shift (CLS).
- Never load unscaled full-resolution camera uploads into small badges or avatars.

---

## 3. Caching Architecture

### A. Object Caching (Redis / Memcached)
- In production, ensure an object cache drop-in (`wp-content/object-cache.php`) is active.
- Verify with:
  ```bash
  wp cache get test_key
  ```
- Store expensive calculations or remote API responses in object cache or transients:
  ```php
  $cache_key = 'my_expensive_query_' . $category_id;
  $data = wp_cache_get($cache_key, 'my_group');
  
  if (false === $data) {
      $data = run_expensive_calculation();
      wp_cache_set($cache_key, $data, 'my_group', 3600);
  }
  ```

### B. Transients API (Database Fallback)
```php
$stats = get_transient('weekly_sales_stats');
if (false === $stats) {
    $stats = calculate_sales();
    set_transient('weekly_sales_stats', $stats, DAY_IN_SECONDS);
}
```
Always invalidate transients on relevant post or option updates:
```php
add_action('save_post', function($post_id) {
    delete_transient('weekly_sales_stats');
});
```

---

## 4. Asset Management & Conditional Enqueueing

Dequeue heavy scripts on pages where they aren't needed:

```php
add_action('wp_enqueue_scripts', function() {
    // Only load form scripts on contact page
    if (!is_page('contact')) {
        wp_dequeue_script('google-recaptcha');
    }
}, 100);
```
