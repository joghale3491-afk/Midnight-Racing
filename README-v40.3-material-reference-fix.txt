MIDNIGHT RACING v40.3 — POWER-UP MATERIAL REFERENCE FIX

Root cause: the Traffic Scanner effect animated visual.scannerRing.material, but the
scannerRing mesh was not included in car.userData.powerupVisuals. Activating Scanner
therefore caused an undefined.material exception and the race update loop paused.

Fix: register scannerRing in the per-car visual-effects registry. Also make the
brake-light, police-light, pickup-beacon, checkpoint, fog-sheet, jammer, scanner,
and grip-effect material accesses defensive against missing/removed meshes.

Y8 and Supabase configuration are unchanged. No database changes are required.
Static validation completed; a live in-browser race test is still required.
