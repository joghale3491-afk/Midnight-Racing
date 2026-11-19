# MIDNIGHT RACING

A browser-based 3D street-racing prototype designed for desktop and mobile. Host the folder on GitHub Pages or another HTTPS static host.

## Included in this build

Build revision: November 19, 2026. The service-worker cache version was advanced so deployed browsers fetch this update instead of retaining the older cached page.

### Menu and profile
- Sign-in / account-creation gate with guest play.
- Public racer usernames are shown in the UI, lobbies, race HUD messages and leaderboards; the account email is not used as the player display name.
- Responsive side navigation. Story and Ranked are separate side-navigation destinations; the main Race Hub stays focused on picking a race.
- Settings for sound, original synthesized EDM / techno music, volume and mobile touch style.

### Race controls and vehicles
- Desktop: W / Up accelerates, S / Down brakes, A / Left and D / Right steer, Space uses nitro, Q activates the selected powerup, P / Escape pauses.
- Solo mobile play supports touch controls as well as keyboard controls. Local 2-player shows two dedicated touch-control clusters; Player 1 uses WASD / arrows and Player 2 uses IJKL / U.
- The garage preview and player car use the same 3D vehicle builder, including selected body proportions, paint, upgrade details, spoilers, underglow and rims.
- Rival AI paint colours are randomized. AI pace adapts to the selected car and upgrades.
- Up to 10 laps, four circuits, random track / mode selection, time attack, ghost, infected and police pursuits.
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
