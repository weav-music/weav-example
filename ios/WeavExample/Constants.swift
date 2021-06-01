//
//  Constants.swift
//  WeavExample
//
//  Created by mani on 01/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation

typealias WorkoutResourceBundle = (identifier: String, path: String)

struct Constants {
  static let defaultInstructorBundle: WorkoutResourceBundle = {
    let identifier = "kelly_roberts_instructor_embedded"
    let url = Bundle.main.url(forResource: identifier, withExtension: "bundle")!
    return (identifier: identifier, path: url.path)
  }()

  static let exampleWorkout: WorkoutResourceBundle = {
    let identifier = "kelly_roberts_400m_repeats"
    let url = Bundle.main.url(forResource: identifier, withExtension: "bundle")!
    return (identifier: identifier, path: url.path)
  }()

  static let examplePlaylistId = "io.weav.bundle.WeavExample"
}
