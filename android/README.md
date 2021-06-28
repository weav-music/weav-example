# Weav Android Example Application

This folder contains source code and an Android Studio project for the io.weav.example test application.


## Build Prerequisites

**Android WeavKit Library** This is available via your dropbox link. The file `weavkit.aar` should be placed into the `weav-example/android/sdk-resources` folder.

## Running the Application

The `weav-example/android` folder can be opened using Android Studio.

Once opened, the applcation can be loaded onto a device using the Android Studio run/debug flow. Once the application has been installed on a device for the first time, storage permissions must be accepted, and the provided runtime resources must be loaded onto the device:

**Runtime Resources** The dropbox link also contains a folder `weav-example-license-key`. The resources in this folder must be copied to the application folder on each device where you intend to run the application.

When a device is connected to Android Studio, and once storage permissions have been accepted, the device file explorer (opened with `View -> Tool Windows -> Device File Explorer`) can be used to load the runtime resources onto the device. The destination folder should be created when permissions are accepted and can be found at one of the following locations depending on the exact device model:

`storage/emulated/0/Android/data/io.weav.example/files`
`sdcard/Android/data/io.weav.example/files`

Once located the following files must be uploaded from `*Dropbox_folder*/weav-example-license-key/` into `data/io.weav.example/files/`:

File Name                                    |
---------------------------------------------|
`kelly_roberts_400m_repeats.bundle`          |
`kelly_roberts_instructor_embedded.bundle`   |
`WeavExampleEmbeddedSongs.bundle`            |
`kelly_roberts_400m_repeats.enc`             |


## Issues



