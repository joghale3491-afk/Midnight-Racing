MIDNIGHT RACING - UPDATE NOTES

- Story and Ranked now have their own side-navigation destinations. The Race Hub stays focused on normal race setup.
- Multiplayer contains Casual Quick Match and Private Lobbies. Ranked has its own page and online-only queue.
- Ranked requires Street Rep level 10, a separate Ranked Ticket, at least 10 energy, a signed-in account and another player queued for Ranked.
- Username is the public racer handle, not the account email.
- Added original synthesized EDM / techno beat, rotating special events, clear story mission objectives and story completion checks.
- Police chases use active patrol intercepts, with no respawns during the chase.
- Energy maximum is 50; a race costs 10 energy.
- Car previews and player race cars use the same 3D model builder.

SETUP
1. Replace the Supabase URL and public anon key placeholders in index.html.
2. Run supabase_setup.sql in the Supabase SQL Editor.
3. Make sure Supabase Realtime is available.
4. Upload all folder contents to the GitHub repository and wait for Pages to redeploy.

NOTE: Online queues and synchronized race positions use Supabase Realtime presence / broadcast. This is a playable prototype, not a production anti-cheat or server-authoritative ranked system. Server-side race result validation and rating updates are still needed before public competitive launch.
