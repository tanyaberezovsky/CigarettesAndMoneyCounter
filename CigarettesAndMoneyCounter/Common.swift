//
//  Common.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 5/24/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import Foundation

import UIKit

func isNumeric(a: String) -> Bool {
    return Int(a) != nil
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
    
    let laterDate = NSDate()
    var bLastCigWasToday:Bool = true
    
    let components = NSCalendar.currentCalendar().components([.Second, .Minute, .Hour, .Day, .Month, .Year], fromDate: earlierDate,
        toDate: laterDate, options: [])
    
    var arrStrDate = [String]()
    var retStr:String = ""
    
    if components.year>0 {arrStrDate.append(" \(components.year) Years"); bLastCigWasToday=false;}
    if components.month>0 {arrStrDate.append(" \(components.month) Months"); bLastCigWasToday=false;}
    if components.day>0 {arrStrDate.append(" \(components.day) Days"); bLastCigWasToday=false;}
    if components.hour>0 {arrStrDate.append(" \(components.hour) Hours")}
    if components.minute>0 {arrStrDate.append(" \(components.minute) Minutes")}
    
    if arrStrDate.count == 0
    {retStr = "Just smoked a cigarette"}
    else
    {retStr +=  arrStrDate.joinWithSeparator("") + " Free of Smoking"}
    
    return (retStr, bLastCigWasToday)
}

func decimalFormatToString(num: Double) -> String{
    if (num % 1 == 0)
    {
        return String(format: "%.0f", num)
    }
    else
    {
        return String(format: "%.1f", num)
    }
}


func decimalIsInteger(num: Double) -> Bool{
    if (num % 1 == 0)
    {
        return true
    }
    else
    {
        return false
    }
}


public func segmentToDays(segment: Int) -> Double
{
    var ret: Double = 1
    
    switch segment{
    case 1:
        ret = 7
    case 2:
        ret = 30
    case 3:
        ret = 360
    default:
        break
    }
    return ret
}

func AverageOfSmokingTimeDescription(totalSigs: Double, segment: Int) -> String{
    var text: String = "Average smoking time "
    
    //var days = segmentToDays(segment)
    
    let smokingSigTimeMinets: Double = (Double(5) * totalSigs)
    var smokingSigTime: Double = smokingSigTimeMinets / 60
    
    if(decimalIsInteger(smokingSigTime))
    {
        text += decimalFormatToString(smokingSigTime) + " hours"
    }
    else
    {
        if (smokingSigTimeMinets < 60){
            text += String(format: "%.0f", smokingSigTimeMinets) + " minets"
        }
        else{
            smokingSigTime =  (smokingSigTimeMinets - (smokingSigTimeMinets % 60)) / 60
            
            text += String(format: "%.0f", smokingSigTime) + " hours and "
            
            smokingSigTime = smokingSigTimeMinets % 60
            
            text += String(format: "%.0f", smokingSigTime) + " minets"
        }
    }
    return text;
}
