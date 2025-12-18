---
name: plugin-development
description: Develop WordPress plugins following best practices for plugin architecture, hooks system, admin interfaces, REST API, and WordPress coding standards. Use when building new plugins, adding plugin features, or fixing plugin issues.
---

# Plugin Development Skill

## Instructions

When developing WordPress plugins:

### 1. Plugin Structure

```
plugin-name/
├── assets/
│   ├── css/
│   ├── js/
│   └── images/
├── includes/
│   ├── class-plugin-name.php
│   ├── class-plugin-name-admin.php
│   ├── class-plugin-name-public.php
│   └── class-plugin-name-activator.php
├── admin/
│   ├── views/
│   └── partials/
├── public/
│   ├── views/
│   └── partials/
├── languages/
├── templates/
├── plugin-name.php
├── uninstall.php
└── readme.txt
```

### 2. Main Plugin File Header

```php
<?php
/**
 * Plugin Name:       Plugin Name
 * Plugin URI:        https://example.com/plugin
 * Description:       Short description of the plugin.
 * Version:           1.0.0
 * Requires at least: 6.0
 * Requires PHP:      8.0
 * Author:            Your Agency
 * Author URI:        https://youragency.com
 * License:           GPL v2 or later
 * License URI:       https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain:       plugin-name
 * Domain Path:       /languages
 */

if (!defined('ABSPATH')) {
    exit;
}

define('PLUGIN_NAME_VERSION', '1.0.0');
define('PLUGIN_NAME_PATH', plugin_dir_path(__FILE__));
define('PLUGIN_NAME_URL', plugin_dir_url(__FILE__));
```

### 3. OOP Plugin Architecture

```php
class Plugin_Name {
    private static $instance = null;

    public static function instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    private function __construct() {
        $this->load_dependencies();
        $this->set_hooks();
    }

    private function load_dependencies() {
        require_once PLUGIN_NAME_PATH . 'includes/class-admin.php';
        require_once PLUGIN_NAME_PATH . 'includes/class-public.php';
    }

    private function set_hooks() {
        add_action('init', [$this, 'init']);
        add_action('admin_menu', [$this, 'admin_menu']);
    }
}

// Initialize
Plugin_Name::instance();
```

### 4. Activation & Deactivation

```php
register_activation_hook(__FILE__, 'plugin_name_activate');
function plugin_name_activate() {
    // Create database tables
    // Set default options
    // Schedule cron jobs
    flush_rewrite_rules();
}

register_deactivation_hook(__FILE__, 'plugin_name_deactivate');
function plugin_name_deactivate() {
    // Clear scheduled hooks
    wp_clear_scheduled_hook('plugin_name_daily_event');
    flush_rewrite_rules();
}
```

### 5. Uninstall (uninstall.php)

```php
<?php
if (!defined('WP_UNINSTALL_PLUGIN')) {
    exit;
}

// Delete options
delete_option('plugin_name_settings');

// Delete custom tables
global $wpdb;
$wpdb->query("DROP TABLE IF EXISTS {$wpdb->prefix}plugin_name_table");

// Delete user meta
delete_metadata('user', 0, 'plugin_name_user_data', '', true);
```

### 6. Admin Settings Page

```php
function plugin_name_add_admin_menu() {
    add_menu_page(
        __('Plugin Name', 'plugin-name'),
        __('Plugin Name', 'plugin-name'),
        'manage_options',
        'plugin-name',
        'plugin_name_settings_page',
        'dashicons-admin-generic',
        30
    );
}
add_action('admin_menu', 'plugin_name_add_admin_menu');

function plugin_name_register_settings() {
    register_setting('plugin_name_settings', 'plugin_name_options', [
        'sanitize_callback' => 'plugin_name_sanitize_options',
    ]);
}
add_action('admin_init', 'plugin_name_register_settings');
```

### 7. REST API Endpoints

```php
add_action('rest_api_init', function() {
    register_rest_route('plugin-name/v1', '/items', [
        'methods' => 'GET',
        'callback' => 'plugin_name_get_items',
        'permission_callback' => function() {
            return current_user_can('edit_posts');
        },
    ]);
});

function plugin_name_get_items($request) {
    $items = get_option('plugin_name_items', []);
    return rest_ensure_response($items);
}
```

### 8. AJAX Handlers

```php
// Admin AJAX
add_action('wp_ajax_plugin_name_action', 'plugin_name_ajax_handler');
// Frontend AJAX (logged out users)
add_action('wp_ajax_nopriv_plugin_name_action', 'plugin_name_ajax_handler');

function plugin_name_ajax_handler() {
    check_ajax_referer('plugin_name_nonce', 'nonce');

    if (!current_user_can('edit_posts')) {
        wp_send_json_error('Unauthorized', 403);
    }

    $data = sanitize_text_field($_POST['data'] ?? '');

    // Process...

    wp_send_json_success(['result' => $data]);
}
```

### 9. Custom Post Types & Taxonomies

```php
function plugin_name_register_post_types() {
    register_post_type('portfolio', [
        'labels' => [
            'name' => __('Portfolio', 'plugin-name'),
            'singular_name' => __('Portfolio Item', 'plugin-name'),
        ],
        'public' => true,
        'has_archive' => true,
        'supports' => ['title', 'editor', 'thumbnail'],
        'show_in_rest' => true, // Gutenberg support
    ]);
}
add_action('init', 'plugin_name_register_post_types');
```

### 10. Security Checklist

- [ ] Verify nonces on all forms/AJAX
- [ ] Check user capabilities
- [ ] Sanitize all inputs
- [ ] Escape all outputs
- [ ] Use prepared statements for SQL
- [ ] Validate file uploads
- [ ] Prefix all globals, functions, classes

### 11. Performance Tips

- Lazy load assets (only on needed pages)
- Use transients for cached data
- Batch database operations
- Minimize autoload options
- Use object caching when available
