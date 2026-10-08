# Testing, Debugging, Review, and Quality Gates

Choose tests based on changed behavior and risk. A simple cosmetic label change does not require the same gate as trading, purchases, save migration or publishing.

## Debugging sequence

1. Reproduce the failure; capture exact action, place/session, player count and device/input.
2. Inspect Output/client/server logs and identify the first relevant error/warning, not merely downstream symptoms.
3. Trace source ownership: client or server script, instance parent, replication timing, remotes, async result and lifecycle.
4. Form one falsifiable hypothesis, change one relevant variable, and rerun the failing path.
5. Inspect changed source/hierarchy and check for regressions in adjacent state paths.
6. Report root cause only when supported by evidence; distinguish likely cause from confirmed cause.

## Change-scaled gates

**UI-only/cosmetic:** source/hierarchy readback; relevant screen preview; readability/contrast; one narrow and one wider viewport; no clipping/Output error.

**Interactive UI:** additionally primary/cancel/repeated-input paths, loading/error/empty/disabled states, touch/mouse/gamepad as supported, close/reopen/respawn cleanup, stale async response.

**Gameplay/network:** additionally client/server simulation, server rejects malformed/forged/stale requests, duplicate/rate conditions, multi-client synchronization where relevant, server-side result observed.

**Persistence/economy/purchase:** additionally isolated test data, failure/retry behavior, idempotency, no destructive live key, authoritative value readback, receipt verification according to current official APIs.

**Release or broad refactor:** run relevant full test matrix, static/type/build checks, regression paths, dependency/API freshness, change summary and unresolved-risk review. Never publish unless authorized.

## UI/device matrix

For supported devices, test at least one representative narrow portrait, landscape, tablet-like and desktop viewport; console/controller when the experience claims support. Use Device Simulator/Controller Emulator if available. Cover safe area/insets, thumbstick/jump zones, text expansion, scrolling/clipping, touch hit region, focus order, gameplay focal area, and actual state transitions. Record which exact cases were actually run.

## Performance review

Check repeated list rendering and update frequency; avoid full-tree rebuild for small changes, expensive work every frame, unnecessary layout churn, unbounded loops, runaway connections and large uncapped data sets. Use profiler/measurement tools when available and state measured findings. Do not assert “optimized” without a measured or clearly described basis.

## Evidence ledger

Use a brief evidence table when work is substantial:

| Claim | Evidence | Coverage | Status |
|---|---|---|---|
| UI renders as intended | Preview/screenshot | named viewport + state | PASS / PARTIAL / NOT RUN |
| Control activates | input action + observed result | input mode and route | PASS / PARTIAL / NOT RUN |
| Server accepts/rejects | server log/state | expected and forged payloads | PASS / PARTIAL / NOT RUN |
| Data persisted | readback | isolated key/test account | PASS / PARTIAL / NOT RUN |

A screenshot supports appearance only. A UI tree supports structure/geometry only. Input sent is not necessarily activation. A successful remote call does not prove the server outcome was correct. Mark claims narrowly.

## Code review checklist

- Correct Script/LocalScript/ModuleScript placement and lifecycle.
- Typed public interfaces; untrusted data narrowed; no deprecated/unknown API without verification.
- Server validates important outcomes and bounded remote payloads.
- Error paths, async cancellation/staleness, duplicate connections and respawn are handled.
- UI has coherent states, focus/touch behavior, responsive geometry and safe recovery.
- Data operations check results and cannot overwrite valid data with fallbacks after failure.
- Changes are focused; project conventions and dependencies retained; no unnecessary per-frame work.
- Test claims match actual evidence; remaining gaps disclosed.
