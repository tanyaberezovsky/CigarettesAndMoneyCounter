//
//  String.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 12/7/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
    

}


extension NSDate {
    func monthAndYear(addDate1: NSDate) -> String {
    //    var txtMonthYear: String
        
        let components = NSCalendar.currentCalendar().components(
            [.Month, .Year], fromDate: addDate1)
        
        var strMonthYear:String
        strMonthYear = "\(components.month)-\(components.year)"
        
        //print(strMonthYear)
        
        return strMonthYear
    }
    
    func endOfMonth() -> NSDate? {
        let components: NSDateComponents = NSDateComponents()
        components.setValue(-1, forComponent: NSCalendarUnit.Day);
        components.setValue(1, forComponent: NSCalendarUnit.Month);
        
        let expirationDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self, options: NSCalendarOptions(rawValue: 0))
        return expirationDate
        
    }

}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }



//2015-08-28 add gradient to nav-bar
extension CAGradientLayer {
    class func gradientLayerForBounds(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [colorNavigationBarTop.CGColor, colorNavigationBarBottom.CGColor]
        return layer
    }
}

extension UIColor {
    class func rgb(r r: Double, g: Double, b: Double, alpha: Double) -> UIColor{
        // UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
        
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
    class func MainColor() -> UIColor {
        return UIColor.rgb(r: 24, g: 135, b: 208, alpha: 1.0)
    }
}
