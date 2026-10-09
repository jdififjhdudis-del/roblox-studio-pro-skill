#!/usr/bin/env python3
"""Lightweight, offline integrity tests for the merged Roblox skill distribution."""
from __future__ import annotations

import json
import py_compile
import re
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
errors: list[str] = []

skill_path = ROOT / "SKILL.md"
skill_text = skill_path.read_text(encoding="utf-8")
if not skill_text.startswith("---\n"):
    errors.append("SKILL.md: YAML frontmatter is missing")
name = re.search(r"^name:\s*(\S+)", skill_text, re.M)
if not name or name.group(1) != ROOT.name:
    errors.append(f"SKILL.md: name must match skill directory ({ROOT.name})")
if len(skill_text.splitlines()) >= 500:
    errors.append(f"SKILL.md: keep the entrypoint below 500 lines (got {len(skill_text.splitlines())})")

markdown = [skill_path, *ROOT.glob("references/*.md"), *ROOT.glob("templates/*.md"), ROOT / "tools/robloxdocs/USAGE.md"]
for path in markdown:
    text = path.read_text(encoding="utf-8")
    if text.count("```") % 2:
        errors.append(f"{path.relative_to(ROOT)}: unbalanced fenced code blocks")
    for raw in re.findall(r"\]\(([^)]+)\)", text):
        target = raw.split("#", 1)[0].strip().strip("<>")
        if not target or "://" in target or target.startswith(("mailto:", "tel:")):
            continue
        candidate = (path.parent / target).resolve()
        if not candidate.exists():
            candidate = (ROOT / target.lstrip("/\\")).resolve()
        try:
            candidate.relative_to(ROOT.resolve())
        except ValueError:
            errors.append(f"{path.relative_to(ROOT)}: link escapes skill root: {raw}")
        else:
            if not candidate.exists():
                errors.append(f"{path.relative_to(ROOT)}: missing local link: {raw}")

metadata = json.loads((ROOT / "metadata.json").read_text(encoding="utf-8"))
if metadata.get("skill_name") != ROOT.name:
    errors.append("metadata.json: skill_name does not match the skill directory")
if metadata.get("last_updated") != "2026-10-01T11:30:00+07:00":
    errors.append("metadata.json: API freshness date changed; don't imply an API refresh during integration")
if metadata.get("upstream_source", {}).get("license") != "MIT":
    errors.append("metadata.json: upstream license attribution is missing")

license_text = (ROOT / "LICENSE").read_text(encoding="utf-8")
for required in ("MIT License", "Copyright", "Permission is hereby granted"):
    if required.casefold() not in license_text.casefold():
        errors.append(f"LICENSE: missing required MIT text ({required})")

evals = json.loads((ROOT / "evals/evals.json").read_text(encoding="utf-8"))
if evals.get("skill_name") != ROOT.name:
    errors.append("evals/evals.json: skill_name does not match the skill directory")
if evals.get("version") != metadata.get("version"):
    errors.append("evals/evals.json: version must match metadata.json")
ids = [case.get("id") for case in evals.get("evals", [])]
if len(ids) != len(set(ids)):
    errors.append("evals/evals.json: duplicate case IDs")
for case in evals.get("evals", []):
    for ref in case.get("expected_references", []):
        if not (ROOT / "references" / ref).exists():
            errors.append(f"evals/evals.json: missing expected reference {ref!r} in case {case.get('id')}")

framework_dir = ROOT / "templates/framework-examples"
framework_files = {
    "server": framework_dir / "ShopService.server.luau",
    "roact": framework_dir / "RoactShop.client.luau",
    "fusion": framework_dir / "FusionShop.client.luau",
}
for label, path in framework_files.items():
    if not path.is_file():
        errors.append(f"framework examples: missing {path.relative_to(ROOT)}")

if all(path.is_file() for path in framework_files.values()):
    server = framework_files["server"].read_text(encoding="utf-8")
    roact = framework_files["roact"].read_text(encoding="utf-8")
    fusion = framework_files["fusion"].read_text(encoding="utf-8")
    reference = (ROOT / "references/advanced-ui-framework-examples.md").read_text(encoding="utf-8")
    checks = {
        "server-authoritative remote handler": "OnServerEvent:Connect" in server and "FireClient" in server,
        "server price and duplicate-ownership checks": "ITEM_PRICE" in server and "ownedItems[itemId]" in server,
        "client sends no price field": "PurchaseRequest:FireServer({ requestId = requestId, itemId = ITEM_ID })" in roact and "PurchaseRequest:FireServer({ requestId = requestId, itemId = ITEM_ID })" in fusion,
        "Roact cleanup and deferred UI events": "function ShopPanel:willUnmount()" in roact and "task.defer(function()" in roact,
        "Fusion 0.3 reactive state and scope cleanup": "Fusion.scoped(Fusion)" in fusion and "scope:Computed" in fusion and "scope:doCleanup()" in fusion,
        "framework limitations and install/test guidance": "deprecated" in reference.casefold() and "non-persistent" in reference.casefold() and "Studio verification plan" in reference,
    }
    for label, passed in checks.items():
        if not passed:
            errors.append(f"framework examples: failed check: {label}")

python_files = [*ROOT.glob("tools/robloxdocs/*.py"), Path(__file__)]
with tempfile.TemporaryDirectory() as temp:
    for path in python_files:
        try:
            py_compile.compile(str(path), cfile=str(Path(temp) / (path.stem + ".pyc")), doraise=True)
        except py_compile.PyCompileError as exc:
            errors.append(f"Python syntax error in {path.relative_to(ROOT)}: {exc.msg}")

if errors:
    print(f"FAIL: {len(errors)} skill integrity issue(s)")
    for error in errors:
        print(f"- {error}")
    sys.exit(1)

print(f"PASS: {len(markdown)} Markdown files checked; {len(evals['evals'])} eval cases; {len(python_files)} Python files compile.")
print("PASS: skill identity, MIT attribution, API freshness date, local links, fences, and eval routing.")
