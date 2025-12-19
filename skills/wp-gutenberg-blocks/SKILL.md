---
name: wp-gutenberg-blocks
description: WordPress Gutenberg block development and Full Site Editing. Use when building custom blocks, block patterns, block themes, extending the block editor, or working with FSE templates, or when user mentions "Gutenberg", "block editor", "custom block", "block pattern", "FSE", "Full Site Editing", "theme.json", "block theme", "InnerBlocks", "RichText", "block.json", or "wp-scripts".
---

# WordPress Gutenberg Blocks Skill

## Overview

Comprehensive guide for developing Gutenberg blocks, block patterns, and Full Site Editing (FSE) themes. **Core principle:** Use modern block development practices with @wordpress/scripts, block.json for metadata, and leverage core components for consistency.

## When to Use

**Use when:**
- Building custom Gutenberg blocks
- Creating block patterns or variations
- Developing FSE/block themes
- Extending core blocks with filters
- Configuring theme.json
- Troubleshooting block editor issues

**Don't use for:**
- Classic theme development (use wp-theme-development)
- Security-focused code review (use wp-security-review)
- Performance optimization (use wp-performance-review)

## Block Development Workflow

1. **Set up build environment** with @wordpress/scripts
2. **Define block metadata** in block.json
3. **Create Edit component** for editor view
4. **Create Save component** or use render.php for dynamic blocks
5. **Register block** in PHP
6. **Add styles** for editor and frontend

## Project Setup

### Initialize Block Plugin

```bash
# Create new block plugin.
npx @wordpress/create-block@latest my-custom-block

# Or create multiple blocks in existing plugin.
cd my-plugin
npx @wordpress/create-block@latest src/blocks/feature-card --no-plugin
```

### package.json Configuration

```json
{
  "name": "my-block-plugin",
  "version": "1.0.0",
  "scripts": {
    "build": "wp-scripts build",
    "start": "wp-scripts start",
    "format": "wp-scripts format",
    "lint:css": "wp-scripts lint-style",
    "lint:js": "wp-scripts lint-js",
    "packages-update": "wp-scripts packages-update"
  },
  "devDependencies": {
    "@wordpress/scripts": "^27.0.0"
  }
}
```

### webpack.config.js (Multiple Blocks)

```javascript
const defaultConfig = require( '@wordpress/scripts/config/webpack.config' );
const path = require( 'path' );

module.exports = {
    ...defaultConfig,
    entry: {
        'feature-card': path.resolve( __dirname, 'src/blocks/feature-card/index.js' ),
        'testimonial': path.resolve( __dirname, 'src/blocks/testimonial/index.js' ),
        'hero-section': path.resolve( __dirname, 'src/blocks/hero-section/index.js' ),
    },
    output: {
        path: path.resolve( __dirname, 'build' ),
        filename: '[name]/index.js',
    },
};
```

## Block Registration

### block.json (Required)

```json
{
    "$schema": "https://schemas.wp.org/trunk/block.json",
    "apiVersion": 3,
    "name": "myplugin/feature-card",
    "version": "1.0.0",
    "title": "Feature Card",
    "category": "widgets",
    "icon": "star-filled",
    "description": "A card highlighting a feature with icon, title, and description.",
    "keywords": [ "feature", "card", "highlight", "service" ],
    "textdomain": "myplugin",
    "supports": {
        "html": false,
        "align": [ "wide", "full" ],
        "anchor": true,
        "color": {
            "background": true,
            "text": true,
            "gradients": true,
            "link": true
        },
        "spacing": {
            "margin": true,
            "padding": true,
            "blockGap": true
        },
        "typography": {
            "fontSize": true,
            "lineHeight": true
        },
        "__experimentalBorder": {
            "radius": true,
            "width": true,
            "color": true,
            "style": true
        }
    },
    "attributes": {
        "title": {
            "type": "string",
            "default": ""
        },
        "description": {
            "type": "string",
            "source": "html",
            "selector": ".feature-card__description"
        },
        "iconName": {
            "type": "string",
            "default": "star-filled"
        },
        "mediaId": {
            "type": "number"
        },
        "mediaUrl": {
            "type": "string"
        },
        "linkUrl": {
            "type": "string",
            "default": ""
        },
        "linkText": {
            "type": "string",
            "default": "Learn More"
        }
    },
    "example": {
        "attributes": {
            "title": "Feature Title",
            "description": "This is a description of the feature.",
            "iconName": "star-filled"
        }
    },
    "editorScript": "file:./index.js",
    "editorStyle": "file:./index.css",
    "style": "file:./style-index.css",
    "viewScript": "file:./view.js",
    "render": "file:./render.php"
}
```

### PHP Registration

```php
<?php
/**
 * Register custom blocks.
 */
function myplugin_register_blocks() {
    // Single block registration.
    register_block_type( __DIR__ . '/build/feature-card' );

    // Or register multiple blocks.
    $blocks = array(
        'feature-card',
        'testimonial',
        'hero-section',
    );

    foreach ( $blocks as $block ) {
        register_block_type( __DIR__ . '/build/' . $block );
    }
}
add_action( 'init', 'myplugin_register_blocks' );

// Register block category.
function myplugin_block_categories( $categories ) {
    return array_merge(
        array(
            array(
                'slug'  => 'myplugin',
                'title' => __( 'My Plugin', 'myplugin' ),
                'icon'  => 'star-filled',
            ),
        ),
        $categories
    );
}
add_filter( 'block_categories_all', 'myplugin_block_categories', 10, 1 );
```

## Edit Component Patterns

### Basic Edit Component

```jsx
import { __ } from '@wordpress/i18n';
import {
    useBlockProps,
    RichText,
    InspectorControls,
    MediaUpload,
    MediaUploadCheck,
    BlockControls,
    AlignmentToolbar,
} from '@wordpress/block-editor';
import {
    PanelBody,
    TextControl,
    Button,
    Icon,
    ToolbarGroup,
    ToolbarButton,
} from '@wordpress/components';
import './editor.scss';

export default function Edit( { attributes, setAttributes } ) {
    const {
        title,
        description,
        iconName,
        mediaId,
        mediaUrl,
        linkUrl,
        linkText,
    } = attributes;

    const blockProps = useBlockProps( {
        className: 'feature-card',
    } );

    const onSelectMedia = ( media ) => {
        setAttributes( {
            mediaId: media.id,
            mediaUrl: media.url,
        } );
    };

    const removeMedia = () => {
        setAttributes( {
            mediaId: undefined,
            mediaUrl: undefined,
        } );
    };

    return (
        <>
            <InspectorControls>
                <PanelBody title={ __( 'Settings', 'myplugin' ) }>
                    <TextControl
                        label={ __( 'Link URL', 'myplugin' ) }
                        value={ linkUrl }
                        onChange={ ( value ) => setAttributes( { linkUrl: value } ) }
                        type="url"
                    />
                    <TextControl
                        label={ __( 'Link Text', 'myplugin' ) }
                        value={ linkText }
                        onChange={ ( value ) => setAttributes( { linkText: value } ) }
                    />
                </PanelBody>

                <PanelBody title={ __( 'Media', 'myplugin' ) } initialOpen={ false }>
                    <MediaUploadCheck>
                        <MediaUpload
                            onSelect={ onSelectMedia }
                            allowedTypes={ [ 'image' ] }
                            value={ mediaId }
                            render={ ( { open } ) => (
                                <div className="editor-media-control">
                                    { mediaUrl ? (
                                        <>
                                            <img src={ mediaUrl } alt="" />
                                            <Button
                                                onClick={ removeMedia }
                                                isDestructive
                                            >
                                                { __( 'Remove', 'myplugin' ) }
                                            </Button>
                                        </>
                                    ) : (
                                        <Button onClick={ open } variant="secondary">
                                            { __( 'Select Image', 'myplugin' ) }
                                        </Button>
                                    ) }
                                </div>
                            ) }
                        />
                    </MediaUploadCheck>
                </PanelBody>
            </InspectorControls>

            <div { ...blockProps }>
                <div className="feature-card__icon">
                    <Icon icon={ iconName } size={ 48 } />
                </div>

                <RichText
                    tagName="h3"
                    className="feature-card__title"
                    value={ title }
                    onChange={ ( value ) => setAttributes( { title: value } ) }
                    placeholder={ __( 'Feature title...', 'myplugin' ) }
                />

                <RichText
                    tagName="p"
                    className="feature-card__description"
                    value={ description }
                    onChange={ ( value ) => setAttributes( { description: value } ) }
                    placeholder={ __( 'Feature description...', 'myplugin' ) }
                />

                { linkUrl && (
                    <a className="feature-card__link" href={ linkUrl }>
                        { linkText }
                    </a>
                ) }
            </div>
        </>
    );
}
```

### Save Component (Static Blocks)

```jsx
import { useBlockProps, RichText } from '@wordpress/block-editor';
import { Icon } from '@wordpress/components';

export default function Save( { attributes } ) {
    const { title, description, iconName, mediaUrl, linkUrl, linkText } = attributes;

    const blockProps = useBlockProps.save( {
        className: 'feature-card',
    } );

    return (
        <div { ...blockProps }>
            { mediaUrl ? (
                <img
                    className="feature-card__image"
                    src={ mediaUrl }
                    alt=""
                />
            ) : (
                <div className="feature-card__icon">
                    <Icon icon={ iconName } size={ 48 } />
                </div>
            ) }

            { title && (
                <RichText.Content
                    tagName="h3"
                    className="feature-card__title"
                    value={ title }
                />
            ) }

            { description && (
                <RichText.Content
                    tagName="p"
                    className="feature-card__description"
                    value={ description }
                />
            ) }

            { linkUrl && (
                <a className="feature-card__link" href={ linkUrl }>
                    { linkText }
                </a>
            ) }
        </div>
    );
}
```

### Dynamic Block (render.php)

```php
<?php
/**
 * Render callback for feature-card block.
 *
 * @param array    $attributes Block attributes.
 * @param string   $content    Block content.
 * @param WP_Block $block      Block instance.
 * @return string Rendered block HTML.
 */

$title       = $attributes['title'] ?? '';
$description = $attributes['description'] ?? '';
$icon_name   = $attributes['iconName'] ?? 'star-filled';
$media_id    = $attributes['mediaId'] ?? 0;
$media_url   = $attributes['mediaUrl'] ?? '';
$link_url    = $attributes['linkUrl'] ?? '';
$link_text   = $attributes['linkText'] ?? __( 'Learn More', 'myplugin' );

$wrapper_attributes = get_block_wrapper_attributes( array(
    'class' => 'feature-card',
) );
?>

<div <?php echo $wrapper_attributes; ?>>
    <?php if ( $media_url ) : ?>
        <img class="feature-card__image" src="<?php echo esc_url( $media_url ); ?>" alt="">
    <?php else : ?>
        <div class="feature-card__icon">
            <span class="dashicons dashicons-<?php echo esc_attr( $icon_name ); ?>"></span>
        </div>
    <?php endif; ?>

    <?php if ( $title ) : ?>
        <h3 class="feature-card__title"><?php echo esc_html( $title ); ?></h3>
    <?php endif; ?>

    <?php if ( $description ) : ?>
        <p class="feature-card__description"><?php echo wp_kses_post( $description ); ?></p>
    <?php endif; ?>

    <?php if ( $link_url ) : ?>
        <a class="feature-card__link" href="<?php echo esc_url( $link_url ); ?>">
            <?php echo esc_html( $link_text ); ?>
        </a>
    <?php endif; ?>
</div>
```

## InnerBlocks Patterns

### Container Block with InnerBlocks

```jsx
import { InnerBlocks, useBlockProps } from '@wordpress/block-editor';
import { __ } from '@wordpress/i18n';

const ALLOWED_BLOCKS = [
    'core/heading',
    'core/paragraph',
    'core/image',
    'core/button',
    'core/list',
];

const TEMPLATE = [
    [ 'core/heading', { level: 2, placeholder: __( 'Section Title', 'myplugin' ) } ],
    [ 'core/paragraph', { placeholder: __( 'Section content...', 'myplugin' ) } ],
];

export default function Edit() {
    const blockProps = useBlockProps( {
        className: 'content-section',
    } );

    return (
        <div { ...blockProps }>
            <InnerBlocks
                allowedBlocks={ ALLOWED_BLOCKS }
                template={ TEMPLATE }
                templateLock={ false }
                renderAppender={ InnerBlocks.DefaultBlockAppender }
            />
        </div>
    );
}

export function Save() {
    const blockProps = useBlockProps.save( {
        className: 'content-section',
    } );

    return (
        <div { ...blockProps }>
            <InnerBlocks.Content />
        </div>
    );
}
```

### Locked Template (Cards Grid)

```jsx
import { InnerBlocks, useBlockProps } from '@wordpress/block-editor';

const TEMPLATE = [
    [ 'myplugin/feature-card', {} ],
    [ 'myplugin/feature-card', {} ],
    [ 'myplugin/feature-card', {} ],
];

export default function Edit() {
    const blockProps = useBlockProps( {
        className: 'cards-grid',
    } );

    return (
        <div { ...blockProps }>
            <InnerBlocks
                template={ TEMPLATE }
                templateLock="all" // Locked: can't add/remove/move.
                // templateLock="insert" // Can reorder but not add/remove.
                // templateLock="contentOnly" // Only edit content.
            />
        </div>
    );
}
```

## Block Patterns

### Register Block Pattern

```php
<?php
/**
 * Register block patterns.
 */
function myplugin_register_patterns() {
    register_block_pattern(
        'myplugin/hero-with-cta',
        array(
            'title'       => __( 'Hero with CTA', 'myplugin' ),
            'description' => __( 'A hero section with heading, description, and call-to-action buttons.', 'myplugin' ),
            'categories'  => array( 'myplugin-patterns' ),
            'keywords'    => array( 'hero', 'banner', 'cta', 'header' ),
            'viewportWidth' => 1200,
            'content'     => '<!-- wp:cover {"dimRatio":50,"minHeight":600,"align":"full"} -->
<div class="wp-block-cover alignfull" style="min-height:600px">
    <span aria-hidden="true" class="wp-block-cover__background has-background-dim"></span>
    <div class="wp-block-cover__inner-container">
        <!-- wp:heading {"textAlign":"center","level":1,"style":{"typography":{"fontSize":"3.5rem"}}} -->
        <h1 class="wp-block-heading has-text-align-center" style="font-size:3.5rem">Welcome to Our Site</h1>
        <!-- /wp:heading -->

        <!-- wp:paragraph {"align":"center","style":{"typography":{"fontSize":"1.25rem"}}} -->
        <p class="has-text-align-center" style="font-size:1.25rem">Discover amazing features and transform your workflow.</p>
        <!-- /wp:paragraph -->

        <!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"}} -->
        <div class="wp-block-buttons">
            <!-- wp:button -->
            <div class="wp-block-button"><a class="wp-block-button__link wp-element-button">Get Started</a></div>
            <!-- /wp:button -->

            <!-- wp:button {"className":"is-style-outline"} -->
            <div class="wp-block-button is-style-outline"><a class="wp-block-button__link wp-element-button">Learn More</a></div>
            <!-- /wp:button -->
        </div>
        <!-- /wp:buttons -->
    </div>
</div>
<!-- /wp:cover -->',
        )
    );

    // Register pattern category.
    register_block_pattern_category( 'myplugin-patterns', array(
        'label' => __( 'My Plugin Patterns', 'myplugin' ),
    ) );
}
add_action( 'init', 'myplugin_register_patterns' );
```

### Pattern from File

```php
// patterns/hero-with-cta.php
<?php
/**
 * Title: Hero with CTA
 * Slug: myplugin/hero-with-cta
 * Categories: myplugin-patterns
 * Keywords: hero, banner, cta
 * Viewport Width: 1200
 */
?>
<!-- wp:cover {"dimRatio":50,"minHeight":600,"align":"full"} -->
<div class="wp-block-cover alignfull" style="min-height:600px">
    <!-- Pattern content here -->
</div>
<!-- /wp:cover -->
```

## Block Variations

### Register Block Variation

```javascript
import { registerBlockVariation } from '@wordpress/blocks';
import { __ } from '@wordpress/i18n';

registerBlockVariation( 'core/group', {
    name: 'card',
    title: __( 'Card', 'myplugin' ),
    description: __( 'A card container with padding, shadow, and rounded corners.', 'myplugin' ),
    icon: 'id',
    scope: [ 'inserter', 'transform' ],
    attributes: {
        className: 'is-style-card',
        style: {
            spacing: {
                padding: {
                    top: '2rem',
                    right: '2rem',
                    bottom: '2rem',
                    left: '2rem',
                },
            },
            border: {
                radius: '8px',
            },
        },
        backgroundColor: 'white',
    },
    innerBlocks: [
        [ 'core/heading', { level: 3, placeholder: __( 'Card Title', 'myplugin' ) } ],
        [ 'core/paragraph', { placeholder: __( 'Card content...', 'myplugin' ) } ],
    ],
    isActive: ( blockAttributes ) =>
        blockAttributes.className?.includes( 'is-style-card' ),
} );

// Variation for columns.
registerBlockVariation( 'core/columns', {
    name: 'two-column-feature',
    title: __( 'Two Column Feature', 'myplugin' ),
    icon: 'columns',
    scope: [ 'inserter' ],
    attributes: {
        className: 'is-style-feature-columns',
    },
    innerBlocks: [
        [ 'core/column', { width: '40%' }, [
            [ 'core/image', {} ],
        ] ],
        [ 'core/column', { width: '60%' }, [
            [ 'core/heading', { level: 2 } ],
            [ 'core/paragraph', {} ],
            [ 'core/buttons', {}, [
                [ 'core/button', {} ],
            ] ],
        ] ],
    ],
} );
```

## Block Styles

### Register Block Styles

```javascript
import { registerBlockStyle } from '@wordpress/blocks';
import { __ } from '@wordpress/i18n';

// Button styles.
registerBlockStyle( 'core/button', {
    name: 'pill',
    label: __( 'Pill', 'myplugin' ),
} );

registerBlockStyle( 'core/button', {
    name: 'shadow',
    label: __( 'Shadow', 'myplugin' ),
} );

// Image styles.
registerBlockStyle( 'core/image', {
    name: 'rounded-lg',
    label: __( 'Rounded Large', 'myplugin' ),
} );

registerBlockStyle( 'core/image', {
    name: 'shadow-lg',
    label: __( 'Shadow Large', 'myplugin' ),
} );

// Group styles.
registerBlockStyle( 'core/group', {
    name: 'card',
    label: __( 'Card', 'myplugin' ),
} );
```

```css
/* style.css */
.wp-block-button.is-style-pill .wp-block-button__link {
    border-radius: 999px;
}

.wp-block-button.is-style-shadow .wp-block-button__link {
    box-shadow: 0 4px 14px rgba(0, 0, 0, 0.15);
}

.wp-block-image.is-style-rounded-lg img {
    border-radius: 1rem;
}

.wp-block-image.is-style-shadow-lg img {
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
}

.wp-block-group.is-style-card {
    background: #fff;
    border-radius: 0.5rem;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
    padding: 2rem;
}
```

## theme.json Configuration

### Comprehensive theme.json

```json
{
    "$schema": "https://schemas.wp.org/trunk/theme.json",
    "version": 3,
    "settings": {
        "appearanceTools": true,
        "useRootPaddingAwareAlignments": true,
        "color": {
            "palette": [
                { "slug": "primary", "color": "#0066cc", "name": "Primary" },
                { "slug": "secondary", "color": "#6c757d", "name": "Secondary" },
                { "slug": "accent", "color": "#ffc107", "name": "Accent" },
                { "slug": "dark", "color": "#212529", "name": "Dark" },
                { "slug": "light", "color": "#f8f9fa", "name": "Light" },
                { "slug": "white", "color": "#ffffff", "name": "White" }
            ],
            "gradients": [
                {
                    "slug": "primary-to-accent",
                    "gradient": "linear-gradient(135deg, var(--wp--preset--color--primary) 0%, var(--wp--preset--color--accent) 100%)",
                    "name": "Primary to Accent"
                }
            ],
            "custom": true,
            "customGradient": true,
            "duotone": [],
            "link": true
        },
        "typography": {
            "fluid": true,
            "fontFamilies": [
                {
                    "fontFamily": "Inter, system-ui, sans-serif",
                    "slug": "primary",
                    "name": "Primary"
                },
                {
                    "fontFamily": "Georgia, serif",
                    "slug": "secondary",
                    "name": "Secondary"
                }
            ],
            "fontSizes": [
                { "slug": "small", "size": "0.875rem", "name": "Small" },
                { "slug": "medium", "size": "1rem", "name": "Medium" },
                { "slug": "large", "size": "1.25rem", "name": "Large" },
                { "slug": "x-large", "size": "1.5rem", "name": "Extra Large" },
                { "slug": "xx-large", "size": "2rem", "name": "2XL" },
                { "slug": "hero", "size": "clamp(2.5rem, 5vw, 4rem)", "name": "Hero" }
            ],
            "lineHeight": true,
            "letterSpacing": true,
            "textDecoration": true,
            "textTransform": true
        },
        "spacing": {
            "padding": true,
            "margin": true,
            "blockGap": true,
            "units": [ "px", "rem", "%", "vw", "vh" ],
            "spacingSizes": [
                { "slug": "10", "size": "0.5rem", "name": "1" },
                { "slug": "20", "size": "1rem", "name": "2" },
                { "slug": "30", "size": "1.5rem", "name": "3" },
                { "slug": "40", "size": "2rem", "name": "4" },
                { "slug": "50", "size": "3rem", "name": "5" },
                { "slug": "60", "size": "4rem", "name": "6" }
            ]
        },
        "layout": {
            "contentSize": "768px",
            "wideSize": "1200px"
        },
        "border": {
            "color": true,
            "radius": true,
            "style": true,
            "width": true
        },
        "shadow": {
            "presets": [
                {
                    "slug": "small",
                    "shadow": "0 1px 3px rgba(0,0,0,0.12)",
                    "name": "Small"
                },
                {
                    "slug": "medium",
                    "shadow": "0 4px 12px rgba(0,0,0,0.15)",
                    "name": "Medium"
                },
                {
                    "slug": "large",
                    "shadow": "0 10px 40px rgba(0,0,0,0.2)",
                    "name": "Large"
                }
            ]
        },
        "blocks": {
            "core/button": {
                "border": {
                    "radius": true
                }
            },
            "core/paragraph": {
                "color": {
                    "link": true
                }
            }
        }
    },
    "styles": {
        "color": {
            "background": "var(--wp--preset--color--white)",
            "text": "var(--wp--preset--color--dark)"
        },
        "typography": {
            "fontFamily": "var(--wp--preset--font-family--primary)",
            "fontSize": "var(--wp--preset--font-size--medium)",
            "lineHeight": "1.6"
        },
        "spacing": {
            "padding": {
                "top": "0",
                "right": "var(--wp--preset--spacing--20)",
                "bottom": "0",
                "left": "var(--wp--preset--spacing--20)"
            }
        },
        "elements": {
            "heading": {
                "typography": {
                    "fontFamily": "var(--wp--preset--font-family--primary)",
                    "fontWeight": "700",
                    "lineHeight": "1.2"
                },
                "color": {
                    "text": "var(--wp--preset--color--dark)"
                }
            },
            "link": {
                "color": {
                    "text": "var(--wp--preset--color--primary)"
                },
                ":hover": {
                    "color": {
                        "text": "var(--wp--preset--color--accent)"
                    }
                }
            },
            "button": {
                "border": {
                    "radius": "4px"
                },
                "color": {
                    "background": "var(--wp--preset--color--primary)",
                    "text": "var(--wp--preset--color--white)"
                },
                ":hover": {
                    "color": {
                        "background": "var(--wp--preset--color--dark)"
                    }
                }
            }
        },
        "blocks": {
            "core/site-title": {
                "typography": {
                    "fontSize": "var(--wp--preset--font-size--large)",
                    "fontWeight": "700"
                }
            }
        }
    },
    "templateParts": [
        { "name": "header", "title": "Header", "area": "header" },
        { "name": "footer", "title": "Footer", "area": "footer" }
    ],
    "customTemplates": [
        { "name": "blank", "title": "Blank", "postTypes": [ "page" ] },
        { "name": "full-width", "title": "Full Width", "postTypes": [ "page", "post" ] }
    ]
}
```

## Extending Core Blocks

### Filter Block Settings

```javascript
import { addFilter } from '@wordpress/hooks';

// Add custom attribute to core/paragraph.
addFilter(
    'blocks.registerBlockType',
    'myplugin/add-paragraph-attribute',
    ( settings, name ) => {
        if ( name !== 'core/paragraph' ) {
            return settings;
        }

        return {
            ...settings,
            attributes: {
                ...settings.attributes,
                isHighlighted: {
                    type: 'boolean',
                    default: false,
                },
            },
        };
    }
);

// Add control to BlockEdit.
import { createHigherOrderComponent } from '@wordpress/compose';
import { InspectorControls } from '@wordpress/block-editor';
import { PanelBody, ToggleControl } from '@wordpress/components';

const withHighlightControl = createHigherOrderComponent( ( BlockEdit ) => {
    return ( props ) => {
        if ( props.name !== 'core/paragraph' ) {
            return <BlockEdit { ...props } />;
        }

        const { attributes, setAttributes } = props;

        return (
            <>
                <BlockEdit { ...props } />
                <InspectorControls>
                    <PanelBody title="Highlight">
                        <ToggleControl
                            label="Highlight this paragraph"
                            checked={ attributes.isHighlighted }
                            onChange={ ( value ) =>
                                setAttributes( { isHighlighted: value } )
                            }
                        />
                    </PanelBody>
                </InspectorControls>
            </>
        );
    };
}, 'withHighlightControl' );

addFilter(
    'editor.BlockEdit',
    'myplugin/highlight-control',
    withHighlightControl
);

// Modify save output.
addFilter(
    'blocks.getSaveContent.extraProps',
    'myplugin/highlight-class',
    ( extraProps, blockType, attributes ) => {
        if ( blockType.name !== 'core/paragraph' ) {
            return extraProps;
        }

        if ( attributes.isHighlighted ) {
            extraProps.className = `${ extraProps.className || '' } is-highlighted`.trim();
        }

        return extraProps;
    }
);
```

## Common Patterns and Best Practices

### Responsive Block Styles

```scss
// editor.scss & style.scss
.wp-block-myplugin-feature-card {
    display: grid;
    gap: 1rem;
    padding: 2rem;

    @media (min-width: 768px) {
        grid-template-columns: auto 1fr;
        gap: 2rem;
    }

    &__icon {
        font-size: 3rem;
        color: var(--wp--preset--color--primary);
    }

    &__title {
        margin: 0 0 0.5rem;
    }

    &__description {
        margin: 0;
        color: var(--wp--preset--color--secondary);
    }
}
```

### Block Deprecation

```jsx
const v1 = {
    attributes: {
        title: { type: 'string' },
        // Old attribute structure.
    },
    save( { attributes } ) {
        return (
            <div className="old-class">
                <h2>{ attributes.title }</h2>
            </div>
        );
    },
};

export const deprecated = [ v1 ];

// In index.js.
import { deprecated } from './deprecated';

registerBlockType( 'myplugin/block', {
    // ...
    deprecated,
} );
```

## Severity Definitions

| Severity | Description |
|----------|-------------|
| **Critical** | Block won't save/render, crashes editor |
| **Warning** | Deprecated API, poor performance, accessibility issues |
| **Info** | Best practice suggestions, optimizations |

## Quick Reference: Anti-Patterns

| Anti-Pattern | Issue | Fix |
|-------------|-------|-----|
| No block.json | Missing metadata, slower loading | Use block.json for all blocks |
| Inline styles in Save | Hard to maintain | Use CSS classes, block supports |
| useEffect for initial data | Runs on every render | Use useMemo or default attributes |
| RichText without formatting | Limited editing | Define allowedFormats prop |
| No loading states | Poor UX for async data | Use Spinner, Placeholder |
| Missing i18n | Not translatable | Wrap strings in __() |

## Deep-Dive References

| Task | Reference to Load |
|------|-------------------|
| Building complex blocks | `references/advanced-blocks.md` |
| FSE template development | `references/fse-guide.md` |
| Block editor performance | `references/editor-performance.md` |
