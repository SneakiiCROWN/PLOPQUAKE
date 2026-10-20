# PLOPQUAKE

Drop colourful blobs, merge matching ones, build combos and trigger BOOMs in a portrait-mode puzzle game.

**Current prerelease: 1.0.6 test · Android code 16.**

## Download and play

1. [Download the Windows ZIP](https://github.com/SneakiiCROWN/PLOPQUAKE/releases/download/plopquake-v1.0.6-public-test-20261020/PLOPQUAKE-Windows-1.0.6-Test.zip).
2. Right-click it, choose **Extract All**, then open the extracted folder.
3. Double-click **PLOPQUAKE.exe** and keep its supporting files together.

On Android, [download the installable APK](https://github.com/SneakiiCROWN/PLOPQUAKE/releases/download/plopquake-v1.0.6-public-test-20261020/PLOPQUAKE-Android-1.0.6-Test.apk), open it from Downloads and choose **Install**. Android may ask permission for that browser or file manager to install trusted downloads.

No coding tools are needed. GitHub’s **Code → Download ZIP** contains source, not the playable program.

## What is in this version?

Normal and Daily modes, collection/progression, rewards, settings, local saves, audio feedback and crowded-pile limits are implemented in the current local source.

## Checked, and still unfinished

The gameplay regression harness passed, covering controls and menus, claims, saves, audio state and crowded piles. A new Windows export launched and exited cleanly with no runtime errors. The Android APK signature and package metadata were checked.

No phone or emulator was connected. Phone touch handling, physics, sound, saving and performance remain unverified on hardware. Windows gameplay needs wider human testing.

## Updating without losing progress

Extract each Windows version into a new folder and keep the old folder for rollback. Keep your existing settings and save folders; do not reset or delete app data to update.

This APK is the preserved local **com.sneakiicrown.plopquake.godottest**, code **16**, signed with the same certificate as the local 1.0.6 build. It can update an older compatible local installation. The earlier GitHub friend APK used **com.sneakiicrown.plopquake.friends** with a temporary key that is unavailable locally. Both apps can coexist; their saves are separate. **Keep the old friend app installed if it has progress you want to retain.** This release does not migrate that progress or replace its signing identity.

## What is next?

The current development notes call for further progression, visual/audio polish and device testing. New content ideas remain plans rather than delivered features.

## Requirements and credits

Windows x64 portable build, or Android 7+ arm64 APK. No editor or source build is needed. Third-party art and audio credits and licences are in THIRD_PARTY_CREDITS.md; Godot notices accompany the Windows package.

Original project material is source-available with the permissions in LICENSE.txt; public availability is not a blanket open-source or asset-reuse licence. Third-party licence rights remain intact.

## Found a bug?

[Open an issue](https://github.com/SneakiiCROWN/PLOPQUAKE/issues) with the release version, Windows/Android version, relevant controller or phone model, steps to reproduce and what happened. Share screenshots or a short recording if useful; leave personal saves, account details and private logs out of public reports.
