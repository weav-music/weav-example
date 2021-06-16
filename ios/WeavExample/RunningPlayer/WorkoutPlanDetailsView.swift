//
//  WorkoutPlanDetailsView.swift
//  WeavExample
//
//  Created by mani on 12/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import UIKit
import WeavKit

class WorkoutPlanDetailsView: UIView {
  private let title = UILabel()
  private let summary = UILabel()
  private let tags = UILabel()

  private let instructorImage = UIImageView()
  private let instructorName = UILabel()

  init() {
    super.init(frame: .zero)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  func setPlan(_ plan: WeavWorkoutPlan) {
    // All details here are customisable and not required to have a functioning workout plan.
    // These only exist for convenience and you may choose to display your own info instead.
    title.text = plan.title
    summary.text = plan.summary
    tags.text = plan.tags.joined(separator: ", ")

    instructorName.text = plan.instructor.name
    instructorImage.asyncSetImage(fromUrl: plan.instructor.imageUrl)

    title.sizeHeightToFit()
    summary.sizeHeightToFit()
    tags.sizeHeightToFit()
    instructorName.sizeHeightToFit()
  }

  private func setup() {
    let instructorContainer = UIView()
    addSubview(instructorContainer)
    addSubview(title)
    addSubview(summary)
    addSubview(tags)

    instructorContainer.addSubview(instructorImage)
    instructorContainer.addSubview(instructorName)

    instructorContainer.snp.makeConstraints {
      $0.left.top.right.equalToSuperview()
    }

    instructorImage.contentMode = .scaleAspectFit
    instructorImage.snp.makeConstraints {
      $0.top.left.bottom.equalToSuperview()
      $0.width.equalTo(100)
      $0.height.equalTo(instructorImage.snp.width)
    }

    instructorName.snp.makeConstraints {
      $0.left.equalTo(instructorImage.snp.right)
      $0.right.equalToSuperview()
      $0.bottom.equalTo(instructorImage)
      $0.height.equalTo(1)
    }

    title.snp.makeConstraints {
      $0.top.equalTo(instructorContainer.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }

    tags.snp.makeConstraints {
      $0.top.equalTo(title.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }

    summary.snp.makeConstraints {
      $0.top.equalTo(tags.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
}

fileprivate extension UILabel {
  func sizeHeightToFit() {
    sizeToFit()
    snp.updateConstraints {
      $0.height.equalTo(bounds.height)
    }
  }
}
