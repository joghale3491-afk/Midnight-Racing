MIDNIGHT RACING v40 — COMPETITIVE PROGRESSION UPDATE

WHAT'S NEW
- Ranked matchmaking is grouped by current rating band (250-point bands).
- Player profile page with rating tier, W/L record, race totals, podiums, online races, best drift score and garage count.
- Global ranked ladder ordered by rating, separate from best lap-time records.
- Twenty-one achievement badges for race milestones, wins, podiums, online racing, ranked progression, police escapes, drifting, checkpoints, story progress, garage collection, upgrades and Street Rep.
- Achievements save in the player profile; server-recorded race milestones also sync to mr_user_achievements.
- Ranked rating updates are calculated in a Supabase RPC. AI-only ranked matches do not change ELO.
- Race timer styling is more stable and centered; special-mode timer is clearer and placed below the top HUD on desktop and mobile.
- Direct client inserts to race_leaderboard are revoked; race results must use the validated server function.

INSTALL ORDER
1. Keep your existing Supabase project and player data.
2. In Supabase SQL Editor, create a NEW query and run:
   supabase_v40_competitive_progression.sql
   This migration must run after the v36 base setup and v37 private-room setup.
3. Do NOT rerun the v36 base SQL or v37 private-room SQL if they have already succeeded.
4. Open index.html and replace the two Supabase placeholders:
   SUPABASE_URL = your project URL
   SUPABASE_ANON_KEY = your public publishable/anon key
   Never put a Secret/service-role key in the browser game.
5. Upload ALL files inside this folder to the root of the existing GitHub repository, replacing previous versions, and commit to main.
6. Refresh the published game with Ctrl+Shift+R. If an older build remains cached, unregister the service worker and clear Cache Storage only; do not clear Local Storage if it contains local progress.

DATABASE NOTES
- v40 adds mr_player_stats, mr_user_achievements and mr_ranked_match_results.
- It adds mr_ensure_player_stats, mr_set_player_username and mr_submit_race_result RPC functions.
- Existing auth users, player_saves, player_profiles and race_leaderboard rows are preserved.
- The game now submits results through mr_submit_race_result. If the v40 SQL migration has not been run, online/global result submission and rating updates will fail until it is applied.

ANTI-CHEAT LIMITATION
The migration blocks direct client inserts to race_leaderboard and validates signed-in user identity, result mode, placement, duration and reward bounds. It also prevents the same ranked user/match pair from being submitted twice. This is a useful baseline, not a cheat-proof system: the game simulation still runs in the player's browser, so a determined modified client could forge plausible race data. Full anti-cheat requires authoritative server-side race simulation or a trusted game server.

TESTING
- Sign in and open Player Profile. A new account starts at 1000 Bronze rating.
- Open Ranked Multiplayer; only players in the same 250-point rating band are grouped. If no human opponents join and the game fills with AI, the match is recorded but does not change ELO.
- Complete a ranked match against at least one other human. Check rating and W/L stats.
- Open Rankings and check the Global Ranked Ladder.
- Open Achievements and check progress/unlocks.
- Try Checkpoint, Police Pursuit or other timed modes and verify the centered timer stays clear of the top HUD on desktop and mobile.

SUPABASE KEYS
Only the Project URL and public Publishable/anon key belong in index.html. Never expose the database password, service-role key or Supabase Secret key.
