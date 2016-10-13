//
//  RGB.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 8/28/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import Foundation
import UIKit

//class RGB:UIColor {}
extension UIColor{
    

    convenience init(r: Int, g:Int , b:Int , alpha: Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(alpha)/255)
    }

     convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        
        self.init(red: CGFloat(red),green: CGFloat(green),blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
        class func MainColor() -> UIColor {
            return UIColor(red: CGFloat(24 / 255) , green: CGFloat(135 / 255), blue: CGFloat( 208 / 255), alpha: CGFloat(1))

        }
}
