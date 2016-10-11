//
//  BarChartFormatter.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 10/10/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit
import Foundation
import Charts

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter{
    
    var months: [String]! = ["Level 0", "Level 1", "Level 2", "Level 3"]
    
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return months[Int(value)]
    }
}

