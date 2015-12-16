//
//  SummaryViewController.swift
//  CigarettesAndMoneyCounter
//orit
//  Created by Tania on 27/11/2015.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//


import UIKit
import CoreData

class SummaryViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,NSFetchedResultsControllerDelegate
{

    var currentSegmentDateType  = Constants.SegmentDateType.day
    
    var datePickerView  : UIDatePicker = UIDatePicker()
    var myPicker: UIPickerView = UIPickerView()
    var curentDate:NSDate = NSDate()
    
    
    @IBOutlet weak var segmentDateType: UISegmentedControl!
    @IBOutlet weak var selectedDate: UITextField!
    
    var pickerData = [ ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]]
    
    var arrYear = [String]()
    
    func createYearArr()
    {
        if (arrYear.count > 0){ return;}
        
        for i in 1...10 {
            arrYear.append(String(2013 + i))
        }

        pickerData.append(arrYear)
    }
    //80B53D53B6
    @IBAction func shiftBtnDateSubOnTouch(sender: UIButton) {
        calculateSelectedDate(-1)
    }
    
    @IBAction func shiftBtnDateAddOnTouch(sender: UIButton) {
        calculateSelectedDate(1)
    }
    
    @IBAction func selectedDateTouchDown(sender: UITextField) {
        myPicker.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createYearArr()
        loadScreenGraphics();
        let cigRecord = CigaretteRecordManager()
        cigRecord.calculateAmountAndCost()
        
    }
    
    enum pickerComponent:Int{
        case size = 0
        case topping = 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return (pickerData[component][row] )
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    //MARK -Instance Methods
    func updateLabel(){
        let month = pickerData[0][myPicker.selectedRowInComponent(0)]
        let year = pickerData[1][myPicker.selectedRowInComponent(1)]
        selectedDate.text =  (month ) + " " + (year )
    }
    
    @IBAction func segmentDateTypeChanged(sender: UISegmentedControl) {
        currentSegmentDateType = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!.lowercaseString
        closeAllKeyboards()
        curentDate = NSDate()
        drawSelectedDate()
    }
    
    
    func drawSelectedDate(){
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: curentDate)
     
        let indexOfYear =  pickerData[1].indexOf(String(components.year))
        
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.day: //day
            selectedDate.inputView = datePickerView
            showSelectedDate(curentDate, dateFormat: Constants.dateFormat.day)
            datePickerView.date = curentDate
        case Constants.SegmentDateType.month://month
            self.selectedDate.inputView = myPicker
            selectedDate.text = self.getStringDate(curentDate, currentDateFormat: Constants.dateFormat.month)
            myPicker.selectRow(components.month - 1, inComponent: 0, animated: true)
            myPicker.selectRow(indexOfYear!, inComponent: 1, animated: true)
        case Constants.SegmentDateType.year:
            self.selectedDate.inputView = myPicker
            selectedDate.text = self.getStringDate(curentDate, currentDateFormat: Constants.dateFormat.year)
            myPicker.selectRow(indexOfYear!, inComponent: 1, animated: true)
       default:
            return;
        }
       
    }
    
    
    
    func calculateSelectedDate(shiftFactor: Int = 0){
        
        var unitDate : NSCalendarUnit = NSCalendarUnit.Day
        
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.month://month
            unitDate = NSCalendarUnit.Month
        case Constants.SegmentDateType.year:
            unitDate = NSCalendarUnit.Year
        default:
            unitDate = NSCalendarUnit.Day
            
        }
        
        curentDate = NSCalendar.currentCalendar().dateByAddingUnit(
            unitDate,
            value: shiftFactor,
            toDate: curentDate,
            options: NSCalendarOptions(rawValue: 0))!

        drawSelectedDate()
    }
    
    

    func getStringDate(dDate: NSDate, currentDateFormat: String)->String
    {
        let dateFormatter = NSDateFormatter()

        dateFormatter.dateFormat = currentDateFormat
    
        return dateFormatter.stringFromDate(dDate)
    }
    
    func loadScreenGraphics()
    {
        myPicker.delegate = self
        myPicker.hidden = true
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        selectedDate.inputView = datePickerView
     
        //set selected date to text field
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        //set init value
        showSelectedDate(NSDate(), dateFormat: Constants.dateFormat.day)
    }
    
    //set selected date to text field
    func handleDatePicker(sender: UIDatePicker) {
        showSelectedDate(sender.date, dateFormat: Constants.dateFormat.day)
    }

    func showSelectedDate(date: NSDate, dateFormat: String){
        selectedDate.text = self.getStringDate(date, currentDateFormat: dateFormat)
    }
    
    func closeAllKeyboards()
    {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeAllKeyboards()
    }
    
}
