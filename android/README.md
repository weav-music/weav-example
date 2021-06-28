# Weav Android Example Application

This folder contains an example android app as an Android Studio project.


### Build Prerequisites

Download provided `weavkit.aar` and place in `sdk-resources` folder.

### Loading resources to device or emulator

You should have been provided with a resource bundle containing the following resources/directories:

File Name                                    |
---------------------------------------------|
`kelly_roberts_400m_repeats.bundle`          |
`kelly_roberts_instructor_embedded.bundle`   |
`WeavExampleEmbeddedSongs.bundle`            |
`kelly_roberts_400m_repeats.enc`             |

Upload this resource bundle to device or emulator at one of the following paths:

`storage/emulated/0/Android/data/io.weav.example/files`
`sdcard/Android/data/io.weav.example/files`

This is for running the example app only. In production, songs and other resources can and should be downloaded by accessing the `WeavKit.musicLibrary()` via the SDK.


## Running the Application

The `weav-example/android` folder can be opened using Android Studio.

Run/Debug the app on device or emulator and accept all storage access permissions to be able to read local resource bundles (you may need to restart the app after accepting permissions).


## Issues

- Audible clicks at the beginning of an audio session on some Android devices caused by AAudio library.
- cannot switch between MusicSession and RunningWithMusicSession without restarting music playback



