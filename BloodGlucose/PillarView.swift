//
//  PillarView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/8.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class PillarView: UIView ,ChartViewDelegate ,IAxisValueFormatter{

    

    
    
    @IBOutlet weak var bbChartV: BarChartView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    var myXvalue = [String]()
    
    //绘制视图
    func insertDateLoadChartView(_ dateArray:[String],sdbgArray:[NSNumber]){
        //MARK:-柱形图模块-------->>>>>>>>>
        
        var anlyzeXvals = [NSObject]()
        var anlyzeYvals = [BarChartDataEntry]()
        
        
        print(sdbgArray)
        
        self.myXvalue = dateArray
        
        let max = sdbgArray.max { (a, b) -> Bool in
            return a < b
        }

        
        if let tmpMAX = max {
            
            if tmpMAX < 10 {
                self.bbChartV.leftAxis.axisMaximum = 10.0
            }else{
                self.bbChartV.leftAxis.axisMaximum = Double(tmpMAX) + 4.0
            }
     
        }
        
        
        
        for index in 0 ..< dateArray.count {
            
            let time = dateArray[index] 
            let value = sdbgArray[index]
            
            
            let yy = BarChartDataEntry(x: Double(index), y: Double(value))
            
            
            anlyzeXvals.append(time as NSObject)
            anlyzeYvals.append(yy)
        }
        self.loadAnalyzeImg(anlyzeXvals, yVals: anlyzeYvals)
        
        
    }
    
    //MARK:绘制柱形图
    func loadAnalyzeImg(_ xVals:[NSObject],yVals:[BarChartDataEntry]){

        let set:BarChartDataSet = BarChartDataSet(values: yVals, label: "")
        
        //设置柱形图 宽度
        
//        set.barBorderWidth = 0.8
        
        set.setColor(UIColor(red: 53/255.0, green: 208/255.0, blue: 192/255.0, alpha: 0.8))
        //柱行上的 字
        set.drawValuesEnabled = false
        
        var dataSets = [ChartDataSet]()
        dataSets.append(set)
        
        
        
        let data = BarChartData(dataSets: dataSets)
        
        
        self.bbChartV.data = data
    }
    
    
    
    func initSetup(){
        
        
        bbChartV.delegate = self
        bbChartV.chartDescription?.text = ""
        bbChartV.noDataText = "没有数据"
        
        bbChartV.drawBarShadowEnabled = false
        //数字在图形之上
        bbChartV.drawValueAboveBarEnabled = true
        bbChartV.maxVisibleCount = 60
 
        
        
        
        //关闭点击事件
        // bbChartV.userInteractionEnabled = false

        //关闭底部图例显示
        let legend = bbChartV.legend
        legend.enabled = false
        
        
        //放大
        bbChartV.pinchZoomEnabled = false
        bbChartV.drawGridBackgroundEnabled = false
        //放大倍数
        bbChartV.viewPortHandler.setMaximumScaleY(1)
        bbChartV.viewPortHandler.setMaximumScaleX(50)
        
        
        let xAxis:XAxis = bbChartV.xAxis
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 10.0)
        xAxis.drawGridLinesEnabled = false
        xAxis.labelCount = 7
        xAxis.axisMinimum = 0.0
        xAxis.granularity = 1.0
        
        xAxis.valueFormatter = self
        
        
        
        let leftFormatter = NumberFormatter()
        leftFormatter.minimumFractionDigits = 0
        leftFormatter.maximumFractionDigits = 1
        
        let leftAxis:YAxis = bbChartV.leftAxis
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10.0)
        leftAxis.labelCount = 4
        //-------隐藏 横线条
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0.0
        leftAxis.axisMaximum = 10
        leftAxis.labelCount = 8
        leftAxis.labelPosition = YAxis.LabelPosition.outsideChart
        leftAxis.spaceTop = 0.15

        
        let rightAxis = bbChartV.rightAxis
        rightAxis.drawGridLinesEnabled = false
        rightAxis.labelFont = UIFont.systemFont(ofSize: 0.0)
        rightAxis.labelTextColor = UIColor.clear
        
        //隐藏右边标尺
        rightAxis.drawAxisLineEnabled = false

        
        bbChartV.legend.direction = .leftToRight
        bbChartV.legend.form = .square
        
        
        bbChartV.legend.formSize = 9.0
        bbChartV.legend.font = UIFont(name: "HelveticaNeue-Light", size: 11.0)!
        
        bbChartV.legend.xEntrySpace = 4.0
        
        let marker = BalloonMarker(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), font: UIFont(name: "Helvetica", size: 12)!, textColor: UIColor.black, insets: UIEdgeInsets(top: 5, left: 5, bottom: 15, right: 15))
        marker.minimumSize = CGSize(width: 10, height: 5)
        self.bbChartV.marker = marker
    
        
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        
        let xValue = self.myXvalue[Int(value)]
        
        return xValue
    }
  

}
