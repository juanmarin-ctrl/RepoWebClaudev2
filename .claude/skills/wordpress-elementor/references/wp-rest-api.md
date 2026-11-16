# WordPress REST API Architecture & Best Practices

Use this reference when building, consuming, or exposing WordPress REST API routes, endpoints, and data contracts.

---

## 1. Route Registration (`register_rest_route`)

Always register routes within the `rest_api_init` action hook. Use semantic, versioned namespaces:

```php
add_action('rest_api_init', function() {
    register_rest_route('custom-app/v1', '/items/(?P<id>\d+)', [
        [
            'methods'             => \WP_REST_Server::READABLE, // 'GET'
            'callback'            => 'get_custom_item',
            'permission_callback' => 'check_read_permissions',
            'args'                => [
                'id' => [
                    'validate_callback' => function($param, $request, $key) {
                        return is_numeric($param);
                    },
                    'sanitize_callback' => 'absint',
                ],
            ],
        ],
        [
            'methods'             => \WP_REST_Server::CREATABLE, // 'POST'
            'callback'            => 'create_custom_item',
            'permission_callback' => 'check_write_permissions',
            'args'                => [
                'title' => [
                    'required'          => true,
                    'type'              => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
            ],
        ],
    ]);
});
```

---

## 2. Mandatory Permission Callbacks

WordPress REST API requires an explicit `permission_callback` for every route.
- **Rule**: Returning `__return_true` must be done only for intentionally public read-only endpoints.
- **Rule**: Never execute write actions without verifying capability and user context.

```php
function check_write_permissions($request) {
    if (!current_user_can('edit_posts')) {
        return new \WP_Error(
            'rest_forbidden',
            __('You do not have permission to perform this action.', 'textdomain'),
            ['status' => rest_authorization_required_code()]
        );
    }
    return true;
}
```

---

## 3. Exposing Custom Post Types & Meta in REST

To make Custom Post Types accessible via the standard `/wp/v2/` API (useful for Headless setups, frontends, or MCP tooling):

```php
register_post_type('portfolio', [
    'labels'       => ['name' => __('Portfolios', 'textdomain')],
    'public'       => true,
    'show_in_rest' => true, // Enables standard REST endpoints: /wp/v2/portfolio
    'rest_base'    => 'portfolios',
    'supports'     => ['title', 'editor', 'thumbnail', 'custom-fields'],
]);
```

### Exposing Post Meta to REST:
```php
register_post_meta('portfolio', 'client_name', [
    'show_in_rest' => true,
    'single'       => true,
    'type'         => 'string',
    'auth_callback' => function() {
        return current_user_can('edit_posts');
    },
]);
```

---

## 4. Response Shaping & Status Codes

Wrap return values in `\WP_REST_Response` to control HTTP status codes and headers:

```php
function get_custom_item($request) {
    $item_id = $request->get_param('id');
    $data = get_item_data($item_id);

    if (!$data) {
        return new \WP_Error('item_not_found', __('Item not found', 'textdomain'), ['status' => 404]);
    }

    $response = new \WP_REST_Response($data, 200);
    $response->header('X-Custom-Header', 'Value');
    return $response;
}
```

---

## 5. Integrating with EMCP Tools / Elementor REST

The EMCP Tools plugin exposes Elementor layout inspection, widget creation, and kit settings via REST endpoints under:
- `/wp-json/mcp/emcp-tools-server` (v3+)
- or standard WP REST routes when creating posts (`/wp/v2/pages`).

When querying page structure or post metadata via REST, check that `_elementor_edit_mode` is set to `builder` and `_elementor_data` contains valid JSON.
