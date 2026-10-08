# Roblox UI Systems: Design and Implementation

This reference expands the UI-first workflow in `../SKILL.md`. Verify engine details against Creator Hub when APIs or platform behavior may have changed.

## Design pass before implementation

1. **Purpose:** identify the player's goal and the single most important action.
2. **Information architecture:** group related content, keep labels concise, and make hierarchy obvious without relying on color alone.
3. **Visual system:** choose a restrained palette, readable type scale, consistent spacing, alignment, corner radius, stroke, and icon treatment. Reuse tokens across screens.
4. **Interaction states:** define idle, hover/focus, pressed, selected, disabled, loading, success, empty, and error states as needed.
5. **Device/input matrix:** declare which of touch, mouse/keyboard, and gamepad are supported; design navigation and button placement accordingly.
6. **Responsive plan:** specify what changes on narrow screens (reflow, scroll, compact labels) and what must remain fixed/readable.
7. **Implementation and verification:** build a small representative screen first, then test in Device Simulator before scaling the pattern.

## Choosing Roblox UI primitives

- `ScreenGui` for screen overlays/HUD; `SurfaceGui` and `BillboardGui` for in-world panels and markers. Confirm the requested experience matches the container.
- `Frame` for grouping; `TextLabel` for text; `TextButton`/`ImageButton` for actions; `TextBox` for user entry.
- `UIListLayout` for ordered rows/columns, `UIGridLayout` for repeated tiles, and `UIPageLayout` for page flows. Layout objects control child arrangement; avoid fighting them by assigning manual positions to their children.
- `UIPadding` for internal whitespace; `UICorner`, `UIStroke`, and carefully used `UIGradient` for appearance. Don't overdecorate every element.
- `UISizeConstraint`/`UIAspectRatioConstraint` for bounds and shape; use `UIScale` only when a coherent subtree should scale together.
- `ScrollingFrame` for content that can exceed the available viewport; provide clear scroll affordances and keep primary actions reachable.

## Responsive geometry

A `UDim2` axis combines a relative **Scale** term and pixel **Offset** term. Use Scale for relationships to the parent container; use Offset for small fixed details such as padding or border thickness. `AnchorPoint` changes the origin used to position an object; centered modals commonly use `(0.5, 0.5)` with a center position. Always check the hierarchy: layouts and size modifiers may override direct Position/Size values.

Prefer stable layout constraints over device-specific hardcoded coordinates. For example, a centered panel can use a scale-based position and size, an intentional center anchor, and min/max size constraints; its contents can flow through a list layout. Choose exact values based on the UI, not by copying arbitrary constants.

### Screen-safe composition

- Keep essential HUD elements away from default mobile controls and system/notch areas. Choose `ScreenGui` inset settings deliberately and verify the resulting safe area.
- Design primary touch actions in comfortable thumb reach; avoid tiny adjacent controls. Provide a way to close every modal and recover from a blocked flow.
- Ensure a layout works in both portrait and landscape if both are supported. For long content, scroll within a panel instead of shrinking text until unreadable.
- Reserve enough room for dynamic text/localization, names, counts, and translated strings. Test maximum plausible values.

## Interaction and state patterns

A UI should represent application state, not act as the authority for it. Keep a single source of truth for selected tab, open/closed panels, pending actions, and server-provided data. Render state into UI; don't infer ownership/currency from a locally editable label.

For a request/action button:

1. Check local presentation state (e.g. already pending) and disable or show progress.
2. Send a narrow request through the intended remote/API.
3. Let the server validate current conditions and perform the action.
4. Reconcile the screen from the authoritative result or refreshed server state.
5. On failure, restore interaction and show a useful, non-sensitive explanation.

Avoid connecting handlers every time a panel opens unless they are disconnected on close. Prefer one lifecycle owner. Clean up connections and cancel obsolete tweens when destroying/replacing UI. If a response arrives after the view was closed or the selection changed, ignore it or verify it still applies.

## Accessibility and input

- Maintain readable text, strong foreground/background contrast, consistent focus indication, meaningful button labels, and distinct disabled states.
- Do not convey status only through hue; pair color with text/icon/shape.
- Provide gamepad-selectable order and clear selected state if console is supported. Check directional navigation through modals, grids, and scrolling panels.
- Use touch-sized hit regions. If a decorative icon is small, its actionable parent can be larger.
- Avoid flashing, long blocking animations, and feedback that prevents immediate correction.

## UI test matrix

| Test | Look for |
|---|---|
| Phone portrait and landscape | Safe areas, thumb reach, overflow, text fit, scrolling |
| Tablet | Excessive whitespace, panel bounds, balanced composition |
| Desktop | Alignment, large-window behavior, mouse hover, keyboard support |
| Console (if supported) | Focus order, directional navigation, readable couch distance |
| Dynamic content | Long names, empty list, large counts, missing icon, localization expansion |
| Runtime state | Loading, rapid repeat input, close/reopen, respawn, server error |
| Multiplayer (when relevant) | Other-player state updates and server-authoritative results |

Use Studio Device Simulator and Controller Emulator when available. A screenshot at only one desktop aspect ratio is not proof of responsive behavior.

## UI code organization

For small UI, keep implementation direct and easy to paste. For growing systems, isolate:

- **View construction:** instances/layout/style.
- **Controller:** input and screen lifecycle.
- **State/data adapter:** update/render from explicit values.
- **Remote/service boundary:** narrow calls with typed payload/result contracts.

Don't split into many modules without a real reuse, testing, or ownership benefit. Keep view-only code in an appropriate client context; secrets and gameplay authority remain server-side.

## Official references

- [User interface overview](https://create.roblox.com/docs/ui)
- [Position and size](https://create.roblox.com/docs/ui/position-and-size)
- [List/flex layouts](https://create.roblox.com/docs/ui/list-flex-layouts)
- [Grid/table layouts](https://create.roblox.com/docs/ui/grid-table-layouts)
- [Size modifiers](https://create.roblox.com/docs/ui/size-modifiers)
- [Appearance modifiers](https://create.roblox.com/docs/ui/appearance-modifiers)
- [UI animation](https://create.roblox.com/docs/ui/animation)
- [Device Simulator](https://create.roblox.com/docs/studio/device-simulator)
