//
//  MusicControlsView.swift
//  WeavExample
//
//  Created by mani on 11/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import WeavKit

class MusicControlsView: UIView {
  private let coverArtImage = UIImageView()
  private let songTitleLabel = UILabel()
  private let artistLabel = UILabel()

  private let progressView = UIProgressView()

  private let playPauseButton = UIButton(type: .system)
  private let nextSongButton = UIButton(type: .system)
  private let prevSongButton = UIButton(type: .system)

  init() {
    super.init(frame: .zero)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  func setIsPlaying(_ isPlaying: Bool) {
    playPauseButton.setImage(isPlaying ? UIImage.pauseButton : UIImage.playButton, for: .normal)
  }

  func setPlayerControls(_ target: Any?,
                         onNextSong: Selector,
                         onPreviousSong: Selector,
                         onPlayerToggle: Selector) {
    playPauseButton.addTarget(target, action: onPlayerToggle, for: .touchUpInside)
    nextSongButton.addTarget(target, action: onNextSong, for: .touchUpInside)
    prevSongButton.addTarget(target, action: onPreviousSong, for: .touchUpInside)
  }

  func songChanged(_ song:  WeavSong) {
    DispatchQueue.main.async { [weak self] in
      if let image = try? UIImage(data: Data(contentsOf: song.coverArtImageUrl)) {
        self?.coverArtImage.image = image
      }
    }
    songTitleLabel.text = song.name
    artistLabel.text = song.artist
  }

  func songProgress(_ ratio: Double) {
    progressView.setProgress(Float(ratio), animated: false)
  }

  private func setup() {
    clipsToBounds = true

    let titleLabel = UILabel()

    addSubview(titleLabel)
    addSubview(coverArtImage)
    addSubview(progressView)
    addSubview(songTitleLabel)
    addSubview(artistLabel)
    addSubview(playPauseButton)
    addSubview(nextSongButton)
    addSubview(prevSongButton)

    titleLabel.text = "Music Controls"
    titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    titleLabel.textColor = .black
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 1
    titleLabel.sizeToFit()
    titleLabel.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.height.equalTo(titleLabel.bounds.height)
    }

    coverArtImage.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.height.equalTo(coverArtImage.snp.width)
    }

    progressView.progressTintColor = .black
    progressView.trackTintColor = .lightGray.withAlphaComponent(0.4)
    progressView.setProgress(0, animated: false)
    progressView.transform = progressView.transform.scaledBy(x: 1, y: 2)

    progressView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.top.equalTo(coverArtImage.snp.bottom).inset(-8)
      make.height.equalTo(4)
    }

    songTitleLabel.snp.makeConstraints {
      $0.left.equalTo(coverArtImage.snp.right).offset(8)
      $0.right.equalToSuperview()
    }

    artistLabel.snp.makeConstraints {
      $0.top.equalTo(songTitleLabel.snp.bottom)
      $0.left.equalTo(coverArtImage.snp.right).offset(8)
      $0.right.equalToSuperview()
      $0.bottom.equalTo(coverArtImage)
    }

    playPauseButton.setImage(UIImage.playButton, for: .normal)
    playPauseButton.snp.makeConstraints {
      $0.top.equalTo(progressView.snp.bottom).offset(8)
      $0.height.equalTo(45)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(playPauseButton.snp.height)
      $0.bottom.equalToSuperview()
    }

    nextSongButton.setImage(UIImage.nextButton, for: .normal)
    nextSongButton.snp.makeConstraints {
      $0.height.width.centerY.equalTo(playPauseButton)
      $0.right.equalToSuperview()
    }

    prevSongButton.setImage(UIImage.previousButton, for: .normal)
    prevSongButton.snp.makeConstraints {
      $0.height.width.centerY.equalTo(playPauseButton)
      $0.left.equalToSuperview()
    }
  }
}
