# Global color remapping & palette migration

Migrating an existing Elementor site to a new palette (rebrand, light→dark, or dark→light) is **not** a find-and-replace. Elementor stores colors in two independent layers that both need migrating:

1. **Kit globals** (`system_colors`, `custom_colors`) referenced through `settings.__globals__`.
2. **Literal hex values** baked into every element setting (often thousands).

The same token is routinely used as a background *and* as text on the same site. Blindly changing a token's value produces light text on light backgrounds. Audit first, remap by property, verify contrast last.

## 1. Audit before touching anything

Take a full backup of `_elementor_data` and `_elementor_page_settings`:

```php
global $wpdb;
$rows = $wpdb->get_results("SELECT post_id, meta_key, meta_value FROM {$wpdb->postmeta}
  WHERE meta_key IN ('_elementor_data','_elementor_page_settings')", ARRAY_A);
foreach ($rows as $r) echo $r['post_id']."\t".$r['meta_key']."\t".base64_encode($r['meta_value'])."\n";
```

Then build a **token × property** matrix. The property key is what decides whether a color is a background, border, or text:

```php
foreach ($rows as $r) {
  $d = json_decode($r['meta_value'], true);
  walk($d); // recursively collect: __globals__[prop] = "globals/colors?id=<token>"
}
```

Classify each usage:

| Property contains | Role |
|---|---|
| `background` | background |
| `border`, `divider` | border |
| `icon_secondary_color` (social icons) | **background** (counterintuitive) |
| everything else (`title_color`, `text_color`, `number_color`, `color`, `description_color`, `icon_color`, `link_color`, `button_text_color`, `hover_color`) | text |

If a token appears in more than one role it is a **conflict token**. Give it the value of its dominant role, then remap the minority role to a token with the right semantics.

## 2. Pick a dark palette with measured contrast

Example: dark palette built around an ocre brand (`#A67C61`):

| Role | Value | Notes |
|---|---|---|
| Page background | `#1E1710` | |
| Surface / cards | `#2A2118` | |
| Primary text | `#F5F0E6` | 15.6:1 on page bg |
| Muted text | `#C9BFB2` | 9.8:1 |
| Accent / brand | `#A67C61` | 4.79:1 on page bg, **4.27:1 on surface** |
| Accent on surface | `#C39D77` | 6.33:1 — use for small text on cards |
| Borders | `#4A3D30` | |
| Button label on accent | `#1E1710` | 4.79:1; white on ocre is only 3.7:1 |

Rule: `#A67C61` is safe for large text and UI on the page background, but not for normal text on surfaces. Switch those to the lighter bronze.

## 3. Remap `__globals__` by property

Operate on the raw JSON string and replace only the token after `colors?id=`, keeping the property key intact. This preserves every other byte and avoids re-encoding the whole document.

```php
function target($prop, $tok) {
  $isBg     = stripos($prop,'background') !== false || stripos($prop,'icon_secondary_color') !== false;
  $isBorder = stripos($prop,'border') !== false || stripos($prop,'divider') !== false;
  if ($isBg)     return bg_token($tok);      // light tokens -> dark background tokens
  if ($isBorder) return border_token($tok);  // light/dark -> border token
  return text_token($prop, $tok);            // dark tokens -> light text tokens
}

$new = preg_replace_callback(
  '~"([A-Za-z0-9_]+)":"globals\\\\/colors\?id=([A-Za-z0-9_-]+)"~',
  function ($m) { $t = target($m[1], $m[2]); return $t ? '"'.$m[1].'":"globals\\/colors?id='.$t.'"' : $m[0]; },
  $raw
);
```

Important details:
- The stored JSON contains escaped slashes: `globals\/colors?id=...`.
- `title_color` pointing at a background token → light text token.
- `description_color`/`text_color` → muted light token; `button_text_color` → brightest light token.
- `icon_secondary_color` on social icons is the **background**; `icon_primary_color` is the icon.

## 4. Remap literal hex values by the same property rules

Run a second pass over `"prop":"#RRGGBB"` pairs. Do not enumerate every dark hex; use luminance:

```php
function luminance($h) {
  $h = ltrim($h,'#');
  $c = [hexdec(substr($h,0,2))/255, hexdec(substr($h,2,2))/255, hexdec(substr($h,4,2))/255];
  $f = fn($v) => $v <= 0.03928 ? $v/12.92 : pow(($v+0.055)/1.055, 2.4);
  return 0.2126*$f($c[0]) + 0.7152*$f($c[1]) + 0.0722*$f($c[2]);
}
```

- Background property + luminance > 0.6 → dark background.
- Border property + light or dark hex → border color.
- Text property + luminance < 0.18 → light text (muted for body/description, bright for titles/buttons).
- Accent hexes map to the new brand accent explicitly.

Make the script idempotent: after a correct run, a dry-run must report 0 changes.

## 5. Persisting the changes: `update_post_meta` is not reliable

On managed hosting (GoDaddy, some object-cache drop-ins), `update_post_meta()` on `_elementor_data` can return `true` and **silently revert**. Observed symptom: `$wpdb` read-after-write returns the old string.

Use raw SQL plus cache invalidation:

```php
$wpdb->update($wpdb->postmeta, ['meta_value' => $new],
  ['post_id' => $id, 'meta_key' => '_elementor_data']);
wp_cache_delete($id, 'post_meta');
```

Store the JSON **unslashed** with `$wpdb->update`; do not pass it through `wp_slash()` here. Validate after writing:

```php
$ok = is_array(json_decode(get_post_meta($id, '_elementor_data', true), true));
```

## 6. CSS flush is a two-step operation

`wp elementor flush-css` alone often leaves stale files. Force a full rebuild:

```php
global $wpdb;
$wpdb->query("DELETE FROM {$wpdb->postmeta} WHERE meta_key='_elementor_css'");
foreach (glob(WP_CONTENT_DIR.'/uploads/elementor/css/*.css') as $f) @unlink($f);
```

Then `wp cache flush` and request the page once so Elementor regenerates its CSS.

## 7. Elementor CSS caches and specificity traps

- **Nested accordion (atomic, Elementor 4)**: title color comes from CSS variables `--n-accordion-title-normal-color`, `--n-accordion-title-hover-color`, `--n-accordion-title-active-color`, not from element settings. `widget-nested-accordion.min.css` defines them at the same specificity as a plain `.elementor-widget-n-accordion` rule and loads later, so a same-specificity override loses. Use `body .elementor-widget-n-accordion{...}`.
- **Social icons**: background uses the *primary* token and icon color the *secondary* token. Check the generated CSS before assuming which binding does what.
- **WooCommerce**: the gallery trigger and product tabs are styled by plugin rules with higher specificity (`.woocommerce div.product div.images .woocommerce-product-gallery__trigger`, `.woocommerce div.product .woocommerce-tabs ul.tabs li`). Match their selector or use a targeted `!important`.
- **Theme JSON / block styles** can also hardcode backgrounds. Changing the kit will not touch them.

## 8. Verify contrast with a real browser

Use `agent-browser eval` to walk visible text nodes, resolve the nearest non-transparent ancestor background, and compute WCAG contrast. Audit two thresholds: `<3` (hard failure) and `<4.5` (AA failure for normal text). Ignore decorative empty spans when classifying.

Also verify:
- `body` computed background and text colors changed.
- The old brand hex appears 0 times in the rendered HTML.
- At 1440 and 390 px there is no horizontal overflow.

## Checklist

- [ ] Backup `_elementor_data` + `_elementor_page_settings` (base64).
- [ ] Build token × property matrix; list conflict tokens.
- [ ] Set kit values by dominant role (IDs unchanged).
- [ ] Remap `__globals__` by property class.
- [ ] Remap literal hex by property class + luminance.
- [ ] Write with `$wpdb->update` + `wp_cache_delete`; validate JSON.
- [ ] Delete `_elementor_css` + CSS files; flush object cache.
- [ ] Fix atomic variables, social icons, WooCommerce with scoped CSS.
- [ ] Contrast audit <3 and <4.5 at desktop and mobile.
- [ ] Re-run the remap dry-run: 0 changes.
