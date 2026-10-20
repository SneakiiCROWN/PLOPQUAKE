# PLOPQUAKE!

Drop blobs, merge matching ones and work your way up to a big BOOM. A colourful portrait-mode game made for Android.

**Current version: Android friend-test APK.** You can install it without Godot, but this exact build still needs real-phone gameplay testing.

## Download and play

1. On your **Android phone**, [download the test APK](https://github.com/SneakiiCROWN/PLOPQUAKE/releases/download/plopquake-test-3/PLOPQUAKE-Android-Friend-Test.apk).
2. Open the downloaded file from your browser or Downloads app.
3. Tap **Install**. Android may ask you to allow installs from that particular app; only do this if you trust this download.
4. Open **PLOPQUAKE!** and play.

No PC, Godot or coding tools are needed for the APK. **Code → Download ZIP** is source code, not the game.

This is installed as a **separate friend-test app**, so it should not replace your main PLOPQUAKE installation or saves. Test APKs use temporary signing keys: future test updates might require uninstalling the earlier test version, which deletes that test version's local saves.

## How to play

- Tap or hold in the play area to drop blobs.
- Merge matching blobs into bigger ones.
- Build combos and trigger BOOMs.
- Check out Normal/Daily modes, the collection and settings.

## What's working, and what's still being tested?

- **Built successfully:** the Godot project imported and an installable Android APK was exported.
- **Implemented in the project:** blob-dropping, merging, BOOMs, progression modes, saves and menus.
- **Still needs phone testing:** controls, physics, music/sounds, save/restore, performance and how it looks on different screens.

An exported APK is **not** proof that every gameplay feature works on every phone. Please tell me if you find a bug.

## What's coming next?

More blob and progression variety, power-up ideas, extra rewards and continued visual/audio polish. The longer plan is in [development notes](DEVELOPMENT_SUMMARY.md). Third-party credits are in [THIRD_PARTY_CREDITS.md](THIRD_PARTY_CREDITS.md).

## Found a bug?

[Report it here](https://github.com/SneakiiCROWN/PLOPQUAKE/issues). Include your phone model, Android version and what happened.

## For developers only

Install **Godot 4.7.x**, download the repository source, import the folder containing `project.godot` and press **Run**. Android exports need the appropriate Godot export templates and Android SDK. More detail: [README-READ-FIRST.md](README-READ-FIRST.md).
