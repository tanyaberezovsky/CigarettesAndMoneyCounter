//
//  SummaryViewController.swift
//  CigarettesAndMoneyCounter
//orit
//  Created by Tania on 27/11/2015.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//


import UIKit
import CoreData
import Charts

class SummaryViewController: GlobalUIViewController, UIPickerViewDataSource,UIPickerViewDelegate, NSFetchedResultsControllerDelegate
{
   // @IBOutlet weak var barChartView: HorizontalBarChartView!

    var currentSegmentDateType  = Constants.SegmentDateType.month
    
    var datePickerView  : UIDatePicker = UIDatePicker()
    var myPicker: UIPickerView = UIPickerView()
    var curentDate:NSDate = NSDate()
    var toDate:NSDate = NSDate()
    
    @IBOutlet weak var smokedLabel: UILabel!
    @IBOutlet weak var smoked: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var pieChart: PieChartView!
  //  @IBOutlet weak var barChartView: BarChartView!

 //   @IBOutlet weak var pieChart: pieChart!
   
    @IBOutlet weak var segmentDateType: UISegmentedControl!
    @IBOutlet weak var selectedDate: UITextField!
    
    @IBOutlet weak var segmentGraphType: UISegmentedControl!
    var pickerData = [ ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]]
    
    var arrYear = [String]()
    
    @IBAction func graphTypeChanged(sender: UISegmentedControl) {
        
        showChartBySegmntIndex(sender.selectedSegmentIndex)
    }
    
    func  showChartBySegmntIndex(index: Int = 0)
    {
        drawChart()
        
        if (index == 1)
        {
            
            barChart.hidden = false
            pieChart.hidden = true
            
        }
        else
        {
            barChart.hidden = true
            pieChart.hidden = false
        }
        
    }
    
    
    
    func createYearArr()
    {
        if (arrYear.count > 0){ return;}
        
        for i in 1...10 {
            arrYear.append(String(2013 + i))
        }

        pickerData.append(arrYear)
    }
    //password azriely 80B53D53B6
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
        
        pieChart.noDataTextDescription = "Have five"
        pieChart.noDataText = "congratulation, you don't smoke at this period"
    
        
       pieChart.hidden = true;
       // barChartView.delegate = self
        
        createYearArr()
        loadScreenGraphics();

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
        calculateSelectedDate(0)
       
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
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: curentDate)
        let userCalendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        
        var unitDate : NSCalendarUnit = NSCalendarUnit.Day
        
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.year:
            unitDate = NSCalendarUnit.Year
            dateComponents.month = 1
            dateComponents.day = 1
        case Constants.SegmentDateType.month://month
            unitDate = NSCalendarUnit.Month
            dateComponents.month = components.month
            dateComponents.day = 1
        default:
            unitDate = NSCalendarUnit.Day
            dateComponents.month = components.month
            dateComponents.day = components.day
 
        }
        
        dateComponents.year = components.year
        curentDate = userCalendar.dateFromComponents(dateComponents)!
        
        curentDate = NSCalendar.currentCalendar().dateByAddingUnit(
            unitDate,
            value: shiftFactor,
            toDate: curentDate,
            options: NSCalendarOptions(rawValue: 0))!

        toDate = NSCalendar.currentCalendar().dateByAddingUnit(
            unitDate,
            value: 1,
            toDate: curentDate,
            options: NSCalendarOptions(rawValue: 0))!
        print(curentDate)
        print(toDate)
        
        drawSelectedDate()
        drawCostAndSmoked()
        drawChart()
    }
    
    
    
    func  drawCostAndSmoked()
    {
    
        let cigRecord = CigaretteRecordManager()
        let smokeAndCost = cigRecord.calculateAmountAndCost(curentDate, toDate: toDate)
        
        smoked.text  = String(smokeAndCost.smoked)
        cost.text = decimalFormatToCurency(smokeAndCost.cost)
 smokedLabel.text = cigarettesToPackDescription(smokeAndCost.smoked, sufix: "SMOKED")
    }
    
    
    func  drawChart()
    {
        
        if(segmentGraphType.selectedSegmentIndex == 0){
        
            calculateAdnDrowChartPie()
        }
        else
        {
            calculateAdnDrowChartMultiBar()
        }
    }
    
    
    func  calculateAdnDrowChartPie()
    {
        
        let cigRecord = CigaretteRecordManager()
        
        let fieldName = "reason"
        let arrReason:NSArray = cigRecord.calculateGraphDataByFieldName(curentDate, toDate: toDate, fieldName: fieldName)
       
        var description = [String]()
        var sumOfCigs = [Double]()
        
        
        if arrReason.count > 0 {
            
            for i in 0..<arrReason.count
            {
                if let desc:String = (arrReason[i] as! NSDictionary)[fieldName] as? String {
                    description.append(desc)
                }
                if let cigs = (arrReason[i] as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber {
                    sumOfCigs.append(Double(cigs))
                }
            }
            
          //  setChartPie(description, values: sumOfCigs)
        //    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
          //  let unitsSoldPie = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        }
        setChartPie(description, values: sumOfCigs)//(months, values: unitsSoldPie)

    }
    



func setChartPie(dataPoints: [String], values: [Double]) {
    
    var dataEntries: [ChartDataEntry] = []
    
    for i in 0..<dataPoints.count {
        let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
        dataEntries.append(dataEntry)
    }
    
    let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
    
    
    
    pieChartDataSet.colors = ChartColorTemplates.joyful()
    
    let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
    
//pieChartData.setDrawValues(true)
    pieChart.legend.labels = ["why"]
    
    pieChart.legend.position = ChartLegend.ChartLegendPosition.LeftOfChart
    
    pieChart.data = pieChartData
    
    
}
    
    
    
    func setChartPieOld(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
         //   print("\(values[i])")
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "why")
        
        pieChartDataSet.valueTextColor = UIColor.darkGrayColor()
        
        let colors:ColorTemplates = ColorTemplates();
        
        pieChartDataSet.colors = colors.chartPieColors()
        
        /* var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        print("\(red) \(green) \(blue)")
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        
        colors.append(color)
        
        }
        
        pieChartDataSet.colors = colors
        */
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
       // pieChartData.setDrawValues(false)
        pieChart.legend.labels = ["why"]
        
        pieChart.legend.position = ChartLegend.ChartLegendPosition.LeftOfChart
        
        pieChart.data = pieChartData
        
        //    pieChart.animate(xAxisDuration: NSTimeInterval(2))
        
    }
    /*
    let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: label)
    
    let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
    pieChartData.setDrawValues(false)
    pieChartView.legend.labels = [label]
    pieChartView.data = pieChartData
    pieChartView.animate(xAxisDuration: NSTimeInterval(5))
    
    */
    


    func  calculateAdnDrowChartMultiBar()
    {
        
        let cigRecord = CigaretteRecordManager()
        
        var fieldName = "levelOfEnjoy"
        
        var arrReason:NSArray = cigRecord.calculateGraphDataByFieldName(curentDate, toDate: toDate, fieldName: fieldName, orderByField: fieldName)
        
        let description: NSMutableArray = ["Level 1", "Level 2", "Level 3", "Level 4"]
        var sumOfCigsEnjoy = [Double]()
        var sumOfCigsNeed = [Double]()
  
        
        for var j = 0; j < description.count; j++
        {
            for var i = 0; i < arrReason.count; i++
            {
                if let desc = (arrReason[i] as! NSDictionary)[fieldName] as? NSNumber {

                    if(desc == j + 1){
                        if let cigs = (arrReason[i] as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber {
                            sumOfCigsEnjoy.append(Double(cigs))
                        }
                    }
                }
            }
            if(sumOfCigsEnjoy.count < j + 1){
                    sumOfCigsEnjoy.append(0)
            }
        }
        
        
        fieldName = "levelAsNeeded"
        arrReason = cigRecord.calculateGraphDataByFieldName(curentDate, toDate: toDate, fieldName: fieldName, orderByField: fieldName)
        
        for k in 0..<description.count {
            
        //}

        //for var k = 0; k < description.count; k++
        //{
            for i in 0..<arrReason.count
            {
                if let desc = (arrReason[i] as! NSDictionary)[fieldName] as? NSNumber {
                    
                    if(desc == k + 1){
                        if let cigs = (arrReason[i] as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber {
                            sumOfCigsNeed.append(Double(cigs))
                        }
                    }
                }
            }
            if(sumOfCigsNeed.count < k + 1){
                sumOfCigsNeed.append(0)
            }
        }
       
        setMultiBarChart(sumOfCigsEnjoy, values2: sumOfCigsNeed, xVals: description)
        
    
    }
    
    func setMultiBarChart( values: [Double], values2: [Double], xVals: NSMutableArray)
    {
        
        barChart.noDataText = "You need to provide data for the chart."
        var dataEntries1: [BarChartDataEntry] = []
        var dataEntries2: [BarChartDataEntry] = []
        
        for i in 0..<xVals.count {
            let dataEntry1 = BarChartDataEntry(value: values[i], xIndex: i)
            
            let dataEntry2 = BarChartDataEntry(value: values2[i], xIndex: i)
            dataEntries1.append(dataEntry1)
            dataEntries2.append(dataEntry2)
        }
        
        let chartDataSet1 = BarChartDataSet(yVals: dataEntries1, label: "Enjoyment")
        let chartDataSet2 = BarChartDataSet(yVals: dataEntries2, label: "Needed")
        chartDataSet1.colors = ColorTemplates.Enjoyment()
        chartDataSet2.colors = ColorTemplates.Needed()
        
        
        let t = ChartConverter()
        let chartData:BarChartData = t.setData(chartDataSet1, set2: chartDataSet2, xVals: xVals)

     //setDrawValueAboveBar
        chartData.groupSpace = 1
 //       chartData.setDrawValues(true)
        barChart.data = chartData
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getStringDate(dDate: NSDate, currentDateFormat: String)->String
    {
        let dateFormatter = NSDateFormatter()

        dateFormatter.dateFormat = currentDateFormat
    
        return dateFormatter.stringFromDate(dDate)
    }
    
    func loadScreenGraphics()
    {
        showChartBySegmntIndex(segmentGraphType.selectedSegmentIndex)
        
        barChart.descriptionText = ""
        pieChart.descriptionText = ""
        
        myPicker.delegate = self
        myPicker.hidden = true
        
        segmentDateType.selectedSegmentIndex = 1
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        selectedDate.inputView = datePickerView
     
        //set selected date to text field
     //   datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        datePickerView.addTarget(self, action: #selector(self.handleDatePicker(_:)),
                                 forControlEvents: UIControlEvents.ValueChanged)
     //todo
        //set init value
    //    showSelectedDate(NSDate(), dateFormat: Constants.dateFormat.day)
        
        calculateSelectedDate(0)
        
        
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
