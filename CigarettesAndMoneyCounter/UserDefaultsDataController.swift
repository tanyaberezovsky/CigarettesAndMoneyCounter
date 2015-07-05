//
//  UserDefaultsDataController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/20/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import Foundation


@objc class UserDefaults{
    
    class func newInstance() -> UserDefaults {
        return UserDefaults();
    }
    
    var levelAsNeeded = 0
    var levelOfEnjoyment = 0
    var averageCostOfOnePack = 0.0
    var dailyGoal = 0
    var todaySmoked = 0
    var dateLastCig: NSDate!
}

@objc class UserDefaultsDataController{
    
    class func newInstance() -> UserDefaultsDataController {
        return UserDefaultsDataController();
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  will save user defaults
    //++++++++++++++++++++++++++++++++++++
    @objc  func saveUserDefaults(userDefaults: UserDefaults) {
        
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
  //      userDefaults.levelAsNeeded = 10
        
        defaults.setInteger(userDefaults.levelAsNeeded, forKey: "levelAsNeeded")
        
        defaults.setInteger(userDefaults.levelOfEnjoyment, forKey: "levelOfEnjoyment")
    
        defaults.setInteger(userDefaults.dailyGoal, forKey: "dailyGoal")
    
        defaults.setDouble(userDefaults.averageCostOfOnePack, forKey: "averageCostOfOnePack")
        
    }
    
    @objc  func saveLastAddedCig(lastDateCig: NSDate, todaySmoked: Int) {
        
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(todaySmoked, forKey: "todaySmoked")

        defaults.setObject(NSDate(), forKey: "dateLastCig")
        
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  load user defaults into object
    //++++++++++++++++++++++++++++++++++++
    @objc  func loadUserDefaults() -> UserDefaults{
        
        var userDefaults = UserDefaults()
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        
        userDefaults.levelAsNeeded = defaults.integerForKey("levelAsNeeded")
        
        userDefaults.levelOfEnjoyment = defaults.integerForKey("levelOfEnjoyment")
        userDefaults.dailyGoal = defaults.integerForKey("dailyGoal")
        userDefaults.averageCostOfOnePack = defaults.doubleForKey("averageCostOfOnePack")
        userDefaults.todaySmoked = defaults.integerForKey("todaySmoked")
        if let d:NSDate = defaults.objectForKey("dateLastCig") as? NSDate{
            userDefaults.dateLastCig = d
        }
        
        return userDefaults
    }
    
}