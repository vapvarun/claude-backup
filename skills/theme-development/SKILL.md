---
name: theme-development
description: Develop WordPress themes following best practices for theme structure, template hierarchy, customizer options, Gutenberg blocks, and theme standards. Use when building new themes, adding theme features, or fixing theme issues.
---

# Theme Development Skill

## Instructions

When developing WordPress themes:

### 1. Theme Structure

```
theme-name/
├── assets/
│   ├── css/
│   ├── js/
│   ├── images/
│   └── fonts/
├── inc/
│   ├── customizer.php
│   ├── template-functions.php
│   ├── template-tags.php
│   └── block-patterns.php
├── template-parts/
│   ├── header/
│   ├── footer/
│   ├── content/
│   └── components/
├── patterns/
├── parts/
├── templates/
├── functions.php
├── style.css
├── theme.json
└── screenshot.png
```

### 2. Theme.json (Block Themes)

```json
{
  "$schema": "https://schemas.wp.org/trunk/theme.json",
  "version": 2,
  "settings": {
    "color": {
      "palette": [
        { "slug": "primary", "color": "#0066cc", "name": "Primary" }
      ]
    },
    "typography": {
      "fontFamilies": [],
      "fontSizes": []
    },
    "spacing": {
      "units": ["px", "rem", "%"]
    },
    "layout": {
      "contentSize": "1200px",
      "wideSize": "1400px"
    }
  },
  "styles": {},
  "templateParts": [],
  "customTemplates": []
}
```

### 3. Template Hierarchy

Follow WordPress template hierarchy:
- `front-page.php` → Static front page
- `home.php` → Blog posts page
- `single-{post-type}.php` → Single posts
- `archive-{post-type}.php` → Archives
- `page-{slug}.php` → Specific pages
- `taxonomy-{taxonomy}.php` → Taxonomy archives

### 4. Customizer Options

```php
function theme_customize_register($wp_customize) {
    // Section
    $wp_customize->add_section('theme_options', [
        'title' => __('Theme Options', 'theme-name'),
        'priority' => 30,
    ]);

    // Setting + Control
    $wp_customize->add_setting('header_layout', [
        'default' => 'default',
        'sanitize_callback' => 'sanitize_text_field',
    ]);

    $wp_customize->add_control('header_layout', [
        'label' => __('Header Layout', 'theme-name'),
        'section' => 'theme_options',
        'type' => 'select',
        'choices' => [
            'default' => __('Default', 'theme-name'),
            'centered' => __('Centered', 'theme-name'),
        ],
    ]);
}
add_action('customize_register', 'theme_customize_register');
```

### 5. Enqueue Assets Properly

```php
function theme_enqueue_assets() {
    // Styles
    wp_enqueue_style(
        'theme-style',
        get_stylesheet_uri(),
        [],
        wp_get_theme()->get('Version')
    );

    // Scripts
    wp_enqueue_script(
        'theme-script',
        get_template_directory_uri() . '/assets/js/main.js',
        ['jquery'],
        wp_get_theme()->get('Version'),
        true
    );

    // Localize
    wp_localize_script('theme-script', 'themeData', [
        'ajaxUrl' => admin_url('admin-ajax.php'),
        'nonce' => wp_create_nonce('theme_nonce'),
    ]);
}
add_action('wp_enqueue_scripts', 'theme_enqueue_assets');
```

### 6. Security Best Practices

- Escape all output: `esc_html()`, `esc_attr()`, `esc_url()`
- Sanitize all input: `sanitize_text_field()`, `wp_kses_post()`
- Use nonces for forms and AJAX
- Validate user capabilities
- Prefix all functions and variables

### 7. Performance Optimization

- Lazy load images
- Minify CSS/JS for production
- Use `wp_enqueue_script` with `defer` strategy
- Optimize web fonts loading
- Implement critical CSS

### 8. Accessibility Requirements

- Semantic HTML structure
- Skip links for navigation
- Focus states on interactive elements
- Alt text for images
- ARIA labels where needed
- Color contrast compliance

### 9. Theme Check Compliance

Before release:
- [ ] Passes Theme Check plugin
- [ ] No PHP errors or warnings
- [ ] Translation-ready (text domains)
- [ ] Screenshot is 1200x900px
- [ ] License is GPL compatible
- [ ] No bundled plugins (recommend instead)
