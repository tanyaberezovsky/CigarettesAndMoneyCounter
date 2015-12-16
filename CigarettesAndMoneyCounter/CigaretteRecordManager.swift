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
        
        let defaults = UserDefaultsDataController()
        var userDefaults = UserDefaults()
        userDefaults = defaults.loadUserDefaults()
        
        
        task.cigarettes = addedCigs
        
        task.levelOfEnjoy = userDefaults.levelOfEnjoyment
        task.levelAsNeeded  = userDefaults.levelAsNeeded
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        let nowDate = NSDate()
        task.addDate = nowDate
        task.reason = ""
        
        do {
            try MyManagedObjectContext?.save()
        } catch _ {
        }
        
        var todaySmoked = 0
        
        if let lastCig = userDefaults.dateLastCig{
            let calcRet = calculateLastCigaretTime(lastCig)
            if calcRet.bLastCigWasToday == true{
                todaySmoked = userDefaults.todaySmoked + 1
            }
            else
            {
                todaySmoked = 1
            }
            
        }
        
       
        defaults.saveLastAddedCig(nowDate, todaySmoked: todaySmoked)
    }

    func  calculateAmountAndCost()
    {
//        You create an "expression description" for the sum of all totalWorkTimeInHours values:
        
        let expressionDesc = NSExpressionDescription()
        expressionDesc.name = "sumOftotalCigarettes"
        expressionDesc.expression = NSExpression(forFunction: "sum:",
            arguments:[NSExpression(forKeyPath: "cigarettes")])
        expressionDesc.expressionResultType = .Integer32AttributeType
        
        let expresionCount = NSExpressionDescription()
        expresionCount.name = "countLines"
        expresionCount.expression = NSExpression(forFunction: "count:", arguments: [NSExpression.expressionForEvaluatedObject()])
        expresionCount.expressionResultType = .Integer32AttributeType
        
//    and then a fetch request which fetches only this sum:
        
        let fetchRequest = NSFetchRequest(entityName: "CigaretteRecord")
        fetchRequest.propertiesToFetch = [expressionDesc, expresionCount]
        fetchRequest.resultType = .DictionaryResultType

        
        do {
            let result:NSArray = try self.MyManagedObjectContext!.executeFetchRequest(fetchRequest) //as! [DictionaryResultType]

            
            if (result.count > 0) {
             
                if let a = result[0].valueForKey("countLines")   as? NSNumber {
                    let aString = a.stringValue
                    print(aString) // -1
                } else {
                    // either d doesn't have a value for the key "a", or d does but the value is not an NSNumber
                }
                
                if let a = result[0].valueForKey("sumOftotalCigarettes")   as? NSNumber {
                    let aString = a.stringValue
                    print(aString) // -1
                } else {
                    // either d doesn't have a value for the key "a", or d does but the value is not an NSNumber
                }


//            let name1: String = result[0].valueForKey("sumOftotalCigarettes")  as! String
//            // let name1: Int32? = result[0].valueForKey("sumOftotalCigarettes") as? Int32
//                print("1 - \(name1)")
//                let name: String? = result[0].valueForKey("sumOftotalCigarettes") as? String
//                print("1 - \(name)")
                
                
//                let person = result[0] as CigaretteRecord
//                
//                
//                if let first = person.valueForKey("sumOftotalCigarettes"){
//                    print("\(first) ")
//                }
//                
//                print("2 - \(person)")
            }

//            var myArray = [AnyObject]()
//            
//            myArray = results[0] as Array<AnyObject>
//            
//        print(results[0]["sumOftotalCigarettes"])

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            //return nil
        }
        
//        let dict = results[0] as [String:Double]
//        let totalHoursWorkedSum = dict["sumOftotalWorkTimeInHours"]!

    }
}