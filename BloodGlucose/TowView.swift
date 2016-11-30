//
//  TowView.swift
//  JNWAN
//
//  Created by sqluo on 16/5/4.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class TowView: UIView {

    var TowSize:CGSize!
    
    var Wsize:CGFloat!
    var Hsize:CGFloat!
    
    override func draw(_ rect: CGRect) {
        
        TowSize = self.frame.size
        
        Wsize = UIScreen.main.bounds.width / 320
        Hsize = UIScreen.main.bounds.height / 568
        
        print(Wsize,Hsize)
        
        //孕妇
        let womanImgView = UIImageView(frame: CGRect(x: 10 * Wsize, y: -(250 * Hsize), width: 60 * Wsize , height: 250 * Hsize))
        womanImgView.image = UIImage(named: "woman")
        self.addSubview(womanImgView)
        
        var minSeconds1 = 0.1 * Double(NSEC_PER_SEC)
        var dtime1 = DispatchTime.now() + Double(Int64(minSeconds1)) / Double(NSEC_PER_SEC)
        
        //孕妇
        DispatchQueue.main.asyncAfter(deadline: dtime1, execute: {

            let move = JNWSpringAnimation(keyPath: "transform.translation.y")
            
            move?.damping = 15
            move?.stiffness = 100
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = 250 * self.Hsize
            
            womanImgView.layer.add(move!, forKey: move?.keyPath)
            womanImgView.transform = CGAffineTransform(translationX: 0, y: 250 * self.Hsize)
            
        })
        //家人
        let familyImgView = UIImageView(frame: CGRect(x: (10 + 40) * self.Wsize, y: -(350 * Hsize), width: 80 * Wsize , height: 350 * Hsize))
        familyImgView.image = UIImage(named: "family")
        self.addSubview(familyImgView)
        
        minSeconds1 = 0.3 * Double(NSEC_PER_SEC)
        dtime1 = DispatchTime.now() + Double(Int64(minSeconds1)) / Double(NSEC_PER_SEC)
        
        //家人
        DispatchQueue.main.asyncAfter(deadline: dtime1, execute: {
            
            let move = JNWSpringAnimation(keyPath: "transform.translation.y")
            
            move?.damping = 10
            move?.stiffness = 100
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = 350 * self.Hsize
            
            familyImgView.layer.add(move!, forKey: move?.keyPath)
            familyImgView.transform = CGAffineTransform(translationX: 0, y: 350 * self.Hsize)
            
        })
        
        
        //家人2
        let family2ImgView = UIImageView(frame: CGRect(x: (10 + 40 + 60) * self.Wsize, y: -(170 * Hsize), width: 75 * Wsize , height: 170 * Hsize))
        family2ImgView.image = UIImage(named: "family1")
        self.addSubview(family2ImgView)
        
        minSeconds1 = 0.5 * Double(NSEC_PER_SEC)
        dtime1 = DispatchTime.now() + Double(Int64(minSeconds1)) / Double(NSEC_PER_SEC)
        
        //家人2
        DispatchQueue.main.asyncAfter(deadline: dtime1, execute: {
            
            let move = JNWSpringAnimation(keyPath: "transform.translation.y")
            
            move?.damping = 18
            move?.stiffness = 100
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = 170 * self.Hsize
            
            family2ImgView.layer.add(move!, forKey: move?.keyPath)
            family2ImgView.transform = CGAffineTransform(translationX: 0, y: 170 * self.Hsize)
            
        })
        
        //血糖异常
        
        let bloodNoImgView = UIImageView(frame: CGRect(x: (10 + 40 + 60 + 70) * self.Wsize, y: -(245 * Hsize), width: 88 * Wsize , height: 245 * Hsize))
        bloodNoImgView.image = UIImage(named: "bloodNo")
        self.addSubview(bloodNoImgView)
        
        minSeconds1 = 0.7 * Double(NSEC_PER_SEC)
        dtime1 = DispatchTime.now() + Double(Int64(minSeconds1)) / Double(NSEC_PER_SEC)
        
        //家人2
        DispatchQueue.main.asyncAfter(deadline: dtime1, execute: {
            
            let move = JNWSpringAnimation(keyPath: "transform.translation.y")
            
            move?.damping = 13
            move?.stiffness = 100
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = 245 * self.Hsize
            
            bloodNoImgView.layer.add(move!, forKey: move?.keyPath)
            bloodNoImgView.transform = CGAffineTransform(translationX: 0, y: 245 * self.Hsize)
            
        })
        
        
        //亚健康
//        let noHealthImgView = UIImageView(frame: CGRect(x: (10 + 40 + 60 + 70 + 65) * self.Wsize, y: -(315 * Hsize), width: 68 * Wsize , height: 315 * Hsize))
        
        let x: CGFloat = (10 + 40 + 60 + 70 + 65) * self.Wsize
        let noHealthImgView = UIImageView(frame: CGRect(x: x, y: -(315 * Hsize), width: 68 * Wsize, height: 315 * Hsize))
        
        
        noHealthImgView.image = UIImage(named: "noHealth")
        self.addSubview(noHealthImgView)
        
        minSeconds1 = 0.9 * Double(NSEC_PER_SEC)
        dtime1 = DispatchTime.now() + Double(Int64(minSeconds1)) / Double(NSEC_PER_SEC)
        
        //家人2
        DispatchQueue.main.asyncAfter(deadline: dtime1, execute: {
            
            let move = JNWSpringAnimation(keyPath: "transform.translation.y")
            
            move?.damping = 15
            move?.stiffness = 100
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = 315 * self.Hsize
            
            noHealthImgView.layer.add(move!, forKey: move?.keyPath)
            noHealthImgView.transform = CGAffineTransform(translationX: 0, y: 315 * self.Hsize)
            
        })
        
        
        //我需要吗？
        
        let myLabel = UILabel(frame: CGRect(x: (TowSize.width - 300) / 2,y: TowSize.height,width: 300,height: 40))
        
        myLabel.textColor = UIColor.orange

        myLabel.textAlignment = .center
        
        myLabel.font = UIFont.systemFont(ofSize: 28)
        
        let attributedStr = NSMutableAttributedString(string: "我 需 要 吗 ？")
        
        attributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 40) , range: NSMakeRange(1, 4))
        
        myLabel.attributedText = attributedStr
        
        self.addSubview(myLabel)
        
        minSeconds1 = 1.1 * Double(NSEC_PER_SEC)
        dtime1 = DispatchTime.now() + Double(Int64(minSeconds1)) / Double(NSEC_PER_SEC)
        
        //家人2
        DispatchQueue.main.asyncAfter(deadline: dtime1, execute: {
            
            let move = JNWSpringAnimation(keyPath: "transform.translation.y")
            
            move?.damping = 20
            move?.stiffness = 100
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = -110 * self.Hsize - 40
            
            myLabel.layer.add(move!, forKey: move?.keyPath)
            myLabel.transform = CGAffineTransform(translationX: 0, y: -110 * self.Hsize - 40)
            
        })
        
        
        
    }
 

}
