//
//  CalculatorViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 7/12/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
// tau: shni
// google: shir

import UIKit
//import ENSwiftSideMenu
import GoogleMobileAds

class CalculatorViewController: GlobalUIViewController {

    @IBOutlet weak var ciggarets: UITextField!
    @IBOutlet weak var packCost: UITextField!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var totalCigs: UILabel!
    @IBOutlet weak var totalPacks: UILabel!
    
    @IBOutlet weak var cigsDesc: UILabel!
    
    @IBOutlet weak var cigsPerPack: UITextField!
    @IBOutlet weak var adBannerView: GADBannerView!

    @IBOutlet weak var segmentPeriod: UISegmentedControl!
    @IBOutlet weak var smokingTime: UILabel!
    var segment = 0
    var calc=Calculator()
    var tempValue:String!
   
    
    @IBAction func cigarettsEditingEnd(_ sender: UITextField) {
        if (ciggarets.text == "")
        {
        ciggarets.text = tempValue
        }
    }
    
    @IBAction func cigarettsEditingBegin(_ sender: AnyObject) {
        tempValue = ciggarets.text
        ciggarets.text = ""
    }
    
    @IBAction func cigsPerPackEditingBegin(_ sender: AnyObject) {
        tempValue = cigsPerPack.text
        cigsPerPack.text = ""
    }
    
    @IBAction func cigsPerPackEditingEnd(_ sender: AnyObject) {
        if (cigsPerPack.text == "")
        {
            cigsPerPack.text = tempValue
        }
    }
    
    @IBAction func cigsPerPackChanged(_ sender: AnyObject) {
        if isNumeric(cigsPerPack.text!){
            calc.cigsPerPack = Int( cigsPerPack.text!)!
        }
    }
    
    @IBAction func packCostEditingBegin(_ sender: UITextField) {
        tempValue = packCost.text
        packCost.text = ""
    }
    @IBAction func packCostEditingEnd(_ sender: UITextField) {
        if (packCost.text == "")
        {
            packCost.text = tempValue
        }
    }
    
    @IBAction func packCostChanged(_ sender: AnyObject) {
        if isNumeric(packCost.text!){
            calc.packCost = packCost.text!.toDouble()!
        }
    }
    
    @IBAction func ciggaretsChanged(_ sender: UITextField) {
        if isNumeric(ciggarets.text!){
            calc.totalCiggarets = ciggarets.text!.toDouble()!
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        segment = sender.selectedSegmentIndex
        //print("segment=\(segment)")
        calc.segment  = segment
        setDescription()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAd()
        // Do any additional setup after loading the view.
        //Move next line to viewWillAppear functon if you store your view controllers
        self.sideMenuController()?.sideMenu?.delegate = self
        
       _ = calc.propertyChanged.addHandler(self, handler: CalculatorViewController.onPropertyChanged)
        loadGraphicsSettings()
        
        LoadDefaultValues()
       
    }
    
    func initAd(){
        adBannerView.adUnitID = Keys.adMob.unitID
        adBannerView.rootViewController = self
        //request the ad
        adBannerView.load(GADRequest())
    }
    
    func roundSegmentConers()
    {
        
        //set button look like text field
        var layerLevelAsNeeded: CALayer
        
        layerLevelAsNeeded = segmentPeriod.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
 
        
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
    
    
    
    func onPropertyChanged(_ property: CalculatorProperty) {
        
        ciggarets.text = decimalFormatToString(calc.totalCiggarets)//String(format: "%.1f", calc.totalCiggarets)
        
        if let cigsPack = cigsPerPack.text?.toDouble(){
            totalCigs.text = String(format: "%.0f", calc.totalCiggarets / cigsPack)
        }
        
        let cost: Double = calc.calculateCost() //a(1) //calculateCost()
        
        totalCost.text = decimalFormatToCurency(cost)
        
         smokingTime.attributedText = AverageOfSmokingTimeDescription(calc.totalCiggarets, segment: segment)
    }

    fileprivate func calculateCost() -> Double
    {
        
        return  calc.totalCiggarets * (calc.packCost / Double( calc.cigsPerPack))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
        
        
        layerLevelAsNeeded = cigsPerPack.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
        
        
        layerLevelAsNeeded = ciggarets.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
        
        
        layerLevelAsNeeded = segmentPeriod.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        
        let userDefaults:UserDefaults = UserDefaultsDataController.sharedInstance.loadUserDefaults()
        
       calc.totalCiggarets = Double(userDefaults.dailyGoal)
    
        calc.packCost = userDefaults.averageCostOfOnePack
        
        calc.cigsPerPack = userDefaults.amountOfCigarettsInOnePack
        
       ciggarets.text = String(userDefaults.dailyGoal)
        
       packCost.text = decimalFormatToCurency(userDefaults.averageCostOfOnePack)
       
       cigsPerPack.text = String(userDefaults.amountOfCigarettsInOnePack)
    
    }

   

}

extension CalculatorViewController: ENSideMenuDelegate {
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
}
