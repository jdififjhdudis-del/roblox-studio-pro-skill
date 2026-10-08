# Roblox UI Systems: Layout, Visual Hierarchy, and UX

Load alongside `ui-production-workflow.md` for UI implementation details. Verify current engine properties and framework APIs against Creator Hub and the project's actual UI system.

## Choosing a container and primitives

Use `ScreenGui` for overlays/HUD. Use `SurfaceGui` or `BillboardGui` when content belongs in the 3D world; review scaling, distance, occlusion and readability in context. Common elements are `Frame`, `TextLabel`, `TextButton`, `ImageLabel`, `ImageButton`, `TextBox`, and `ScrollingFrame`.

Use `UIListLayout` for ordered rows/columns, `UIGridLayout` for uniform repeated cells, `UIPageLayout` for paged flows, and `UIPadding` for internal spacing. These layout objects control/influence their children; do not simultaneously fight their positioning with arbitrary coordinates. Add `UICorner`, `UIStroke`, or a restrained `UIGradient` only when consistent with the project's style. `UISizeConstraint` and `UIAspectRatioConstraint` can bound dimensions/shape. `UIScale` should scale a coherent group when appropriate, not replace responsive design.

## Responsive geometry

`UDim2` combines relative **Scale** and pixel **Offset** for each axis. Use Scale for relationship to the parent and Offset for intentional fixed details (small padding/borders), with an anchor chosen for the intended origin. A centered panel commonly uses a center `AnchorPoint` and center position, plus explicit size bounds. Layouts and size modifiers can override or influence direct `Position`/`Size`; inspect the hierarchy before debugging geometry.

Never copy a coordinate recipe blindly. Instead define: usable viewport, panel max/min size, reflow behavior, scroll boundary, fixed control reach, and how text/content growth is handled. Use different compositions when needed (e.g. compact portrait panel vs wider landscape), but only introduce viewport rules after identifying where composition fails.

## Safe areas and gameplay composition

- Choose ScreenGui inset behavior deliberately and check Roblox UI/safe insets in the actual device preview.
- Keep essential actions clear of mobile thumbstick/jump controls and system/notch regions. Frequently used controls should be reachable with the player's available thumb.
- Protect gameplay focus: do not cover the target/reticle, health, objective or combat controls without an intentional modal/overlay state.
- For world-space UI, validate scale/legibility at expected distances and camera angles, not only in Explorer.
- Ensure each modal has a visible close/back route; handle gamepad back/selection if supported.

## Visual system

Use semantic tokens (e.g. `surface`, `textPrimary`, `textMuted`, `accent`, `danger`, `spaceSmall`, `radiusPanel`) instead of repeating raw values. Typography roles should distinguish title, body, supporting label and numeric/status content. Establish alignment and spacing rhythm; use restraint with gradients, outlines, glows, shadows and motion. Maintain a strong primary-action hierarchy, clear grouping, and contrast over diverse gameplay backgrounds.

Keep themes adaptable: match the game's existing art direction and genre. For a new game, propose a compact coherent direction and keep the token values easy to revise. Do not treat any sample palette, font size, panel occupancy, breakpoint or component count as a universal Roblox rule.

## Text, localization and scrolling

Plan for name length, dynamic counters and translated copy; a layout that fits English at one aspect ratio may clip elsewhere. Choose text scaling/wrapping/truncation intentionally. If truncation is used, preserve access to essential information. Bound `AutomaticSize` and content-driven growth so it cannot push controls off-screen. For long content use a clear scrolling container and keep persistent primary actions reachable.

## Feedback, motion, and accessibility

Design every relevant control for idle, hover (where applicable), pressed, selected/focus, disabled, pending/loading, success and failure. Do not use color as the sole status signal. Keep actionable errors understandable; avoid showing sensitive server internals. Use restrained transitions to clarify state change, cancel/replace overlapping tweens, and avoid blocking input. Respect available reduced-motion preferences where the project's UI system supports them; verify exact APIs first.

Touch targets need an adequately sized hit region and separation, especially for adjacent destructive actions. For keyboard/controller, define sensible focus order, visible selected state, and recovery from a closed/removed component. Mouse-only hover affordances must have equivalents for touch/gamepad.

## State and lifecycle

Represent each complex screen with explicit UI state rather than scattered booleans where possible. Keep server data separate from editable presentation. Handle async response after close/tab switch; ignore or reconcile stale data rather than repainting the wrong view. Connect events once per lifecycle; disconnect listeners and cancel obsolete tweens/tasks when rebuilding or destroying views. Ensure respawn/reopen does not duplicate UI or handlers.

For repeated data entries, reuse stable instances or paginate/virtualize if needed; do not build an unbounded, fully populated hierarchy for enormous lists. Avoid rebuilding an entire screen for a small value change.

## Official references

- [User interface overview](https://create.roblox.com/docs/ui)
- [Position and size](https://create.roblox.com/docs/ui/position-and-size)
- [List/flex layouts](https://create.roblox.com/docs/ui/list-flex-layouts)
- [Grid/table layouts](https://create.roblox.com/docs/ui/grid-table-layouts)
- [Size modifiers](https://create.roblox.com/docs/ui/size-modifiers)
- [Appearance modifiers](https://create.roblox.com/docs/ui/appearance-modifiers)
- [UI styling](https://create.roblox.com/docs/ui/styling)
- [UI animation](https://create.roblox.com/docs/ui/animation)
- [Device Simulator](https://create.roblox.com/docs/studio/device-simulator)
