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

## Pass criteria

The agent routes to the right playbook; inspects project conventions and actual tool capabilities; returns exact placement/contracts; uses typed, server-authoritative logic for valuable state; addresses UX/input/lifecycle; distinguishes observation from recommendation; verifies or names unrun checks; and handles live side effects without needless approvals or unsafe action. It should not force a design framework, invent APIs/assets, or claim unsupported coverage.
