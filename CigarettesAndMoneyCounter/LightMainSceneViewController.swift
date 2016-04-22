//
//  LightMainSceneViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/13/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import UIKit
import CoreData

@IBDesignable
class LightMainSceneViewController: GlobalUIViewController, UIPopoverPresentationControllerDelegate, popOverControllerDelegate, TableLevelsControllerDelegate {

    @IBOutlet weak var txtLastCig: UILabel!
    
    @IBOutlet weak var circularLoader: CircularLoaderView!
    
    @IBOutlet weak var addSmoke: UIButton!
    
    @IBOutlet weak var dailySmokedCigs: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "showSecondViewController")
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        LoadDefaultValues()
 //  addSmoke.layoutSubviews()

 //self.viewWillAppear(false)
    }
    
    @IBAction func addCigarettes(sender: AnyObject) {
        /*
        let cigRecord = CigaretteRecordManager()
        cigRecord.saveCigaretteRecordEntityFromDefaultsValues()
        
        LoadDefaultValues()
        circularLoader.setNeedsDisplay()
*/
        
    }
    
    
    
    /*
    delegated function from dataReloadAfterSave
    called while pressinf save button in defautls settings screen    */
    func dataReloadAfterSave(){
        LoadDefaultValues()
        circularLoader.setNeedsDisplay()
    }

    
    override func  viewDidAppear(animated: Bool) {
        roundButtonConers()
    }
    
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        let defaults = UserDefaultsDataController()
        var userDefaults = UserDefaults()
        userDefaults = defaults.loadUserDefaults()
        
        var todaySmoked = 0

        if let lastCig = userDefaults.dateLastCig{
            let calcRet = calculateLastCigaretTime(lastCig)
            txtLastCig.text = calcRet.txtLastCig
            if calcRet.bLastCigWasToday == true{
                todaySmoked = userDefaults.todaySmoked
            }
 
        }
        else{
            txtLastCig.text = "How long has it been since last cigarette"//"Do not smoke at all"  "Free of smoking time"
        }
        dailySmokedCigs.text = String(Int(todaySmoked))
        roundButtonConers()
      
        if let lastCig = userDefaults.dateLastCig{
            if(NSCalendar.currentCalendar().isDateInToday(lastCig)){
                loadCircularLoader(userDefaults.todaySmoked, dailyLimit: userDefaults.dailyGoal)
            }
        }
        
    }

    func loadCircularLoader(todaySmoked: Int, dailyLimit: Int)
    {
        if(todaySmoked>0){
        let circileAngle: Double = Double(todaySmoked) / Double(dailyLimit) * 100;
        
        circularLoader.toValue = CGFloat( circileAngle);
        }
//        if (circileAngle <= 50)
//        {
//            circularLoader.fillColor = UIColor.whiteColor()
//        }
//        else   if (circileAngle > 100)
//        {
//            circularLoader.fillColor = UIColors.CircleLoaderColors.red
//        }
//        else
//        {
//            circularLoader.fillColor = UIColors.CircleLoaderColors.yellow
//        }
    
    }
    
    
    func roundButtonConers(){
       // addSmoke.backgroundColor = UIColor.clearColor()
        addSmoke.layer.cornerRadius = addSmoke.layer.bounds.height / 2
        addSmoke.layer.borderWidth = 1
        addSmoke.layer.borderColor = addSmoke.backgroundColor?.CGColor
    }
    
        override func viewWillAppear(animated: Bool) {
            if self.childViewControllers.count > 0 {

            let secondVC: AnyObject = childViewControllers[0]
                 let navCtr  = self.navigationController as UINavigationController!
            //
            //
                navCtr.pushViewController(secondVC as! UIViewController, animated: false)
            }
            LoadDefaultValues()
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSecondViewController() {
        self.performSegueWithIdentifier("idFirstSegue", sender: self)
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMenu" {
            let popOverVC = segue.destinationViewController
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.Popover
            popOverVC.popoverPresentationController!.delegate = self
        }
        
        
        
        if segue.identifier == "showPopForm"{
            
            let popOverVC = segue.destinationViewController as! popOverViewController
            popOverVC.myDelegate = self
            
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.Popover
            
            popOverVC.view.opaque = false;
            popOverVC.view.alpha = 0.9;
            

            
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            
            if let pop = popOverVC.popoverPresentationController {
                
                var passthroughViews: [UIView]?
                passthroughViews = [self.view]
                

                pop.permittedArrowDirections = .Any
                //    pop.sourceView = myButton
                pop.passthroughViews = passthroughViews
                
                pop.delegate = self
                
                
                pop.sourceRect = CGRect(
                    x: 0,
                    y: 0 + addSmoke.layer.bounds.height + 15,
                    width: view.frame.width,
                    height: 250)
                
                popOverVC.preferredContentSize = CGSize(width: view.frame.width, height: 250)
                /*
                pop.sourceRect = CGRect(
                    x: 0,
                    y: self.view.frame.height / 4,
                    width: popOverVC.view.frame.width,
                    height: popOverVC.view.frame.height)
                
*/
            }
            
            /*    self.presentViewController(
            popOverVC,
            animated: true,
            completion: nil)
            */
            
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
//        if sender.identifier == "idFirstSegueUnwind" {
//            let originalColor = self.view.backgroundColor
//            self.view.backgroundColor = UIColor.redColor()
//            
//            UIView.animateWithDuration(1.0, animations: { () -> Void in
//                self.view.backgroundColor = originalColor
//            })
//        }
    }
    
   /* override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "idFirstSegueUnwind" {
                let unwindSegue = FirstCustomSegueUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
    }
    */
    
    /*
    delegated function from TableLavels.swift
    received selected row value from TableLevels and set it to apropriate field
    */
    func myColumnDidSelected(controller: TableLavels, text: String, segueName: String) {
        
        if segueName == segueNames.segueCauseOfSmoking{
           //reasonText = text;
            // print(text)
            // reason.setTitle(reasonText, forState: UIControlState.Normal)
        }
        self.performSegueWithIdentifier("showPopForm", sender: self)
        
        controller.navigationController?.popViewControllerAnimated(true)
        
        // println(segueName)
        //     self.presentingViewController(self, animated: true, completion: nil)
        //       self.presentingViewController(self,) // (true, completion: nil)
    }

}
