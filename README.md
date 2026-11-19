# MIDNIGHT RACING

Neon 3D street racing for browser and mobile (installable PWA).

## Deploy
Upload this folder to any HTTPS static host (e.g. GitHub Pages), open it on Android in Chrome and choose **Install app**.

## What's in this build
- Title screen with username, sign in and PLAY; settings (music volume, touch controls)
- Street Rep levels (milestone credit bonus every 5 levels), ranked races at level 5 with rank points
- Energy: each race costs 10 energy, recharging 1 per 20 seconds
- Rivals scale with your upgrades, rep and ranked mode
- Respawn at full condition when vehicle condition hits zero (not in police pursuits)
- More frequent power-ups, on-screen pause button, background music, working service worker

## Backend
Accounts, cloud saves and online rooms use Supabase directly from `index.html` (table `game_saves`).
`online.js` and `supabase_setup.sql` are an older starter and are not used by the game.
