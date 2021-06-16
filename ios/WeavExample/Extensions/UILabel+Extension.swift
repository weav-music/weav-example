//
//  UILabel+Extension.swift
//  WeavExample
//
//  Created by mani on 13/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
  static func createTitleLabel(_ title: String) -> UILabel {
    let label = UILabel()
    label.text = title
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textColor = .black
    label.textAlignment = .center
    label.numberOfLines = 1
    label.sizeToFit()
    return label
  }
}
