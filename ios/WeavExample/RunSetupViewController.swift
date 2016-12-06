//
//  SecondViewController.swift
//  WeavExample
//
//  Created by mani on 06/12/2016.
//  Copyright © 2016 Weav. All rights reserved.
//

import UIKit
import WeavKit

class RunSetupViewController: UIViewController {

  @IBOutlet weak var optInDebug: UISwitch!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    optInDebug.setOn(UserDefaults.standard.bool(forKey: WeavKitDataSharingPermissionKey), animated: true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func onDataSharingPreferenceChange(_ sender: Any) {
    UserDefaults.standard.set(optInDebug.isOn, forKey: WeavKitDataSharingPermissionKey)
    UserDefaults.standard.synchronize()
  }

}

