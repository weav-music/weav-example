//
//  LocationPermissionRequest.swift
//  WeavExample
//
//  Created by mani on 11/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import CoreLocation

class LocationPermissionRequest: NSObject {
  private let locationManager = CLLocationManager()

  var status: CLAuthorizationStatus {
    return CLLocationManager.authorizationStatus()
  }

  typealias Callback = (_ granted: Bool) -> ()
  private var callback: Callback?

  override init() {
    super.init()
    locationManager.delegate = self
  }

  func requestPermission(_ callback: @escaping Callback) {
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      callback(true)
    case .denied, .restricted:
      callback(false)
    case .notDetermined:
      fallthrough
    @unknown default:
      self.callback = callback
      locationManager.requestWhenInUseAuthorization()
    }
  }
}

extension LocationPermissionRequest: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if let callback = callback {
      self.callback = nil
      callback([.authorizedAlways, .authorizedWhenInUse].contains(status))
    }
  }
}
