# UI Production Workflow: Brief → Build → Review → Verify

Use for any non-trivial Roblox UI request. Adapt the depth to scope: a tiny label change does not need a full design review.

## A. Decide whether to critique, create, repair, or refactor

- **Critique/review:** inspect and report observations; do not mutate unless asked.
- **Create:** establish the target hierarchy/style, propose or infer a compact brief, then build the smallest complete screen.
- **Repair:** preserve the current visual system and unrelated elements; fix the defect and test its original failing path.
- **Refactor:** retain behavior and visual output unless redesign is explicitly requested; explain the risk and test regressions.

Identify the exact ScreenGui/world-space surface, place/session, source-of-truth, and UI execution owner. For tool-driven work, check capability, target, and edit/play state before mutation; see `studio-tooling-and-safety.md`.

## B. Build a one-screen design brief

Write this internally or show a short version to the user for larger work:

```text
Screen/feature:
Player goal:
Primary action:
Information priority (1–3):
Visual direction / existing style to preserve:
Supported viewports and input modes:
Navigation/back/close behavior:
States: default, loading, empty, selected/focus, disabled, success, error:
Data source and authority (client presentation / server truth):
Acceptance checks:
```

If the request supplies enough detail, do not interrupt progress with redundant questions. If style is unspecified, infer from the existing game. For a new project, choose a coherent, adjustable direction and state the assumption. Avoid imposing a fixed palette or art style.

For reusable written artifacts, start from [`../templates/ui-design-brief.md`](../templates/ui-design-brief.md). Treat `Status: Approved` as a record of real user/reviewer authorization, not a mandatory gate for routine reversible work.

## C. Plan interaction and screen states

1. Name the user task and the visual focal point; assign one primary action and demote secondary actions.
2. Draw a short navigation flow: entry → action → result; include cancel/back/close and recovery path.
3. Define state transitions and the data owner. E.g. `Idle → Pending → Success | Failure`; pending blocks duplicate UX input, while the server independently rate-limits and validates.
4. Include edge content: zero items, many items, long names, missing image, large numeric value, delayed response, player respawn/reopen, and localization growth as relevant.
5. Consider gameplay context: camera/focal areas, combat controls, HUD conflicts, world-space readability, and whether the panel blocks play.

## D. Design system and composition

Use existing game tokens/components first. Otherwise define a small semantic system: background/surface/text/accent/status colors; display/title/body/caption roles; spacing/radius/stroke levels; and motion duration/easing intent. Avoid values scattered arbitrarily through every object. Use color contrast plus text/icons, and visually distinguish primary/secondary/danger actions.

Prefer editable authored Instances for stable screen shells and data-driven runtime creation for repeated entries, unless the project's existing framework requires another pattern. Keep layouts aligned and content bounded. Define safe viewport composition, insets and thumb-reach areas; reserve enough width for translated text. Do not assert a universal breakpoint—choose one where the composition actually stops working and verify it.

## E. Implement incrementally

Build in this order:

1. Container and major panel placement.
2. Main hierarchy and responsive layout/scroll behavior.
3. Typography, spacing, tokens, contrast and actions.
4. All relevant states and input/focus behavior.
5. Motion and visual polish after the basic flow works.

Separate presentation from state/data fetching when complexity warrants. Add one component or interaction at a time and read back actual hierarchy/source. Use server-authoritative responses for gameplay/economy. Keep UI shells from owning persistence or trusted rules.

## F. Run a bounded visual iteration loop

For supported tool capability: **inspect → implement → preview → compare to brief → adjust → preview the affected states again**. Change one major variable at a time so the result remains explainable. Stop when acceptance checks are met or a required tool/evidence is unavailable. Treat automated critique/advisory results as hints, not as proof or design authority.

For each preview, identify the evidence type:

- Screenshot/render: composition, hierarchy, clipping and visible state only.
- Semantic/Explorer inspection: Instance tree, properties, layering and selected geometry.
- Input test: actual delivery and response to mouse/touch/gamepad/keyboard.
- Server/gameplay observation: authoritative effect, remote rejection, currency/ownership change.
- Data readback: persisted outcome and failure handling.

Do not claim one category from another. A desktop screenshot does not establish touch comfort, focus navigation, or server effect.

## G. UI acceptance matrix

Test only supported targets, but cover every target the game claims to support:

| Dimension | Representative checks |
|---|---|
| Viewport | Narrow portrait, wide landscape, tablet-ish, common desktop; extreme ratios if supported |
| Safe space | Topbar/notch/insets, thumbstick/jump reserved areas, no critical overlap |
| Content | Empty, typical, full/large list, long text/localization, missing image, large values |
| Interaction | Primary, secondary, cancel/back/close, repeated rapid input, disabled/pending, invalid action |
| Inputs | Touch hit area/reach; mouse and keyboard; directional gamepad focus and back if supported |
| Lifecycle | Open/close/reopen, tab changes, respawn, stale async response, destroyed view |
| Gameplay context | HUD conflicts, camera focal region, modal obstruction, world-space legibility |
| Feedback | Loading, success, actionable error, selected/focus, disabled, accessible non-color cue |

Record actual configurations and states tested. Name what could not be tested, and do not present all dimensions as passed if only a subset was observed.

## H. UI delivery notes

For significant screens, deliver: a brief of player goal/visual direction; exact Explorer placement; data/state contract and any remotes; interaction and responsive decisions; actual viewport/input/state evidence; remaining gaps. Keep the handoff concise.

Use [`../templates/test-evidence.md`](../templates/test-evidence.md) when a release or multi-device UI change benefits from a reusable evidence record. For a lightweight change, a concise summary is enough.
