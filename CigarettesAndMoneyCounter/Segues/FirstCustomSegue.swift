//
//  FirstCustomSegue.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/13/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import UIKit
import CoreData

class FirstCustomSegue:
UIStoryboardSegue {
    
    override func perform() {
        
        var fromViewController: AnyObject = self.sourceViewController
        var toViewController: AnyObject = self.destinationViewController
    
        let fromView = fromViewController.view as UIView!
        let toView: UIView = toViewController.view as UIView!
        if let containerView = fromView.superview {
            let initialFrame = fromView.frame
            var offscreenRect = initialFrame
            offscreenRect.origin.y += CGRectGetHeight(initialFrame)
            toView.frame = offscreenRect
            containerView.addSubview(toView)
            
            var navCtr  = fromViewController.navigationController as UINavigationController!
            
            // Being explicit with the types NSTimeInterval and CGFloat are important
            // otherwise the swift compiler will complain
            var duration: NSTimeInterval = 0.4
            
            UIView.animateWithDuration(duration, animations: {
                toView.frame = initialFrame
                }, completion: { finished in
                    navCtr.viewControllers.append(toViewController)
                    navCtr.popToViewController(toViewController as! UIViewController, animated: false)

    
            })
            
           
        }
        
    }
}
  /*__________________________________________________*/

//    override func perform() {
//        let fromVC = sourceViewController as! UIViewController
//        let toVC = destinationViewController as! UIViewController
//
//
//        var vcs = fromVC.navigationController?.viewControllers
//        vcs?.append(toVC)
//
//        fromVC.navigationController?.setViewControllers(vcs,animated: true)
//
//    }
//


// toView.removeFromSuperview()
//if let navController = toViewController.navigationController {
// navController!.popToViewController(toViewController as! UIViewController, animated: false)
//}

//duration = 1.0
//let delay: NSTimeInterval = 0.0
//let options = UIViewAnimationOptions.CurveEaseInOut
//let damping: CGFloat = 0.5
//let velocity: CGFloat = 4.0
//                    UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping,
//                        initialSpringVelocity: velocity, options: options, animations: {
//                            toView.frame = initialFrame
//                        }, completion: { finished in
//                            toView.removeFromSuperview()
//                            if let navController = toViewController.navigationController {
//                                navController.popToViewController(toViewController, animated: false)
//                            }
//                    })


//   override func perform() {
//    let fromViewController: UIViewController = self.sourceViewController as! UIViewController
//        let toViewController: UIViewController = self.destinationViewController as! UIViewController
//        
//        
//        let containerView: UIView? = fromViewController.view.superview
//        let screenBounds: CGRect = UIScreen.mainScreen().bounds
////        
//        let finalToFrame: CGRect = screenBounds
//        //let finalFromFrame: CGRect = CGRectOffset(finalToFrame,0, -screenBounds.size.height)
////        
//        toViewController.view.frame = CGRectOffset(finalToFrame, 0, screenBounds.size.height)
//        containerView?.addSubview(toViewController.view)
////        
////
////        
//        var navCtr  = fromViewController.navigationController as UINavigationController!
////
////        
//       // var duplicatedSourceView: UIView = fromViewController.view.snapshotViewAfterScreenUpdates(false) // Create a screenshot of the old view.
//    
//        
//        //  navCtr.view.backgroundColor = UIColor.whiteColor()
//     //   navCtr.view.addSubview(duplicatedSourceView)
//        
//    navCtr.viewControllers.append(toViewController)
//        
//       
//
//        UIView.animateWithDuration(0.5, animations: {
//            
//            toViewController.view.frame = finalToFrame
////            fromViewController.view.frame = finalFromFrame
//           // fromViewController.view.alpha = 1.0
//            
//            }, completion: { finished in
//              //  let fromVC: UIViewController = self.sourceViewController as! UIViewController
//                //let toVC: UIViewController = self.destinationViewController as! UIViewController
//            
//
//
//                 //                   if let navController = toViewController.navigationController {
//                                       navCtr.popToViewController(toViewController, animated: false)
//               // }
//        })
//    }
//}

 /*__________________________________________________*/
//
//    override func perform() {
//        // Assign the source and destination views to local variables.
//        var firstVC: AnyObject = self.sourceViewController
//        var secondVC: AnyObject = self.destinationViewController
//        
//        
//        var firstVCView = firstVC.view as UIView!
//        var secondVCView = secondVC.view as UIView!
//  
//        
//        let screenHeight = UIScreen.mainScreen().bounds.size.height
//
//     
//        let initialFrame = firstVCView.frame
//        var offscreenRect = initialFrame
//        offscreenRect.origin.y -= CGRectGetHeight(initialFrame)
//        secondVCView.frame = offscreenRect
//        var navCtr  = firstVC.navigationController as UINavigationController!
//       navCtr.viewControllers.append(secondVC)
//
//       
//
//        // Animate the transition.
//        UIView.animateWithDuration(0.4, animations: { () -> Void in
//          //  firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, -screenHeight)
//            secondVCView.frame = CGRectOffset(secondVCView.frame, 0.0, -screenHeight)
//            
//            }) { (Finished) -> Void in
//                //secondVCView.removeFromSuperview()
//                if let navController = secondVC.navigationController {
//                    navController!.popToViewController(self.destinationViewController as! UIViewController, animated: false)
//                }
//                // Specify the initial position of the destination view.
//                
//                //  secondVCView.frame = CGRectMake(0.0, screenHeight, screenWidth, screenHeight)
//                
//                
//                //        let containerView = firstVCView.superview
//                //        containerView?.addSubview(secondVCView)
//                
//                // Get the screen width and height.
//                //        let screenWidth = UIScreen.mainScreen().bounds.size.width
//                //  var f = NavViewController()
//                
//                // wrap the centerViewController in a navigation controller, so we can push views to it
//                // and display bar button items in the navigation bar
//                // var centerNavigationController = UINavigationController(rootViewController: secondVC as! UIViewController)
//                //        view.addSubview(centerNavigationController.view)
//                //        addChildViewController(centerNavigationController)
//                //
//                //        centerNavigationController.didMoveToParentViewController(self)
//                
//                // Access the app's key window and insert the destination view above the current (source) one.
//                //        let window = UIApplication.sharedApplication().keyWindow
//                //        window?.insertSubview(secondVCView , aboveSubview: firstVCView)
//            //    navCtr.showViewController(secondVC as! UIViewController, sender: nil)
//            //    navCtr.presentViewController(secondVC as! UIViewController, animated: false, completion: nil)
//                // .pushViewController(secondVC as! UIViewController, animated: true)
//           //     self.sourceViewController.navigationController!!.popViewControllerAnimated(false)
////                self.sourceViewController.navigationController!!.pushViewController(self.destinationViewController as! UIViewController,
////                    animated: false)
////                self.sourceViewController.presentViewController(self.destinationViewController as! UIViewController,
////                    animated: false,
////                    completion: nil)
//        }
//        
//        
//
//  }
//}
