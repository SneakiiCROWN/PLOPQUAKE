# PLOPQUAKE! — Real asset integration map (v1.0)

This project uses sprites from the player's approved visual reference artwork. These assets are **not** whole screenshots pretending to be gameplay.

## Original PLOPQUAKE Assets
- `art/integrated/neon_logo.png` → `_header()` and `_draw_game()`.
- `art/integrated/blobs/00_pip.png` through `08_absurd.png` → `_draw_portrait()` for the first nine evolution tiers.
- Level ten remains in `art/blobs/09_mythic.png`, preserving its full reveal and collision tier.
- `art/integrated/accessories/` → `_draw_accessory()` for purchased Crown Spark, Pumpkin Pop, Candy Pop, Prism Pop and Inkstorm looks.
- `art/integrated/ui/card_*.png` → `_art_card()` Home navigation with real button events; no static button overlay.
- `art/integrated/factory_frame.png` → `_draw_game()` arena edge during October if Seasonal Decorations are enabled and Battery Saver is off.
- `art/integrated/blobs/season_*.png` → `_draw_events()` seasonal portraits.
- `art/integrated/ui/boom_burst.png` → the actual ready-to-use BOOM action.
- `art/integrated/ui/industrial_panel.png` → Nine-patch button chrome for non-green controls.
- `art/third_party/wenrexa_green_action.png` / `_pressed.png` → Green action button nine-patch (Wenrexa CC0).
- `art/production/blobs/` → Upgraded blob portraits (preferred over `art/blobs/`).
- `art/production/frame/` → Factory rail textures (top, left, right, floor).

## Kenney Assets (v1.0 Addition)
- `art/kenney_particles/` → Particle textures for merge effects, explosions, bursts (circle, spark, star, magic, fire, smoke, twirl, trace).
- `audio/kenney_ui/` → Interface sounds (click, select, confirmation, back, open, close, error, switch, toggle, drop, pluck, tick).
- `audio/kenney_music/` → 8-bit music jingles for victories, milestones, rewards.
- `audio/kenney_impact/` → Impact sounds for collisions, landings, drops, BOOM.
- `art/kenney_ui/` → UI pack textures (buttons, panels, sliders, checkboxes, icons).
- `art/kenney_pixel_ui/` → Pixel UI pack for alternative styling.
- `art/kenney_game_icons/` → Game icons for boosters, rewards, achievements.

## Slime Pack (v1.0 Addition)
- `art/slime/` → CC0 slime sprites by Rick Hoppmann for reference/animation ideas.

Only gameplay code controls scores, tickets, purchases, drops, collision physics, saves and daily dates. No figures printed on concept screenshots are used for those values.

## Performance

The images load once in `_ready()`, and are reused as cached Texture2D objects. Battery Saver disables the optional factory frame, complex shockwaves, and reduces particle counts. The game preserves existing low-motion and color contrast settings. Kenney particle textures are loaded at startup; fallback procedural particles generated if missing.

## Commercial release

No trademark clearance or native APK runtime certification has been completed. This is a visual integration playtest, not a Play Store publication build.
