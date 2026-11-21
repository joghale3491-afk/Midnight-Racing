MIDNIGHT RACING v39 — EASIER LOBBIES & READY CHECK
=================================================

INSTALL
1. Extract this ZIP.
2. Open index.html and put your Supabase Project URL and Publishable key in the existing SUPABASE_URL and SUPABASE_ANON_KEY settings. Do not use a Secret/service_role key.
3. Upload every file and folder in this ZIP to the root of your existing GitHub Pages repository, replacing the previous version.
4. Commit to main and refresh with Ctrl+Shift+R. If the older layout is cached, unregister the service worker and clear Cache Storage only (do not clear Local Storage).

LOBBY CHANGES
- Clear Quick Match, Open Public Lobby, Create Private Room, and Join a Friend sections.
- Press Enter in the invite-code field to join.
- Private-room hosts can copy an invite link. Opening it pre-fills the room code and opens the Multiplayer tab.
- Private, public, Casual Quick Match, Ranked, and Tournament lobbies now have a Ready for Race toggle.
- The host gets a Start Race button only after all connected human players are ready.
- The matchmaking overlay contains the Ready/Start buttons so controls are usable while the overlay is open.
- Player names and readiness labels remain visible in the lobby roster.
- Public Casual is one shared open lobby in this build; private rooms are joined by invite link or code.

SUPABASE
- No new SQL is required. Keep the existing v37 private-room SQL functions and security policies installed.
- Existing Supabase URL/key placeholders remain in the source package by design; insert your project's URL and Publishable key in index.html.
- Private room creation, join, ready state, start and leave continue to use the v37 SQL RPCs. Public/queue readiness uses Realtime Presence and requires no additional table.

TEST
1. Open two separate browsers/devices and sign in with two different accounts.
2. Create a private room on Player 1 and copy the invite link.
3. Open the link on Player 2, confirm it fills the code, then press JOIN ROOM.
4. Both players should appear by username. Each presses READY FOR RACE.
5. The host's START RACE button should enable only when both players are ready.
6. Repeat using Join Public Lobby or Casual Quick Match.

LIMITATION
This package can be syntax-checked locally, but live cross-device Realtime behaviour still requires testing against your Supabase project.
