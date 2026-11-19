# MIDNIGHT RACING

A browser-based 3D street-racing prototype designed for desktop and mobile. The start-up intro leads into the username/account gate and main Race Hub. Host the folder on GitHub Pages or another HTTPS static host.

## Included in this build

Build revision: November 19, 2026 · Track / vehicle visual pass. The service-worker cache version was advanced so deployed browsers fetch this update instead of retaining the older cached page.

### Menu and profile
- Sign-in / account-creation gate with guest play.
- Public racer usernames are shown in the UI, lobbies, race HUD messages and leaderboards; the account email is not used as the player display name.
- Responsive side navigation. Story and Ranked are separate side-navigation destinations; the main Race Hub stays focused on picking a race.
- Settings for sound, original synthesized EDM / techno music, volume and mobile touch style.

### Race controls and vehicles
- Desktop: W / Up accelerates, S / Down brakes, A / Left and D / Right steer, Space uses nitro, Q activates the selected powerup, P / Escape pauses.
- Solo mobile play supports touch controls as well as keyboard controls. Local 2-player shows two dedicated touch-control clusters; Player 1 uses WASD / arrows and Player 2 uses IJKL / U.
- The garage preview and player car use the same 3D vehicle builder, including glass, wheel/rim details, body proportions, paint, upgrade details, spoilers, underglow and rims. Twelve paint swatches are available in the garage.
- Car performance has rank-specific speed and handling bands: each rank has a defined minimum and maximum, with each of its 20 cars placed along that band.
- Rival AI paint colours are randomized. AI pace adapts to the selected car and upgrades.
- Eight circuits with expanded procedural scenery, road shoulders, curbs, lane markings, barriers, lights and theme-specific landmarks. Track quality is generated locally with Three.js primitives; no external 3D asset downloads are required.
- Every standard race randomizes its lap count (2–6), weather (clear, rain, storm, fog or snow) and the position/type of supply-drop powerups. Ghost remains a one-lap personal-best run.
- Time Attack is now last-place elimination: every 30 seconds, the current last-place active racer is removed until only one racer remains. It is a survival race, not a conventional timed lap record.
- In police pursuits, multiple patrol cars actively intercept and ram the player's line. Police vehicles are not respawned after being disabled; the player's chase ends when vehicle condition reaches zero (no player respawn).
- Civilian traffic can be collided with. Supply drops replenish the selected powerup. Vehicle condition respawns outside police pursuits.

### Progression and garage
- Energy is capped at 50, costs 10 per race and regenerates over time.
- Street Rep is earned from street races, Ranked races and events. Every five levels awards Credits, a separate Ranked Ticket and a rare powerup.
- Seven vehicle ranks (D, C, B, A, S, Exotic and Secret), with 20 catalogue entries per rank, rank unlock levels, car levels, performance upgrades and cosmetic attachments.
- Store, powerup inventory, pre-race powerup selection, daily / weekly quests, rotating special events and Friday / Sunday tournament windows.
- Five story chapters with three required side stories per chapter. Each selected mission shows its objective; the chapter main race must be completed before its required side stories, and all side stories must be completed before the next chapter unlocks. Mission objectives must be met for story progress to save.

### Multiplayer
- **Casual Quick Match:** searches a shared Supabase Realtime presence queue and pairs with another user searching for Casual.
- **Private Lobby:** create a six-character casual room code or join a friend's code.
- **Ranked:** separate side-navigation page and separate queue. Requires a signed-in player, Street Rep level 10+, one Ranked Ticket, 10 energy and a second player who is also queueing for Ranked. Ranked never starts as a solo or local race. A Ranked Ticket is consumed only when an opponent has connected.
- Online races use the matched room's presence / broadcast channel to exchange racer positions. Online head-to-head races do not add computer AI racers.
- Server leaderboard and separate Ranked standings are stored in Supabase.

## Supabase setup

1. Open your Supabase project and copy its **Project URL** and **public anon / publishable key**.
2. In `index.html`, replace `YOUR_SUPABASE_PROJECT_URL` and `YOUR_SUPABASE_ANON_KEY` with those values. Never put a `service_role` key in browser code.
3. In Supabase **SQL Editor**, paste and run the full `supabase_setup.sql` file.
4. In **Authentication → URL Configuration**, add your deployed GitHub Pages URL as an allowed site / redirect URL.
5. Confirm Supabase Realtime is available for your project; Casual queue, Ranked queue, private lobby presence and race position broadcasts depend on it.
6. Upload the contents of this folder to the repository's `main` branch and let GitHub Pages redeploy.

Supabase credentials are intentionally left as placeholders in this ZIP. Guest progression and offline racing work without Supabase. Accounts, cloud saves, leaderboards and online matchmaking require the project URL, public key, SQL setup and Realtime connection.

## Important multiplayer limitation

This is a browser-client prototype. Queue pairing and opponent-position synchronization use Supabase Realtime presence / broadcast channels. They are suitable for testing and playing with trusted users, but they are **not server-authoritative**: a competitive public release still needs trusted server-side matchmaking, race simulation / result validation, anti-cheat checks, rating updates and reconnect handling (for example, with Supabase Edge Functions and database RPCs). Do not treat the current browser-submitted leaderboard results as cheat-proof.

## Deploy / update

Extract the ZIP. Upload the **contents** of `Midnight-Racing-main` into your GitHub repository, replacing the old versions of `index.html`, `manifest.webmanifest`, `sw.js`, icons and `supabase_setup.sql`. Keep those files together. Open the GitHub Pages URL in Android Chrome and use the browser menu's **Install app** option to install the PWA.

Three.js and Supabase JS load from public CDNs, so first load and online features need internet access. `online.js` is retained from the original project but is not loaded by the current game; the active online integration is inside `index.html`.


## This update

- The intro screen is a short animated title sequence; clicking “Enter the Night” opens the existing account / guest gate.
- Standard track races use random 2–6 lap lengths. Time Attack has its own 30-second elimination checkpoints and continues until a single active racer remains.
- Weather changes include clear, rain, storm, fog and snow. Rain/storm/snow also adjust grip, and a simple screen weather layer reinforces the 3D fog / lighting change.
- Supply drops are randomized on each race for both location and reward type (boost, repair, shield or scanner). Collecting a drop awards that type to inventory.
- There are eight themed circuits and a richer road/scenery pass. Cars have additional glass and wheel details, broader paint choices and rank-banded performance.

Note: the world and vehicles remain procedural low-poly / stylized 3D models, not high-resolution licensed car or track assets. Online matchmaking currently groups up to six clients through Supabase Realtime presence/broadcast; it still requires configured Supabase credentials and is not server-authoritative.


## Track and race quality update
- Expanded the circuit selection to 12 selectable tracks, including Ember Ridge, Lunar Test Circuit, Neon Port and Redwood Run.
- Added a procedural asphalt grain texture, glowing road-edge guides, additional skyline markers, stars and new volcanic/lunar scenery.
- Race laps (2–6), weather (clear, rain, storm, fog or snow) and collectible powerup placement/type are randomized for each new race.
- Online casual and Ranked matchmaking now group up to six players per race; the host's track, lap count, weather and supply-drop seed are shared with the room.
- Time Attack is a timed last-place elimination event. Eliminated racers are removed from play and the camera follows the remaining field.
- Garage, race and NPC cars share the same base 3D car generator; NPCs use varied body silhouettes and colors, while the selected player car uses its garage model and attachments.
- Added a broader 20-color paint selection and additional class styling for higher-ranked vehicles.

Note: scenery and vehicle geometry are procedurally generated Three.js models. They are stylized 3D assets rather than externally sourced photorealistic models. Online matchmaking still requires the project's own Supabase credentials, Realtime configuration and database policies.
