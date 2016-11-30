//
//  ScatterView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/18.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class ScatterView: UIView ,ChartViewDelegate ,IAxisValueFormatter{

    
    var chartView: ScatterChartView!
    
    override func draw(_ rect: CGRect) {
        
        self.setMyChartView(rect)
        
        
    }
 

    func setMyChartView(_ rect: CGRect){
        
        chartView = ScatterChartView(frame: CGRect(x: 0,y: 0,width: rect.width,height: rect.height))
        
        chartView.backgroundColor = UIColor().rgb(255, g: 248, b: 246, alpha: 1)
        
        self.addSubview(chartView)
        
 
        chartView.delegate = self

        chartView.chartDescription?.text = ""
        chartView.noDataText = "您没有添加数据"

        
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        
        chartView.viewPortHandler.setMaximumScaleY(1)
        chartView.viewPortHandler.setMaximumScaleX(2)

        chartView.dragEnabled = true
        
        chartView.setScaleEnabled(true)
        
        chartView.maxVisibleCount = 1
        

        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = true
 
        l.font = UIFont.systemFont(ofSize: 10)
        l.xOffset = 5.0
        let yl = chartView.leftAxis
//        let yl = chartView.rightAxis
        yl.labelFont = UIFont.systemFont(ofSize: 10)

        yl.drawGridLinesEnabled = false
        
        yl.labelPosition = .outsideChart
        yl.axisMinimum = 0
        yl.axisLineColor = UIColor().rgb(68, g: 68, b: 68, alpha: 1)
        
 
        chartView.rightAxis.enabled = false //右边y
        
        chartView.leftAxis.drawGridLinesEnabled = false
        
        //x坐标
        let xl = chartView.xAxis
        xl.labelFont = UIFont.systemFont(ofSize: 10)
        
        xl.drawLimitLinesBehindDataEnabled = false
        
        xl.valueFormatter = self
        
        xl.drawGridLinesEnabled = false
        //x坐标显示位置
        xl.labelPosition = XAxis.LabelPosition.bottom
        xl.labelWidth = 5
        
        xl.axisMinimum = 0.0
        xl.granularity = 1.0
        xl.axisMaximum = 8.0
        //设置x轴 的间距
        xl.axisLineColor = UIColor().rgb(68, g: 68, b: 68, alpha: 1)
        self.chartView.xAxis.enabled = true //x值
        
        
       
        let marker = BalloonMarker(color: UIColor().rgb(1, g: 1, b: 1, alpha: 0.4), font: UIFont(name: "Helvetica", size: 12)!, textColor: UIColor.black, insets: UIEdgeInsets(top: 5, left: 5, bottom: 15, right: 5))
        marker.minimumSize = CGSize(width: 10, height: 5)
        
        chartView.marker = marker

        
    }
    
//    var name = ["凌\n晨","早\n餐\n前","早\n餐\n后","午\n餐\n前","午\n餐\n后","晚\n餐\n前","晚\n餐\n后","睡\n前","随\n机"]
    
    var myXvals = ["凌\n晨","早\n餐\n前","早\n餐\n后","午\n餐\n前","午\n餐\n后","晚\n餐\n前","晚\n餐\n后","睡\n前","随\n机"]
    
    let logoColor = [UIColor().rgb(147, g: 39, b: 179, alpha: 1),
                     UIColor().rgb(192, g: 208, b: 27, alpha: 1),
                     UIColor().rgb(45, g: 127, b: 198, alpha: 1),
                     UIColor().rgb(255, g: 148, b: 105, alpha: 1),
                     UIColor().rgb(92, g: 165, b: 39, alpha: 1),
                     UIColor().rgb(207, g: 36, b: 31, alpha: 1),
                     UIColor().rgb(71, g: 24, b: 239, alpha: 1),
                     UIColor().rgb(71, g: 24, b: 239, alpha: 1)]
    
    func setScatterChartData(_ dataDic: [String:Any]){
        
        //------
        let mmLabel = UILabel(frame: CGRect(x: -9,y: 12,width: 40,height: 11))
        mmLabel.text = "mmol/L"
        mmLabel.textColor = UIColor().rgb(246, g: 93, b: 34, alpha: 1)
        mmLabel.textAlignment = .center
        mmLabel.font = UIFont(name: PF_SC, size: 9)
        
        mmLabel.layer.allowsEdgeAntialiasing = true
        mmLabel.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI / 2))
        
        self.addSubview(mmLabel)
        //-------

        let dateArray = dataDic["dateArray"] as! [String]
        
        let myYVals = dataDic["myYVals"] as! [[ChartDataEntry]]
  
        self.myXvals = dataDic["xVals"] as! [String]
        
        
        var dataSets = [ScatterChartDataSet]()

        
        
        //
        var maxYArray = [Double]()
        
        for index in 0..<myYVals.count {
            
            let label = dateArray[index]
            
            let yVals = myYVals[index]
            
            let set = ScatterChartDataSet(values: yVals, label: label)

            set.setScatterShape(ScatterChartDataSet.Shape.circle)
            
            set.setColor(self.logoColor[index])
            
            dataSets.append(set)
            
            
            for item in yVals {
                let max = item.y
                maxYArray.append(max)
            }
   
        }
        
        print(maxYArray)
        
        let tmpMax = maxYArray.max(by: { (a, b) -> Bool in
            return a < b
        })
        
        if let maxY = tmpMax{
            
            if maxY <= 10 {
                chartView.leftAxis.axisMaximum = 10.0
            }else{
                chartView.leftAxis.axisMaximum = maxY * 1.3
            }

        }
        
        
        
        

        let data1 = ScatterChartData(dataSets: dataSets)
        data1.setValueFont(UIFont.systemFont(ofSize: 7))
        chartView.data = data1
        
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let val = self.myXvals[Int(value)]
        return val
    }
    

    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        print(dataSetIndex,highlight)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("chartValueNothingSelected")
    }
    
    
}
