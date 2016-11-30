//
//  WellSnowView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class WellSnowView: UIView {

    
    @IBOutlet weak var imgW: NSLayoutConstraint!//200
    @IBOutlet weak var imgH: NSLayoutConstraint!
    @IBOutlet weak var imgToTopH: NSLayoutConstraint!//27
    @IBOutlet weak var labelH: NSLayoutConstraint!//54
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    
     var imgArray = ["caidai1","caidai2","caidai3","caidai4","caidai5","caidai6"]
    
    
    func initSetup(){
        
        //布局
        self.setLayOut()
        
        //下雪动画
        self.snowAnimation()
    }
    
    func snowAnimation(){
        
        let rect = CGRect(x: 0.0, y: -80.0, width: self.bounds.width,
                          height: 50.0)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        self.layer.addSublayer(emitter)
        emitter.emitterShape = kCAEmitterLayerRectangle
        
        emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
        emitter.emitterSize = rect.size
        
        var aabb = [CAEmitterCell]()
        
        
        for item in 0...imgArray.count - 1 {
            
            let emitterCell = CAEmitterCell()
            emitterCell.contents = UIImage(named: self.imgArray[item])!.scaleImageToWidth(30).cgImage
            emitterCell.birthRate = Float(BGNetwork().randomInRange(5...8))  //每秒产生120个粒子
            emitterCell.lifetime = Float(BGNetwork().randomInRange(2...3))    //存活1秒
            emitterCell.lifetimeRange = 10
            
            
            aabb.append(emitterCell)
            
            emitterCell.yAcceleration = CGFloat(BGNetwork().randomInRange(30...45))  //给Y方向一个加速度
            emitterCell.xAcceleration = 1.0 //x方向一个加速度
            emitterCell.velocity = CGFloat(BGNetwork().randomInRange(10...15)) //初始速度
            //            emitterCell.emissionLongitude = CGFloat(-M_PI) //向左
            
            emitterCell.emissionLongitude = CGFloat(0) //向左
            
            
            emitterCell.velocityRange = 200.0   //随机速度 -200+20 --- 200+20
            emitterCell.emissionRange = CGFloat(M_PI_2) //随机方向 -pi/2 --- pi/2
            
            emitterCell.scale = 0.8
            emitterCell.scaleRange = 0.8  //0 - 1.6
            emitterCell.scaleSpeed = -0.11  //逐渐变小
            
            emitterCell.alphaRange = 0.85   //随机透明度
            emitterCell.alphaSpeed = -0.15  //逐渐消失
            
        }
        
        emitter.emitterCells = aabb
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func setLayOut(){
        let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
        self.imgW.constant = Hsize * 200
        self.imgH.constant = Hsize * 200
        self.imgToTopH.constant = Hsize * 27
        self.labelH.constant = Hsize * 54
  
    }
    
    
 

}
