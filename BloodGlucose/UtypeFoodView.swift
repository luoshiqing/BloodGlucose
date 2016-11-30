//
//  UtypeFoodView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/9.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class UtypeFoodView: UIView {

    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var energyLabel: UILabel!
    
    
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var towLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    
    
    func setUtypeFoodViewDate(_ type:String,energy:String){
        self.typeLabel.text = type
        self.energyLabel.text = energy
    }
    
    
    
    
    override func draw(_ rect: CGRect) {


        
        let attributedStr = NSMutableAttributedString(string: "*一份不同类食物交换所提供的热量是相同的(90千卡)")
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.orange, range: NSMakeRange(0,1))
        oneLabel.attributedText = attributedStr

        let attributedStr2 = NSMutableAttributedString(string: "*同类食物在一定重量内所含的蛋白质、脂肪、碳水化合和热量相近")
        attributedStr2.addAttribute(NSForegroundColorAttributeName, value: UIColor.orange, range: NSMakeRange(0,1))
        towLabel.attributedText = attributedStr2
        
        let attributedStr3 = NSMutableAttributedString(string: "*不同食物不能互换，同类食物可以互换")
        attributedStr3.addAttribute(NSForegroundColorAttributeName, value: UIColor.orange, range: NSMakeRange(0,1))
        threeLabel.attributedText = attributedStr3
        
        
        
        
        
        
    }
    

}
