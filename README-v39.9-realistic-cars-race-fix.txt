MIDNIGHT RACING v39.9 — REALISTIC VEHICLE MODELS & RACE START FIX

Built from the v39.8 3D showroom/WebGL package.

FIXES AND IMPROVEMENTS
- Fixed the race-start ReferenceError: defined the missing placeOnGrid() helper used to align AI rivals on the starting grid.
- Rebuilt vehicle generation around 20 coherent road-car archetypes and catalogue-ID-based dimensional variation. All 140 catalogue entries receive different wheelbase, body width/length, cabin placement/size and tyre dimensions.
- The same catalogue-specific chassis is used by the player, Garage, Store, AI opponents, local Player 2 and civilian traffic.
- Replaced solid metallic-looking wheel discs with rubber tyre cylinders, black sidewalls, a five-spoke face, rim ring, brake rotor and hub; higher-detail cars also get calipers.
- Reduced exaggerated body scaling and removed overly large add-on shapes that made vehicles look distorted.
- Civilian traffic uses a lighter visual detail level to limit rendering cost while retaining its unique body and wheel design.
- Preserved the existing 3D showroom, Y8 SDK integration, Supabase project configuration, multiplayer and game content.

CHECKS
- Main JavaScript module passes Node syntax validation.
- Race-grid helper definition and call references checked.
- Catalogue has 140 models; deterministic body/chassis dimension tuples are unique across all 140.
- Supabase and Y8 SDK configuration strings preserved; no placeholder values found.
- ZIP integrity and root-level index.html verified.
- A live browser driving/rendering test is still required.
