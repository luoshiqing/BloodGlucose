//
//  PushView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/8.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class PushView: UIView {

    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textLabel: UITextView!
    
    
    
    
    
   
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.textColor = UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
        
        
        
    }
    

}
