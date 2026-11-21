MIDNIGHT RACING v40.2 SERVICE-WORKER REPAIR

This is a small repair for an installation/caching problem. It deliberately does NOT include index.html so your Supabase URL and Publishable key are not overwritten.

UPLOAD THESE ITEMS TO THE ROOT OF YOUR EXISTING GITHUB REPOSITORY:
- sw.js (replace the existing root sw.js)
- audio/ (upload the folder with both MP3 files)

The service worker now caches assets independently. A missing optional audio file will not abort installation of the game service worker. The cache name is updated so browsers can replace the previous v40 worker.

After committing:
1. Open the GitHub Pages game.
2. Press F12 > Application > Service Workers > Unregister.
3. Under Cache Storage, delete only caches whose names start with midnight-racing-.
4. Reload the page with Ctrl+Shift+R.

Do NOT delete Local Storage. Do NOT replace index.html for this repair. Do NOT rerun Supabase SQL.
