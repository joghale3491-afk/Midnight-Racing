MIDNIGHT RACING v37 — PRIVATE ROOM MATCHMAKING UPDATE

WHAT CHANGED
- Private lobbies now use database-backed room creation and joining.
- Invite codes are 8 characters, generated from an alphabet that avoids confusing characters (O, I, 0, 1).
- Joining a room checks that the room exists, is still open, and has a free slot.
- The lobby is capped at six signed-in drivers.
- Every driver must be ready before the host can start.
- The start action is verified by a server-side RPC, not just by the local UI.
- Private lobby traffic uses Supabase private Realtime channels and membership-based Realtime RLS policies.
- If the host leaves, the earliest remaining member becomes host.
- Rooms expire after three hours and are removed when the last member leaves.
- A Copy Room Code button is available to the host.

IMPORTANT SETUP
1. Keep your existing v36 Supabase project and existing database tables.
2. In Supabase Dashboard > SQL Editor > New Query, run supabase_private_rooms_v37.sql once.
3. Open index.html and paste your current Supabase Project URL and Publishable key into SUPABASE_URL and SUPABASE_ANON_KEY. These values are intentionally left as placeholders in this package.
4. Upload the complete contents of this folder to the root of your existing GitHub Pages repository, replacing the old files.
5. Commit to main, then refresh the site with Ctrl+Shift+R. If an old service worker caches the prior version, unregister it and clear only Cache Storage (do not clear Local Storage).

PRIVATE CHANNEL SECURITY
The private-race:<CODE> Realtime channel checks membership in mr_private_lobby_members. Players must successfully create or join the room through the supplied RPC functions before they can subscribe. Do not expose a Supabase Secret/service_role key in index.html.

TEST
- Use two DIFFERENT signed-in accounts in separate browsers/devices.
- On player 1: Multiplayer > Private Lobby > Create Private Lobby. Copy the 8-character code.
- On player 2: enter the code > Join Room.
- Confirm both names appear in the same lobby.
- Both players press I'M READY; the host presses START RACE.
- Try a wrong code, full room, and host leaving to verify the error handling / handoff.

NOTE
This update covers invite-only casual private rooms. Public quick match, ranked, tournament, cloud saves and existing account setup retain their existing v36 flows. Ranked-result integrity still needs server-side result validation before being considered competitive/cheat-resistant.
