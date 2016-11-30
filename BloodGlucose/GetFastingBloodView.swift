//
//  GetFastingBloodView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/10.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class GetFastingBloodView: UIView {

   
    
    let mainText = "1、可以到附近的药房及诊所扎指血获得空腹血糖值\n2、无糖尿病的患者可以输入近期体检单的空腹血糖值\n3、可以到医院抽取静脉血获得空腹血糖值"
    
    
    
    override func draw(_ rect: CGRect) {
        
        
        let leftWidth: CGFloat = 22.5
        
        
        let string:NSString = self.mainText as NSString
        
        let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
        
        let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
        
        let brect = string.boundingRect(with: CGSize(width: rect.width - leftWidth * 2, height: 0), options: [options,a], attributes:  [NSFontAttributeName:UIFont(name: PF_SC, size: 15)!], context: nil)
        
        
        let textLabel = UILabel(frame: CGRect(x: leftWidth,y: 23,width: rect.width - leftWidth * 2,height: brect.height))
        
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor().rgb(68, g: 68, b: 68, alpha: 1)
        textLabel.font = UIFont(name: PF_SC, size: 15)
        
//        let attributedStr = NSMutableAttributedString(string: self.mainText)
//        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), range: NSMakeRange(13,4))
//        textLabel.attributedText = attributedStr
        
        textLabel.text = self.mainText
        
        self.addSubview(textLabel)
        
        
        
        
        
        
        
        
        
        
    }
 

}
