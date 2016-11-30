//
//  UattentionView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/9.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class UattentionView: UIView {

    
    
    @IBOutlet weak var foodTextView: UITextView!
    
    
    
    
    func setUattentionViewDate(_ food:String){
        self.foodTextView.text = food
    }
    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
