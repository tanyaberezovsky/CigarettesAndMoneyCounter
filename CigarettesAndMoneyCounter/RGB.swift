//
//  RGB.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 8/28/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import Foundation
import UIKit

class RGB:UIColor {
    init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat) {
        super.init(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: alpha)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        self.init(CGFloat(red), CGFloat(green), CGFloat(blue), alpha: CGFloat(alpha))
    }

}
/*
let view = UIView(frame: CGRect(x: 0,y: 0,width: 400,height: 400))
let color = RGB(255, 255, 0, alpha: 1)
view.backgroundColor = color

*/