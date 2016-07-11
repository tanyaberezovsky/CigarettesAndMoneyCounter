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


func createSmokeText(unitTimeValue:NSInteger, unitName:String) -> String
{
    var unitName1 = unitName
    if unitTimeValue == 1 {  unitName1 = unitName.substringToIndex(unitName.endIndex.advancedBy(-1))}
    return " \(unitTimeValue) \(unitName1)"
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
    
    if(!NSCalendar.currentCalendar().isDateInToday(earlierDate)){
        bLastCigWasToday  = false    }
    
    let components = NSCalendar.currentCalendar().components([.Second, .Minute, .Hour, .Day, .Month, .Year], fromDate: earlierDate,
        toDate: laterDate, options: [])
    
    var arrStrDate = [String]()
    var retStr:String = "LAST CIGARETTE"
    var counter = 0;
    
    if components.year>0 {
        arrStrDate.append(createSmokeText(components.year, unitName:"EARS")); bLastCigWasToday=false;
        if components.month>0 {arrStrDate.append(createSmokeText(components.month, unitName:"MONTHS")); bLastCigWasToday=false;}
        counter += 1
    }
    else if components.month>0 {arrStrDate.append(createSmokeText(components.month, unitName:"MONTHS")); bLastCigWasToday=false;
        if components.day>0 {arrStrDate.append(createSmokeText(components.day, unitName:"DAYS")); bLastCigWasToday=false;}
    }
    else if components.day>0 {arrStrDate.append(createSmokeText(components.day, unitName:"DAYS")); bLastCigWasToday=false;
        if components.hour>0 {arrStrDate.append(createSmokeText(components.hour, unitName:"HOURS"))}
    }
    else{
        if components.hour>0 {arrStrDate.append(createSmokeText(components.hour, unitName:"HOURS"))
         if components.minute>0 {arrStrDate.append(" \(components.minute) MIN")}
        }
        else if components.minute>0 {arrStrDate.append(createSmokeText(components.minute, unitName:"MINUTES"))}
    }
    
    if arrStrDate.count == 0
    {retStr = "JUST SMOKED A CIGARETTE"}
    else
    {retStr +=  arrStrDate.joinWithSeparator("") + " AGO"}
    
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

func decimalFormatToCurency(num: Double) -> String{
    let unitedStatesLocale = NSLocale(localeIdentifier: "en_US")

    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
    
    numberFormatter.locale = unitedStatesLocale
    return    numberFormatter.stringFromNumber(num)!


}

public func cigarettesToPackDescription(cigs: Int, sufix: String) -> String
{

    let defaults = UserDefaultsDataController()
    //var userDefaults = UserDefaults()
   
    var ret = sufix
    if let userDefaults:UserDefaults = defaults.loadUserDefaults(){
        
    let cigsInPack = userDefaults.amountOfCigarettsInOnePack
        
    if (cigsInPack < cigs)
    {
        let packs = cigs/cigsInPack
        
        if(packs >= 2){
            ret = "%@ (%d PACKS)"
        }
        else{
            ret = "%@ (%d PACK)"}
        
        ret = NSString(format:ret, sufix, packs) as String
    }
    }
    return ret

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

func AverageOfSmokingTimeDescription(totalSigs: Double, segment: Int) -> NSMutableAttributedString{
    var text: String = "SMOKING TIME "
    var myMutableString = NSMutableAttributedString()
    //var days = segmentToDays(segment)
   
    let smokingSigTimeMinets: Double = (Double(5) * totalSigs)
    var smokingSigTime: Double = smokingSigTimeMinets / 60
    
    if(decimalIsInteger(smokingSigTime))
    {
        text += decimalFormatToString(smokingSigTime) + " HOURS"
    }
    else
    {
        if (smokingSigTimeMinets < 60){
            text += String(format: "%.0f", smokingSigTimeMinets) + " MINUTES"
        }
        else{
            smokingSigTime =  (smokingSigTimeMinets - (smokingSigTimeMinets % 60)) / 60
            
            text += String(format: "%.0f", smokingSigTime) + " HOURS AND "
            
            smokingSigTime = smokingSigTimeMinets % 60
            
            text += String(format: "%.0f", smokingSigTime) + " MINUTES"
        }
    }
    
    myMutableString = NSMutableAttributedString(string: text)
    
    myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColors.GreenAddButton.green, range: NSRange(location:13, length: text.characters.count - 13))

    return myMutableString;
}
