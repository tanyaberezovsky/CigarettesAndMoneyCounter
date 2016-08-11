//
//  question1ViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 08/08/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit

class question1ViewController: GlobalUIViewController
{

    var myDelegateQ1:popOverControllerDelegate? = nil

    @IBOutlet weak var smokedPerDay: UITextField!
    @IBOutlet weak var skip: UIButton!
    
    @IBOutlet weak var next: UIButton!
    var tempValue:String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
            loadScreenGraphics()
       // roundButtonConers()
            loadDailyLimit()
    
            //Looks for single or multiple taps.
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(question1ViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
            
        }
    
        //Calls this function when the tap is recognized.
        func dismissKeyboard() {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            view.endEditing(true)
        }
    func loadScreenGraphics()
    {
        var layerLevelAsNeeded: CALayer
        
        layerLevelAsNeeded = smokedPerDay.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
    }
    
    func roundButtonConers(){
        skip.layer.cornerRadius = skip.layer.bounds.height / 2
        skip.layer.borderWidth = 1
        skip.layer.borderColor =  skip.backgroundColor?.CGColor//UIColor.whiteColor().CGColor
        
        next.layer.cornerRadius = next.layer.bounds.height / 2
        next.layer.borderWidth = 1
        next.layer.borderColor = next.backgroundColor?.CGColor
        
    }
    
    @IBAction func cigsLimitEditingBegin(sender: UITextField) {
        tempValue = sender.text
        sender.text = ""
    }
    @IBAction func cigsLimitEditingEnd(sender: UITextField) {
        if (sender.text == "")
        {
            sender.text = tempValue
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func skip(sender: UIButton) {
          self.dismissViewControllerAnimated(false, completion: nil)
    }

    @IBAction func next(sender: UIButton) {
       
        saveDailyLimit()
        if(myDelegateQ1 != nil){
            myDelegateQ1!.dataReloadAfterSave()
        }
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    
    
    func loadDailyLimit() {
        
            let defaults = UserDefaultsDataController()
            //  var userDefaults = UserDefaults()
            if let userDefaults:UserDefaults = defaults.loadUserDefaults(){
                
                if let cigLimit:Int = Int(userDefaults.dailyGoal){
                    
                 smokedPerDay.text!  = String( cigLimit)
                
            }
        }
        
        return
        
    }

    func saveDailyLimit() {
        if let cigLimit:Int = Int( smokedPerDay.text! ){
        
        let defaults = UserDefaultsDataController()
        //  var userDefaults = UserDefaults()
        if let userDefaults:UserDefaults = defaults.loadUserDefaults(){
            
         
                userDefaults.dailyGoal = cigLimit
                defaults.saveUserDefaults(userDefaults)
                
            
        }
        }
        
        return
        
    }

    
}

protocol question1ViewControllerDelegate{
    func dataReloadAfterSave()
}