# Luau and Roblox Project Architecture

Use this as a decision aid, not a rigid framework. Preserve an existing project's conventions unless they are actively harmful.

## Script placement and execution context

- `Script`: server-side logic in a valid server execution container (commonly `ServerScriptService`); authoritative gameplay, validation, and persistence belong on the server.
- `LocalScript`: client-side input and presentation in supported client containers (commonly `StarterPlayerScripts`, `StarterCharacterScripts`, `StarterGui`, or `StarterPack`). Check current execution rules for the actual parent.
- `ModuleScript`: reusable code, but its security and state implications depend on who requires it and where it replicates. A module replicated to clients is not secret.
- `ReplicatedStorage`: shared remotes/modules/config that are safe for clients to read. Do not place secrets or privileged logic there.
- `ServerStorage`/`ServerScriptService`: server-only assets and logic where appropriate.

Do not simply move a script to a different container without checking its execution context, dependencies, replication, and lifecycle.

## Luau conventions

- Prefer `local` bindings, consistent PascalCase for Roblox instances/types as customary, and clear camelCase/local naming consistent with the project.
- For significant new modules, use `--!strict` where the project/runtime supports it. Give module exports, functions, state records, and remote payloads explicit types. Keep type definitions close to their contract.
- Avoid `any` as a convenience. Narrow unknown or loosely shaped data at the boundary and fail safely.
- Use explicit return types for public functions when they clarify a contract. Use early returns for invalid states and avoid deeply nested conditionals.
- Prefer `task.wait`, `task.delay`, and `task.spawn` over legacy scheduling functions. Avoid `while true` without a bounded purpose, cancellation plan, and appropriate yield.
- Avoid `WaitForChild` as a blanket cure for ordering bugs. Use it for expected replication timing; add a timeout and clear error for required instances when a hang would otherwise be opaque.
- Use `pcall` only around operations that can fail; inspect the result and report/handle errors rather than suppressing them.

## Module and service design

Create modules around cohesive responsibility (e.g., UI controller, inventory rules, configuration). Avoid giant scripts that mix input, rendering, remote contracts, and persistence. Avoid needless abstraction for tiny features.

Use dependency injection or explicit parameters when it makes tests/reuse easier. Avoid hidden global state. Ensure initialization is idempotent or guarded so respawn/reopen does not multiply connections or actions.

## Project and sync tools

A project may be edited directly in Studio, as `.rbxlx`/`.rbxmx`, or through Rojo/another sync workflow. Inspect the actual setup first. When Rojo is used, follow its project mapping and source-of-truth rules; do not edit generated output or an unmapped file and assume Studio will sync it. Confirm mapping and sync status before claiming the instance exists in Studio.

Before changing an existing project:

1. Find the entry points and existing modules.
2. Check naming, folders, style, and available tooling.
3. Identify duplicate functionality and dependencies.
4. Make a narrow edit and preserve unrelated work.
5. Verify sync/build errors and Explorer paths after changes.

## API verification

Use official Creator Hub documentation and the class reference for exact properties, methods, enum values, security tags, and supported parent contexts. When an API is unfamiliar or recent:

1. Search the official reference using the exact class/member.
2. Check whether it is deprecated, restricted, server-only, client-only, or not scriptable.
3. Verify argument and return types.
4. Use the code only if the documented execution context matches the implementation.
5. If not verifiable, state uncertainty and avoid fabricated signatures.

## Common architecture errors to catch

- A LocalScript placed in a container where it does not execute.
- Assuming a client-created instance or property change replicates to the server.
- Trusting a client-supplied item price, target, reward, position, or permission.
- Putting authoritative state in a shared module or replicated container.
- Rebuilding the same UI repeatedly on character respawn.
- Circular module requires, initialization order assumptions, or unbounded waits.
- Using RemoteFunctions for work that can yield indefinitely without a timeout/fallback strategy.

## Official references

- [Luau reference](https://create.roblox.com/docs/luau)
- [Luau type checking](https://create.roblox.com/docs/luau/type-checking)
- [Client-server runtime](https://create.roblox.com/docs/projects/client-server)
- [Roblox API reference](https://create.roblox.com/docs/reference/engine)
- [Rojo documentation](https://rojo.space/docs)
