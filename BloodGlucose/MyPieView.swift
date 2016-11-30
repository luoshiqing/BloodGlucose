//
//  MyPieView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/11.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyPieView: UIView ,ChartViewDelegate{

    var dateView:UIView!
    var pppView:PieChartView!
    var dateLabel:UILabel!
    
    func initView(){
        self.isUserInteractionEnabled = false
        
        //设置标题
        let biaotiLabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: 20))
        biaotiLabel.text = "血糖数据分析图"
        biaotiLabel.textColor = UIColor.orange
        biaotiLabel.textAlignment = .center
        self.addSubview(biaotiLabel)

        
        //设置日期
        dateView = UIView(frame: CGRect(x: 0,y: 22,width: self.frame.size.width,height: 20))
        dateView.backgroundColor = UIColor.white
        //设置日期label
        dateLabel = UILabel(frame: CGRect(x: 0,y: 0,width: dateView.frame.size.width,height: dateView.frame.size.height))
        self.dateView.addSubview(dateLabel)
        dateLabel.text = "日期"
        
        dateLabel.textAlignment = .center
        
        
        self.addSubview(dateView)
        
        pppView = PieChartView(frame: CGRect(x: 0,y: dateView.frame.size.height + biaotiLabel.frame.size.height + 2 + 3 ,width: self.frame.size.width,height: self.frame.size.height - dateView.frame.size.height - biaotiLabel.frame.size.height - 2 - 3))
        pppView.backgroundColor = UIColor.white
        
        self.addSubview(pppView)
        
        //设置图形属性
        self.pppView.delegate = self
        
        //关闭底部图例显示
        let legend = self.pppView.legend
        legend.enabled = false
        
        
        self.pppView.usePercentValuesEnabled = true
        
//        self.pppView.holeTransparent = true
        
        
        
        
        //半径
        self.pppView.holeRadiusPercent = 0.0
        self.pppView.transparentCircleRadiusPercent = 0.0
        
        
        self.pppView.chartDescription?.text = "高血糖占时间比"
        
        self.pppView.setExtraOffsets(left: 5.0, top: 1.0, right: 5.0, bottom: 5.0)
        
        self.pppView.drawCenterTextEnabled = false

        
        self.pppView.drawHoleEnabled = true
        self.pppView.rotationAngle = 0.0
        self.pppView.rotationEnabled = true
        
        let l:Legend = self.pppView.legend
        
//        l.position = .rightOfChart
        
        
        
        l.direction = .rightToLeft
        
        l.xEntrySpace = 7.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
    }

}
