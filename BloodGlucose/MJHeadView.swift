//
//  MJHeadView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/6.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MJHeadView: UIView {

    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    var WJHomeCtr:UIViewController!
 
    @IBOutlet weak var riskView: UIView!
    
    
    @IBOutlet weak var allActTimeLabel: UILabel!
    
    
    @IBOutlet weak var allActNumLabel: UILabel!
    
    
    @IBOutlet weak var avgTimeLabel: UILabel!
    
    @IBOutlet weak var healthLevelLabel: UILabel!
    
    
    @IBOutlet weak var rsikBtn: UIButton!
    
    
    
    
    @IBOutlet weak var leftW: NSLayoutConstraint!//124
    
    
    @IBOutlet weak var midW: NSLayoutConstraint!//125
    
    @IBOutlet weak var rightW: NSLayoutConstraint!//124
    
    
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        self.rsikBtn.isUserInteractionEnabled = false
        
        //设置布局
        
        self.setLayOut()
        
        //
        let tap = UITapGestureRecognizer(target: self, action: #selector(MJHeadView.someViewAct(_:)))
        riskView.addGestureRecognizer(tap)
        
        //设置半边圆角
        let maskPath = UIBezierPath(roundedRect: riskView.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.topLeft], cornerRadii: CGSize(width: 4, height: 4))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = riskView.bounds
        
        maskLayer.path = maskPath.cgPath
        
        riskView.layer.mask = maskLayer
        
        
        
        //赋值
        
        //健康等级
        var healthValue = "0%"
        
        switch jiancheTime {
        case 0:
            healthValue = "0%"
        case 0..<72:
            healthValue = "25%"
        case 72..<360:
            healthValue = "50%"
        case 360..<3600:
            healthValue = "75%"
        default:
            healthValue = "100%"
        }
        
        healthLevelLabel.text = healthValue
        
        
        allActNumLabel.text = "\(jiancheNum)次"
        
        
        let avgTime = String(format: "%.1f", pingjunTime)
  
        
        
        
        avgTimeLabel.text = "\(avgTime)天"
        
        
        
        let typeName = "\(jiancheTime)"
        
        
        let dd = "小时"
        
        let str: String = typeName + dd
        
        
        
        let typeNameCount = typeName.characters.count
        
        let attributedStr = NSMutableAttributedString(string: str)
        
        attributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 60) , range: NSMakeRange(0, typeNameCount))
        
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, typeNameCount))
        
        let doseNameCount = dd.characters.count
        
        attributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17) , range: NSMakeRange(typeNameCount, doseNameCount))
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(typeNameCount, doseNameCount))

        allActTimeLabel.attributedText = attributedStr
        
        
    }
    
    
    func setLayOut(){
        
        let Wsize = (UIScreen.main.bounds.width - 2) / (375 - 2)
        
        leftW.constant = 124 * Wsize
        midW.constant = 125 * Wsize
        rightW.constant = 124 * Wsize
        
    }
    
    
    func someViewAct(_ send: UITapGestureRecognizer){
        print("风险评估")

        
        let endRiskVC = EndRiskViewController()
        
        self.WJHomeCtr.navigationController?.pushViewController(endRiskVC, animated: true)
        
        
        
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
