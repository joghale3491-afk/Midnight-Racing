MIDNIGHT RACING v39.4 — AI PACE, RACE POWERUP LOG & HARDER QUESTS

BASE
- Built directly on v39.3 Individual Car Shop Designs.
- Keeps Y8 SDK App ID/login integration and Supabase configuration.
- Keeps guest mode, existing Supabase accounts, existing multiplayer setup, prior Time Attack fix, shop vehicle visual designs, track visual changes, and mobile HUD.
- No Supabase table changes or SQL migration are required.

WHAT CHANGED
AI PACE
- Each AI racer samples the live speed of the nearest active human driver (Player 1 or local Player 2).
- AI pace targets follow the player's speed with smoothing to avoid sudden rubber-band acceleration or braking.
- Vehicle top-speed limits and small per-rival skill differences remain in place.
- AI retains its last observed player pace after all human drivers are eliminated or finish, so remaining race logic does not suddenly slow down.

RACE POWERUP LOG
- Added a compact in-race activity panel that records the latest four Player 1 / Player 2 power-up events.
- Power-up pickups are marked ACQUIRED; activations are marked USED.
- The panel resets at the beginning of each race and uses text-only DOM updates for safe display.

QUEST DIFFICULTY
- Raised the requirements and rewards for the three Quest Board challenges.
- Increased multi-stage Street Credentials, Online Rival and Pursuit Specialist goals.
- Increased daily and weekly contract targets while preserving Street Rep rank scaling and corresponding reward scaling.
- Existing quest progress is retained; no player profile wipe is performed.

CACHE
- Service-worker cache version has been updated to make browsers fetch v39.4 files.

VALIDATION
- Main JavaScript module syntax checked with Node.js.
- Key AI, feed, quest, Supabase and Y8 configuration blocks inspected.
- ZIP integrity checked after packaging.
- No live browser race or Y8 portal test is claimed; test AI speed response, local 2-player feed and quest progress after upload.

INSTALL
1. Extract the ZIP.
2. Upload all files and folders inside the extracted folder to the root of the Midnight-Racing GitHub repository, replacing the old files.
3. Commit the changes to main.
4. Open the game and hard-refresh using Ctrl+Shift+R.
5. Test a race by changing speed repeatedly; AI pacing should follow smoothly. Collect and activate powerups; check the Race Powerup Log. Review the Quest Board, Daily Contracts and Weekly Challenges.
