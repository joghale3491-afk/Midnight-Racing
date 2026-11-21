MIDNIGHT RACING — VERSION 35
============================

INSTALL / UPDATE
1. Extract this ZIP.
2. Upload every item inside the Midnight-Racing-v35 folder to the root of your GitHub Pages repository, replacing the previous files.
3. Keep index.html, sw.js, manifest.webmanifest, all icon files, and the audio folder together.
4. Commit the changes and open the GitHub Pages site.
5. If an older build is cached, hard-refresh with Ctrl+Shift+R. On a phone, close the site and reopen it; clear site data if the old icon remains.

V35 CHANGES
- Keeps the v34 gameplay and visual/audio improvements, including rear-mounted nitro effects, layered boost sounds, checkpoint timing, improved race grid layout, stable timer HUD, mobile controls, P2 split-screen layout, in-game confirmations and per-car visual attachment ownership.
- Adds a standalone Tournament side tab with a three-round online series: Qualifier, Semi-final and Grand Final. Each round is a real online multiplayer race with a minimum of two human racers, round-specific tracks/laps, series points (10/7/5/3/2/1), saved finishes and a series-completion reward.
- Tournament queue matches only players on the same tournament round and weekly event key. The tournament queue is available Friday, Saturday and Sunday. Tournament multiplayer requires a signed-in account, configured Supabase project and working Supabase Realtime presence/broadcast.
- Adds a separate Quest side tab with three multi-stage quest lines: Street Credentials (solo or multiplayer), Online Rival (real online multiplayer objectives), and Pursuit Specialist (Police Pursuit objectives). Stages unlock one after another and have individual credit rewards.
- Expands Police Pursuit with an on-screen heat meter, three escalating phases, flashing red/blue police lightbars, synthesized siren, faster pressure from patrol cars, and backup/interceptor reinforcements at timed stages. It uses original gameplay effects rather than copied NFS assets.
- Adds a custom Midnight Racing MR app mark in PNG and ICO sizes, browser tab/bookmark favicon declarations, Apple touch icon, installable PWA manifest, canonical URL and Open Graph/Twitter sharing metadata.
- Updates the service-worker cache to v35 and includes the icon and manifest files in the offline app shell.

MULTIPLAYER / CLOUD NOTES
- Online tournament matchmaking requires the existing Supabase URL/key configuration, account sign-in, and Realtime enabled for presence/broadcast. This ZIP cannot configure Supabase secrets or create database policies in your project.
- Quest campaigns are saved locally and included in cloud profile saves when a configured account is signed in.
- Tournament progress is saved in the local player profile and syncs only through the game's configured cloud-save system; different devices must be signed into the same account for shared progression.

ICON / SEARCH PREVIEW NOTE
- Browser tabs, bookmarks and installable app icons use the included favicon/PWA image files after the new files are published and cached content refreshes.
- Search-result icons and social share previews are controlled by search engines and social platforms. The site metadata and preview image are now provided, but external crawlers must revisit the public site before previews update; appearance in a search result cannot be forced instantly.

AUDIO NOTE
- Engine, nitro and police siren sounds use generated Web Audio synthesis, and the racing soundtrack is an original bundled loop. Browser audio starts only after a user interaction because autoplay policies commonly block sound before a gesture.

CHECKS / LIMITATIONS
- Inline JavaScript is checked with Node.js syntax validation.
- ZIP integrity and required asset references are checked after packaging.
- A live multiplayer race, Supabase authentication, and full PC/phone gameplay session cannot be verified from this build environment. Please test after publishing to GitHub Pages.
