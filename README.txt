MIDNIGHT RUN — SUPABASE ACCOUNTS + CLOUD SAVE

This update adds email registration, sign-in, sign-out, and cloud saving/loading.
It uses the Supabase project URL and publishable key configured by the project owner.

Database requirements:
- public.game_saves with user_id (uuid primary key referencing auth.users), progress (jsonb), updated_at (timestamptz)
- Row Level Security enabled on game_saves
- Authenticated SELECT/INSERT/UPDATE policies restricting user_id to auth.uid()

The profiles table from the previous setup is not required by this first integration.
The game continues to save locally when signed out. Cloud saves sync after changes when signed in.

Install:
1. Extract this ZIP.
2. Replace the index.html in the root of your existing GitHub repository.
3. Keep all other repository files.
4. Commit directly to main and wait for GitHub Pages to publish.
5. Hard refresh the game.

Supabase auth:
- Email provider must be enabled.
- If email confirmation is enabled, verify the email before signing in.
- Never put a Supabase secret/service-role key in this file. Only a publishable key belongs in browser code.
