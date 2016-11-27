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

    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        self.data = pieChartData
        
        pieChartDataSet.colors = ColorTemplates.chartPieLevelsColors()
        
    }
}
