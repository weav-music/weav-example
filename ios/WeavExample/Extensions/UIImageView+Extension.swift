//
//  UIImageView+Extension.swift
//  WeavExample
//
//  Created by mani on 13/06/2021.
//  Copyright © 2021 Weav. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
  func asyncSetImage(fromUrl url: URL) {
    DispatchQueue.global(qos: .default).async { [weak self] in
      if let data = try? Data(contentsOf: url) {
        DispatchQueue.main.async {
          self?.image = UIImage(data: data)
        }
      }
    }
  }
}
