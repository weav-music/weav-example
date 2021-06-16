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

  private var myView: RunSetupView {
    return view as! RunSetupView
  }

  private let locationPermissionRequest = LocationPermissionRequest()

  private var plan: WeavWorkoutPlan?

  override func loadView() {
    view = RunSetupView()

    myView.setRunActions(self,
                         onStartRunWithMusic: #selector(onStartRunWithMusic),
                         onStartRunWithoutMusic: #selector(onStartRunWithoutMusic))
    myView.setWorkoutPlanActions(self,
                                 onLoadWorkoutPlan: #selector(onLoadWorkoutPlan),
                                 onStartRunWithMusic: #selector(onStartWorkoutPlanWithMusic),
                                 onStartRunWithoutMusic: #selector(onStartWorkoutPlanWithoutMusic))
  }

  @objc
  private func onLoadWorkoutPlan() {
    if let plan = getOrLoadWorkoutPlan() {
      myView.setWorkoutDetails(plan)
    }
  }

  @objc
  private func onStartWorkoutPlanWithMusic() {
    if let workoutPlan = getOrLoadWorkoutPlan() {
      let config = WeavRunningSessionConfig.createDefault()
      let session = WeavKit.sessionManager().activateRunningWithMusicSession(with: config)
      startRunning(session: session, config: config, workoutPlan: workoutPlan)
    }
  }

  @objc
  private func onStartWorkoutPlanWithoutMusic() {
    if let workoutPlan = getOrLoadWorkoutPlan() {
      let config = WeavRunningSessionConfig.createDefault()
      let session = WeavKit.sessionManager().activateRunningSession(with: config)
      startRunning(session: session, config: config, workoutPlan: workoutPlan)
    }
  }

  @objc
  private func onStartRunWithMusic() {
    let config = WeavRunningSessionConfig.createDefault()
    let session = WeavKit.sessionManager().activateRunningWithMusicSession(with: config)
    startRunning(session: session, config: config, workoutPlan: nil)
  }

  @objc
  private func onStartRunWithoutMusic() {
    let config = WeavRunningSessionConfig.createDefault()
    let session = WeavKit.sessionManager().activateRunningSession(with: config)
    startRunning(session: session, config: config, workoutPlan: nil)
  }

  private func startRunning(session: WeavRunningSession, config: WeavRunningSessionConfig, workoutPlan: WeavWorkoutPlan?) {
    setLocationSource(config) { [weak self] in
      let vc = RunningPlayerViewController(session: session, workoutPlan: workoutPlan)
      let navController = UINavigationController(rootViewController: vc)
      navController.modalPresentationStyle = .fullScreen
      self?.present(navController, animated: true, completion: nil)
    }
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

  private func getOrLoadWorkoutPlan() -> WeavWorkoutPlan? {
    if let plan = plan {
      return plan
    }
    plan = WeavWorkoutPlan.create(fromPath: Constants.exampleWorkout.path,
                                  identifier: Constants.exampleWorkout.identifier)
    return plan
  }
}

