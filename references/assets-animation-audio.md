# Assets, Animation, Audio, and Visual Feedback

Use when a task includes Toolbox/Creator Store assets, images/icons, meshes, animations, sounds, particles, camera effects, or reward “feel.” Asset/publishing operations can carry security, licensing, and cost/permission implications; use actual approved sources and verify every result.

## Asset sourcing and security

- Inspect source, creator/ownership, type, dependencies and license/usage terms before relying on an external asset. Prefer official/user-supplied assets or verified repository provenance.
- Treat inserted models/plugins/scripts as untrusted until audited. Search for unexpected scripts, remote calls, obfuscated code, privileged effects and unrelated descendants before placing in production.
- Never fabricate Roblox asset IDs or say an asset has been uploaded when it has not. Distinguish concept art/mockup from an approved runtime asset.
- Check actual asset availability and permission in Studio; an ID alone is not proof of access or safe usage.
- Before paid generation, upload, marketplace operation or destructive asset replacement, identify expected side effects and get required authorization.

## UI icons and images

Choose iconography that communicates meaning at the actual display size and against its background. Provide consistent aspect/crop/contrast, text alternatives/labels, fallback for missing/failed assets, and a load state for critical imagery. Avoid unique icon-only actions whose meaning is unclear. Test memory/latency impact for large image lists.

## Animation workflow

1. Identify rig type, target instance, ownership and animation purpose.
2. Verify supported animation APIs and asset permissions for the target experience.
3. Plan the state/event that starts and stops the animation (equip, action, emote, result), plus interruption/respawn cleanup.
4. Set priority/looping/blend behavior intentionally and keep gameplay-critical hit/authority independent of cosmetic playback where appropriate.
5. Test with the real rig and concurrent animations; inspect animation load/failure and replicated visibility as needed.

Never assume an animation asset is available because its ID is known. Check current Creator Hub behavior and the project's ownership/access.

## Audio and VFX feedback

Tie effects to meaningful state transitions; avoid duplicate playback from both client and server without a clear reason. Choose audience/context, distance/volume, concurrency and cleanup. Limit particle count, lifetime, emit rate, screen effects and transient instances for mobile performance. Keep essential success/failure feedback perceivable without audio or color alone.

Use short and consistent timing; effects should reinforce rather than delay the next player action. Test repeated events, low-end rendering, quiet/muted conditions and failed asset loads.

## Provenance in the handoff

State whether visual/audio assets are user-supplied, existing project assets, official/approved Creator Store, generated concepts, or placeholders. List any asset IDs only when observed and permitted. Call out missing permissions or substitution requirements.
