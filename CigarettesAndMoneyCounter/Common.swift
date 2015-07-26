//
//  Common.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 5/24/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import Foundation



func isNumeric(a: String) -> Bool {
    return a.toInt() != nil
}


/*
reseive date and return string
if date was in past hour
return: last cigarette was x minutes ago
if date was in last 24 hours
return: last cigarette was x hours x minutes ago
if date was in last month - 30 days
return: last cigarette was x days x hours x minutes ago
if date was in last year
return: last cigarette was x month x days x hours x minutes ago
if date was sooner then last year
return: last cigarette was x years x month x days x hours x minutes ago
}
*/

func calculateLastCigaretTime(earlierDate: NSDate)  -> (txtLastCig: String, bLastCigWasToday: Bool){
    
    var laterDate = NSDate()
    var bLastCigWasToday:Bool = true
    
    let components = NSCalendar.currentCalendar().components(.CalendarUnitSecond |
        .CalendarUnitMinute | .CalendarUnitHour | .CalendarUnitDay |
        .CalendarUnitMonth | .CalendarUnitYear, fromDate: earlierDate,
        toDate: laterDate, options: nil)
    
    var arrStrDate = [String]()
    var retStr:String = "last cigarette was"
    
    if components.year>0 {arrStrDate.append(" \(components.year) years"); bLastCigWasToday=false;}
    if components.month>0 {arrStrDate.append(" \(components.month) months"); bLastCigWasToday=false;}
    if components.day>0 {arrStrDate.append(" \(components.day) days"); bLastCigWasToday=false;}
    if components.hour>0 {arrStrDate.append(" \(components.hour) hours")}
    if components.minute>0 {arrStrDate.append(" \(components.minute) minutes")}
    
    if arrStrDate.count == 0
    {retStr += " just now"}
        else
    {retStr +=  "".join(arrStrDate) + " ago"}
    
    return (retStr, bLastCigWasToday)
}
