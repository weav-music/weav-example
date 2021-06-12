//
//  UIImage.swift
//  WeavExample
//
//  Created by mani on 11/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  static var previousButton: UIImage {
    return #imageLiteral(resourceName: "previous")
  }

  static var nextButton: UIImage {
    return #imageLiteral(resourceName: "next")
  }

  static var playButton: UIImage {
    return #imageLiteral(resourceName: "play")
  }

  static var pauseButton: UIImage {
    return #imageLiteral(resourceName: "pause")
  }
}
