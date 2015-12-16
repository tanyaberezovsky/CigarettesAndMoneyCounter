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

    
    var datePickerView  : UIDatePicker = UIDatePicker()
    
    
    @IBOutlet weak var txtLastCig: UILabel!
    @IBOutlet var levelAsNeeded: UIButton!
    @IBOutlet var txtCigarette: UITextField!
    var cigaretts: String!
    @IBOutlet var levelOfEnjoy: UIButton!
    
  
    @IBOutlet weak var causeOfSmoking: UIButton!
    
    @IBOutlet var AddDate: UITextField!
  //  @IBOutlet var txtReason: UITextField!
   // @IBOutlet var pikerLvlAsNeed: UIPickerView!
  //  @IBOutlet weak var txtReason: UIButton!
    
    //@IBOutlet weak var reason: UIButton!
    
    @IBOutlet var dailySmokedCigs: UILabel!
    @IBOutlet var dailyGoal: UILabel!
    @IBOutlet var dailyCost: UILabel!
    
    @IBAction func cigarettesEditingEnd(sender: UITextField) {
        if(sender.text == "")
        {
            sender.text = cigaretts
        }
    }
    
    @IBAction func cigarettesEditingBegin(sender: UITextField) {
        cigaretts = sender.text
        sender.text = ""
        
    }
   
    @IBOutlet var btnAdd: UIButton!
    
    var arrNumbers = [];
    var levelAsNeededText: String="0"
    var levelOfEnjoyText:String="0"
    var reasonText:String!
    
    var todaySmoked=0
    
    @IBAction func SettingsTouch(sender: UIBarButtonItem) {
        
    }
    @IBAction func addCigarettes(sender: AnyObject) {
        closeAllKeyboards()
        saveCigaretteRecordEntity()
        loadInitiatedValues()
        LoadDefaultValues()
    }
    
    override func viewWillAppear(animated: Bool) {
      //  self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func closeAllKeyboards()
    {
        self.view.endEditing(true)
    }
    
    func saveCigaretteRecordEntity() {
        
        if let addedCigs = Int(self.txtCigarette.text!){
            if addedCigs <= 0 {
                AlertError("Illegal value of cigarette")
                return
            }
        }
        else{
            AlertError("Illegal value of cigarette")
            return
        }

        
        let entityDescripition = NSEntityDescription.entityForName("CigaretteRecord", inManagedObjectContext: MyManagedObjectContext!)
        
        let task = CigaretteRecord(entity: entityDescripition!, insertIntoManagedObjectContext:  MyManagedObjectContext)
        
        task.cigarettes = Int(self.txtCigarette.text!)!
        todaySmoked = todaySmoked + Int(self.txtCigarette.text!)!
        
        
       if isNumeric(self.levelOfEnjoyText){
        task.levelOfEnjoy = Int(self.levelOfEnjoyText)!}
        
        if isNumeric(self.levelAsNeededText){
            task.levelAsNeeded = Int(self.levelAsNeededText)!}
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"

        let dateString:String = AddDate.text!
        let dateValue:NSDate?=dateFormatter.dateFromString(dateString)
        task.addDate = dateValue!
        task.reason = reasonText
        
        do {
            try MyManagedObjectContext?.save()
        } catch _ {
        }
      
        let defaults = UserDefaultsDataController()
        
        
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
        
        
        
        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "showFirstViewController")
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
     

    }
    
    func showFirstViewController() {
        self.performSegueWithIdentifier("idFirstSegueUnwind", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeAllKeyboards()
    }
    
    func getStringDate(dDate: NSDate)->String
    {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter.stringFromDate(dDate)
    }
    
    func setNowDate(){
        let curentDate = NSDate()
        AddDate.text = self.getStringDate(curentDate)
        datePickerView.date = curentDate
    }
    
    func loadInitiatedValues()
    {
        setNowDate()
        
        txtCigarette.text = "1";
    }
    
    func loadScreenGraphics()
    {
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        AddDate.inputView = datePickerView
        //set selected date to text field
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
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
        let defaults = UserDefaultsDataController()
        var userDefaults = UserDefaults()
        userDefaults = defaults.loadUserDefaults()
        
        dailyCost.text = "0"
        
        dailyGoal.text = String(userDefaults.dailyGoal)
        
        levelOfEnjoyText = String(userDefaults.levelOfEnjoyment)
        
        levelOfEnjoy.setTitle(levelOfEnjoyText, forState: UIControlState.Normal)
        
        levelAsNeededText = String(userDefaults.levelAsNeeded)
        
        levelAsNeeded.setTitle(levelAsNeededText, forState: UIControlState.Normal)
        
        reasonText = String(userDefaults.reason)
        
        causeOfSmoking.setTitle(reasonText, forState: UIControlState.Normal)
        
        if let lastCig = userDefaults.dateLastCig{
            let calcRet = calculateLastCigaretTime(lastCig)
            txtLastCig.text = calcRet.txtLastCig
            
            if calcRet.bLastCigWasToday == true{

                dailyCost.text = String(format:"%.1f", (userDefaults.averageCostOfOnePack / 20) * Double( userDefaults.todaySmoked))
                todaySmoked = userDefaults.todaySmoked
            
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
            txtLastCig.text = "How long has it been since last cigarette"
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
            print(text)
            levelOfEnjoy.setTitle(levelOfEnjoyText, forState: UIControlState.Normal)
        }
        if segueName == segueNames.segueLvlOfNeeded{
            levelAsNeededText = text;
            print(text)
            levelAsNeeded.setTitle(levelAsNeededText, forState: UIControlState.Normal)
        }
        if segueName == segueNames.segueCauseOfSmoking{
            reasonText = text;
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
            
            print(segue.identifier)
            
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

