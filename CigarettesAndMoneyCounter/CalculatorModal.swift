//
//  CalculatorModal.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 7/12/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import Foundation

//model
class Calculator{
    
var dailyCiggarets:Double = 1
//var packCost:Double = 1

    //Key-Value-Observing (KVO) define Property Observers
    //Property Observers are not called during Initialization
    func setValue(ciggarets: Double, segment: Int)
    {
        self.dailyCiggarets = ciggarets / segmentToDays(segment)
        // call recalculate function
        // fireEvent to update GUI
    }
    
    var packCost: Double = 0.0{
        willSet
        {
            println("About to set status to:  \(newValue)")
        }
        didSet
        {
            if packCost != oldValue
            {
         //       postNewStatusNotification()
            }
        }
    }
    /*
    func setValue(packCost: Double)
    {
        self.packCost = packCost
        // call recalculate function
        // fireEvent to update GUI
    }
    */
    func segmentToDays(segment: Int) -> Double
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

    func getValues(segment: Int)-> (Double, Double)
    {
    
        return (dailyCiggarets * segmentToDays(segment), packCost * segmentToDays(segment))
    }
    
}