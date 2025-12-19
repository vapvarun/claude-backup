# WordPress Hardening Checklist

Security hardening recommendations for WordPress installations.

## wp-config.php Hardening

### Essential Security Constants

```php
<?php
/**
 * Security-enhanced wp-config.php settings.
 */

// Disable file editing from admin.
define( 'DISALLOW_FILE_EDIT', true );

// Disable plugin/theme installation from admin (stricter).
define( 'DISALLOW_FILE_MODS', true );

// Force SSL for admin and logins.
define( 'FORCE_SSL_ADMIN', true );

// Use unique authentication keys (generate at https://api.wordpress.org/secret-key/1.1/salt/).
define( 'AUTH_KEY',         'unique-phrase-here' );
define( 'SECURE_AUTH_KEY',  'unique-phrase-here' );
define( 'LOGGED_IN_KEY',    'unique-phrase-here' );
define( 'NONCE_KEY',        'unique-phrase-here' );
define( 'AUTH_SALT',        'unique-phrase-here' );
define( 'SECURE_AUTH_SALT', 'unique-phrase-here' );
define( 'LOGGED_IN_SALT',   'unique-phrase-here' );
define( 'NONCE_SALT',       'unique-phrase-here' );

// Limit post revisions (prevents database bloat).
define( 'WP_POST_REVISIONS', 5 );

// Empty trash more frequently.
define( 'EMPTY_TRASH_DAYS', 7 );

// Disable XML-RPC if not needed.
// (Do this via filter instead - see below.)

// Production debug settings.
define( 'WP_DEBUG', false );
define( 'WP_DEBUG_DISPLAY', false );
define( 'WP_DEBUG_LOG', false );
define( 'SCRIPT_DEBUG', false );

// Database table prefix (change from default 'wp_').
$table_prefix = 'wp_x7k3_'; // Use unique prefix.

// Automatic updates (security updates only).
define( 'WP_AUTO_UPDATE_CORE', 'minor' );
```

### Move wp-config.php Above Web Root

```
/home/user/
├── wp-config.php       ← Move here (one level above)
└── public_html/
    ├── wp-admin/
    ├── wp-content/
    ├── wp-includes/
    └── index.php
```

WordPress automatically looks one directory up for `wp-config.php`.

---

## .htaccess Security Rules

```apache
# Block access to sensitive files.
<FilesMatch "^(wp-config\.php|readme\.html|license\.txt|install\.php)$">
    Require all denied
</FilesMatch>

# Block access to hidden files.
<FilesMatch "^\.">
    Require all denied
</FilesMatch>

# Block access to backup and log files.
<FilesMatch "\.(bak|config|sql|fla|psd|ini|log|sh|inc|swp|dist|tar|gz|zip)$">
    Require all denied
</FilesMatch>

# Block PHP execution in uploads.
<Directory "/var/www/html/wp-content/uploads">
    <Files "*.php">
        Require all denied
    </Files>
</Directory>

# Disable directory browsing.
Options -Indexes

# Block author enumeration.
RewriteEngine On
RewriteCond %{REQUEST_URI} ^/$
RewriteCond %{QUERY_STRING} ^author=([0-9]+) [NC]
RewriteRule .* - [F]

# Block XML-RPC.
<Files xmlrpc.php>
    Require all denied
</Files>

# Block wp-trackback.php.
<Files wp-trackback.php>
    Require all denied
</Files>

# Prevent script injection.
Options +FollowSymLinks
RewriteEngine On
RewriteCond %{QUERY_STRING} (<|%3C).*script.*(>|%3E) [NC,OR]
RewriteCond %{QUERY_STRING} GLOBALS(=|[|%[0-9A-Z]{0,2}) [OR]
RewriteCond %{QUERY_STRING} _REQUEST(=|[|%[0-9A-Z]{0,2})
RewriteRule ^(.*)$ index.php [F,L]
```

---

## PHP Hardening Functions

### Disable XML-RPC

```php
// Completely disable XML-RPC.
add_filter( 'xmlrpc_enabled', '__return_false' );

// Remove XML-RPC header.
remove_action( 'wp_head', 'rsd_link' );

// Block XML-RPC methods.
add_filter( 'xmlrpc_methods', function( $methods ) {
    return array();
} );
```

### Add Security Headers

```php
add_action( 'send_headers', 'prefix_security_headers' );
function prefix_security_headers() {
    // Only on frontend.
    if ( is_admin() ) {
        return;
    }

    // Prevent clickjacking.
    header( 'X-Frame-Options: SAMEORIGIN' );

    // Prevent MIME type sniffing.
    header( 'X-Content-Type-Options: nosniff' );

    // Enable XSS filter.
    header( 'X-XSS-Protection: 1; mode=block' );

    // Referrer policy.
    header( 'Referrer-Policy: strict-origin-when-cross-origin' );

    // Permissions policy (formerly Feature-Policy).
    header( 'Permissions-Policy: camera=(), microphone=(), geolocation=()' );

    // Content Security Policy (customize based on your needs).
    // Uncomment and adjust after testing.
    // header( "Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';" );
}
```

### Block User Enumeration

```php
// Block /?author=N enumeration.
add_action( 'template_redirect', 'prefix_block_author_enum' );
function prefix_block_author_enum() {
    if ( isset( $_GET['author'] ) && ! is_admin() ) {
        wp_safe_redirect( home_url(), 301 );
        exit;
    }
}

// Block REST API user enumeration for unauthenticated users.
add_filter( 'rest_authentication_errors', function( $result ) {
    if ( true === $result || is_wp_error( $result ) ) {
        return $result;
    }

    $request_uri = isset( $_SERVER['REQUEST_URI'] ) ? $_SERVER['REQUEST_URI'] : '';
    if ( strpos( $request_uri, '/wp-json/wp/v2/users' ) !== false ) {
        if ( ! is_user_logged_in() ) {
            return new WP_Error(
                'rest_user_cannot_view',
                'User listing requires authentication.',
                array( 'status' => 401 )
            );
        }
    }

    return $result;
} );
```

### Limit Login Attempts (Basic)

```php
add_filter( 'authenticate', 'prefix_check_login_attempts', 30, 3 );
function prefix_check_login_attempts( $user, $username, $password ) {
    if ( empty( $username ) ) {
        return $user;
    }

    $ip           = $_SERVER['REMOTE_ADDR'];
    $transient    = 'login_attempts_' . md5( $ip );
    $attempts     = get_transient( $transient );
    $max_attempts = 5;
    $lockout_time = 15 * MINUTE_IN_SECONDS;

    if ( false !== $attempts && $attempts >= $max_attempts ) {
        return new WP_Error(
            'too_many_attempts',
            sprintf(
                'Too many failed login attempts. Try again in %d minutes.',
                ceil( $lockout_time / 60 )
            )
        );
    }

    return $user;
}

add_action( 'wp_login_failed', 'prefix_record_failed_login' );
function prefix_record_failed_login( $username ) {
    $ip        = $_SERVER['REMOTE_ADDR'];
    $transient = 'login_attempts_' . md5( $ip );
    $attempts  = get_transient( $transient );

    if ( false === $attempts ) {
        $attempts = 0;
    }

    set_transient( $transient, $attempts + 1, 15 * MINUTE_IN_SECONDS );
}

add_action( 'wp_login', 'prefix_clear_login_attempts', 10, 2 );
function prefix_clear_login_attempts( $username, $user ) {
    $ip        = $_SERVER['REMOTE_ADDR'];
    $transient = 'login_attempts_' . md5( $ip );
    delete_transient( $transient );
}
```

### Hide WordPress Version

```php
// Remove version from head.
remove_action( 'wp_head', 'wp_generator' );

// Remove version from RSS.
add_filter( 'the_generator', '__return_empty_string' );

// Remove version from scripts/styles.
add_filter( 'style_loader_src', 'prefix_remove_version', 10, 2 );
add_filter( 'script_loader_src', 'prefix_remove_version', 10, 2 );
function prefix_remove_version( $src, $handle ) {
    if ( strpos( $src, 'ver=' ) ) {
        $src = remove_query_arg( 'ver', $src );
    }
    return $src;
}
```

### Secure Login Cookie

```php
// Use secure cookies on HTTPS.
add_filter( 'secure_signon_cookie', function( $secure ) {
    return is_ssl();
} );

// Set SameSite attribute for cookies (WordPress 5.2+).
// Handled automatically but can be customized via wp_set_auth_cookie action.
```

---

## File Permissions

### Recommended Permissions

| File/Directory | Permission | Owner |
|---------------|------------|-------|
| wp-config.php | 400 or 440 | www-data |
| .htaccess | 444 | www-data |
| wp-content/ | 755 | www-data |
| wp-content/uploads/ | 755 | www-data |
| wp-content/plugins/ | 755 | www-data |
| wp-content/themes/ | 755 | www-data |
| All .php files | 644 | www-data |
| All directories | 755 | www-data |

### Set Permissions Script

```bash
#!/bin/bash
# Secure WordPress file permissions.

WP_ROOT="/var/www/html"
WP_USER="www-data"
WP_GROUP="www-data"

# Set ownership.
chown -R ${WP_USER}:${WP_GROUP} ${WP_ROOT}

# Set directory permissions.
find ${WP_ROOT} -type d -exec chmod 755 {} \;

# Set file permissions.
find ${WP_ROOT} -type f -exec chmod 644 {} \;

# Secure wp-config.php.
chmod 400 ${WP_ROOT}/wp-config.php

# Secure .htaccess.
chmod 444 ${WP_ROOT}/.htaccess
```

---

## Database Security

### Change Table Prefix

For new installations, use a unique prefix in `wp-config.php`:

```php
$table_prefix = 'wp_x7k3_'; // Not 'wp_'.
```

### Database User Permissions

Create a MySQL user with minimal required permissions:

```sql
-- Create dedicated user.
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'strong_password_here';

-- Grant only required permissions.
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER
ON wordpress_db.*
TO 'wp_user'@'localhost';

-- Apply changes.
FLUSH PRIVILEGES;
```

---

## Admin Security

### Change Login URL (via plugin or custom code)

```php
// Simple login URL change (basic protection - use security plugin for robust solution).
add_action( 'init', 'prefix_custom_login_url' );
function prefix_custom_login_url() {
    $custom_login = 'secure-login'; // Your custom slug.

    $request_uri = isset( $_SERVER['REQUEST_URI'] ) ? $_SERVER['REQUEST_URI'] : '';

    // Allow custom login URL.
    if ( strpos( $request_uri, $custom_login ) !== false ) {
        return;
    }

    // Block default login URLs for non-authenticated users.
    if ( ! is_user_logged_in() ) {
        $blocked = array( 'wp-login.php', 'wp-admin' );
        foreach ( $blocked as $path ) {
            if ( strpos( $request_uri, $path ) !== false ) {
                wp_safe_redirect( home_url( '404' ) );
                exit;
            }
        }
    }
}
```

### Disable Admin for Non-Admins

```php
add_action( 'admin_init', 'prefix_restrict_admin' );
function prefix_restrict_admin() {
    if ( wp_doing_ajax() ) {
        return;
    }

    if ( ! current_user_can( 'manage_options' ) && ! current_user_can( 'edit_posts' ) ) {
        wp_safe_redirect( home_url() );
        exit;
    }
}
```

### Hide Admin Bar for Non-Admins

```php
add_filter( 'show_admin_bar', function( $show ) {
    if ( ! current_user_can( 'edit_posts' ) ) {
        return false;
    }
    return $show;
} );
```

---

## REST API Security

### Require Authentication for REST API

```php
add_filter( 'rest_authentication_errors', function( $result ) {
    if ( true === $result || is_wp_error( $result ) ) {
        return $result;
    }

    if ( ! is_user_logged_in() ) {
        return new WP_Error(
            'rest_not_logged_in',
            'API access requires authentication.',
            array( 'status' => 401 )
        );
    }

    return $result;
} );
```

### Disable REST API for Unauthenticated Users

```php
add_filter( 'rest_authentication_errors', function( $result ) {
    if ( ! is_user_logged_in() ) {
        return new WP_Error(
            'rest_disabled',
            'REST API is disabled for unauthenticated users.',
            array( 'status' => 403 )
        );
    }
    return $result;
} );
```

### Allow Only Specific REST Endpoints

```php
add_filter( 'rest_endpoints', function( $endpoints ) {
    // Remove user endpoint for non-authenticated users.
    if ( ! is_user_logged_in() ) {
        if ( isset( $endpoints['/wp/v2/users'] ) ) {
            unset( $endpoints['/wp/v2/users'] );
        }
        if ( isset( $endpoints['/wp/v2/users/(?P<id>[\d]+)'] ) ) {
            unset( $endpoints['/wp/v2/users/(?P<id>[\d]+)'] );
        }
    }
    return $endpoints;
} );
```

---

## Security Audit Checklist

### Configuration
- [ ] `WP_DEBUG` disabled in production
- [ ] Unique `$table_prefix` (not `wp_`)
- [ ] Strong authentication keys/salts
- [ ] `DISALLOW_FILE_EDIT` enabled
- [ ] `FORCE_SSL_ADMIN` enabled
- [ ] `wp-config.php` permissions set to 400

### Access Control
- [ ] XML-RPC disabled (if not needed)
- [ ] User enumeration blocked
- [ ] REST API endpoints protected
- [ ] Admin area restricted
- [ ] Login attempts limited

### File Security
- [ ] PHP execution blocked in uploads
- [ ] Directory listing disabled
- [ ] Sensitive files blocked (.git, .env, backups)
- [ ] Correct file permissions set

### Headers & Transport
- [ ] HTTPS enforced site-wide
- [ ] Security headers configured
- [ ] WordPress version hidden

### Monitoring
- [ ] Login attempt logging enabled
- [ ] File integrity monitoring active
- [ ] Error logging configured (not displayed)
- [ ] Regular security scans scheduled
