//
//  RunningControlsView.swift
//  WeavExample
//
//  Created by mani on 02/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import WeavKit

class RunningControlsView: UIView {
  let pauseResumeButton = UIButton(type: .system)

  let duration = StatView(title: "Duration")
  let cadence = StatView(title: "Cadence")
  let distance = StatView(title: "Distance")
  let pace = StatView(title: "Pace")

  init() {
    super.init(frame: .zero)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  func workoutStateChanged(_ isRunning: Bool) {
    pauseResumeButton.setTitle(isRunning ? "Pause workout" : "Resume workout", for: .normal)
  }

  func onWorkoutStateToggle(_ target: Any?, _ selector: Selector) {
    pauseResumeButton.addTarget(target, action: selector, for: .touchUpInside)
  }

  private func setup() {
    let titleLabel = UILabel()

    addSubview(titleLabel)
    addSubview(pauseResumeButton)

    let container = UIView()
    addSubview(container)
    container.addSubview(duration)
    container.addSubview(cadence)
    container.addSubview(distance)
    container.addSubview(pace)

    titleLabel.text = "Running Controls"
    titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    titleLabel.textColor = .black
    titleLabel.textAlignment = .center
    titleLabel.snp.makeConstraints {
      $0.bottom.equalTo(container.snp.top)
      $0.top.left.right.equalToSuperview()
    }

    container.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.bottom.equalTo(pauseResumeButton.snp.top)
    }

    pauseResumeButton.setTitle("Start workout", for: .normal)
    pauseResumeButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalToSuperview().dividedBy(6)
    }

    duration.snp.makeConstraints {
      $0.top.left.equalToSuperview()
      $0.width.equalToSuperview().dividedBy(2)
      $0.height.equalToSuperview().dividedBy(2)
    }

    cadence.snp.makeConstraints {
      $0.width.height.equalTo(duration)
      $0.right.top.equalToSuperview()
    }

    distance.snp.makeConstraints {
      $0.width.height.equalTo(duration)
      $0.left.bottom.equalToSuperview()
    }

    pace.snp.makeConstraints {
      $0.width.height.equalTo(duration)
      $0.right.bottom.equalToSuperview()
    }
  }
}
