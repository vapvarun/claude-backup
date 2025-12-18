---
name: wordpress-gutenberg
description: Create WordPress Gutenberg blocks, block patterns, and Full Site Editing templates. Use when building custom blocks, block themes, or extending the block editor.
---

# WordPress Gutenberg Skill

## Instructions

When developing for Gutenberg:

### 1. Block Registration (PHP)

```php
function register_custom_block() {
    register_block_type(__DIR__ . '/build/custom-block');
}
add_action('init', 'register_custom_block');
```

### 2. block.json

```json
{
  "$schema": "https://schemas.wp.org/trunk/block.json",
  "apiVersion": 3,
  "name": "theme/custom-block",
  "version": "1.0.0",
  "title": "Custom Block",
  "category": "theme",
  "icon": "star-filled",
  "description": "A custom block for the theme.",
  "keywords": ["custom", "block"],
  "supports": {
    "html": false,
    "align": ["wide", "full"],
    "color": {
      "background": true,
      "text": true,
      "gradients": true
    },
    "spacing": {
      "margin": true,
      "padding": true
    },
    "typography": {
      "fontSize": true,
      "lineHeight": true
    }
  },
  "attributes": {
    "title": {
      "type": "string",
      "default": ""
    },
    "content": {
      "type": "string",
      "source": "html",
      "selector": "p"
    },
    "mediaId": {
      "type": "number"
    },
    "mediaUrl": {
      "type": "string"
    }
  },
  "textdomain": "theme",
  "editorScript": "file:./index.js",
  "editorStyle": "file:./index.css",
  "style": "file:./style-index.css",
  "render": "file:./render.php"
}
```

### 3. Edit Component (JavaScript)

```jsx
import { __ } from '@wordpress/i18n';
import {
  useBlockProps,
  RichText,
  MediaUpload,
  MediaUploadCheck,
  InspectorControls,
} from '@wordpress/block-editor';
import {
  PanelBody,
  Button,
  TextControl,
  ToggleControl,
} from '@wordpress/components';

export default function Edit({ attributes, setAttributes }) {
  const { title, content, mediaId, mediaUrl } = attributes;
  const blockProps = useBlockProps();

  return (
    <>
      <InspectorControls>
        <PanelBody title={__('Settings', 'theme')}>
          <TextControl
            label={__('Title', 'theme')}
            value={title}
            onChange={(value) => setAttributes({ title: value })}
          />
        </PanelBody>
      </InspectorControls>

      <div {...blockProps}>
        <MediaUploadCheck>
          <MediaUpload
            onSelect={(media) => setAttributes({
              mediaId: media.id,
              mediaUrl: media.url,
            })}
            allowedTypes={['image']}
            value={mediaId}
            render={({ open }) => (
              <Button onClick={open} variant="secondary">
                {mediaUrl
                  ? <img src={mediaUrl} alt="" />
                  : __('Select Image', 'theme')
                }
              </Button>
            )}
          />
        </MediaUploadCheck>

        <RichText
          tagName="p"
          value={content}
          onChange={(value) => setAttributes({ content: value })}
          placeholder={__('Enter content...', 'theme')}
        />
      </div>
    </>
  );
}
```

### 4. Save Component

```jsx
import { useBlockProps, RichText } from '@wordpress/block-editor';

export default function Save({ attributes }) {
  const { title, content, mediaUrl } = attributes;
  const blockProps = useBlockProps.save();

  return (
    <div {...blockProps}>
      {mediaUrl && <img src={mediaUrl} alt="" />}
      {title && <h3>{title}</h3>}
      <RichText.Content tagName="p" value={content} />
    </div>
  );
}
```

### 5. Dynamic Block (PHP Render)

```php
<?php
// render.php
$title = $attributes['title'] ?? '';
$content = $attributes['content'] ?? '';
?>

<div <?php echo get_block_wrapper_attributes(); ?>>
    <?php if ($title) : ?>
        <h3><?php echo esc_html($title); ?></h3>
    <?php endif; ?>

    <?php if ($content) : ?>
        <div class="content">
            <?php echo wp_kses_post($content); ?>
        </div>
    <?php endif; ?>
</div>
```

### 6. Block Patterns

```php
register_block_pattern(
    'theme/hero-section',
    [
        'title'       => __('Hero Section', 'theme'),
        'description' => __('A hero section with heading and CTA.', 'theme'),
        'categories'  => ['theme-patterns'],
        'keywords'    => ['hero', 'header', 'banner'],
        'content'     => '
            <!-- wp:cover {"dimRatio":50,"minHeight":500} -->
            <div class="wp-block-cover" style="min-height:500px">
                <div class="wp-block-cover__inner-container">
                    <!-- wp:heading {"textAlign":"center","level":1} -->
                    <h1 class="has-text-align-center">Welcome</h1>
                    <!-- /wp:heading -->
                    <!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"}} -->
                    <div class="wp-block-buttons">
                        <!-- wp:button -->
                        <div class="wp-block-button">
                            <a class="wp-block-button__link">Get Started</a>
                        </div>
                        <!-- /wp:button -->
                    </div>
                    <!-- /wp:buttons -->
                </div>
            </div>
            <!-- /wp:cover -->
        ',
    ]
);

// Register pattern category
register_block_pattern_category('theme-patterns', [
    'label' => __('Theme Patterns', 'theme'),
]);
```

### 7. Block Variations

```javascript
import { registerBlockVariation } from '@wordpress/blocks';

registerBlockVariation('core/group', {
    name: 'card',
    title: 'Card',
    description: 'A card container with padding and shadow.',
    attributes: {
        className: 'is-style-card',
        style: {
            spacing: { padding: '2rem' },
            border: { radius: '8px' },
        },
    },
    isActive: (blockAttributes) =>
        blockAttributes.className?.includes('is-style-card'),
});
```

### 8. Block Styles

```javascript
import { registerBlockStyle } from '@wordpress/blocks';

registerBlockStyle('core/button', {
    name: 'outline',
    label: 'Outline',
});

registerBlockStyle('core/image', {
    name: 'rounded',
    label: 'Rounded',
});
```

```css
/* style.css */
.wp-block-button.is-style-outline .wp-block-button__link {
    background: transparent;
    border: 2px solid currentColor;
}

.wp-block-image.is-style-rounded img {
    border-radius: 1rem;
}
```

### 9. InnerBlocks

```jsx
import { InnerBlocks, useBlockProps } from '@wordpress/block-editor';

const ALLOWED_BLOCKS = ['core/heading', 'core/paragraph', 'core/image'];

const TEMPLATE = [
    ['core/heading', { placeholder: 'Title...' }],
    ['core/paragraph', { placeholder: 'Content...' }],
];

export default function Edit() {
    const blockProps = useBlockProps();

    return (
        <div {...blockProps}>
            <InnerBlocks
                allowedBlocks={ALLOWED_BLOCKS}
                template={TEMPLATE}
                templateLock={false}
            />
        </div>
    );
}

export function Save() {
    const blockProps = useBlockProps.save();

    return (
        <div {...blockProps}>
            <InnerBlocks.Content />
        </div>
    );
}
```

### 10. Build Setup

```json
// package.json
{
  "scripts": {
    "build": "wp-scripts build",
    "start": "wp-scripts start",
    "format": "wp-scripts format",
    "lint:js": "wp-scripts lint-js"
  },
  "devDependencies": {
    "@wordpress/scripts": "^27.0.0"
  }
}
```

### 11. Best Practices

- Use block.json for metadata
- Leverage core block components
- Support block.json settings (colors, spacing)
- Use RichText for editable content
- Provide InspectorControls for settings
- Make blocks translation-ready
- Test in both editor and frontend
- Follow WordPress coding standards
