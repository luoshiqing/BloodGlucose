//
//  EnergyFigureView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/14.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class EnergyFigureView: UIView {

    
    var max:Float = 11000.0
    var value:Float = 0.0
    var tmpEndValue:CGFloat = 0.0

    override func draw(_ rect: CGRect) {
        
        
        self.loadBgCircles()
        
        
        self.loadValueCircles((self.tmpCircleValue * CGFloat(M_PI * 2)))
        
        
    }
 
    
    var tmpCircleValue:CGFloat = 0.0
    
    //设置动画的定时器
    var animationNSTimer:Timer!
    var addValue:CGFloat = 0.01 //单步递增的值
    
    var MaxValue:CGFloat = 0
    
    func setSomeData(_ max: Float,value: Float){
        self.max = max
        self.value = value
        
//        self.setNeedsDisplay()
        
        
        
        
//        self.MaxValue = CGFloat(value / max)
        
        
        self.tmpCircleValue = CGFloat(value / max)
        
        
        print("MaxValue:\(self.tmpCircleValue)")
        
        self.setNeedsDisplay()
//        BGNetwork().delay(0.2) {
//            self.animationNSTimer = NSTimer.scheduledTimerWithTimeInterval(0.007, target: self, selector: #selector(EnergyFigureView.animationTimerAct), userInfo: nil, repeats: true)
//        }
   
    }
    
    func animationTimerAct(){
        
        
//        tmpCircleValue = tmpCircleValue / CGFloat(M_PI * 2)
//        print("tmpCircleValue:\(tmpCircleValue)")
        
        if MaxValue == 0.0 {
            self.tmpCircleValue = 0.0
            if self.animationNSTimer != nil {
                self.animationNSTimer.invalidate()
                self.animationNSTimer = nil
                
                print("释放")
                
            }
            self.setNeedsDisplay()
        }else{
            
            if tmpCircleValue < MaxValue{
                if tmpCircleValue + addValue < MaxValue {
                    self.tmpCircleValue += self.addValue
                    
                    
                    
                    
                }else{
                    
                    self.tmpCircleValue = self.MaxValue
                    
                    
                    
                    
                }
                
                self.setNeedsDisplay()
            }else{
                
                
                
                if self.animationNSTimer != nil {
                    self.animationNSTimer.invalidate()
                    self.animationNSTimer = nil
                    
                    print("释放")
                    
                }
                self.tmpCircleValue = 0.0
                
            }
            
        }
     
        
    }
    
    
    
    
    //加载背景大圆
    func loadBgCircles(){
        
        let mycontext1 = UIGraphicsGetCurrentContext()

        
        let aColor = UIColor(red: 254/255.0, green: 241/255.0, blue: 235/255.0, alpha: 1)
        mycontext1?.setFillColor(aColor.cgColor)
        
        mycontext1?.setLineWidth(1)
//        CGContextAddArc(mycontext1, 50, 50, 50, 0, CGFloat(M_PI) * 2, 0)
        
        mycontext1?.addArc(center: CGPoint(x: 50, y: 50), radius: 50, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: false)
        
        mycontext1?.drawPath(using: CGPathDrawingMode.fill)
    }
    
    
    //加载当前比例 扇形
    func loadValueCircles(_ value: CGFloat){


        let mycontext: CGContext? = UIGraphicsGetCurrentContext()
        
        let aColor = UIColor(red: 255/255.0, green: 200/255.0, blue: 176/255.0, alpha: 1)
        mycontext?.setFillColor(aColor.cgColor)
        

        mycontext?.move(to: CGPoint(x: 50, y: 50))
        

//        CGContextAddArc(mycontext, 50, 50, 50, 0, value, 0)

        mycontext?.addArc(center: CGPoint(x: 50, y: 50), radius: 50, startAngle: 0, endAngle: value, clockwise: false)
        
        
        mycontext?.closePath()
        

        mycontext?.drawPath(using: CGPathDrawingMode.fill)


        
        
    }
    
    
    
    
    
    

}
