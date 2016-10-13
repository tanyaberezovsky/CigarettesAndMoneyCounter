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
open class CigaretteRecord: NSManagedObject {

    @NSManaged var cigarettes: NSNumber
    @NSManaged var levelAsNeeded: NSNumber
    @NSManaged var levelOfEnjoy: NSNumber
    @NSManaged var addDate: Date
    @NSManaged var reason: String
    @NSManaged var cost: Double
    
    func yearMonth()-> String{
        
        let components = (Calendar.current as NSCalendar).components(
            [.month, .year], from: addDate)
        
        var strMonthYear:String
        strMonthYear = "\(components.year)-\(components.month)"
        
        
        return strMonthYear
    }
    
    func year()-> String{
        
        let components = (Calendar.current as NSCalendar).components(
             .year, from: addDate)
        
        
        return "\(components.year)"

    }
    
  
   open var groupByMonth: String{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM"
            return dateFormatter.string(from: self.addDate)
        }
    }
    
    
   open var fetchedResultsController: NSFetchedResultsController<CigaretteRecord> = {
        //let fetchRequest = NSFetchRequest(entityName: "CigaretteRecord")
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CigaretteRecord")
    
        let sort = NSSortDescriptor(key: "addDate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        fetchRequest.fetchBatchSize = 20
    
    let expressionSumCigarettes = NSExpressionDescription()
    expressionSumCigarettes.name = "sumOftotalCigarettes"
    expressionSumCigarettes.expression = NSExpression(forFunction: "sum:",
                                                      arguments:[NSExpression(forKeyPath: "cigarettes")])
    expressionSumCigarettes.expressionResultType = .integer32AttributeType
    
    fetchRequest.propertiesToFetch = [expressionSumCigarettes]
    fetchRequest.resultType = .dictionaryResultType
    
        let result = NSFetchedResultsController<CigaretteRecord>(fetchRequest: fetchRequest as! NSFetchRequest<CigaretteRecord>, managedObjectContext: (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!, sectionNameKeyPath: "groupByMonth", cacheName: nil)
    

        return result
    }()
}

//http://stackoverflow.com/questions/32776375/grouping-core-data-with-nsfetchedresultscontroller-in-swift   
 
