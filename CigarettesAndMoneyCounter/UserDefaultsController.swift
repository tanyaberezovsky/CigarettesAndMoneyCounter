//
//  UserDefaultsController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 10/9/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import UIKit


class UserDefaultsController: UIViewController,TableLevelsControllerDelegate {
    
    @IBOutlet var levelAsNeeded: UIButton!
    @IBOutlet var levelOfEnjoy: UIButton!
    
    @IBOutlet var averageCost: UITextField!
    var levelAsNeededText: String="0"
    var levelOfEnjoyText:String="0"
    
    @IBOutlet var dailyGoal: UITextField!
    
    @IBOutlet var buttonSave: UIButton!
    
    var myDelegate:UserDefaultsControllerDelegate? = nil
    
    
    @IBAction func SaveDafaultsTouch(sender: UIButton) {
        var defaults = UserDefaultsDataController()
        var userDefaults = UserDefaults()
        
       if isNumeric(averageCost.text){
                userDefaults.averageCostOfOnePack = averageCost.text.toDouble()!
        }

        
        if isNumeric(dailyGoal.text){
            userDefaults.dailyGoal = dailyGoal.text.toInt()!}
        
        if isNumeric(levelOfEnjoyText){
            userDefaults.levelOfEnjoyment = levelOfEnjoyText.toInt()!}
        
        if isNumeric(levelAsNeededText){
            userDefaults.levelAsNeeded = levelAsNeededText.toInt()!}
        
        defaults.saveUserDefaults(userDefaults)
        
        
        if(myDelegate != nil){
            myDelegate!.ReloadUserDefaults()
        }
        
    }
    
    func barButtonItemClicked(){
        if(myDelegate != nil){
            myDelegate!.ReloadUserDefaults()
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
    
    
    //init variable and set segueid into it
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "segueLvlOfNeededSettings" || segue.identifier == "segueLvlOfEnjoySettings"{
            let vc = segue.destinationViewController as! TableLavels
            vc.segueSourceName = segue.identifier
            vc.myDelegate = self
        }
        /* if segue.identifier == "segueLvlOfNeeded"{
        
        }*/
    }
    
    override func viewDidLoad() {
        loadGraphicsSettings()
        LoadDefaultValues()
      //  self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "barButtonItemClicked:"), animated: true)

    }
    
    
    //++++++++++++++++++++++++++++++++++++
    //  load Graphics Settings
    //++++++++++++++++++++++++++++++++++++
    func loadGraphicsSettings() {
        //round button conners
        var btnLayer: CALayer = buttonSave.layer
        btnLayer.cornerRadius = 10
        
        //set button look like text field
        var layerLevelAsNeeded: CALayer = levelAsNeeded.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColor.lightGrayColor().CGColor
        
        
        //set button look like text field
        layerLevelAsNeeded = levelOfEnjoy.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColor.lightGrayColor().CGColor
        
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        var defaults = UserDefaultsDataController()
        var userDefaults = UserDefaults()
        userDefaults = defaults.loadUserDefaults()
        averageCost.text = String(format:"%.1f", userDefaults.averageCostOfOnePack)
        
        dailyGoal.text = String(userDefaults.dailyGoal)
        
        levelOfEnjoyText = String(userDefaults.levelOfEnjoyment)
        
        levelOfEnjoy.setTitle(levelOfEnjoyText, forState: UIControlState.Normal)
        
        levelAsNeededText = String(userDefaults.levelAsNeeded)
        
        levelAsNeeded.setTitle(levelAsNeededText, forState: UIControlState.Normal)
        
    }
    
    /*
    delegated function from TableLavels.swift
    received selected row value from TableLevels and set it to apropriate field
    */
    func myColumnDidSelected(controller: TableLavels, text: String, segueName: String) {
        if segueName == "segueLvlOfEnjoySettings"{
            levelOfEnjoyText = text;
            println(text)
            levelOfEnjoy.setTitle(levelOfEnjoyText, forState: UIControlState.Normal)
        }
        if segueName == "segueLvlOfNeededSettings"{
            levelAsNeededText = text;
            println(text)
            levelAsNeeded.setTitle(levelAsNeededText, forState: UIControlState.Normal)
        }
        
        controller.navigationController?.popViewControllerAnimated(true)
        // println(segueName)
    }
    
}


protocol UserDefaultsControllerDelegate{
    func ReloadUserDefaults()
}
