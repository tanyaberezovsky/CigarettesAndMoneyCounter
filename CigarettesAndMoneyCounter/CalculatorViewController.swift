//
//  CalculatorViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 7/12/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
// tau: shni
// google: shir

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var ciggarets: UITextField!
    @IBOutlet weak var packCost: UITextField!
    @IBOutlet weak var totalCost: UILabel!
    
    @IBOutlet weak var cigsDesc: UILabel!
    

    @IBOutlet weak var smokingTime: UILabel!
    var segment = 0
    var calc = Calculator();
    
   //ciggaretsEditingDidEnd
    
    @IBAction func packCostChanged(sender: AnyObject) {
        if isNumeric(packCost.text){
            calc.packCost = packCost.text.toDouble()!
        }
    }
    
    @IBAction func ciggaretsChanged(sender: UITextField) {
        if isNumeric(ciggarets.text){
            calc.totalCiggarets = ciggarets.text.toDouble()!
        }
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        segment = sender.selectedSegmentIndex
        println("segment=\(segment)")
        calc.segment  = segment
        setDescription()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calc.propertyChanged.addHandler(self, handler: CalculatorViewController.onPropertyChanged)

        LoadDefaultValues()
       
    }
    
    func setDescription()
    {
        var desc: String
        switch segment{
        case 0:
            desc = "per day"
        case 1:
            desc = "per week"
        case 2:
            desc = "per month"
        case 3:
            desc = "per year"
        default:
            desc=""
        }
        cigsDesc.text = desc
    }
    
    
    
    func onPropertyChanged(property: CalculatorProperty) {
        println("A calculator property changed! totalCiggarets = \(calc.totalCiggarets); sigment=\(calc.segment); packCost=\(calc.packCost)")
        
        ciggarets.text = decimalFormatToString(calc.totalCiggarets)//String(format: "%.1f", calc.totalCiggarets)
        
        var cost: Double = calc.calculateCost() //a(1) //calculateCost()
        
        totalCost.text = decimalFormatToString(cost)//String(format: "%.1f", cost)
//
         smokingTime.text = AverageOfSmokingTimeDescription(calc.totalCiggarets, segment)
    }

    private func calculateCost() -> Double
    {
        
        return  calc.totalCiggarets * (calc.packCost / 20)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        closeAllKeyboards()
    }
    
    func closeAllKeyboards()
    {
        self.view.endEditing(true)
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        var defaults = UserDefaultsDataController()
        var userDefaults = UserDefaults()
        userDefaults = defaults.loadUserDefaults()
        
       calc.totalCiggarets = Double(userDefaults.dailyGoal)
    
        calc.packCost = userDefaults.averageCostOfOnePack
        
       ciggarets.text = String(userDefaults.dailyGoal)
        
       packCost.text = decimalFormatToString(userDefaults.averageCostOfOnePack)
       
       
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
