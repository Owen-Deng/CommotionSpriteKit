//
//  ViewController.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//
// Our team name is Trio , and Member is Chuanqi Deng, Rongwei Ji, Yunfeng Huang.

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
    @IBOutlet weak var todaySteps: UILabel!
    @IBOutlet weak var yesterdaySteps: UILabel!
    @IBOutlet weak var stepsToGoal: UILabel!
    @IBOutlet weak var currentStatus: UILabel!
    @IBOutlet weak var dailyGoal: UITextField!
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
                self.yesterdaySteps.text! += " \(steps)"
            }
        }
        // update today's steps
        motionModel.updateTodaySteps(){(steps:Int64) in
            DispatchQueue.main.async { [self] in
                numOfStepsToday = steps
                self.todaySteps.text! = "Today's steps: \(numOfStepsToday)"
                stepsToGoal.text = "Steps to daily goal: \(max(0, dailyStepsGoal - numOfStepsToday))"
            }
        }
        // update status
        motionModel.updateCurrentStatus(){(statusText:String) in
            DispatchQueue.main.async {
                self.currentStatus.text! = "Current status: \(statusText)"
            }
        }
        
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
            dailyStepsGoal = goalSteps
            stepsToGoal.text = "Steps to daily goal: \(max(0, dailyStepsGoal - numOfStepsToday))"
            configModel.dailyGoal = goalSteps
        }
    }

}


