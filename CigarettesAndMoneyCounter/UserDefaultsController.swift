//
//  UserDefaultsController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 10/9/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import UIKit


class UserDefaultsController: GlobalUIViewController,TableLevelsControllerDelegate {
    @IBOutlet weak var reason: UIButton!
    
    @IBOutlet var averageCost: UITextField!
   
    @IBOutlet weak var levelAsNeeded: UISegmentedControl!
    var reasonText:String!
    var tempValue:String!
    

    @IBOutlet weak var levelOfEnjoy: UISegmentedControl!
    @IBOutlet weak var amountOfCigarettsInOnePack: UITextField!
    @IBOutlet var dailyGoal: UITextField!
    
    @IBOutlet weak var minimalMode: UISwitch!
    var minimalModeOn:Bool!
    var myDelegate:UserDefaultsControllerDelegate? = nil
    
    override func viewDidLoad() {
        loadGraphicsSettings()
        LoadDefaultValues()
        //  self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "barButtonItemClicked:"), animated: true)
        
        gradientBackgroundRegular()
        
    }
    
    override func gradientBackgroundRegular() {
        self.view.backgroundColor = UIColor.clearColor()
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
        
        let colors:ColorTemplates = ColorTemplates();
        gradient.colors = colors.purpleGray()
        
        view.layer.insertSublayer(gradient, atIndex: 0)
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
    
    
    @IBAction func switchOnChange(sender: UISwitch) {
        minimalModeOn = sender.on
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            SaveDafaultsTouch()
        }
    }

    
    func SaveDafaultsTouch() {
        let defaults = UserDefaultsDataController()
        let userDefaults = UserDefaults()
        
       if isNumeric(averageCost.text!){
                userDefaults.averageCostOfOnePack = averageCost.text!.toDouble()!
        }

        
        if isNumeric(amountOfCigarettsInOnePack.text!){
            userDefaults.amountOfCigarettsInOnePack = Int(amountOfCigarettsInOnePack.text!)!
        }

        userDefaults.averageCostOfOneCigarett = userDefaults.averageCostOfOnePack / Double(userDefaults.amountOfCigarettsInOnePack)
        
        if isNumeric(dailyGoal.text!){
            userDefaults.dailyGoal = Int(dailyGoal.text!)!}
        

            userDefaults.levelOfEnjoyment = levelOfEnjoy.selectedSegmentIndex
        
            userDefaults.levelAsNeeded = levelAsNeeded.selectedSegmentIndex
        
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    
    //init variable and set segueid into it
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == segueNames.segueCauseOfSmoking{
            let vc = segue.destinationViewController as! TableLavels
            vc.segueSourceName = segue.identifier
            vc.myDelegate = self
        }
     
    }
    
    
    
    //++++++++++++++++++++++++++++++++++++
    //  load Graphics Settings
    //++++++++++++++++++++++++++++++++++++
    func loadGraphicsSettings() {
        
        //set button look like text field
        var layerLevelAsNeeded: CALayer
        
        //set button look like text field
        layerLevelAsNeeded = reason.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
        layerLevelAsNeeded = levelOfEnjoy.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
        layerLevelAsNeeded = levelAsNeeded.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
        
        layerLevelAsNeeded = dailyGoal.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
        layerLevelAsNeeded = amountOfCigarettsInOnePack.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
        
        layerLevelAsNeeded = averageCost.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        let defaults = UserDefaultsDataController()
        var userDefaults = UserDefaults()
        
        userDefaults = defaults.loadUserDefaults()
        
        averageCost.text = decimalFormatToCurency(userDefaults.averageCostOfOnePack)
        
        dailyGoal.text = String(userDefaults.dailyGoal)
        
        levelOfEnjoy.selectedSegmentIndex = userDefaults.levelOfEnjoyment
        
        
        levelAsNeeded.selectedSegmentIndex = userDefaults.levelAsNeeded 
    
        
        reasonText = String(userDefaults.reason)
        
        reason.setTitle(reasonText, forState: UIControlState.Normal)
        
        //minimalMode.on = userDefaults.minimalModeOn
        
    }
    
    /*
    delegated function from TableLavels.swift
    received selected row value from TableLevels and set it to apropriate field
    */
    func myColumnDidSelected(controller: TableLavels, text: String, segueName: String) {
        
        if segueName == segueNames.segueCauseOfSmoking{
            reasonText = text;
           // print(text)
            reason.setTitle(reasonText, forState: UIControlState.Normal)
        }
        
      
        controller.navigationController?.popViewControllerAnimated(true)
        // println(segueName)
    }
    
}


protocol UserDefaultsControllerDelegate{
    func ReloadUserDefaults()
}
