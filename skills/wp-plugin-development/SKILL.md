---
name: wp-plugin-development
description: WordPress plugin development best practices and architecture. Use when building new plugins, adding plugin features, creating custom post types, registering REST APIs, implementing admin interfaces, or following WordPress coding standards, or when user mentions "plugin development", "custom plugin", "plugin architecture", "hooks system", "actions", "filters", "REST API", "admin page", "settings API", "custom post type", "taxonomies", or "plugin standards".
---

# WordPress Plugin Development Skill

## Overview

Comprehensive guide for developing WordPress plugins following best practices. Covers plugin architecture, hooks system, admin interfaces, REST API, database operations, and WordPress coding standards. **Core principle:** Build secure, performant, and maintainable plugins that integrate seamlessly with WordPress.

## When to Use

**Use when:**
- Building new WordPress plugins
- Adding features to existing plugins
- Creating custom post types and taxonomies
- Implementing REST API endpoints
- Building admin interfaces and settings pages
- Troubleshooting plugin issues

**Don't use for:**
- Theme development (use wp-theme-development)
- Block development specifically (use wp-gutenberg-blocks)
- Security auditing (use wp-security-review)

## Plugin Structure

### Recommended Directory Structure

```
plugin-name/
├── assets/
│   ├── css/
│   │   ├── admin.css
│   │   └── public.css
│   ├── js/
│   │   ├── admin.js
│   │   └── public.js
│   └── images/
├── includes/
│   ├── class-plugin-name.php           # Main plugin class
│   ├── class-plugin-name-loader.php    # Hook loader
│   ├── class-plugin-name-activator.php # Activation logic
│   ├── class-plugin-name-deactivator.php
│   ├── class-plugin-name-i18n.php      # Internationalization
│   └── functions.php                    # Helper functions
├── admin/
│   ├── class-plugin-name-admin.php     # Admin functionality
│   ├── views/
│   │   ├── admin-page.php
│   │   └── settings-page.php
│   └── partials/
├── public/
│   ├── class-plugin-name-public.php    # Public functionality
│   ├── views/
│   └── partials/
├── languages/
│   └── plugin-name.pot
├── templates/
│   └── template-parts/
├── vendor/                              # Composer dependencies
├── plugin-name.php                      # Main plugin file
├── uninstall.php                        # Cleanup on uninstall
├── readme.txt                           # WordPress.org readme
├── composer.json
└── package.json
```

## Main Plugin File

### Plugin Header

```php
<?php
/**
 * Plugin Name:       Plugin Name
 * Plugin URI:        https://example.com/plugin
 * Description:       A comprehensive description of the plugin functionality.
 * Version:           1.0.0
 * Requires at least: 6.0
 * Requires PHP:      8.0
 * Author:            Your Agency
 * Author URI:        https://youragency.com
 * License:           GPL v2 or later
 * License URI:       https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain:       plugin-name
 * Domain Path:       /languages
 * Update URI:        https://example.com/plugin-update
 *
 * @package Plugin_Name
 */

// Prevent direct access.
if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

// Plugin constants.
define( 'PLUGIN_NAME_VERSION', '1.0.0' );
define( 'PLUGIN_NAME_FILE', __FILE__ );
define( 'PLUGIN_NAME_PATH', plugin_dir_path( __FILE__ ) );
define( 'PLUGIN_NAME_URL', plugin_dir_url( __FILE__ ) );
define( 'PLUGIN_NAME_BASENAME', plugin_basename( __FILE__ ) );

// Autoloader.
require_once PLUGIN_NAME_PATH . 'vendor/autoload.php';

// Plugin activation/deactivation hooks.
register_activation_hook( __FILE__, array( 'Plugin_Name_Activator', 'activate' ) );
register_deactivation_hook( __FILE__, array( 'Plugin_Name_Deactivator', 'deactivate' ) );

// Initialize plugin.
function plugin_name_init() {
    return Plugin_Name::instance();
}
add_action( 'plugins_loaded', 'plugin_name_init' );
```

## Main Plugin Class (Singleton Pattern)

```php
<?php
/**
 * Main plugin class.
 *
 * @package Plugin_Name
 */

class Plugin_Name {

    /**
     * Single instance of the class.
     *
     * @var Plugin_Name
     */
    private static $instance = null;

    /**
     * Plugin loader.
     *
     * @var Plugin_Name_Loader
     */
    protected $loader;

    /**
     * Get single instance.
     *
     * @return Plugin_Name
     */
    public static function instance() {
        if ( null === self::$instance ) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * Constructor.
     */
    private function __construct() {
        $this->load_dependencies();
        $this->set_locale();
        $this->define_admin_hooks();
        $this->define_public_hooks();
        $this->define_rest_api();
        $this->run();
    }

    /**
     * Load dependencies.
     */
    private function load_dependencies() {
        require_once PLUGIN_NAME_PATH . 'includes/class-plugin-name-loader.php';
        require_once PLUGIN_NAME_PATH . 'includes/class-plugin-name-i18n.php';
        require_once PLUGIN_NAME_PATH . 'admin/class-plugin-name-admin.php';
        require_once PLUGIN_NAME_PATH . 'public/class-plugin-name-public.php';

        $this->loader = new Plugin_Name_Loader();
    }

    /**
     * Set locale for internationalization.
     */
    private function set_locale() {
        $i18n = new Plugin_Name_I18n();
        $this->loader->add_action( 'plugins_loaded', $i18n, 'load_plugin_textdomain' );
    }

    /**
     * Register admin hooks.
     */
    private function define_admin_hooks() {
        $admin = new Plugin_Name_Admin();

        // Admin scripts and styles.
        $this->loader->add_action( 'admin_enqueue_scripts', $admin, 'enqueue_styles' );
        $this->loader->add_action( 'admin_enqueue_scripts', $admin, 'enqueue_scripts' );

        // Admin menu.
        $this->loader->add_action( 'admin_menu', $admin, 'add_admin_menu' );

        // Settings.
        $this->loader->add_action( 'admin_init', $admin, 'register_settings' );

        // AJAX handlers.
        $this->loader->add_action( 'wp_ajax_plugin_name_action', $admin, 'ajax_handler' );
    }

    /**
     * Register public hooks.
     */
    private function define_public_hooks() {
        $public = new Plugin_Name_Public();

        $this->loader->add_action( 'wp_enqueue_scripts', $public, 'enqueue_styles' );
        $this->loader->add_action( 'wp_enqueue_scripts', $public, 'enqueue_scripts' );

        // Shortcodes.
        $this->loader->add_action( 'init', $public, 'register_shortcodes' );
    }

    /**
     * Register REST API endpoints.
     */
    private function define_rest_api() {
        $this->loader->add_action( 'rest_api_init', $this, 'register_rest_routes' );
    }

    /**
     * Register REST routes.
     */
    public function register_rest_routes() {
        register_rest_route(
            'plugin-name/v1',
            '/items',
            array(
                array(
                    'methods'             => WP_REST_Server::READABLE,
                    'callback'            => array( $this, 'get_items' ),
                    'permission_callback' => array( $this, 'get_items_permissions_check' ),
                ),
                array(
                    'methods'             => WP_REST_Server::CREATABLE,
                    'callback'            => array( $this, 'create_item' ),
                    'permission_callback' => array( $this, 'create_item_permissions_check' ),
                    'args'                => $this->get_item_schema(),
                ),
            )
        );
    }

    /**
     * Run the loader.
     */
    public function run() {
        $this->loader->run();
    }
}
```

## Activation & Deactivation

### Activator Class

```php
<?php
/**
 * Plugin activation handler.
 *
 * @package Plugin_Name
 */

class Plugin_Name_Activator {

    /**
     * Activation hook callback.
     */
    public static function activate() {
        // Check PHP version.
        if ( version_compare( PHP_VERSION, '8.0', '<' ) ) {
            deactivate_plugins( PLUGIN_NAME_BASENAME );
            wp_die(
                esc_html__( 'This plugin requires PHP 8.0 or higher.', 'plugin-name' ),
                'Plugin Activation Error',
                array( 'back_link' => true )
            );
        }

        // Check WordPress version.
        if ( version_compare( get_bloginfo( 'version' ), '6.0', '<' ) ) {
            deactivate_plugins( PLUGIN_NAME_BASENAME );
            wp_die(
                esc_html__( 'This plugin requires WordPress 6.0 or higher.', 'plugin-name' ),
                'Plugin Activation Error',
                array( 'back_link' => true )
            );
        }

        // Create custom database tables.
        self::create_tables();

        // Set default options.
        self::set_default_options();

        // Schedule cron events.
        self::schedule_events();

        // Flush rewrite rules.
        flush_rewrite_rules();

        // Set activation flag for welcome screen.
        set_transient( 'plugin_name_activated', true, 30 );
    }

    /**
     * Create custom database tables.
     */
    private static function create_tables() {
        global $wpdb;

        $charset_collate = $wpdb->get_charset_collate();
        $table_name      = $wpdb->prefix . 'plugin_name_data';

        $sql = "CREATE TABLE IF NOT EXISTS $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            user_id bigint(20) unsigned NOT NULL,
            title varchar(255) NOT NULL,
            content longtext,
            status varchar(20) DEFAULT 'draft',
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY status (status)
        ) $charset_collate;";

        require_once ABSPATH . 'wp-admin/includes/upgrade.php';
        dbDelta( $sql );

        // Store database version.
        update_option( 'plugin_name_db_version', PLUGIN_NAME_VERSION );
    }

    /**
     * Set default plugin options.
     */
    private static function set_default_options() {
        $defaults = array(
            'enabled'       => true,
            'items_per_page' => 10,
            'cache_duration' => 3600,
        );

        if ( false === get_option( 'plugin_name_settings' ) ) {
            add_option( 'plugin_name_settings', $defaults );
        }
    }

    /**
     * Schedule cron events.
     */
    private static function schedule_events() {
        if ( ! wp_next_scheduled( 'plugin_name_daily_cleanup' ) ) {
            wp_schedule_event( time(), 'daily', 'plugin_name_daily_cleanup' );
        }
    }
}
```

### Deactivator Class

```php
<?php
/**
 * Plugin deactivation handler.
 *
 * @package Plugin_Name
 */

class Plugin_Name_Deactivator {

    /**
     * Deactivation hook callback.
     */
    public static function deactivate() {
        // Clear scheduled events.
        $timestamp = wp_next_scheduled( 'plugin_name_daily_cleanup' );
        if ( $timestamp ) {
            wp_unschedule_event( $timestamp, 'plugin_name_daily_cleanup' );
        }

        // Flush rewrite rules.
        flush_rewrite_rules();

        // Clear transients.
        delete_transient( 'plugin_name_cache' );
    }
}
```

### Uninstall (uninstall.php)

```php
<?php
/**
 * Plugin uninstall handler.
 *
 * @package Plugin_Name
 */

// Exit if not uninstalling.
if ( ! defined( 'WP_UNINSTALL_PLUGIN' ) ) {
    exit;
}

// Delete options.
delete_option( 'plugin_name_settings' );
delete_option( 'plugin_name_db_version' );

// Delete transients.
delete_transient( 'plugin_name_cache' );

// Delete custom tables.
global $wpdb;
$wpdb->query( "DROP TABLE IF EXISTS {$wpdb->prefix}plugin_name_data" );

// Delete user meta.
delete_metadata( 'user', 0, 'plugin_name_preferences', '', true );

// Delete post meta.
delete_post_meta_by_key( 'plugin_name_meta' );

// Clear any scheduled events.
wp_clear_scheduled_hook( 'plugin_name_daily_cleanup' );

// Clean up any uploaded files.
$upload_dir = wp_upload_dir();
$plugin_dir = $upload_dir['basedir'] . '/plugin-name';
if ( is_dir( $plugin_dir ) ) {
    // Use WP_Filesystem for file operations.
    global $wp_filesystem;
    WP_Filesystem();
    $wp_filesystem->rmdir( $plugin_dir, true );
}
```

## Admin Settings Page

### Admin Class

```php
<?php
/**
 * Admin functionality.
 *
 * @package Plugin_Name
 */

class Plugin_Name_Admin {

    /**
     * Enqueue admin styles.
     *
     * @param string $hook Current admin page hook.
     */
    public function enqueue_styles( $hook ) {
        // Only load on plugin pages.
        if ( false === strpos( $hook, 'plugin-name' ) ) {
            return;
        }

        wp_enqueue_style(
            'plugin-name-admin',
            PLUGIN_NAME_URL . 'assets/css/admin.css',
            array(),
            PLUGIN_NAME_VERSION
        );
    }

    /**
     * Enqueue admin scripts.
     *
     * @param string $hook Current admin page hook.
     */
    public function enqueue_scripts( $hook ) {
        if ( false === strpos( $hook, 'plugin-name' ) ) {
            return;
        }

        wp_enqueue_script(
            'plugin-name-admin',
            PLUGIN_NAME_URL . 'assets/js/admin.js',
            array( 'jquery' ),
            PLUGIN_NAME_VERSION,
            true
        );

        wp_localize_script(
            'plugin-name-admin',
            'pluginNameAdmin',
            array(
                'ajaxUrl' => admin_url( 'admin-ajax.php' ),
                'nonce'   => wp_create_nonce( 'plugin_name_admin_nonce' ),
                'strings' => array(
                    'confirmDelete' => esc_html__( 'Are you sure?', 'plugin-name' ),
                    'saving'        => esc_html__( 'Saving...', 'plugin-name' ),
                    'saved'         => esc_html__( 'Saved!', 'plugin-name' ),
                ),
            )
        );
    }

    /**
     * Add admin menu pages.
     */
    public function add_admin_menu() {
        // Main menu page.
        add_menu_page(
            esc_html__( 'Plugin Name', 'plugin-name' ),
            esc_html__( 'Plugin Name', 'plugin-name' ),
            'manage_options',
            'plugin-name',
            array( $this, 'render_main_page' ),
            'dashicons-admin-generic',
            30
        );

        // Submenu: Dashboard.
        add_submenu_page(
            'plugin-name',
            esc_html__( 'Dashboard', 'plugin-name' ),
            esc_html__( 'Dashboard', 'plugin-name' ),
            'manage_options',
            'plugin-name',
            array( $this, 'render_main_page' )
        );

        // Submenu: Settings.
        add_submenu_page(
            'plugin-name',
            esc_html__( 'Settings', 'plugin-name' ),
            esc_html__( 'Settings', 'plugin-name' ),
            'manage_options',
            'plugin-name-settings',
            array( $this, 'render_settings_page' )
        );
    }

    /**
     * Register settings.
     */
    public function register_settings() {
        register_setting(
            'plugin_name_settings_group',
            'plugin_name_settings',
            array(
                'type'              => 'array',
                'sanitize_callback' => array( $this, 'sanitize_settings' ),
                'default'           => array(),
            )
        );

        // General Settings Section.
        add_settings_section(
            'plugin_name_general',
            esc_html__( 'General Settings', 'plugin-name' ),
            array( $this, 'render_general_section' ),
            'plugin-name-settings'
        );

        // Enable Feature Field.
        add_settings_field(
            'enabled',
            esc_html__( 'Enable Feature', 'plugin-name' ),
            array( $this, 'render_checkbox_field' ),
            'plugin-name-settings',
            'plugin_name_general',
            array(
                'label_for'   => 'enabled',
                'description' => esc_html__( 'Enable the main feature.', 'plugin-name' ),
            )
        );

        // Items Per Page Field.
        add_settings_field(
            'items_per_page',
            esc_html__( 'Items Per Page', 'plugin-name' ),
            array( $this, 'render_number_field' ),
            'plugin-name-settings',
            'plugin_name_general',
            array(
                'label_for'   => 'items_per_page',
                'min'         => 1,
                'max'         => 100,
                'description' => esc_html__( 'Number of items to display per page.', 'plugin-name' ),
            )
        );
    }

    /**
     * Sanitize settings.
     *
     * @param array $input Raw input.
     * @return array Sanitized input.
     */
    public function sanitize_settings( $input ) {
        $sanitized = array();

        if ( isset( $input['enabled'] ) ) {
            $sanitized['enabled'] = (bool) $input['enabled'];
        }

        if ( isset( $input['items_per_page'] ) ) {
            $sanitized['items_per_page'] = absint( $input['items_per_page'] );
            $sanitized['items_per_page'] = max( 1, min( 100, $sanitized['items_per_page'] ) );
        }

        return $sanitized;
    }

    /**
     * Render checkbox field.
     *
     * @param array $args Field arguments.
     */
    public function render_checkbox_field( $args ) {
        $options = get_option( 'plugin_name_settings' );
        $value   = isset( $options[ $args['label_for'] ] ) ? $options[ $args['label_for'] ] : false;
        ?>
        <input
            type="checkbox"
            id="<?php echo esc_attr( $args['label_for'] ); ?>"
            name="plugin_name_settings[<?php echo esc_attr( $args['label_for'] ); ?>]"
            value="1"
            <?php checked( $value, true ); ?>
        >
        <?php if ( ! empty( $args['description'] ) ) : ?>
            <p class="description"><?php echo esc_html( $args['description'] ); ?></p>
        <?php endif; ?>
        <?php
    }

    /**
     * Render number field.
     *
     * @param array $args Field arguments.
     */
    public function render_number_field( $args ) {
        $options = get_option( 'plugin_name_settings' );
        $value   = isset( $options[ $args['label_for'] ] ) ? $options[ $args['label_for'] ] : '';
        ?>
        <input
            type="number"
            id="<?php echo esc_attr( $args['label_for'] ); ?>"
            name="plugin_name_settings[<?php echo esc_attr( $args['label_for'] ); ?>]"
            value="<?php echo esc_attr( $value ); ?>"
            min="<?php echo esc_attr( $args['min'] ?? '' ); ?>"
            max="<?php echo esc_attr( $args['max'] ?? '' ); ?>"
            class="small-text"
        >
        <?php if ( ! empty( $args['description'] ) ) : ?>
            <p class="description"><?php echo esc_html( $args['description'] ); ?></p>
        <?php endif; ?>
        <?php
    }

    /**
     * Render settings page.
     */
    public function render_settings_page() {
        if ( ! current_user_can( 'manage_options' ) ) {
            return;
        }
        ?>
        <div class="wrap">
            <h1><?php echo esc_html( get_admin_page_title() ); ?></h1>

            <form action="options.php" method="post">
                <?php
                settings_fields( 'plugin_name_settings_group' );
                do_settings_sections( 'plugin-name-settings' );
                submit_button();
                ?>
            </form>
        </div>
        <?php
    }

    /**
     * AJAX handler.
     */
    public function ajax_handler() {
        check_ajax_referer( 'plugin_name_admin_nonce', 'nonce' );

        if ( ! current_user_can( 'manage_options' ) ) {
            wp_send_json_error(
                array( 'message' => esc_html__( 'Unauthorized', 'plugin-name' ) ),
                403
            );
        }

        $action = isset( $_POST['plugin_action'] ) ? sanitize_text_field( wp_unslash( $_POST['plugin_action'] ) ) : '';

        switch ( $action ) {
            case 'save_item':
                $result = $this->save_item( $_POST );
                break;
            case 'delete_item':
                $result = $this->delete_item( $_POST );
                break;
            default:
                wp_send_json_error( array( 'message' => esc_html__( 'Invalid action', 'plugin-name' ) ) );
        }

        if ( is_wp_error( $result ) ) {
            wp_send_json_error( array( 'message' => $result->get_error_message() ) );
        }

        wp_send_json_success( $result );
    }
}
```

## Custom Post Types & Taxonomies

```php
<?php
/**
 * Register custom post types and taxonomies.
 *
 * @package Plugin_Name
 */

class Plugin_Name_Post_Types {

    /**
     * Register custom post types.
     */
    public function register_post_types() {
        $labels = array(
            'name'                  => _x( 'Projects', 'Post type general name', 'plugin-name' ),
            'singular_name'         => _x( 'Project', 'Post type singular name', 'plugin-name' ),
            'menu_name'             => _x( 'Projects', 'Admin Menu text', 'plugin-name' ),
            'add_new'               => __( 'Add New', 'plugin-name' ),
            'add_new_item'          => __( 'Add New Project', 'plugin-name' ),
            'edit_item'             => __( 'Edit Project', 'plugin-name' ),
            'new_item'              => __( 'New Project', 'plugin-name' ),
            'view_item'             => __( 'View Project', 'plugin-name' ),
            'view_items'            => __( 'View Projects', 'plugin-name' ),
            'search_items'          => __( 'Search Projects', 'plugin-name' ),
            'not_found'             => __( 'No projects found.', 'plugin-name' ),
            'not_found_in_trash'    => __( 'No projects found in Trash.', 'plugin-name' ),
            'all_items'             => __( 'All Projects', 'plugin-name' ),
            'archives'              => __( 'Project Archives', 'plugin-name' ),
            'attributes'            => __( 'Project Attributes', 'plugin-name' ),
            'insert_into_item'      => __( 'Insert into project', 'plugin-name' ),
            'uploaded_to_this_item' => __( 'Uploaded to this project', 'plugin-name' ),
            'featured_image'        => _x( 'Featured Image', 'project', 'plugin-name' ),
            'set_featured_image'    => _x( 'Set featured image', 'project', 'plugin-name' ),
            'remove_featured_image' => _x( 'Remove featured image', 'project', 'plugin-name' ),
            'use_featured_image'    => _x( 'Use as featured image', 'project', 'plugin-name' ),
            'filter_items_list'     => __( 'Filter projects list', 'plugin-name' ),
            'items_list_navigation' => __( 'Projects list navigation', 'plugin-name' ),
            'items_list'            => __( 'Projects list', 'plugin-name' ),
        );

        $args = array(
            'labels'              => $labels,
            'public'              => true,
            'publicly_queryable'  => true,
            'show_ui'             => true,
            'show_in_menu'        => true,
            'show_in_nav_menus'   => true,
            'show_in_admin_bar'   => true,
            'show_in_rest'        => true, // Enable Gutenberg editor.
            'rest_base'           => 'projects',
            'menu_position'       => 25,
            'menu_icon'           => 'dashicons-portfolio',
            'capability_type'     => 'post',
            'hierarchical'        => false,
            'supports'            => array(
                'title',
                'editor',
                'author',
                'thumbnail',
                'excerpt',
                'comments',
                'revisions',
                'custom-fields',
            ),
            'has_archive'         => true,
            'rewrite'             => array(
                'slug'       => 'projects',
                'with_front' => false,
            ),
            'query_var'           => true,
            'can_export'          => true,
            'delete_with_user'    => false,
            'template'            => array(
                array( 'core/paragraph', array( 'placeholder' => __( 'Project description...', 'plugin-name' ) ) ),
            ),
            'template_lock'       => false,
        );

        register_post_type( 'project', $args );
    }

    /**
     * Register custom taxonomies.
     */
    public function register_taxonomies() {
        // Project Category taxonomy.
        $labels = array(
            'name'                       => _x( 'Categories', 'taxonomy general name', 'plugin-name' ),
            'singular_name'              => _x( 'Category', 'taxonomy singular name', 'plugin-name' ),
            'search_items'               => __( 'Search Categories', 'plugin-name' ),
            'popular_items'              => __( 'Popular Categories', 'plugin-name' ),
            'all_items'                  => __( 'All Categories', 'plugin-name' ),
            'parent_item'                => __( 'Parent Category', 'plugin-name' ),
            'parent_item_colon'          => __( 'Parent Category:', 'plugin-name' ),
            'edit_item'                  => __( 'Edit Category', 'plugin-name' ),
            'view_item'                  => __( 'View Category', 'plugin-name' ),
            'update_item'                => __( 'Update Category', 'plugin-name' ),
            'add_new_item'               => __( 'Add New Category', 'plugin-name' ),
            'new_item_name'              => __( 'New Category Name', 'plugin-name' ),
            'separate_items_with_commas' => __( 'Separate categories with commas', 'plugin-name' ),
            'add_or_remove_items'        => __( 'Add or remove categories', 'plugin-name' ),
            'choose_from_most_used'      => __( 'Choose from the most used categories', 'plugin-name' ),
            'not_found'                  => __( 'No categories found.', 'plugin-name' ),
            'no_terms'                   => __( 'No categories', 'plugin-name' ),
            'items_list_navigation'      => __( 'Categories list navigation', 'plugin-name' ),
            'items_list'                 => __( 'Categories list', 'plugin-name' ),
            'back_to_items'              => __( '&larr; Back to Categories', 'plugin-name' ),
        );

        $args = array(
            'labels'              => $labels,
            'public'              => true,
            'publicly_queryable'  => true,
            'show_ui'             => true,
            'show_in_menu'        => true,
            'show_in_nav_menus'   => true,
            'show_in_rest'        => true,
            'rest_base'           => 'project-categories',
            'show_tagcloud'       => true,
            'show_in_quick_edit'  => true,
            'show_admin_column'   => true,
            'hierarchical'        => true,
            'rewrite'             => array(
                'slug'         => 'project-category',
                'with_front'   => false,
                'hierarchical' => true,
            ),
            'query_var'           => true,
        );

        register_taxonomy( 'project_category', array( 'project' ), $args );
    }
}

// Register on init.
add_action( 'init', array( new Plugin_Name_Post_Types(), 'register_post_types' ) );
add_action( 'init', array( new Plugin_Name_Post_Types(), 'register_taxonomies' ) );
```

## REST API Endpoints

```php
<?php
/**
 * REST API functionality.
 *
 * @package Plugin_Name
 */

class Plugin_Name_REST_API {

    /**
     * Namespace.
     *
     * @var string
     */
    protected $namespace = 'plugin-name/v1';

    /**
     * Register routes.
     */
    public function register_routes() {
        // Get/Create items.
        register_rest_route(
            $this->namespace,
            '/items',
            array(
                array(
                    'methods'             => WP_REST_Server::READABLE,
                    'callback'            => array( $this, 'get_items' ),
                    'permission_callback' => array( $this, 'get_items_permissions_check' ),
                    'args'                => $this->get_collection_params(),
                ),
                array(
                    'methods'             => WP_REST_Server::CREATABLE,
                    'callback'            => array( $this, 'create_item' ),
                    'permission_callback' => array( $this, 'create_item_permissions_check' ),
                    'args'                => $this->get_endpoint_args_for_item_schema( WP_REST_Server::CREATABLE ),
                ),
                'schema' => array( $this, 'get_public_item_schema' ),
            )
        );

        // Get/Update/Delete single item.
        register_rest_route(
            $this->namespace,
            '/items/(?P<id>[\d]+)',
            array(
                array(
                    'methods'             => WP_REST_Server::READABLE,
                    'callback'            => array( $this, 'get_item' ),
                    'permission_callback' => array( $this, 'get_item_permissions_check' ),
                    'args'                => array(
                        'id' => array(
                            'description' => __( 'Unique identifier for the item.', 'plugin-name' ),
                            'type'        => 'integer',
                            'required'    => true,
                        ),
                    ),
                ),
                array(
                    'methods'             => WP_REST_Server::EDITABLE,
                    'callback'            => array( $this, 'update_item' ),
                    'permission_callback' => array( $this, 'update_item_permissions_check' ),
                    'args'                => $this->get_endpoint_args_for_item_schema( WP_REST_Server::EDITABLE ),
                ),
                array(
                    'methods'             => WP_REST_Server::DELETABLE,
                    'callback'            => array( $this, 'delete_item' ),
                    'permission_callback' => array( $this, 'delete_item_permissions_check' ),
                ),
                'schema' => array( $this, 'get_public_item_schema' ),
            )
        );
    }

    /**
     * Check if user can read items.
     *
     * @param WP_REST_Request $request Request object.
     * @return bool|WP_Error
     */
    public function get_items_permissions_check( $request ) {
        return current_user_can( 'read' );
    }

    /**
     * Check if user can create items.
     *
     * @param WP_REST_Request $request Request object.
     * @return bool|WP_Error
     */
    public function create_item_permissions_check( $request ) {
        return current_user_can( 'edit_posts' );
    }

    /**
     * Get items.
     *
     * @param WP_REST_Request $request Request object.
     * @return WP_REST_Response|WP_Error
     */
    public function get_items( $request ) {
        $per_page = $request->get_param( 'per_page' ) ?? 10;
        $page     = $request->get_param( 'page' ) ?? 1;

        global $wpdb;
        $table_name = $wpdb->prefix . 'plugin_name_data';

        $items = $wpdb->get_results(
            $wpdb->prepare(
                "SELECT * FROM $table_name ORDER BY created_at DESC LIMIT %d OFFSET %d",
                $per_page,
                ( $page - 1 ) * $per_page
            )
        );

        $total = $wpdb->get_var( "SELECT COUNT(*) FROM $table_name" );

        $response = rest_ensure_response( $items );
        $response->header( 'X-WP-Total', $total );
        $response->header( 'X-WP-TotalPages', ceil( $total / $per_page ) );

        return $response;
    }

    /**
     * Create item.
     *
     * @param WP_REST_Request $request Request object.
     * @return WP_REST_Response|WP_Error
     */
    public function create_item( $request ) {
        global $wpdb;
        $table_name = $wpdb->prefix . 'plugin_name_data';

        $data = array(
            'user_id' => get_current_user_id(),
            'title'   => sanitize_text_field( $request->get_param( 'title' ) ),
            'content' => wp_kses_post( $request->get_param( 'content' ) ),
            'status'  => sanitize_key( $request->get_param( 'status' ) ?? 'draft' ),
        );

        $result = $wpdb->insert( $table_name, $data, array( '%d', '%s', '%s', '%s' ) );

        if ( false === $result ) {
            return new WP_Error(
                'insert_failed',
                __( 'Failed to create item.', 'plugin-name' ),
                array( 'status' => 500 )
            );
        }

        $item = $wpdb->get_row(
            $wpdb->prepare( "SELECT * FROM $table_name WHERE id = %d", $wpdb->insert_id )
        );

        return rest_ensure_response( $item );
    }

    /**
     * Get item schema.
     *
     * @return array
     */
    public function get_public_item_schema() {
        return array(
            '$schema'    => 'http://json-schema.org/draft-04/schema#',
            'title'      => 'plugin_name_item',
            'type'       => 'object',
            'properties' => array(
                'id'         => array(
                    'description' => __( 'Unique identifier for the item.', 'plugin-name' ),
                    'type'        => 'integer',
                    'readonly'    => true,
                ),
                'title'      => array(
                    'description' => __( 'The title for the item.', 'plugin-name' ),
                    'type'        => 'string',
                    'required'    => true,
                ),
                'content'    => array(
                    'description' => __( 'The content for the item.', 'plugin-name' ),
                    'type'        => 'string',
                ),
                'status'     => array(
                    'description' => __( 'The status for the item.', 'plugin-name' ),
                    'type'        => 'string',
                    'enum'        => array( 'draft', 'published', 'archived' ),
                    'default'     => 'draft',
                ),
                'created_at' => array(
                    'description' => __( 'The date the item was created.', 'plugin-name' ),
                    'type'        => 'string',
                    'format'      => 'date-time',
                    'readonly'    => true,
                ),
            ),
        );
    }
}
```

## Hooks System

### Actions and Filters

```php
// ❌ BAD: Hardcoded values, not extensible.
function get_items_per_page() {
    return 10;
}

// ✅ GOOD: Allow filtering.
function get_items_per_page() {
    return apply_filters( 'plugin_name_items_per_page', 10 );
}

// ❌ BAD: No action hooks for extensibility.
function process_order( $order ) {
    save_order( $order );
    send_email( $order );
}

// ✅ GOOD: Add action hooks.
function process_order( $order ) {
    do_action( 'plugin_name_before_process_order', $order );

    save_order( $order );

    do_action( 'plugin_name_order_saved', $order );

    send_email( $order );

    do_action( 'plugin_name_after_process_order', $order );
}

// ✅ GOOD: Filter output before returning.
function get_formatted_price( $price ) {
    $formatted = number_format( $price, 2 );
    return apply_filters( 'plugin_name_formatted_price', $formatted, $price );
}

// ✅ GOOD: Custom hook with multiple parameters.
do_action( 'plugin_name_item_created', $item_id, $item_data, $user_id );

// ✅ GOOD: Filter with default and context.
$title = apply_filters( 'plugin_name_item_title', $title, $item_id, $context );
```

## WP-Cron Best Practices

### Scheduling Cron Events

```php
// Register custom intervals.
add_filter( 'cron_schedules', function( $schedules ) {
    $schedules['fifteen_minutes'] = array(
        'interval' => 900,
        'display'  => __( 'Every 15 Minutes', 'plugin-name' ),
    );
    return $schedules;
});

// Schedule on activation.
register_activation_hook( __FILE__, function() {
    if ( ! wp_next_scheduled( 'plugin_name_daily_task' ) ) {
        wp_schedule_event( time(), 'daily', 'plugin_name_daily_task' );
    }
});

// Unschedule on deactivation.
register_deactivation_hook( __FILE__, function() {
    wp_clear_scheduled_hook( 'plugin_name_daily_task' );
});
```

### CRITICAL: Avoid Hook Naming Conflicts (Infinite Recursion)

**WARNING:** Never use the same name for a cron hook and an internal action fired within its callback. This causes infinite recursion and fatal errors.

```php
// ❌ FATAL BUG: Infinite recursion!
// Cron hook name matches internal action - WordPress calls do_action('my_cron_hook')
// which triggers the callback, which fires the same action again = infinite loop
wp_schedule_event( time(), 'hourly', 'plugin_name_check_status' );

add_action( 'plugin_name_check_status', 'my_status_check' );

function my_status_check() {
    // This fires the SAME hook that triggered this function!
    do_action( 'plugin_name_check_status' ); // INFINITE LOOP!
}

// ✅ CORRECT: Use different names for cron hook vs internal action
wp_schedule_event( time(), 'hourly', 'plugin_name_check_status' );

add_action( 'plugin_name_check_status', 'my_status_check' );

function my_status_check() {
    // Use a DIFFERENT action name with prefix like 'do_' or '_run'
    do_action( 'plugin_name_do_check_status' ); // Safe - different name
}

// Then other modules can hook to the internal action:
add_action( 'plugin_name_do_check_status', 'actual_status_checker' );
```

### Cron Callback Best Practices

```php
// ✅ GOOD: Add error handling and logging.
add_action( 'plugin_name_daily_cleanup', function() {
    try {
        // Perform cleanup.
        $deleted = plugin_name_cleanup_old_data();

        // Log success.
        if ( defined( 'WP_DEBUG' ) && WP_DEBUG ) {
            error_log( "Plugin Name: Cleaned up {$deleted} old records" );
        }
    } catch ( Exception $e ) {
        error_log( 'Plugin Name Cron Error: ' . $e->getMessage() );
    }
});

// ✅ GOOD: Prevent long-running cron from timing out.
add_action( 'plugin_name_heavy_task', function() {
    // Increase time limit for long tasks.
    set_time_limit( 300 );

    // Process in batches.
    $batch_size = 100;
    $offset = 0;

    do {
        $items = get_items_batch( $offset, $batch_size );
        foreach ( $items as $item ) {
            process_item( $item );
        }
        $offset += $batch_size;
    } while ( count( $items ) === $batch_size );
});
```

### Audit Checklist for Cron Jobs

When reviewing cron implementations, check:

1. **Hook Name Conflicts** - Ensure cron hook names differ from any `do_action()` calls within callbacks
2. **Proper Scheduling** - Events scheduled on activation, cleared on deactivation
3. **Error Handling** - Callbacks wrapped in try-catch with logging
4. **Batch Processing** - Large data sets processed in chunks
5. **Time Limits** - Long tasks extend execution time
6. **Unique Scheduling** - Check `wp_next_scheduled()` before adding events

## Security Best Practices

```php
// ❌ BAD: Missing nonce verification.
if ( isset( $_POST['submit'] ) ) {
    update_option( 'my_option', $_POST['value'] );
}

// ✅ GOOD: Verify nonce.
if ( isset( $_POST['submit'] ) ) {
    if ( ! wp_verify_nonce( $_POST['_wpnonce'], 'plugin_name_save' ) ) {
        wp_die( 'Security check failed' );
    }
    update_option( 'my_option', sanitize_text_field( $_POST['value'] ) );
}

// ❌ BAD: Missing capability check.
function admin_page_handler() {
    delete_option( 'important_setting' );
}

// ✅ GOOD: Check capabilities.
function admin_page_handler() {
    if ( ! current_user_can( 'manage_options' ) ) {
        wp_die( 'Unauthorized access' );
    }
    delete_option( 'important_setting' );
}

// ❌ BAD: SQL injection vulnerable.
$results = $wpdb->get_results(
    "SELECT * FROM {$wpdb->posts} WHERE post_title = '$title'"
);

// ✅ GOOD: Use prepared statements.
$results = $wpdb->get_results(
    $wpdb->prepare(
        "SELECT * FROM {$wpdb->posts} WHERE post_title = %s",
        $title
    )
);

// ❌ BAD: XSS vulnerable.
echo $_GET['search'];

// ✅ GOOD: Escape output.
echo esc_html( $_GET['search'] );
```

## Internationalization

```php
<?php
/**
 * Internationalization handler.
 *
 * @package Plugin_Name
 */

class Plugin_Name_I18n {

    /**
     * Load plugin textdomain.
     */
    public function load_plugin_textdomain() {
        load_plugin_textdomain(
            'plugin-name',
            false,
            dirname( PLUGIN_NAME_BASENAME ) . '/languages/'
        );
    }
}

// Usage in code.

// Simple string.
__( 'Hello World', 'plugin-name' );

// Echo string.
esc_html_e( 'Hello World', 'plugin-name' );

// With context.
_x( 'Post', 'noun', 'plugin-name' );

// Pluralization.
sprintf(
    _n(
        '%s item',
        '%s items',
        $count,
        'plugin-name'
    ),
    number_format_i18n( $count )
);

// With placeholders.
sprintf(
    /* translators: %s: User name */
    __( 'Hello, %s!', 'plugin-name' ),
    esc_html( $user_name )
);
```

## Coding Standards

### Naming Conventions

```php
// Functions: lowercase with underscores, prefixed.
function plugin_name_get_items() {}
function plugin_name_process_data() {}

// Classes: CamelCase with prefix.
class Plugin_Name_Admin {}
class Plugin_Name_REST_Controller {}

// Constants: uppercase with underscores.
define( 'PLUGIN_NAME_VERSION', '1.0.0' );
define( 'PLUGIN_NAME_PATH', __DIR__ );

// Variables: lowercase with underscores.
$user_data = array();
$post_count = 0;

// Hooks: lowercase with underscores, prefixed.
do_action( 'plugin_name_init' );
apply_filters( 'plugin_name_output', $output );
```

### File Headers

```php
<?php
/**
 * Class description.
 *
 * @package    Plugin_Name
 * @subpackage Plugin_Name/Admin
 * @author     Your Name <email@example.com>
 * @since      1.0.0
 */
```

## Dependency Checking

### Check Required Plugins

```php
<?php
/**
 * Plugin dependency checker.
 * Add to main plugin file BEFORE initializing the plugin.
 */

class Plugin_Name_Dependencies {

    /**
     * Required plugins.
     *
     * @var array
     */
    private static $required = array(
        array(
            'path' => 'woocommerce/woocommerce.php',
            'name' => 'WooCommerce',
            'version' => '8.0.0',
        ),
        array(
            'path' => 'buddypress/bp-loader.php',
            'name' => 'BuddyPress',
            'version' => '12.0.0',
        ),
    );

    /**
     * Check all dependencies.
     *
     * @return bool|WP_Error True if OK, WP_Error if not.
     */
    public static function check() {
        // PHP version
        if ( version_compare( PHP_VERSION, '8.0', '<' ) ) {
            return new WP_Error( 'php_version', 'PHP 8.0+ required' );
        }

        // WordPress version
        if ( version_compare( get_bloginfo( 'version' ), '6.0', '<' ) ) {
            return new WP_Error( 'wp_version', 'WordPress 6.0+ required' );
        }

        // Required plugins
        if ( ! function_exists( 'is_plugin_active' ) ) {
            require_once ABSPATH . 'wp-admin/includes/plugin.php';
        }

        foreach ( self::$required as $plugin ) {
            if ( ! is_plugin_active( $plugin['path'] ) ) {
                return new WP_Error(
                    'missing_plugin',
                    sprintf( '%s is required', $plugin['name'] )
                );
            }
        }

        return true;
    }

    /**
     * Display admin notice for missing dependencies.
     *
     * @param WP_Error $error The error object.
     */
    public static function admin_notice( $error ) {
        add_action( 'admin_notices', function() use ( $error ) {
            printf(
                '<div class="notice notice-error"><p><strong>%s:</strong> %s</p></div>',
                esc_html__( 'Plugin Name', 'plugin-name' ),
                esc_html( $error->get_error_message() )
            );
        });
    }
}

// Usage in main plugin file
add_action( 'plugins_loaded', function() {
    $check = Plugin_Name_Dependencies::check();

    if ( is_wp_error( $check ) ) {
        Plugin_Name_Dependencies::admin_notice( $check );
        return;
    }

    // Initialize plugin only if dependencies met
    Plugin_Name::instance();
});
```

### Conditional Feature Loading

```php
<?php
/**
 * Load features based on available plugins.
 */

class Plugin_Name_Features {

    /**
     * Initialize based on available dependencies.
     */
    public static function init() {
        // Always load core
        require_once PLUGIN_NAME_PATH . 'includes/core.php';

        // WooCommerce integration
        if ( class_exists( 'WooCommerce' ) ) {
            require_once PLUGIN_NAME_PATH . 'includes/woocommerce.php';
        }

        // Elementor widgets
        if ( did_action( 'elementor/loaded' ) ) {
            require_once PLUGIN_NAME_PATH . 'includes/elementor.php';
        }

        // BuddyPress integration
        if ( function_exists( 'buddypress' ) ) {
            require_once PLUGIN_NAME_PATH . 'includes/buddypress.php';
        }

        // ACF integration
        if ( class_exists( 'ACF' ) ) {
            require_once PLUGIN_NAME_PATH . 'includes/acf.php';
        }
    }
}
```

### Common Plugin Detection

```php
<?php
/**
 * Helper functions for detecting common plugins.
 */

function plugin_name_is_woocommerce_active() {
    return class_exists( 'WooCommerce' );
}

function plugin_name_is_elementor_active() {
    return defined( 'ELEMENTOR_VERSION' );
}

function plugin_name_is_buddypress_active() {
    return function_exists( 'buddypress' );
}

function plugin_name_is_acf_active() {
    return class_exists( 'ACF' );
}

function plugin_name_is_gutenberg_active() {
    return function_exists( 'register_block_type' );
}

function plugin_name_is_local_environment() {
    return function_exists( 'wp_get_environment_type' )
        && wp_get_environment_type() === 'local';
}
```

## Severity Definitions

| Severity | Description |
|----------|-------------|
| **Critical** | Plugin won't activate, security vulnerability |
| **Warning** | Deprecated usage, missing best practices |
| **Info** | Optimization suggestion, code style |

## Plugin Check Compliance

Before release, ensure:

- [ ] Passes Plugin Check (no errors)
- [ ] Uses proper prefixing for all globals
- [ ] Escapes all output
- [ ] Sanitizes all input
- [ ] Verifies nonces on forms/AJAX
- [ ] Checks capabilities before actions
- [ ] Uses prepared statements for SQL
- [ ] Includes uninstall.php for cleanup
- [ ] Translation-ready with proper text domain
- [ ] Follows WordPress Coding Standards
- [ ] No PHP errors or warnings
- [ ] Includes readme.txt with proper format
