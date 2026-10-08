# UI Component Patterns and Worked Scenarios

Framework-neutral guidance: use Roblox Instances directly or the framework already present (such as Fusion or another reactive UI library). Do not impose or install a framework without a project-level reason. Verify any framework version and API before use.

## Component contract

Before making a reusable control, define its contract: inputs/properties, events/output, state owned by the component versus state owned by the screen, accessible label, supported input modes, lifecycle owner, and visual token dependencies. Reuse a component only when several screens need the same behavior or styling; don't abstract a one-off control prematurely.

The bundle includes [`../templates/responsive-panel.client.luau`](../templates/responsive-panel.client.luau) as a concrete starting point for a bounded panel, text constraints, `Activated` input, and open/close states. It is a **demonstration**, not a production theme, and contains no gameplay/server request. This environment does not include a Luau analyzer or Roblox Studio runtime; verify it in the target Studio version and adapt safe areas, visual style and navigation before shipping.

A button component should define at least: label/icon; intent (primary, secondary, destructive); enabled/busy state; activation callback; focus/pressed feedback; minimum usable hit region; and whether it can be activated by gamepad/touch. If the action is consequential, its callback initiates an intent request; the server remains authoritative.

## Interaction state machine

For async actions, model state explicitly:

```text
Idle ──activate──> Pending ──accepted──> Success
                         └──rejected/error──> Failure ──retry──> Pending
```

During `Pending`, show progress and prevent duplicate presentation-level submission. Restore the control on recoverable failure; display safe, actionable feedback. Keep idempotency/rate validation server-side. Do not leave a button permanently disabled after a timeout or screen replacement.

## Component styling

Keep appearance values in a theme/config module or established project styling system. Store semantic roles, not opaque per-screen numbers. Use stable parent-relative layouts and constraints. When a token changes, inspect all consumers to avoid unintended regressions. Treat palette and sample component choices as project-specific; do not redesign existing screens to match a generic sample.

## Worked scenario: shop item card

**Scope:** a UI card showing name, icon, server-provided price/ownership, and a purchase action. It is not a receipt or source of economic truth.

1. Inspect the game's current shop and inventory model, item IDs and remote contract.
2. Define card states: loading, available, insufficient funds (display only from latest server state), owned/unavailable, purchase pending, success, and server rejection.
3. Render server-provided item data. Client sends only stable item ID/intent; server retrieves price and validates balance/eligibility.
4. Disable/relabel the button during request and handle stale response (e.g. card removed or shop closed).
5. Test forged IDs and repeated requests on the server, not merely hidden/disabled controls. Verify authoritative balance/ownership and UI reconciliation.
6. Test long names, missing image, empty shop, narrow viewport, scroll and gamepad focus if supported.

## Worked scenario: modal/dialog

Use a dedicated overlay layer with intentional `ZIndex`, dim/background treatment consistent with the game, clear title/body/action hierarchy, and visible cancel/close route. Decide whether tapping outside closes it; never assume. If closing or replacing the modal, disconnect its listeners and cancel animations. For keyboard/controller, keep focus within the active flow where supported and restore sensible focus when dismissed. Confirm destructive gameplay actions server-side.

## Worked scenario: data-driven inventory

Use stable item identifiers, explicit selected state, layout-driven grid/list, a scroll boundary and detail panel. Represent empty/loading/failed states instead of rendering nothing. On selection change, avoid stale thumbnail/details responses. Paginate or reuse rows for large inventories; don't recreate every item on each currency update. Test maximum expected list size and empty/full transitions.

## Safe Roblox Instance construction guidance

When generating Instances in code, set properties intentionally, parent only after required properties/children are ready when practical, and give each object a stable, meaningful name. Keep builders idempotent or guard duplicate creation. Use absolute Explorer paths in handoff. Do not rely on `FindFirstChild` returning an expected instance without handling absence. If using authored Studio objects, describe the exact parent tree and properties rather than saying “add a GUI”.

Avoid using this reference as permission to invent API members. Check Creator Hub for unfamiliar properties, enum values, input/focus APIs or current reduced-motion support.
