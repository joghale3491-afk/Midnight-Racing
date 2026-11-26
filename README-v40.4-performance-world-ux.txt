MIDNIGHT RACING v40.4 — PERFORMANCE, SCENERY & UX OVERHAUL

Built from the working v40.3 package. Y8 and Supabase settings are preserved.

NEW GRAPHICS SETTINGS
- Low: reduced pixel ratio, no dynamic shadows, reduced scenery/weather density, 30 FPS render cap.
- Medium: balanced 45 FPS render cap, normal scenery, reduced shadow map.
- High: higher render resolution, more scenery, full weather detail, dynamic shadows, 60 FPS render cap.
- The selected preset is saved locally. Scenery density is rebuilt on the next race.

PERFORMANCE WORK
- Track environment detail uses instanced meshes and quality-based density.
- Weather particle/fog counts and night-sky star counts adapt to quality.
- Traffic neighbor/lane scans and AI traffic-avoidance/pickup decisions are cached briefly; steering and movement remain frame-updated.
- Low/Medium modes cap rendering separately from simulation updates.
- AI/traffic car part shadow casting is disabled; player car shadows are retained on High.

WORLD AND CAR VISUALS
- Added instanced street lighting, neon roadside signs, planters and trees on urban/harbor routes.
- Added extra natural roadside shrubs/rocks on land routes.
- Increased or reduced environment density with quality preset; no new external copyrighted car or environment assets.
- Slightly richer clear-coat car paint finish.

UX
- Added a clear Graphics & Performance control in Settings.
- Added smoother menu panel transitions, button feedback, focus styles and reduced-motion support.

CHECKS
Static HTML/CSS/JavaScript syntax, package integrity, app-shell references and Y8/Supabase configuration were checked. Live WebGL frame-rate testing on the user's device is still required.
