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

//extension UINavigationController{
//    
//    public override func shouldAutorotate() -> Bool {
//    
//            return false
//    }
//    
//}

//extension UINavigationControllerDelegate {
//    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask {
//        return [UIInterfaceOrientationMask.Portrait, .PortraitUpsideDown]
//    }
//    
//    
//}

        
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    

}


extension Date {
    func monthAndYear(_ addDate1: Date) -> String {
    //    var txtMonthYear: String
        
        let components = (Calendar.current as NSCalendar).components(
            [.month, .year], from: addDate1)
        
        var strMonthYear:String
        strMonthYear = "\(components.month)-\(components.year)"
        
        //print(strMonthYear)
        
        return strMonthYear
    }
    
    func endOfMonth() -> Date? {
        let components: DateComponents = DateComponents()
        (components as NSDateComponents).setValue(-1, forComponent: NSCalendar.Unit.day);
        (components as NSDateComponents).setValue(1, forComponent: NSCalendar.Unit.month);
        
        let expirationDate = (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: NSCalendar.Options(rawValue: 0))
        return expirationDate
        
    }
  
    
}

public func ==(lhs: Date, rhs: Date) -> Bool {
    return  lhs.compare(rhs) == .orderedSame
}

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
}

//extension Date { }



//2015-08-28 add gradient to nav-bar
extension CAGradientLayer {
    class func gradientLayerForBounds(_ bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [colorNavigationBarTop.cgColor, colorNavigationBarBottom.cgColor]
        return layer
    }
}
