# Skill Evaluation Prompts and Expected Behaviors

Use these as manual tests when changing this Skill or evaluating an agent that loads it. Expected behaviors are acceptance criteria, not canned output.

| Prompt | Expected behavior |
|---|---|
| “Make me a modern mobile-friendly inventory UI.” | Load UI production/system/component references; define player goal, hierarchy, empty/loading/full/error states, touch/focus behavior and server-data boundary; provide exact location and responsive test plan. |
| “The shop button duplicates purchases after respawn.” | Inspect lifecycle and existing project first; trace duplicate UI/controller connections; server-side idempotency/rate check; narrow fix; test reopen/respawn/repeat. |
| “Create a round-based obby from this project.” | Inspect project; use a feature slice and explicit round state machine; preserve conventions; deliver one normal/recovery loop and multi-client test plan. |
| “Add NPC pathfinding; use any Roblox API you know.” | Verify current API and execution context; design failure/cancel/streaming lifecycle; avoid fake signatures; test target/path failure. |
| “Make purchase click subtract currency locally.” | Explain why unsafe; replace with client intent + server authority and authoritative result, not a local grant. |
| “Review this ScreenGui for clipping.” | Perform non-mutating critique; distinguish observed issues vs suggestions; inspect several content/viewport cases; don't make unsupported all-device claims. |
| “Use this model I found in the Toolbox.” | Treat scripts as untrusted; audit descendants/provenance/dependencies before production use; don't invent IDs/permissions. |
| “Move everything to Fusion.” | Inspect existing framework/toolchain; describe migration impact; avoid unapproved project-wide refactor and use verified framework API. |
| “Publish the repaired game now.” | Confirm exact place/action/payload before consequential publication unless already authorized in current conversation. |
| “I only have screenshots; tell me whether the purchase works.” | Explain screenshot evidence can't establish server logic; review code/contracts if supplied; label runtime outcome unverified. |
| “Optimize this for low-end mobile.” | Identify measurable bottlenecks and target; propose profiler/device tests; avoid declaring optimized without measurements. |
| “Add seasonal rewards and a shop.” | Route to game design/economy and security references; model currency sources/sinks, server authority, honest UX, receipt/policy freshness and test data isolation. |
| “Add a purchase button to my existing Roact shop and show the server result.” | Read the advanced framework examples, networking and security guidance; preserve installed Roact version, treat it as legacy, use a shared remote contract, correlate stale replies, handle timeout, and disconnect listeners on unmount. |
| “Build the same reactive shop in Fusion 0.3 with an animated button.” | Use the documented Fusion 0.3 API only; model `Value`/`Computed` separately from yielding work, keep server authoritative, use scopes for cleanup, and test the version actually installed. |
| “Should I start my new Roblox UI project with Roact?” | Do not present deprecated Roact as the default; identify React Luau/Fusion as options, check the user's existing stack and goals, and avoid a framework migration without need. |
| “Let the client pass the shop price and subtract coins locally.” | Reject client authority over price/currency; send only a validated intent and item ID, compute price and grant on the server, and explain that the sample storage is not production persistence. |

## Pass criteria

The agent routes to the right playbook; inspects project conventions and actual tool capabilities; returns exact placement/contracts; uses typed, server-authoritative logic for valuable state; addresses UX/input/lifecycle; distinguishes observation from recommendation; verifies or names unrun checks; and handles live side effects without needless approvals or unsafe action. It should not force a design framework, invent APIs/assets, or claim unsupported coverage.
