# Advanced UI ↔ Gameplay Examples: Roact 1.x and Fusion 0.3

Use this playbook when a Roblox interface must send player intent to game logic, render authoritative results, handle loading/pending/error states, and clean up listeners. The same server contract supports either client implementation; install **one UI example at a time**.

## Contents

- [Framework/version decision](#frameworkversion-decision)
- [Project setup](#project-setup)
- [Shared remote contract](#shared-remote-contract)
- [Example files](#example-files)
- [Lifecycle and safety walkthrough](#lifecycle-and-safety-walkthrough)
- [Studio verification plan](#studio-verification-plan)
- [Production boundaries](#production-boundaries)
- [Sources and API provenance](#sources-and-api-provenance)

## Framework/version decision

- **Roact 1.x:** keep the example for maintenance or migration of an existing Roact experience. Roblox's [Roact repository](https://github.com/Roblox/roact) explicitly says the project is deprecated and directs users to [React Luau](https://github.com/Roblox/react-luau) for the maintained React-style library. Do not silently recommend starting a new project on Roact.
- **Fusion 0.3:** the sample uses the versioned 0.3 API (`Fusion.scoped(Fusion)`, `scope:Value`, `scope:Computed`, `scope:Spring`, `scope:New`, `Fusion.OnEvent`). Its own [0.3 tutorial](https://elttob.uk/Fusion/0.3/tutorials/) warns that Fusion is pre-1.0 and breaking changes can occur. Pin/inspect the version actually installed; do not paste this API into Fusion 0.2 or assume it matches `/latest`.
- Do not migrate an existing UI framework just to use an example. Inspect the project package, Rojo/Wally mapping, component conventions, and the framework version first.

## Project setup

Choose these placements in the target place:

```text
ReplicatedStorage
└── Packages
    ├── Fusion                 # Only for FusionShop.client.luau
    └── Roact                  # Only for RoactShop.client.luau
ServerScriptService
└── ShopService.server.luau
StarterPlayer
└── StarterPlayerScripts
    └── ShopClient.client.luau # Copy ONE client template and rename it
```

The server script creates `ReplicatedStorage.ShopRemotes` and its four `RemoteEvent`s. Install the library with its own [official Fusion 0.3 instructions](https://elttob.uk/Fusion/0.3/tutorials/get-started/installing-fusion/) or the project's established Roact package workflow. The examples expect each package ModuleScript at the paths shown above. **Never run both client templates simultaneously**: both listen to the shared remotes and intentionally use the same item/request contract.

The `.server.luau` and `.client.luau` suffixes are source-file conventions commonly used by Rojo. In plain Studio, create a `Script` under `ServerScriptService` and a `LocalScript` under `StarterPlayerScripts`, then paste the corresponding source. Keep the package ModuleScript names/locations aligned with the `WaitForChild` paths in the selected client.

## Shared remote contract

| RemoteEvent | Direction | Payload | Purpose |
|---|---|---|---|
| `SnapshotRequest` | client → server | no payload | Request current demo balance/ownership. |
| `SnapshotResult` | server → client | `{ coins: number, owned: { [string]: boolean } }` | Initial/refresh state. |
| `PurchaseRequest` | client → server | `{ requestId: safe integer, itemId: string }` | Request an action; contains **no price, balance, or grant**. |
| `PurchaseResult` | server → client | `{ requestId, ok, reason, coins, owned }` | Correlated authoritative outcome and refreshed state. |

`requestId` exists to associate a reply with the current client request and reject stale UI responses. It is **not** an authentication token or security proof. The server validates payload shape/length, looks up the item and price on the server, applies a per-player cooldown, checks balance and ownership, and only then mutates state. A repeat request for the already-owned demo item does not charge again. This follows Roblox's [remote-event security guidance](https://create.roblox.com/docs/scripting/events/remote) and the server-authority principles in the main skill.

## Example files

1. [`ShopService.server.luau`](../templates/framework-examples/ShopService.server.luau) — shared server endpoint, input validation, server-owned price, cooldown, duplicate ownership check, snapshot, and player cleanup.
2. [`RoactShop.client.luau`](../templates/framework-examples/RoactShop.client.luau) — stateful Roact component, `Activated` events, deferred state transitions, response correlation, timeout, refresh action, and lifecycle disconnection.
3. [`FusionShop.client.luau`](../templates/framework-examples/FusionShop.client.luau) — Fusion 0.3 `Value`/`Computed` state, an animated `Spring`, `OnEvent` handlers, open/close state, stale-response guard, and scope cleanup.

The UI uses scale-based width with a maximum size constraint, wrapped status text, a loading state, a disabled/pending state, an owned state, and a server-result state. Adapt copy, theme, layout, localization and input affordances to the actual game's design system rather than treating these styles as a universal UI specification.

## Lifecycle and safety walkthrough

1. Mount the UI and subscribe to `SnapshotResult`/`PurchaseResult` **before** requesting the initial snapshot.
2. Render a loading state until the server snapshot arrives. Do not infer wallet or ownership from client-local defaults.
3. On activation, prevent duplicate pending requests, create a bounded request ID, show pending feedback, and send only the item ID plus correlation ID.
4. The server validates every request as untrusted input. The client disables the button for UX, but the server still enforces ownership and affordability.
5. Accept only the response matching the current request ID. Update display state from the returned server values; ignore replies arriving after a timeout or newer request.
6. On timeout, tell the player to refresh state before retrying. The demo's server-side ownership check prevents charging twice for the same item; production transactions still need the game's existing idempotent data/economy service.
7. On UI teardown, Roact disconnects its remote listeners in `willUnmount` and cancels its timer. Fusion inserts connections into its scope and runs `scope:doCleanup()` when the LocalScript is destroyed.

**Roact-specific note:** the official [events guide](https://roblox.github.io/roact/guide/events/) says event props are connected/disconnected with the rendered tree and warns that synchronous `setState` during reconciliation can throw. The example defers button-triggered state work and performs network-result updates asynchronously. Its [state/lifecycle guide](https://roblox.github.io/roact/guide/state-and-lifecycle/) supports the `init`, `didMount`, `willUnmount`, and `setState` pattern; [bindings and refs](https://roblox.github.io/roact/advanced/bindings-and-refs/) are better suited when a specific animated property needs updates outside ordinary reconciliation.

**Fusion-specific note:** [Fusion 0.3 events](https://elttob.uk/Fusion/0.3/tutorials/roblox/events/) documents `OnEvent`; the [scope guide](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/scopes/) documents cleanup of connections/instances; and its [server-fetch cookbook](https://elttob.uk/Fusion/0.3/examples/cookbook/fetch-data-from-server/) distinguishes yielding work from pure `Computed` derivation. Keep yielding/network calls in event callbacks, not inside `Computed` functions. Reusable component patterns are in the [component best-practices guide](https://elttob.uk/Fusion/0.3/tutorials/best-practices/components/) and the [button cookbook](https://elttob.uk/Fusion/0.3/examples/cookbook/button-component/).

## Studio verification plan

Run in a **test place**, using Studio's server/client test modes. Do not validate valuable purchases against live production data.

- Confirm the server creates all four `RemoteEvent`s before the client waits for them.
- Join with one client: verify loading → 100 coins → enabled purchase; purchase once and confirm 60 coins plus owned state.
- Click repeatedly/rapidly: ensure one pending action at a time and no duplicate charge; confirm the server cooldown produces a recoverable message.
- For affordability coverage, temporarily set the demo `STARTING_COINS` below `ITEM_PRICE`; confirm the button communicates the state and the server still rejects a forged purchase request.
- Send an unknown item ID, malformed table, oversized string, non-integer/out-of-range request ID, and a repeated item request from a test client; verify no unauthorized mutation.
- Delay or drop a response in a controlled test: verify the timeout copy, stale result ignored, and refresh synchronizes state.
- Respawn/reopen/destroy the UI: ensure no duplicate remote listeners, orphaned UI, timer callback, or stale update remains.
- Test at narrow/mobile and desktop viewport sizes, touch activation, readable text, GUI inset, gamepad selection if supported, and multi-client isolation.

Record which mode/version was tested and what was observed. The template source is a code starting point; it is not evidence that the user's place or every device has been runtime-tested.

## Production boundaries

`ShopService.server.luau` is deliberately a **non-persistent teaching demo**: coins and ownership reset on server restart, it stores one sample item in memory, and the sample does **not** create a Roblox `Tool` or apply another gameplay effect. The UI says “Demo ownership” to make that boundary visible. Before production use:

- Replace its tables with the project's existing server-side profile/economy/inventory service; do not create a second competing source of truth.
- Make the balance check, debit, and grant atomic under that service's rules; persist and recover with the game's data lifecycle.
- Define real retry/idempotency semantics, transaction logs, rollback/failure behavior, and per-action rate limits. UI request IDs alone do not make backend writes exactly-once.
- For paid developer products, follow `MarketplaceService.ProcessReceipt` and current Roblox monetization policy; never grant a purchase because a client RemoteEvent says payment succeeded.
- Re-check current Creator Hub APIs, the installed framework version and the target experience's actual data model before adapting.

## Sources and API provenance

These examples were written for this repository from the cited public documentation; they are not copied framework source files. Sources checked on **2026-10-09**:

- Roblox [Roact repository/deprecation notice](https://github.com/Roblox/roact), [components](https://roblox.github.io/roact/guide/components/), [events](https://roblox.github.io/roact/guide/events/), [state/lifecycle](https://roblox.github.io/roact/guide/state-and-lifecycle/), and [bindings/refs](https://roblox.github.io/roact/advanced/bindings-and-refs/).
- Roblox [React Luau repository](https://github.com/Roblox/react-luau) as the React-style successor referenced by Roact's README.
- Elttob [Fusion 0.3 docs](https://elttob.uk/Fusion/0.3/), [installation](https://elttob.uk/Fusion/0.3/tutorials/get-started/installing-fusion/), [events](https://elttob.uk/Fusion/0.3/tutorials/roblox/events/), [scopes](https://elttob.uk/Fusion/0.3/tutorials/fundamentals/scopes/), and [cookbook](https://elttob.uk/Fusion/0.3/examples/cookbook/).
- Roblox [remote events](https://create.roblox.com/docs/scripting/events/remote) for the platform boundary. Framework lifecycle/state semantics are third-party library behavior, not Roblox engine guarantees.
