# Gutenberg Block Development Guide

Use this reference when building or maintaining custom Gutenberg blocks, block attributes, server-side rendering, and deprecations.

---

## 1. Modern `block.json` (API v3)

Every block should be declared via `block.json`:

```json
{
  "$schema": "https://schemas.wp.org/trunk/block.json",
  "apiVersion": 3,
  "name": "nh-core/course-card",
  "version": "1.0.0",
  "title": "Course Card",
  "category": "widgets",
  "icon": "welcome-learn-more",
  "description": "Displays a branded course preview card.",
  "supports": {
    "html": false,
    "align": ["wide", "full"],
    "color": {
      "background": true,
      "text": true
    },
    "spacing": {
      "margin": true,
      "padding": true
    }
  },
  "textdomain": "nh-core",
  "attributes": {
    "courseId": {
      "type": "number",
      "default": 0
    },
    "showPrice": {
      "type": "boolean",
      "default": true
    }
  },
  "editorScript": "file:./index.js",
  "editorStyle": "file:./index.css",
  "style": "file:./style-index.css",
  "render": "file:./render.php"
}
```

Register the block in PHP via:
```php
add_action('init', function() {
    register_block_type(__DIR__ . '/build/course-card');
});
```

---

## 2. Dynamic Blocks vs Static Blocks

- **Dynamic Blocks (`render.php` or `render_callback`)**: Recommended for data-driven blocks (posts, courses, dynamic prices, user state). In `index.js`, `save: () => null`. Rendering is handled entirely in PHP on every request.
- **Static Blocks (`save: ({ attributes }) => ...`)**: Markup is serialized into `post_content` as HTML comments and markup (`<!-- wp:nh-core/course-card -->...<!-- /wp:nh-core/course-card -->`).

### Dynamic Block `render.php`:
```php
<?php
/**
 * @var array    $attributes Block attributes.
 * @var string   $content    Block inner content.
 * @var WP_Block $block      Block instance.
 */

$course_id  = $attributes['courseId'] ?? 0;
$show_price = $attributes['showPrice'] ?? true;
$wrapper_attributes = get_block_wrapper_attributes(['class' => 'nh-course-card']);
?>
<div <?php echo $wrapper_attributes; ?>>
    <h3><?php echo esc_html(get_the_title($course_id)); ?></h3>
    <?php if ($show_price) : ?>
        <span class="price"><?php echo esc_html(nh_core_get_price($course_id)); ?></span>
    <?php endif; ?>
</div>
```

---

## 3. InnerBlocks Pattern

To allow nesting arbitrary blocks or structured templates inside your block:

```jsx
// edit.js
import { useInnerBlocksProps, useBlockProps } from '@wordpress/block-editor';

const MY_TEMPLATE = [
    [ 'core/heading', { placeholder: 'Course Title', level: 3 } ],
    [ 'core/paragraph', { placeholder: 'Course short summary...' } ],
    [ 'core/button', { text: 'Enroll Now' } ]
];

export default function Edit() {
    const blockProps = useBlockProps();
    const innerBlocksProps = useInnerBlocksProps(blockProps, {
        template: MY_TEMPLATE,
        templateLock: false // or 'all' to prevent adding/removing
    });

    return <div { ...innerBlocksProps } />;
}
```

---

## 4. Block Deprecations (Never Break Existing Content)

When you modify the markup produced by a static block's `save()` function, existing posts will fail validation with:
`This block contains unexpected or invalid content.`

**Fix: Always provide a deprecation entry:**

```javascript
// deprecated.js
const v1 = {
    attributes: {
        title: { type: 'string', source: 'html', selector: 'h3' }
    },
    save({ attributes }) {
        return (
            <div className="legacy-card">
                <h3>{attributes.title}</h3>
            </div>
        );
    }
};

export default [ v1 ];
```

Include it in `index.js`:
```javascript
import deprecated from './deprecated';

registerBlockType(metadata.name, {
    edit: Edit,
    save: Save,
    deprecated
});
```

---

## 5. Tooling & Build Pipeline (`@wordpress/scripts`)

In `package.json`:
```json
{
  "scripts": {
    "start": "wp-scripts start",
    "build": "wp-scripts build",
    "lint:css": "wp-scripts lint-style",
    "lint:js": "wp-scripts lint-js"
  },
  "devDependencies": {
    "@wordpress/scripts": "^30.0.0"
  }
}
```
Run `npm run start` during development and `npm run build` for production distribution.
