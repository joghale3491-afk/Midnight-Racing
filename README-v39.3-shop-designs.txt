MIDNIGHT RACING v39.3 — INDIVIDUAL CAR SHOP DESIGNS

This update is based on the v39.2 Y8 Visual Overhaul build.

WHAT CHANGED
- Every dealership car has its own top-down artwork preview in the Vehicle Dealership.
- Previews vary by vehicle model: body width/length, roof/cabin shape, nose treatment, headlight signature, hood details, stripes and rear aero.
- The selected-car cards in the Garage show the same individual previews and a body-style label.
- The actual 3D vehicles use per-model silhouette proportions and model-specific trim signatures.
- AI and traffic low-detail models inherit their catalog vehicle's signature rather than using one generic shape.
- Service-worker cache name was bumped so browsers fetch the new shop and car-preview code.

PRESERVED
- Y8 SDK App ID and authentication integration.
- Supabase project settings and existing backend integration.
- Existing multiplayer, progression, vehicle stats, Time Attack fix, track and HUD features.
- No Supabase database or SQL changes are required.

TESTING
- JavaScript module syntax checked with Node.js.
- SVG preview generator rendered and visually inspected.
- Catalog visual IDs checked for uniqueness (140 vehicles).
- ZIP integrity checked after packaging.
- Full browser / live race behaviour has not been tested in this environment.
