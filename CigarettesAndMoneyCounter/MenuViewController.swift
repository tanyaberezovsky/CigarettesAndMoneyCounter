//
//  MenuViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 05/03/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBAction func SettingaTouch(sender: AnyObject) {
    }

    @IBAction func AbouteTouch(sender: AnyObject) {
    }
    
    @IBAction func calculatorTouch(sender: AnyObject) {

       
/*
        let secondVC: AnyObject = CalculatorViewController()
        let navCtr  = sender.parentmodalViewController .navigationController as UINavigationController!
        
        sender.parentViewController.
        //
        //
        navCtr.pushViewController(secondVC as! UIViewController, animated: false)*/
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCalc" || segue.identifier == "showSettings" || segue.identifier == "showAbout"
        {
             navigateToRoot(self, toViewController: segue.destinationViewController)
        }
    }
    
    func navigateToRoot(viewController: UIViewController, toViewController: UIViewController)
    {
        var nc = viewController.navigationController
        
        // If this is a normal view with NavigationController, then we just pop to root.
        if nc != nil
        {
            nc?.popToRootViewControllerAnimated(true)
        }
        
        // Most likely we are in Modal view, so we will need to search for a view with NavigationController.
        let vc = viewController.presentingViewController
        
        if nc == nil
        {
            nc = viewController.presentingViewController?.navigationController
        }
        
        if nc == nil
        {
            nc = viewController.parentViewController?.navigationController
        }
        
        if vc is UINavigationController
        {
            nc = vc as? UINavigationController
        }
        
        if nc != nil
        {
            viewController.dismissViewControllerAnimated(false, completion:nil)
//nc!.pushViewController(destinationViewController , animated: false)
            let fromViewController: AnyObject = (nc?.viewControllers[0])!//.parentViewController!

            
            let fromView = fromViewController.view as UIView!
            let toView: UIView = toViewController.view as UIView!
            if let containerView = fromView.superview {
                let initialFrame = fromView.frame
                var offscreenRect = initialFrame
                offscreenRect.origin.y += CGRectGetHeight(initialFrame)
                toView.frame = offscreenRect
                containerView.addSubview(toView)
        
                
            
            // Being explicit with the types NSTimeInterval and CGFloat are important
            // otherwise the swift compiler will complain
            let duration: NSTimeInterval = 0.4
            
            UIView.animateWithDuration(duration, animations: {
                toView.frame = initialFrame
                }, completion: { finished in
                    nc!.viewControllers.append(toViewController)
                    nc!.popToViewController(toViewController, animated: false)
                    
                    
            })
        }
    }
  
    }
    
    
}
