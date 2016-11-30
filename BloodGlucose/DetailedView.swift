//
//  DetailedView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/7.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit




class DetailedView: UIView {
    


    @IBOutlet weak var detTextView: UITextView!
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    func initSetup(){
        
        
        //布局
        
    }
    
   
    

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
