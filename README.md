# WeavKit Example App

This repository contains example apps for iOS and Android to get up and running with the provided SDK and example resources.

---

## For SDK integration within your own app:

Add `WeavKit.xcframework` under Frameworks, Libraries, and Embedded Content of your app target.

Add all provided resources to your project workspace.

These resources can also be hosted on your servers, and downloaded after app installation. But for simplicity we'll assume you have already downloaded them and have local URL to them.

---

### Initialize Weav Kit:

**Basic minimum setup**:

```
WeavKit.setup(withLicenseKey: "your license key. specific to your app bundle id")
```

**Set has subscription**:

```
WeavKit.setHasSubscription(true)
```

Without this flag, the music plays back one song at a time and doesn't transition into next song. This flag may change in the future based on different music licensing agreements (TBD).

**Load local music** if you have a music bundle provided:

```
if let url = Bundle.main.url(forResource: "WeavExampleEmbeddedSongs", withExtension: "bundle") {
  WeavKit.loadLocalContent(fromPath: url)
}
```

**Set user identifier:**

```
WeavKit.setUserIdentifier("unique user id")
```
This helps us track number of users that use the app for usage and analytics. A user may install the app on multiple devices. The SDK automatically detects new installation, however, without this identification, each new installation is treated as a distinct user.

--- 

### Load a Workout Plan

```
if let url = Bundle.main.url(forResource: "kelly_roberts_400m_repeats",
                                 withExtension: "enc"),
   let workoutPlan = WeavWorkoutPlan.create(fromPath: url,
                                            identifier: "kelly_roberts_400m_repeats") {
    // refer to detauls in WeavWorkoutPlan.h to display workout details if desired
}
```
---

### Start running session:

#### Create a `WeavRunningSessionConfig`. 

```
let config = WeavRunningSessionConfig()
if let url = Bundle.main.url(forResource: "kelly_roberts_instructor_embedded", withExtention: "bundle") {
  config.instructorBundlePath = url.path
}
config.instructorBundleResourceIdentifier = "kelly_roberts_instructor_embedded"
config.distanceUnitPreference = .mile

// decide on your distance update source (Refer to running-data-source-types.h for details)
config.distanceUpdateSource = kDistanceUpdateSourceCustomDistanceProvider

// decide on cadence update source (refer to running-data-source-types.h) for details
config.cadenceUpdateSource = kCadenceUpdateSourceDefault

// keep a reference to prompt settings so that they can be modified while running if needed
let promptSettings = config.promptSettings
promptSettings.applyPromptSettings()

// Add this extension to simplify prompt settings.
// You may want to implement some UI to allow the user to change their prompt preferences
extension WeavRunningPromptSettings {
  func applyPromptSettings() {
    self.promptTypes = 0

    // enable announce distance
    self.promptTypes |= kRunningPromptTypeDistance.rawValue

    // enable announce duration
    self.promptTypes |= kRunningPromptTypeDuration.rawValue

    // enable announcing pace
    self.promptTypes |= kRunningPromptTypePace.rawValue

    // eg. to announce every half kilometer
    self.promptIntervalValue = 0.5
    self.distanceUnitPreference = .kilometer

    // global enabled for announcements
    self.isEnabled = true
  }
}

```
You may want to create a swift extension so to create the same default config each time for your app.

#### Start a running session:

```
let sessionManager = WeavKit.sessionManager()

// activate session with or without music:
// session.activateRunningWithMusicSession(with: config) // with music
let session = sessionManager.activateRunningSession(with: config)

// add a delegate to get running session callbacks (WeavRunningSessionDelegate)
// session.addRunningSessionDelegate(runningSessionDelegate) 

```

#### Pick a running mode to start:
- **cadence mode**: activates cadence detection algorithm using motion data
- **workout mode**: uses a workout plan (see above how to create a WeavWorkoutPlan instance)

```
let workoutResourceBundlePath = Bundle.main.url(forResource: "kelly_roberts_400m_repeats",
                                                withExtension: "bundle")!
running.activateWorkoutPlanMode(with: workoutPlan,
                        resourceBundlePath: workoutResourceBundlePath,
                        // Refer to WeavRunModeControl+Public.h for details on WeavRunWorkoutModeControlDelegate
                        delegate: delegate) 
                     
// To start workout timer you must explicitly call:
running.startWorkout()                   

// if its a runningWithMusicSession you can get music to start playing by calling:
running.resumeMusic()

// music and workout can run independently. you may want to pause the workout if music player paused by the user (using headphones, via lockscreen) or there is an audio interruption (listen for playerStateChanged callbacks).
                                               
```

