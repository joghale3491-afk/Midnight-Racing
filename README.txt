MIDNIGHT RACING v40.1
Track boundaries, smoother steering, street scenery, notifications and car design update

BUILT FROM
- Midnight Racing v40.0, the working race-start/countdown build.

CHANGES
- Player 1 and local Player 2 are kept inside the road corridor. The road shoulder remains usable, with a firm boundary before the outer scenery.
- Continuous guardrails and track-edge reflectors are now present on every track theme.
- Steering input eases into turns and high-speed steering is less abrupt. A / Left Arrow steer left; D / Right Arrow steer right.
- Urban, industrial, harbour and skyway tracks receive closer street-front buildings, illuminated windows, signs and awnings.
- Power-up feed entries and active power-up notifications are cleared when a race ends or the player returns to a menu. Power-up events are ignored outside active races.
- Car body geometry has been refined using original, brand-free vehicle archetypes inspired by real-world categories. Distinct chassis dimensions and more exotic aero details progress with vehicle rarity.
- Wheel centres were refined so black rubber tyres, alloy spokes and brake hardware read more clearly.
- Service-worker cache version updated to v40.1.

PRESERVED
- Y8 SDK integration and App ID.
- Supabase URL and public client key.
- Existing accounts, cloud profiles, multiplayer, race modes, tracks, quests, cars, power-ups and the v40.0 countdown repair.
- No database migrations or table changes are required.

STATIC CHECKS
- JavaScript module syntax check passed.
- CSS parser reported zero errors.
- HTML scan found no duplicate IDs.
- All local src/href references resolve.
- Y8 and Supabase configuration markers present.
- ZIP integrity checked after packaging.

IMPORTANT
These are static package checks. A live browser test is still required to confirm driving behaviour, collision boundaries, track performance and visual appearance on the player's device.
