MIDNIGHT RACING v39.8 — 3D VEHICLE SHOWROOM & WEBGL CONTEXT FIX
================================================================

BASE
- Built from the v39.7 Checkpoint, Mobile Controls & HUD package.
- Preserves Y8 SDK sign-in, Supabase configuration, existing profile data,
  multiplayer, checkpoint tuning, mobile controls, quests, AI, tracks and power-ups.
- No Supabase schema changes or SQL migration are required.

GARAGE & VEHICLE DESIGNS
- Garage inspection now builds the preview from the exact selected catalogue model ID.
- Twenty model-specific body profiles change the 3D top-view body silhouette,
  width, wheelbase and cabin/roof outlines; this is not just paint or trim variation.
- Additional 3D bodywork differentiates mid-engine supercars, rally buggies,
  luxury saloons, tuner coupes, endurance prototypes, fastbacks, sport wagons,
  performance utes, track specials, executive GTs, widebody racers and concept cars.
- The Garage preview includes the selected car's own per-car attachments.

STORE DEALERSHIP
- Replaced flat SVG dealership thumbnails with a live 3D vehicle inspection stage.
- Select INSPECT 3D on a catalogue row to load that exact car into the showroom.
- The selected model rotates automatically; drag the canvas to inspect its sides.
- The same preview canvas/renderer is moved between Garage and Store. The game
  does not create a separate WebGL renderer for every catalogue card.

WEBGL / GRAPHICS
- The previous WebGL support check created and immediately lost a temporary
  WebGL2 context before creating the main Three.js renderer. The game now checks
  and reuses the context on its actual game canvas, avoiding an unnecessary
  extra WebGL context allocation.
- The Garage/Store preview renderer now initializes lazily when the player opens
  one of those panels, and one auxiliary renderer is shared between both panels.
- The preview renderer uses a low-power context and reduced pixel ratio to lower
  GPU pressure on mobile devices.
- A browser/device that genuinely lacks WebGL 2 still needs hardware acceleration
  enabled or a WebGL 2-compatible browser; Three.js r160 requires WebGL 2.

INSTALL
1. Extract this ZIP.
2. Upload every file and folder inside to the root of the existing Midnight Racing
   GitHub repository, replacing the older files.
3. Commit to main.
4. Open the published game and hard-refresh (Ctrl+Shift+R on desktop).
5. Open Garage and switch between several owned cars. Then open Store, choose a
   rank, and press INSPECT 3D on several models. Drag the showroom to rotate them.

CHECKS
- JavaScript module syntax, service-worker syntax, HTML IDs, required preview nodes,
  local file references, and ZIP integrity were checked.
- Static validation is not a live browser/WebGL or gameplay test. Verify the 3D
  previews and start a race on the target desktop/mobile devices before Y8 submission.
