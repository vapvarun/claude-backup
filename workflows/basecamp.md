# Basecamp Workflows

## Token Sync (OAuth Expired)

Quick fix:
```bash
~/.mcp-servers/basecamp-mcp-server/sync-token.sh
```
Then restart Claude Code.

Manual fix if script fails:
1. Refresh token in WordPress: `http://reign-release.local/wp-admin/options-general.php?page=basecamp-reader`
2. Read token from WP DB:
```bash
cd /Users/varundubey/Local\ Sites/reign-release/app/public && wp eval '
$data = get_option("bcr_token_data");
echo "ACCESS_TOKEN=" . $data["access_token"] . "\n";
echo "REFRESH_TOKEN=" . $data["refresh_token"] . "\n";
'
```
3. Update BOTH config files with tokens:
   - `~/.mcp-servers/basecamp-mcp-server/config.json`
   - `~/Library/Application Support/Claude/claude_desktop_config.json`
4. Restart Claude Code

---

## WP Community Documents (Sayansi)

**Project ID**: `44836778`

| Column | URL | Use For |
|--------|-----|---------|
| **Functionality Issues** | https://3.basecamp.com/5798509/buckets/44836778/card_tables/columns/9294572132 | Bug reports |
| **Testing** | https://3.basecamp.com/5798509/buckets/44836778/card_tables/columns/9294572959 | QA testing |

**Workflow**: Pick card from Issues → Fix → Comment with details → Move to Testing

---

## Basecamp Formatting

Use HTML tags (markdown doesn't render):
- `<strong>` for bold
- `<br>` for line breaks

Example:
```html
<strong>Fixed</strong> - Issue resolved<br><br><strong>Root Cause:</strong><br>Description here
```
