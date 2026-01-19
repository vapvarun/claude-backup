# WP Blog Publishing Workflow

**MCP Server**: `~/.mcp-servers/wp-blog-mcp-server/`
**Full docs**: See `CLAUDE-WORKFLOW.md` in that directory

## Pre-Publish Checklist

1. **Content**: 2000+ words, Gutenberg blocks, proper headings
2. **Images**: Upload with alt text
3. **Tags**: Run `suggest_tags` → create/assign 3-5 tags
4. **Internal Links**: Run `suggest_internal_links` → add 2+ links
5. **Featured Image**: Upload and set with `media_set_featured`
6. **Audit**: Run `audit_pre_publish` - ALL checks must pass
7. **Publish**: Use `post_publish_safe` only after audit passes

## Post-Publish (Social Media)

1. `social_generate` - All platforms
2. `social_generate_assets` - Platform images
3. `social_list` - Review content
4. `social_export` - For scheduling tools

## Tool Order

```
Pre-Publish:
post_create → suggest_tags → tag_create → suggest_internal_links →
post_update → media_set_featured → audit_pre_publish → post_publish_safe

Post-Publish:
social_generate → social_generate_assets → social_list → social_export
```

## Our Standards

| Check | Default | Our Standard |
|-------|---------|--------------|
| Word Count | 300 | **2000+** |
| Tags | 1 | **3-5** |
| Internal Links | 2 | **2-3** |
| SEO Score | 70 | **80+** |
