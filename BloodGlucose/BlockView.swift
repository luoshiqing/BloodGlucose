//
//  BlockView.swift
//  BloodSugar
//
//  Created by 吾久 on 15/11/27.
//  Copyright © 2015年 虞政凯. All rights reserved.
//

import UIKit

//中心坐标
var cenderPoint:CGPoint!

//半径
var radius:CGFloat!

//线的宽度
var lineWidth:CGFloat!

//CAGradientLayer
var gradientLayer:CAGradientLayer!

//合并的两个渐变后的calayer
var addLayer:CALayer!

//一般用来绘画曲线CAShapeLayer
var sapeLayer:CAShapeLayer!

//渐变的层坐标CGRect
var layerRect:CGRect!
var layerRect2:CGRect!

//Bezierpath
var bezierPath = UIBezierPath()


class BlockView: UIView {
    
    struct AlternativeRect {
        var origin = CGPoint()
        var size = CGSize()
        var center: CGPoint {
            get {
                let centerX = origin.x + (size.width / 2)
                let centerY = origin.y + (size.height / 2)
                return CGPoint(x: centerX, y: centerY)
            }
            set {
                origin.x = newValue.x - (size.width / 2)
                origin.y = newValue.y - (size.height / 2)
            }
        }
    }
    
    
    
    
    fileprivate var rawString: NSString = ""
    var name:NSString{
        
        get{
            
            print("GET ====== \(rawString)")
            return rawString
        }
        set{
            
            print("SET ====== \(rawString)")
            rawString = newValue
        }
    }

    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        let blockimageview = UIImageView(frame: frame)
//        blockimageview.image = IMAGE("pm1")
        blockimageview.center = self.center
        self.addSubview(blockimageview)
        lineWidth = 15
        cenderPoint = self.center

        gradientLayer = CAGradientLayer()
        gradientLayer.backgroundColor = UIColor(red: 1, green: 0, blue: 1, alpha: 0.5).cgColor
        
        addLayer = CALayer()
        addLayer.insertSublayer(gradientLayer, at: 0)
        sapeLayer = CAShapeLayer()
        sapeLayer.fillColor = UIColor.clear.cgColor
        sapeLayer.strokeColor = UIColor.white.cgColor
    
    }
    
       required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
       
        
        print("--------\(self.name)")
        if rect.size.height > rect.size.width
        {
            radius = rect.size.width / 2.0
        }
        else
        {
            radius = rect.size.height / 2.0
        }

        layerRect = rect
        //layerRect = CGRectMake(0,0,800,800)
        gradientLayer.frame = layerRect
        sapeLayer.lineWidth = lineWidth
        bezierPath.addArc(withCenter: cenderPoint, radius: 106 - lineWidth/2, startAngle: CGFloat(-M_PI * 1.25), endAngle: CGFloat(M_PI_4), clockwise: true)
        sapeLayer.path = bezierPath.cgPath
        sapeLayer.strokeEnd = 0.005
        addLayer.mask = sapeLayer
        self.layer.addSublayer(addLayer)
    }

}
