//
//  popOverViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 02/03/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit

class popOverViewController: UIViewController
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
        cancel.layer.borderColor = cancel.backgroundColor?.CGColor
        
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
        cigRecord.saveCigaretteRecordEntity(levelOfEnjoy.selectedSegmentIndex, levelAsNeeded: levelAsNeeded.selectedSegmentIndex, reason: reasonText)
        
        
        if(myDelegate != nil){
            myDelegate!.dataReloadAfterSave()
        }
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}

protocol popOverControllerDelegate{
    func dataReloadAfterSave()
}