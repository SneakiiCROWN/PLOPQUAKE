# PLOPQUAKE! — Real asset integration map (v0.6)

This project uses sprites from the player's approved visual reference artwork. These assets are **not** whole screenshots pretending to be gameplay.

- `art/integrated/neon_logo.png` → `_header()` and `_draw_game()`.
- `art/integrated/blobs/00_pip.png` through `08_absurd.png` → `_draw_portrait()` for the first nine evolution tiers.
- Level ten remains in `art/blobs/09_mythic.png`, preserving its full reveal and collision tier.
- `art/integrated/accessories/` → `_draw_accessory()` for purchased Crown Spark, Pumpkin Pop, Candy Pop, Prism Pop and Inkstorm looks.
- `art/integrated/ui/card_*.png` → `_art_card()` Home navigation with real button events; no static button overlay.
- `art/integrated/factory_frame.png` → `_draw_game()` arena edge during October if Seasonal Decorations are enabled and Battery Saver is off.
- `art/integrated/blobs/season_*.png` → `_draw_events()` seasonal portraits.
- `art/integrated/ui/boom_burst.png` → the actual ready-to-use BOOM action.
- Other atlas crops in `art/integrated/ui/` are available to extend the native UI later; they are not currently bound as independent gameplay controls.

Only gameplay code controls scores, tickets, purchases, drops, collision physics, saves and daily dates. No figures printed on concept screenshots are used for those values.

## Performance

The images load once in `_ready()`, and are reused as cached Texture2D objects. Battery Saver disables the optional factory frame and complex shockwaves. The game preserves existing low-motion and color contrast settings.

## Commercial release

No trademark clearance or native APK runtime certification has been completed. This is a visual integration playtest, not a Play Store publication build.
