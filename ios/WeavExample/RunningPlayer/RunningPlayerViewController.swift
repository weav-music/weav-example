//
//  PlayerViewController.swift
//  WeavExample
//
//  Created by mani on 06/12/2016.
//  Copyright © 2016 Weav. All rights reserved.
//

import Foundation
import UIKit
import WeavKit

class RunningPlayerViewController: UIViewController {

  private let runningSession: WeavRunningSession

  private var musicSession: WeavRunningWithMusicSession? {
    return runningSession as? WeavRunningWithMusicSession
  }
  private var controls: WeavRunModeControl!

  private let myView: RunningPlayerView

  init(session: WeavRunningSession, workoutPlan: WeavWorkoutPlan?) {
    self.runningSession = session
    self.myView = RunningPlayerView(hasWorkoutPlan: workoutPlan != nil,
                                    hasMusicControls: (runningSession as? WeavRunningWithMusicSession) != nil)
    super.init(nibName: nil, bundle: nil)
    if let workoutPlan = workoutPlan {
      controls = session.activateWorkoutPlanMode(with: workoutPlan,
                                                 resourceBundlePath: Constants.exampleWorkoutBundle.path,
                                                 delegate: self)
    } else {
      controls = session.activateCadenceMode(withInitialCadence: 120.0, cadenceLock: false)
    }
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  override func loadView() {
    view = myView

    myView.musicPlayerView?.setPlayerControls(self,
                                              onNextSong: #selector(onNextSong),
                                              onPreviousSong: #selector(onPreviousSong),
                                              onPlayerToggle: #selector(onPlayerToggle))
    myView.statsView.onWorkoutStateToggle(self, #selector(onWorkoutStateToggle))
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                        target: self,
                                                        action: #selector(onCloseSession))

    musicSession?.setPlaylistWithId(Constants.examplePlaylistId)
    musicSession?.addMusicSessionDelegate(self)
    runningSession.addRunningSessionDelegate(self)
  }
  
  @objc
  private func onPreviousSong() {
    musicSession?.prevSong()
  }
  
  @objc
  private func onNextSong() {
    musicSession?.nextSong()
  }

  @objc
  private func onPlayerToggle() {
    guard let session = musicSession else { return }
    if session.isMusicPlaying {
      session.pauseMusic()
    } else {
      session.resumeMusic()
    }
  }

  @objc
  private func onWorkoutStateToggle() {
    if runningSession.isWorkoutRunning {
      runningSession.pauseWorkout()
    } else if runningSession.hasWorkoutStarted {
      // Starting or resuming workout in a WeavRunningWithMusicSession will *always* resume music.
      runningSession.resumeWorkout()
    } else {
      runningSession.startWorkout()
    }
  }
  
  @objc
  private func onCloseSession() {
    runningSession.stop()
    runningSession.terminate()
    WeavKit.sessionManager().deactivateSession()
    dismiss(animated: true)
  }
}

extension RunningPlayerViewController: WeavMusicSessionDelegate {
  func nowPlaying(_ song: WeavSong, in playlist: WeavPlaylist) {
    myView.musicPlayerView?.songChanged(song)
  }

  func playerBpmChanged(_ bpm: Double) {

  }

  func playerStateChanged(_ isPlaying: Bool) {
    myView.musicPlayerView?.setIsPlaying(isPlaying)
  }

  func nowPlayingSongProgress(_ elapsed: TimeInterval, total: TimeInterval) {
    myView.musicPlayerView?.songProgress(elapsed / total)
  }
}

extension RunningPlayerViewController: WeavRunningSessionDelegate {
  func cadenceUpdated(_ cadence: Double) {
    myView.statsView.cadence.text = String(format:"%.f bpm", cadence)
  }

  func splitPaceUpdated(_ mps: Double) {
    // TODO (mani) - format pace to more human readable
    myView.statsView.pace.text = String(format: "%.2f mps", mps)
  }

  func updateDistance(_ meters: Double, atLatitude lat: Double, andLongitude lon: Double) {
    myView.statsView.distance.text = String(format: "%.f meters", meters)
  }
  
  func workoutStateChanged(_ isRunning: Bool) {
//    To attach music state to workout state,
//    this is where you must call pause or resume music accordingly.
//    if isRunning {
//      musicSession?.resumeMusic()
//    } else {
//      musicSession?.pauseMusic()
//    }
    myView.statsView.workoutStateChanged(isRunning)
  }
  
  func timerTicked(_ timeElapsed: TimeInterval) {
    myView.statsView.duration.text = TimeUtils.formatTime(seconds: timeElapsed)
  }
}

extension RunningPlayerViewController: WeavRunWorkoutModeControlDelegate {
  func workoutExecutorWorkoutPlanCompleted() {
    myView.workoutStateView?.setTitle("Done")
    myView.workoutStateView?.setLengthRemainig("")
    // at this point, workout plan is complete, the controls now behave same as cadence mode
    print("Workout plan completed - switching to cadence mode")
  }

  func workoutExecutorIntervalLengthRemaining(_ lengthRemaining: WeavWorkoutIntervalLength) {
    myView.workoutStateView?.setLengthRemainig(lengthRemaining.displayString)
  }

  func workoutExecutorScoreCardRowAdded(for info: WeavWorkoutScoreCardInfo,
                                        scoreRow: WeavWorkoutScoreCardRow) {

  }

  func workoutExecutorIntervalChanged(from fromInterval: WeavWorkoutInterval?,
                                      withStats results: WeavWorkoutIntervalResults?,
                                      to toInterval: WeavWorkoutInterval?) {
    if let toInterval = toInterval {
      myView.workoutStateView?.setTitle(toInterval.title)
    }
  }
}
