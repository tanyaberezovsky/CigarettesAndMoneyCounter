//
//  SummaryViewController.swift
//  CigarettesAndMoneyCounter
//orit
//  Created by Tania on 27/11/2015.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//


import UIKit
import CoreData
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

import Charts

class SummaryViewController: GlobalUIViewController, UIPickerViewDataSource,UIPickerViewDelegate, NSFetchedResultsControllerDelegate
{
   // @IBOutlet weak var barChartView: HorizontalBarChartView!

    var currentSegmentDateType  = Constants.SegmentDateType.month
    
    var datePickerView  : UIDatePicker = UIDatePicker()
    var monthPicker: UIPickerView = UIPickerView()
    var yearPicker: UIPickerView = UIPickerView()
    var curentDate:Date = Date()
    var toDate:Date = Date()
    
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
       // barChart.descriptionText = ""
        barChart.chartDescription?.text = ""
        barChart.backgroundColor = UIColor.clear
        barChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.gridBackgroundColor = UIColor.clear
        
     ///   barChart.legend.position = Legend.Position.aboveChartLeft
       //'Position' is deprecated: Use `horizontalAlignment`, `verticalAlignment`, `orientation`, `drawInside`, `direction`.
        barChart.legend.verticalAlignment = Legend.VerticalAlignment.top
        barChart.legend.orientation = Legend.Orientation.horizontal
        barChart.legend.direction = Legend.Direction.leftToRight
        
        barChart.legend.textColor = UIColor.white
        
        barChart.xAxis.labelTextColor = UIColor.white
        
        ///!barChart.leftAxis.valueFormatter = (NumberFormatter() as! IAxisValueFormatter)
        ///barChart.leftAxis.valueFormatter?.generatesDecimalNumbers = false
        barChart.xAxis.valueFormatter = DefaultAxisValueFormatter(formatter: NumberFormatter())
        barChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: NumberFormatter())
        
        barChart.leftAxis.axisMinimum = 0///.customAxisMin = 0
        barChart.leftAxis.labelTextColor = UIColor.white
        barChart.leftAxis.drawGridLinesEnabled = false
        barChart.rightAxis.drawGridLinesEnabled = false
        barChart.rightAxis.drawAxisLineEnabled = false
        barChart.rightAxis.drawLabelsEnabled = false
        
        
    }
    
    
    func initHorizontalChartUI()
    {
        
        horizontChart.chartDescription?.text = ""
        horizontChart.backgroundColor = UIColor.clear
        horizontChart.xAxis.labelPosition =  XAxis.LabelPosition.bottom

        
        horizontChart.xAxis.drawGridLinesEnabled = false
        horizontChart.gridBackgroundColor = UIColor.clear
       /// horizontChart.legend.position = Legend.Position.aboveChartLeft
        horizontChart.legend.verticalAlignment = Legend.VerticalAlignment.top
        horizontChart.legend.orientation = Legend.Orientation.horizontal
        horizontChart.legend.direction = Legend.Direction.leftToRight
        
        horizontChart.legend.textColor = UIColor.white
        horizontChart.rightAxis.labelTextColor = UIColor.white
       
        ///horizontChart.infoTextColor = UIColor.white
        horizontChart.xAxis.labelPosition =  XAxis.LabelPosition.bottom
        horizontChart.xAxis.labelTextColor = UIColor.white
        horizontChart.xAxis.axisLineColor = UIColor.white
        ///!horizontChart.leftAxis.valueFormatter = (NumberFormatter() as! IAxisValueFormatter)
       /// horizontChart.leftAxis.valueFormatter?.generatesDecimalNumbers = false
        horizontChart.xAxis.valueFormatter = DefaultAxisValueFormatter(formatter: NumberFormatter())
        horizontChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: NumberFormatter())
        horizontChart.rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: NumberFormatter())
        
        //horizontChart.leftAxis.axisMinimum = 0 //.customAxisMin = 0
        horizontChart.leftAxis.labelTextColor = UIColor.white
        
        horizontChart.leftAxis.axisLineColor = UIColor.white
        horizontChart.leftAxis.drawGridLinesEnabled = false
        horizontChart.rightAxis.drawGridLinesEnabled = false
        horizontChart.rightAxis.drawAxisLineEnabled = false
        horizontChart.rightAxis.drawLabelsEnabled = false
        horizontChart.isHidden = true
        
    }
    
    func initPieChartUI()
    {
        pieChart.chartDescription?.text = ""
        
        //pieChart.noDataTextDescription = "Have five"
        pieChart.noDataText = "you don't smoke at this period"
        
        pieChart.backgroundColor = UIColor.clear
       
        pieChart.holeColor = ColorTemplates.purpleGray()[1]
        
        ///pieChart.legend..labels = ["why"]
        ///'labels' is deprecated: Use `entries`.
        pieChart.legend.textColor = UIColor.white
        ///pieChart.xAxis.valueFormatter = DefaultAxisValueFormatter(formatter: NumberFormatter())

       /// pieChart.legend.position = Legend.Position.leftOfChart
        pieChart.legend.verticalAlignment = Legend.VerticalAlignment.top
        pieChart.legend.orientation = Legend.Orientation.vertical
        pieChart.legend.direction = Legend.Direction.leftToRight
        pieChart.legend.drawInside = true
        pieChart.legend.textColor = UIColor.white
       // pieChart.usePercentValuesEnabled = true
        pieChart.drawEntryLabelsEnabled = false
        pieChart.isHidden = true
        
        
    }
    
    @IBAction func graphTypeChanged(_ sender: UISegmentedControl) {
        
        showChartBySegmntIndex(sender.selectedSegmentIndex)
    }
    
    func  showChartBySegmntIndex(_ index: Int = 0)
    {
        drawChart()
        
        barChart.isHidden = true
        pieChart.isHidden = true
        horizontChart.isHidden = true

        if (index == 0)
        {
            pieChart.isHidden = false
        }
        else if (index == 1)
        {
            barChart.isHidden = false
        }
        else  if (index == 2)
        {
            horizontChart.isHidden = false
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

    @IBAction func shiftBtnDateSubOnTouch(_ sender: UIButton) {
        calculateSelectedDate(-1)
    }
    
    @IBAction func shiftBtnDateAddOnTouch(_ sender: UIButton) {
        calculateSelectedDate(1)
    }
    
    @IBAction func selectedDateTouchDown(_ sender: UITextField) {
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.month:
            monthPicker.isHidden = false
            yearPicker.isHidden = true
        case Constants.SegmentDateType.year:
            monthPicker.isHidden = true
            yearPicker.isHidden = false
        default:
            return
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.month:
            return pickerData.count
        case Constants.SegmentDateType.year:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.month:
            return pickerData[component].count
        case Constants.SegmentDateType.year:
            return pickerYearData.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.month:
            return pickerData[component][row]
        case Constants.SegmentDateType.year:
            return pickerYearData[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    //MARK -Instance Methods
    func updateLabel(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        var currentDateStr:String
        var month:String
        var year:String
        
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.month:
            month = pickerData[0][monthPicker.selectedRow(inComponent: 0)]
            year = pickerData[1][monthPicker.selectedRow(inComponent: 1)]
            selectedDate.text =   String(format: "%@ %@", month, year)
            currentDateStr = String(format: "%d-01-%@", monthPicker.selectedRow(inComponent: 0) + 1, year)
        case Constants.SegmentDateType.year:
            year = pickerYearData[yearPicker.selectedRow(inComponent: 0)]
            selectedDate.text =  year
            currentDateStr = String(format: "01-01-%@", year)
        default:
            return;
        }
        curentDate = dateFormatter.date(from: currentDateStr)!
        calculateSelectedDate(0)
        
    }
    
    @IBAction func segmentDateTypeChanged(_ sender: UISegmentedControl) {
        
        currentSegmentDateType = sender.titleForSegment(at: sender.selectedSegmentIndex)!.lowercased()
        
        closeAllKeyboards()
        
        curentDate = Date()
        calculateSelectedDate(0)
       
    }
    
    
    func drawSelectedDate(){
        let components = (Calendar.current as NSCalendar).components([.day, .month, .year], from: curentDate)
     
        
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.day: //day
            selectedDate.inputView = datePickerView
            showSelectedDate(curentDate, dateFormat: Constants.dateFormat.day)
            datePickerView.date = curentDate
        case Constants.SegmentDateType.month://month
            let indexOfYear =  pickerData[1].index(of: String(describing: components.year!))
            self.selectedDate.inputView = monthPicker
            selectedDate.text = self.getStringDate(curentDate, currentDateFormat: Constants.dateFormat.month)
            monthPicker.selectRow(components.month! - 1, inComponent: 0, animated: true)
            monthPicker.selectRow(indexOfYear!, inComponent: 1, animated: true)
        case Constants.SegmentDateType.year:
            let indexOfYear =  pickerYearData.index(of: String(describing: components.year!))
            self.selectedDate.inputView = yearPicker
            selectedDate.text = self.getStringDate(curentDate, currentDateFormat: Constants.dateFormat.year)
            yearPicker.selectRow(indexOfYear!, inComponent: 0, animated: true)
       default:
            return;
        }
       
    }
    
    
    
    func calculateSelectedDate(_ shiftFactor: Int = 0){
        let components = (Calendar.current as NSCalendar).components([.day, .month, .year], from: curentDate)
        let userCalendar = Calendar.current
        var dateComponents = DateComponents()
        
        var unitDate : NSCalendar.Unit = NSCalendar.Unit.day
        
        switch(currentSegmentDateType){
        case Constants.SegmentDateType.year:
            unitDate = NSCalendar.Unit.year
            dateComponents.month = 1
            dateComponents.day = 1
        case Constants.SegmentDateType.month://month
            unitDate = NSCalendar.Unit.month
            dateComponents.month = components.month
            dateComponents.day = 1
        default:
            unitDate = NSCalendar.Unit.day
            dateComponents.month = components.month
            dateComponents.day = components.day
 
        }
        
        dateComponents.year = components.year
        curentDate = userCalendar.date(from: dateComponents)!
        
        curentDate = (Calendar.current as NSCalendar).date(
            byAdding: unitDate,
            value: shiftFactor,
            to: curentDate,
            options: NSCalendar.Options(rawValue: 0))!

        toDate = (Calendar.current as NSCalendar).date(
            byAdding: unitDate,
            value: 1,
            to: curentDate,
            options: NSCalendar.Options(rawValue: 0))!
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
        let arrReason2:NSArray = cigRecord.calculateGraphDataByFieldName(curentDate, toDate: toDate, fieldName: fieldName)//.sort {return $0 < $1}


        var description = [String]()
        var sumOfCigs = [Double]()
        var cigsTotal:Int
        
        var arrReason = arrReason2.sortedArray (comparator: {
            (obj1, obj2) -> ComparisonResult in
            
            let first = Double(((obj1 as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber)!)
            let second = Double(((obj2 as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber)!)
            
            if (first < second) {
                return ComparisonResult.orderedDescending;
            } else {
                return ComparisonResult.orderedAscending;
            }
        })

        
        if arrReason.count > 0 {
            
            for i in 0..<arrReason.count
            {
                if let cigs = (arrReason[i] as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber {
                    sumOfCigs.append(Double(cigs))
                    cigsTotal = Int(cigs)
                }
                else{
                    cigsTotal = 0}
                
                if let desc:String = (arrReason[i] as! NSDictionary)[fieldName] as? String {
                   // description.append(desc)
                    description.append(String(format: "%d-%@", cigsTotal, desc))
                }
            }
            
        }
        setChartPie(description, values: sumOfCigs)//(months, values: unitsSoldPie)

    }
    


//load data
    func setChartPie(_ dataPoints: [String], values: [Double]) {
        
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            ///        let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i]) //(x: Double(i), y: values[i])
            
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        
        pieChartDataSet.yValuePosition = .insideSlice
        
        pieChartDataSet.colors = ColorTemplates.chartPieColors()// ChartColorTemplates.joyful()
        //   let pieChartData1 = PieChartData(xVals: dataPoints, dataSets: pieChartDataSet)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        
        
        //pieChartDataSet.valueFormatter =  IValueFormatter(formatter: numberFormatter)

        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        //pieChartData.init xVals =  dataPoints
        //DefaultAxisValueFormatter(formatter: NumberFormatter())

//        let numFormtPercents: NumberFormatter = NumberFormatter()
//        numFormtPercents.numberStyle = .percent
//        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: numFormtPercents))
        pieChartData.setDrawValues(false)
        
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
                    
                    if(desc.intValue == j){
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
                    
                    if(desc.intValue == k){
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
        let dateFormatterStart = DateFormatter()
        dateFormatterStart.dateFormat = "MM-dd-yyyy HH:mm"
        
        // convert string into date
        var dateValueStart:Date?
        var dateValueEnd:Date?
        
        var monthSymbol: String = String()
        //print(months.count)
        let components = (Calendar.current as NSCalendar).components([.day, .month, .year], from: curentDate)
        
        
        var description = [String]()
        var sumOfCigs = [Double]()
        
        let currenDate = Date()
        
        var evens = [Int]()
        
        for (_,i) in (0...23).reversed().enumerated() {
            evens.append(i)
            //monthSymbol = months[components.month] // month - from your date components
            dataStringStart = String(format: "%d-%d-%d %d:00", components.month!, components.day! ,components.year!, i)
            dateValueStart = dateFormatterStart.date(from: dataStringStart)
            
            if dateValueStart > currenDate {
                continue
            }
            
            dataStringEnd = String(format: "%d-%d-%d %d:59", components.month!, components.day! ,components.year!, i)
            dateValueEnd = dateFormatterStart.date(from: dataStringEnd)
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
        //description.append(monthSymbol)
        
        //setMaxMilAxisElement
        if let maxVal = sumOfCigs.max(){
            setLabelCount(maxVal)
        }
        //print(description)
        
        setHorizontalChartData(sumOfCigs, xVals: description)

        
    }
    
    func setLabelCount(_ val:Double){
        
        var maxVal = val
        var labelCount = maxVal
        if maxVal > 15 {labelCount = 15
            maxVal = maxVal + (maxVal / 100 * 1.5)
        }
        
        horizontChart.leftAxis.axisMaximum = maxVal + 1 ///.customAxisMax = maxVal + 1
        horizontChart.leftAxis.labelCount = Int(labelCount) / 2 + 2
    }

    
    func   calculateAndDrowHorizontalChartByMonth()
    {
        
        let cigRecord = CigaretteRecordManager()
        
        var dataStringStart:String
        var dataStringEnd:String
        let dateFormatterStart = DateFormatter()
        dateFormatterStart.dateFormat = "MM-dd-yyyy HH:mm"
        
        // convert string into date
        var dateValueStart:Date?
        var dateValueEnd:Date?
        
        let dateFormatter = DateFormatter()
        
        let months = dateFormatter.shortMonthSymbols
        var monthSymbol: String = String()
        //print(months.count)
        let components = (Calendar.current as NSCalendar).components([.day, .month, .year], from: curentDate)
        
        
        var description = [String]()
        var sumOfCigs = [Double]()
      
        let currenDate = Date()
        
        var evens = [Int]()

        //let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        // Swift 1.2:
        let range = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: curentDate)
        
        let numDays = range.length

        for (_,i) in (1...numDays).reversed().enumerated() {
            evens.append(i)
            //monthSymbol = months[components.month] // month - from your date components
            dataStringStart = String(format: "%d-%d-%d 00:00", components.month!, i ,components.year!)
            dateValueStart = dateFormatterStart.date(from: dataStringStart)
            
            if dateValueStart > currenDate {
                continue
            }
            
            dataStringEnd = String(format: "%d-%d-%d 23:59", components.month!, i ,components.year!)
            dateValueEnd = dateFormatterStart.date(from: dataStringEnd)
            //print("month")
            //print(monthSymbol)
            monthSymbol = String(format: "%@ %d", (months?[components.month! - 1])!, i)
            
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
        //description.append(monthSymbol)
        
        //setMaxMilAxisElement
        if let maxVal = sumOfCigs.max(){
            setLabelCount(maxVal)
        }
        
        setHorizontalChartData(sumOfCigs, xVals: description)
        
    }
    


    func   calculateAndDrowHorizontalChartByYear()
    {
       
        let cigRecord = CigaretteRecordManager()
        
        var dataStringStart:String
        let dateFormatterStart = DateFormatter()
        dateFormatterStart.dateFormat = "yyyy-MM-dd"
        
        // convert string into date
        var dateValueStart:Date! //= dateFormatterStart.dateFromString(dataStringStart)
        var dateValueEnd:Date!//= dateFormatterStart.dateFromString(dataStringStart)

        
        let dateFormatter = DateFormatter()
        
        let months = dateFormatter.shortMonthSymbols
        var monthSymbol: String = String()
        //print(months.count)
        let components = (Calendar.current as NSCalendar).components([.day, .month, .year], from: curentDate)
        
        
        var description = [String]()
        var sumOfCigs = [Double]()
       /* for (index, number) in (0...10).reverse().enumerate() {
            //print("index \(index) , number \(number)")
        }*/
        let currenDate = Date()
        
      //  var evens = [Int]()
        for (_,i) in (0...11).reversed().enumerated() {
          //  evens.append(i)
            monthSymbol = (months?[i])! // month - from your date components
            dataStringStart = String(format: "%d-%d-01", components.year!, i+1)
            dateValueStart = dateFormatterStart.date(from: dataStringStart)!
            
            if dateValueStart > currenDate {
                continue
            }
            
            dateValueEnd = dateFormatterStart.date(from:  String(format: "%d-%d-15", components.year!, i+1))!.endOfMonth()!
            dateValueEnd = dateValueEnd.endOfMonth()!
            
            print(currenDate)
            print(dateValueStart)
            print(dateValueEnd)
            
            let arrCiggs:NSArray = cigRecord.calculateGraphDataByExpresion(dateValueStart, toDate: dateValueEnd)
            for k in 0..<arrCiggs.count
            {
            
                        if let cigs = (arrCiggs[k] as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber {
                            sumOfCigs.append(Double(cigs))
                            description.append(monthSymbol)
                        }
                        else if sumOfCigs.count > 0 {
                            sumOfCigs.append(Double(0))
                            description.append(monthSymbol)
                }
                
                  
            }
        }
       // description.append(monthSymbol)
        
        //setMaxMilAxisElement
        if let maxVal = sumOfCigs.max(){
            horizontChart.leftAxis.axisMaximum = maxVal + 10
            setLabelCount(maxVal)
        }
        
        
        setHorizontalChartData(sumOfCigs, xVals: description)
 
    }
    
    func setMaxMilAxisElementBarChart( _ values: [Double], values2: [Double])
    {
        guard let number1 = values.max(), let number2 = values2.max() else { return }

        
        var maxVal = max(number1, number2)
        
        var labelCount = maxVal
        if maxVal > 15 {labelCount = 15
            maxVal = maxVal + (maxVal / 100 * 1.5)
        }
        
        barChart.leftAxis.axisMaximum = maxVal + 1
        barChart.leftAxis.labelCount = Int(labelCount) / 2 + 2
        
        

    }
    
    
    
    func setHorizontalChartData( _ values: [Double],  xVals: [String])
    {
        if(xVals.count == 0){
            horizontChart.clear()
            horizontChart.clearValues()
            return
        }
        
         var newxVals: [String] = xVals
    
        //add "" becouse of component index bug
        newxVals.append("")
        
        let labelCount = newxVals.count - 1 > 10 ? 10 : newxVals.count - 1
        
        horizontChart.xAxis.labelCount = labelCount
        horizontChart.xAxis.axisMinimum = 0
        horizontChart.xAxis.axisMaximum = Double(newxVals.count - 1)
        
        barChart.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        let formato:HorizontalBarChartFormatter = HorizontalBarChartFormatter()
        
        formato.months = newxVals
        
        let xaxis:XAxis = XAxis()
  
        for i in 0..<newxVals.count - 1 {
            ///let dataEntry0 = BarChartDataEntry(value: values[i], xIndex: i)
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i]])
            
            dataEntries.append(dataEntry)
            
            _ = formato.stringForValue(Double(i), axis: xaxis)
        }
        
        xaxis.valueFormatter = formato
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Smoked cigarettes")
        chartDataSet.colors = ColorTemplates.HorizontalBarChartColor()
        chartDataSet.valueTextColor = UIColor.white// ColorTemplates.HorizontalBarChartColor()[0]
    ///    let chartData = BarChartData(xVals: xVals, dataSet: chartDataSet)
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setValueFormatter(DefaultValueFormatter(formatter: NumberFormatter()))
        
        horizontChart.xAxis.valueFormatter = xaxis.valueFormatter
       /// chartData.groupSpace = 1
        horizontChart.data = chartData
    }
    
    
    func setMultiBarChart( _ values: [Double], values2: [Double], xVals: NSMutableArray)
    {
        let formato:BarChartFormatter = BarChartFormatter()
        let xaxis:XAxis = XAxis()
        
        var dataSets: [ChartDataSet] = [ChartDataSet]()
        
        barChart.noDataText = "You need to provide data for the chart."
        var dataEntries1: [BarChartDataEntry] = []
     //   var dataEntries2: [BarChartDataEntry] = []
        var dataEntry1: BarChartDataEntry
       // var dataEntry2: BarChartDataEntry
        
        for i in 0..<xVals.count {
            //            let dataEntry = BarChartDataEntry(x: Double(i+2), y:values[i], data: xVals )
            //    1        dataEntry1 = BarChartDataEntry(x: Double(i+2), yValues:values, label:  xVals[i] as! String )
            //     1       dataEntry2 = BarChartDataEntry(x: Double(i+2), yValues:values2, label:  xVals[i] as! String )
            
            dataEntry1 = BarChartDataEntry(x: Double(i), yValues:[values[i] ])
        //    dataEntry2 = BarChartDataEntry(x: Double(i), y:values2[i] )
            //
            //        3    dataEntry1 = BarChartDataEntry(x: Double(i), yValues: [values[i]], label: xVals[i] as! String)
            //        3    dataEntry2 = BarChartDataEntry(x: Double(i), yValues: [values2[i]], label: xVals[i] as! String)
            //            ///let dataEntry1 = BarChartDataEntry(value: values[i], xIndex: i)
            
            ///let dataEntry2 = BarChartDataEntry(value: values2[i], xIndex: i)
            dataEntries1.append(dataEntry1)
         //   dataEntries2.append(dataEntry2)
            
            //4    let dataEntry = BarChartDataEntry.init(x: Double(i), yValues: [values[i],values2[i]])//, data: xVals[i] as! String)
            //4  dataEntries1.append(dataEntry1)
            
            _ =  formato.stringForValue(Double(i), axis: xaxis)
            xaxis.valueFormatter = formato
            
            let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: "Enjoyment")
       //     let chartDataSet2 = BarChartDataSet(values: dataEntries2, label: "Needed")
            chartDataSet1.colors = [ UIColor(red: 235/255.0, green: 155/255.0, blue: 152/255.0, alpha: 1.0), UIColor(red: 152/255.0, green: 235/255.0, blue: 196/255.0, alpha: 1.0)]

            //chartDataSet2.colors = ColorTemplates.Needed()
            chartDataSet1.valueTextColor = ColorTemplates.Enjoyment()[0]
          //  chartDataSet2.valueTextColor = ColorTemplates.Needed()[0]
            
            // let t = ChartConverter()
            //let chartData:BarChartData = t.setData(chartDataSet1, set2: chartDataSet2, xVals: xVals)
            
            //NSMutableArray *dataSets = [[NSMutableArray alloc] init];
            dataSets.append(chartDataSet1)
       //     dataSets.append(chartDataSet2)
            
        }
       
        let chartData: BarChartData = BarChartData.init( dataSets: dataSets)
        ///BarChartData *data = [[BarChartData alloc] initWithX:xVals dataSets:dataSets];
        //     BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        
        //setDrawValueAboveBar
        ///    chartData.groupSpace = 1
        //       chartData.setDrawValues(true)
        chartData.setValueFormatter(DefaultValueFormatter(formatter: NumberFormatter()))
        
        barChart.xAxis.valueFormatter = xaxis.valueFormatter
        barChart.data = chartData
        
    }
    
    
    
//    
//    
//    func setMultiBarChart( _ values: [Double], values2: [Double], xVals: NSMutableArray)
//    {
//        let formato:BarChartFormatter = BarChartFormatter()
//        let xaxis:XAxis = XAxis()
//        
//        
//        barChart.noDataText = "You need to provide data for the chart."
//        var dataEntries1: [BarChartDataEntry] = []
//        var dataEntries2: [BarChartDataEntry] = []
//        var dataEntry1: BarChartDataEntry
//        var dataEntry2: BarChartDataEntry
//        
//        for i in 0..<xVals.count {
////            let dataEntry = BarChartDataEntry(x: Double(i+2), y:values[i], data: xVals )
////    1        dataEntry1 = BarChartDataEntry(x: Double(i+2), yValues:values, label:  xVals[i] as! String )
////     1       dataEntry2 = BarChartDataEntry(x: Double(i+2), yValues:values2, label:  xVals[i] as! String )
//
//           dataEntry1 = BarChartDataEntry(x: Double(i), y:values[i] )
//           dataEntry2 = BarChartDataEntry(x: Double(i), y:values2[i] )
////            
////        3    dataEntry1 = BarChartDataEntry(x: Double(i), yValues: [values[i]], label: xVals[i] as! String)
////        3    dataEntry2 = BarChartDataEntry(x: Double(i), yValues: [values2[i]], label: xVals[i] as! String)
////            ///let dataEntry1 = BarChartDataEntry(value: values[i], xIndex: i)
//            
//            ///let dataEntry2 = BarChartDataEntry(value: values2[i], xIndex: i)
//            dataEntries1.append(dataEntry1)
//           dataEntries2.append(dataEntry2)
//      
//        //4    let dataEntry = BarChartDataEntry.init(x: Double(i), yValues: [values[i],values2[i]])//, data: xVals[i] as! String)
//          //4  dataEntries1.append(dataEntry1)
//
//           _ =  formato.stringForValue(Double(i), axis: xaxis)
//
//        }
//        xaxis.valueFormatter = formato
//        
//        let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: "Enjoyment")
//        let chartDataSet2 = BarChartDataSet(values: dataEntries2, label: "Needed")
//        chartDataSet1.colors = ColorTemplates.Enjoyment()
//        chartDataSet2.colors = ColorTemplates.Needed()
//        chartDataSet1.valueTextColor = ColorTemplates.Enjoyment()[0]
//        chartDataSet2.valueTextColor = ColorTemplates.Needed()[0]
//        
//       // let t = ChartConverter()
//        //let chartData:BarChartData = t.setData(chartDataSet1, set2: chartDataSet2, xVals: xVals)
//
//        //NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//        var dataSets: [ChartDataSet] = [ChartDataSet]()
//        dataSets.append(chartDataSet1)
//        dataSets.append(chartDataSet2)
//  
//        let chartData: BarChartData = BarChartData.init( dataSets: dataSets)
//        ///BarChartData *data = [[BarChartData alloc] initWithX:xVals dataSets:dataSets];
//   //     BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
//        
//     //setDrawValueAboveBar
//    ///    chartData.groupSpace = 1
// //       chartData.setDrawValues(true)
//        chartData.setValueFormatter(DefaultValueFormatter(formatter: NumberFormatter()))
//        
//        barChart.xAxis.valueFormatter = xaxis.valueFormatter
//        barChart.data = chartData
//    }
//    
//    
//    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getStringDate(_ dDate: Date, currentDateFormat: String)->String
    {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = currentDateFormat
    
        return dateFormatter.string(from: dDate)
    }
    
    func loadScreenGraphics()
    {
        
        loadGraphicsSettings()
        
        showChartBySegmntIndex(segmentGraphType.selectedSegmentIndex)
        
        
        monthPicker.delegate = self
        monthPicker.isHidden = true
        
        yearPicker.delegate = self
        yearPicker.isHidden = true
        
        segmentDateType.selectedSegmentIndex = 1
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        selectedDate.inputView = datePickerView
     
        //set selected date to text field
     //   datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        datePickerView.addTarget(self, action: #selector(self.handleDatePicker(_:)),
                                 for: UIControlEvents.valueChanged)
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
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
        
        
        layerLevelAsNeeded = segmentDateType.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
        
        
        layerLevelAsNeeded = segmentGraphType.layer
        layerLevelAsNeeded.cornerRadius = 5
        layerLevelAsNeeded.borderWidth = 0.5
        layerLevelAsNeeded.borderColor = UIColors.Segment.selected.cgColor
    }
    
    //set selected date to text field
    func handleDatePicker(_ sender: UIDatePicker) {
        showSelectedDate(sender.date, dateFormat: Constants.dateFormat.day)
        curentDate = sender.date
        calculateSelectedDate(0)
    }

    func showSelectedDate(_ date: Date, dateFormat: String){
        selectedDate.text = self.getStringDate(date, currentDateFormat: dateFormat)
    }
    
    func closeAllKeyboards()
    {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeAllKeyboards()
    }
    
}
