# Research Provenance and Design Rationale

This Skill is independently written. It draws general workflow ideas from the public repositories below; it does not reproduce their text, assume their APIs are available, or imply endorsement. Verify all Roblox technical details against current official docs. Repository state and tool features may change.

## Repositories inspected

| Repository | Distinct contribution used as design inspiration |
|---|---|
| [TabooHarmony/roblox-brain](https://github.com/TabooHarmony/roblox-brain) | Modular topic coverage; risk-scaled inspection/mutation; cross-device UI and evidence-oriented testing. |
| [MSayib/roblox-dev-skill](https://github.com/MSayib/roblox-dev-skill) | Compact router plus focused references; runnable task workflows; distinct player-to-server and agent-to-Studio safety models; freshness discipline. |
| [afrxo/roblox-agent-skills](https://github.com/afrxo/roblox-agent-skills) | Separation of Luau, runtime, toolchain and UI; typed data boundaries; preserve project tooling; examples paired with guidance. |
| [gamedev-skills/awesome-gamedev-agent-skills](https://github.com/gamedev-skills/awesome-gamedev-agent-skills) | Narrow domain playbooks; inspect source-of-truth before editing; authored UI shell, responsive composition and test matrices. |
| [zilibobi/roblox-skills](https://github.com/zilibobi/roblox-skills) | Proactive docs retrieval, freshness/offline disclosure, source citations and alternate-query fallback. |
| [hope1026/weppy-roblox-mcp](https://github.com/hope1026/weppy-roblox-mcp) | Explicit target/capability before mutation; evidence-aware UI review; bounded preview/adjust/test loop; separation of input evidence from server outcome. |
| [AshExplained/roblox-skills](https://github.com/AshExplained/roblox-skills) | Life-cycle routing across UX, UI implementation, mobile testing, security/economy, debugging, publishing and creator-store auditing; phone-first design with explicit state briefs. |
| [JustineDevs/roblox-ai-os](https://github.com/JustineDevs/roblox-ai-os) | Brief → blueprint → implementation → verification workflow and an explicit pre-action research/planning gate. Its runtime/setup is Codex-specific and is not assumed here. |
| [brockmartin/roblox-game-skill](https://github.com/brockmartin/roblox-game-skill) | Router plus workflow/reference/template library; task-specific debugging, security, performance and release checklists. Treat README counts/features as project claims, not independent verification. |
| [boshyxd/robloxstudio-mcp](https://github.com/boshyxd/robloxstudio-mcp) | Read-only inspection before mutation and tool mode distinctions. Repository README states that this project is archived and recommends a maintained fork; do not install or assume its MCP tools. |

## What this Skill adapts

The earlier six projects were examined for repository structure and selected checked-in skill/reference contents; this iteration additionally inspected four individual AshExplained instruction files (`roblox-ui-implementation`, `roblox-game-ux`, `roblox-mobile-playtest`, and `roblox-security-economy`). For JustineDevs and brockmartin, only the repository page/README and linked workflow claims were reviewed here, not every referenced implementation file. For boshyxd, the repository README was reviewed and itself reports the project archived. Their advertised feature counts and operational claims are therefore not treated as independently verified. Shared, useful patterns informed this Skill's short intent router, specialist references, explicit preflight, narrow edits, responsive UI brief, state checklist, evidence ledger, API freshness rules, vertical feature slices, reusable design templates and scoped safety gates. UI is expanded beyond engine mechanics into player goal, information hierarchy, art direction, input modes, component states, visual iteration and observed test evidence. Broader game-development coverage now includes gameplay feature slices, game design/operations, and asset/animation/audio workflows.

## What this Skill does not assume or copy

A repository's MCP/plugin schemas, framework APIs, tool selectors, test assets, palette values, device thresholds, marketplace statements or version claims are specific to that project. They are not imported as contracts. This Skill does not depend on a particular MCP server, Fusion, a local docs mirror, a specific Rojo toolchain, or screenshot/visual-checker capability. When such a capability is present, verify its live schema and report its actual limits.

The research indicates the skill libraries are useful design references, not substitutes for current official documentation or a running Studio test. Their examples may be incomplete, version-sensitive, or unexecuted; do not copy code without project/API verification. One inspected MCP repository declares itself archived; its operations are not adopted as current tool contracts. Product-specific workflows, paid/permissioned operations, token/palette values, timing targets and runtime command names are not treated as universal.
