MIDNIGHT RUN — ONLINE RACING UPDATE

INSTALL
1. Download and extract this ZIP.
2. Open your GitHub repository: midnight-run.
3. Replace the existing index.html in the repository root with this index.html.
4. Keep all your other files and folders.
5. Commit directly to main and wait for GitHub Pages to publish.
6. Hard refresh the game with Ctrl + Shift + R.

TEST
1. Open the game in two separate browsers or one normal and one incognito window.
2. Sign in with two different accounts.
3. Create a private room in one window and join using its six-character code in the other.
4. Both drivers press I'M READY. One driver starts the online race.
5. Test driving close together, collecting the same pickups, using nitro, and finishing at different times.

WHAT'S NEW
- Remote opponent car is created and shown during the online race.
- Live position, speed, lap, nitro, damage, shield, turbo, and nitro-boost state are broadcast.
- Opponent pickup claims are shared so the same pickup is not collected twice.
- Close player-to-player contact applies a collision effect to both drivers.
- Finish messages include the opponent's finish time and lap. The results screen waits visibly for the other driver and updates when they finish.

IMPORTANT LIMITATIONS
This remains an early two-player online prototype using Supabase Realtime broadcasts. It is not server-authoritative. Network delay can affect collision timing and position accuracy. AI, traffic, weather, and some local race effects are still simulated independently on each device. A dedicated authoritative game server is needed for reliable competitive multiplayer and cheat resistance. The collision and pickup synchronization is best-effort, not a guarantee of identical physics on both devices.
