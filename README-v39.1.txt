MIDNIGHT RACING v39.1 — MOBILE HUD, LANDSCAPE UI & RANKED CLASS MATCHMAKING
============================================================================

WHAT CHANGED
- Reworked the race HUD spacing and readability, including the standard race timer, lap/position and speed readouts.
- Added a contextual mode-timer progress rail and a consistent MM:SS display for Time Attack, Police, Checkpoint, Drift and Infected modes.
- Added dedicated mobile-landscape layouts for the menu, mode/track cards, pre-race dialogs, HUD and touch controls. The game does not force screen rotation; portrait remains supported.
- Improved touch target sizes, focus visibility, queue roster spacing and menu card consistency.
- Ranked matchmaking now groups human players by the selected car class (D, C, B, A, S, Exotic or Secret). Players only see same-class drivers in their Ranked queue. Ranked AI fillers are also restricted to that class.
- Casual and Tournament matchmaking rules are unchanged.

IMPORTANT RANKING NOTE
This v39 codebase contains vehicle-class ranks, not a separate player skill-rating/MMR tier. Therefore, same-rank Ranked matchmaking in this update means same selected CAR CLASS. It does not implement Bronze/Silver/Gold player divisions or an MMR rating.

INSTALL
1. Extract the ZIP.
2. Open index.html and keep/restore your own Supabase Project URL and Publishable/anon key in the two existing constants. Never use a service_role/secret key.
3. Upload the contents of the Midnight-Racing-v39.1 folder to the root of the GitHub Pages repository, replacing the old files.
4. Commit to main.
5. Open the published game and refresh. If an older UI remains, use Ctrl+Shift+R on PC. On mobile, close the browser tab and reopen the published link.

SUPABASE / SQL
- No new SQL is required for these changes. Ranked class grouping uses Supabase Realtime Presence fields already published by the queue client.
- Keep your existing v37 private-room migration installed. Do not rerun old SQL scripts.
- This package is based on the exact v39 ZIP provided in this conversation; it does not include later v40/v41-only files or migrations.

TEST CHECKLIST
- Desktop: select Ranked, search with two accounts using the same car class, then repeat with a different class.
- Mobile portrait: inspect menu, race HUD and touch controls.
- Mobile landscape: inspect menu navigation, race briefing, timers, steering and powerup controls.
- Modes with countdowns: Time Attack, Police, Checkpoint, Drift and Infected.

VALIDATION
JavaScript syntax and key asset/HTML checks should be performed before release. The package has not been live-tested against the user's Supabase project or every mobile browser/device; cross-device Realtime matching and gameplay still require testing.
