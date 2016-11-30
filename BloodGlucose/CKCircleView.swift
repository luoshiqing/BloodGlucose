//
//  CKCircleView.swift
//  MyCKCircle
//
//  Created by sqluo on 16/7/15.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

import QuartzCore


class CKCircleView: UIView {

    var currentNum: Int!
    
    var minNum: Int!
    
    var maxNum: Int!
    
    var units: String!
    
    var dialRadius: CGFloat!
    
    var dialColor: UIColor!
    
    var outerRadius: CGFloat!
    
    var backColor: UIColor!
    
    var arcColor: UIColor!
    
    var arcRadius: CGFloat!
    
    var arcThickness: CGFloat!
    
    var labelFont: UIFont!
    
    var labelColor: UIColor!
    
    //---------
    var trueCenter: CGPoint!

    var numberLabel: UILabel!
    
    var angle: Double!
    
    var circle: UIView!
    
    
    func initCircleView(_ frame: CGRect){
        
        
        
        
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        
        
        self.minNum = 0
        self.maxNum = 100
        self.currentNum = self.minNum
        self.units = ""
        
        //
        let width = frame.size.width
        let height = frame.size.height
        
        self.trueCenter = CGPoint(x: width / 2, y: height / 2)
        
        //
        self.dialRadius = 10
        self.arcRadius = 50
        self.outerRadius = min(width, height) / 2
        self.arcThickness = 5.0
        
        self.circle = UIView(frame: CGRect(x: (width - self.dialRadius * 2) / 2 ,y: height * 0.25 ,width: self.dialRadius * 2, height: self.dialRadius * 2))
        
        self.circle.isUserInteractionEnabled = true
        self.addSubview(self.circle)
        
        //
        self.numberLabel = UILabel(frame: CGRect(x: width * 0.1,y: height / 2 - width / 6,width: width * 0.8, height: width / 3))
        self.numberLabel.text = "\(self.currentNum)" + self.units
        self.numberLabel.center = self.trueCenter

        self.numberLabel.textAlignment = .center
        self.labelFont = UIFont(name: "Arial", size: 15)
        self.numberLabel.font = self.labelFont
        
 
        self.addSubview(self.numberLabel)
        
        
        //滑动手势
        
//        let pv = UIPanGestureRecognizer(target: self, action: #selector(CKCircleView.handlePan(_:)))
//        self.addGestureRecognizer(pv)
        
        self.arcColor = UIColor.red
        self.backColor = UIColor.yellow
        self.dialColor = UIColor.blue
        self.labelColor = UIColor.black
        
        
    }
    

    
 
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        
        
        
        self.setBgCircle()
        
        let color = self.arcColor
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1)
        
        context?.setFillColor((color?.cgColor)!)
        
        context?.setStrokeColor((color?.cgColor)!)
        
        let path: UIBezierPath = self.createAcrPathWithAngle(self.angle, point: self.trueCenter, radius: self.arcRadius)
        
        path.lineWidth = self.arcThickness
        
        if self.angle > 1 {
            path.stroke()
        }
        
        //外内线条圆
        self.setOuterRing()
        self.InnerRing()
        //内部实体圆
        self.loadInsideCircle()
    }
    
    var xxxxxL: CGFloat = 0.5
    
    
    func setOuterRing(){
        
        let color = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(10)
        
        context?.setFillColor(color.cgColor)
        
        context?.setStrokeColor(color.cgColor)
        
        let endAngle: CGFloat = CGFloat(M_PI) * 2

        let aPath = UIBezierPath(arcCenter: self.trueCenter, radius: self.arcRadius + self.arcThickness / 2, startAngle: 0 , endAngle: endAngle, clockwise: true)
        
        aPath.lineWidth = xxxxxL
        
        
        aPath.stroke()
    }
    func InnerRing(){
        
        let color = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(10)
        
        context?.setFillColor(color.cgColor)
        
        context?.setStrokeColor(color.cgColor)
        
        let endAngle: CGFloat = CGFloat(M_PI) * 2
        
        let aPath = UIBezierPath(arcCenter: self.trueCenter, radius: self.arcRadius - self.arcThickness / 2 , startAngle: 0 , endAngle: endAngle, clockwise: true)
        
        aPath.lineWidth = xxxxxL
        
        
        aPath.stroke()
    }
    
    
    
    func setBgCircle(){
        
        let color = UIColor.white
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(10)
        
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
    
    func loadInsideCircle(){
        
        let color = UIColor(red: 246/255.0, green: 96/255.0, blue: 34/255.0, alpha: 1)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(10)
        
        context?.setFillColor(color.cgColor)
        
        context?.setStrokeColor(color.cgColor)
        
        let endAngle: CGFloat = CGFloat(M_PI) * 2
        
        /*
         1. arcCenter  中心
         2. radius     半径
         3. startAngle 起始位置
         4. endAngle   结束位置
         */
        
        
        let aPath = UIBezierPath(arcCenter: self.trueCenter, radius: self.arcRadius - 18, startAngle: 0 , endAngle: endAngle, clockwise: true)
        
        aPath.lineWidth = 13
        
        
        aPath.stroke()
        
        
        
    }
    
    
    
    
    
    
 
    func handlePan(_ pv: UIPanGestureRecognizer){
        
        let translation: CGPoint = pv.location(in: self)
        
        let x_displace: CGFloat = translation.x - self.trueCenter.x
        
        let y_displace: CGFloat = -1.0 * (translation.y - self.trueCenter.y)
        
        var radius: Double = Double(pow(x_displace, 2) + pow(y_displace, 2))
        
        radius = pow(radius, 0.5)
        
        var angle: Double = 180 / M_PI * asin(Double(x_displace) / radius)
        
        if x_displace > 0 && y_displace < 0 {
            angle = 180 - angle
        }else if x_displace < 0 {
            
            if y_displace > 0 {
                angle = 360.0 + angle
            }else if y_displace <= 0 {
                angle = 180 + -1.0 * angle
            }
   
        }
        
//        print("------>>>>:\(angle)")
        
        self.moveCircleToAngle(angle)
        
        
    }
    
    func moveCircleToAngle(_ angle: Double){
        
        self.angle = angle
        
        self.setNeedsDisplay()
        
        
        let width = self.frame.size.width
        
        let heigth = self.frame.size.height
        
        var newCenter = CGPoint(x: width / 2, y: heigth / 2)
        
        
        newCenter.y += self.arcRadius * CGFloat(sin(M_PI / 180 * (angle - 90)))
        newCenter.x += self.arcRadius * CGFloat(cos(M_PI / 180 * (angle - 90)))
        
        self.circle.center = newCenter
        self.currentNum = self.minNum + Int(Double(self.maxNum - self.minNum) * (angle / 360.0))
        
        
//        self.numberLabel.text = "\(self.currentNum)%"
        self.numberLabel.text = ""
        
//        print("inside move circle current numb is---->:\(self.currentNum)")
        
    }
    
    

    func createAcrPathWithAngle(_ angle: Double, point: CGPoint ,radius: CGFloat) ->UIBezierPath{
        
        let endAngle: CGFloat = CGFloat((Int(angle) + 270 + 1) % 360)
        
        let aPath = UIBezierPath(arcCenter: point, radius: radius, startAngle: self.degreesToRadians(270) , endAngle: self.degreesToRadians(endAngle), clockwise: true)

        return aPath
        
    }
    
    func degreesToRadians(_ degrees: CGFloat) ->CGFloat{

        return (CGFloat(M_PI) * degrees) / 180
        
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        super.willMove(toSuperview: newSuperview)
        
        //背景圆
        self.arcRadius = min(self.arcRadius, self.outerRadius - self.dialRadius)
        
        self.layer.cornerRadius = self.outerRadius
        
        self.backgroundColor = self.backColor
//        self.backgroundColor = UIColor.redColor()
        
        
//         var circle: UIView!
        //dial
        self.circle.frame = CGRect(x: (self.frame.size.width - self.dialRadius * 2) / 2, y: self.frame.size.height * 0.25, width: self.dialRadius * 2, height: self.dialRadius * 2)
        
        self.circle.layer.cornerRadius = self.dialRadius
        
        self.circle.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        self.setAlph(self.circle)
        
        //label
        self.numberLabel.font = self.labelFont
        self.numberLabel.text = "\(self.currentNum)" + self.units
        
        self.numberLabel.text = "0"
        
        self.numberLabel.textColor = self.labelColor
        
        
        self.moveCircleToAngle(0)
        
        self.setNeedsDisplay()
        

    }
 
    
    
    var colorArray = [UIColor().rgb(255, g: 94, b: 0, alpha: 1),
                      UIColor().rgb(255, g: 144, b: 0, alpha: 1),
                      UIColor().rgb(255, g: 210, b: 0, alpha: 1),
                      UIColor().rgb(255, g: 210, b: 0, alpha: 1)]
    
  
    var colorIndex = 0
    
    
    func setAlph(_ circle: UIView){
     
        
        
        
        
        UIView.animate(withDuration: 2 / 6.0, delay: 0, options: UIViewAnimationOptions(), animations: {
            
            
            var clolors = UIColor().rgb(246, g: 93, b: 34, alpha: 1)
            
            switch self.colorIndex{
            case 0:
                clolors = self.colorArray[0]
                self.colorIndex = 1
            case 1:
                clolors = self.colorArray[1]
                self.colorIndex = 2
            case 2:
                clolors = self.colorArray[2]
                self.colorIndex = 3
            case 3:
                clolors = self.colorArray[3]
                self.colorIndex = 0
                self.colorArray = self.colorArray.reversed()
            default:
                break
            }
            
            
            circle.backgroundColor = clolors
            

        }) { (comp: Bool) in
            
            self.setAlph(circle)
             
            
        }
  
    }
    
    
    
    
    
    
    
    
    
    
    
    

}
