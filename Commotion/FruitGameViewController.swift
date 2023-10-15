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
    
    struct AppUtility {
        
        // for locking the orientation about the game for good experience
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
               
            }
        }
        /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
       
            self.lockOrientation(orientation)
        
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
    //lock the orientation in portrait 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    var isgameLoaded=false//  flag for the game is loaded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.orientation == .portrait{  // when enter in the game is portrait directly load game
            loadGameScene()
            isgameLoaded=true
        }
        
        // if change the orientation, it should notice the function to load later .
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //set the orientation change when start load game
    @objc func orientationDidChange() {
            let currentOrientation = UIDevice.current.orientation
                if UIDevice.current.orientation == .portrait && isgameLoaded==false{
                        loadGameScene()
                        isgameLoaded=true
                }
    }
    
    //load game
    func loadGameScene(){
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
    
    // change and lock the portrat for game
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }

    override var shouldAutorotate: Bool{
        return false
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
  
    // segue to infor page
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
