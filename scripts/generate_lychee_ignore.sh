#!/usr/bin/env bash
set -euo pipefail

# Dynamically generate / prune a .lycheeignore file for freshly added posts
# Avoids transient 404 on canonical URLs before GitHub Pages deployment propagates.

BASE_URL="https://lazydom.xyz/blog"
MAIN_BRANCH="origin/main"
IGNORE_FILE=".lycheeignore"
RETENTION_DAYS=4

echo "[lychee-ignore] Generating dynamic ignore list" >&2

# Ensure file exists immediately (even if later logic aborts)
touch "$IGNORE_FILE"

# Ensure we have main to diff against (best effort)
git fetch --quiet origin main || true

# Identify newly added post markdown files relative to main
new_posts=$(git diff --diff-filter=A --name-only "${MAIN_BRANCH}...HEAD" | grep '^_posts/.*\.md$' || true)

if [[ -z "${new_posts}" ]]; then
  echo "[lychee-ignore] No newly added posts detected; nothing to add." >&2
  # Still prune old entries
  touch "$IGNORE_FILE"
else
  echo "[lychee-ignore] New posts detected:\n${new_posts}" >&2
fi


# Prune entries older than cutoff (comments look like: # added: YYYY-MM-DD)
cutoff=$(date -u -d "${RETENTION_DAYS} days ago" +%Y-%m-%d)
today=$(date -u +%Y-%m-%d)
tmpfile=$(mktemp)

while IFS= read -r line; do
  if [[ "$line" =~ ^#\ added:\ ([0-9]{4}-[0-9]{2}-[0-9]{2})$ ]]; then
    ts="${BASH_REMATCH[1]}"
    if [[ "$ts" < "$cutoff" ]]; then
      # Skip this dated comment and the next line (assumed URL)
      read -r _ || true
      continue
    fi
  fi
  echo "$line" >> "$tmpfile"
done < "$IGNORE_FILE"

mv "$tmpfile" "$IGNORE_FILE"

for f in $new_posts; do
  slug=$(basename "$f" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}-(.*)\.md$/\1/')
  url="${BASE_URL}/${slug}/"
  if ! grep -Fxq "$url" "$IGNORE_FILE"; then
    {
      echo "# added: $today"
      echo "$url"
    } >> "$IGNORE_FILE"
    echo "[lychee-ignore] Added $url" >&2
  fi
done

echo "[lychee-ignore] Final $IGNORE_FILE contents:" >&2
sed 's/^/  /' "$IGNORE_FILE" >&2