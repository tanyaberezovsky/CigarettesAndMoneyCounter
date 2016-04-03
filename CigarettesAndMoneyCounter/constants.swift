//
//  constants.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 8/28/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import Foundation
import UIKit

let colorNavigationBarTop = RGB(41, 128, 185, alpha: 1)
let colorNavigationBarBottom = RGB(34, 160, 145, alpha: 1)

let colorNavigationBarBlack = RGB(24, 25, 35, alpha: 1)

let colorNavigationBarDarkPurpleGray = RGB(65, 62, 75, alpha: 1)


let colorSegmentTint = RGB(239, 239, 244, alpha: 1)

let colorSegmentBackground = RGB(0 , 184, 156, alpha: 1)

struct UIColors{
    struct  CircleLoaderColors {
        static  let yellow = RGB(234 , 240, 142, alpha: 1)
        static  let red = RGB(234 , 97, 157, alpha: 1)
        static  let red1 = RGB(246 , 0, 62, alpha: 1)

    }
    
    struct Segment {
        static  let selected = RGB(66 , 62, 76, alpha: 1)
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


/*
struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}


struct Resolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}
*/