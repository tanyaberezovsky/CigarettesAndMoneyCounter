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
class LightMainSceneViewController: GlobalUIViewController, UIPopoverPresentationControllerDelegate, popOverControllerDelegate, question1ViewControllerDelegate, TableLevelsControllerDelegate {

    @IBOutlet weak var txtLastCig: UILabel!
    
    @IBOutlet weak var circularLoader: CircularLoaderView!
    
    @IBOutlet weak var addSmoke: UIButton!
    
    @IBOutlet weak var dailySmokedCigs: UILabel!
    
    private let defaults = UserDefaultsDataController()
    
    override func viewDidLoad() {
        if let userDefaults:UserDefaults = defaults.loadUserDefaults(){
            showQuestion1(userDefaults)
            //coreDataReasonsEntityInit(userDefaults)
        }
        
        super.viewDidLoad()
    //2016-07-30
        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(LightMainSceneViewController.showSecondViewController))
        //      let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "showSecondViewController")

        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
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
       // circularLoader.setNeedsDisplay()
    }
  
    override func  viewDidAppear(animated: Bool) {
        roundButtonConers()
        LoadDefaultValues()

    }
    
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        let defaults = UserDefaultsDataController()
      //  var userDefaults = UserDefaults()
        if let userDefaults:UserDefaults = defaults.loadUserDefaults(){
        
        var todaySmoked = 0

        if let lastCig = userDefaults.dateLastCig{
            let calcRet = calculateLastCigaretTime(lastCig)
            txtLastCig.text = calcRet.txtLastCig
            if calcRet.bLastCigWasToday == true{
                todaySmoked = userDefaults.todaySmoked
            }
 
        }
        else{
            txtLastCig.text = "TIME SINCE LAST CIGARETTE"// "How long has it been since last cigarette"//"Do not smoke at all"  "Free of smoking time"
        }
       // dailySmokedCigs.text = String(Int(todaySmoked))
            dailySmokedCigs.attributedText = dailySmokedToText(Int(todaySmoked), limit: userDefaults.dailyGoal)
            
        roundButtonConers()
      
        if let lastCig = userDefaults.dateLastCig{
            if(NSCalendar.currentCalendar().isDateInToday(lastCig)){
                loadCircularLoader(userDefaults.todaySmoked, dailyLimit: userDefaults.dailyGoal)
            }
        }
        }
         circularLoader.setNeedsDisplay()
    }

    
    func dailySmokedToText(totalSigs: Int, limit: Int) -> NSMutableAttributedString{
        var myMutableString = NSMutableAttributedString()
        
        let remainder: Int = limit - totalSigs > 0 ? limit - totalSigs: 0

        
        
        myMutableString = NSMutableAttributedString(string: String(format: "    %d/ %d", totalSigs, remainder))
        
        
        
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: UIFont.systemFontOfSize(13.0),
                                     range: NSRange(location: 0, length: 4))
        
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: UIFont.systemFontOfSize(13.0),
                                     range: NSRange(location:String(totalSigs).characters.count+4, length: String(remainder).characters.count+2))
        return myMutableString;
    }
    
    
    func loadCircularLoader(todaySmoked: Int, dailyLimit: Int)
    {
        if(todaySmoked>0){
        let circileAngle: Double = Double(todaySmoked) / Double(dailyLimit) * 100;
        
        circularLoader.toValue = CGFloat( circileAngle);
        }

    
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
           // LoadDefaultValues()
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
            
            }
           
        }
    
    }


      
     func showQuestion1(userDefaults:UserDefaults) {
        
            if userDefaults.showQuestion1 == true {
            
                
                let popOverVC = storyboard!.instantiateViewControllerWithIdentifier("question1ViewController") as! question1ViewController
        
                popOverVC.myDelegateQ1 = self
                
                popOverVC.view.opaque = false;
                popOverVC.view.alpha = 1//0.9;
            
        
                popOverVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
                presentViewController(popOverVC, animated: true, completion: nil)
                
                userDefaults.showQuestion1 = false
                defaults.saveUserDefaults(userDefaults)
                
            }
        
        return
     
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
 
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
        circularLoader.setNeedsDisplay()
    }
    
 
    
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
