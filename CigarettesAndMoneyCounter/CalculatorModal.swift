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

        
   internal func calculateCost()-> Double
    {
        
        return totalCiggarets * (packCost / 20)
    }
   

    internal func a(a1: Double) -> Double
    {
        return 2
    }

}