//
//  SummaryViewController.swift
//  CigarettesAndMoneyCounter
//orit
//  Created by Tania on 27/11/2015.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//


import UIKit
import CoreData
import GoogleMobileAds
import Charts

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


class SummaryViewController: GlobalUIViewController, UIPickerViewDataSource,UIPickerViewDelegate, NSFetchedResultsControllerDelegate
{
    @IBOutlet weak var adBannerView: GADBannerView!
    fileprivate let userDefaults = UserDefaultsDataController.sharedInstance.loadUserDefaults()
    
    var currentSegmentDateType  = Constants.SegmentDateType.month
    
    var datePickerView  : UIDatePicker = UIDatePicker()
    var monthPicker: UIPickerView = UIPickerView()
    var yearPicker: UIPickerView = UIPickerView()
    var curentDate:Date = Date()
    var toDate:Date = Date()
    
    @IBOutlet weak var smokedLabel: UILabel!
    @IBOutlet weak var smoked: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var horizontChart: BarChartView!// HorizontalBarChartView!
   
    @IBOutlet weak var segmentDateType: UISegmentedControl!
    @IBOutlet weak var selectedDate: UITextField!
    
    @IBOutlet weak var segmentGraphType: UISegmentedControl!
    var pickerData = [ ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]]
    var pickerYearData = [String]()

    
    var arrYear = [String]()
    
    let lvlChart1 = LevelsPieChartView()
    let lvlChart2 = LevelsPieChartView()
    
    
    enum pickerComponent:Int{
        case size = 0
        case topping = 1
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initAd()
        initHorizontalChartUI()
        initPieChartUI()
        createYearArr()
        loadScreenGraphics()

    }
    
    func initAd(){
        adBannerView.adUnitID = Keys.adMob.unitID
        adBannerView.rootViewController = self
        adBannerView.load(GADRequest())
//        let request: GADRequest = GADRequest()
//        request.testDevices = [Keys.adMob.unitID, kGADSimulatorID]
//        adBannerView.load(request)

    }
    
    func initHorizontalChartUI()
    {
        
        horizontChart.chartDescription?.text = ""
        horizontChart.backgroundColor = UIColor.clear
        horizontChart.xAxis.labelPosition =  XAxis.LabelPosition.bottom

        
        horizontChart.xAxis.drawGridLinesEnabled = false
        horizontChart.gridBackgroundColor = UIColor.clear
        horizontChart.legend.verticalAlignment = Legend.VerticalAlignment.top
        horizontChart.legend.orientation = Legend.Orientation.horizontal
        horizontChart.legend.direction = Legend.Direction.leftToRight
        
        horizontChart.legend.textColor = UIColor.white
        horizontChart.rightAxis.labelTextColor = UIColor.white
       
        horizontChart.xAxis.labelPosition =  XAxis.LabelPosition.bottom
        horizontChart.xAxis.labelTextColor = UIColor.white
        horizontChart.xAxis.axisLineColor = UIColor.white
        horizontChart.xAxis.valueFormatter = DefaultAxisValueFormatter(formatter: NumberFormatter())
        horizontChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: NumberFormatter())
        horizontChart.rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: NumberFormatter())
        
        horizontChart.leftAxis.labelTextColor = UIColor.white
        
        horizontChart.xAxis.labelRotationAngle = 60
        
        horizontChart.leftAxis.axisLineColor = UIColor.white
        horizontChart.leftAxis.drawGridLinesEnabled = false
        horizontChart.rightAxis.drawGridLinesEnabled = false
        horizontChart.rightAxis.drawAxisLineEnabled = false
        horizontChart.rightAxis.drawLabelsEnabled = false
        horizontChart.isHidden = true
        
    }
    
    
    //MARK: INIT PIE
    func initPieChartUI()
    {
        pieChart.chartDescription?.text = ""//Reasons Analysis"
        pieChart.chartDescription?.textColor = UIColor.white
        pieChart.chartDescription?.font = NSUIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 0.1))
        pieChart.chartDescription?.yOffset = -10
        pieChart.chartDescription?.xOffset = 0
        
        //pieChart.chartDescription?.position
        pieChart.noDataText = "you don't spend at this period"
        pieChart.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 10)//View setExtraOffsetsWithLeft:30 top:0 right:30 bottom:0
        
        pieChart.backgroundColor = UIColor.clear
        
        pieChart.holeColor = ColorTemplates.purpleGray()[1]
        ///'labels' is deprecated: Use `entries`.
        pieChart.legend.textColor = UIColor.white
        pieChart.legend.verticalAlignment = Legend.VerticalAlignment.top
        pieChart.legend.orientation = Legend.Orientation.horizontal
        pieChart.legend.direction = Legend.Direction.leftToRight
        pieChart.legend.drawInside = false
        pieChart.legend.form  = .circle
        pieChart.legend.textColor = UIColor.white
        pieChart.legend.font = NSUIFont.systemFont(ofSize: 12.0)
        
        pieChart.usePercentValuesEnabled = true
        pieChart.drawEntryLabelsEnabled = false
        //   pieChart.dragDecelerationEnabled = true
        pieChart.isHidden = true
        pieChart.holeRadiusPercent = 0.7
        //   pieChart.drawHoleEnabled = false
        
        
     }

    
    @IBAction func graphTypeChanged(_ sender: UISegmentedControl) {
        
        showChartBySegmntIndex(sender.selectedSegmentIndex)
    }
    
    func  showChartBySegmntIndex(_ index: Int = 0)
    {
        drawChart()
        
   //     barChart.isHidden = true
        lvlChart1.isHidden = true
        lvlChart2.isHidden = true
        
        pieChart.isHidden = true
        horizontChart.isHidden = true

        if (index == 0)
        {
            pieChart.isHidden = false
        }
        else if (index == 1)
        {
 //           barChart.isHidden = false
            lvlChart1.isHidden = false
            lvlChart2.isHidden = false
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
            calculateAdnDrowLevelsChart()
        }
        else if(segmentGraphType.selectedSegmentIndex == 2)
        {
            calculateAndDrowHorizontalChart()
        }

    }
    
    
    //MARK: drow PIE
    
    func  calculateAdnDrowChartPie()
    {
        
        let cigRecord = CigaretteRecordManager()
        
        let fieldName = "reason"
        print("fromDate = \(curentDate)")
        print("toDate = \(toDate)")
        let arrReason2:NSArray = cigRecord.calculateGraphDataByFieldName(curentDate, toDate: toDate, fieldName: fieldName)
        
        
        var description = [String]()
        var sumOfCigs = [Double]()
        var cigsTotal:Double = 0
        
        
        //optimized
        let arrReason = arrReason2.sorted(by: {
            let first = Double((($0 as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber)!)
            let second = Double((($1 as! NSDictionary)["sumOftotalCigarettes"] as? NSNumber)!)
            return first > second
        })
        
        
        //was for i in 0..<arrReason.count
        //optimized
        sumOfCigs = arrReason.reduce([Double](), {(sumOfCigs:[Double], obj:NSFastEnumerationIterator.Element) -> [Double] in
            var sumOfCigs = sumOfCigs
            if let cigs = (obj as! NSDictionary)["sumOftotalCigarettes"] as? Double {
                sumOfCigs.append(cigs)
            }
            return sumOfCigs
        })
     //print(sumOfCigs.count)
        //cigsTotal = sumOfCigs.reduce(Double(), {return $0 + $1})
        
        description = arrReason.reduce([String](), {(arrDesc:[String], obj:NSFastEnumerationIterator.Element) -> [String] in
            var arrDesc = arrDesc
            if let desc:String = (obj as! NSDictionary)[fieldName] as? String {
                arrDesc.append(String(format: "%d-%@", Int(sumOfCigs[arrDesc.count]), desc))
            }
            return arrDesc
        })
        
        setChartPie(description, values: sumOfCigs)//(months, values: unitsSoldPie)
        
    }
    

    //MARK: SET PIE
    //load data
    func setChartPie(_ dataPoints: [String], values: [Double]) {
        
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        
        pieChartDataSet.yValuePosition = .outsideSlice
        
        pieChartDataSet.colors = ColorTemplates.chartPieColors()// ChartColorTemplates.joyful()
        pieChartDataSet.sliceSpace = 3
        pieChartDataSet.selectionShift = 8//
        pieChartDataSet.xValuePosition = .insideSlice
        pieChartDataSet.yValuePosition = .outsideSlice
        
        
        pieChartDataSet.valueLinePart1OffsetPercentage = 0.85
        pieChartDataSet.valueLinePart1Length = 0.2
        pieChartDataSet.valueLinePart2Length = 0.1
        pieChartDataSet.valueLineWidth = 1
        pieChartDataSet.valueLineColor = UIColor.white
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.numberStyle    = .percent
        numberFormatter.multiplier     = 1.00
        //numberFormatter.multiplier = @1.f
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartData.setDrawValues(true)
        
//        pieChart.frame  = CGRect(x: barChart.frame.origin.x+( barChart.frame.origin.x*0.05), y: barChart.frame.origin.y+(barChart.frame.origin.y*0.05), width:  barChart.frame.width - (barChart.frame.width*0.1), height: barChart.frame.height - (barChart.frame.height*0.1))
//        
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: numberFormatter))
        
        pieChart.data = pieChartData
        
    }

    //MARK: Levels chart show
    func calculateAdnDrowLevelsChart()
    {
        let cigRecord = CigaretteRecordManager()
        
        var fieldName = "levelOfEnjoy"
        
        var arrReason:NSArray = cigRecord.calculateGraphDataByFieldName(curentDate, toDate: toDate, fieldName: fieldName, orderByField: fieldName)
        
        let dataPointsEnjoy: [String]! = LevelsDescription
        let dataPointsNeed: [String]! = LevelsDescription
        var sumOfCigsEnjoy = [Double]()
        var sumOfCigsNeed = [Double]()
        
        for j in 0..<dataPointsEnjoy.count
        {
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
                sumOfCigsEnjoy.append(0.00000001)
            }
       //     dataPointsEnjoy[j] = "\(Int(sumOfCigsEnjoy[j])) - \(dataPointsEnjoy[j])"
        }
        
        
        fieldName = "levelAsNeeded"
        arrReason = cigRecord.calculateGraphDataByFieldName(curentDate, toDate: toDate, fieldName: fieldName, orderByField: fieldName)
        
        for k in 0..<dataPointsNeed.count  {
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
                sumOfCigsNeed.append(0.00000001)
            }
            //dataPointsNeed[k] = "\(Int(sumOfCigsNeed[k])) - \(dataPointsNeed[k])"
            
        }
        
     //   setMaxMilAxisElementBarChart(sumOfCigsEnjoy, values2: sumOfCigsNeed)
        
     //   setMultiBarChart(sumOfCigsEnjoy, values2: sumOfCigsNeed, xVals: description)
        lvlChart1.setChart(dataPoints: dataPointsEnjoy, values: sumOfCigsEnjoy, description: "Enjoy")
        
        self.view.addSubview(lvlChart1)
    //    lvlChart1.bounds = barChart.bounds
        let height = pieChart.frame.height - 3;
        lvlChart1.frame =  pieChart.frame
        lvlChart1.frame.size = CGSize(width: pieChart.frame.width-(pieChart.frame.width*0.5), height: height)
        
        
        lvlChart2.setChart(dataPoints: dataPointsNeed, values: sumOfCigsNeed, description: "Needed")
       // lvlChart2.legend.enabled = false
        
        self.view.addSubview(lvlChart2)
    //    lvlChart2.bounds = barChart.bounds
        lvlChart2.frame  = CGRect(x: pieChart.frame.origin.x + pieChart.frame.width/2, y: pieChart.frame.origin.y, width: pieChart.frame.width-(pieChart.frame.width*0.5), height: height)  //  levelsView.frame
        
        
    }
    
    
    //MAKR: calculate And Drow HorizontalChart
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
    
    //MARK: calculate And Drow HorizontalChartByDay
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
        let components = (Calendar.current as NSCalendar).components([.day, .month, .year], from: curentDate)
        
        
        var description = [String]()
        var sumOfCigs = [Double]()
        
        let currenDate = Date()
        
        var evens = [Int]()
        
        for (_,i) in (0...22).reversed().enumerated() {
            evens.append(i)
            dataStringStart = String(format: "%d-%d-%d %d:00", components.month!, components.day! ,components.year!, i)
            dateValueStart = dateFormatterStart.date(from: dataStringStart)
            
            if dateValueStart > currenDate {
                continue
            }
            
            dataStringEnd = String(format: "%d-%d-%d %d:00", components.month!, components.day! ,components.year!, i+1)
            dateValueEnd = dateFormatterStart.date(from: dataStringEnd)
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
        if let maxVal = sumOfCigs.max(){
            setLabelCount(maxVal)
        }
        
        setHorizontalChartData(sumOfCigs, xVals: description)

        horizontChart.rightAxis.removeAllLimitLines()
    
    }
    
    func setLabelCount(_ val:Double){
        
        var maxVal = val
        var labelCount = maxVal
        if maxVal > 15 {labelCount = 15
            maxVal = maxVal + (maxVal / 100 * 1.5)
        }
        horizontChart.leftAxis.axisMaximum = maxVal + 1
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
            dataStringStart = String(format: "%d-%d-%d 00:00", components.month!, i ,components.year!)
            dateValueStart = dateFormatterStart.date(from: dataStringStart)
            
            if dateValueStart > currenDate {
                continue
            }
            
            dataStringEnd = String(format: "%d-%d-%d 23:59", components.month!, i ,components.year!)
            dateValueEnd = dateFormatterStart.date(from: dataStringEnd)
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
        if let maxVal = sumOfCigs.max(){
            setLabelCount(maxVal)
        }
        
        setHorizontalChartData(sumOfCigs, xVals: description)
        
        let ll = ChartLimitLine(limit: Double(userDefaults.dailyGoal), label: "Limit")
        ll.valueTextColor = UIColor.white
        ll.lineColor = UIColor.orange
        horizontChart.rightAxis.removeAllLimitLines()
        horizontChart.rightAxis.addLimitLine(ll)
        
        
    }
    


    func   calculateAndDrowHorizontalChartByYear()
    {
       
        let cigRecord = CigaretteRecordManager()
        
        var dataStringStart:String
        let dateFormatterStart = DateFormatter()
        dateFormatterStart.dateFormat = "yyyy-MM-dd"
        
        // convert string into date
        var dateValueStart:Date!
        var dateValueEnd:Date!

        
        let dateFormatter = DateFormatter()
        
        let months = dateFormatter.shortMonthSymbols
        var monthSymbol: String = String()
        let components = (Calendar.current as NSCalendar).components([.day, .month, .year], from: curentDate)
        
        
        var description = [String]()
        var sumOfCigs = [Double]()
        let currenDate = Date()
        
        for (_,i) in (0...11).reversed().enumerated() {
            monthSymbol = (months?[i])! // month - from your date components
            dataStringStart = String(format: "%d-%d-01", components.year!, i+1)
            dateValueStart = dateFormatterStart.date(from: dataStringStart)!
            
            if dateValueStart > currenDate {
                continue
            }
//            
//            dateValueEnd = dateFormatterStart.date(from:  String(format: "%d-%d-15", components.year!, i+1))!.endOfMonth()!
//            dateValueEnd = dateValueEnd.endOfMonth()!
            if i == 11 {
                dataStringStart = String(format: "%d-%d-01", components.year! + 1, 1)
            }
            else {
                dataStringStart = String(format: "%d-%d-01", components.year!, i+2)
            }
            dateValueEnd = dateFormatterStart.date(from: dataStringStart)!
            
//print(currenDate)
//print(dateValueStart)
//print(dateValueEnd)
            
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
        if let maxVal = sumOfCigs.max(){
            horizontChart.leftAxis.axisMaximum = maxVal + 10
            setLabelCount(maxVal)
        }
        
        
        setHorizontalChartData(sumOfCigs, xVals: description)
        
        let ll = ChartLimitLine(limit: Double(userDefaults.dailyGoal) * 30, label: "Limit")
        ll.valueTextColor = UIColor.white
        ll.lineColor = UIColor.orange
        horizontChart.rightAxis.removeAllLimitLines()
        horizontChart.rightAxis.addLimitLine(ll)
    }
    
//    func setMaxMilAxisElementBarChart( _ values: [Double], values2: [Double])
//    {
//        guard let number1 = values.max(), let number2 = values2.max() else { return }
//
//        
//        var maxVal = max(number1, number2)
//        
//        var labelCount = maxVal
//        if maxVal > 15 {labelCount = 15
//            maxVal = maxVal + (maxVal / 100 * 1.5)
//        }
//        barChart.leftAxis.axisMinimum = 0
//        barChart.leftAxis.axisMaximum = maxVal + 1
//        barChart.leftAxis.labelCount = Int(labelCount) / 2 + 2
//        
//        barChart.xAxis.axisMinimum = 0
//        
//
//    }
//    
    
    
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
        
       // barChart.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        let formato:HorizontalBarChartFormatter = HorizontalBarChartFormatter()
        
        formato.months = newxVals
        
        let xaxis:XAxis = XAxis()
  
        for i in 0..<newxVals.count - 1 {
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i]])
            
            dataEntries.append(dataEntry)
            
            _ = formato.stringForValue(Double(i), axis: xaxis)
        }
        
        
        xaxis.valueFormatter = formato
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Smoked cigarettes")
        chartDataSet.colors = ColorTemplates.HorizontalBarChartColor()
        chartDataSet.valueTextColor = UIColor.white// ColorTemplates.HorizontalBarChartColor()[0]
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setValueFormatter(DefaultValueFormatter(formatter: NumberFormatter()))
        
        horizontChart.xAxis.valueFormatter = xaxis.valueFormatter
        horizontChart.data = chartData
    }
    
//
//    
//    
//    func setMultiBarChart( _ values: [Double], values2: [Double], xVals: [String]!)
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
//
//           dataEntry1 = BarChartDataEntry(x: Double(i), y:values[i] )
//           dataEntry2 = BarChartDataEntry(x: Double(i), y:values2[i] )
//            dataEntries1.append(dataEntry1)
//           dataEntries2.append(dataEntry2)
//      
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
//        var dataSets: [ChartDataSet] = [ChartDataSet]()
//        dataSets.append(chartDataSet1)
//        dataSets.append(chartDataSet2)
//  
//        let chartData: BarChartData = BarChartData.init( dataSets: dataSets)
//        chartData.setValueFormatter(DefaultValueFormatter(formatter: NumberFormatter()))
//        let groupSpace = 0.16
//        let barSpace = 0.02
//        let barWidth = 0.3
//        
//        chartData.barWidth = barWidth
//        chartData.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
//        barChart.xAxis.valueFormatter = xaxis.valueFormatter
//        barChart.data = chartData
//    }
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
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        selectedDate.inputView = datePickerView
     
        //set selected date to text field
        
        datePickerView.addTarget(self, action: #selector(self.handleDatePicker(_:)),
                                 for: UIControl.Event.valueChanged)
        //set init value
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
    @objc func handleDatePicker(_ sender: UIDatePicker) {
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
