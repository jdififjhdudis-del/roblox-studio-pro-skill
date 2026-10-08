# Roblox Feature Slice — [Feature Name]

## Player outcome
[What becomes possible in the game?]

## Scope
**Included:** [...]
**Explicitly excluded:** [...]
**Assumptions:** [...]

## Current project facts
- Place/source of truth: [...]
- Existing owner/modules: [...]
- Toolchain/dependencies: [...]
- Relevant warnings/tests: [...]

## State and ownership
| State/data | Canonical owner | Client presentation | Persisted? |
|---|---|---|---|
| [...] | Server/client/static | [...] | Yes/no |

## Contracts
| Boundary | Request/input | Validation | Result/failure |
|---|---|---|---|
| Client → server remote (if any) | [...] | [...] | [...] |

## Implementation slices
1. [Small playable normal path]
2. [Failure/cancel/recovery path]
3. [Additional cases only when needed]

## UI and feedback
[Load `ui-design-brief.md` if feature includes a non-trivial surface.]

## Risk and abuse cases
[Invalid payload, repeat, race, disconnect, respawn, stale state, persistence failure, asset failure, etc.]

## Acceptance tests
- [ ] Normal journey observed
- [ ] Failure/edge cases observed
- [ ] Client/server authority verified
- [ ] Relevant device/input configurations checked
- [ ] Data tested only in isolated environment if destructive
- [ ] Source/hierarchy read back and no new unexplained errors

## Delivery
[Changed paths/Explorer tree, setup, evidence, untested risks, rollback note]
