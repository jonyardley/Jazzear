#!/usr/bin/env python3
"""Fail CI when a relative markdown link points at a file that doesn't exist."""

import re
import sys
from pathlib import Path

SKIP_DIRS = {".git", "target", "node_modules", ".build", "DerivedData"}
LINK = re.compile(r"\]\(([^)\s]+)\)")
EXTERNAL = ("http://", "https://", "mailto:", "tel:")

failures = []
for md in sorted(Path(".").rglob("*.md")):
    if SKIP_DIRS & set(md.parts):
        continue
    for match in LINK.finditer(md.read_text(encoding="utf-8")):
        target = match.group(1).split("#", 1)[0]
        if not target or target.startswith(EXTERNAL):
            continue
        if not (md.parent / target).exists():
            failures.append(f"{md}: broken link -> {match.group(1)}")

for failure in failures:
    print(failure)
sys.exit(1 if failures else 0)
