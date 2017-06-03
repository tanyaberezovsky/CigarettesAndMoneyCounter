//
//  UserDefaultsController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 10/9/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import UIKit
import  ENSwiftSideMenu

class UserDefaultsController: GlobalUIViewController,TableLevelsControllerDelegate, ENSideMenuDelegate {
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
        self.sideMenuController()?.sideMenu?.delegate = self
        
        loadGraphicsSettings()
        LoadDefaultValues()
        
        gradientBackgroundRegular()
        
    }
    
    override func gradientBackgroundRegular() {
        self.view.backgroundColor = UIColor.clear
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
        
        gradient.colors = ColorTemplates.purpleGrayCGColor()
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func costPack(_ sender: UITextField) {
        tempValue = sender.text
        sender.text = ""
    }
    
    @IBAction func costPackEditingEnd(_ sender: UITextField) {
        if (sender.text == "")
        {
            sender.text = tempValue
        }
    }
    
    @IBAction func dailyLimitEditingBegin(_ sender: UITextField) {
        tempValue = sender.text
        sender.text = ""
    }
    @IBAction func dailyLimitEditingEnd(_ sender: UITextField) {
        if (sender.text == "")
        {
            sender.text = tempValue
        }
    }
    
    
    @IBAction func switchOnChange(_ sender: UISwitch) {
        minimalModeOn = sender.isOn
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            SaveDafaultsTouch()
        }
    }

    
    func SaveDafaultsTouch() {
      
       // let userDefaults:UserDefaults = defaults.loadUserDefaults()
        let defaults = UserDefaultsDataController.sharedInstance
        
        let userDefaults:UserDefaults = UserDefaultsDataController.sharedInstance.loadUserDefaults()
  
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    
    //init variable and set segueid into it
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueNames.segueCauseOfSmoking{
            let vc = segue.destination as! TableLavels
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
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
        
        
        layerLevelAsNeeded = levelOfEnjoy.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
        
        
        layerLevelAsNeeded = levelAsNeeded.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
        
        
        
        layerLevelAsNeeded = dailyGoal.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
        
        
        layerLevelAsNeeded = amountOfCigarettsInOnePack.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
        
        
        
        layerLevelAsNeeded = averageCost.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        let defaults:UserDefaultsDataController = UserDefaultsDataController.sharedInstance
        let userDefaults:UserDefaults = defaults.loadUserDefaults()
        
        averageCost.text = decimalFormatToCurency(userDefaults.averageCostOfOnePack)
        
        dailyGoal.text = String(userDefaults.dailyGoal)
        
        levelOfEnjoy.selectedSegmentIndex = userDefaults.levelOfEnjoyment
        
        amountOfCigarettsInOnePack.text = String( userDefaults.amountOfCigarettsInOnePack)
        levelAsNeeded.selectedSegmentIndex = userDefaults.levelAsNeeded 
    
        
        reasonText = String(userDefaults.reason)
        
        reason.setTitle(reasonText, for: UIControlState())
        
        
    }
    
    /*
    delegated function from TableLavels.swift
    received selected row value from TableLevels and set it to apropriate field
    */
    func myColumnDidSelected(_ controller: TableLavels, text: String, segueName: String) {
        
        if segueName == segueNames.segueCauseOfSmoking && !text.isEmpty {
            reasonText = text;
            reason.setTitle(reasonText, for: UIControlState())
        }
        
      
        _ = controller.navigationController?.popViewController(animated: true)
    }
    
}


protocol UserDefaultsControllerDelegate{
    func ReloadUserDefaults()
}
