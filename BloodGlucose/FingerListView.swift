//
//  FingerListView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/3/30.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class FingerListView: UIView {

    
    @IBOutlet weak var addBloodBtn: UIButton!
    
    @IBOutlet weak var bloodTabView: UITableView!
    
    
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var canceBtn: UIButton!
    
    
    
    @IBOutlet weak var saveW: NSLayoutConstraint!//120

    
    @IBOutlet weak var canceW: NSLayoutConstraint!//121
    
    @IBOutlet weak var BtnViewW: NSLayoutConstraint!//244
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        //布局
        self.initSetup()
//        self.setLayOut()
    }
    
    func setLayOut(){
        let Wsize = UIScreen.main.bounds.width / 320
        saveW.constant = Wsize * 120
        canceW.constant = Wsize * 121
    }
    
    
    func initSetup(){
        
        

        
        
        //设置btnView 圆角
        btnView.layer.cornerRadius = 5
        btnView.clipsToBounds = true
        
        //设置半边圆角
        let maskPath = UIBezierPath(roundedRect: saveBtn.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.topLeft], cornerRadii: CGSize(width: 5, height: 5))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = saveBtn.bounds
        
        maskLayer.path = maskPath.cgPath
        
        saveBtn.layer.mask = maskLayer
        
        let maskPath1 = UIBezierPath(roundedRect: canceBtn.bounds, byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        
        let maskLayer1 = CAShapeLayer()
        
        maskLayer1.frame = canceBtn.bounds
        
        maskLayer1.path = maskPath1.cgPath
        
        canceBtn.layer.mask = maskLayer1
        

        
    }
    
    
    
  

}
