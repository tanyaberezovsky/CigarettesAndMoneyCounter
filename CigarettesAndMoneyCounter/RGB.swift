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
    
  /*  convenience public init (R: CGFloat, G: CGFloat, B: CGFloat, alpha: CGFloat = 1) {
        self.init(red: R/255, green: G/255, blue: B/255, alpha: alpha)
    }
    */
    convenience init(r: Int, g:Int , b:Int , alpha: Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(alpha)/255)
    }

     convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        
        self.init(red: CGFloat(red),green: CGFloat(green),blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
        class func MainColor() -> UIColor {
            return UIColor(red: CGFloat(24 / 255) , green: CGFloat(135 / 255), blue: CGFloat( 208 / 255), alpha: CGFloat(1))

        //    return init(r: 24, g: 135, b: 208, alpha: 1)
        }

/*
    override init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat) {
        super.init(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: alpha)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        self.init(CGFloat(red), CGFloat(green), CGFloat(blue), alpha: CGFloat(alpha))
    }

    @nonobjc required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
    }

    @nonobjc required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
    }

    @nonobjc required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
    }

    @nonobjc required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
    }

    @nonobjc required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
    }

    @nonobjc required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
    }

    @nonobjc required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
    }*/

}
/*
let view = UIView(frame: CGRect(x: 0,y: 0,width: 400,height: 400))
let color = RGB(255, 255, 0, alpha: 1)
view.backgroundColor = color

*/
