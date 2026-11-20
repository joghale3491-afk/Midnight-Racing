# MIDNIGHT RACING — Combined Update

This package combines the November 19 Track / Graphics Upgrade with the uploaded Online Racing, Multiplayer Lobby, Main Story Episodes, and Quest / Star Ratings updates.

## Included

## November 20 — Gameplay, Ranked AI and Visual Stability Update

- Reworked Time Attack and Infected into timed last-place/tagged-racer elimination rounds; Police Pursuit uses active intercepting patrol AI and a 90-second escape target; Ghost Run races the saved personal best; Drift Trial uses its dedicated Drift Arena; Checkpoint Run and Traffic Run have explicit timed objectives and a strict damage cap.
- Replaced Survival Gauntlet with Rival Duel. Local two-player result handling, per-player finish states, and mode-specific failure/respawn behavior have been tightened.
- Added collision damage for player cars, local Player 2, AI rivals, civilian traffic and roadside barriers. Disabled vehicles respawn at full condition in normal modes; Police Pursuit and Traffic Run retain their elimination/failure rules.
- Ranked waits up to 18 seconds for human players, then fills every open seat to a six-driver grid with AI whose car rank, vehicle stats and driver level are derived from the human lobby. Offline rivals also use class-matched vehicle stats and adapt their pace and racing line.
- Vehicle price, class, model and individual car level now determine displayed and live performance. Speedometer conversion was corrected so a D-class car's top-speed stat is its real displayed km/h cap rather than being boosted above 200 km/h.
- Improved car/track presentation and renderer performance, initialized the race camera at the starting grid, and refreshed RaceHub, Story, garage and race setup selectors with visible option cards. Powerup acquire/use notifications and the relocated pause control are included.
- Static JavaScript syntax, HTML structure/duplicate-ID checks and deterministic AI roster tests pass. Live 3D gameplay, browser-specific rendering and multi-account Supabase matchmaking still need to be tested in a real browser session.


- 30 procedural Three.js circuits with distinct turn profiles, improved road / scenery pass, 3D garage and shared vehicle model builder.
- Rank-banded 140-car catalogue, car levels, upgrades, paint colours, attachments, store and powerup inventory.
- Responsive desktop / mobile controls, separate local two-player controls, tutorial, intro and original synthesized EDM / techno audio.
- Thirty-chapter Nightshift campaign matched one-to-one with the 30 circuits, three crew episodes per chapter (90 side episodes), story-path decisions, mission objectives, chapter / episode star ratings, and required episode progression.
- Daily / weekly contracts, longer-term Nightshift crew contracts, rotating events, tournament windows, Street Rep milestones and Ranked Tickets.
- Casual Quick Match, public casual lobby, private lobbies with ready-up and host start, and a separate online-only Ranked queue. All online rooms are capped at six racers.
- Shared online race start settings, remote racer positions / speed / lap / damage / nitro, online collision messaging, shared pickup claims, finish notifications and online results display.
- 100 Energy cap with automatic +1 Energy every five minutes (including offline time), exactly 5 Energy charged at the start of each race, purchasable +25 Energy refills and Ranked Tickets, per-race objective / loadout briefing, randomized 2–6 lap races, per-race weather and seeded randomized supply-drop placement.


## November 19 — UI / 3D Weather / Track Expansion

- Expanded the procedural circuit roster to 30 tracks. Only the first story circuit is available initially. Each following circuit unlocks after its matching previous chapter main race and all three crew episodes are completed; the final circuit unlocks after Chapter 29 and its three episodes are cleared.
- Replaced the block-based car shell with beveled, tapered body geometry, a separate glass cabin, angled glass panels, detailed wheels, lamps and class-dependent aero. The same vehicle builder is used in the garage and race world.
- Replaced the fixed-screen weather graphic with 3D rain streaks, drifting snow, animated fog layers, wet-road materials and occasional storm lightning. Weather is identified in the race HUD.
- Reorganized Race Hub track selection and pre-race preferences into collapsible setup groups, improved menu scrolling and responsive layouts, and refreshed touch-control surfaces.


## November 20 — Story, Garage, Track Layout and Economy Expansion

- Expanded the Nightshift campaign to 30 main chapters and 90 side episodes. The ordered track list follows the story chapter order; completing a chapter race and earning at least one star in all three side episodes unlocks the next chapter and its matching circuit.
- Added two chapter decisions (Back the Crew / Chase the Lead) with different win rewards, and chapter-specific mission briefings with story dialogue, objectives and reward information.
- Added a pre-race briefing to solo, story, side-story, tournament and rotating special-event starts. Players can equip up to two owned powerups; an empty loadout is allowed.
- Added Drift Trial, Checkpoint Run, Rival Duel and Traffic Run as original modes alongside Street, Police Pursuit, Time Attack, Ghost Run, Infected and Random Circuit.
- Expanded powerups to eight types. Added credit purchases for powerups, +25 Energy refills, Ranked Tickets, 40 paint finishes and nine visual attachments.
- Rebuilt garage car choice as visible vehicle cards with rank filters. Upgrade prices scale with vehicle rank and upgrade level, while engine / handling gains remain small and capped within each vehicle's class range. Upgrade records are stored per car.
- Added turn-profile geometry to the 30 circuits: hairpins, chicanes, esses, kinks, double-apex corners, banked sections and varying-radius bends. Each track card lists its turn profile.
- Energy automatically regenerates by one point every five minutes, up to 100, while the game is open or closed. Every race attempt that starts charges exactly 5 Energy; queue searches and lobby browsing do not charge Energy. The partial recharge timer is retained when energy is spent. A deliberately empty pre-race powerup loadout remains empty after saving and reloading. Store refills add 25 Energy up to the 100 Energy cap.

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

- Casual Quick Match and Ranked search separate queues. Ranked requires a signed-in player at Street Rep level 10+, one Ranked Ticket and at least 5 Energy; a ticket is consumed when the shared race launches. Ranked searches for humans for up to 18 seconds, then fills remaining grid slots with AI rivals matched to the human lobby’s Street Rep level, car class and vehicle stats so the six-driver grid can start even when the queue is quiet.
- Public and private casual rooms support up to six players. Private/public lobbies display player readiness; the host starts after at least two players are present and everyone is ready.
- Online position, car state, pickup claims, contact effects and finishes use Supabase Realtime broadcast. Ranked gives the queue up to 18 seconds to find human opponents, then adds stat-matched AI fillers to reach a six-driver grid. The shared roster is generated from the human players’ Street Rep level, selected car rank and derived vehicle stats; every client simulates its own physics and AI fillers locally. This is still a client-authoritative prototype, not production anti-cheat or trusted server matchmaking. Public competitive launch needs a server-authoritative queue/race/result service, validation and reconnect handling.

## Asset / test limitations

Tracks and cars remain locally generated stylized 3D geometry. They are not high-resolution licensed assets. Static HTML / JavaScript checks can detect syntax and structural problems, but they do not replace live gameplay tests in multiple browsers / accounts. Configure Supabase and test the public/private lobby, ready-up, synchronized starts, car state, pickup claims and finish results with at least two separate accounts before relying on online play.

## November 19 — Energy, Notifications, Events and Ranked Queue Update

- Energy capacity is now 100. Every race costs exactly 5 Energy at race start; searching queues and browsing lobbies costs nothing. Energy regenerates by +1 every five minutes, including time offline, and the Store sells +25 refills.
- Added an auto-opening notification inbox for rewards, unlocks, energy updates, purchases, event resets and Ranked grid fills. The bell keeps unread counts available.
- Daily and weekly challenge targets and rewards scale with Street Rep / selected car rank. AI event pace and special-event objectives also scale with rank tier.
- Ranked matchmaking searches for humans for 18 seconds, then fills the remaining seats with up to five AI opponents. Total ranked grid size is six. Ranked still requires a signed-in Level 10+ player and a Ranked Ticket.
- Garage rank chips and Store rank chips show distinct selection states; the Store now only displays actual vehicle classes (D through Exotic) instead of an ambiguous All Ranks option.


## Update v17 — AI powerups and visual refresh

- Added a live two-slot in-race powerup panel with item names, key hints, and remaining charges. The panel can be clicked to select a slot; Q activates the selected item and E switches between available slots.
- AI rivals now start with a small private powerup kit, collect supply drops, and activate boost, repair, shield, grip, pulse, jammer, scanner, and overdrive according to race conditions. AI powerups have visible temporary glow effects.
- AI racing lines now make short adjustments toward nearby supply drops. AI inventories are separate from the player's saved inventory.
- Improved rival/ghost/remote-car detail while keeping civilian traffic on the lower-cost model. Added more sport trim, improved wheel faces, body accents, lights, and aero details.
- Added textured terrain, stronger asphalt detail, lane paint, illuminated trackside bollards, branded circuit signs, corner lighting, and more balanced scene lighting.
- Bumped the service-worker cache key so browsers fetch the new build.

The updated JavaScript passes syntax validation. The live WebGL scene still requires a browser/device smoke test to confirm visual performance on the target hardware.


## Update v18 — finish line and AI powerup improvements

- Added a high-contrast black-and-white checker stripe across the road and a lit START / FINISH banner above the circuit at the start/finish point. Both local racers receive a finish-line notification on crossing.
- Fixed AI powerup decisions so police pursuit vehicles can also activate their own powerups. Patrol cars receive shield, pulse or jammer charges; other rivals can use repair, shield, grip, pulse, overdrive, jammer and scanner.
- Added distinct temporary AI powerup glow colors and extended pickup seeking while scanner is active. AI inventories remain private and do not use the player’s stock.
- Bumped the service-worker cache key so browsers fetch the updated build.

Static JavaScript syntax and structural checks are run on the packaged build. A live browser/device test is still required for WebGL visuals and online multiplayer behavior.

- AI shields now also protect police units from player-caused impact damage.
