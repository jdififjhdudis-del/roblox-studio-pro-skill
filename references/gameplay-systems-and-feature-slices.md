# Gameplay Systems and Vertical Feature Slices

Use this reference when a request changes actual play: combat, rounds, quests, progression, movement, abilities, NPCs, inventory, social systems or game loops. Combine with the security reference whenever client requests or value are involved.

## Build the smallest complete slice

A feature is a vertical slice when the player can encounter it, act on it, see the result, and recover from failure. Don't generate a wide file tree or many placeholder systems before one playable path works.

1. **Player outcome:** identify the in-game action and feedback, not just “add a system.”
2. **State/owner:** list canonical state and its owner (server, client presentation, persistent store). Name allowed transitions.
3. **Entry/lifecycle:** identify where it initializes, when it resets, respawns, ends, or persists.
4. **Contract:** specify module/service API and any remote payload/result, including invalid/stale/error behavior.
5. **Slice:** implement one normal journey plus a meaningful failure/cancel path.
6. **Evidence:** test the direct path and ownership boundary; then expand variants only after it works.

## State machines over boolean tangles

For systems with phases, define a finite set of states and legal transitions first. Example round lifecycle:

```text
Waiting → Intermission → MapLoading → Active → Results → Cleanup → Waiting
```

For each transition specify: trigger, validator/owner, state mutation, player feedback, timeout/cancel, and duplicate-trigger behavior. Reject out-of-order transitions. Avoid several independent booleans that allow impossible combinations such as “round active and map not loaded.”

For client UX, mirror only the minimum replicated state needed to render. The server must decide phase changes, winners, rewards and eligibility.

## System-specific design prompts

**Combat/abilities:** who owns hit detection and damage? What validation exists for target, range, cooldown, team, state, line of sight and rate? What feedback is client-side cosmetic vs server-authoritative?

**Quests/progression:** stable quest IDs, objective types, repeat rules, event sources, duplicate reward prevention, reset windows, migration/versioning, and bounded UI updates. Do not award progress because a client reports it completed.

**NPC/AI:** state transitions and cancellation, path/target failure behavior, server load, streaming/respawn, and client visual polish. Verify current Pathfinding/animation APIs instead of assuming a tutorial signature.

**Inventory/tools:** canonical server ownership, stable item identity, equip/unequip invariants, character lifecycle, duplicate requests, and UI reconciliation.

**Rounds/parties/trading:** explicit participant snapshot, leave/disconnect behavior, competing actions, cancellation and cleanup. For valuable exchange, lock/revalidate and commit server-side, using current platform/security constraints.

**Input/movement:** map keyboard/mouse/touch/gamepad separately where needed; preserve core controls, avoid double-binding, unbind on lifecycle end, and support rebind/focus where the design requires it.

**Building/placement:** validate ownership, bounds, collision, rate, permissions and resource cost; use stable server-approved definitions. Treat client previews as presentation only.

## Architecture at the right scale

A small system may be one server ModuleScript plus one client controller. Larger systems may separate services, controllers, data models and UI adapters. The choice should follow existing project conventions. Define explicit module APIs and initialization order; avoid circular requires and service singletons with hidden mutable state. Prefer event-driven updates for discrete gameplay state; reserve frame-step work for truly continuous behavior.

## Testing ladder

Start with one player and the feature's normal path. Then cover invalid/stale request, cancellation, respawn/disconnect, competing players, latency if network-sensitive, server client divergence, and relevant persistence boundaries. Use multi-client Studio test when sharing or competition matters. Report exactly what was covered.

## Source freshness

Check exact current Roblox APIs for `ContextActionService`, `UserInputService`, Pathfinding, animation, streaming, physics, constraints, and any newer authority/networking feature. This guide describes reasoning patterns, not a replacement for current API docs.
