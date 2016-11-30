//
//  DownStepsView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/20.
//  Copyright © 2016年 nash_su. All rights reserved.
//


//----底部步骤视图

import UIKit

class DownStepsView: UIView {

    
    
    var stepNmaeArray = ["第一步 “打开蓝牙”",
                         "第二步 “设备连接”",
                         "第三步 “初始化”",
                         "第四步 “极化”",
                         "第五步 “开始监测”"]
    
    var detailedArray = ["因设备是通过蓝牙与APP进行连接，所以不要忘记打开蓝牙哦~~",
                         "进入监测页面，扫描到要监测的监测设备，连接自己的设备编码",
                         "初始化需要7分钟，7分钟内无需进行任何操作，只需等待设备进入极化。",
                         "极化3分钟以后会出现第一个电流值，点击右上角观看电流值，如果电流值正常（电流值不低于10000），则无需特殊处理，极化是探针与人体反应的稳定时间，总时间为3小时，期间无需进行任何操作。",
                         "极化完成，建议您在第二天输入空腹指血查看您的血糖变化曲线。"]
    
    
    var stepsInt = 1
    
    
    
    var stepNameLabel: UILabel!
    var detailLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        /*
        //线条
        let y: CGFloat = 28
        let x: CGFloat = 19
        
        let xtView = UIView(frame: CGRectMake(x,y,rect.width - x * 2,1))
        xtView.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.addSubview(xtView)
        
        
        //步骤标题
        let b_y = y + 14
        let b_h: CGFloat = 16
        
        self.stepNameLabel = UILabel(frame: CGRectMake(x,b_y,rect.width - x * 2,b_h))
        
        let tmpText = self.stepNmaeArray[self.stepsInt - 1]

        let str = tmpText

        let typeNameCount = 5
        
        let attributedStr = NSMutableAttributedString(string: str)
        attributedStr.addAttribute(NSFontAttributeName, value: UIFont(name: PF_SC, size: 16)! , range: NSMakeRange(0, typeNameCount))
        
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1), range: NSMakeRange(0, typeNameCount))
        
        let doseNameCount = str.characters.count - typeNameCount
        
        attributedStr.addAttribute(NSFontAttributeName, value: UIFont(name: PF_SC, size: 16)! , range: NSMakeRange(typeNameCount, doseNameCount))
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), range: NSMakeRange(typeNameCount, doseNameCount - 1))

        self.stepNameLabel.attributedText = attributedStr

        self.addSubview(self.stepNameLabel)
        
        
        
        //详细
        let d_y = b_y + b_h + 12
        
        let d_h = rect.height - d_y

        self.detailLabel = UILabel(frame: CGRectMake(x,d_y,rect.width - x * 2,d_h))
       
        let detailText = self.detailedArray[self.stepsInt - 1]
        
  
        
        self.detailLabel.text = detailText
        
        self.detailLabel.numberOfLines = 0
        
        self.detailLabel.textColor = UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1)
        
        self.detailLabel.font = UIFont(name: PF_SC, size: 15)
        
//        self.detailLabel.backgroundColor = UIColor.yellowColor()
        
        let string:NSString = detailText
        
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        
        let a:NSStringDrawingOptions = NSStringDrawingOptions.UsesFontLeading
        
        let brect = string.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width - 28, 0), options: [options,a], attributes:  [NSFontAttributeName:(self.detailLabel.font)!], context: nil)
        
        self.detailLabel.frame = CGRectMake(x,d_y,rect.width - x * 2,brect.height)
        
        
        
        
        
        self.addSubview(self.detailLabel)
        
        
        
        
        */
 
    }
 

}
