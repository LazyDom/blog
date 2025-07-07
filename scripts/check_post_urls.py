#!/usr/bin/env python3
import re
import sys
from pathlib import Path

POSTS_DIR = Path(__file__).parent.parent / '_posts'
MARKDOWN_DIR = Path(__file__).parent.parent
POST_URL_PATTERN = re.compile(r'\{\%\s*post_url\s+([\w\-]+)\s*\%\}')

# Collect all post slugs (filenames without date and extension)
post_slugs = set()
for post_file in POSTS_DIR.glob('*.md'):
    # e.g., 2025-04-27-how-to-install-minikube-on-wsl2.md -> how-to-install-minikube-on-wsl2
    slug = '-'.join(post_file.stem.split('-')[3:])
    if not slug:
        slug = post_file.stem  # fallback
    post_slugs.add(slug)

# Search all markdown files for post_url tags
errors = []
for md_file in MARKDOWN_DIR.glob('*.md'):
    with md_file.open() as f:
        for i, line in enumerate(f, 1):
            for match in POST_URL_PATTERN.finditer(line):
                ref = match.group(1)
                if ref not in post_slugs:
                    errors.append(f"{md_file}: Line {i}: Broken post_url reference: '{ref}'")

if errors:
    print("Broken Jekyll post_url references found:")
    for err in errors:
        print(err)
    sys.exit(1)
else:
    print("All Jekyll post_url references are valid.")
