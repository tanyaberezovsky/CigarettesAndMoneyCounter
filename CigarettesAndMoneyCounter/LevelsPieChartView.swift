//
//  LevelsPieChartView.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 27/11/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit
import Charts

class LevelsPieChartView: PieChartView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //MARK: INIT PIE
    func initPieChartUI(description: String)
    {
        self.chartDescription?.text = description
        self.chartDescription?.textColor = UIColor.white
        self.chartDescription?.font = NSUIFont.systemFont(ofSize: 14.0)
        self.chartDescription?.yOffset = -10
        self.chartDescription?.xOffset = 0
        
        //pieChart.chartDescription?.position
        self.noDataText = ""
        self.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 10)//View setExtraOffsetsWithLeft:30 top:0 right:30 bottom:0
        
        self.backgroundColor = UIColor.clear
        
       //self.holeColor = ColorTemplates.purpleGray()[1]
        ///'labels' is deprecated: Use `entries`.
        self.legend.textColor = UIColor.white
        self.legend.verticalAlignment = Legend.VerticalAlignment.top
        self.legend.orientation = Legend.Orientation.vertical
        self.legend.direction = Legend.Direction.leftToRight
        self.legend.drawInside = false
        self.legend.form  = .circle
        self.legend.textColor = UIColor.white
        self.legend.font = NSUIFont.systemFont(ofSize: 12.0)
        
        self.usePercentValuesEnabled = true
        self.drawEntryLabelsEnabled = false
        //   pieChart.dragDecelerationEnabled = true
        //self.isHidden = true
       // self.holeRadiusPercent = 0
       // self.transparentCircleRadiusPercent = 0;
        self.drawHoleEnabled = false
    }

    
    func setChart(dataPoints: [String], values: [Double], description: String) {
        initPieChartUI(description: description)
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        
       
        
        
        pieChartDataSet.colors = ColorTemplates.chartPieLevelsColors()
        pieChartDataSet.sliceSpace = 3
        pieChartDataSet.selectionShift = 8//
        pieChartDataSet.xValuePosition = .insideSlice
        pieChartDataSet.yValuePosition = .insideSlice
        
        
//        pieChartDataSet.valueLinePart1OffsetPercentage = 0.85
//        pieChartDataSet.valueLinePart1Length = 0.2
//        pieChartDataSet.valueLinePart2Length = 0.1
//        pieChartDataSet.valueLineWidth = 1
//        pieChartDataSet.valueLineColor = UIColor.white
//        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.numberStyle    = .percent
        numberFormatter.multiplier     = 1.00
        //numberFormatter.multiplier = @1.f
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartData.setDrawValues(true)
        
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: numberFormatter))
        

        
        self.data = pieChartData
        
    }
}
