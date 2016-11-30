//
//  MyLineChartView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/10.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyLineChartView: LineChartView ,ChartViewDelegate ,IAxisValueFormatter{

    
    var myXvals = [String]()
    
    func initView(){
        
 
        
        self.delegate = self
        
//        self.descriptionText = ""
//        
//        self.noDataTextDescription = ""
        
        self.chartDescription?.text = ""
        self.noDataText = "没有数据"
        
        //放大
        self.pinchZoomEnabled = false
        self.drawGridBackgroundEnabled = false
        //放大倍数
        self.viewPortHandler.setMaximumScaleY(1)
        self.viewPortHandler.setMaximumScaleX(50)
        
        //关闭底部图例显示
        let legend = self.legend
        legend.enabled = false
        
        
        self.dragEnabled = true
        self.scaleXEnabled = true
        self.pinchZoomEnabled = true
        self.drawGridBackgroundEnabled = false
        
        
        let leftAxis:YAxis = self.leftAxis
        leftAxis.removeAllLimitLines()

        
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 10
 
        
        leftAxis.drawZeroLineEnabled = false
        
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.drawGridLinesEnabled = false
        //设置坐标轴 颜色
        leftAxis.axisLineColor = UIColor.gray
        
  
        
        self.rightAxis.enabled = false
        
        
        let xAxis:XAxis = self.xAxis
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        xAxis.labelFont = UIFont(name: "Helvetica", size: 10)!
        
        xAxis.valueFormatter = self
        xAxis.granularity = 1.0
        
        
        xAxis.drawGridLinesEnabled = false
        //设置坐标轴 颜色
        xAxis.axisLineColor = UIColor.gray
        
        
        
//        xAxis.spaceBetweenLabels = 0
        self.xAxis.enabled = true
        
        
        
        self.animate(xAxisDuration: 1,yAxisDuration: 1, easingOption: ChartEasingOption.easeInOutQuart)
        
        
        //添加血糖高位警示线
        
        let upperLimit:ChartLimitLine = ChartLimitLine(limit: 7.8)
        upperLimit.lineColor = UIColor.green
        upperLimit.lineWidth = 0.5
        upperLimit.lineDashLengths = [4,4]
        
        //添加血糖低位警示线
        let lowerLimit:ChartLimitLine = ChartLimitLine(limit: 3.9)
        lowerLimit.lineColor = UIColor.gray
        lowerLimit.lineWidth = 0.5
        lowerLimit.lineDashLengths = [4,4]
        
        leftAxis.addLimitLine(upperLimit)
        leftAxis.addLimitLine(lowerLimit)
        

        let marker = BalloonMarker(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), font: UIFont(name: "Helvetica", size: 12)!, textColor: UIColor.black, insets: UIEdgeInsets(top: 5, left: 5, bottom: 15, right: 15))
        marker.minimumSize = CGSize(width: 10, height: 5)
        self.marker = marker
        
        self.setVisibleXRangeMaximum(60)
        
        
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let str = self.myXvals[Int(value)]
        return str

    }
   
    
}
