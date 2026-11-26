MIDNIGHT RACING v39.2 — Y8 TRACK, VEHICLE & HUD OVERHAUL

Base:
- Preserves the working Y8 SDK sign-in integration and the existing Supabase configuration.
- Keeps guest play, existing Supabase accounts, online features and the Time Attack elimination fix.
- No Supabase schema or SQL migration is required for this update.

What changed:
- Coastal Run and harbor water are placed outside the road area instead of using a large water plane that can overlap the circuit.
- Traffic, player, AI, ghost and remote cars are positioned using a level road-aligned pose to prevent spline pitch/roll from flipping vehicles.
- All 31 route definitions passed the static route validation check.
- Player, AI and traffic models now use more distinct vehicle silhouettes and details across eight design families.
- Traffic changes lanes more smoothly, varies its speed on bends, reacts to nearby traffic and uses its brake lights when slowing.
- Player and AI cars get steering lean, braking pitch, suspension motion and animated wheels.
- AI nitro and power-up activations now have visible vehicle effects, including exhaust flames, shields, pulse rings, grip effects and repair pulses.
- Track scenery includes themed buildings, trees, rocks, roadside lighting, reflectors, shoreline details and improved asphalt texture.
- Power-up pickups have animated beacons, halos, hover motion and lighting.
- The mode timer is integrated into the race HUD; nitro status, notifications and toast messages have clearer feedback.
- When nitro empties, the driver must release the nitro control and let the tank recover to 10% before it can activate again. The same rule applies to local Player 2.

Validation performed:
- Main inline JavaScript passed Node.js syntax validation.
- Static route validator passed for 31 of 31 track definitions.
- ZIP integrity check passed after packaging.
- A live browser race session was not completed in this environment; test Coastal Run, other tracks, traffic and AI effects after upload.

GitHub Pages update:
1. Extract the ZIP.
2. Upload all files and folders inside the extracted folder to the root of the Midnight-Racing GitHub repository, replacing the old versions.
3. Commit the changes to main.
4. Open the game and hard-refresh with Ctrl+Shift+R.

Y8 submission:
- The ZIP contains index.html at the archive root for HTML5 packaging.
- Use the Y8 Developer Portal's game upload flow and follow its required metadata/media steps.
- Ads, Y8 cloud storage, achievements and Y8 leaderboards are not enabled by this visual update.
