# Research Provenance, License, and Integration Notes

## Upstream skill incorporated

This repository now **incorporates and modifies** the public [`MSayib/roblox-dev-skill`](https://github.com/MSayib/roblox-dev-skill), rather than claiming to be wholly independent. The imported baseline was the `master` commit [`fd4926f093dbdea137f0ed1d38aae4945b714785`](https://github.com/MSayib/roblox-dev-skill/commit/fd4926f093dbdea137f0ed1d38aae4945b714785), version 2.14.0, checked in on 2026-10-01. Its [`MIT License`](../LICENSE) is preserved in this repository; copied and adapted source material remains subject to that license.

The imported content includes the source `SKILL.md`, all 14 specialist references, the RobloxDocs API-monitor/split/diff/audit tools, the API-helper usage guide, metadata history, and its evaluation suite. The main skill was adapted to the name `roblox-studio-pro`, this repository's paths, and the additional UI, gameplay, asset and evidence playbooks. The API monitor's reference discovery, user-agent and issue URL were adapted for this repository. No upstream installer was copied or run.

The upstream's stated engine/Luau snapshot and verification date remain the source's own claims, not a new validation performed during this integration. `metadata.json` preserves the 2026-10-01 API knowledge date; this integration does **not** claim a Roblox API refresh. Re-check current Creator Hub documentation and actual available Studio/tool schemas before using version-sensitive facts. Optional API scripts can download or write local reference data; do not run a refresh unless the user has authorized that side effect.

## User-authored additions retained and integrated

The UI-focused material authored for this repository remains alongside the upstream engine-level `ui-systems.md`:

- `ui-production-workflow.md` — brief → implementation → preview → evidence workflow.
- `ui-component-patterns.md` — component/state patterns and worked UI scenarios.
- `ui-systems-roblox-studio-pro.md` — responsive composition, accessibility, lifecycle and game-context guidelines.
- `gameplay-systems-and-feature-slices.md`, `game-design-and-operations.md`, and `assets-animation-audio.md` — additional production playbooks.
- `templates/` — UI brief, feature slice, test evidence and a LocalScript UI demonstration.

The `.luau` demo has not been executed in Roblox Studio in this environment. Treat it as an editable starting point and verify it in the target experience.

## Additional design-pattern research

Earlier iterations reviewed these projects as design references, not as official Roblox API sources:

| Repository | Pattern considered |
|---|---|
| [TabooHarmony/roblox-brain](https://github.com/TabooHarmony/roblox-brain) | Modular topic coverage and risk-aware inspection/testing. |
| [afrxo/roblox-agent-skills](https://github.com/afrxo/roblox-agent-skills) | Separate architecture, Luau, toolchain and UI guidance. |
| [gamedev-skills/awesome-gamedev-agent-skills](https://github.com/gamedev-skills/awesome-gamedev-agent-skills) | Focused domain routing and responsive UI verification. |
| [zilibobi/roblox-skills](https://github.com/zilibobi/roblox-skills) | Documentation freshness and source-grounded answers. |
| [hope1026/weppy-roblox-mcp](https://github.com/hope1026/weppy-roblox-mcp) | Explicit target/capability checks and observed evidence. |
| [AshExplained/roblox-skills](https://github.com/AshExplained/roblox-skills) | Distinct UX, UI implementation, mobile playtest and security/economy workflows; four selected skill files were reviewed. |
| [JustineDevs/roblox-ai-os](https://github.com/JustineDevs/roblox-ai-os) | Brief → blueprint → implementation flow; only the repository page/README was reviewed. |
| [brockmartin/roblox-game-skill](https://github.com/brockmartin/roblox-game-skill) | Router/reference/template architecture; only repository page/README claims were reviewed. |
| [boshyxd/robloxstudio-mcp](https://github.com/boshyxd/robloxstudio-mcp) | Read-only inspection concepts; its README reports the project archived, so its tools are not assumed here. |

External skills, README claims, tool signatures, and code examples are not Roblox's official API contract. Verify engine behavior against current Creator Hub docs, the actual target place, and tools available in the agent's environment.
