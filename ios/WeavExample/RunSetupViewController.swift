//
//  SecondViewController.swift
//  WeavExample
//
//  Created by mani on 06/12/2016.
//  Copyright © 2016 Weav. All rights reserved.
//

import UIKit
import WeavKit

class RunSetupViewController: UIViewController {

  @IBOutlet weak var optInDebug: UISwitch!

  private let locationPermissionRequest = LocationPermissionRequest()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    optInDebug.setOn(UserDefaults.standard.bool(forKey: WeavKit.dataSharingPermissionKey()), animated: true)
  }

  @IBAction func onDataSharingPreferenceChange(_ sender: Any) {
    UserDefaults.standard.set(optInDebug.isOn, forKey: WeavKit.dataSharingPermissionKey())
    UserDefaults.standard.synchronize()
  }

  @IBAction func onStartRun(_ sender: Any) {
    let config = WeavRunningSessionConfig.createDefault()
    setLocationSource(config) { [weak self] in
      let session = WeavKit.sessionManager().activateRunningSession(with: config)
      let controls = session.startCadenceMode(withInitialCadence: 120, cadenceLock: false)
      self?.showPlayerViewController(session: session, controls: controls)
    }
  }

  private func showPlayerViewController(session: WeavRunningSession, controls: WeavRunModeControl) {
    let vc = RunningPlayerViewController(session: session, cadenceControls: controls)
    let navController = UINavigationController(rootViewController: vc)
    navController.modalPresentationStyle = .fullScreen
    present(navController, animated: true, completion: nil)
  }

  private func setLocationSource(_ config: WeavRunningSessionConfig, _ onDone: @escaping () -> ()) {
//    If you will be providing location or distance updates update the config:

//    If you will be providing distance updates manually, update the config and then periodically
//    call session.updateDistance with meters elapsed
//    config.distanceUpdateSource = kDistanceUpdateSourceCustomDistanceProvider
//    session.updateDistance(_ distanceMeters: Double)

//    If you will be providing location updates, with CLLocation objects, WeavKit will automatically
//    compute distance updates. WeavKit may run some filtering algorithms based on activity.
//    config.distanceUpdateSource = kDistanceUpdateSourceCustomLocationDetector
//    session.updateLocation(_ location: CLLocation)

//    If you want to use the default CLLocation based distance updates, you must request location permission.
//    To receive updates, you should add a running session delegate.
//    session.addRunningSessionDelegate(_ delegate: WeavRunningSessionDelegate)

    config.distanceUpdateSource = kDistanceUpdateSourceDefault
    return locationPermissionRequest.requestPermission { granted in
      print("Location permission \(granted ? "" : "not ")granted.")
      onDone()
    }
  }
}

