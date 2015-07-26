//
//  CalculatorModal.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 7/12/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import Foundation


//In order to make an object observable, it adopts the following protocol:
protocol PropertyObservable {
    typealias PropertyType
    var propertyChanged: Event<PropertyType> { get }
}


enum CalculatorProperty {
    case PackCost, TotalCiggarets, Segment// totalCost
}

//model
class Calculator{
    
    typealias PropertyType = CalculatorProperty
    let propertyChanged = Event<CalculatorProperty>()
    
    dynamic var segment: Int = 0
    {
        didSet {
            if segment != oldValue
            {
                totalCiggarets = dailyCiggarets * segmentToDays(segment)
                propertyChanged.raise(.TotalCiggarets)

            }
        }
    }
    
    dynamic private var dailyCiggarets: Double = 1
        {
        didSet {
            if self.dailyCiggarets != oldValue
            {
                propertyChanged.raise(.TotalCiggarets)
            }
        }
    }
    
    dynamic var totalCiggarets: Double = 1
    {
        didSet {
            if self.totalCiggarets != oldValue
            {
                dailyCiggarets = self.totalCiggarets / segmentToDays(segment)
            }
            
           // propertyChanged.raise(.TotalCiggarets)
            
        }
    }
    
    dynamic var packCost: Double = 1.0
        {
        didSet {
           // if packCost != oldValue
            //{
                propertyChanged.raise(.PackCost)
            //}
        }
    }

    
//    dynamic var totalCost: Double = 0.0
//    {
//        set{
//                return calculateCost()
//        }
//    }

//    lazy var totalCost: Double = calculateCost()
    
   internal func calculateCost()-> Double
    {
        
        return totalCiggarets * (packCost / 20)
    }
    
    private func segmentToDays(segment: Int) -> Double
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

    internal func a(a1: Double) -> Double
    {
        return 2
    }
//var packCost:Double = 1

    //Key-Value-Observing (KVO) define Property Observers
    //Property Observers are not called during Initialization
  /*  func setValue(ciggarets: Double, segment: Int)
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
   
    func getValues(segment: Int)-> (Double, Double)
    {
    
        return (dailyCiggarets * segmentToDays(segment), packCost * segmentToDays(segment))
    }
    */
}