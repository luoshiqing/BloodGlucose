//
//  ContinuouChartView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/29.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class ContinuouChartView: UIView ,ChartViewDelegate,IAxisValueFormatter{

    var myLineView:LineChartView!
    
    override func draw(_ rect: CGRect) {
        self.setChartData()
    }
 
    func setChartData(){
       
        self.myLineView = LineChartView(frame: CGRect(x: 10,y: 0,width: self.frame.size.width - 20,height: self.frame.size.height))
        self.myLineView.backgroundColor = UIColor(red: 255/255.0, green: 248/255.0, blue: 246/255.0, alpha: 1)
        self.addSubview(self.myLineView)
        
        myLineView.delegate = self


        myLineView.chartDescription?.text = ""
        myLineView.noDataText = "没有数据"
        
        
        //放大
        myLineView.pinchZoomEnabled = false
        myLineView.drawGridBackgroundEnabled = false
        //放大倍数
        myLineView.viewPortHandler.setMaximumScaleY(1)
        myLineView.viewPortHandler.setMaximumScaleX(30)
        
        //关闭底部图例显示
        let legend = myLineView.legend
        legend.enabled = false
        
        myLineView.dragEnabled = true
        myLineView.scaleXEnabled = true
        myLineView.pinchZoomEnabled = true
        myLineView.drawGridBackgroundEnabled = false
        
        
        let leftAxis:YAxis = myLineView.leftAxis
        leftAxis.removeAllLimitLines()

        leftAxis.axisMaximum = 10
        leftAxis.axisMinimum = 0
        
        
        leftAxis.drawZeroLineEnabled = false
        
        
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.drawGridLinesEnabled = false
        
//        let formatter = NumberFormatter()
//        formatter.numberStyle = NumberFormatter.Style.decimal
//        
//        leftAxis.valueFormatter = formatter
        
        
        myLineView.rightAxis.enabled = false
        
        
        let xAxis:XAxis = myLineView.xAxis
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        xAxis.labelFont = UIFont(name: "Helvetica", size: 10)!
        
        
        xAxis.drawGridLinesEnabled = false
        
//        xAxis.labelRotationAngle = -45.0
        
        xAxis.valueFormatter = self
        xAxis.granularity = 1.0
        
        myLineView.xAxis.enabled = true
        
        
        
        myLineView.animate(xAxisDuration: 1,yAxisDuration: 1, easingOption: ChartEasingOption.easeInOutQuart)
        
        
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
        myLineView.marker = marker
        
        
        myLineView.setVisibleXRangeMaximum(10)
    }
    
    fileprivate var myxArray = [String]()
    
    //MARK:－多日->绘制图形
    func loadContinuousManyDaysChartView(_ xArray:NSMutableArray,yArray:NSMutableArray,dataArray:NSMutableArray,dataCount:NSMutableArray){
        
   
        
        if xArray.count <= 0 {

            self.myLineView.clear()

        }else{
            
            var colorArray = [UIColor]()
            colorArray = [UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1),
                          UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1),
                          UIColor(red: 85/255.0, green: 212/255.0, blue: 255/255.0, alpha: 1),
                          UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1),
                          UIColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1),
                          UIColor(red: 253/255.0, green: 145/255.0, blue: 46/255.0, alpha: 1),
                          UIColor(red: 219/255.0, green: 112/255.0, blue: 147/255.0, alpha: 1),
                          UIColor(red: 255/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1),
                          UIColor(red: 64/255.0, green: 224/255.0, blue: 208/255.0, alpha: 1)]
            //解析数据
            
            var dataSets:[ChartDataSet] = []
            var xVals = [String]()
            
            var numMax = 0
            
            for xxx in xArray {
                let xVals1 = xxx as! [String]
                xVals = xVals + xVals1
            }
            self.myxArray = xVals
            
            for maxmax in dataArray {
                let maxArray = maxmax as! [Int]
                
                //基于获取到的血糖数值设置图示最大值最小值范围
                numMax = maxArray.reduce(Int.min, { max($0, $1) })
                
                
            }
            
            for max1 in 0  ..< dataArray.count {
                
                let aaaarray1:[Int] = dataArray[max1] as! [Int]
                
                if max1 == 0 {
                    
                    numMax = aaaarray1.reduce(Int.min, { max($0, $1) })
                }else{
                    let  bbbb = aaaarray1.reduce(Int.min, { max($0, $1) })
                    if(bbbb > numMax){
                        numMax = bbbb
                    }
                }
                
            }
            //设置天数分割线
            var tmpDataCount:Double = 0.0
            let leftAxis:XAxis = self.myLineView.xAxis
            
            leftAxis.removeAllLimitLines()
            
            for ddd in 0 ..< dataCount.count {
                let limitCount:Double = Double(dataCount[ddd] as! Int)
                
                tmpDataCount += limitCount
                
                let lowerLimit:ChartLimitLine = ChartLimitLine(limit: tmpDataCount)
                lowerLimit.lineColor = UIColor.gray
                lowerLimit.lineWidth = 1
                lowerLimit.lineDashLengths = [2,4]
                
                leftAxis.addLimitLine(lowerLimit)
            }
            
            for index in 0 ..< yArray.count {
                
                let yVals1 = yArray[index]
                
                let yVals:[ChartDataEntry] = yVals1 as! [ChartDataEntry]
                
                let set = LineChartDataSet(values: yVals, label: "")
                let color:UIColor = colorArray[index]
                
                set.setColor(color)
                set.setCircleColor(UIColor.black)
                set.lineWidth = 1
                set.circleRadius = 3.0
                set.drawCirclesEnabled = false
                //            set.drawCubicEnabled = true
                set.drawValuesEnabled = false //点的值
                set.drawCircleHoleEnabled = false
                set.highlightEnabled = true
                set.fillColor = UIColor.gray
                
                
                dataSets.append(set)
   
                
                let leftAxis1:YAxis = self.myLineView.leftAxis
                
                
                print("numMax:\(numMax)")
                if numMax >= 8{
                    leftAxis1.axisMaximum = Double(numMax + 4)
                }else{
                    leftAxis1.axisMaximum = 10
                }
 
                let data: LineChartData = LineChartData(dataSets: dataSets)
                
   
                self.myLineView.data = data
                self.myLineView.setVisibleXRangeMaximum(480 * 3)
                self.myLineView.moveViewToX(Double(yVals.count))
                
                self.myLineView.highlightValue(x: Double(yVals.count), dataSetIndex: yVals.count, callDelegate: false)
                
            }
            
            
        }
        
    
        
    }
    
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        
        
        let str = self.myxArray[Int(value)]
        
        return str
        
    }
    
    
}
