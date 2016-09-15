//
//  ViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/19/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import UIKit
import CoreData

class ViewController: GlobalUIViewController, TableLevelsControllerDelegate, UserDefaultsControllerDelegate {

    let MyManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    var datePickerView  : UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var txtCigarette: UILabel!
    
    @IBOutlet weak var txtLastCig: UILabel!
    var cigaretts: String!
    
    @IBOutlet weak var levelAsNeeded: UISegmentedControl!
    @IBOutlet weak var levelOfEnjoy: UISegmentedControl!
  
    @IBOutlet weak var causeOfSmoking: UIButton!
    
    @IBOutlet var AddDate: UITextField!
  
    @IBOutlet var dailySmokedCigs: UILabel!
    @IBOutlet var dailyGoal: UILabel!
    @IBOutlet var dailyCost: UILabel!
    
   
    @IBOutlet weak var ciggaretsSlider: UISlider!
    @IBOutlet var btnAdd: UIButton!
    
    var arrNumbers = [];
   
    var reasonText:String!
    
    var todaySmoked=0
    
    @IBAction func cigarettsSliderValueChanged(sender: AnyObject) {
        txtCigarette.text = String(Int32( ciggaretsSlider.value))
        
    }
    
    @IBAction func addCigarettes(sender: AnyObject) {
        closeAllKeyboards()
        saveCigaretteRecordEntity()
        //usleep(500000)
        loadInitiatedValues()
        LoadDefaultValues()
    }
    
    override func viewWillAppear(animated: Bool) {
      //  self.navigationController?.setNavigationBarHidden(false, animated: false)
        roundButtonConers()
    }
    
    func roundSegmentConers()
    {
        
        //set button look like text field
        var layerLevelAsNeeded: CALayer
        
        layerLevelAsNeeded = levelOfEnjoy.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor

        
        layerLevelAsNeeded = levelAsNeeded.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor

        
        
        layerLevelAsNeeded = causeOfSmoking.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
        layerLevelAsNeeded = AddDate.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
    }
    
    
    func roundButtonConers(){
        btnAdd.layer.cornerRadius = btnAdd.layer.bounds.height / 2
        btnAdd.layer.borderWidth = 1
        btnAdd.layer.borderColor = btnAdd.backgroundColor?.CGColor
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
        
        task.levelOfEnjoy = self.levelOfEnjoy.selectedSegmentIndex
        
        
        task.levelAsNeeded = levelAsNeeded.selectedSegmentIndex
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"

        let dateString:String = AddDate.text!
        let dateValue:NSDate?=dateFormatter.dateFromString(dateString)
        task.addDate = dateValue!
        task.reason = reasonText
      
        
        let defaults = UserDefaultsDataController()
        let userDefaults:UserDefaults = defaults.loadUserDefaults()
        
        task.cost = userDefaults.averageCostOfOneCigarett * Double(task.cigarettes)
        
        do {
            try MyManagedObjectContext?.save()
            MyManagedObjectContext?.reset()
        } catch _ {
        }
      
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
        
        
       //2016-07-30
        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.showFirstViewController))
   //     let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "showFirstViewController")
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
        
        txtCigarette.text = "1"
        ciggaretsSlider.value = 1
    }
    
    func loadScreenGraphics()
    {
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        AddDate.inputView = datePickerView
        //set selected date to text field
        //datePickerView.addTarget(self, action: Selector("handleDatePicker:"), //forControlEvents: UIControlEvents.ValueChanged)
        
        datePickerView.addTarget(self, action: #selector(self.handleDatePicker(_:)),
                         forControlEvents: UIControlEvents.ValueChanged)
        
      roundSegmentConers()
        
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        let defaults = UserDefaultsDataController()
        let userDefaults:UserDefaults = defaults.loadUserDefaults()
        
        dailyCost.text = "0"
        
        dailyGoal.text = String(userDefaults.dailyGoal)
        
        levelOfEnjoy.selectedSegmentIndex = userDefaults.levelOfEnjoyment
        
        
        levelAsNeeded.selectedSegmentIndex = userDefaults.levelAsNeeded
        
        
        reasonText = String(userDefaults.reason)
        
        causeOfSmoking.setTitle(reasonText, forState: UIControlState.Normal)
        
        if let lastCig = userDefaults.dateLastCig{
            let calcRet = calculateLastCigaretTime(lastCig)
            txtLastCig.text = calcRet.txtLastCig
            
            if calcRet.bLastCigWasToday == true{

                dailyCost.text = String(format:"%.1f", (userDefaults.averageCostOfOnePack / Double( userDefaults.amountOfCigarettsInOnePack)) * Double( userDefaults.todaySmoked))
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
       
        if segueName == segueNames.segueCauseOfSmoking  && !text.isEmpty {
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
            
            //print(segue.identifier)
            
        if  segue.identifier == segueNames.segueCauseOfSmoking{
            let vc = segue.destinationViewController as! TableLavels
            vc.segueSourceName = segue.identifier
            vc.myDelegate = self
        }
        else if (segue.identifier == segueNames.userDefaults){
            let vc = segue.destinationViewController as! UserDefaultsController
            vc.myDelegate = self
        }
      
    }

}

