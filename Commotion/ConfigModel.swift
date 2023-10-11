//
//  ConfigModel.swift
//  Commotion
//
//  Created by Owen on 10/10/23.
//  Copyright © 2023 Eric Larson. All rights reserved.
//

import UIKit

class ConfigModel: NSObject {
    static var sharedInstance = ConfigModel()
    override init() {
        UserDefaults.standard.register(defaults: ["dailyGoal" : 500])
    }
    var dailyGoal:Int64{
        get{
           return Int64(UserDefaults.standard.integer(forKey: "dailyGoal"))
        }
        set(goal){
            
            UserDefaults.standard.setValue(goal, forKey: "dailyGoal")
        }
    }
}
