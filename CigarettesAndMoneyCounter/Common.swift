//
//  Common.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 5/24/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import Foundation

import UIKit

let delegateApplication = UIApplication.shared.delegate as! AppDelegate

func isNumeric(_ a: String) -> Bool {
    if (Int(a) != nil) == true {
        return true
    } else {
        return Double(a) != nil
    }
}


func createSmokeText(_ unitTimeValue:NSInteger, unitName:String) -> String
{
    var unitName1 = unitName
    if unitTimeValue == 1 {  unitName1 = unitName.substring(to: unitName.characters.index(unitName.endIndex, offsetBy: -1))}
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

func calculateLastCigaretTime(_ earlierDate: Date)  -> (txtLastCig: String, bLastCigWasToday: Bool){
    
    let laterDate = Date()
    var bLastCigWasToday:Bool = true
    
    if(!Calendar.current.isDateInToday(earlierDate)){
        bLastCigWasToday  = false    }
    
    let components = (Calendar.current as NSCalendar).components([.second, .minute, .hour, .day, .month, .year], from: earlierDate,
        to: laterDate, options: [])
    
    var arrStrDate = [String]()
    var retStr:String = "LAST CIGARETTE"
    retStr = ""
    var counter = 0;
    
    
    if components.year!>0 {
        arrStrDate.append(createSmokeText(components.year!, unitName:"YEARS")); bLastCigWasToday=false;
        if components.month!>0 {arrStrDate.append(createSmokeText(components.month!, unitName:"MONTHS")); bLastCigWasToday=false;}
        counter += 1
    }
    else if components.month!>0 {arrStrDate.append(createSmokeText(components.month!, unitName:"MONTHS")); bLastCigWasToday=false;
        if components.day!>0 {arrStrDate.append(createSmokeText(components.day!, unitName:"DAYS")); bLastCigWasToday=false;}
    }
    else if components.day!>0 {arrStrDate.append(createSmokeText(components.day!, unitName:"DAYS")); bLastCigWasToday=false;
        if components.hour!>0 {arrStrDate.append(createSmokeText(components.hour!, unitName:"HOURS"))}
    }
    else{
        if components.hour!>0 {arrStrDate.append(createSmokeText(components.hour!, unitName:"HOURS"))
         if components.minute!>0 {arrStrDate.append(" \(components.minute!) MIN")}
        }
        else if components.minute!>0 {arrStrDate.append(createSmokeText(components.minute!, unitName:"MINUTES"))}
    }
    if arrStrDate.count == 0
    {retStr = "JUST SMOKED A CIGARETTE"}
    else
    {retStr +=  arrStrDate.joined(separator: "") + " FREE OF SMOKING"//" AGO"
    }
    
    return (retStr, bLastCigWasToday)
}

func decimalFormatToString(_ num: Double) -> String{
    if (num.truncatingRemainder(dividingBy: 1) == 0)
    {
        return String(format: "%.0f", num)
    }
    else
    {
        return String(format: "%.1f", num)
    }
}


func decimalIsInteger(_ num: Double) -> Bool{
    if (num.truncatingRemainder(dividingBy: 1) == 0)
    {
        return true
    }
    else
    {
        return false
    }
}

func decimalFormatToCurency(_ num: Double) -> String{
    let unitedStatesLocale = Locale(identifier: "en_US")

    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    
    numberFormatter.locale = unitedStatesLocale
    return    numberFormatter.string(from: NSNumber(value: num))!


}

public func cigarettesToPackDescription(_ cigs: Int, sufix: String) -> String
{ 

    var ret = sufix
    let defaults:UserDefaultsDataController = UserDefaultsDataController.sharedInstance
    let userDefaults:UserDefaults = defaults.loadUserDefaults()
    
    let cigsInPack = userDefaults.amountOfCigarettsInOnePack
        
    if (cigsInPack < cigs)
    {
        let packs = cigs/cigsInPack
        
        if(packs >= 2){
            ret = "%@ (%d PACKS)"
        }
        else{
            ret = "%@ (%d PACK)"}
        
        ret = NSString(format:ret as NSString, sufix, packs) as String
    }
    
    return ret

}

public func segmentToDays(_ segment: Int) -> Double
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

func AverageOfSmokingTimeDescription(_ totalSigs: Double, segment: Int) -> NSMutableAttributedString{
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
            smokingSigTime =  (smokingSigTimeMinets - (smokingSigTimeMinets.truncatingRemainder(dividingBy: 60))) / 60
            
            text += String(format: "%.0f", smokingSigTime) + " HOURS AND "
            
            smokingSigTime = smokingSigTimeMinets.truncatingRemainder(dividingBy: 60)
            
            text += String(format: "%.0f", smokingSigTime) + " MINUTES"
        }
    }
    
    myMutableString = NSMutableAttributedString(string: text)
    
    myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: NSRange(location:13, length: text.characters.count - 13))

    return myMutableString;
}
