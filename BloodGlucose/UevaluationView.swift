//
//  UevaluationView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/28.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class UevaluationView: UIView {

    
    var statValue:CGFloat = CGFloat(M_PI) - CGFloat(M_PI / 4)
    var tmpEndValue:CGFloat = CGFloat(M_PI) - CGFloat(M_PI / 4)
    var endValue = CGFloat(M_PI * 2) + CGFloat(M_PI / 4)
    
    //接收评分
    var circleValue:CGFloat!
    //根据评分算出的 value 值
    var tmpCircleValue:CGFloat = 0
    
    //设置动画的定时器
    var animationNSTimer:Timer!
    var addValue:CGFloat = 0.3 //单步递增的值
    
    
    
    var uDateLabel:UILabel!
    
    var uDateView:UIView!
    
    //2.加载日期选择视图
    func loadUevaluationDateView(_ date:String){
        
        //大背景图
        self.uDateView = UIView(frame: CGRect(x: self.frame.size.width - 110 - 5,y: 2,width: 110,height: 25))
        self.uDateView.backgroundColor = UIColor.clear
        self.addSubview(self.uDateView)
        //时钟图片
        let tImg = UIImageView(frame: CGRect(x: 0, y: (self.uDateView.frame.size.height - 17) / 2, width: 16, height: 17))
        tImg.image = UIImage(named: "uTime")
        self.uDateView.addSubview(tImg)
        
        //时间文字
        self.uDateLabel = UILabel(frame: CGRect(x: 18,y: (self.uDateView.frame.size.height - 12) / 2,width: 80,height: 12))
        self.uDateLabel.textColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1)
        self.uDateLabel.text = date
        self.uDateLabel.font = UIFont.systemFont(ofSize: 13)
//        self.uDateLabel.backgroundColor = UIColor.whiteColor()
        self.uDateView.addSubview(self.uDateLabel)

        //向下箭头
        let downImg = UIImageView(frame: CGRect(x: 97, y: (self.uDateView.frame.size.height - 6) / 2, width: 10.5, height: 6))
        downImg.image = UIImage(named: "uDown")
        self.uDateView.addSubview(downImg)
    }

    
    
    
    
    
    //3.加载圆形动画
    func initUevaluationView(_ circleValue:CGFloat){
        self.circleValue = circleValue
        
        self.tmpCircleValue = (self.endValue - self.statValue) * circleValue / 100 + self.statValue
        print(self.statValue,self.tmpCircleValue,self.endValue)
        
        

        BGNetwork().delay(0.5) { 
            self.animationNSTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(UevaluationView.animationTimerAct), userInfo: nil, repeats: true)
        }
        
        
        
    }
    

    var numLabel:UILabel!

    //1.加载其他视图
    func loadUevaluationAnyView(_ numVlaue:CGFloat){
        
        //等级label
        let stateLabel = UILabel(frame: CGRect(x: (self.frame.size.width - 35) / 2,y: 78 - 30,width: 35,height: 35))
        stateLabel.font = UIFont.systemFont(ofSize: 35)
        stateLabel.textAlignment = .center
//        stateLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.addSubview(stateLabel)
        //差良优
        switch numVlaue {
        case 0..<60:
            stateLabel.text = "差"
            stateLabel.textColor = UIColor(red: 254/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
        case 60..<80:
            stateLabel.text = "良"
            stateLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        case 80...100:
            stateLabel.text = "优"
            stateLabel.textColor = UIColor(red: 21/255.0, green: 204/255.0, blue: 71/255.0, alpha: 1)
        default:
            break
        }
        //数值label
        self.numLabel = UILabel(frame: CGRect(x: (self.frame.size.width - 90) / 2,y: 48 + 35 + 12,width: 90,height: 25))
        self.numLabel.font = UIFont.systemFont(ofSize: 24)
        self.numLabel.textAlignment = .center
        self.numLabel.textColor = UIColor(red: 99/255.0, green: 99/255.0, blue: 99/255.0, alpha: 1)
        self.numLabel.text = "0分"
        self.addSubview(self.numLabel)
        
        
        let jiancepf = UILabel(frame: CGRect(x: (self.frame.size.width - 80) / 2,y: 48 + 35 + 12 + 25 + 12,width: 80,height: 20))
        jiancepf.font = UIFont.systemFont(ofSize: 13)
        jiancepf.textAlignment = .center
        jiancepf.textColor = UIColor(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1)
        jiancepf.text = "检测评分"
        self.addSubview(jiancepf)
        
        
    }
    
    
    
    
    
    func animationTimerAct(){

        
        if self.tmpEndValue <  self.tmpCircleValue{
            
            if self.tmpEndValue + self.addValue < self.tmpCircleValue {
                self.tmpEndValue += self.addValue
                
                let tttt = Float(self.tmpEndValue - self.statValue) / Float(self.endValue - self.statValue) * 100
                let textValue = NSString(format: "%.1f", tttt)
                if self.numLabel != nil {
                    self.numLabel.text = "\(textValue)分"
                }
                
                
            }else{
                self.tmpEndValue = self.tmpCircleValue
                let tttt = Float(self.tmpEndValue - self.statValue) / Float(self.endValue - self.statValue) * 100
                let textValue = NSString(format: "%.1f", tttt)
                if self.numLabel != nil {
                    self.numLabel.text = "\(textValue)分"
                }
            }
            
            self.setNeedsDisplay()
            
        }else{

            
            if self.animationNSTimer != nil {
                self.animationNSTimer.invalidate()
                self.animationNSTimer = nil
            }
        }
        
        
    }
    
    
    override func draw(_ rect: CGRect) {
        
        //加载 灰色 圆
        self.myCircles()

        self.myCircle(self.tmpEndValue)
        
    }
 
    
    func myCircles(){
        
        let mycontext1 = UIGraphicsGetCurrentContext()
        
        mycontext1?.setFillColor(red: 0, green: 0.5, blue: 0, alpha: 1) //设置内圈颜色
        
        mycontext1?.setStrokeColor(red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1) //设置外圈颜色
        
        mycontext1?.setLineWidth(3)
        
        
//        CGContextAddArc(mycontext1, (self.frame.size.width - 78) / 2 + 78 / 2, 100, 78, self.statValue, self.endValue, 0)
        
        mycontext1?.addArc(center: CGPoint(x: (self.frame.size.width - 78) / 2 + 78 / 2, y: 100), radius: 78, startAngle: self.statValue, endAngle: self.endValue, clockwise: false)
        
        
        mycontext1?.drawPath(using: CGPathDrawingMode.stroke)
        
        
        
    }
    
    func myCircle(_ endValue: CGFloat){
        
        let mycontext = UIGraphicsGetCurrentContext()
        
        mycontext?.setFillColor(red: 0, green: 0.5, blue: 0.5, alpha: 1) //设置内圈颜色
        
        mycontext?.setStrokeColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1) //设置外圈颜色
        
        mycontext?.setLineWidth(3)
        
//        CGContextAddArc(mycontext, (self.frame.size.width - 78) / 2 + 78 / 2, 100, 78, self.statValue, endValue, 0)

        mycontext?.addArc(center: CGPoint(x: (self.frame.size.width - 78) / 2 + 78 / 2, y: 100), radius: 78, startAngle: self.statValue, endAngle: endValue, clockwise: false)
        
        
        mycontext?.drawPath(using: CGPathDrawingMode.stroke)
        
        
        
    }
    

}
