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

    // MARK: =====UI Outlets=====
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var stepCounter: UISlider!
    @IBOutlet weak var debugLabel: UILabel!
    
    // MARK: =====UI Lifecycle=====
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.startActivityMonitoring()
        self.startPedometerMonitoring()
    }


    // MARK: =====Motion Methods=====
    func startActivityMonitoring(){
        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
            // update from this queue (should we use the MAIN queue here??.... )
            self.activityManager.startActivityUpdates(to: OperationQueue.main)
            {(activity:CMMotionActivity?)->Void in
                // unwrap the activity and display
                // using the real time pedometer influences how often we get activity updates...
                // so these updates can come through less often than we may want
                if let unwrappedActivity = activity {
                    // Print if we are walking or running
                    print("%@",unwrappedActivity.description)
                    self.activityLabel.text = "🚶: \(unwrappedActivity.walking), 🏃: \(unwrappedActivity.running)"
                }
            }
        }
        
    }
    
    func startPedometerMonitoring(){
        // check if pedometer is okay to use
        if CMPedometer.isStepCountingAvailable(){
            // start updating the pedometer from the current date and time
            pedometer.startUpdates(from: Date())
            {(pedData:CMPedometerData?, error:Error?)->Void in
                
                // if no errors, update the main UI
                if let data = pedData {
                    
                    // display the output directly on the phone
                    DispatchQueue.main.async {
                        // this goes into the large gray area on view
                        self.debugLabel.text = "\(data.description)"
                        
                        // this updates the slider with number of steps
                        self.stepCounter.value = data.numberOfSteps.floatValue
                    }
                }
            }
        }
    }


}

