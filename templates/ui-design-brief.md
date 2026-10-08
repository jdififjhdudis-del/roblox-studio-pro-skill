# UI Design Brief — [Feature Name]

**Status:** Draft / Approved (use Approved only after the authorized reviewer approves)
**Surface:** ScreenGui / world-space GUI / HUD / other
**Existing project style to preserve:** [link or short description]

## Player goal
[What the player needs to do or understand.]

## Priority and hierarchy
1. Primary action/information: [...]
2. Secondary: [...]
3. Supporting/optional: [...]

## Flow and navigation
- Entry point: [...]
- Primary path: [...]
- Cancel/back/close path: [...]
- Recovery/error path: [...]

## Components and data
| Component | Purpose | Data source/authority | Actions |
|---|---|---|---|
| [...] | [...] | client display / server state / static | [...] |

## States
- Default: [...]
- Loading/pending: [...]
- Empty: [...]
- Selected/focus: [...]
- Disabled/locked: [...]
- Success: [...]
- Error/retry: [...]
- Long text/missing asset: [...]

## Visual system
[Semantic color, typography, spacing, shape, icon and motion roles. Adapt to game style; don't lock in arbitrary values without testing.]

## Responsive/input behavior
| Target | Composition/reflow | Input/focus | Safe-area notes |
|---|---|---|---|
| Phone portrait | [...] | Touch | [...] |
| Phone landscape | [...] | Touch | [...] |
| Tablet | [...] | Touch/keyboard | [...] |
| Desktop | [...] | Mouse/keyboard | [...] |
| Console (if supported) | [...] | Gamepad | [...] |

## Acceptance checks
- [ ] Primary action is visually clear and operable.
- [ ] Relevant empty/loading/error/success/disabled states exist.
- [ ] No critical clipping or overlap at supported viewports.
- [ ] Text, hit regions and focus are usable for supported inputs.
- [ ] Server-authoritative actions reconcile from trusted results.
- [ ] Verification evidence and untested cases are recorded.
