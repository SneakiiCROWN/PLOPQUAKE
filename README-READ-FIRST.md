# PLOPQUAKE! v0.9 — Curated Godot UI Integration

This is the **actual native Godot game project**, based on v0.8. It is not a mockup, a standalone art pack, a precompiled APK, or the older HTML game.

The original score/merge/BOOM rules, Daily/Normal progression, event system, native save identifier, project/package identity and accessibility options are preserved.

## Main changes
- Six soft, user-supplied UI sounds added from Nathan Gibson's CC BY 4.0 pack. Menu navigation, errors, buttons and confirmation cues invoke them.
- Wenrexa's CC0 green panels style real green action buttons, with separate press-state image.
- Existing neon factory panel art now uses 9-slice rendering on other large buttons, so graphics scale without stretched corners.
- Touch-release feedback rings; locked rewards explain why they're not yet available.
- Startup only loads the final illustrated blob images, falling back to old images only if necessary.
- Idle menus redraw at 30 FPS (or 15 FPS with battery saver) for mobile battery/performance.
- Android `package/unique_name` and `user://plopquake_native_v1.json` unchanged.

## Import to Godot Android
1. On the previous build use Settings → Data → Copy Save; paste that save in a note and keep the previous project.
2. Godot → Projects → Import → select the v0.9 ZIP in Downloads. Install in a separate folder.
3. Open the project and press ▶ Run.
4. Test a merge, BOOM, Pause, Daily mode, Events, rewards, Locker, Settings/Sounds and a save/restore.

All third-party author/licence information is in `THIRD_PARTY_CREDITS.md`. Do not distribute unused source packs.

**Limitations:** Not compiled/tested inside the actual Godot runtime or exported as an APK in this environment. A real phone test and Android export are required before release.
