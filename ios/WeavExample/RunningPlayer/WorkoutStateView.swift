//
//  WorkoutStateView.swift
//  WeavExample
//
//  Created by mani on 16/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class WorkoutStateView: UIView {
  private let label = UILabel.createTitleLabel("")
  private let lengthRemaining = UILabel()

  init() {
    super.init(frame: .zero)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  func setTitle(_ text: String) {
    label.text = text
  }

  func setLengthRemainig(_ text: String) {
    lengthRemaining.text = text
  }

  private func setup() {
    addSubview(label)
    addSubview(lengthRemaining)

    let top = UILayoutGuide()
    let bottom = UILayoutGuide()

    addLayoutGuide(top)
    addLayoutGuide(bottom)

    top.snp.makeConstraints {
      $0.top.equalToSuperview()
    }

    label.snp.makeConstraints {
      $0.top.equalTo(top.snp.bottom)
      $0.width.centerX.equalToSuperview()
    }

    lengthRemaining.textAlignment = .center
    lengthRemaining.snp.makeConstraints {
      $0.top.equalTo(label.snp.bottom)
      $0.width.centerX.equalToSuperview()
      $0.bottom.equalTo(bottom.snp.top)
    }

    bottom.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.height.equalTo(top)
    }
  }
}
