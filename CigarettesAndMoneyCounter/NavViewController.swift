//
//  NavViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 7/4/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

 
    
    //gradient bar
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientBar()
    }
    //black bar
    func blackBar() {
        
        UINavigationBar.appearance().barTintColor = colorNavigationBarBlack
        UINavigationBar.appearance().translucent = false
        UIBarButtonItem.appearance().tintColor = UIColor.lightGrayColor()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        // Status bar white font
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.lightGrayColor()
    }
    
    func gradientBar(){
      //  super.viewDidLoad()
        self.navigationBar.translucent = false
        self.navigationBar.tintColor = UIColor.whiteColor()
        let fontDictionary = [ NSForegroundColorAttributeName:UIColor.whiteColor() ]
        self.navigationBar.titleTextAttributes = fontDictionary
        self.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), forBarMetrics: UIBarMetrics.Default)
        //colored the iphone upper font bar to white
        self.navigationBar.barStyle = UIBarStyle.Black
    }
    
    private func imageLayerForGradientBackground() -> UIImage {
        var updatedFrame = self.navigationBar.bounds
        // take into account the status bar
        updatedFrame.size.height += 20
        var layer = CAGradientLayer.gradientLayerForBounds(updatedFrame)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
