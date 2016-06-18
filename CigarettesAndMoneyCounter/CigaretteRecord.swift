//
//  CigaretteRecord.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 12/20/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import Foundation
import CoreData

/*record that will fetched from coredata*/
public class CigaretteRecord: NSManagedObject {

    @NSManaged var cigarettes: NSNumber
    @NSManaged var levelAsNeeded: NSNumber
    @NSManaged var levelOfEnjoy: NSNumber
    @NSManaged var addDate: NSDate
    @NSManaged var reason: String
    @NSManaged var cost: Double
    
    func yearMonth()-> String{
    //    var txtMonthYear: String
        
        let components = NSCalendar.currentCalendar().components(
            [.Month, .Year], fromDate: addDate)
        
        var strMonthYear:String
        strMonthYear = "\(components.year)-\(components.month)"
        
        //print(strMonthYear)
        
        return strMonthYear
    }
    
    func year()-> String{
      //  var txtMonthYear: String
        
        let components = NSCalendar.currentCalendar().components(
             .Year, fromDate: addDate)
        
        
        return "\(components.year)"

    }
    
  
   public var groupByMonth: String{
        get{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM"
            return dateFormatter.stringFromDate(self.addDate)
        }
    }
    
    
   public var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "CigaretteRecord")
        
        let sort = NSSortDescriptor(key: "addDate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        fetchRequest.fetchBatchSize = 20
    
    let expressionSumCigarettes = NSExpressionDescription()
    expressionSumCigarettes.name = "sumOftotalCigarettes"
    expressionSumCigarettes.expression = NSExpression(forFunction: "sum:",
                                                      arguments:[NSExpression(forKeyPath: "cigarettes")])
    expressionSumCigarettes.expressionResultType = .Integer32AttributeType
    
    fetchRequest.propertiesToFetch = [expressionSumCigarettes]
    fetchRequest.resultType = .DictionaryResultType
    
    
        let result = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!, sectionNameKeyPath: "groupByMonth", cacheName: nil)
        //result.delegate = self
        
        return result
    }()
}

//http://stackoverflow.com/questions/32776375/grouping-core-data-with-nsfetchedresultscontroller-in-swift   
  /* var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "CigaretteRecord")
        
        let sort = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        fetchRequest.fetchBatchSize = 20
        
        let result = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.childManagedObjectContext!, sectionNameKeyPath: CigaretteRecord.groupByMonth, cacheName: nil)
        result.delegate = self
        
        return result
    }()*/


