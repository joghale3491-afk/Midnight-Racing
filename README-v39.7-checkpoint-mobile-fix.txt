MIDNIGHT RACING v39.7 — CHECKPOINT & MOBILE CONTROL FIX

Based on v39.6 Grand Prix Street Circuits.

CHECKPOINT RUN
- Fixed starting countdown: 10 seconds.
- Every checkpoint adds exactly 5 seconds.
- Four checkpoints are evenly placed at 20%, 40%, 60%, and 80% of the route distance.
- Both the visible gates and player crossing checks use the same distance calculation.
- The HUD timer scale reflects the maximum available time (30 seconds).
- In local two-player checkpoint races, one driver's timeout no longer ends the other driver's active run.

MOBILE CONTROLS
- Player 2 touch controls are hidden by default.
- They appear only after a real local two-player race has created Player 2.
- Starting solo, events, or online races clears stale local two-player touch state.
- Player 2 controls remain hidden in single-player races even if a previous selection left stale UI state.

CHECKS
- JavaScript syntax, HTML/ID checks, CSS balance, local asset references, and ZIP integrity were checked.
- These are static checks; a live browser and multiplayer driving test is still recommended.

TIMER HUD LAYOUT
- Timed-mode timer remains inside the race-info HUD, not as a floating overlay.
- On narrow screens it moves to a compact second row below position, lap, and race time.
- Speed readout gets a reserved column so it does not overlap player information.
- Compact portrait, narrow-phone, landscape, and local two-player layouts are covered.
- Timer label/value/progress stay aligned; the hint is hidden on narrow screens to save space.

SERVICE WORKER
- Cache name bumped to v39.7 so browsers request the updated game files instead of reusing the previous v39.6 cache.

CHECKPOINT TIMER DETAILS
- The timer bar starts full at 10 seconds and scales to the time currently earned, rather than appearing one-third full against a fixed 30-second scale.
- In local two-player checkpoint races, the HUD switches to Player 2's checkpoint countdown/progress after Player 1 finishes or is eliminated while Player 2 remains active.
- The next checkpoint marker highlight follows the active local driver in that handoff state.
