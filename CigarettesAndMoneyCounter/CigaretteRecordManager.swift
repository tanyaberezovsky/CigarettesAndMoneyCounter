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
    
    let MyManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
 
    
    func saveCigaretteRecordEntity(_ levelOfEnjoyment:Int, levelAsNeeded:Int, reason:String) {
        let defaults:UserDefaultsDataController = UserDefaultsDataController.sharedInstance
    
        let userDefaults:UserDefaults = defaults.loadUserDefaults()
        
   
        
       let addedCigs = 1
        
        let entityDescripition = NSEntityDescription.entity(forEntityName: "CigaretteRecord", in: MyManagedObjectContext!)
        
        let task = CigaretteRecord(entity: entityDescripition!, insertInto:  MyManagedObjectContext)
        
        
        //2015-12-16 into cigarettes save the cost of ciggarets
        task.cigarettes = NSNumber(value: addedCigs)
        
        task.cost = userDefaults.averageCostOfOneCigarett

        task.levelOfEnjoy = NSNumber(value: levelOfEnjoyment)
        task.levelAsNeeded  = NSNumber(value: levelAsNeeded)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        let nowDate = Date()
        task.addDate = nowDate
        task.reason = reason
        
        do {
            try MyManagedObjectContext?.save()
            MyManagedObjectContext?.reset()
        } catch _ {
        }
        
        var todaySmoked = 1
    
        
        if let lastCig = userDefaults.dateLastCig{
            let calcRet = calculateLastCigaretTime(lastCig)
            if calcRet.bLastCigWasToday == true{
                todaySmoked = userDefaults.todaySmoked + 1
            }
        }
        defaults.saveLastAddedCig(nowDate, todaySmoked: todaySmoked)
        
    
    }

    
    
    func  calculateAmountAndCost(_ fromDate: Date, toDate: Date) -> (smoked:Int, cost: Double)
    {
        //where condition
        let predicate = NSPredicate(format:"%@ >= addDate AND %@ <= addDate", toDate as CVarArg, fromDate as CVarArg)
        
        var smoked:Int = 0
        var cost:Double = 0
        
        let expressionSumCigarettes = NSExpressionDescription()
        expressionSumCigarettes.name = "sumOftotalCigarettes"
        expressionSumCigarettes.expression = NSExpression(forFunction: "sum:",
            arguments:[NSExpression(forKeyPath: "cigarettes")])
        expressionSumCigarettes.expressionResultType = .integer32AttributeType
      
        
        let expressionSumCost = NSExpressionDescription()
        expressionSumCost.name = "sumCost"
        expressionSumCost.expression = NSExpression(forFunction: "sum:",
            arguments:[NSExpression(forKeyPath: "cost")])
        expressionSumCost.expressionResultType = .doubleAttributeType
        
        
        let expresionCount = NSExpressionDescription()
        expresionCount.name = "countLines"
        expresionCount.expression = NSExpression(forFunction: "count:", arguments: [NSExpression.expressionForEvaluatedObject()])
        expresionCount.expressionResultType = .integer32AttributeType
        
//    and then a fetch request which fetches only this sum:
       let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CigaretteRecord")
        fetchRequest.propertiesToFetch = [expressionSumCigarettes, expressionSumCost, expresionCount]
        fetchRequest.resultType = .dictionaryResultType
        
       fetchRequest.predicate = predicate
        
        
        do {
            let result:NSArray = try self.MyManagedObjectContext!.fetch(fetchRequest) as NSArray //as! [DictionaryResultType]

            
            if (result.count > 0) {
             
                
                if let a = (result[0] as AnyObject).value(forKey: "sumOftotalCigarettes") as? NSNumber {
                    let aString = a.stringValue
                    smoked = Int(aString)!
                } else {
                    // either d doesn't have a value for the key "a", or d does but the value is not an NSNumber
                }

                
                if let a = (result[0] as AnyObject).value(forKey: "sumCost") as? NSNumber {
                    let aString = a.stringValue
                    cost = Double(aString)!
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
    func  calculateGraphDataByFieldName(_ fromDate: Date, toDate: Date, fieldName: String, orderByField: String = "cigarettes") -> NSArray
    {
        //where condition
        let predicate = NSPredicate(format:"%@ >= addDate AND %@ <= addDate", toDate as CVarArg, fromDate as CVarArg)
        
        
        let expressionSumCigarettes = NSExpressionDescription()
        expressionSumCigarettes.name = "sumOftotalCigarettes"
        expressionSumCigarettes.expression = NSExpression(forFunction: "sum:",
            arguments:[NSExpression(forKeyPath: "cigarettes")])
        expressionSumCigarettes.expressionResultType = .integer32AttributeType
       
        
                //    and then a fetch request which fetches only this sum:
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CigaretteRecord")
        fetchRequest.propertiesToFetch = [ fieldName, expressionSumCigarettes]
        fetchRequest.resultType = .dictionaryResultType
        
        fetchRequest.predicate = predicate
        
        fetchRequest.propertiesToGroupBy = [fieldName]
        
        let sort = NSSortDescriptor(key: orderByField, ascending: true)
        fetchRequest.sortDescriptors = [sort]

        var result:NSArray = NSArray()
        
        do {
            result = try self.MyManagedObjectContext!.fetch(fetchRequest ) as NSArray
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return result
        }
        return result
        
    }
    //field name = reason/
    func  calculateGraphDataByExpresion(_ fromDate: Date, toDate: Date, orderByField: String = "cigarettes") -> NSArray
    {
        //where condition
        let predicate = NSPredicate(format:"%@ >= addDate AND %@ <= addDate", toDate as CVarArg, fromDate as CVarArg)
        
        
        let expressionSumCigarettes = NSExpressionDescription()
        expressionSumCigarettes.name = "sumOftotalCigarettes"
        expressionSumCigarettes.expression = NSExpression(forFunction: "sum:",
                                                          arguments:[NSExpression(forKeyPath: "cigarettes")])
        expressionSumCigarettes.expressionResultType = .integer32AttributeType
        
        
        //    and then a fetch request which fetches only this sum:
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CigaretteRecord")
        fetchRequest.propertiesToFetch = [ expressionSumCigarettes]
        fetchRequest.resultType = .dictionaryResultType
        
        fetchRequest.predicate = predicate
        
        
        let sort = NSSortDescriptor(key: orderByField, ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        var result:NSArray = NSArray()
        
        do {
            result = try self.MyManagedObjectContext!.fetch(fetchRequest) as NSArray
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return result
        }
        return result
        
    }
    
    
    
    //field name = reason/
    func  calculateHorizontalGraphDataByFieldName(_ fromDate: Date, toDate: Date, fieldName: String, orderByField: String = "cigarettes") -> NSArray
    {
        
        let cigRec:CigaretteRecord = CigaretteRecord()
        
        do {
            try cigRec.fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        let resultArr:NSArray = NSArray()
        
        return resultArr
        
         }
    
    
    //http://stackoverflow.com/questions/32776375/grouping-core-data-with-nsfetchedresultscontroller-in-swift

}
