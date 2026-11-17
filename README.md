# MIDNIGHT RUN — installable mobile app package

## Included
- Existing MIDNIGHT RUN game as `index.html`
- PWA manifest, service worker and app icons
- Account/cloud-save/realtime-room client starter (`online.js`)
- Supabase database/RLS setup (`supabase_setup.sql`)

## Install on Android
1. Deploy this folder to an HTTPS host (for example, a static hosting provider).
2. Open the deployed URL in Chrome on Android.
3. Use Chrome menu → **Install app** or **Add to Home screen**.
4. Launch from the new home-screen icon. Landscape mode is recommended.

A PWA is installable; it is not yet a signed Play Store APK.

## Configure accounts and cloud saves
1. Create a Supabase project.
2. In Supabase SQL Editor, run `supabase_setup.sql`.
3. In `online.js`, replace `YOUR_PROJECT` and `YOUR_SUPABASE_ANON_KEY` with the project's Project URL and anon/public key.
4. Add the deployed site URL to Supabase Auth → URL Configuration / redirect URLs.
5. Include Supabase JS v2 in `index.html` before `online.js`, then include `online.js` and call `MidnightRunOnline.init()`.

Only use the anon/public key in browser code. Never expose a service-role key. Supabase Auth handles passwords; this app does not store passwords itself.

## Multiplayer status
The package includes authenticated realtime room connection and a race-state broadcast API. To make actual synchronized racing, the game simulation must publish each player's position/rotation/speed at a fixed rate and interpolate remote racers on the receiving client. The current single-file game has not been refactored to authoritative network simulation, so online races are a backend integration starter, not a completed playable online multiplayer mode. Local split-screen remains whatever the existing game build supports.

## Security / production checklist
- Configure email verification and password reset in Supabase Auth.
- Add rate limits, abuse reporting, room membership authorization and private-channel policies.
- Validate race results server-side before awarding credits; never trust client-submitted currency or unlocks.
- For a public release, use a server-authoritative race service and test on real Android devices.
