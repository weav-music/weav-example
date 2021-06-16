//
//  RunSetupView.swift
//  WeavExample
//
//  Created by mani on 13/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import WeavKit

private let buttonFont = UIFont.systemFont(ofSize: 18)

private class StartRunChoiceView: UIView {
  private let runWithMusicButton = UIButton(type: .system)
  private let runWithoutMusicButton = UIButton(type: .system)

  init(title: String, noun: String) {
    super.init(frame: .zero)
    setup(title: title, noun: noun)
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  func setActions(_ target: Any,
                  withMusic: Selector,
                  withoutMusic: Selector) {
    runWithMusicButton.addTarget(target, action: withMusic, for: .touchUpInside)
    runWithoutMusicButton.addTarget(target, action: withoutMusic, for: .touchUpInside)
  }

  private func setup(title: String, noun: String) {
    let titleLabel = UILabel.createTitleLabel(title)
    let orLabel = UILabel()

    addSubview(titleLabel)
    addSubview(runWithMusicButton)
    addSubview(orLabel)
    addSubview(runWithoutMusicButton)

    titleLabel.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.height.equalTo(titleLabel.bounds.height)
    }

    runWithMusicButton.setTitle("Start \(noun) with music", for: .normal)
    runWithMusicButton.titleLabel?.font = buttonFont
    runWithMusicButton.sizeToFit()
    runWithMusicButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(orLabel.snp.top)
      $0.height.equalTo(runWithMusicButton.bounds.height)
    }

    orLabel.text = "or"
    orLabel.sizeToFit()
    orLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.equalTo(orLabel.bounds.height)
    }

    runWithoutMusicButton.setTitle("Start \(noun) without music", for: .normal)
    runWithoutMusicButton.titleLabel?.font = buttonFont
    runWithoutMusicButton.sizeToFit()
    runWithoutMusicButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(orLabel.snp.bottom)
      $0.bottom.equalToSuperview()
      $0.height.equalTo(runWithoutMusicButton.bounds.height)
    }
  }
}

class RunSetupView: UIView {

  private let loadWorkoutButton = UIButton(type: .system)
  private let workoutPlanDetailsView = WorkoutPlanDetailsView()

  private let runWithoutWorkout = StartRunChoiceView(title: "Run without workout plan", noun: "run")
  private let runWithWorkoutPlan = StartRunChoiceView(title: "Run with workout plan", noun: "workout plan")

  init() {
    super.init(frame: .zero)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  func setWorkoutDetails(_ plan: WeavWorkoutPlan) {
    workoutPlanDetailsView.setPlan(plan)
    workoutPlanDetailsView.isHidden = false
    loadWorkoutButton.isHidden = true
  }

  func setWorkoutPlanActions(_ target: Any,
                             onLoadWorkoutPlan: Selector,
                             onStartRunWithMusic: Selector,
                             onStartRunWithoutMusic: Selector) {
    loadWorkoutButton.addTarget(target, action: onLoadWorkoutPlan, for: .touchUpInside)
    runWithWorkoutPlan.setActions(target, withMusic: onStartRunWithMusic, withoutMusic: onStartRunWithoutMusic)
  }

  func setRunActions(_ target: Any,
                     onStartRunWithMusic: Selector,
                     onStartRunWithoutMusic: Selector) {
    runWithoutWorkout.setActions(target, withMusic: onStartRunWithMusic, withoutMusic: onStartRunWithoutMusic)
  }

  private func setup() {
    backgroundColor = .white

    let spacer = UILayoutGuide()

    addSubview(workoutPlanDetailsView)
    addSubview(loadWorkoutButton)
    addSubview(runWithWorkoutPlan)
    addLayoutGuide(spacer)
    addSubview(runWithoutWorkout)

    workoutPlanDetailsView.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top)
      $0.left.right.equalToSuperview().inset(8)
    }

    runWithWorkoutPlan.snp.makeConstraints {
      $0.top.equalTo(workoutPlanDetailsView.snp.bottom)
      $0.left.right.equalTo(workoutPlanDetailsView)
      $0.height.equalTo(workoutPlanDetailsView).dividedBy(2)
    }

    spacer.snp.makeConstraints {
      $0.top.equalTo(runWithWorkoutPlan.snp.bottom)
      $0.bottom.equalTo(runWithoutWorkout.snp.bottom)
    }

    runWithoutWorkout.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16)
      $0.height.equalTo(runWithWorkoutPlan)
    }

    loadWorkoutButton.setTitle("Load workout plan", for: .normal)
    loadWorkoutButton.titleLabel?.font = buttonFont
    loadWorkoutButton.sizeToFit()
    loadWorkoutButton.snp.makeConstraints {
      $0.center.equalTo(workoutPlanDetailsView)
    }
  }
}
