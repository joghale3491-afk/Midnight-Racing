# MIDNIGHT RACING

A browser-based 3D street-racing prototype with a mobile-friendly game hub. It can be hosted on GitHub Pages or another HTTPS static host.

## What's included in this update

- New title / sign-in gate with guest play, username editing and Supabase sign-in/sign-up hooks.
- Local profile saving, Street Rep progression, level-up rewards every five levels, tickets and race energy (10 energy per race; one energy regenerates every six minutes).
- Ranked access gate at Street Rep level 10, plus tournament tickets.
- Responsive keyboard and touchscreen controls. Local two-player uses Player 1 WASD / arrows / touch and Player 2 IJKL + U / touch.
- Four tracks, 3 / 5 / 7 / 10 lap choices, random track + random game mode, time attack, police pursuit, ghost-run and infected modes.
- AI pacing adapts to the player's selected car and performance upgrades. Moving civilian traffic and rival cars can take damage; vehicle condition resets at zero.
- Police pursuit pressure, civilian traffic collision handling and collectible supply drops.
- Powerup inventory and pre-race selection: Nitro Surge, Quick Repair, Impact Shield and Traffic Scanner.
- A garage with 140 generated vehicle catalogue entries (20 each in D, C, B, A, S, Exotic and Secret ranks), rank unlock levels, performance upgrades, car levels, paint, spoilers, neon underglow and rims.
- Five story chapters with three required side stories each, selectable Crew / Solo story paths, and chapter gating until all side stories are completed.
- Daily and weekly contracts, Friday / Sunday tournament windows, local best times, local leaderboard and server leaderboard UI.
- Synthesized background music, settings toggles and a visible pause control.

## Controls

**Solo:** W / Up accelerates, S / Down brakes, A / Left and D / Right steer, Space uses nitro, Q activates the selected powerup, P or Escape pauses.

**Local 2-player:** Player 1 uses the solo controls. Player 2 uses I to accelerate, K to brake, J / L to steer, U for nitro. On mobile, use the two separate on-screen control clusters.

On mobile, select **Hold** or **Tap steering / Hold throttle** in Settings. (The buttons remain touch-enabled in both modes.)

## Supabase setup (accounts, cloud saves and server leaderboard)

1. Open your Supabase project and copy its **Project URL** and **public anon/publishable key**.
2. In `index.html`, replace `YOUR_SUPABASE_PROJECT_URL` and `YOUR_SUPABASE_ANON_KEY` with those two values. Do not use a `service_role` key in browser code.
3. In Supabase, open **SQL Editor**, paste the full contents of `supabase_setup.sql`, and run it.
4. In **Authentication → URL Configuration**, add your deployed game URL to the allowed redirect / site URL settings.
5. Redeploy the complete folder to GitHub Pages. Sign in from the title screen or Settings.

Supabase is not configured in this ZIP: the two values in `index.html` are placeholders. Guest profiles, local progression, local best times and offline gameplay do not require Supabase.

## Online multiplayer status

Private Realtime rooms use a six-character room code. Both players must use the same configured Supabase project, sign in, and enter the same code. The Realtime channel synchronizes opponent positions and includes the online opponent in the local finishing order. This is a starter implementation, not a production matchmaking/ranked service: automatic global matchmaking, authoritative race simulation, anti-cheat validation, reconnection handling and server-side ranked rating still need a trusted backend / Edge Function.

The server leaderboard is backed by `race_leaderboard`. The current browser client submits race results directly; before a public competitive release, validate results on a trusted server function rather than trusting client-submitted times or rewards.

## Deploy / update

Upload the **contents** of this folder to the repository's `main` branch (keep `index.html`, `manifest.webmanifest`, `sw.js`, icons and `supabase_setup.sql` together). Open the GitHub Pages URL on Android Chrome and choose **Install app** from the browser menu to install the PWA.

This project loads Three.js and Supabase JS from public CDNs, so the first load and account / online features need an internet connection. `online.js` is a legacy file from the original ZIP and is not loaded by the current game; the active multiplayer integration is in `index.html`.
