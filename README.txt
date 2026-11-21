MIDNIGHT RACING v38 — MULTIPLAYER USERNAME ROSTERS
==================================================

UPDATE
1. Extract this ZIP.
2. Upload every item inside the Midnight-Racing-v38 folder to the root of your existing GitHub Pages repository, replacing the v37 files.
3. Keep index.html, sw.js, manifest.webmanifest, icon files, and the audio folder together.
4. Commit to main, then refresh the published game with Ctrl+Shift+R.
5. If the old menu remains cached, unregister the site's service worker and clear Cache Storage only. Do not clear Local Storage.

SUPABASE
- Keep using the Supabase project already connected to v37.
- This is a client-side Realtime Presence/UI update; no new SQL is required.
- Keep the existing v37 private-room SQL functions and RLS policies installed.
- Make sure index.html contains your current Project URL and Publishable key. This source package intentionally leaves those values as placeholders. Never put a Supabase Secret/service_role key in the game.

V38 CHANGES
- Private rooms list each joined driver's in-game username, with HOST / READY / WAITING and YOU labels.
- Public lobbies list the usernames of joined drivers.
- Casual, Ranked and Tournament matchmaking show the six-player group assigned to the current queue slot.
- The matched-room overlay continues to show the player names while the room connects.
- Roster names are inserted as text, not HTML. Duplicate Realtime presence entries for the same user ID are deduplicated.

TEST
1. Use two different signed-in accounts in separate browsers/devices.
2. Create a private room, join it from the second account, and confirm both names appear.
3. Test the public lobby and confirm the same.
4. Start Casual Quick Match on both accounts and confirm the queue shows the players' usernames.
5. Repeat with Ranked/Tournament when eligible.

LIMITATION
- Names are supplied through Supabase Realtime Presence. A username change appears after the player reconnects or updates their presence.
- This environment can validate code syntax and package integrity but cannot perform a live session against your Supabase project.
