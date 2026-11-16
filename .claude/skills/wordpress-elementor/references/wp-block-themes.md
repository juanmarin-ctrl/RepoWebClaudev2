# WordPress Block Themes & theme.json Guide

Use this guide when creating, customizing, or auditing WordPress Block Themes (Full Site Editing / FSE) and `theme.json`.

---

## 1. Directory Structure of a Block Theme

```
my-block-theme/
├── theme.json               # Global styles, palette, typography, layout
├── style.css                # Theme metadata header
├── templates/
│   ├── index.html           # Fallback template
│   ├── single.html          # Single post
│   ├── page.html            # Standard page
│   └── 404.html             # 404 template
├── parts/
│   ├── header.html          # Header template part
│   └── footer.html          # Footer template part
├── patterns/                # Reusable block patterns (.php or .html)
│   └── hero.php
└── styles/                  # Style variations
    └── dark.json
```

---

## 2. Modern `theme.json` (Version 3)

```json
{
  "$schema": "https://schemas.wp.org/trunk/theme.json",
  "version": 3,
  "settings": {
    "appearanceTools": true,
    "layout": {
      "contentSize": "840px",
      "wideSize": "1200px"
    },
    "color": {
      "palette": [
        { "slug": "base", "color": "#ffffff", "name": "Base" },
        { "slug": "contrast", "color": "#111827", "name": "Contrast" },
        { "slug": "primary", "color": "#2563eb", "name": "Primary" },
        { "slug": "accent", "color": "#f59e0b", "name": "Accent" }
      ]
    },
    "typography": {
      "fontFamilies": [
        {
          "fontFamily": "Inter, sans-serif",
          "name": "Inter",
          "slug": "inter"
        }
      ],
      "fluid": true
    }
  },
  "styles": {
    "color": {
      "background": "var(--wp--preset--color--base)",
      "text": "var(--wp--preset--color--contrast)"
    },
    "typography": {
      "fontFamily": "var(--wp--preset--font-family--inter)",
      "lineHeight": "1.6"
    },
    "elements": {
      "button": {
        "color": {
          "background": "var(--wp--preset--color--primary)",
          "text": "var(--wp--preset--color--base)"
        },
        "border": {
          "radius": "6px"
        }
      }
    }
  }
}
```

---

## 3. Templates & Template Parts

Templates use HTML block comments representing core blocks:

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->

<!-- wp:group {"tagName":"main","layout":{"type":"constrained"}} -->
<main class="wp-block-group">
    <!-- wp:post-title {"level":1} /-->
    <!-- wp:post-content {"layout":{"type":"constrained"}} /-->
</main>
<!-- /wp:group -->

<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

---

## 4. Registering Block Patterns

Create a PHP file in the `patterns/` directory:

```php
<?php
/**
 * Title: Hero with Call to Action
 * Slug: my-theme/hero-cta
 * Categories: featured, banner
 * Description: High impact hero section with primary button.
 */
?>
<!-- wp:group {"align":"full","style":{"spacing":{"padding":{"top":"80px","bottom":"80px"}}},"backgroundColor":"contrast","textColor":"base","layout":{"type":"constrained"}} -->
<div class="wp-block-group alignfull has-base-color has-contrast-background-color has-text-color has-background" style="padding-top:80px;padding-bottom:80px">
    <!-- wp:heading {"textAlign":"center","level":1} -->
    <h1 class="wp-block-heading has-text-align-center">Build Faster with WordPress</h1>
    <!-- /wp:heading -->

    <!-- wp:paragraph {"align":"center"} -->
    <p class="has-text-align-center">Scalable architectures and elegant designs.</p>
    <!-- /wp:paragraph -->

    <!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"}} -->
    <div class="wp-block-buttons">
        <!-- wp:button -->
        <div class="wp-block-button"><a class="wp-block-button__link wp-element-button">Get Started</a></div>
        <!-- /wp:button -->
    </div>
    <!-- /wp:buttons -->
</div>
<!-- /wp:group -->
```
