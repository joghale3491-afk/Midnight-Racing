MIDNIGHT RUN - MULTIPLAYER LOBBY UPDATE

This update adds the first online multiplayer stage:
- Public lobby using Supabase Realtime Presence
- Private rooms with six-character codes
- Driver presence and ready status

IMPORTANT:
This is the lobby stage only. It does NOT yet synchronize cars or run a live online race.
The next stage will add race-state synchronization after the lobby is tested.

INSTALL:
1. Back up your current index.html.
2. Replace only index.html in your GitHub Pages repository with this file.
3. Commit directly to main and wait for Pages to publish.
4. Hard refresh the live game (Ctrl+Shift+R).
5. Sign in, open MULTIPLAYER, and test public lobby or private room.

SUPABASE:
This uses Supabase Realtime channels and Presence with your existing project URL and publishable key.
No additional SQL table is needed for this lobby stage. In Supabase Dashboard, ensure Realtime is available/enabled for the project.
Never expose a service_role or secret key in the browser.
