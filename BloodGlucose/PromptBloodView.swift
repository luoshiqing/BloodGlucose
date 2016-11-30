//
//  PromptBloodView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/3.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class PromptBloodView: UIView {

    
    
    fileprivate let bgColor = UIColor(red: 32/255.0, green: 198/255.0, blue: 55/255.0, alpha: 1)
    
    fileprivate let names = "点击这里录入今日指血"
    
    //三角 宽度 10 ，高度 10
    
    let sjWidth: CGFloat = 10
    
    
    override func draw(_ rect: CGRect) {
        
        
        
        let downH = rect.height - 10
        let downW = rect.width
        //上部视图
        let downView = UIView(frame: CGRect(x: 0,y: 0,width: downW,height: downH))
        downView.backgroundColor = self.bgColor
        
        downView.layer.cornerRadius = 3
        downView.layer.masksToBounds = true
        downView.alpha = 0.8
        self.addSubview(downView)
        
        
        //标题
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: downW,height: downH))
        titleLabel.text = self.names
        titleLabel.font = UIFont(name: PF_SC, size: 14)
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.white
        
        titleLabel.layer.cornerRadius = 3
        titleLabel.layer.masksToBounds = true
        
        self.addSubview(titleLabel)
        
        
        
        self.drawTriangle(rect)
        
      
        
    }
 
    func drawTriangle(_ rect: CGRect){
        
        
        let startPoint: CGFloat = 15
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.beginPath()
        
        context?.move(to: CGPoint(x: startPoint, y: rect.height - self.sjWidth))
        
        context?.addLine(to: CGPoint(x: startPoint + self.sjWidth, y: rect.height - self.sjWidth))
        context?.addLine(to: CGPoint(x: startPoint + self.sjWidth / 2, y: rect.height))
        
        context?.closePath()
        
        self.bgColor.setFill()
        
        UIColor.clear.setStroke()
        
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
        
    }
    
    

}
