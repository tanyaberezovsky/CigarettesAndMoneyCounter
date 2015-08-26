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
class CigaretteRecord: NSManagedObject {

    @NSManaged var cigarettes: NSNumber
    @NSManaged var levelAsNeeded: NSNumber
    @NSManaged var levelOfEnjoy: NSNumber
    @NSManaged var addDate: NSDate
    @NSManaged var reason: String
    
    func yearMonth()-> String{
        var txtMonthYear: String
        
        let components = NSCalendar.currentCalendar().components(
            .CalendarUnitMonth | .CalendarUnitYear, fromDate: addDate)
        
        var strMonthYear:String
        strMonthYear = "\(components.year)-\(components.month)"
        
        println(strMonthYear)
        
        return strMonthYear
    }
    
    func year()-> String{
        var txtMonthYear: String
        
        let components = NSCalendar.currentCalendar().components(
             .CalendarUnitYear, fromDate: addDate)
        
        
        return "\(components.year)"

    }
    
    
}



