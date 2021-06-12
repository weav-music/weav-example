//
//  RunningPlayerView.swift
//  WeavExample
//
//  Created by mani on 11/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class RunningPlayerView: UIView {
  let musicPlayerView: MusicControlsView?
  let statsView = RunningControlsView()

  init(hasMusicControls: Bool) {
    musicPlayerView = hasMusicControls ? MusicControlsView() : nil
    super.init(frame: .zero)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  private func setup() {
    addSubview(statsView)

    backgroundColor = .white

    let musicControlsLayoutGuide = musicPlayerView ?? UIView()
    addSubview(musicControlsLayoutGuide)

    musicControlsLayoutGuide.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(16)
      make.bottom.equalToSuperview().inset(32)
      make.height.equalToSuperview().dividedBy(4)
    }

    statsView.snp.makeConstraints { make in
      make.left.right.height.equalTo(musicControlsLayoutGuide)
      make.bottom.equalTo(musicControlsLayoutGuide.snp.top)
    }
  }
}
