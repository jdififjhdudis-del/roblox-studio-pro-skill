# Luau and Roblox Project Architecture

Use as a decision aid, not a framework prescription. Preserve existing conventions unless they are actively harmful. Verify current APIs and supported contexts in the official engine reference.

## Script placement and trust boundary

- `Script`: server-side logic in a valid server execution container, commonly `ServerScriptService`; use for authoritative gameplay, validation and persistence.
- `LocalScript`: client-side input/presentation in supported client containers, commonly `StarterPlayerScripts`, `StarterCharacterScripts`, `StarterGui`, or `StarterPack`. Confirm execution rules for the actual parent.
- `ModuleScript`: reusable code, but security and state depend on who requires it and whether it replicates. A client-replicated module is not secret.
- `ReplicatedStorage`: shared remotes/modules/config safe for clients to inspect. Keep secrets and trusted authority out.
- `ServerStorage`/`ServerScriptService`: server-only assets and logic where appropriate.

Never move a script without checking execution context, replication, ownership, lifecycle and dependencies. Do not assume client-created Instances/properties replicate to the server.

## Luau standards

Use `local`, descriptive names, small cohesive functions, clear early returns and project-consistent conventions. Use `--!strict` for nontrivial new code when compatible; explicitly type public module APIs, state records, remote payloads and return values where useful. Avoid `any` as a shortcut; validate and narrow untrusted data at boundaries. Handle tagged unions exhaustively when practical.

Prefer `task` scheduling APIs over legacy `wait`/`spawn`/`delay`; avoid unbounded loops and unnecessary per-frame work. Clean up connections, tweens, temporary Instances and spawned work. Use timeouts/diagnostics for required `WaitForChild` paths when indefinite waiting would hide a hierarchy error. Use `pcall` around failure-prone operations and inspect the result; don't swallow errors.

## Architecture and lifecycle

Organize around cohesive responsibility: view/construction, controller/input, state/data adapter, and remote boundary when complexity warrants it. Keep small features simple; do not build an abstraction framework prematurely. Make initialization idempotent or guarded. Define who owns startup and cleanup, and test character respawn, screen close/reopen, and player removal.

Client state is a view/cache, not authority. Server state owns economy, inventory mutations, health/damage, permissions, cooldowns, and persistence as appropriate. Shared module code does not make its values trusted if executed by the client.

## Existing projects and toolchains

Inspect project shape first: direct Studio place, `.rbxlx`/`.rbxmx`, Rojo, plugin-generated hierarchy, or another workflow. Identify authored source-of-truth, mappings, dependencies, version pins and build steps. With Rojo, follow actual `default.project.json` mappings and avoid editing generated output as if it were source. Preserve the working toolchain unless migration was requested and justified. Do not claim a source edit is visible in Studio until sync/build confirmation.

A useful preflight is: locate entry points → map existing owners/modules → inspect warnings → trace remote/data path → find tests/build scripts → name the smallest target diff.

## API and dependency verification

For unfamiliar, recent, deprecated or security-sensitive members, verify exact class/member, access context, arguments/returns, replication behavior and deprecation status in Roblox Creator Hub. For community modules/frameworks, verify repository, current major version, installation/mapping, compatibility with project Luau and license/source constraints. If verification fails, ask or explain uncertainty instead of inventing a signature.

## Frequent defects to detect

- LocalScript in a non-executing parent; server Script attempting client UI/input behavior.
- Client-only state mistaken for authoritative state or assumed to replicate.
- Client-owned secret/config or client supplied price/permission trusted by server.
- Duplicate `PlayerGui`/ScreenGui creation or multiplied event handlers after respawn.
- Circular requires, startup-order dependency, endless wait, stale async writes, or unhandled operation failure.
- A Rojo edit to the wrong path, ignored mapping, generated file, or unsynced Studio place.

## Source references

- [Luau](https://create.roblox.com/docs/luau)
- [Type checking](https://create.roblox.com/docs/luau/type-checking)
- [Client-server runtime](https://create.roblox.com/docs/projects/client-server)
- [Engine reference](https://create.roblox.com/docs/reference/engine)
- [Rojo docs](https://rojo.space/docs)
