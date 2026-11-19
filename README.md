# MIDNIGHT RACING — Combined Update

This package combines the November 19 Track / Graphics Upgrade with the uploaded Online Racing, Multiplayer Lobby, Main Story Episodes, and Quest / Star Ratings updates.

## Included

- Existing 12-track procedural Three.js circuits, improved road / scenery pass, 3D garage and shared vehicle model builder.
- Rank-banded 140-car catalogue, car levels, upgrades, paint colours, attachments, store and powerup inventory.
- Responsive desktop / mobile controls, separate local two-player controls, tutorial, intro and original synthesized EDM / techno audio.
- Eight-chapter Nightshift campaign, three narrative side episodes per chapter, story-path choice, mission objectives, chapter / episode star ratings, and required episode progression.
- Daily / weekly contracts, longer-term Nightshift crew contracts, rotating events, tournament windows, Street Rep milestones and Ranked Tickets.
- Casual Quick Match, public casual lobby, private lobbies with ready-up and host start, and a separate online-only Ranked queue. All online rooms are capped at six racers.
- Shared online race start settings, remote racer positions / speed / lap / damage / nitro, online collision messaging, shared pickup claims, finish notifications and online results display.
- 50 energy cap, randomized 2–6 lap races, per-race weather and seeded randomized supply-drop placement.


## November 19 — UI / 3D Weather / Track Expansion

- Expanded the procedural circuit roster to 30 tracks. The first three are available initially; additional groups unlock after completing a chapter race and all three crew episodes. The final routes unlock after the campaign is complete.
- Replaced the block-based car shell with beveled, tapered body geometry, a separate glass cabin, angled glass panels, detailed wheels, lamps and class-dependent aero. The same vehicle builder is used in the garage and race world.
- Replaced the fixed-screen weather graphic with 3D rain streaks, drifting snow, animated fog layers, wet-road materials and occasional storm lightning. Weather is identified in the race HUD.
- Reorganized Race Hub track selection and pre-race preferences into collapsible setup groups, improved menu scrolling and responsive layouts, and refreshed touch-control surfaces.

## Install

1. Extract the ZIP file.
2. Open the `Midnight-Racing-main` folder created when you extract the ZIP.
3. Upload **all contents of that folder** into the root of the existing GitHub repository, replacing the older files.
4. Commit the update to `main` and wait for GitHub Pages to publish.
5. Open the game and hard refresh (`Ctrl + Shift + R`). On mobile, close and reopen the site after deployment.

## Supabase setup

1. In `index.html`, replace `YOUR_SUPABASE_PROJECT_URL` and `YOUR_SUPABASE_ANON_KEY` with your project's URL and public anon / publishable key. Never place a service-role or secret key in browser code.
2. Run the full `supabase_setup.sql` in the Supabase SQL Editor.
3. Add the deployed GitHub Pages URL in Supabase Authentication URL Configuration.
4. Ensure Supabase Realtime is available for the project. Casual matchmaking, Ranked matchmaking, public/private lobbies, ready states and race broadcasts depend on it.

Credentials are intentionally placeholders. Offline / guest racing remains available without Supabase. Account login, cloud saves, online queues and server leaderboards require configuration.

## Multiplayer notes

- Casual Quick Match and Ranked search separate queues. Ranked requires a signed-in player at Street Rep level 10+, one Ranked Ticket and at least 10 Energy; a ticket is consumed only after a valid room launch.
- Public and private casual rooms support up to six players. Private/public lobbies display player readiness; the host starts after at least two players are present and everyone is ready.
- Online position, car state, pickup claims, contact effects and finishes use Supabase Realtime broadcast. Every client simulates its own physics. This is still a client-authoritative prototype, not production anti-cheat or trusted server matchmaking. Public competitive launch needs a server-authoritative race/result service, validation and reconnect handling.

## Asset / test limitations

Tracks and cars remain locally generated stylized 3D geometry. They are not high-resolution licensed assets. Static HTML / JavaScript checks can detect syntax and structural problems, but they do not replace live gameplay tests in multiple browsers / accounts. Configure Supabase and test the public/private lobby, ready-up, synchronized starts, car state, pickup claims and finish results with at least two separate accounts before relying on online play.
