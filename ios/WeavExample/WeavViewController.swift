//
//  WeavViewController.swift
//  WeavExample
//
//  Created by mani on 18/01/2017.
//  Copyright © 2017 Weav. All rights reserved.
//

import Foundation
import UIKit
import WeavKit

class WeavViewController: UIViewController, WeavErrorDelegate {
  
  func weavErrorNoPlayableSong() {
    // No bundled songs + No downloaded songs or no access to downloaded songs based on subscription status
    print("Error: No playable song found")
  }
  
  func weavErrorNoSubscription() {
    // No access to premium features i.e. downloading premium songs, etc
    // This is also a point where the host app may choose to display a popup for IAP
    print("Error: No subscription")
  }
}
