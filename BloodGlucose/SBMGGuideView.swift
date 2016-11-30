//
//  SBMGGuideView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/5.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SBMGGuideView: UIView ,JMHoledViewDelegate{

    typealias SBMGGuideViewOkActClourse = ()->Void
    var okActClourse: SBMGGuideViewOkActClourse?
    
    
    
    enum JMHoledType {
        case menu
        case title
        case help
        case fingerBlood
        case addEvent
        case upData
        case seeTrends
        case seeData
    }
    
    
    
    //引导 提示
    var holedView:JMHoledView!

    
    
    let Hsize = (UIScreen.main.bounds.height - 64 - 49) / (667 - 64 - 49)
    var diaHeight: CGFloat!     //表盘的宽跟高
    
    var three_width: CGFloat!
    var tow_width: CGFloat!
    var any_height: CGFloat!
    
    
    
    
    
    //(0.0, 252.960288808664, 320.0, 202.039711191336)
    
    //是哪个步骤了
    var myJMType = JMHoledType.menu
    
    var myRect: CGRect!
   
    override func draw(_ rect: CGRect) {
        
        self.myRect = rect
        
       
        self.diaHeight = (280 + 28 + 10) * Hsize
        
        self.three_width = rect.width / 3.0
        self.tow_width = rect.width / 2.0
        self.any_height = (rect.height - self.diaHeight - 49 - 64) / 3.0
        
      
        self.holedView = JMHoledView(frame: CGRect(x: 0,y: 0,width: rect.width,height: rect.height))
        self.holedView.backgroundColor = UIColor.clear
        
        self.holedView.holeViewDelegate = self
        
        self.addSubview(self.holedView)
        
        
        self.loadSomeOneHoledView(myJMType)
        
        
    }
    
    
    
    
    func loadSomeOneHoledView(_ type: JMHoledType){
        
        self.holedView.removeHoles()
        switch type {
        case .menu:
            //显示
            self.holedView.addHoleRoundedRect(on: CGRect(x: 10, y: 22, width: 40, height: 40), withCornerRadius: 5)
            //文字
            let label = StatisticalService().getCustomView("点击此处可对设备进行管理", width: 300, height: 40 ,fontSize: 18)
            self.holedView.addHCustomView(label, on: CGRect(x: 15, y: 80, width: 300, height: 60))
            //箭头
            let arrowImg1 = StatisticalService().getCustomeArrowView(40, transform: -CGFloat(M_PI / 4))
            self.holedView.addHCustomView(arrowImg1, on: CGRect(x: 50, y: 54, width: 40, height: 40))
  
        case .title:
            print("标题")
            
            self.holedView.addHoleRoundedRect(on: CGRect(x: (self.myRect.width - 186) / 2, y: 20 + (44 - 36) / 2, width: 186, height: 38), withCornerRadius: 5)
            
            //文字
            let label = StatisticalService().getCustomView("此处是您佩戴设备的编号\n应与您的设备编号一致", width: 300, height: 60 ,fontSize: 18)
            self.holedView.addHCustomView(label, on: CGRect(x: (self.myRect.width - 300) / 2, y: 64 + 40, width: 300, height: 60))
            //箭头
            let arrowImg1 = StatisticalService().getCustomeArrowView(40, transform: 0)
            self.holedView.addHCustomView(arrowImg1, on: CGRect(x: (self.myRect.width - 35) / 2, y: 64, width: 35, height: 35))
            
            
            
            
        case .help:
            
            self.holedView.addHoleRoundedRect(on: CGRect(x: self.myRect.width - 40 - 5, y: 22, width: 40, height: 40), withCornerRadius: 5)
            
            let label = StatisticalService().getCustomView("点击此处可查看帮助", width: 300, height: 40 ,fontSize: 20)
            self.holedView.addHCustomView(label, on: CGRect(x: self.myRect.width - 300 , y: 80, width: 300, height: 60))
   
            let arrowImg1 = StatisticalService().getCustomeArrowView(40, transform: CGFloat(M_PI / 4))
            self.holedView.addHCustomView(arrowImg1, on: CGRect(x: self.myRect.width - 90, y: 54, width: 40, height: 40))
            
        case .fingerBlood:
            
            
            let h: CGFloat = 50
            let w: CGFloat = 80

            let x = (three_width - w) / 2
            
            let y = diaHeight + 64 + (self.any_height - h) / 2 + self.any_height
 
            self.holedView.addHoleRoundedRect(on: CGRect(x: x, y: y, width: w, height: h), withCornerRadius: 5)
            
            let label = StatisticalService().getCustomView("输入指血使您的血\n糖变化趋势更精准", width: 200, height: 40 ,fontSize: 20)
            self.holedView.addHCustomView(label, on: CGRect(x: 5 , y: (self.myRect.height - 80) / 2, width: 200, height: 80))
            
            let arrowImg1 = StatisticalService().getCustomeArrowView(60, transform: CGFloat(M_PI))
            self.holedView.addHCustomView(arrowImg1, on: CGRect(x: 10, y: (self.myRect.height - 80) / 2 + 15 + 60, width: 60, height: 60))
            
        case .addEvent:
            
            let h: CGFloat = 50
            let w: CGFloat = 80
            
            let x = (three_width - w) / 2 + three_width
            
            let y = diaHeight + 64 + (self.any_height - h) / 2 + self.any_height
            
            self.holedView.addHoleRoundedRect(on: CGRect(x: x, y: y, width: w, height: h), withCornerRadius: 5)
            
            let label = StatisticalService().getCustomView("添加运动、饮食、药物记录\n更好的管理生活习惯", width: 250, height: 40 ,fontSize: 20)
            self.holedView.addHCustomView(label, on: CGRect(x: (self.myRect.width - 250) / 2 , y: (self.myRect.height - 80) / 2, width: 250, height: 80))
            
            let arrowImg1 = StatisticalService().getCustomeArrowView(60, transform: CGFloat(M_PI))
            self.holedView.addHCustomView(arrowImg1, on: CGRect(x: (self.myRect.width - 60) / 2, y: (self.myRect.height - 80) / 2 + 15 + 60, width: 60, height: 60))
            
        case .upData:
            
            
            let h: CGFloat = 50
            let w: CGFloat = 80
            
            let x = (three_width - w) / 2 + three_width * 2
            
            let y = diaHeight + 64 + (self.any_height - h) / 2 + self.any_height
            
            self.holedView.addHoleRoundedRect(on: CGRect(x: x, y: y, width: w, height: h), withCornerRadius: 5)
            
            let label = StatisticalService().getCustomView("上传您的数据\n以便医生查看", width: 150, height: 40 ,fontSize: 20)
            self.holedView.addHCustomView(label, on: CGRect(x: self.myRect.width - 150 - 5, y: (self.myRect.height - 80) / 2, width: 150, height: 80))
            
            let arrowImg1 = StatisticalService().getCustomeArrowView(60, transform: CGFloat(M_PI))
            self.holedView.addHCustomView(arrowImg1, on: CGRect(x: self.myRect.width - 60 - 10, y: (self.myRect.height - 80) / 2 + 15 + 60, width: 60, height: 60))
            
        case .seeTrends:
            
            let h: CGFloat = 50
            let w: CGFloat = 110
            
            let x = (tow_width - w) / 2
            
            let y = diaHeight + 64 + (self.any_height - h) / 2 + self.any_height * 2
            
            self.holedView.addHoleRoundedRect(on: CGRect(x: x, y: y, width: w, height: h), withCornerRadius: 5)
            
            let label = StatisticalService().getCustomView("查看血糖变化趋势", width: 200, height: 40 ,fontSize: 20)
            self.holedView.addHCustomView(label, on: CGRect(x: (self.myRect.width - 200) / 2 , y: (self.myRect.height - 80) / 2 + self.any_height, width: 200, height: 80))
            
            let arrowImg1 = StatisticalService().getCustomeArrowView(60, transform: CGFloat(M_PI * 7/6))
            self.holedView.addHCustomView(arrowImg1, on: CGRect(x: (self.myRect.width - 60) / 2 , y: (self.myRect.height - 80) / 2 + 15 + 60 + self.any_height, width: 60, height: 60))
            
        case .seeData:
            
            
            let h: CGFloat = 50
            let w: CGFloat = 110
            
            let x = (tow_width - w) / 2 + tow_width
            
            let y = diaHeight + 64 + (self.any_height - h) / 2 + self.any_height * 2
            
            self.holedView.addHoleRoundedRect(on: CGRect(x: x, y: y, width: w, height: h), withCornerRadius: 5)
            
            let label = StatisticalService().getCustomView("数据管理文案为仅供专业人士进行数据管理", width: 200, height: 40 ,fontSize: 20)
            self.holedView.addHCustomView(label, on: CGRect(x: (self.myRect.width - 200) / 2, y: (self.myRect.height - 80) / 2  + self.any_height, width: 200, height: 80))
            
            let arrowImg1 = StatisticalService().getCustomeArrowView(60, transform: -CGFloat(M_PI * 7/6))
            self.holedView.addHCustomView(arrowImg1, on: CGRect(x: (self.myRect.width - 60) / 2, y: (self.myRect.height - 80) / 2 + 15 + 60 + self.any_height, width: 60, height: 60))
   

        }
 
        
    }
    
    
  
    
    func holedView(_ holedView: JMHoledView!, didSelectHoleAt index: UInt) {
        
        print(index)
        if index == 0 {
            
            switch self.myJMType {
            case .menu:
                //
                self.myJMType = .title
                self.loadSomeOneHoledView(self.myJMType)
                
            case .title:
                
                self.myJMType = .help
                
                self.loadSomeOneHoledView(self.myJMType)
                
            case .help:
                
                self.myJMType = .fingerBlood
                self.loadSomeOneHoledView(self.myJMType)
            case .fingerBlood:
                self.myJMType = .addEvent
                self.loadSomeOneHoledView(self.myJMType)
                
            case .addEvent:
                
                self.myJMType = .upData
                self.loadSomeOneHoledView(self.myJMType)
                
            case .upData:
                self.myJMType = .seeTrends
                
                self.loadSomeOneHoledView(self.myJMType)
                
            case .seeTrends:
                self.myJMType = .seeData
                
                self.loadSomeOneHoledView(self.myJMType)
                
            case .seeData:
                
                
                if self.holedView != nil {
                    self.holedView.removeHoles()
                    self.holedView.removeFromSuperview()
                    self.holedView = nil
                }
                
                self.okActClourse?()

            }
   
            
            
        }
    
        
    }
    
    
    
 
    
    
}
