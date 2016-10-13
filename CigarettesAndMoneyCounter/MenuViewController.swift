//
//  MenuViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 05/03/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBAction func SettingaTouch(_ sender: AnyObject) {
    }

    @IBAction func AbouteTouch(_ sender: AnyObject) {
    }
    
    @IBAction func calculatorTouch(_ sender: AnyObject) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalc" || segue.identifier == "showSettings" || segue.identifier == "showAbout"
        {
             navigateToRoot(self, toViewController: segue.destination)
        }
    }
    
    func navigateToRoot(_ viewController: UIViewController, toViewController: UIViewController)
    {
        var nc = viewController.navigationController
        
        // If this is a normal view with NavigationController, then we just pop to root.
        if nc != nil
        {
            _ = nc?.popToRootViewController(animated: true)
        }
        
        // Most likely we are in Modal view, so we will need to search for a view with NavigationController.
        let vc = viewController.presentingViewController
        
        if nc == nil
        {
            nc = viewController.presentingViewController?.navigationController
        }
        
        if nc == nil
        {
            nc = viewController.parent?.navigationController
        }
        
        if vc is UINavigationController
        {
            nc = vc as? UINavigationController
        }
        
        if nc != nil
        {
            viewController.dismiss(animated: false, completion:nil)
            let fromViewController: AnyObject = (nc?.viewControllers[0])!

            
            let fromView = fromViewController.view as UIView!
            let toView: UIView = toViewController.view as UIView!
            if let containerView = fromView?.superview {
                let initialFrame = fromView?.frame
                var offscreenRect = initialFrame
                offscreenRect?.origin.y += (initialFrame?.height)!
                toView.frame = offscreenRect!
                containerView.addSubview(toView)
        
                
            
            // Being explicit with the types NSTimeInterval and CGFloat are important
            // otherwise the swift compiler will complain
            let duration: TimeInterval = 0.4
            
            UIView.animate(withDuration: duration, animations: {
                toView.frame = initialFrame!
                }, completion: { finished in
                    nc!.viewControllers.append(toViewController)
                    nc!.popToViewController(toViewController, animated: false)
                    
                    
            })
        }
    }
  
    }
    
    
}
