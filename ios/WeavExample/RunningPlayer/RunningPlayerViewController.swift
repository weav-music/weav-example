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
  private let controls: WeavRunModeControl

  private var myView: RunningPlayerView {
    return view as! RunningPlayerView
  }

  init(session: WeavRunningSession, cadenceControls: WeavRunModeControl) {
    self.runningSession = session
    self.controls = cadenceControls
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  override func loadView() {
    view = RunningPlayerView(hasMusicControls: musicSession != nil)

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
    if runningSession.isWorkoutInProgress {
      runningSession.pauseWorkout()
    } else {
      runningSession.startWorkout()
      runningSession.resumeWorkout()
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
    musicSession?.duckMusic(isRunning ? 1.0 : 0.4)
    myView.statsView.workoutStateChanged(isRunning)
  }
  
  func timerTicked(_ timeElapsed: TimeInterval) {
    myView.statsView.duration.text = Self.formatTime(seconds: timeElapsed)
  }
  
  static func formatTime(seconds: TimeInterval) -> String {
    guard !seconds.isNaN else { return "-:--:--" }
    
    let timeInterval = Int(round(seconds))
    
    let seconds = timeInterval % 60
    let minutes = (timeInterval / 60) % 60
    let hours = (timeInterval / 3600)
    
    return String(format: "%d:%0.2d:%0.2d", hours, minutes, seconds)
  }
}
