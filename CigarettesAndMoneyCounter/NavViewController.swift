//
//  NavViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 7/4/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

    override func viewDidLoad() {
        
        var red = 24 / 255
        var green = 25 / 255
        var blue = 35 / 255
        var alpha: Double = 1.0
        var color: UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
        
        UINavigationBar.appearance().barTintColor = color
        
        
      //  UINavigationBar.appearance().backgroundColor = color// UIColor.greenColor()
       
//        red = 253 / 255
//        green = 253 / 255
//        blue = 253 / 255
//         color = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
        
        UIBarButtonItem.appearance().tintColor = UIColor.lightGrayColor()
       UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
      /*  let font: UIFont = UIFont()//(name: "fontName", size: 17)!
        let color2 = UIColor.orangeColor()
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: font,NSForegroundColorAttributeName: color2], forState: .Normal)
        
        // UINavigationBar.appearance().titleTextAttributes = [UITextAttributeTextColor: UIColor.blueColor()]
        UITabBar.appearance().backgroundColor = UIColor.yellowColor();
*/
        super.viewDidLoad()
        
        // Status bar white font
        self.navigationBar.barStyle = UIBarStyle.Black
       self.navigationBar.tintColor = UIColor.lightGrayColor()//whiteColor()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
