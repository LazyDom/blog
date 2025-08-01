#!/bin/bash
# Usage: ./scripts/publish_draft.sh draft-filename.md
# Moves a draft from _drafts to _posts, renaming it with today's date prefix.

set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 draft-filename.md"
  exit 1
fi

draft="$1"
draft_path="$(dirname "$0")/../_drafts/$draft"
posts_dir="$(dirname "$0")/../_posts"

today=$(date +%Y-%m-%d)

if [ ! -f "$draft_path" ]; then
  echo "Draft file not found: $draft_path"
  exit 2
fi

new_name="${today}-${draft}"
new_path="$posts_dir/$new_name"

mv "$draft_path" "$new_path"
echo "Moved $draft to _posts as $new_name"
