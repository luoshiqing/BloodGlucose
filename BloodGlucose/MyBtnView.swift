//
//  MyBtnView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/28.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyBtnView: UIView {
    
    
    @IBOutlet weak var bgView: UIView!
    
    
    @IBOutlet weak var leftBtn: UIButton!
    
    @IBOutlet weak var rightBtn: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {

        self.initSetup()
        
    }
    
    func initSetup(){
        //设置bgView 圆角
        bgView.layer.cornerRadius = 5
        bgView.clipsToBounds = true
        
        
        
        //设置半边圆角
//        let maskPath = UIBezierPath(roundedRect: leftBtn.bounds, byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.TopLeft], cornerRadii: CGSizeMake(11, 11))
//        
//        let maskLayer = CAShapeLayer()
//        
//        maskLayer.frame = leftBtn.bounds
//        
//        maskLayer.path = maskPath.CGPath
//        
//        leftBtn.layer.mask = maskLayer
//        
//        let maskPath1 = UIBezierPath(roundedRect: rightBtn.bounds, byRoundingCorners: [UIRectCorner.TopRight, UIRectCorner.BottomRight], cornerRadii: CGSizeMake(11, 11))
//        
//        let maskLayer1 = CAShapeLayer()
//        
//        maskLayer1.frame = rightBtn.bounds
//        
//        maskLayer1.path = maskPath1.CGPath
//        
//        rightBtn.layer.mask = maskLayer1
//        
//        
//        self.leftBtn.addTarget(self, action: "btnAct:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.rightBtn.addTarget(self, action: "btnAct:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        self.leftBtn.tag = 1
//        self.rightBtn.tag = 2
        
        
        
    }

    func btnAct(_ send:UIButton){
        switch send.tag{
        case 1:
            print("左边")
        case 2:
            print("右边")
        default:
            break
        }
    }
    
    
    
}
