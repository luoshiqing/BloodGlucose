//
//  ThreeView.swift
//  JNWAN
//
//  Created by sqluo on 16/5/5.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class ThreeView: UIView {

    
    
    
    var Hsize:CGFloat!
    var Wsize:CGFloat!
    
    var ThreeSize:CGSize!
    

    override func draw(_ rect: CGRect) {
        // Drawing code
        
        ThreeSize = self.frame.size
        Hsize = UIScreen.main.bounds.height / 568
        Wsize = UIScreen.main.bounds.width / 320
        
        
        //用药，情绪
        let fourImgView = UIImageView(frame: CGRect(x: 10 * self.Wsize, y: 20 * self.Hsize, width: 160 * self.Wsize, height: 165 * self.Wsize))
        fourImgView.image = UIImage(named: "tFour")
        
        fourImgView.transform = CGAffineTransform(scaleX: 0.01,y: 0.01)
        
        self.addSubview(fourImgView)
        
        
        var minSeconds = 0.1 * Double(NSEC_PER_SEC)
        var dtime = DispatchTime.now() + Double(Int64(minSeconds)) / Double(NSEC_PER_SEC)
        
        //用药，情绪
        DispatchQueue.main.asyncAfter(deadline: dtime, execute: {
           
//            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                
//                fourImgView.transform = CGAffineTransformMakeScale(1,1)
//                
//                }, completion: nil)
            
            
            let scale = JNWSpringAnimation(keyPath: "transform.scale")
            
            scale?.damping = 15
            scale?.stiffness = 100
            scale?.mass = 2
            
            scale?.fromValue = 0.01
            scale?.toValue = 1.0
            
            fourImgView.layer.add(scale!, forKey: scale?.keyPath)
            fourImgView.transform = CGAffineTransform(scaleX: 1,y: 1)
  
            
            let rotation = JNWSpringAnimation(keyPath: "transform.rotation")
            
            rotation?.damping = 15
            rotation?.stiffness = 30
            rotation?.mass = 2
            
            rotation?.fromValue = 0
            rotation?.toValue = 2 * M_PI
            
            fourImgView.layer.add(rotation!, forKey: rotation?.keyPath)
            fourImgView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2))
            
            
        })
        
        
        //个性化
//        let label1 = UILabel(frame: CGRectMake((10 + 160 + 10) * self.Wsize,80 * self.Hsize,ThreeSize.width - 180 * self.Wsize,25))
        let label1 = UILabel(frame: CGRect(x: self.ThreeSize.width,y: 80 * self.Hsize,width: ThreeSize.width - 180 * self.Wsize,height: 25))

        label1.textAlignment = .center
        label1.textColor = UIColor(red: 73/255.0, green: 149/255.0, blue: 204/255.0, alpha: 1)
        label1.text = "个性化"
        label1.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(label1)
        
        let label2 = UILabel(frame: CGRect(x: self.ThreeSize.width,y: 80 * self.Hsize + 30,width: self.ThreeSize.width - 180 * self.Wsize,height: 25))

        label2.textAlignment = .center
        label2.textColor = UIColor(red: 73/255.0, green: 149/255.0, blue: 204/255.0, alpha: 1)
        
        let attributedStr = NSMutableAttributedString(string: "健康指导建议")
        attributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 22) , range: NSMakeRange(0, 4))
        label2.attributedText = attributedStr
 
        self.addSubview(label2)
        

        
        minSeconds = 0.3 * Double(NSEC_PER_SEC)
        dtime = DispatchTime.now() + Double(Int64(minSeconds)) / Double(NSEC_PER_SEC)
        
        //用药，情绪
        DispatchQueue.main.asyncAfter(deadline: dtime, execute: {
            
            let move = JNWSpringAnimation(keyPath: "transform.translation.x")
            
            move?.damping = 15
            move?.stiffness = 50
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = -(self.ThreeSize.width - 180 * self.Wsize)
            
            label1.layer.add(move!, forKey: move?.keyPath)
            label1.transform = CGAffineTransform(translationX: -(self.ThreeSize.width - 180 * self.Wsize), y: 0)
            
            
            label2.layer.add(move!, forKey: move?.keyPath)
            label2.transform = CGAffineTransform(translationX: -(self.ThreeSize.width - 180 * self.Wsize), y: 0)
            
            
            
            
            
        })
        
        //手机
        minSeconds = 0.5 * Double(NSEC_PER_SEC)
        dtime = DispatchTime.now() + Double(Int64(minSeconds)) / Double(NSEC_PER_SEC)
        
        
        let tPhoneImgView = UIImageView(frame: CGRect(x: (self.ThreeSize.width - 124 * self.Wsize) - 25, y: 200 * self.Hsize, width: 124 * self.Wsize, height: 260 * self.Wsize))
        tPhoneImgView.image = UIImage(named: "tPhone")
        
        tPhoneImgView.transform = CGAffineTransform(scaleX: 0.01,y: 0.01)
        
        self.addSubview(tPhoneImgView)
        
        DispatchQueue.main.asyncAfter(deadline: dtime, execute: {

            
            let scale = JNWSpringAnimation(keyPath: "transform.scale")
            
            scale?.damping = 20
            scale?.stiffness = 100
            scale?.mass = 2
            
            scale?.fromValue = 0.01
            scale?.toValue = 1.0
            
            tPhoneImgView.layer.add(scale!, forKey: scale?.keyPath)
            tPhoneImgView.transform = CGAffineTransform(scaleX: 1,y: 1)
        })
        
        //手机实时观看
        let phoneLabel1 = UILabel(frame: CGRect(x: -((self.ThreeSize.width - 130 * self.Wsize) - 25),y: (200 + 90) * self.Hsize,width: (self.ThreeSize.width - 130 * self.Wsize) - 25,height: 30))
    
//        phoneLabel1.backgroundColor = UIColor.redColor()
        phoneLabel1.textAlignment = .center
        phoneLabel1.textColor = UIColor.orange
        phoneLabel1.text = "手机实时观看"
        phoneLabel1.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(phoneLabel1)
        
        
        let phoneLabel2 = UILabel(frame: CGRect(x: -((self.ThreeSize.width - 130 * self.Wsize) - 25),y: (200 + 90 + 30 + 10) * self.Hsize,width: (self.ThreeSize.width - 130 * self.Wsize) - 25,height: 30))
        
//        phoneLabel2.backgroundColor = UIColor.redColor()
        phoneLabel2.textAlignment = .center
        phoneLabel2.textColor = UIColor.orange
        phoneLabel2.text = "血 糖 变 化"
        phoneLabel2.font = UIFont.systemFont(ofSize: 30)
        self.addSubview(phoneLabel2)
        
        minSeconds = 0.7 * Double(NSEC_PER_SEC)
        dtime = DispatchTime.now() + Double(Int64(minSeconds)) / Double(NSEC_PER_SEC)
        
        //手机实时观看
        DispatchQueue.main.asyncAfter(deadline: dtime, execute: {
            
            let move = JNWSpringAnimation(keyPath: "transform.translation.x")
            
            move?.damping = 15
            move?.stiffness = 50
            move?.mass = 2
            
            move?.fromValue = 0
            move?.toValue = (self.ThreeSize.width - 130 * self.Wsize) - 25
            
            phoneLabel1.layer.add(move!, forKey: move?.keyPath)
            phoneLabel1.transform = CGAffineTransform(translationX: (self.ThreeSize.width - 130 * self.Wsize) - 25, y: 0)
            
            
            phoneLabel2.layer.add(move!, forKey: move?.keyPath)
            phoneLabel2.transform = CGAffineTransform(translationX: (self.ThreeSize.width - 130 * self.Wsize) - 25, y: 0)
            
            
            
            
            
        })
        
        
        
    }
 

}
