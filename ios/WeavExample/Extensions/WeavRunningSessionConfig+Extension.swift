//
//  WeavRunningSessionConfig+Extension.swift
//  WeavExample
//
//  Created by mani on 01/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import WeavKit

extension WeavRunningSessionConfig {
  static func createDefault() -> WeavRunningSessionConfig {
    let config = WeavRunningSessionConfig()
    config.cadenceUpdateSource = kCadenceUpdateSourceDefault
    config.distanceUpdateSource = kDistanceUpdateSourceDefault
    config.distanceUnitPreference = .kilometer
    config.runningPromptSettings.distanceUnitPreference = .kilometer
    config.heartRateUpdateSource = kHeartRateUpdateSourceNone
    config.instructorBundlePath = Constants.defaultInstructorBundle.path
    config.instructorBundleResourceIdentifier = Constants.defaultInstructorBundle.identifier

    // Running prompt settings enable audio announcements of stats
    // Only if an audio guided workout is running, these values are over-ridden by the audio guided workout.
    // Once an audio guided workout finishes, prompts revert back to being announced based on these settings.
    let promptSettings = config.runningPromptSettings
    promptSettings.isEnabled = true

    // every 0.25km announce prompts
    promptSettings.distanceUnitPreference = .kilometer
    promptSettings.promptInterval = kRunningPromptIntervalDistance
    promptSettings.promptIntervalValue = 0.25

    promptSettings.promptTypes |= kRunningPromptTypePace.rawValue
    promptSettings.promptTypes |= kRunningPromptTypeDistance.rawValue
    promptSettings.promptTypes |= kRunningPromptTypeDuration.rawValue

    return config
  }
}
