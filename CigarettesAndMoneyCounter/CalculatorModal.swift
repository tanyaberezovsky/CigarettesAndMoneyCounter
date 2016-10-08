//
//  CalculatorModal.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 7/12/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import Foundation


//In order to make an object observable, it adopts the following protocol:
//2016-07-30
protocol PropertyObservable {
    associatedtype PropertyType
    var propertyChanged: Event<PropertyType> { get }
}


enum CalculatorProperty {
    case packCost, cigsPerPack, totalCiggarets, segment// totalCost
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
                propertyChanged.raise(.totalCiggarets)

            }
        }
    }
    
    dynamic fileprivate var dailyCiggarets: Double = 1
        {
        didSet {
            if self.dailyCiggarets != oldValue
            {
                propertyChanged.raise(.totalCiggarets)
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
                propertyChanged.raise(.packCost)
            //}
        }
    }

    dynamic var cigsPerPack: Int = 1
        {
        didSet {
            // if packCost != oldValue
            //{
            propertyChanged.raise(.cigsPerPack)
            //}
        }
    }
        //
    
   internal func calculateCost()-> Double
    {
        
        return totalCiggarets * (packCost / Double( cigsPerPack))
    }
   

    internal func a(_ a1: Double) -> Double
    {
        return 2
    }

}
