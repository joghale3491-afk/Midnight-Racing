MIDNIGHT RACING v39.6 — GRAND PRIX STREET CIRCUITS & DRIVER CONTROLS

BASE BUILD
- Built from the v39.5 Y8 power-up visual effects package.
- Preserves the Y8 App ID and SDK initialization.
- Preserves the configured Supabase project URL and public publishable key.
- Preserves the existing shop/car designs, adaptive AI, quest changes, power-up effects,
  Time Attack fix, multiplayer code, and service-worker/offline assets.
- No Supabase SQL or database changes are required.

TRACKS
- Non-drift circuits use longer, original street-GP layouts, targeting approximately
  2.2–2.8 km per lap based on their scaled route control points. Actual spline distance
  can vary slightly with smoothing and corner shaping.
- Each non-drift circuit has six theme-specific Grand Prix corner signatures, selected
  from hairpins, chicanes, esses, kinks, double-apex turns, varying-radius turns, and
  banked corners.
- Coastal and harbour shorelines are positioned relative to each generated track's
  bounds so water and dock meshes stay outside the road on the longer layouts.
- Desert and alpine hills are placed beyond the road edge rather than randomly on the
  driving surface. Horizon lights were moved farther outside the larger circuits.
- These are original layouts inspired by street-circuit and Grand Prix corner types;
  they are not exact copies of real Formula One circuits.
- Drift Arena remains a shorter dedicated drift course.

DRIVING
- Player 1 is directly controlled in world space. The track no longer turns the car
  automatically around corners; track projection is used for lap/progress bookkeeping.
- Player 1: W/Up accelerate, S/Down brake, A/D or Left/Right steer, Space nitro,
  C or Left/Right Shift drift, Q use selected power-up, E switch power-up.
- Player 2: IJKL drive, U nitro, B or Numpad 0 drift, O power-up, Y switch slot.
- Touch controls: steer left/right, GAS, BRAKE, N2, POWER and SWAP. There is no
  separate drift button. Hold BRAKE while steering to initiate a drift.
- Touchscreen controls have larger targets and a compact two-player layout.

CHECKS PERFORMED
- JavaScript module syntax check passed (Node.js --check).
- Service-worker syntax check passed.
- HTML parsed with 244 unique IDs and no duplicate IDs.
- CSS top-level parsing reported no errors.
- All 31 track definitions passed the static track-definition audit.
- All 30 non-drift circuits have six corner templates; Drift Arena remains compact.
- ZIP integrity checked after packaging.

TESTING NOTE
- These are static code and package checks. Real browser driving, mobile touch handling,
  live multiplayer, Y8 login, and Supabase sign-in still require in-game testing.
