//
//  popOverViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 02/03/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit

class popOverViewController: UIViewController, TableLevelsControllerDelegate
{

    var myDelegate:popOverControllerDelegate? = nil
    
    @IBOutlet weak var levelOfEnjoy: UISegmentedControl!
    
    @IBOutlet weak var levelAsNeeded: UISegmentedControl!
    @IBOutlet weak var causeOfSmoking: UIButton!
    
    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var done: UIButton!
    var reasonText:String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        loadScreenGraphics()
        roundButtonConers()
        LoadDefaultValues()
    }
    
    func loadScreenGraphics()
    {
    //    view.frame.width = super.parentViewController?.view.frame.width
        
        //set button look like text field
        var layerLevelAsNeeded: CALayer
        
        layerLevelAsNeeded = levelOfEnjoy.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColor.lightGrayColor().CGColor
        
        layerLevelAsNeeded = levelAsNeeded.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColor.lightGrayColor().CGColor
        
        
        layerLevelAsNeeded = causeOfSmoking.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColor.lightGrayColor().CGColor
        
    }
    
    func roundButtonConers(){
        done.layer.cornerRadius = done.layer.bounds.height / 2
        done.layer.borderWidth = 1
        done.layer.borderColor = done.backgroundColor?.CGColor
        
        cancel.layer.cornerRadius = cancel.layer.bounds.height / 2
        cancel.layer.borderWidth = 1
        cancel.layer.borderColor = UIColor.whiteColor().CGColor //cancel.backgroundColor?.CGColor
        
    }
    
    
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        let defaults = UserDefaultsDataController()
        var userDefaults = UserDefaults()
        userDefaults = defaults.loadUserDefaults()
        
        
        levelOfEnjoy.selectedSegmentIndex = userDefaults.levelOfEnjoyment
        
        
        levelAsNeeded.selectedSegmentIndex = userDefaults.levelAsNeeded 
        
        
        reasonText = String(userDefaults.reason)
        
        causeOfSmoking.setTitle(reasonText, forState: UIControlState.Normal)
        
       
    }

    @IBAction func cancelTouch(sender: AnyObject) {
          self.dismissViewControllerAnimated(false, completion: nil)
    }
   
    @IBAction func finishTouch(sender: AnyObject) {
        let cigRecord = CigaretteRecordManager()
        cigRecord.saveCigaretteRecordEntity(levelOfEnjoy.selectedSegmentIndex, levelAsNeeded: levelAsNeeded.selectedSegmentIndex, reason: causeOfSmoking.currentTitle!)
        
        
        if(myDelegate != nil){
            myDelegate!.dataReloadAfterSave()
        }
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    

  /*  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueNames.segueCauseOfSmoking {
            
            let toViewController = segue.destinationViewController as! TableLavels
            toViewController.segueSourceName = segue.identifier
            
            navigateToRoot(self, toViewController: toViewController)
        }
    }*/
    
    func navigateToRoot(viewController: UIViewController, toViewController: TableLavels)
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
            let fromViewController: LightMainSceneViewController = (nc?.viewControllers[0]) as! LightMainSceneViewController//.parentViewController!
            
            toViewController.myDelegate = fromViewController
            
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
    
    /*
    delegated function from TableLavels.swift
    received selected row value from TableLevels and set it to apropriate field
    */
    func myColumnDidSelected(controller: TableLavels, text: String, segueName: String) {
        
        if segueName == segueNames.segueCauseOfSmoking{
            reasonText = text;
            // print(text)
           // reason.setTitle(reasonText, forState: UIControlState.Normal)
        }
        
        controller.navigationController?.popViewControllerAnimated(true)
        // println(segueName)
   //     self.presentingViewController(self, animated: true, completion: nil)
 //       self.presentingViewController(self,) // (true, completion: nil)
    }
    
}

protocol popOverControllerDelegate{
    func dataReloadAfterSave()
}