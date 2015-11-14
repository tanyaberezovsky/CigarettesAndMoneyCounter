//
//  CigaretteRecordManager.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 11/4/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import UIKit
import CoreData

class CigaretteRecordManager {
    
    let MyManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    func saveCigaretteRecordEntityFromDefaultsValues() {
        
       let addedCigs = 1
        
        let entityDescripition = NSEntityDescription.entityForName("CigaretteRecord", inManagedObjectContext: MyManagedObjectContext!)
        
        let task = CigaretteRecord(entity: entityDescripition!, insertIntoManagedObjectContext:  MyManagedObjectContext)
        
        var defaults = UserDefaultsDataController()
        var userDefaults = UserDefaults()
        userDefaults = defaults.loadUserDefaults()
        
        
        task.cigarettes = addedCigs
        
        task.levelOfEnjoy = userDefaults.levelOfEnjoyment
        task.levelAsNeeded  = userDefaults.levelAsNeeded
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        let nowDate = NSDate()
        task.addDate = nowDate
        task.reason = ""
        
        MyManagedObjectContext?.save(nil)
        
       
        defaults.saveLastAddedCig(nowDate, todaySmoked: userDefaults.todaySmoked + addedCigs)
    }

}