//
//  String.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 12/7/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
    

}


extension NSDate {
    func monthAndYear(addDate1: NSDate) -> String {
        var txtMonthYear: String
        
        let components = NSCalendar.currentCalendar().components(
            .CalendarUnitMonth | .CalendarUnitYear, fromDate: addDate1)
        
        var strMonthYear:String
        strMonthYear = "\(components.month)-\(components.year)"
        
        println(strMonthYear)
        
        return strMonthYear
    }
}