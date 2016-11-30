//
//  AdviceView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/11.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit


protocol AdvieceViewDelegate{
    func advieceAct(_ tag:Int)
}

class AdviceView: UIView {

    var delegate:AdvieceViewDelegate!
    
    @IBOutlet weak var advicView: UIView!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    
    @IBOutlet weak var leftImgView: UIImageView!
    
    @IBOutlet weak var leftLabel: UILabel!
    
    
    @IBOutlet weak var rightImgView: UIImageView!
    
    @IBOutlet weak var rightLabel: UILabel!
    
    
    
    
    
    @IBOutlet weak var leftW: NSLayoutConstraint!//110
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    func initSetup(){
        
        self.leftImgView.image = UIImage(named: "spoonForkF.png")
        self.rightImgView.image = UIImage(named: "basketballL.png")
        
        
        //布局
        leftW.constant = UIScreen.main.bounds.width / 320 * 110
        
        //设置半边圆角
        let maskPath = UIBezierPath(roundedRect: leftView.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.topLeft], cornerRadii: CGSize(width: 4, height: 4))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = leftView.bounds
        
        maskLayer.path = maskPath.cgPath
        
        leftView.layer.mask = maskLayer
        
        let maskPath1 = UIBezierPath(roundedRect: rightView.bounds, byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 4, height: 4))
        
        let maskLayer1 = CAShapeLayer()
        
        maskLayer1.frame = rightView.bounds
        
        maskLayer1.path = maskPath1.cgPath
        
        rightView.layer.mask = maskLayer1
        
        
        //设置圆角
        advicView.layer.cornerRadius = 4
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
            //点击运动
            if (send.view!.tag == 235) {
                self.rightView.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
                self.leftView.backgroundColor = UIColor.white
                
                //设置图片字体
                self.leftLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
                self.rightLabel.textColor = UIColor.white
                
                self.leftImgView.image = UIImage(named: "spoonForkL.png")
                self.rightImgView.image = UIImage(named: "basketballF.png")
                
                self.delegate.advieceAct(send.view!.tag)
                self.leftBool = true
                print("235")
            }
        }else{
            //点击饮食
            if (send.view!.tag == 234) {
                
                self.leftView.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
                self.rightView.backgroundColor = UIColor.white
                
                self.leftImgView.image = UIImage(named: "spoonForkF.png")
                self.rightImgView.image = UIImage(named: "basketballL.png")
                //设置图片字体
                self.rightLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
                self.leftLabel.textColor = UIColor.white
                
                
                self.delegate.advieceAct(send.view!.tag)
                self.leftBool = false
                print("234")
            }
        }
        
        
        
        
    }
    

}
