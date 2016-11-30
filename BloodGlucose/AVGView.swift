//
//  AVGView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/14.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class AVGView: UIView {

    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var numLabel: UILabel!
    
    
    @IBOutlet weak var superView: UIView!
    
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var subViewW: NSLayoutConstraint!
    
    @IBOutlet weak var shuxianView: UIView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var sanjiaoImgView: UIImageView!
    
    @IBOutlet weak var midLabel: UILabel!
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    func initSetup(){
        //设置圆角
//        imgView.layer.cornerRadius = 14.5
//        imgView.clipsToBounds = true
        
        
    }

}
