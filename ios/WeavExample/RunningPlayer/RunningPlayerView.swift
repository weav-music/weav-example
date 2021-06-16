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
  let workoutStateView: WorkoutStateView?
  let musicPlayerView: MusicControlsView?
  let statsView = RunningControlsView()

  init(hasWorkoutPlan: Bool, hasMusicControls: Bool) {
    workoutStateView = hasWorkoutPlan ? WorkoutStateView() : nil
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

    let workoutStateLayoutGuide = workoutStateView ?? UIView()
    addSubview(workoutStateLayoutGuide)

    workoutStateLayoutGuide.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top)
      $0.left.right.equalToSuperview()
      $0.bottom.equalTo(statsView.snp.top)
    }

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
