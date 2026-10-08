# Roblox Game Design, Production, and Operations

Use when the request is about a whole game, onboarding, genre fit, retention, live operations, economy feel, release quality, or when a technical feature lacks a player-facing objective. Keep this advisory and grounded in the user's design goals.

## Start from player intent

Clarify the fantasy, audience/session context, core action, short-term goal, feedback/reward, and what makes mastery or social play meaningful. Convert that into one playable loop and measurable acceptance criteria; don't begin with a broad feature count. A first-session goal can be “reach the first meaningful action promptly,” but any timing target is a heuristic to playtest, not a universal Roblox law.

Use a narrow vertical slice: spawn/context → teach one action → immediate understandable feedback → next goal. Preserve player agency and avoid walls of onboarding text, modal interruptions, confusing currencies, or reward feedback that obscures play.

## Feature planning template

For each feature, name: player problem; user story; gameplay state; primary action; dependencies; client/server/data ownership; UI feedback; edge/failure cases; success criteria; and excluded scope. Sequence prerequisite infrastructure only when needed for a playable test.

## Genre-aware design

Use genre conventions as an inspiration, not a copied recipe. For a simulator consider collection/upgrade/zone progression; for an obby consider checkpoint/attempt feedback; for an RPG consider objective clarity/build choice/world readability; for social spaces consider presence, expression, privacy and safe interaction. Adapt to the specific creator vision and avoid cloning another game's protected expression/assets.

## Fair progression and economy

Map value sources and sinks; track how progression changes over repeated sessions; anticipate inflation, dominant strategies, duplicate claims, trading edge cases and new-player disadvantage. Keep gameplay value server-authoritative. If monetization is in scope, be transparent, age-appropriate, policy-compliant, and avoid pay-to-win or coercive urgency unless the user explicitly requests a policy review (and then consult current platform policy). Do not invent current policy requirements; check authoritative Roblox documentation.

## Release and live update planning

Before a release, identify what changed, affected player journey, server/client compatibility, schema migration, rollback path, expected monitoring signal, and test environment. A scoped release checklist may include: startup/join, first interaction, normal loop, failure recovery, cross-platform UI, remotes/security, persistence in isolated data, performance on a representative low-end device, and relevant moderation/policy checks. Run only what is relevant; never claim comprehensive readiness from a partial smoke test.

When making an operational plan, prefer reversible rollout and clear versioning. Publishing or live configuration changes are external consequential actions: do not perform without explicit user authorization.
