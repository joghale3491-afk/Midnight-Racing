MIDNIGHT RUN — ONLINE RACING UPDATE

WHAT THIS UPDATE ADDS
- Adds a START ONLINE RACE button to the private room panel.
- Requires exactly two signed-in drivers in the same room.
- Both drivers must press I'M READY before the race can start.
- One driver starts a shared countdown and sends the selected track to the other player.
- Each game creates a remote opponent car.
- Player distance, lane position and speed are broadcast over Supabase Realtime.
- Remote car movement is smoothed between received updates.
- The remote driver is included in the local position display and finish ranking.
- Sends a finish notification to the other driver.

IMPORTANT LIMITATIONS
- This is an early two-player online racing prototype.
- It uses client-to-client Supabase Realtime broadcasts; it is not server-authoritative.
- Both players still simulate their own AI rivals, traffic, weather and pickups locally.
- Remote collisions, pickup effects, damage, nitro, and exact finish adjudication are not synchronized.
- A dedicated authoritative game server would be needed for production-grade competitive multiplayer.
- Keep the existing Supabase URL, publishable key, game_saves table and RLS setup unchanged.

INSTALL
1. Extract this ZIP.
2. Replace the existing index.html in the root of your GitHub repository with this index.html.
3. Keep the rest of your repository files.
4. Commit directly to main and wait for GitHub Pages to deploy.
5. Open the game and hard-refresh with Ctrl + Shift + R.

TEST
1. Open the game in two separate browsers.
2. Sign in with two different accounts.
3. In the first browser, create a private room.
4. In the second browser, join using the six-character room code.
5. Both players press I'M READY.
6. One player clicks START ONLINE RACE.
7. Both should see the same selected track and countdown, then see the other player's car.

If anything fails, send a screenshot of both game windows and the multiplayer status text.
