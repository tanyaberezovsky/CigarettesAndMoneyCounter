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
       // gradientBar()
       perpleBar()
    }
    
    func opacityBar() {

       // UINavigationBar.appearance().barTintColor = colorNavigationBarBlack
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().translucent = true
        //UIBarButtonItem.appearance().tintColor = UIColor.lightGrayColor()
        //UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.5, alpha: 0.9)

        // Status bar white font
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.lightGrayColor()
    }
    //colorNavigationBarDarkPurpleGray
    //black bar
    func perpleBar() {
        
        UINavigationBar.appearance().barTintColor = colorNavigationBarDarkPurpleGray
        UINavigationBar.appearance().translucent = false
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        // Status bar white font
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.lightGrayColor()
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
        let layer = CAGradientLayer.gradientLayerForBounds(updatedFrame)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func segueForUnwindingToViewController(toViewController: UIViewController,
        fromViewController: UIViewController,
        identifier: String?) -> UIStoryboardSegue {
            return UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController) {
                let fromView = fromViewController.view
                let toView = toViewController.view
                if let containerView = fromView.superview {
                    let initialFrame = fromView.frame
                    var offscreenRect = initialFrame
                  //  offscreenRect.origin.x -= CGRectGetWidth(initialFrame)
                    offscreenRect.origin.y -= CGRectGetHeight(initialFrame)
                    toView.frame = offscreenRect
                    containerView.addSubview(toView)
                    // Being explicit with the types NSTimeInterval and CGFloat are important
                    // otherwise the swift compiler will complain
                    var duration: NSTimeInterval = 0.4
                   
                    UIView.animateWithDuration(duration, animations: {
                            toView.frame = initialFrame
                        }, completion: { finished in
                            toView.removeFromSuperview()
                            if let navController = toViewController.navigationController {
                                navController.popToViewController(toViewController, animated: false)
                            }
                    })
                    
                    duration = 1.0
//                    let delay: NSTimeInterval = 0.0
//                    let options = UIViewAnimationOptions.CurveEaseInOut
//                    let damping: CGFloat = 0.5
//                    let velocity: CGFloat = 4.0
//                    UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping,
//                        initialSpringVelocity: velocity, options: options, animations: {
//                            toView.frame = initialFrame
//                        }, completion: { finished in
//                            toView.removeFromSuperview()
//                            if let navController = toViewController.navigationController {
//                                navController.popToViewController(toViewController, animated: false)
//                            }
//                    })
                }
            }
    }

}
