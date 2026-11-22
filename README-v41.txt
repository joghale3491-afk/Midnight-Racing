MIDNIGHT RACING v41 — STARTUP, COMPETITIVE PLAY & UI UPDATE
==========================================================

WHAT THIS UPDATE CHANGES
- Fixes the intro flow: ENTER THE NIGHT now explicitly opens the account gate, or opens the main hub directly when an account session is already restored.
- Starts with the account screen and main menu hidden, preventing the main menu from covering the account screen.
- Guest play, sign-in and sign-up all explicitly reveal the main hub.
- Makes the PLAY RACE action show a readable message if the 3D renderer or briefing cannot start.
- Keeps the full v40 game content, the prior v40.3 startup patch and the bundled local audio files.
- Ranked matchmaking starts with a close rating window and widens the acceptable rating difference as the queue waits.
- Ranked results now use a server-registered human match roster. The browser no longer supplies the list of opponent IDs to the protected result procedure.
- Server records prevent the same player from submitting twice for one competitive match and prevent two registered humans from claiming the same placement.
- Tournament entry, three-round progression, round placements and points are saved in Supabase and can be loaded across devices.
- Adds a global weekly tournament standings list.
- Keeps the existing global ranked leaderboard, player profiles, career stats and achievement pages.
- Adds clearer keyboard focus and mobile touch-target styling.
- Includes STATIC-REVIEW-v41.txt with the source-level checks and live-test limits.

IMPORTANT SECURITY LIMIT
This is stronger validation, not a cheat-proof game server. Race physics and timing still run in the browser. A modified client could still falsify movement or finishing data before submitting it. Fully authoritative anti-cheat needs a trusted server-side simulation/telemetry service (for example, a Supabase Edge Function backed by a trusted game server). Do not market client-side race results as fully cheat-proof.

SUPABASE SETUP — READ BEFORE RUNNING SQL
Your existing Supabase project and player data are reused. Do not delete tables or reset the project.

For the existing Midnight Racing project that already has v37 private-room features and v40 competitive progression:
1. Open Supabase → SQL Editor → New query.
2. Run ONLY: supabase_v41_integrity_tournaments.sql
3. Confirm the final verification query shows the four permissions as expected (direct-read flags are expected false; join/submit flags true; legacy RPC blocked true).

The package also includes these older scripts for reference/new-project setup:
- supabase_setup.sql — original base schema. Run only for a brand-new project or if the base tables have never been created.
- supabase_private_rooms_v37.sql — run only if the private-room migration has never been installed.
- supabase_v40_competitive_progression.sql — run only if the v40 ranked/progression migration has never been installed.
- supabase_v41_integrity_tournaments.sql — new migration for this release; run once.

For an empty/new Supabase project, use this order: base setup → v37 private rooms → v40 progression → v41 integrity/tournaments.
Do NOT rerun base/v37/v40 on the existing project when they already succeeded. The v41 script is additive and does not clear your saves or accounts.

GITHUB INSTALL
1. Download and extract the ZIP.
2. Open the inner Midnight-Racing-v41 folder.
3. Before uploading, open index.html and restore your existing Supabase Project URL and public Publishable/anon key in SUPABASE_URL and SUPABASE_ANON_KEY. The ZIP intentionally contains placeholders. Never paste a Secret/service-role key into the browser file.
4. Upload the contents of the inner folder to the root of your existing GitHub Pages repository, replacing the old game files.
5. Commit to main. Do not delete Supabase tables or local game saves.
6. Open the published game and do a hard refresh (Ctrl+Shift+R on Windows). The service-worker cache has a new v41 name so the browser should fetch the new shell.

TEST CHECKLIST
1. Fresh load: only the intro screen should be visible.
2. Press ENTER THE NIGHT: the account screen should appear. If already signed in, it should go to the main hub.
3. Press CONTINUE AS GUEST: the main hub should appear.
4. Click each left-side navigation item: Race Hub, Story, Ranked, Tournaments, Quests, Garage, Store, Events, Rankings, Profile, Achievements, Settings and Multiplayer.
5. On Race Hub, choose a race mode and track, then press PLAY RACE. The briefing should appear.
6. Press CONFIRM LOADOUT · START RACE. The countdown and race should appear if WebGL 2 is available.
7. In two signed-in browsers/devices, test Ranked and Tournament matchmaking. Both drivers must be signed in and enter the same match.
8. Complete tournament rounds and confirm the current round/points update from Supabase after refreshing on another device.

WHAT WAS CHECKED IN THIS PACKAGE
- JavaScript module syntax validation (Node.js parser).
- HTML duplicate-ID scan and event-listener target scan.
- Presence of local audio files referenced by the service worker.
- SQL text/function signature consistency by source inspection.

WHAT STILL NEEDS LIVE TESTING
A real browser session against your Supabase project is needed to verify WebGL rendering, external CDN availability, authentication, Realtime matchmaking, two-device race synchronization and SQL permissions. This environment could not complete a live browser run against your project, so those items are not claimed as passed. If the game still gets stuck, send the screen you reach and any message shown in the game's own status area.

SUPABASE KEYS
Only the Project URL and public Publishable/anon key belong in index.html. Never expose the database password, service-role key or Supabase Secret key.
