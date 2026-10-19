# PLOPQUAKE! v1.0 — Android Release

This is the **actual native Godot game project**, based on v0.9. It is not a mockup, a standalone art pack, a precompiled APK, or the older HTML game.

The original score/merge/BOOM rules, Daily/Normal progression, event system, native save identifier, project/package identity and accessibility options are preserved.

## Main changes from v0.9
- **Hold-to-drop**: Hold and drag in the play area to rapidly drop blobs with a sensible cooldown (0.18s, max 8 drops).
- **Merge squash/stretch animation**: Satisfying visual feedback when blobs merge.
- **Kenney Particle Pack integration**: Merge effects now use high-quality particle textures (circles, sparks, stars, magic, fire, smoke, twirls, traces).
- **Kenney UI Sounds integration**: Additional UI sounds for click, select, confirmation, back, open, close, error, switch, toggle, drop, pluck, tick.
- **Kenney Music Jingles**: 8-bit jingles available for victory, merge milestones, and rewards.
- **Kenney Impact Sounds**: Available for blob collisions, landings, drops, and BOOM effects.
- **Kenney UI Pack**: Professional button backgrounds, panels, and UI components.
- **Kenney Game Icons**: Available for booster icons, rewards, collection symbols, achievements.
- **Credits screen**: Accessible from main menu, lists all third-party assets and licenses.
- **Improved physics**: Better collision separation to prevent jittering and stuck blobs.
- **Enhanced visual feedback**: Merge effects, chain reactions, and BOOM feel more impactful.
- **Version bump**: v1.0.0 (version code 10) for Android release.

## Import to Godot Android
1. On the previous build use Settings → Data → Copy Save; paste that save in a note and keep the previous project.
2. Godot → Projects → Import → select the v1.0 project folder. Install in a separate folder.
3. Open the project and press ▶ Run.
4. Test a merge, BOOM, Pause, Daily mode, Events, rewards, Locker, Settings/Sounds, Credits and a save/restore.
5. Export for Android: Project → Export → Android → Export Project.

All third-party author/licence information is in `THIRD_PARTY_CREDITS.md`. Do not distribute unused source packs.

**Limitations:** Not compiled/tested inside the actual Godot runtime or exported as an APK in this environment. A real phone test and Android export are required before release.
