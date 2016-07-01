//
//  CalculatorViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 7/12/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
// tau: shni
// google: shir

import UIKit

class CalculatorViewController: GlobalUIViewController {

    @IBOutlet weak var ciggarets: UITextField!
    @IBOutlet weak var packCost: UITextField!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var totalCigs: UILabel!
    @IBOutlet weak var totalPacks: UILabel!
    
    @IBOutlet weak var cigsDesc: UILabel!
    
    @IBOutlet weak var cigsPerPack: UITextField!

    @IBOutlet weak var segmentPeriod: UISegmentedControl!
    @IBOutlet weak var smokingTime: UILabel!
    var segment = 0
    var calc=Calculator()
    var tempValue:String!
    
//    calc = Calculator()

   
    
    @IBAction func cigarettsEditingEnd(sender: UITextField) {
        if (ciggarets.text == "")
        {
        ciggarets.text = tempValue
        }
    }
    
    @IBAction func cigarettsEditingBegin(sender: AnyObject) {
        tempValue = ciggarets.text
        ciggarets.text = ""
    }
    
    @IBAction func cigsPerPackEditingBegin(sender: AnyObject) {
        tempValue = cigsPerPack.text
        cigsPerPack.text = ""
    }
    
    @IBAction func cigsPerPackEditingEnd(sender: AnyObject) {
        if (cigsPerPack.text == "")
        {
            cigsPerPack.text = tempValue
        }
    }
    
    @IBAction func cigsPerPackChanged(sender: AnyObject) {
        if isNumeric(cigsPerPack.text!){
            calc.cigsPerPack = Int( cigsPerPack.text!)!
        }
    }
    
    @IBAction func packCostEditingBegin(sender: UITextField) {
        tempValue = packCost.text
        packCost.text = ""
    }
    @IBAction func packCostEditingEnd(sender: UITextField) {
        if (packCost.text == "")
        {
            packCost.text = tempValue
        }
    }
    
    @IBAction func packCostChanged(sender: AnyObject) {
        if isNumeric(packCost.text!){
            calc.packCost = packCost.text!.toDouble()!
        }
    }
    
    @IBAction func ciggaretsChanged(sender: UITextField) {
        if isNumeric(ciggarets.text!){
            calc.totalCiggarets = ciggarets.text!.toDouble()!
        }
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        segment = sender.selectedSegmentIndex
        //print("segment=\(segment)")
        calc.segment  = segment
        setDescription()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calc.propertyChanged.addHandler(self, handler: CalculatorViewController.onPropertyChanged)
        loadGraphicsSettings()
        
        LoadDefaultValues()
       
    }
    
    func roundSegmentConers()
    {
        
        //set button look like text field
        var layerLevelAsNeeded: CALayer
        
        layerLevelAsNeeded = segmentPeriod.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
       // layerLevelAsNeeded.borderColor = UIColor.lightGrayColor().CGColor
        
        
    }

    func setDescription()
    {
        var desc: String
        switch segment{
        case 0:
            desc = "per Day"
        case 1:
            desc = "per Week"
        case 2:
            desc = "per Month"
        case 3:
            desc = "per Year"
        default:
            desc=""
        }
        cigsDesc.text = "Cigarettes " + desc
    }
    
    
    
    func onPropertyChanged(property: CalculatorProperty) {
        //print("A calculator property changed! totalCiggarets = \(calc.totalCiggarets); sigment=\(calc.segment); packCost=\(calc.packCost)")
        
        ciggarets.text = decimalFormatToString(calc.totalCiggarets)//String(format: "%.1f", calc.totalCiggarets)
        
        if let cigsPack = cigsPerPack.text?.toDouble(){
            totalCigs.text = String(format: "%.0f", calc.totalCiggarets / cigsPack)
        }
        
        let cost: Double = calc.calculateCost() //a(1) //calculateCost()
        
        totalCost.text = decimalFormatToCurency(cost)
        
//
         smokingTime.text = AverageOfSmokingTimeDescription(calc.totalCiggarets, segment: segment)
    }

    private func calculateCost() -> Double
    {
        
        return  calc.totalCiggarets * (calc.packCost / Double( calc.cigsPerPack))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeAllKeyboards()
    }
    
    func closeAllKeyboards()
    {
        self.view.endEditing(true)
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  load Graphics Settings
    //++++++++++++++++++++++++++++++++++++
    func loadGraphicsSettings() {
        
        //set button look like text field
        var layerLevelAsNeeded: CALayer
        
        //set button look like text field
        layerLevelAsNeeded = packCost.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
        layerLevelAsNeeded = cigsPerPack.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
        layerLevelAsNeeded = ciggarets.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
        layerLevelAsNeeded = segmentPeriod.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        let defaults = UserDefaultsDataController()
    //    var userDefaults = UserDefaults()
      if let userDefaults:UserDefaults = defaults.loadUserDefaults(){
        
       calc.totalCiggarets = Double(userDefaults.dailyGoal)
    
        calc.packCost = userDefaults.averageCostOfOnePack
        
        calc.cigsPerPack = userDefaults.amountOfCigarettsInOnePack
        
       ciggarets.text = String(userDefaults.dailyGoal)
        
       packCost.text = decimalFormatToCurency(userDefaults.averageCostOfOnePack)
       
       cigsPerPack.text = String(userDefaults.amountOfCigarettsInOnePack)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
