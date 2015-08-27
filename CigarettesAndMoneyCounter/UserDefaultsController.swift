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
    @IBOutlet weak var reason: UIButton!
    
    @IBOutlet var averageCost: UITextField!
   
    var reasonText:String!
    var levelAsNeededText: String="0"
    var levelOfEnjoyText:String="0"
    var tempValue:String!
    
    @IBOutlet var dailyGoal: UITextField!
    
    @IBOutlet weak var minimalMode: UISwitch!
    var minimalModeOn:Bool!
    var myDelegate:UserDefaultsControllerDelegate? = nil
    
    override func viewDidLoad() {
        loadGraphicsSettings()
        LoadDefaultValues()
        //  self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "barButtonItemClicked:"), animated: true)
        
    }
    @IBAction func costPack(sender: UITextField) {
        tempValue = sender.text
        sender.text = ""
    }
    @IBAction func costPackEditingEnd(sender: UITextField) {
        if (sender.text == "")
        {
            sender.text = tempValue
        }
    }
    
    @IBAction func dailyLimitEditingBegin(sender: UITextField) {
        tempValue = sender.text
        sender.text = ""
    }
    @IBAction func dailyLimitEditingEnd(sender: UITextField) {
        if (sender.text == "")
        {
            sender.text = tempValue
        }
    }
    
    /*  @IBAction func packCostEditingBegin(sender: UITextField) {
    tempValue = packCost.text
    packCost.text = ""
    }
    @IBAction func packCostEditingEnd(sender: UITextField) {
    if (packCost.text == "")
    {
    packCost.text = tempValue
    }
    }*/
    
    @IBAction func switchOnChange(sender: UISwitch) {
        minimalModeOn = sender.on
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            SaveDafaultsTouch()
        }
    }

    
    func SaveDafaultsTouch() {
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
        
        if (reasonText != nil)
        {
            userDefaults.reason = reasonText
        }
        if(minimalModeOn != nil){
            userDefaults.minimalModeOn = minimalModeOn
        }
        
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
        if  segue.identifier == segueNames.segueLvlOfNeeded || segue.identifier == segueNames.segueLvlOfEnjoy || segue.identifier == segueNames.segueCauseOfSmoking{
            let vc = segue.destinationViewController as! TableLavels
            vc.segueSourceName = segue.identifier
            vc.myDelegate = self
        }
        /* if segue.identifier == "segueLvlOfNeeded"{
        
        }*/
    }
    
    
    
    //++++++++++++++++++++++++++++++++++++
    //  load Graphics Settings
    //++++++++++++++++++++++++++++++++++++
    func loadGraphicsSettings() {
        
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
        
        //set button look like text field
        layerLevelAsNeeded = reason.layer
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
        
        averageCost.text = decimalFormatToString(userDefaults.averageCostOfOnePack)//String(format:"%.1f", userDefaults.averageCostOfOnePack)
        
        dailyGoal.text = String(userDefaults.dailyGoal)
        
        levelOfEnjoyText = String(userDefaults.levelOfEnjoyment)
        
        levelOfEnjoy.setTitle(levelOfEnjoyText, forState: UIControlState.Normal)
        
        levelAsNeededText = String(userDefaults.levelAsNeeded)
        
        levelAsNeeded.setTitle(levelAsNeededText, forState: UIControlState.Normal)
        
        reasonText = String(userDefaults.reason)
        
        reason.setTitle(reasonText, forState: UIControlState.Normal)
        
        minimalMode.on = userDefaults.minimalModeOn
        
    }
    
    /*
    delegated function from TableLavels.swift
    received selected row value from TableLevels and set it to apropriate field
    */
    func myColumnDidSelected(controller: TableLavels, text: String, segueName: String) {
        if segueName == segueNames.segueLvlOfEnjoy{
            levelOfEnjoyText = text;
            println(text)
            levelOfEnjoy.setTitle(levelOfEnjoyText, forState: UIControlState.Normal)
        }
        if segueName == segueNames.segueLvlOfNeeded{
            levelAsNeededText = text;
            println(text)
            levelAsNeeded.setTitle(levelAsNeededText, forState: UIControlState.Normal)
        }
        if segueName == segueNames.segueCauseOfSmoking{
            reasonText = text;
            println(text)
            reason.setTitle(reasonText, forState: UIControlState.Normal)
        }
        controller.navigationController?.popViewControllerAnimated(true)
        // println(segueName)
    }
    
}


protocol UserDefaultsControllerDelegate{
    func ReloadUserDefaults()
}
