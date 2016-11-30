//
//  OneView.swift
//  JNWAN
//
//  Created by sqluo on 16/5/4.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class OneView: UIView {

    var oneSize:CGRect!
    
    var Wsize:CGFloat!
    var Hsize:CGFloat!
    
    
    override func draw(_ rect: CGRect) {
        //不在父视图的切除
        self.clipsToBounds = true
        
        self.oneSize = self.frame
        //根据4寸屏幕适配
        self.Wsize = UIScreen.main.bounds.width / 320
        self.Hsize = UIScreen.main.bounds.height / 568
        
        
        //1.logImg
        let imgView = UIImageView(frame: CGRect(x: self.oneSize.size.width, y: 35 * self.Hsize, width: 50 * self.Wsize, height: 50 * self.Hsize))
        imgView.image = UIImage(named: "Glog")
        self.addSubview(imgView)

        //2.手机图片
        let phoneImgView = UIImageView(frame: CGRect(x: (self.oneSize.size.width - 124 * self.Wsize) / 2, y: 70 * self.Hsize, width: 124 * self.Wsize, height: 260 * self.Hsize))
        phoneImgView.image = UIImage(named: "phone")
        phoneImgView.transform = CGAffineTransform(scaleX: 0.1,y: 0.1)
        phoneImgView.alpha = 0
        self.addSubview(phoneImgView)
        
        
        
        var minSeconds1 = 0.2 * Double(NSEC_PER_SEC)
        var dtime1 = DispatchTime.now() + Double(Int64(minSeconds1)) / Double(NSEC_PER_SEC)
        
        //log图片动画
        DispatchQueue.main.asyncAfter(deadline: dtime1, execute: {
            
            let move = JNWSpringAnimation(keyPath: "transform.translation.x")
            
            move?.damping = 15
            move?.stiffness = 50
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = -(self.oneSize.size.width - 20 * self.Wsize)
            
            imgView.layer.add(move!, forKey: move?.keyPath)
            imgView.transform = CGAffineTransform(translationX: -(self.oneSize.size.width - 20), y: 0)
            
        })

        
       
        
        minSeconds1 = 0.4 * Double(NSEC_PER_SEC)
        dtime1 = DispatchTime.now() + Double(Int64(minSeconds1)) / Double(NSEC_PER_SEC)
        
        //3.手机图片动画
        DispatchQueue.main.asyncAfter(deadline: dtime1, execute: {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                
                phoneImgView.alpha = 1
                
                }, completion: nil)
            let scale = JNWSpringAnimation(keyPath: "transform.scale")
            
            scale?.damping = 16
            scale?.stiffness = 100
            scale?.mass = 2
            
            scale?.fromValue = 0.1
            scale?.toValue = 1.0
            
            phoneImgView.layer.add(scale!, forKey: scale?.keyPath)
            phoneImgView.transform = CGAffineTransform(scaleX: 1,y: 1)
            
        })
        
        //24小时图片
        let hourImgView = UIImageView(frame: CGRect(x: self.oneSize.size.width - 20 - 105 * self.Wsize, y: -105 * self.Hsize, width: 105 * self.Hsize, height: 105 * self.Hsize))
        hourImgView.image = UIImage(named: "hour24")
        self.addSubview(hourImgView)
        
        minSeconds1 = 0.6 * Double(NSEC_PER_SEC)
        dtime1 = DispatchTime.now() + Double(Int64(minSeconds1)) / Double(NSEC_PER_SEC)
        
        //24小时图片
        DispatchQueue.main.asyncAfter(deadline: dtime1, execute: {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                
                hourImgView.alpha = 1
                
                }, completion: nil)
            let move = JNWSpringAnimation(keyPath: "transform.translation.y")
            
            move?.damping = 15
            move?.stiffness = 100
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = (250 + 105 * self.Hsize) * self.Hsize
            
            hourImgView.layer.add(move!, forKey: move?.keyPath)
            hourImgView.transform = CGAffineTransform(translationX: 0, y: (250 + 105 * self.Hsize) * self.Hsize)
            
        })
        
        //4.护士图片
        let nurseImgView = UIImageView(frame: CGRect(x: -(self.oneSize.size.width / 3) * self.Wsize, y: self.oneSize.size.height - 210 * self.Hsize - 49, width: (self.oneSize.size.width / 3 - 10) * self.Wsize, height: 210 * self.Hsize))
        nurseImgView.image = UIImage(named: "girl")
        self.addSubview(nurseImgView)
        
        minSeconds1 = 0.8 * Double(NSEC_PER_SEC)
        dtime1 = DispatchTime.now() + Double(Int64(minSeconds1)) / Double(NSEC_PER_SEC)
        
        //护士图片
        DispatchQueue.main.asyncAfter(deadline: dtime1, execute: {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                
                hourImgView.alpha = 1
                
                }, completion: nil)
            let move = JNWSpringAnimation(keyPath: "transform.translation.x")
            
            move?.damping = 30
            move?.stiffness = 100
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = (self.oneSize.size.width / 3) * self.Wsize + 30
            
            nurseImgView.layer.add(move!, forKey: move?.keyPath)
            nurseImgView.transform = CGAffineTransform(translationX: (self.oneSize.size.width / 3) * self.Wsize + 30, y: 0)
            
        })
        
        
        //5.实时动态
        
        let myLabel = UILabel(frame: CGRect(x: self.oneSize.size.width - 20 - 200 * self.Wsize,y: self.oneSize.size.height,width: 200 * self.Wsize,height: 30 * self.Hsize))

//        myLabel.backgroundColor = UIColor.greenColor()
        myLabel.font = UIFont.systemFont(ofSize: 20)
        myLabel.textAlignment = .center
        myLabel.text = "实时动态"
        myLabel.textColor = UIColor.orange
        self.addSubview(myLabel)
    
        minSeconds1 = 1.0 * Double(NSEC_PER_SEC)
        dtime1 = DispatchTime.now() + Double(Int64(minSeconds1)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: dtime1, execute: {
            
//            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                
//                myLabel.alpha = 0
//                myLabel.alpha = 1
//                
//                }, completion: nil)
            let move = JNWSpringAnimation(keyPath: "transform.translation.y")
            
            move?.damping = 20
            move?.stiffness = 100
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = -200 * self.Hsize
            
            myLabel.layer.add(move!, forKey: move?.keyPath)
            myLabel.transform = CGAffineTransform(translationX: 0, y: -200 * self.Hsize)
            
        })
   
        
        //6.血糖监测服务
        
        let bloodLabel = UILabel(frame: CGRect(x: self.oneSize.size.width - 20 - 200*self.Wsize,y: self.oneSize.size.height,width: 200*self.Wsize,height: 30*self.Hsize))
        
//        bloodLabel.backgroundColor = UIColor.greenColor()
        bloodLabel.font = UIFont.systemFont(ofSize: 28)
        bloodLabel.textAlignment = .center
        bloodLabel.text = "血糖监测服务"
        bloodLabel.textColor = UIColor.orange
        self.addSubview(bloodLabel)
        
        minSeconds1 = 1.1 * Double(NSEC_PER_SEC)
        dtime1 = DispatchTime.now() + Double(Int64(minSeconds1)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: dtime1, execute: {
            
//            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                
//                myLabel.alpha = 0
//                myLabel.alpha = 1
//                
//                }, completion: nil)
            let move = JNWSpringAnimation(keyPath: "transform.translation.y")
            
            move?.damping = 20
            move?.stiffness = 100
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = -160 * self.Hsize
            
            bloodLabel.layer.add(move!, forKey: move?.keyPath)
            bloodLabel.transform = CGAffineTransform(translationX: 0, y: -160 * self.Hsize)
            
        })
        
        
        
        
        
        
        
        
        
        
        
    }
 
    

}
