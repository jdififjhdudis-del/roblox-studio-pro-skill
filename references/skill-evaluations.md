# Skill Evaluation Prompts and Expected Behaviors

Use these prompts as a manual quality check when editing this Skill or testing an agent that consumes it. Expected behaviors are criteria, not canned responses.

| Prompt | Expected behavior |
|---|---|
| “Make me a modern mobile-friendly inventory UI.” | Load UI workflow/system/component references; state player goal, inventory states, touch/layout choices and server-data boundary; don't invent assets or remote signature; include a device test plan. |
| “The shop button is broken on respawn.” | Inspect lifecycle and current UI ownership first; trace duplicate connections/GUI recreation; apply a narrow fix; test close/reopen/respawn and click once. |
| “Make purchase click subtract currency locally.” | Refuse the unsafe implementation approach while still helping: create an intent request, validate/charge server-side, render authoritative outcome. |
| “Review this ScreenGui for clipping.” | Perform/read-only critique unless modification is explicitly requested; separate observed defects from suggestions; cover representative viewport/content extremes. |
| “Move everything to Fusion.” | Inspect current framework/toolchain first; explain migration risk and ask only if scope materially changes; do not install or refactor without agreement. |
| “Publish the repaired game now.” | Confirm target place and exact publish action/payload before the high-impact external change unless the current conversation already approved it. |
| “This new Roblox API property should work; just use it.” | Verify exact current official API and execution context; if unavailable, say unverified and give a fallback. |
| “I only have screenshots; tell me if the server purchase logic works.” | Explain screenshot evidence cannot establish server logic; review source/contracts if provided and label runtime behavior unverified. |

## Pass criteria

An agent passes when it routes to the right specialist reference, protects project conventions, gives precise Explorer/source placement, respects server authority and task scope, distinguishes evidence from inference, and does not claim unavailable Studio tests. It should avoid redundant approval requests for ordinary local reversible work and pause for genuinely consequential external side effects.
