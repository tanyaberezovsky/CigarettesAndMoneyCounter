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
    var monthPicker: UIPickerView = UIPickerView()
    var yearPicker: UIPickerView = UIPickerView()
    var curentDate:NSDate = NSDate()
    var toDate:NSDate = NSDate()
    
    @IBOutlet weak var smokedLabel: UILabel!
    @IBOutlet weak var smoked: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var horizontChart: HorizontalBarChartView!
   
    @IBOutlet weak var segmentDateType: UISegmentedControl!
    @IBOutlet weak var selectedDate: UITextField!
    
    @IBOutlet weak var segmentGraphType: UISegmentedControl!
    var pickerData = [ ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]]
    var pickerYearData = [String]()

    
    var arrYear = [String]()
    
    enum pickerComponent:Int{
        case size = 0
        case topping = 1
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        initBarChartUI()
        initHorizontalChartUI()
        initPieChartUI()
        createYearArr()
        loadScreenGraphics();

    }
    
    func initBarChartUI()
    {
        barChart.descriptionText = ""
        barChart.backgroundColor = UIColor.clearColor()
        barChart.xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.gridBackgroundColor = UIColor.clearColor()
        barChart.legend.position = ChartLegend.ChartLegendPosition.AboveChartLeft
        barChart.legend.textColor = UIColor.whiteColor()
        
        barChart.xAxis.labelTextColor = UIColor.whiteColor()
        barChart.leftAxis.valueFormatter = NSNumberFormatter()
        barChart.leftAxis.valueFormatter?.generatesDecimalNumbers = false
        barChart.leftAxis.customAxisMin = 0
        barChart.leftAxis.labelTextColor = UIColor.whiteColor()
        barChart.leftAxis.drawGridLinesEnabled = false
        barChart.rightAxis.drawGridLinesEnabled = false
        barChart.rightAxis.drawAxisLineEnabled = false
        barChart.rightAxis.drawLabelsEnabled = false
        
        
    }
    
    
    func initHorizontalChartUI()
    {
        
        horizontChart.descriptionText = ""
        horizontChart.backgroundColor = UIColor.clearColor()
        horizontChart.xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        
        horizontChart.xAxis.drawGridLinesEnabled = false
        horizontChart.gridBackgroundColor = UIColor.clearColor()
        horizontChart.legend.position = ChartLegend.ChartLegendPosition.AboveChartLeft
        horizontChart.legend.textColor = UIColor.whiteColor()
        horizontChart.rightAxis.labelTextColor = UIColor.whiteColor()
       
        horizontChart.infoTextColor = UIColor.whiteColor()
       horizontChart.xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        horizontChart.xAxis.labelTextColor = UIColor.whiteColor()
        horizontChart.xAxis.axisLineColor = UIColor.whiteColor()
        horizontChart.leftAxis.valueFormatter = NSNumberFormatter()
        horizontChart.leftAxis.valueFormatter?.generatesDecimalNumbers = false
        horizontChart.leftAxis.customAxisMin = 0
        horizontChart.leftAxis.labelTextColor = UIColor.whiteColor()
        
        horizontChart.leftAxis.axisLineColor = UIColor.whiteColor()
        horizontChart.leftAxis.drawGridLinesEnabled = false
        horizontChart.rightAxis.drawGridLinesEnabled = false
        horizontChart.rightAxis.drawAxisLineEnabled = false
        horizontChart.rightAxis.drawLabelsEnabled = false
        horizontChart.hidden = true
        
    }
    
    func initPieChartUI()
    {
        pieChart.descriptionText = ""
        
        //pieChart.noDataTextDescription = "Have five"
        pieChart.noDataText = "you don't smoke at this period"
        
        pieChart.backgroundColor = UIColor.clearColor()
       
        pieChart.holeColor = ColorTemplates.purpleGray()[1]
        
        pieChart.legend.labels = ["why"]
        pieChart.legend.textColor = UIColor.whiteColor()
        
        pieChart.legend.position = ChartLegend.ChartLegendPosition.LeftOfChart
        
        pieChart.hidden = true
        
        
    }
    
    @IBAction func graphTypeChanged(sender: UISegmentedControl) {
        
        showChartBySegmntIndex(sender.selectedSegmentIndex)
    }
    
    func  showChartBySegmntIndex(index: Int = 0)
    {
        drawChart()
        
        barChart.hidden = true
        pieChart.hidden = true
        horizontChart.hidden = true

        if (index == 0)
        {
            pieChart.hidden = false
        }
        else if (index == 1)
        {
            barChart.hidden = false
        }
        else  if (index == 2)
        {
            horizontChart.hidden = false
        }
        
    }
    
    
    
    func createYearArr()
    {
        if (arrYear.count > 0){ return;}
        
        for i in 1...10 {
            arrYear.append(String(2013 + i))
        }
        
        pickerData.append(arrYear)
        pickerYearData = arrYear
    }

    @IBAction func shiftBtnDateSubOnTouch(sender: UIButton) {
        calculateSelectedDate(-1)
    }
    
    @IBAction func shiftBtnDateAddOnTouch(sender: UIButton) {
        calculateSelectedDate(1)
    }
    
    @IBAction func selectedDateTouchDown(sender: UITextField) {
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.month:
            monthPicker.hidden = false
            yearPicker.hidden = true
        case Constants.SegmentDateType.year:
            monthPicker.hidden = true
            yearPicker.hidden = false
        default:
            return
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.month:
            return pickerData.count
        case Constants.SegmentDateType.year:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.month:
            return pickerData[component].count
        case Constants.SegmentDateType.year:
            return pickerYearData.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.month:
            return pickerData[component][row]
        case Constants.SegmentDateType.year:
            return pickerYearData[row]
        default:
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    //MARK -Instance Methods
    func updateLabel(){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        var currentDateStr:String
        var month:String
        var year:String
        
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.month:
            month = pickerData[0][monthPicker.selectedRowInComponent(0)]
            year = pickerData[1][monthPicker.selectedRowInComponent(1)]
            selectedDate.text =   String(format: "%@ %@", month, year)
            currentDateStr = String(format: "%d-01-%@", monthPicker.selectedRowInComponent(0) + 1, year)
        case Constants.SegmentDateType.year:
            year = pickerYearData[yearPicker.selectedRowInComponent(0)]
            selectedDate.text =  year
            currentDateStr = String(format: "01-01-%@", year)
        default:
            return;
        }
        curentDate = dateFormatter.dateFromString(currentDateStr)!
        calculateSelectedDate(0)
        
    }
    
    @IBAction func segmentDateTypeChanged(sender: UISegmentedControl) {
        
        currentSegmentDateType = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!.lowercaseString
        
        closeAllKeyboards()
        
        curentDate = NSDate()
        calculateSelectedDate(0)
       
    }
    
    
    func drawSelectedDate(){
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: curentDate)
     
        
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.day: //day
            selectedDate.inputView = datePickerView
            showSelectedDate(curentDate, dateFormat: Constants.dateFormat.day)
            datePickerView.date = curentDate
        case Constants.SegmentDateType.month://month
            let indexOfYear =  pickerData[1].indexOf(String(components.year))
            self.selectedDate.inputView = monthPicker
            selectedDate.text = self.getStringDate(curentDate, currentDateFormat: Constants.dateFormat.month)
            monthPicker.selectRow(components.month - 1, inComponent: 0, animated: true)
            monthPicker.selectRow(indexOfYear!, inComponent: 1, animated: true)
        case Constants.SegmentDateType.year:
            let indexOfYear =  pickerYearData.indexOf(String(components.year))
            self.selectedDate.inputView = yearPicker
            selectedDate.text = self.getStringDate(curentDate, currentDateFormat: Constants.dateFormat.year)
            yearPicker.selectRow(indexOfYear!, inComponent: 0, animated: true)
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
        //print(curentDate)
        //print(toDate)
        
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
        else if(segmentGraphType.selectedSegmentIndex == 1)
        {
            calculateAdnDrowChartMultiBar()
        }
        else if(segmentGraphType.selectedSegmentIndex == 2)
        {
            calculateAndDrowHorizontalChart()
        }

    }
    
    
    func  calculateAdnDrowChartPie()
    {
        
        let cigRecord = CigaretteRecordManager()
        
        let fieldName = "reason"
        let arrReason:NSArray = cigRecord.calculateGraphDataByFieldName(curentDate, toDate: toDate, fieldName: fieldName) //.sort {return $0 < $1}


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
            
        }
        setChartPie(description, values: sumOfCigs)//(months, values: unitsSoldPie)

    }
    


//load data
func setChartPie(dataPoints: [String], values: [Double]) {
    
    var dataEntries: [ChartDataEntry] = []
    
    for i in 0..<dataPoints.count {
        let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
        dataEntries.append(dataEntry)
    }
    
    let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
    
    
    pieChartDataSet.colors = ColorTemplates.chartPieColors()// ChartColorTemplates.joyful()
    
    let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
    
    
    pieChart.data = pieChartData
    
   
}
    
    
    func calculateAdnDrowChartMultiBar()
    {
        let cigRecord = CigaretteRecordManager()
        
        var fieldName = "levelOfEnjoy"
        
        var arrReason:NSArray = cigRecord.calculateGraphDataByFieldName(curentDate, toDate: toDate, fieldName: fieldName, orderByField: fieldName)
        
        let description: NSMutableArray = ["Level 0", "Level 1", "Level 2", "Level 3"]
        var sumOfCigsEnjoy = [Double]()
        var sumOfCigsNeed = [Double]()
        
        // for var j = 0; j < description.count; j++
        for j in 0..<description.count
        {
            // for var i = 0; i < arrReason.count; i++
            for i in 0..<arrReason.count
            {
                if let desc = (arrReason[i] as! NSDictionary)[fieldName] as? NSNumber {
                    
                    if(desc == j){
                        if let cigs = (arrReason[i] as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber {
                            sumOfCigsEnjoy.append(Double(cigs))
                        }
                    }
                }
            }
            if(sumOfCigsEnjoy.count <= j ){
                sumOfCigsEnjoy.append(0)
            }
        }
        
        
        fieldName = "levelAsNeeded"
        arrReason = cigRecord.calculateGraphDataByFieldName(curentDate, toDate: toDate, fieldName: fieldName, orderByField: fieldName)
        
        for k in 0..<description.count  {
            
            //}
            
            //for var k = 0; k < description.count; k++
            //{
            for i in 0..<arrReason.count
            {
                if let desc = (arrReason[i] as! NSDictionary)[fieldName] as? NSNumber {
                    
                    if(desc == k){
                        if let cigs = (arrReason[i] as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber {
                            sumOfCigsNeed.append(Double(cigs))
                        }
                    }
                }
            }
            if(sumOfCigsNeed.count <= k){
                sumOfCigsNeed.append(0)
            }
        }
        
        setMaxMilAxisElementBarChart(sumOfCigsEnjoy, values2: sumOfCigsNeed)
        
        setMultiBarChart(sumOfCigsEnjoy, values2: sumOfCigsNeed, xVals: description)
        
    }
    
    func   calculateAndDrowHorizontalChart()
    {
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.day:
            calculateAndDrowHorizontalChartByDay();
        case Constants.SegmentDateType.month:
            calculateAndDrowHorizontalChartByMonth();
        case Constants.SegmentDateType.year:
            calculateAndDrowHorizontalChartByYear();
        default:
            return
        }
    
    }
    
    func   calculateAndDrowHorizontalChartByDay()
    {
        
        
        let cigRecord = CigaretteRecordManager()
        
        var dataStringStart:String
        var dataStringEnd:String
        let dateFormatterStart = NSDateFormatter()
        dateFormatterStart.dateFormat = "MM-dd-yyyy HH:mm"
        
        // convert string into date
        var dateValueStart:NSDate?
        var dateValueEnd:NSDate?
        
        var monthSymbol: String
        //print(months.count)
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: curentDate)
        
        
        var description = [String]()
        var sumOfCigs = [Double]()
        
        let currenDate = NSDate()
        
        var evens = [Int]()
        
        for (_,i) in (0...23).reverse().enumerate() {
            evens.append(i)
            //monthSymbol = months[components.month] // month - from your date components
            dataStringStart = String(format: "%d-%d-%d %d:00", components.month, components.day ,components.year, i)
            dateValueStart = dateFormatterStart.dateFromString(dataStringStart)
            
            if dateValueStart > currenDate {
                continue
            }
            
            dataStringEnd = String(format: "%d-%d-%d %d:59", components.month, components.day ,components.year, i)
            dateValueEnd = dateFormatterStart.dateFromString(dataStringEnd)
            //print("month")
            //print(monthSymbol)
            monthSymbol = String(format: "%d:00", i)
            
            let arrCiggs:NSArray = cigRecord.calculateGraphDataByExpresion(dateValueStart!, toDate: dateValueEnd!)
            for i in 0..<arrCiggs.count
            {
                
                if let cigs = (arrCiggs[i] as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber {
                    sumOfCigs.append(Double(cigs))
                    description.append(monthSymbol)
                }
                else if sumOfCigs.count > 0 {
                    sumOfCigs.append(Double(0))
                    description.append(monthSymbol)
                }
                
                
            }
        }
        
        //setMaxMilAxisElement
        if let maxVal = sumOfCigs.maxElement(){
            horizontChart.leftAxis.customAxisMax = maxVal + 2
            setLabelCount(maxVal)
        }
        
        setHorizontalChartData(sumOfCigs, xVals: description)

        
    }
    
    func setLabelCount(maxVal:Double){
        var labelCount = maxVal
        if maxVal > 15 {labelCount = 15}
        horizontChart.leftAxis.labelCount = Int(labelCount)
    
    
    }

    
    func   calculateAndDrowHorizontalChartByMonth()
    {
        
        let cigRecord = CigaretteRecordManager()
        
        var dataStringStart:String
        var dataStringEnd:String
        let dateFormatterStart = NSDateFormatter()
        dateFormatterStart.dateFormat = "MM-dd-yyyy HH:mm"
        
        // convert string into date
        var dateValueStart:NSDate?
        var dateValueEnd:NSDate?
        
        let dateFormatter = NSDateFormatter()
        
        let months = dateFormatter.shortMonthSymbols
        var monthSymbol: String
        //print(months.count)
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: curentDate)
        
        
        var description = [String]()
        var sumOfCigs = [Double]()
      
        let currenDate = NSDate()
        
        var evens = [Int]()

        //let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        // Swift 1.2:
        let range = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: curentDate)
        
        let numDays = range.length

        for (_,i) in (1...numDays).reverse().enumerate() {
            evens.append(i)
            //monthSymbol = months[components.month] // month - from your date components
            dataStringStart = String(format: "%d-%d-%d 00:00", components.month, i ,components.year)
            dateValueStart = dateFormatterStart.dateFromString(dataStringStart)
            
            if dateValueStart > currenDate {
                continue
            }
            
            dataStringEnd = String(format: "%d-%d-%d 23:59", components.month, i ,components.year)
            dateValueEnd = dateFormatterStart.dateFromString(dataStringEnd)
            //print("month")
            //print(monthSymbol)
            monthSymbol = String(format: "%@ %d", months[components.month], i)
            
            let arrCiggs:NSArray = cigRecord.calculateGraphDataByExpresion(dateValueStart!, toDate: dateValueEnd!)
            for i in 0..<arrCiggs.count
            {
                
                if let cigs = (arrCiggs[i] as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber {
                    sumOfCigs.append(Double(cigs))
                    description.append(monthSymbol)
                }
                else if sumOfCigs.count > 0 {
                    sumOfCigs.append(Double(0))
                    description.append(monthSymbol)
                }
                
                
            }
        }
        
        //setMaxMilAxisElement
        if let maxVal = sumOfCigs.maxElement(){
            horizontChart.leftAxis.customAxisMax = maxVal + 2
            setLabelCount(maxVal)
        }
        
        setHorizontalChartData(sumOfCigs, xVals: description)
        
    }
    


    func   calculateAndDrowHorizontalChartByYear()
    {
       
        let cigRecord = CigaretteRecordManager()
        
        var dataStringStart:String
        let dateFormatterStart = NSDateFormatter()
        dateFormatterStart.dateFormat = "MM-dd-yyyy"
        
        // convert string into date
        var dateValueStart:NSDate? //= dateFormatterStart.dateFromString(dataStringStart)
        var dateValueEnd:NSDate? //= dateFormatterStart.dateFromString(dataStringStart)

        
        let dateFormatter = NSDateFormatter()
        
        let months = dateFormatter.shortMonthSymbols
        var monthSymbol: String
        //print(months.count)
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: curentDate)
        
        
        var description = [String]()
        var sumOfCigs = [Double]()
       /* for (index, number) in (0...10).reverse().enumerate() {
            //print("index \(index) , number \(number)")
        }*/
        let currenDate = NSDate()
        
      //  var evens = [Int]()
        for (_,i) in (0...11).reverse().enumerate() {
          //  evens.append(i)
            monthSymbol = months[i] // month - from your date components
            dataStringStart = String(format: "%d-01-%d", i+1, components.year)
            dateValueStart = dateFormatterStart.dateFromString(dataStringStart)
            
            if dateValueStart > currenDate {
                continue
            }
            
            dateValueEnd = dateValueStart!.endOfMonth()
            //print("month")
            //print(monthSymbol)
            
            let arrCiggs:NSArray = cigRecord.calculateGraphDataByExpresion(dateValueStart!, toDate: dateValueEnd!)
            for i in 0..<arrCiggs.count
            {
            
                        if let cigs = (arrCiggs[i] as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber {
                            sumOfCigs.append(Double(cigs))
                            description.append(monthSymbol)
                        }
                        else if sumOfCigs.count > 0 {
                            sumOfCigs.append(Double(0))
                            description.append(monthSymbol)
                }
                
                  
            }
        }
        
        //setMaxMilAxisElement
        if let maxVal = sumOfCigs.maxElement(){
            horizontChart.leftAxis.customAxisMax = maxVal + 10
            setLabelCount(maxVal)
        }
        
        setHorizontalChartData(sumOfCigs, xVals: description)
 
    }
    
    func setMaxMilAxisElementBarChart( values: [Double], values2: [Double])
    {
        guard let number1 = values.maxElement(), number2 = values2.maxElement() else { return }

        
        let maxVal = max(number1, number2)
        
        barChart.leftAxis.customAxisMax = maxVal
      //  barChart.leftAxis.customAxisMax = barChart.data!.yMax + 1.0
        barChart.leftAxis.labelCount = Int(maxVal)  // Int(barChart.leftAxis.customAxisMax - 1)
        
    }
    
    
    
    func setHorizontalChartData( values: [Double], xVals: [String])
    {
        
        barChart.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<xVals.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        chartDataSet.colors = ColorTemplates.HorizontalBarChartColor()
        chartDataSet.valueTextColor = UIColor.whiteColor()// ColorTemplates.HorizontalBarChartColor()[0]
        let chartData = BarChartData(xVals: xVals, dataSet: chartDataSet)
        chartData.groupSpace = 1
        horizontChart.data = chartData
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
        chartDataSet1.valueTextColor = ColorTemplates.Enjoyment()[0]
        chartDataSet2.valueTextColor = ColorTemplates.Needed()[0]
        
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
        
        loadGraphicsSettings()
        
        showChartBySegmntIndex(segmentGraphType.selectedSegmentIndex)
        
        
        monthPicker.delegate = self
        monthPicker.hidden = true
        
        yearPicker.delegate = self
        yearPicker.hidden = true
        
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
    
    //++++++++++++++++++++++++++++++++++++
    //  load Graphics Settings
    //++++++++++++++++++++++++++++++++++++
    func loadGraphicsSettings() {
        
        //set button look like text field
        var layerLevelAsNeeded: CALayer
        
        //set button look like text field
        layerLevelAsNeeded = selectedDate.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
        layerLevelAsNeeded = segmentDateType.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
        
        
        layerLevelAsNeeded = segmentGraphType.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.CGColor
    }
    
    //set selected date to text field
    func handleDatePicker(sender: UIDatePicker) {
        showSelectedDate(sender.date, dateFormat: Constants.dateFormat.day)
        curentDate = sender.date
        calculateSelectedDate(0)
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
