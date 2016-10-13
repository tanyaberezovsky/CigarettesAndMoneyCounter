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

        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.5, alpha: 0.9)

        // Status bar white font
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = UIColor.lightGray
    }
    //colorNavigationBarDarkPurpleGray
    //black bar
    func perpleBar() {
        
        UINavigationBar.appearance().barTintColor = colorNavigationBarDarkPurpleGray
        UINavigationBar.appearance().isTranslucent = false
        UIBarButtonItem.appearance().tintColor = UIColor.white
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        // Status bar white font
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = UIColor.lightGray
    }

    //black bar
    func blackBar() {
        
        UINavigationBar.appearance().barTintColor = colorNavigationBarBlack
        UINavigationBar.appearance().isTranslucent = false
        UIBarButtonItem.appearance().tintColor = UIColor.lightGray
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        // Status bar white font
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = UIColor.lightGray
    }
    
    func gradientBar(){
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white
        let fontDictionary = [ NSForegroundColorAttributeName:UIColor.white ]
        self.navigationBar.titleTextAttributes = fontDictionary
        self.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        //colored the iphone upper font bar to white
        self.navigationBar.barStyle = UIBarStyle.black
    }
    
    fileprivate func imageLayerForGradientBackground() -> UIImage {
        var updatedFrame = self.navigationBar.bounds
        // take into account the status bar
        updatedFrame.size.height += 20
        let layer = CAGradientLayer.gradientLayerForBounds(updatedFrame)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func segueForUnwinding(to toViewController: UIViewController,
        from fromViewController: UIViewController,
        identifier: String?) -> UIStoryboardSegue {
            return UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController) {
                let fromView = fromViewController.view
                let toView = toViewController.view
                if let containerView = fromView?.superview {
                    let initialFrame = fromView?.frame
                    var offscreenRect = initialFrame
                  //  offscreenRect.origin.x -= CGRectGetWidth(initialFrame)
                    offscreenRect?.origin.y -= (initialFrame?.height)!
                    toView?.frame = offscreenRect!
                    containerView.addSubview(toView!)
                    // Being explicit with the types NSTimeInterval and CGFloat are important
                    // otherwise the swift compiler will complain
                    var duration: TimeInterval = 0.4
                   
                    UIView.animate(withDuration: duration, animations: {
                            toView?.frame = initialFrame!
                        }, completion: { finished in
                            toView?.removeFromSuperview()
                            if let navController = toViewController.navigationController {
                                navController.popToViewController(toViewController, animated: false)
                            }
                    })
                    
                    duration = 1.0
                }
            }
    }

}
