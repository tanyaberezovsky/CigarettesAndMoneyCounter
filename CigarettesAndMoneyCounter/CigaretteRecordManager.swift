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
        
        //2015-12-16 into cigarettes save the cost of ciggarets
        task.cigarettes = addedCigs
        
        task.cost = userDefaults.averageCostOfOneCigarett

        task.levelOfEnjoy = userDefaults.levelOfEnjoyment
        task.levelAsNeeded  = userDefaults.levelAsNeeded
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        let nowDate = NSDate()
        task.addDate = nowDate
        task.reason = userDefaults.reason
        
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

    
    
    func  calculateAmountAndCost(fromDate: NSDate, toDate: NSDate) -> (smoked:Int32, cost: Double)
    {
        //where condition
        let predicate = NSPredicate(format:"%@ >= addDate AND %@ <= addDate", toDate, fromDate)
        
        var smoked:Int32 = 0
        var cost:Double = 0
        
        let expressionSumCigarettes = NSExpressionDescription()
        expressionSumCigarettes.name = "sumOftotalCigarettes"
        expressionSumCigarettes.expression = NSExpression(forFunction: "sum:",
            arguments:[NSExpression(forKeyPath: "cigarettes")])
        expressionSumCigarettes.expressionResultType = .Integer32AttributeType
      
        
        let expressionSumCost = NSExpressionDescription()
        expressionSumCost.name = "sumCost"
        expressionSumCost.expression = NSExpression(forFunction: "sum:",
            arguments:[NSExpression(forKeyPath: "cost")])
        expressionSumCost.expressionResultType = .DoubleAttributeType
        
        
        let expresionCount = NSExpressionDescription()
        expresionCount.name = "countLines"
        expresionCount.expression = NSExpression(forFunction: "count:", arguments: [NSExpression.expressionForEvaluatedObject()])
        expresionCount.expressionResultType = .Integer32AttributeType
        
//    and then a fetch request which fetches only this sum:
        
        let fetchRequest = NSFetchRequest(entityName: "CigaretteRecord")
        fetchRequest.propertiesToFetch = [expressionSumCigarettes, expressionSumCost, expresionCount]
        fetchRequest.resultType = .DictionaryResultType
        
       fetchRequest.predicate = predicate
        
        
        do {
            let result:NSArray = try self.MyManagedObjectContext!.executeFetchRequest(fetchRequest) //as! [DictionaryResultType]

            
            if (result.count > 0) {
             
                if let a = result[0].valueForKey("countLines") as? NSNumber {
                    let aString = a.stringValue
                    print(aString) // -1
                } else {
                    // either d doesn't have a value for the key "a", or d does but the value is not an NSNumber
                }
                
                if let a = result[0].valueForKey("sumOftotalCigarettes") as? NSNumber {
                    let aString = a.stringValue
                    smoked = Int32(aString)!
                    print(aString) // -1
                } else {
                    // either d doesn't have a value for the key "a", or d does but the value is not an NSNumber
                }

                
                if let a = result[0].valueForKey("sumCost") as? NSNumber {
                    let aString = a.stringValue
                    cost = Double(aString)!
                    print(aString) // -1
                } else {
                    // either d doesn't have a value for the key "a", or d does but the value is not an NSNumber
                }

            }

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return (0, 0)
        }
        return (smoked, cost)

    }
    
    
    //field name = reason/
    func  calculateGraphDataByFieldName(fromDate: NSDate, toDate: NSDate, fieldName: String, orderByField: String = "cigarettes") -> NSArray
    {
        //where condition
        let predicate = NSPredicate(format:"%@ >= addDate AND %@ <= addDate", toDate, fromDate)
        
        
        let expressionSumCigarettes = NSExpressionDescription()
        expressionSumCigarettes.name = "sumOftotalCigarettes"
        expressionSumCigarettes.expression = NSExpression(forFunction: "sum:",
            arguments:[NSExpression(forKeyPath: "cigarettes")])
        expressionSumCigarettes.expressionResultType = .Integer32AttributeType
        
        
                //    and then a fetch request which fetches only this sum:
        
        let fetchRequest = NSFetchRequest(entityName: "CigaretteRecord")
        fetchRequest.propertiesToFetch = [ fieldName, expressionSumCigarettes]
        fetchRequest.resultType = .DictionaryResultType
        
        fetchRequest.predicate = predicate
        
        fetchRequest.propertiesToGroupBy = [fieldName]
        
        let sort = NSSortDescriptor(key: orderByField, ascending: false)
        fetchRequest.sortDescriptors = [sort]

        var result:NSArray = NSArray()
        
        do {
            result = try self.MyManagedObjectContext!.executeFetchRequest(fetchRequest) //as! [DictionaryResultType]
            
            
//            if (result.count > 0) {
//                
//                if let a = result[0].valueForKey("countLines") as? NSNumber {
//                    let aString = a.stringValue
//                    print(aString) // -1
//                } else {
//                    // either d doesn't have a value for the key "a", or d does but the value is not an NSNumber
//                }
//                
//                if let a = result[0].valueForKey("sumOftotalCigarettes") as? NSNumber {
//                    let aString = a.stringValue
//                    smoked = Int32(aString)!
//                    print(aString) // -1
//                } else {
//                    // either d doesn't have a value for the key "a", or d does but the value is not an NSNumber
//                }
//                
//                
//                if let a = result[0].valueForKey("sumCost") as? NSNumber {
//                    let aString = a.stringValue
//                    cost = Double(aString)!
//                    print(aString) // -1
//                } else {
//                    // either d doesn't have a value for the key "a", or d does but the value is not an NSNumber
//                }
//                
//            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return result
        }
        return result
        
    }
}