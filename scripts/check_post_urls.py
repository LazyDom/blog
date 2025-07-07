#!/usr/bin/env python3
import re
import sys
from pathlib import Path

POSTS_DIR = Path(__file__).parent.parent / '_posts'
MARKDOWN_DIR = Path(__file__).parent.parent
POST_URL_PATTERN = re.compile(r'\{\%\s*post_url\s+([\w\-]+)\s*\%\}')

# Collect all post references (full filename without extension)
post_refs = set(post_file.stem for post_file in POSTS_DIR.glob('*.md'))

# Search all markdown files for post_url tags
errors = []
for md_file in MARKDOWN_DIR.glob('*.md'):
    with md_file.open() as f:
        for i, line in enumerate(f, 1):
            for match in POST_URL_PATTERN.finditer(line):
                ref = match.group(1)
                if ref not in post_refs:
                    errors.append(f"{md_file}: Line {i}: Broken post_url reference: '{ref}'")

if errors:
    print("Broken Jekyll post_url references found:")
    for err in errors:
        print(err)
    sys.exit(1)
else:
    print("All Jekyll post_url references are valid.")
