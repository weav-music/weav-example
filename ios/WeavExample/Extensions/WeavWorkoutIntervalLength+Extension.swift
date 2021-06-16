//
//  WeavWorkoutIntervalLength+Extension.swift
//  WeavExample
//
//  Created by mani on 16/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import WeavKit

private func metersInUnitDistance(_ unit: WeavDistanceUnit) -> Double {
  switch unit {
  case .kilometer:
    return 1000.0
  case .mile:
    return 1609.344
  default:
    // this should never be the case
    assert(false)
  }
}

private let showMetersOnlyThreshold = metersInUnitDistance(.kilometer) * 0.9

private func roundValueFrom(meters: Double, distanceUnit: WeavDistanceUnit) -> Double {
  let distanceInUnitValue = meters / metersInUnitDistance(distanceUnit)
  let decimalPoints = 2
  let roundingScale = pow(10, Double(decimalPoints))
  return round(distanceInUnitValue * roundingScale) / roundingScale
}

private func formatDistance(_ distanceMeters: Double, distanceUnit: WeavDistanceUnit) -> String {
  // for distances less than 1km and distance unit km, its prefereable to display meters
  if distanceUnit == .kilometer, distanceMeters < showMetersOnlyThreshold {
    return "\(Int(floor(distanceMeters)))m"
  } else {
    let roundedDistance = roundValueFrom(meters: distanceMeters, distanceUnit: distanceUnit)
    return String(format: "%.02f\(distanceUnit.displayString)", roundedDistance)
  }
}

private func formatTimeRemaining(_ seconds: Double) -> String {
  let secondsInt = Int(round(seconds))
  if secondsInt < 60 {
    return "\(secondsInt)"
  }
  return TimeUtils.formatTime(seconds: seconds, showMinutes: false, showHours: false)
}

extension WeavDistanceUnit {
  var displayString: String {
    switch self {
    case .kilometer:
      return "km"
    case .mile:
      return "mi"
    default:
      assert(false)
    }
  }

  var lengthInMeters: Double {
    switch self {
    case .kilometer:
      return 1000.0
    case .mile:
      return 1609.344
    default:
      // this should never be the case
      assert(false)
    }
  }
}

extension WeavWorkoutIntervalLength {
  var displayString: String {
    switch type {
    case .distance:
      return formatDistance(value, distanceUnit: distanceUnit)
    case .time:
      return formatTimeRemaining(value)
    default:
      // currently none other exist - we don't expect others anytime soon
      assert(false)
    }
  }
}
