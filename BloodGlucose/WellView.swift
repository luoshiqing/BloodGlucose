//
//  WellView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/23.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class WellView: UIView {

    
    @IBOutlet weak var wellTextLabel: UILabel!
    
    
    @IBOutlet weak var oneXGImg: UIImageView!
    @IBOutlet weak var towXGImg: UIImageView!
    @IBOutlet weak var threeXGImg: UIImageView!
    
    @IBOutlet weak var fourXGImg: UIImageView!
    @IBOutlet weak var fiveXGImg: UIImageView!
    
    @IBOutlet weak var sixXGImg: UIImageView!
    @IBOutlet weak var sevenXGImg: UIImageView!
    
    
    
    @IBOutlet weak var imgToUpH: NSLayoutConstraint!//27
    @IBOutlet weak var imgH: NSLayoutConstraint!//200
    @IBOutlet weak var imgW: NSLayoutConstraint!
    
    @IBOutlet weak var youxiuH: NSLayoutConstraint!//54
    
    
    
    
    var timme:Timer!
    var timme1:Timer!
    var animationTime = 0.35
    var animationTime1 = 0.45
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        
        
        
        
        
        self.initSetup()
        
        //布局
        self.setLayOut()
        
    }
    func setLayOut(){
        let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
        _ = UIScreen.main.bounds.width / 320
        
        imgToUpH.constant = Hsize * 27
        imgH.constant = Hsize * 200
        imgW.constant = Hsize * 200
        
        youxiuH.constant = Hsize * 54
    }
    
    var timme3:Timer!
    
    func initSetup(){
        
        
        self.timme = Timer.scheduledTimer(timeInterval: self.animationTime * 2, target: self, selector: #selector(WellView.animation1Act), userInfo: nil, repeats: true)
        self.timme.fire()
        
        self.timme1 = Timer.scheduledTimer(timeInterval: self.animationTime1 * 2, target: self, selector: #selector(WellView.animation2Act), userInfo: nil, repeats: true)
        self.timme1.fire()
        
        
//        self.timme3 = NSTimer.scheduledTimerWithTimeInterval(self.animationTime1 * 2, target: self, selector: "animation3Act", userInfo: nil, repeats: true)
//        self.timme3.fire()
        
        
    }
    
    func animation3Act(){
        
        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationDuration(animationTime1)
        self.oneXGImg.alpha = 0.0
        UIView.commitAnimations()
   
        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationDuration(animationTime1)
        self.oneXGImg.alpha = 1.0
        UIView.commitAnimations()
        
    }
    
    
    
    //动画
    func animation1Act(){
        
            
            UIView.animate(withDuration: self.animationTime, delay: 0.01, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: { () -> Void in
                
                self.oneXGImg.alpha = 0.3
                self.oneXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.1, y: 0.1))
                
                self.threeXGImg.alpha = 0.5
                self.threeXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.2, y: 0.2))
                
                self.fiveXGImg.alpha = 0.4
                self.fiveXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.6, y: 0.6))
                
                self.sevenXGImg.alpha = 0.3
                self.sevenXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.4, y: 0.4))
                
                }) { (finished:Bool) -> Void in
                    
                    UIView.animate(withDuration: self.animationTime, animations:{
                        ()-> Void in
                        //完成动画时，数字块复原
                        self.oneXGImg.alpha = 1
                        self.oneXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
                        
                        self.threeXGImg.alpha = 1
                        self.threeXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.6, y: 0.6))
                        
                        
                        
                        self.fiveXGImg.alpha = 1
                        self.fiveXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))
                        
                        self.sevenXGImg.alpha = 1
                        self.sevenXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.8, y: 0.8))
                    })
                    
                    
                    
                    
            }
            
            
        
        
   
    }
    
    func animation2Act(){
        UIView.animate(withDuration: self.animationTime1, delay: 0.01, options: UIViewAnimationOptions.layoutSubviews, animations: { () -> Void in
            
            
            
            self.towXGImg.alpha = 0.4
            self.towXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
            
            
            
            self.fourXGImg.alpha = 0.6
            self.fourXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.2, y: 0.2))

            self.sixXGImg.alpha = 0.1
            self.sixXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.1, y: 0.1))
            
            
            
            }) { (finished:Bool) -> Void in
                
                UIView.animate(withDuration: self.animationTime1, animations:{
                    ()-> Void in
                    //完成动画时，数字块复原

                    self.towXGImg.alpha = 1
                    self.towXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.9, y: 0.9))

                    self.fourXGImg.alpha = 1
                    self.fourXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.6, y: 0.6))
                    
                    self.sixXGImg.alpha = 1
                    self.sixXGImg.layer.setAffineTransform(CGAffineTransform(scaleX: 0.7, y: 0.7))
                    
                    

                })
    
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
