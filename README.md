# MIDNIGHT RACING

Neon 3D street racing for browser and mobile (installable PWA).

## Deploy
Upload this folder to any HTTPS static host (e.g. GitHub Pages), open it on Android in Chrome and choose **Install app**.

## What's in this build
- Title screen with username, sign in and PLAY; settings (music volume, touch controls)
- Street Rep levels (milestone credit bonus every 5 levels)
- Ranked: online-only, automatic head-to-head matchmaking (level 5+), +25/-15 rank points, Bronze to Diamond
- Casual Online: public lobby and private rooms with no rank points. Story Mode and Ranked live in the side menu
- Energy: each race costs 10 energy, recharging 1 per 20 seconds
- Rivals scale with your upgrades, rep and ranked mode
- Respawn at full condition when vehicle condition hits zero (not in police pursuits)
- Daily and weekly quests, ghost races (race your saved best run per track), traffic crashes that damage you and the AI, random game type on Random Circuit
- More frequent power-ups, on-screen pause button, background music, working service worker

## Backend
Accounts, cloud saves and online rooms use Supabase directly from `index.html` (table `game_saves`).
`online.js` and `supabase_setup.sql` are an older starter and are not used by the game.

- Story missions show a clear briefing and objective; Special Events (Nitro Frenzy, Elimination, Infected Survival) with a daily featured x2 bonus; how-to-play tutorial; Street Rep level bar; on-screen objective banner
