//
//  FruitGameViewController.swift
//  Commotion
//
//  Created by RongWei Ji on 10/11/23.
//  Copyright © 2023 Rongwei Ji. All rights reserved.
//

import UIKit
import SpriteKit

class FruitGameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //load the skview
        let scene=FruitGameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS=true
        skView.showsNodeCount=true
        skView.ignoresSiblingOrder=true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }

    override var shouldAutorotate: Bool{
        return false
    }
  
    
    @IBAction func inforButtonAction(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name("SceneWillLostFocus"), object: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
