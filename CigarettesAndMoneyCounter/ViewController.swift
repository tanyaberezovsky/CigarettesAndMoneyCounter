//
//  ViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/19/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, TableLevelsControllerDelegate, UserDefaultsControllerDelegate {

    let MyManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

   
    
    @IBOutlet weak var txtLastCig: UILabel!
    @IBOutlet var levelAsNeeded: UIButton!
    @IBOutlet var txtCigarette: UITextField!
    @IBOutlet var levelOfEnjoy: UIButton!
    
    @IBOutlet weak var causeOfSmoking: UIButton!
    
    @IBOutlet var AddDate: UITextField!
    @IBOutlet var txtReason: UITextField!
   // @IBOutlet var pikerLvlAsNeed: UIPickerView!
    
   
    @IBOutlet var dailySmokedCigs: UILabel!
    @IBOutlet var dailyGoal: UILabel!
    @IBOutlet var dailyCost: UILabel!
   
    @IBOutlet var btnAdd: UIButton!
    
    var arrNumbers = [];
    var levelAsNeededText: String="0"
    var levelOfEnjoyText:String="0"
    
    var todaySmoked=0
    
    @IBAction func SettingsTouch(sender: UIBarButtonItem) {
        
    }
    @IBAction func addCigarettes(sender: AnyObject) {
        closeAllKeyboards()
        saveCigaretteRecordEntity()
        loadInitiatedValues()
        LoadDefaultValues()
    }
    
    func closeAllKeyboards()
    {
        self.view.endEditing(true)
    }
    
    func saveCigaretteRecordEntity() {
        let entityDescripition = NSEntityDescription.entityForName("CigaretteRecord", inManagedObjectContext: MyManagedObjectContext!)
        
        let task = CigaretteRecord(entity: entityDescripition!, insertIntoManagedObjectContext:  MyManagedObjectContext)
        if isNumeric(self.levelOfEnjoyText){
        if let addedCigs = self.txtCigarette.text.toInt(){
            if addedCigs>0 {
                task.cigarettes = addedCigs
                todaySmoked = todaySmoked + self.txtCigarette.text.toInt()!
            }
            else {AlertError("Illegal value of cigarette")}
        }
        else{AlertError("Illegal value of cigarette")}
        }
       if isNumeric(self.levelOfEnjoyText){
        task.levelOfEnjoy = self.levelOfEnjoyText.toInt()!}
        
          if isNumeric(self.levelAsNeededText){
            task.levelAsNeeded = self.levelAsNeededText.toInt()!}
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"

        let dateString:String = AddDate.text
        let dateValue:NSDate?=dateFormatter.dateFromString(dateString)
        task.addDate = dateValue!
        task.reason = txtReason.text!
        
        MyManagedObjectContext?.save(nil)
      
        var defaults = UserDefaultsDataController()
        
        defaults.saveLastAddedCig( dateValue!, todaySmoked: todaySmoked)
    }

    
    func AlertError(message: String){
        let alert = UIAlertView()
        alert.title = "Error"
        alert.message = message
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    @IBAction func TapGesture(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadScreenGraphics()
        loadInitiatedValues()
        LoadDefaultValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        closeAllKeyboards()
    }
    
    func getStringDate(dDate: NSDate)->String
    {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter.stringFromDate(dDate)
    }
    
    func setNowDate(){
        var curentDate = NSDate()
        AddDate.text = self.getStringDate(curentDate)
    }
    
    func loadInitiatedValues()
    {
        setNowDate()
        
        txtCigarette.text = "1";
    }
    
    func loadScreenGraphics()
    {
    
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        AddDate.inputView = datePickerView
        //set selected date to text field
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
       
//        //round button conners
        
        //    var btnLayer: CALayer = btnAdd.layer
      //  btnLayer.cornerRadius = 99
        
       // var button = UIButton.buttonWithType(.Custom) as UIButton
      /*  btnAdd.frame = CGRectMake(160, 100, 50, 50)
        btnAdd.layer.cornerRadius = 0.5 * btnAdd.bounds.size.width
        btnAdd.setImage(UIImage(named:"thumbsUp.png"), forState: .Normal)
        btnAdd.addTarget(self, action: "thumbsUpButtonPressed", forControlEvents: .TouchUpInside)*/
        
//        
        //set button look like text field
        var layerLevelAsNeeded: CALayer = levelAsNeeded.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColor.lightGrayColor().CGColor
       
        layerLevelAsNeeded = levelOfEnjoy.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColor.lightGrayColor().CGColor
        
        layerLevelAsNeeded = causeOfSmoking.layer
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
        
        dailyCost.text = "0"
        
        dailyGoal.text = String(userDefaults.dailyGoal)
        
        levelOfEnjoyText = String(userDefaults.levelOfEnjoyment)
        
        levelOfEnjoy.setTitle(levelOfEnjoyText, forState: UIControlState.Normal)
        
        levelAsNeededText = String(userDefaults.levelAsNeeded)
        
        levelAsNeeded.setTitle(levelAsNeededText, forState: UIControlState.Normal)
        
        if var lastCig = userDefaults.dateLastCig{
            let calcRet = calculateLastCigaretTime(lastCig)
            txtLastCig.text = calcRet.txtLastCig
            if calcRet.bLastCigWasToday == true{

                dailyCost.text = String(format:"%.1f", (userDefaults.averageCostOfOnePack / 20) * Double( userDefaults.todaySmoked))
                todaySmoked = userDefaults.todaySmoked
                println(userDefaults.dailyGoal)
                println(todaySmoked)
                
                if  userDefaults.dailyGoal > todaySmoked {
                    dailyGoal.text = String(userDefaults.dailyGoal - todaySmoked)
                }
                else{dailyGoal.text = "0"}
            }
            else{
                todaySmoked = 0
            }
        }
        else{
            txtLastCig.text = ""
        }
       dailySmokedCigs.text = String(Int( todaySmoked))
    }
    
    //set selected date to text field
    func handleDatePicker(sender: UIDatePicker) {
        AddDate.text = self.getStringDate(sender.date)
    }

    
    /*
    delegated function from TableLavels.swift
    received selected row value from TableLevels and set it to apropriate field
    */
    func myColumnDidSelected(controller: TableLavels, text: String, segueName: String) {
        if segueName ==  segueNames.segueLvlOfEnjoy{
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
            causeOfSmoking.setTitle(text, forState: UIControlState.Normal)
        }
        
        controller.navigationController?.popViewControllerAnimated(true)
       // println(segueName)
    }
    
    /*
    delegated function from TableLavels.swift
    called while pressinf save button in defautls settings screen    */
    func ReloadUserDefaults(){
        LoadDefaultValues()
    }
    
    //init variable and set segueid into it
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            
        closeAllKeyboards()
            
            println(segue.identifier)
            
        if  segue.identifier == segueNames.segueLvlOfNeeded || segue.identifier == segueNames.segueLvlOfEnjoy || segue.identifier == segueNames.segueCauseOfSmoking{
            let vc = segue.destinationViewController as! TableLavels
            vc.segueSourceName = segue.identifier
            vc.myDelegate = self
        }
        else if (segue.identifier == segueNames.userDefaults){
            let vc = segue.destinationViewController as! UserDefaultsController
            vc.myDelegate = self
        }
       /* if segue.identifier == "segueLvlOfNeeded"{
        
        }*/
    }

}

