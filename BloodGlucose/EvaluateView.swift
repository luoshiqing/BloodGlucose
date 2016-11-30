//
//  EvaluateView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/8.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class EvaluateView: UIView {

    @IBOutlet weak var jingbaoImgView: UIImageView!
    
    
    @IBOutlet weak var donghuaToLeftH: NSLayoutConstraint!//163

    @IBOutlet weak var dhH: NSLayoutConstraint!//34
    @IBOutlet weak var dhW: NSLayoutConstraint!//52
    
    @IBOutlet weak var quxianToUpH: NSLayoutConstraint!//23
    @IBOutlet weak var quxianH: NSLayoutConstraint!//162
    
    @IBOutlet weak var jiaocImgToUpH: NSLayoutConstraint!//27
    @IBOutlet weak var jcImgH: NSLayoutConstraint!//200
    @IBOutlet weak var jcImgW: NSLayoutConstraint!//200
    
    @IBOutlet weak var jcLabelH: NSLayoutConstraint!//54
    @IBOutlet weak var jcLabelW: NSLayoutConstraint!//105
    
    let Wsize = UIScreen.main.bounds.width / 320
    let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
    
    
    var timme:Timer!
    var animationTime = 0.2
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    func initSetup(){
        
        donghuaToLeftH.constant = Wsize * 163
        dhH.constant = Hsize * 34
        dhW.constant = Wsize * 52
        
        quxianToUpH.constant = Hsize * 23
        quxianH.constant = Hsize * 162
        
        jiaocImgToUpH.constant = Hsize * 27
        jcImgH.constant = Wsize * 200
        jcImgW.constant = Wsize * 200
        
        jcLabelH.constant = Hsize * 54
        jcLabelW.constant = Wsize * 105
        
        //报警动画
//        self.animationAct()
        
        
        timme = Timer.scheduledTimer(timeInterval: self.animationTime * 2, target: self, selector: #selector(EvaluateView.animationAct), userInfo: nil, repeats: true)
        timme.fire()
    }
    
    func animationAct(){

        UIView.animate(withDuration: self.animationTime, delay: 0.1, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.jingbaoImgView.alpha = 0.3
            self.jingbaoImgView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.6, y: 0.6))
            }) { (finished:Bool) -> Void in
                
                UIView.animate(withDuration: self.animationTime, animations:{
                    ()-> Void in
                    //完成动画时，数字块复原
                    self.jingbaoImgView.alpha = 1
                    self.jingbaoImgView.layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))
                })
                
                
                
                
        }
        
        
    }
    
    

}
