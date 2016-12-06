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
  
  let session = WeavKit.sessionManager().activateRunningSession()
  var runningControls:WeavRunCadenceModeControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    session.add(self)
    
    runningControls = session.startCadenceMode(withInitialCadence: 120)
  }
  
  @IBAction func onPreviousTrack(_ sender: Any) {
    session.prevSong()
  }
  
  @IBAction func onNextTrack(_ sender: Any) {
    session.nextSong()
  }
  
  @IBAction func onPlayPauseToggle(_ sender: Any) {
    if (session.isWorkoutInProgress){
      session.pauseWorkout()
//      runningSession.pauseMusic()
    } else {
      session.resumeWorkout()
//      runningSession.resumeMusic()
    }
  }
  
  @IBAction func onDoneSession(_ sender: Any) {
    session.stop()
    dismiss(animated: true)
  }
}

extension PlayerViewController: WeavRunningSessionDelegate {

  func playerBpmChanged(_ bpm: Double) {
    bpmLabel.text = String(format:"%.f bpm", bpm)
  }
  
  func workoutStateChanged(_ isRunning: Bool) {
    session.currentVolume = isRunning ? 1.0 : 0.3 // its nice to reduce the volume when workout is paused
    pauseButton.isHidden = !isRunning
    playButton.isHidden = isRunning
  }
  
  func nowPlayingTitle(_ title: String, artist: String, coverArtUrl: URL) {
    do {
      try self.coverArtImage.image = UIImage(data: Data(contentsOf: coverArtUrl))
    } catch _ {}
    trackName.text = title
    artistName.text = artist
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
