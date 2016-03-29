//
//  UserDefaultsDataController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/20/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import Foundation


class UserDefaults{
    
    class func newInstance() -> UserDefaults {
        return UserDefaults();
    }
    
    var levelAsNeeded = 0
    var levelOfEnjoyment = 0
    var dailyGoal = 0
    var todaySmoked = 0
    var dateLastCig: NSDate!
    var reason: String!
    var minimalModeOn: Bool!
    var averageCostOfOnePack = 0.0
    var averageCostOfOneCigarett = 0.0
    var amountOfCigarettsInOnePack = 0
}

class UserDefaultsDataController{
    
    class func newInstance() -> UserDefaultsDataController {
        return UserDefaultsDataController();
    }
  
    //++++++++++++++++++++++++++++++++++++
    //  will save user defaults
    //++++++++++++++++++++++++++++++++++++
      func saveUserDefaults(userDefaults: UserDefaults) {
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
  //      userDefaults.levelAsNeeded = 10
        
        defaults.setInteger(userDefaults.levelAsNeeded, forKey: "levelAsNeeded")
        
        defaults.setInteger(userDefaults.levelOfEnjoyment, forKey: "levelOfEnjoyment")
    
        defaults.setInteger(userDefaults.dailyGoal, forKey: "dailyGoal")
    
        defaults.setDouble(userDefaults.averageCostOfOnePack, forKey: "averageCostOfOnePack")
        
        defaults.setDouble(userDefaults.averageCostOfOneCigarett, forKey: "averageCostOfOneCigarett")
 
        
        defaults.setInteger(userDefaults.amountOfCigarettsInOnePack, forKey: "amountOfCigarettsInOnePack")
 
        defaults.setValue(userDefaults.reason, forKey: "reason")
        
        defaults.setValue(userDefaults.minimalModeOn, forKey: "minimalModeOn")
        
    }
    
    @objc  func saveLastAddedCig(lastDateCig: NSDate, todaySmoked: Int) {
        
        if lastDateCig.timeIntervalSinceNow.isSignMinus {
            //myDate is earlier than Now (date and time)
        } else {
            //myDate is equal or after than Now (date and time)
        }
        if newDateIsLatest(lastDateCig){

            let defaults = NSUserDefaults.standardUserDefaults()
        
            defaults.setObject(todaySmoked, forKey: "todaySmoked")

            defaults.setObject(lastDateCig, forKey: "dateLastCig")
        }
    }
    
    func newDateIsLatest(newDate: NSDate) -> Bool
    {
        //Get Current Date/Time
        let currentDateTime = NSDate()

        var ret = false;
        let defaults = UserDefaultsDataController()
        var userDefaults = UserDefaults()
        userDefaults = defaults.loadUserDefaults()
        
        if let lastCig = userDefaults.dateLastCig{
            if newDate >= lastCig && newDate <= currentDateTime {
                ret = true
            }
        }
        else
        {
            if newDate <= currentDateTime {
                ret = true
            }
        }
        
        return ret;
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  load user defaults into object
    //++++++++++++++++++++++++++++++++++++
      func loadUserDefaults() -> UserDefaults{
        
        let userDefaults = UserDefaults()
        
        let defaults = NSUserDefaults.standardUserDefaults()
       // println(defaults)
        //println(defaults.integerForKey("levelAsNeeded"))
        
        if (defaults.objectForKey("levelAsNeeded") == nil) {
           //then it loads for the first time
            //init defaults values for start up
            userDefaults.dailyGoal = 10
            userDefaults.averageCostOfOnePack = 10
            userDefaults.amountOfCigarettsInOnePack = 20
            userDefaults.averageCostOfOneCigarett = 10 / 20
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
       
            userDefaults.amountOfCigarettsInOnePack = defaults.integerForKey("amountOfCigarettsInOnePack")
            userDefaults.averageCostOfOneCigarett = defaults.doubleForKey("averageCostOfOneCigarett")
                
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