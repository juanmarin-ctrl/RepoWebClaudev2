# WordPress Interactivity API Guide

The Interactivity API provides a reactive, state-driven standard for frontend client interactions in modern WordPress (introduced in WordPress 6.5+).

---

## 1. Core Architecture

The Interactivity API separates **HTML directives** from **JavaScript stores**:

1. Directives attach reactive behavior directly to HTML tags (`data-wp-*`).
2. Modules define global or local state and actions in client stores via `store()`.
3. Server-side rendering initializes state via `wp_interactivity_state()`.

---

## 2. Directives Quick Reference

| Directive | Purpose | Example |
|---|---|---|
| `data-wp-interactive` | Declares interactive namespace | `data-wp-interactive="nhCore"` |
| `data-wp-context` | Scoped local JSON state for an element and its subtree | `data-wp-context='{"isOpen": false}'` |
| `data-wp-bind--[attr]` | Binds element attribute to state | `data-wp-bind--aria-expanded="context.isOpen"` |
| `data-wp-class--[name]`| Toggles CSS class based on boolean state | `data-wp-class--is-active="context.isOpen"` |
| `data-wp-on--[event]` | Listens to DOM event and executes action | `data-wp-on--click="actions.toggleOpen"` |
| `data-wp-text` | Sets inner text reactively | `data-wp-text="state.cartCount"` |
| `data-wp-watch` | Runs a side-effect callback when dependencies change | `data-wp-watch="callbacks.logChange"` |

---

## 3. Server-Side State Initialization (PHP)

Set initial state in PHP before HTML reaches the browser to prevent layout shifts:

```php
add_action('init', function() {
    wp_interactivity_state('nhCore', [
        'cartCount' => 3,
        'userRole'  => is_user_logged_in() ? 'member' : 'guest',
    ]);
});
```

In the block's `render.php`:
```php
<div
    data-wp-interactive="nhCore"
    data-wp-context='{ "isOpen": false }'
    class="nh-accordion"
>
    <button
        data-wp-on--click="actions.toggleOpen"
        data-wp-bind--aria-expanded="context.isOpen"
    >
        Toggle Section
    </button>

    <div
        data-wp-class--is-visible="context.isOpen"
        class="nh-accordion-content"
    >
        <p>Active items in cart: <span data-wp-text="state.cartCount"></span></p>
    </div>
</div>
```

---

## 4. Client Store Definition (view.js)

Declare your module as an ES module using `@wordpress/interactivity`:

```javascript
import { store, getContext } from '@wordpress/interactivity';

store('nhCore', {
    state: {
        get isMember() {
            return store('nhCore').state.userRole === 'member';
        }
    },
    actions: {
        toggleOpen() {
            const context = getContext();
            context.isOpen = !context.isOpen;
        },
        addToCart() {
            const state = store('nhCore').state;
            state.cartCount += 1;
        }
    },
    callbacks: {
        logChange() {
            const context = getContext();
            console.log('Accordion state changed to:', context.isOpen);
        }
    }
});
```

---

## 5. Registering the Module

In `block.json`, specify `viewScriptModule`:

```json
{
  "name": "nh-core/accordion",
  "viewScriptModule": "file:./view.js"
}
```
*(Requires WordPress 6.5+ and `@wordpress/scripts` with module bundling support).*
