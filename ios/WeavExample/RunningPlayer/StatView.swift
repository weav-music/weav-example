//
//  StatView.swift
//  WeavExample
//
//  Created by mani on 02/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class StatView: UIView {
  private let titleLabel = UILabel()
  private let valueLabel = UILabel()

  var text: String? {
    get {
      return valueLabel.text
    }
    set {
      valueLabel.text = newValue
    }
  }

  init(title: String) {
    super.init(frame: .zero)
    setup()
    titleLabel.text = title
    text = "--"
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  private func setup() {
    let top = UILayoutGuide()
    let bottom = UILayoutGuide()

    addLayoutGuide(top)
    addSubview(titleLabel)
    addSubview(valueLabel)
    addLayoutGuide(bottom)

    top.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
    titleLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(top.snp.bottom)
    }

    valueLabel.textAlignment = .center
    valueLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.bottom.equalTo(bottom.snp.top)
    }

    bottom.snp.makeConstraints {
      $0.height.equalTo(top)
      $0.bottom.left.right.equalToSuperview()
    }
  }
}
