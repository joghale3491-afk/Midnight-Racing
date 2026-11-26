MIDNIGHT RACING v39.5 — POWER-UP VISUAL FX UPGRADE

BASE
- Built directly on v39.4 Adaptive AI & Challenge Overhaul.
- Preserves Y8 SDK App ID/login integration, Supabase URL and public key, guest play, multiplayer, shop designs, track visuals, Time Attack fix, adaptive AI and quest updates.
- No database or SQL changes are required.

POWER-UP VISUALS
- Boost: layered exhaust flames and cyan afterglow.
- Overdrive: longer gold-orange exhaust plumes and a rotating gold halo.
- Shield: translucent energy bubble, faceted wireframe shell and orbit ring.
- Repair: floating medical cross, green repair motes and a healing ring. A short visible repair effect is now triggered when the power-up is used.
- Traffic Scanner: rotating radar sweep and gold scan ring, alongside the existing traffic highlighting.
- Grip Compound: four animated wheel-contact rings and sparks.
- Slipstream Pulse: twin cyan expanding shockwave rings.
- Signal Jammer: a separate magenta interference cage rather than reusing the pulse effect.
- All power-up activations receive a brief expanding color-coded ripple. The shared effect system also updates AI rival visuals.

UI
- Power-up cards, race slots and activity-feed icons now use individual colors and icons for faster recognition.

CACHE
- Service-worker cache version updated to ensure browsers fetch the new assets and scripts.

VALIDATION
- Main JavaScript module syntax checked with Node.js.
- All 8 power-up visual paths and Player 1, Player 2 and AI update paths inspected.
- ZIP integrity verified.
- Live browser rendering and driving tests are still required; do not treat static checks as a live gameplay test.

INSTALL
1. Extract the ZIP.
2. Upload every item inside the extracted folder to the root of the Midnight Racing GitHub repository, replacing old files.
3. Commit to main.
4. Open the game and hard-refresh using Ctrl+Shift+R.
5. Test all eight power-ups in a race, including AI use and local Player 2 if applicable.
