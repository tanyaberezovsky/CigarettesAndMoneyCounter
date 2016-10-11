//
//  HorizontalBarChartFormatter.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 10/10/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit
import Foundation
import Charts

@objc(HorizontalBarChartFormatter)
public class HorizontalBarChartFormatter: NSObject, IAxisValueFormatter{
    
    open var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
}


