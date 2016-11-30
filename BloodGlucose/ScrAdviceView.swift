//
//  ScrAdviceView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/14.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

protocol ScrAdviceViewDelegate{
    func ScrAdviceViewAct(_ tag:Int)
}


class ScrAdviceView: UIView {

    var delegate:ScrAdviceViewDelegate!
    
    
    @IBOutlet weak var advicView: UIView!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var rightImgView: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
    
    @IBOutlet weak var leftW: NSLayoutConstraint!//150
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    func initSetup(){
        
        //布局
        self.leftW.constant = self.frame.size.width / 320 * 150
        
        self.leftImgView.image = UIImage(named: "yinshi-tb.png")!.imageWithTintColor(UIColor.white)
        self.rightImgView.image = UIImage(named: "yundong-tb.png")!.imageWithTintColor(UIColor.orange)
        
        //设置半边圆角
        let maskPath = UIBezierPath(roundedRect: leftView.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.topLeft], cornerRadii: CGSize(width: 11, height: 11))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = leftView.bounds
        
        maskLayer.path = maskPath.cgPath
        
        leftView.layer.mask = maskLayer
        
        let maskPath1 = UIBezierPath(roundedRect: rightView.bounds, byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 11, height: 11))
        
        let maskLayer1 = CAShapeLayer()
        
        maskLayer1.frame = rightView.bounds
        
        maskLayer1.path = maskPath1.cgPath
        
        rightView.layer.mask = maskLayer1
        
        
        //设置label 圆角
        advicView.layer.cornerRadius = 12
        advicView.clipsToBounds = true
        
        
        
        
        //设置点击事件
        self.leftView.isUserInteractionEnabled = true
        self.rightView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AdviceView.adviceAct(_:)))
        self.leftView.addGestureRecognizer(tap)
        self.leftView.tag = 234
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(AdviceView.adviceAct(_:)))
        self.rightView.addGestureRecognizer(tap1)
        self.rightView.tag = 235
        
        
        
    }
    
    var leftBool:Bool = false
    
    func adviceAct(_ send:UITapGestureRecognizer){
        
        if (self.leftBool == false) {
            if (send.view!.tag == 235) { //运动
                self.rightView.backgroundColor = UIColor.orange
                self.leftView.backgroundColor = UIColor.white
                
                //设置图片字体
                self.leftLabel.textColor = UIColor.orange
                self.rightLabel.textColor = UIColor.white
                
                self.leftImgView.image = UIImage(named: "yinshi-tb.png")!.imageWithTintColor(UIColor.orange)
                self.rightImgView.image = UIImage(named: "yundong-tb.png")!.imageWithTintColor(UIColor.white)
                
                self.delegate.ScrAdviceViewAct(send.view!.tag)
                self.leftBool = true
                print("235")
            }
        }else{
            if (send.view!.tag == 234) { //饮食
                
                self.leftView.backgroundColor = UIColor.orange
                self.rightView.backgroundColor = UIColor.white
                
                self.leftImgView.image = UIImage(named: "yinshi-tb.png")!.imageWithTintColor(UIColor.white)
                self.rightImgView.image = UIImage(named: "yundong-tb.png")!.imageWithTintColor(UIColor.orange)
                //设置图片字体
                self.rightLabel.textColor = UIColor.orange
                self.leftLabel.textColor = UIColor.white
                
                
                self.delegate.ScrAdviceViewAct(send.view!.tag)
                self.leftBool = false
                print("234")
            }
        }
        
        
        
        
    }


}
