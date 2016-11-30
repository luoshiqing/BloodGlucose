//
//  IsHeadView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/15.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class IsHeadView: UIView {

    
    
    @IBOutlet weak var addInforBtn: UIButton!
    
    
   
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    func initSetup(){
        
        //设置 圆角
        self.addInforBtn.layer.cornerRadius = 33 / 2.0
        self.addInforBtn.clipsToBounds = true
        
        
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
