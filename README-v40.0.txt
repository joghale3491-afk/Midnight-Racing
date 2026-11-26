MIDNIGHT RACING v40.0 — FRAME-SAFE COUNTDOWN & ORIGINAL VEHICLE DESIGN OVERHAUL

Based on the supplied v39.9 full game package.

RACE START / COUNTDOWN
- Replaced the one-second setInterval countdown and 12-second timeout watchdog with a frame-driven countdown tied to the visible main render loop.
- Countdown advances only while the game is actively drawing frames. When the browser tab is hidden, it pauses; when the player returns, it restarts from 3 so background throttling cannot skip GO.
- A watchdog now checks whether the actual 3D render loop is alive and reports the real failing stage. Race energy and ranked tickets are committed only after GO.
- The previously reported placeOnGrid helper is present in the build.

ORIGINAL CAR MODEL IMPROVEMENTS
- Updated all 140 catalogue entries with class-shifted body archetypes and bounded unique chassis, wheelbase, cabin, overhang and width variations.
- Improved tyre and rim read: rubber remains the outer surface; the brake disc is smaller and darker behind open multi-spoke alloy geometry; detailed models add rotor marks and lug nuts.
- Added clearer fender lips, door seams, side handles, bonnet creases, rear LED bridge and undertray details.
- These models are procedural original Three.js geometry rather than third-party copyrighted vehicle meshes or brand replicas.
- Player, AI, traffic, Garage and Store continue to use the same catalogue model identifiers.

PRESERVED
- Y8 SDK integration and existing App ID configuration.
- Supabase URL and public client key configuration.
- Existing multiplayer, player profiles, saved progression, car catalogue, power-ups, quests, tracks, and audio assets.
- No Supabase SQL changes or migrations are required.

STATIC VALIDATION
- Run JavaScript module syntax checks.
- Verify HTML parsing, local asset references, service-worker cache version and ZIP integrity.
- Live browser/WebGL gameplay cannot be guaranteed by static checks; test one solo race, one local two-player race, Garage and Store after upload.
