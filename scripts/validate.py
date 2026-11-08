#!/usr/bin/env python3
"""Sanity-check every skill: SKILL.md exists, has frontmatter with a description, no broken symlinks.

Exit code is non-zero if any check fails. `shared/` is a support folder, not a skill, and is exempt.
"""
import re
import sys
from pathlib import Path

SKILLS = Path(__file__).resolve().parent.parent / "skills"
SUPPORT = {"shared"}


def main():
    problems, count = [], 0
    for d in sorted(SKILLS.iterdir()):
        if not d.is_dir() or d.name in SUPPORT:
            continue
        count += 1
        f = d / "SKILL.md"
        if not f.is_file():
            problems.append(f"{d.name}: missing SKILL.md")
            continue
        text = f.read_text(encoding="utf-8", errors="replace")
        m = re.match(r"---\s*\n(.*?)\n---", text, re.S)
        if not m:
            problems.append(f"{d.name}: no frontmatter")
        elif not re.search(r"^description:", m.group(1), re.M):
            problems.append(f"{d.name}: frontmatter has no description")
        for p in d.rglob("*"):
            if p.is_symlink() and not p.exists():
                problems.append(f"{d.name}: broken symlink {p.relative_to(d)}")
    for p in problems:
        print("FAIL", p)
    print(f"checked {count} skills, {len(problems)} problem(s)")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
