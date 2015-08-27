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
    var reason: String!
    var minimalModeOn: Bool!
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
        
        defaults.setValue(userDefaults.reason, forKey: "reason")
        
        defaults.setValue(userDefaults.minimalModeOn, forKey: "minimalModeOn")
        
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
       // println(defaults)
        //println(defaults.integerForKey("levelAsNeeded"))
        
        if (defaults.objectForKey("levelAsNeeded") == nil) {
           //then it loads for the first time
            //init defaults values for start up
            userDefaults.dailyGoal = 10
            userDefaults.averageCostOfOnePack = 10
            userDefaults.levelAsNeeded = 2
            userDefaults.levelOfEnjoyment = 2
            userDefaults.todaySmoked = 0
            userDefaults.reason = defaultReason
            userDefaults.minimalModeOn = false
            saveUserDefaults(userDefaults)
        }
        else{
        userDefaults.levelAsNeeded = defaults.integerForKey("levelAsNeeded")
        
        userDefaults.levelOfEnjoyment = defaults.integerForKey("levelOfEnjoyment")
        userDefaults.dailyGoal = defaults.integerForKey("dailyGoal")
        userDefaults.averageCostOfOnePack = defaults.doubleForKey("averageCostOfOnePack")
        userDefaults.todaySmoked = defaults.integerForKey("todaySmoked")
            
            if let d:NSDate = defaults.objectForKey("dateLastCig") as? NSDate{
                userDefaults.dateLastCig = d
            }
            
            if let reason = defaults.objectForKey("reason") as? String{
                userDefaults.reason = reason
            }
            else
            {
                userDefaults.reason = defaultReason
                saveUserDefaults(userDefaults)
            }
            if let minimalModeOn = defaults.objectForKey("minimalModeOn") as? Bool{
                userDefaults.minimalModeOn = minimalModeOn
            }
            else
            {
                userDefaults.minimalModeOn = false
                saveUserDefaults(userDefaults)
            }
        }
        return userDefaults
    }
    
}