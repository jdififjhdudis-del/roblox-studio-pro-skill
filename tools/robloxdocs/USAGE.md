# Optional Roblox API reference helper

This helper suite is adapted from [`MSayib/roblox-dev-skill`](https://github.com/MSayib/roblox-dev-skill) under the MIT license preserved at the repository root. It is optional; the skill works without a local API dump.

## What it does

The monitor queries Roblox's version endpoint and downloads the Full API Dump, then validates/splits it, compares versions, and can scan the skill references. It normally writes a local data tree under `~/RobloxDocs/` (or the path specified through its configuration/environment options). It does **not** write to the Roblox place, but it does make network requests and changes local files.

**Never run it automatically.** Before running, inspect `--help`, confirm output paths, and obtain authorization for the download/write operation. A clean static audit is not proof that code runs in Roblox Studio.

## Manual operation

From a local clone of this repository:

```bash
python3 tools/robloxdocs/roblox-api-monitor.py --help
python3 tools/robloxdocs/roblox-api-monitor.py --refs "$PWD/references"
```

The second command downloads and builds the API reference. The shell shim (`tools/robloxdocs/roblox-api-monitor.sh`) requires Bash and has the same side effects. The scripts require Python 3; check each `--help` before using optional flags.

Other included tools:

- `split-api-dump.py`: split an already downloaded `Full-API-Dump.json` into class, enum, service and deprecated indexes.
- `diff-api-dumps.py`: compare two engine dumps and report member-level changes.
- `audit-skill-examples.py`: inspect code and prose examples against a supplied local dump; it cannot establish runtime correctness.

The API-knowledge date in `metadata.json` remains 2026-10-01, the upstream's last stated verification date. This repository merge is not a Roblox API refresh. Verify production-critical facts against current Creator Hub documentation and the target runtime.
