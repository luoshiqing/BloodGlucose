//
//  SeeSerialNumberView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/10.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SeeSerialNumberView: UIView {

    
    fileprivate let mainText = "在您的设备底部查找带有一连串数字编号即为您佩戴设备的设备号，将其编号与您搜索出的设备编号进行比照，选择您佩戴的设备名称相同的设备号进行连接。"
    
    
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
        
        let attributedStr = NSMutableAttributedString(string: self.mainText)
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), range: NSMakeRange(13,4))
        textLabel.attributedText = attributedStr
        
        
        
        self.addSubview(textLabel)
        
    }
 

}
