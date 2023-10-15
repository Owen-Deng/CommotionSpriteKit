//
//  ViewController.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    // MARK: =====Class Variables=====
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    let motionModel = MotionModel.sharedInstance
    let configModel = ConfigModel.sharedInstance
    var dailyStepsGoal:Int64 = 0
    var numOfStepsToday:Int64 = 0
    // MARK: =====UI Outlets=====
    @IBOutlet weak var stepsToGoal: UILabel!
    @IBOutlet weak var currentStatus: UILabel!
    @IBOutlet weak var dailyGoal: UITextField!
    @IBOutlet weak var progressBg: UIView!
    @IBOutlet weak var progressBtn: UIView!
    @IBOutlet weak var progressBgWidth: NSLayoutConstraint!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var yesterdayLabel: UILabel!
    // MARK: =====UI Lifecycle=====
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dailyStepsGoal = configModel.dailyGoal
        dailyGoal.text = "\(dailyStepsGoal)"
        addDoneButtonOnKeyboard()
        
        // get yesterday's steps
        motionModel.getYesterdaySteps(){(steps:Int64) in
            DispatchQueue.main.async {
                self.yesterdayLabel.text! = "\(steps)"
            }
        }
        // update today's steps
        motionModel.updateTodaySteps(){(steps:Int64) in
            DispatchQueue.main.async { [self] in
                numOfStepsToday = steps
                self.todayLabel.text! = "\(numOfStepsToday)"
                let stepsLeft = dailyStepsGoal - numOfStepsToday
                if stepsLeft > 0 {
                    stepsToGoal.text = "\(stepsLeft) steps left"
                }else{
                    stepsToGoal.text = "ready to launch!"
                }
                updateBtnProgress()
            }
        }
        // update status
        motionModel.updateCurrentStatus(){(statusText:String) in
            DispatchQueue.main.async {
                self.currentStatus.text! = "\(statusText)"
            }
        }
    }
    
    // update button progress
    func updateBtnProgress(){
        let percentage = min(1, Float(numOfStepsToday) / Float(dailyStepsGoal))
        let newWidth = progressBtn.frame.width * CGFloat(percentage)
        progressBg.frame.size.width = newWidth
        progressBgWidth.constant = newWidth
    }

    // add a Done button on the numpad for dailyGoal
    func addDoneButtonOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self, action: #selector(dailyGoalDone))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        dailyGoal.inputAccessoryView = keyboardToolbar
        
    }
    
    // Done button handler
    @objc func dailyGoalDone(){
        dailyGoal.resignFirstResponder()
        if let goalSteps = Int64(dailyGoal.text!){
            if goalSteps >= 0{
                dailyStepsGoal = goalSteps
                let stepsLeft = dailyStepsGoal - numOfStepsToday
                if stepsLeft > 0 {
                    stepsToGoal.text = "\(stepsLeft) steps left"
                }else{
                    stepsToGoal.text = "ready to launch!"
                }
                configModel.dailyGoal = goalSteps
                updateBtnProgress()
            }
        }
    }

    // launch game view
    @IBAction func launchGameTouchedL(_ sender: Any) {
        if (numOfStepsToday < dailyStepsGoal) {
            let dialogMessage = UIAlertController(title: "More steps required!", message: "You cannot launch the game before you reach your daily step goal!", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK",style: .default)
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            return
        }
    }
    
    // update the progress bar
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.updateBtnProgress()
        }
           
    }
}


