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
    config.distanceUnitPreference = .mile
    config.heartRateUpdateSource = kHeartRateUpdateSourceNone
    config.instructorBundlePath = Constants.defaultInstructorBundle.path
    config.instructorBundleResourceIdentifier = Constants.defaultInstructorBundle.identifier
    return config
  }
}
