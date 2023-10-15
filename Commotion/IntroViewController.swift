//
//  IntroViewController.swift
//  Commotion
//
//  Created by RongWei Ji on 10/13/23.
//  Copyright © 2023 Rongwei Ji. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let  motionModel=MotionModel.sharedInstance
          motionModel.updateTodaySteps(){(steps:Int64) in
              DispatchQueue.main.async { [self] in
                  if steps>=1000{
                      inforLabel.text="You have a faster shuriken now. Keep walking" // give the infor about the shuriken speed
                  }
              }
          }
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var inforLabel: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
