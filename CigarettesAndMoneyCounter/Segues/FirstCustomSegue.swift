//
//  FirstCustomSegue.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/13/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import UIKit
import CoreData

class FirstCustomSegue:UIStoryboardSegue {
    
    override func perform() {
        
        let fromViewController: AnyObject = self.source
        let toViewController: AnyObject = self.destination
    
        let fromView = fromViewController.view as UIView!
        let toView: UIView = toViewController.view as UIView!
        if let containerView = fromView?.superview {
            let initialFrame = fromView?.frame
            var offscreenRect = initialFrame
            offscreenRect?.origin.y += (initialFrame?.height)!
            toView.frame = offscreenRect!
            containerView.addSubview(toView)
            
            let navCtr  = fromViewController.navigationController as UINavigationController!
            
            // Being explicit with the types NSTimeInterval and CGFloat are important
            // otherwise the swift compiler will complain
            let duration: TimeInterval = 0.4
            
            UIView.animate(withDuration: duration, animations: {
                toView.frame = initialFrame!
                }, completion: { finished in
                    navCtr?.viewControllers.append(toViewController as! UIViewController)
                   _ =  navCtr?.popToViewController(toViewController as! UIViewController, animated: false)

            })
            
           
        }
        
    }
}

