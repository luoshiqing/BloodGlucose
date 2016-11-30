//
//  GraphView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/7.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class GraphView: UIView ,ChartViewDelegate{

    
    
    

    @IBOutlet weak var myLineView: LineChartView!
    
    @IBOutlet weak var moreView: UIView!
    
    @IBOutlet weak var moreLabel: UILabel!
    
    @IBOutlet weak var moreImgView: UIImageView!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    func initSetup(){
        
        //设置 圆角
        moreImgView.layer.cornerRadius = 10
        moreImgView.clipsToBounds = true
        
        moreImgView.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI / 2.0))
        
        
        
        
        
        myLineView.delegate = self
        
//        myLineView.descriptionText = ""
//        myLineView.noDataTextDescription = ""

        myLineView.chartDescription?.text = ""
        myLineView.noDataText = ""
        
        
        //放大
        myLineView.pinchZoomEnabled = false
        myLineView.drawGridBackgroundEnabled = false
        //放大倍数
        myLineView.viewPortHandler.setMaximumScaleY(1)
        myLineView.viewPortHandler.setMaximumScaleX(5)
        
        //关闭底部图例显示
        let legend = myLineView.legend
        legend.enabled = false
        
        myLineView.dragEnabled = true
        myLineView.scaleXEnabled = true
        myLineView.pinchZoomEnabled = true
        myLineView.drawGridBackgroundEnabled = false
        
        
        let leftAxis:YAxis = myLineView.leftAxis
        leftAxis.removeAllLimitLines()
//        leftAxis.customAxisMin = 0
//        leftAxis.customAxisMax = 10
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 10
        
//        leftAxis.startAtZeroEnabled = false
        
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
        
        
        
//        xAxis.spaceBetweenLabels = 0
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
        
//        let marker = BalloonMarker(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), font: UIFont(name: "Helvetica", size: 12)!, insets: UIEdgeInsets(top: 8, left: 8, bottom: 28, right: 8))
//        
//        marker.minimumSize = CGSize(width: 20, height: 10)
//        myLineView.marker = marker
        
        
        myLineView.setVisibleXRangeMaximum(60)
        
        
        
        
    }

}
