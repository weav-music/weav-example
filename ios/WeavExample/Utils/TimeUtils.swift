//
//  TimeUtils.swift
//  WeavExample
//
//  Created by mani on 13/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation

struct TimeUtils {
  static func formatTime(seconds: TimeInterval,
                         showMinutes: Bool = true,
                         showHours: Bool = true,
                         padSeconds: Bool = true) -> String {
    guard !seconds.isNaN else { return String(format: "%@--:--", showHours ? "-:" : "") }

    let timeInterval = Int(round(seconds))

    let seconds = timeInterval % 60
    let minutes = (timeInterval / 60) % 60
    let hours = (timeInterval / 3600)

    let formatLeadingZeros = "%02d"

    if hours > 0 || showHours {
      return String(format: "%d:\(formatLeadingZeros):\(formatLeadingZeros)", hours, minutes, seconds)
    } else if minutes > 0 || showMinutes {
      return String(format: "%d:\(formatLeadingZeros)", minutes, seconds)
    } else {
      return String(format: padSeconds ? formatLeadingZeros : "%d", seconds)
    }
  }
}
