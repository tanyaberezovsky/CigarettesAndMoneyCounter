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
        return NumberFormatter().number(from: self)?.doubleValue
    }
    

}


extension Date {
    func monthAndYear(_ addDate1: Date) -> String {
        
        let components = (Calendar.current as NSCalendar).components(
            [.month, .year], from: addDate1)
        
        var strMonthYear:String
        strMonthYear = "\(components.month)-\(components.year)"
        
        
        return strMonthYear
    }
    
    func startOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }
    
    func endOfMonth() -> Date? {
        var comp: DateComponents = Calendar.current.dateComponents([.month, .day, .hour], from: Calendar.current.startOfDay(for: self))
        comp.month = 1
        comp.day = -1
        return Calendar.current.date(byAdding: comp, to: self.startOfMonth()!)
    }
  
    
}

public func ==(lhs: Date, rhs: Date) -> Bool {
    return  lhs.compare(rhs) == .orderedSame
}

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
}




//2015-08-28 add gradient to nav-bar
extension CAGradientLayer {
    class func gradientLayerForBounds(_ bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [colorNavigationBarTop.cgColor, colorNavigationBarBottom.cgColor]
        return layer
    }
}
