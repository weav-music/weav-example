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

class PlayerViewController:UIViewController {
  @IBOutlet weak var coverArtImage: UIImageView!
  @IBOutlet weak var trackName: UILabel!
  @IBOutlet weak var artistName: UILabel!
  
  @IBOutlet weak var pauseButton: UIButton!
  @IBOutlet weak var playButton: UIButton!
  
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var bpmLabel: UILabel!
  
  let session = WeavKit.sessionManager().activateRunningWithMusicSession(with: WeavRunningSessionConfig.createDefault())
  var runningControls: WeavRunCadenceModeControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    session.setPlaylistWithId(Constants.examplePlaylistId)
    session.addMusicSessionDelegate(self)
    session.addRunningSessionDelegate(self)
    
    runningControls = session.startCadenceMode(withInitialCadence: 120,
                                               cadenceLock: false)

    pauseButton.isHidden = true
  }
  
  @IBAction func onPreviousTrack(_ sender: Any) {
    session.prevSong()
  }
  
  @IBAction func onNextTrack(_ sender: Any) {
    session.nextSong()
  }
  
  @IBAction func onPlayPauseToggle(_ sender: Any) {
    if session.isWorkoutInProgress {
      session.pauseWorkout()
      session.pauseMusic()
    } else {
      session.startWorkout()
      session.resumeMusic()
    }
  }
  
  @IBAction func onDoneSession(_ sender: Any) {
    session.stop()
    session.terminate()
    dismiss(animated: true)
  }
}

extension PlayerViewController: WeavMusicSessionDelegate {
  func nowPlaying(_ song: WeavSong, in playlist: WeavPlaylist) {
    do {
      try self.coverArtImage.image = UIImage(data: Data(contentsOf: song.coverArtImageUrl))
    } catch _ {}
    trackName.text = song.name
    artistName.text = song.artist
  }

  func playerBpmChanged(_ bpm: Double) {
    bpmLabel.text = String(format:"%.f bpm", bpm)
  }

  func playerStateChanged(_ isPlaying: Bool) {

  }

  func nowPlayingSongProgress(_ elapsed: TimeInterval, total: TimeInterval) {

  }
}

extension PlayerViewController: WeavRunningSessionDelegate {
  func cadenceUpdated(_ cadence: Double) {

  }

  func splitPaceUpdated(_ mps: Double) {

  }
  
  func workoutStateChanged(_ isRunning: Bool) {
    session.duckMusic(isRunning ? 1.0 : 0.2)
    pauseButton.isHidden = !isRunning
    playButton.isHidden = isRunning
  }
  
  func timerTicked(_ timeElapsed: TimeInterval) {
    self.timerLabel.text = PlayerViewController.formatTime(seconds: timeElapsed)
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
