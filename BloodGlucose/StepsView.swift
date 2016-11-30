//
//  StepsView.swift
//  MyCKCircle
//
//  Created by sqluo on 16/7/18.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class StepsView: UIView {

    var trueCenter: CGPoint!
 
    var arcRadius : CGFloat = 120
    
    var arcThickness: CGFloat = 1.0
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let width = rect.size.width
        let height = rect.size.height
        
        self.trueCenter = CGPoint(x: width / 2, y: height / 2)
        
//        self.drawCircle()

        
        self.new_fff(self.trueCenter)
    }
    
    //分几份
    let aFew: Int = 5
    
    func new_fff(_ point: CGPoint){
        
        let rrr: CGFloat = 8
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for index in 0...4 {
            
            let f = (M_PI * 2 / Double(self.aFew)) * Double(index)
            
            
            x = point.x + self.arcRadius * CGFloat(sin(f)) - rrr / 2
            y = point.y - self.arcRadius * CGFloat(cos(f)) - rrr / 2
            
            let v = UIView(frame: CGRect(x: x,y: y,width: rrr,height: rrr))
            v.backgroundColor = UIColor.clear
            self.addSubview(v)
    
            
            v.transform = CGAffineTransform(rotationAngle: CGFloat(f))
            
            let xiantiaoV = UIView(frame: CGRect(x: (rrr - 1) / 2,y: 0,width: 1,height: rrr))
            xiantiaoV.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            
            //抗锯齿
            xiantiaoV.layer.shouldRasterize = true
            
            v.addSubview(xiantiaoV)
            
            
        }
 
        
    }

 
    func drawCircle(){
        
        let color = UIColor.groupTableViewBackground
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1)
        
        context?.setFillColor(color.cgColor)
        
        context?.setStrokeColor(color.cgColor)
        
        let endAngle: CGFloat = CGFloat(M_PI) * 2
        
        /*
         1. arcCenter  中心
         2. radius     半径
         3. startAngle 起始位置
         4. endAngle   结束位置
         */

        let aPath = UIBezierPath(arcCenter: self.trueCenter, radius: self.arcRadius, startAngle: 0 , endAngle: endAngle, clockwise: true)
        
        aPath.lineWidth = self.arcThickness
        
        
        
        aPath.stroke()
    }

}
