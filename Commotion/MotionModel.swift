//
//  MotionModel.swift
//  Commotion
//
//  Created by Owen on 10/10/23.
//  Copyright © 2023 Eric Larson. All rights reserved.
//

import UIKit
import CoreMotion

class MotionModel: NSObject {
    static var sharedInstance = MotionModel()
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    // get yesterday's step
    func getYesterdaySteps(completion: @escaping (Int64) -> ()){
        if !CMPedometer.isStepCountingAvailable(){
            completion(Int64(-1))
            return
        }
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let startOfYesterday = Calendar.current.date(byAdding: .day, value: -1, to: startOfToday)
        
        // query yesterday's steps
        pedometer.queryPedometerData(from: startOfYesterday!, to: startOfToday) {(pdata:CMPedometerData?, erro:Error?) ->Void in
            if let data = pdata{
                completion(Int64(truncating: data.numberOfSteps))
            }
        }
    }
    
    // update today's steps
    func updateTodaySteps(update: @escaping (Int64) -> ()){
        if !CMPedometer.isStepCountingAvailable(){
            update(Int64(-1))
            return
        }
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let startOfNextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)
        
        // query today's steps
        pedometer.queryPedometerData(from: startOfToday, to: startOfNextDay!) {(pdata:CMPedometerData?, erro:Error?) ->Void in
            if let data = pdata{
                update(Int64(truncating: data.numberOfSteps))
            }
        }
        
        // query today's steps when step data updates
        pedometer.startUpdates(from: Date())
        { [self](pdata:CMPedometerData?, error:Error?)->Void in
            pedometer.queryPedometerData(from: startOfToday, to: startOfNextDay!) {(pdata:CMPedometerData?, erro:Error?) ->Void in
                if let data = pdata{
                    update(Int64(truncating: data.numberOfSteps))
                }
            }
        }
    }
    
    // update current status
    func updateCurrentStatus(update: @escaping (String) -> ()){
        if !CMMotionActivityManager.isActivityAvailable(){
            update("Unknown")
            return
        }
        
        // update from this queue (should we use the MAIN queue here??.... )
        activityManager.startActivityUpdates(to: OperationQueue.main)
        {(activity:CMMotionActivity?)->Void in
            // unwrap the activity and display
            // using the real time pedometer influences how often we get activity updates...
            // so these updates can come through less often than we may want
            var status:Array<String> = []
            if let unwrappedActivity = activity {
                // Print if we are walking or running
                //print("%@",unwrappedActivity.description)
                if unwrappedActivity.walking{
                    status.append("Walking")
                }
                if unwrappedActivity.running{
                    status.append("Running")
                }
                if unwrappedActivity.automotive{
                    status.append("Automotive")
                }
                if unwrappedActivity.cycling{
                    status.append("Cycling")
                }
                if unwrappedActivity.stationary{
                    status.append("Stationary")
                }
                if unwrappedActivity.unknown{
                    status.append("Unknown")
                }
            }
            if status.count >= 1{
                update(status.joined(separator: ",")) // None of above is true, set the status to unknown
            }else{
                update("Unknown")
            }
        }
    }
}
