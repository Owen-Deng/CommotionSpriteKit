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
    
    // MARK: class variables
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()

    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var stepCounter: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.startActivityMonitoring()
        self.startPedometerMonitoring()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startActivityMonitoring(){
        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
            // update from this queue (should we use the MAIN queue here??.... )
            self.activityManager.startActivityUpdates(to: OperationQueue.main)
            {(activity:CMMotionActivity?)->Void in
                // unwrap the activity and dispaly
                if let unwrappedActivity = activity {
                    print("%@",unwrappedActivity.description)
                    self.activityLabel.text = "Walking: \(unwrappedActivity.walking)"
                }
            }
        }
        
    }
    
    func startPedometerMonitoring(){
        if CMPedometer.isStepCountingAvailable(){
            pedometer.startUpdates(from: Date())
            {(pedData:CMPedometerData?, error:NSError?)->Void in
                if pedData != nil {
                    print("\(pedData!.description)")
                    self.stepCounter.value = (pedData?.numberOfSteps.floatValue)!
                }
            } as! CMPedometerHandler as! CMPedometerHandler as! CMPedometerHandler as! CMPedometerHandler as! CMPedometerHandler as! CMPedometerHandler as! CMPedometerHandler
        }
    }


}

