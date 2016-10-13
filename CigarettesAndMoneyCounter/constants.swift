//
//  constants.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 8/28/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import Foundation
import UIKit

let colorNavigationBarTop = UIColor(r: 41, g: 128, b: 185, alpha: 1)
let colorNavigationBarBottom = UIColor(r: 34, g: 160, b: 145, alpha: 1)

let colorNavigationBarBlack = UIColor(r: 24,g: 25,b: 35, alpha: 1)

let colorNavigationBarDarkPurpleGray = UIColor(r: 65, g: 62, b: 75, alpha: 1)


let colorSegmentTint = UIColor(r: 239, g: 239,b: 244, alpha: 1)

let colorSegmentBackground = UIColor(r: 0 ,g: 184,b: 156, alpha: 1)

struct UIColors{
    struct  CircleLoaderColors {
        static  let yellow = UIColor(r: 234 ,g: 240,b: 142, alpha: 1)
        static  let red = UIColor(r: 234 ,g: 97,b: 157, alpha: 1)
        static  let red1 = UIColor(r: 246 ,g: 0,b: 62, alpha: 1)

    }
    
    struct Segment {
        static  let selected = UIColor(r: 66 ,g: 62,b: 76, alpha: 1)
    }
    
    
    struct GreenAddButton {
        static  let green = UIColor(r: 41 ,g: 215,b: 134, alpha: 1)
    }
    
    
    

}

struct Constants{

    struct SegmentDateType
    {
        static let day = "day"
        static let week = "week"
        static let month = "month"
        static let year = "year"
    }
    
    struct dateFormat
    {
        static let day = "dd MMMM yyyy"
        static let week = "dd MMMM yyyy"
        static let month = "MMMM yyyy"
        static let year = "yyyy"
    }
}

