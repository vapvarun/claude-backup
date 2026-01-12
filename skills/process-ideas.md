# Process Ideas Skill

Process content ideas from the Ideas pipeline into full WordPress articles.

## Usage

```
/process-ideas [options]
```

## Options

- `--priority=<level>` - Filter by priority (high, medium, low, urgent). Default: high,urgent
- `--limit=<n>` - Maximum ideas to process. Default: 5
- `--dry-run` - Preview what would be processed without creating posts
- `--site=<site_id>` - Process ideas for specific site only
- `--skip-audit` - Skip pre-publish audit (not recommended)
- `--skip-social` - Skip social content generation

## What This Skill Does

For each qualifying idea:

### Phase 1: Content Generation
1. Fetch idea details (title, description, target keywords)
2. Generate full article using `content_generate` tool
   - 2000+ words
   - Proper heading structure (H2, H3)
   - Engaging intro with hook
   - Actionable content
   - Strong conclusion with CTA
3. Create WordPress draft with `post_create`

### Phase 2: SEO & Optimization
4. Run `suggest_tags` and apply relevant tags
5. Run `suggest_internal_links` and add 2-3 internal links
6. Search for relevant stock photo and set as featured image
7. Generate meta description

### Phase 3: Quality Check
8. Run `audit_pre_publish` to verify:
   - Word count >= 2000
   - Featured image present
   - Tags assigned (3-5)
   - Internal links (2+)
   - SEO score >= 80
9. Report any issues found

### Phase 4: Cleanup
10. Update idea status to "draft" with `idea_update`
11. Link idea to WordPress post ID

### Phase 5: Social (Optional)
12. Generate social content with `social_generate`
13. Generate platform assets with `social_generate_assets`

## Example Workflows

### Process all high priority ideas
```
/process-ideas
```

### Preview without creating posts
```
/process-ideas --dry-run
```

### Process urgent ideas for specific site
```
/process-ideas --priority=urgent --site=flavtheme
```

### Process with limit
```
/process-ideas --limit=3
```

## Output

The skill outputs a summary table:

```
Processed Ideas Summary
=======================

| Idea | Title | Status | Post ID | Audit Score |
|------|-------|--------|---------|-------------|
| #12  | How to... | Created | 1234 | 85/100 |
| #15  | Top 10... | Created | 1235 | 92/100 |
| #18  | Guide to... | Failed | - | Missing image |

Total: 3 ideas processed
- 2 drafts created successfully
- 1 failed (see details above)
```

## Requirements

- Ideas must exist in the Ideas pipeline (use dashboard or `idea_create`)
- WordPress site must be configured in wp-blog MCP server
- Site must be synced (`index_sync`)

## Related Tools

- `idea_list` - View all ideas
- `idea_create` - Add new idea
- `idea_get_pipeline` - View ideas by status
- `content_generate` - Generate article content
- `audit_pre_publish` - Check post quality
