# Official Source Index and Freshness Rules

Use official Roblox Creator Hub / Luau documentation as the source of truth for engine behavior and APIs. Community tutorials can inspire presentation or workflow, but verify technical claims against official documentation before using them in code.

## Topic index

| Topic | Official documentation |
|---|---|
| UI overview and primitives | https://create.roblox.com/docs/ui |
| Position, size, anchor, layering | https://create.roblox.com/docs/ui/position-and-size |
| Layouts | https://create.roblox.com/docs/ui/list-flex-layouts and https://create.roblox.com/docs/ui/grid-table-layouts |
| UI styling | https://create.roblox.com/docs/ui/styling |
| UI animation | https://create.roblox.com/docs/ui/animation |
| Luau language | https://create.roblox.com/docs/luau |
| Luau types | https://create.roblox.com/docs/luau/type-checking |
| Engine APIs | https://create.roblox.com/docs/reference/engine |
| Security | https://create.roblox.com/docs/scripting/security/security-tactics |
| Client-server model | https://create.roblox.com/docs/projects/client-server |
| Studio testing | https://create.roblox.com/docs/studio/testing-modes |
| Device Simulator | https://create.roblox.com/docs/studio/device-simulator |
| Data stores | https://create.roblox.com/docs/cloud-services/data-stores |
| Rojo | https://rojo.space/docs |

## Verification discipline

- Roblox engine features evolve. Re-check unfamiliar, recently introduced, deprecated, restricted, or security-sensitive details each time they matter.
- Search for the exact class/property/method in Creator Hub's current API reference. Confirm scriptability, security context, parameter/return types, and supported container.
- If a documentation page cannot be accessed or does not establish a claim, state the uncertainty; do not fill gaps by guessing.
- Don't embed engine release numbers, dates, or claims of “latest” in durable advice unless directly verified at task time.
- Cite official docs in user-facing technical explanations when the claim affects a non-obvious implementation choice or production safety.

## Knowledge sources used to shape this skill

- Roblox Creator Hub, [User interface](https://create.roblox.com/docs/ui)
- Roblox Creator Hub, [Position and size UI objects](https://create.roblox.com/docs/ui/position-and-size)
- Roblox Creator Hub, [Luau](https://create.roblox.com/docs/luau)
- Roblox Creator Hub, [Studio testing modes](https://create.roblox.com/docs/studio/testing-modes)
- Community design pattern reference: [roblox-dev-skill](https://github.com/msayib/roblox-dev-skill). This is used as inspiration for modular references, explicit verification, and broad coverage only; this Skill is independently written and does not copy its text or claim affiliation.
