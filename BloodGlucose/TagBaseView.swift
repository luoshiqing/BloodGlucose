//
//  TagBaseView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/6.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class TagBaseView: UIView {

    //定义一个回调
    typealias TagBaseViewValueClosur = (_ tag: Int,_ send: UIButton)->Void
    
    var tagBaseViewClosur:TagBaseViewValueClosur?
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    
    var typeName:String!
    var doseName:String!
    
    
    
    
    override func draw(_ rect: CGRect) {
        
        
        bgView.layer.cornerRadius = 3
        bgView.layer.masksToBounds = true
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
        

        self.bringSubview(toFront: self.deleteBtn)
        
        
        self.deleteBtn.addTarget(self, action: #selector(TagBaseView.deleteBtnAct(_:)), for: UIControlEvents.touchUpInside)
        
        if typeName != nil && doseName != nil {
            let str = typeName + "(\(doseName))"
            
            
            let typeNameCount = typeName.characters.count
            
            let attributedStr = NSMutableAttributedString(string: str)
            attributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14) , range: NSMakeRange(0, typeNameCount))
            
            attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), range: NSMakeRange(0, typeNameCount))
            
            let doseNameCount = "(\(doseName))".characters.count
            
            attributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 11) , range: NSMakeRange(typeNameCount, doseNameCount))
            attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 72/255.0, green: 72/255.0, blue: 72/255.0, alpha: 1), range: NSMakeRange(typeNameCount, doseNameCount))
            
  
            
            nameLabel.attributedText = attributedStr
            
            
            
        }
        
        
        
    }
    
    func deleteBtnAct(_ send: UIButton){
        print(send.tag)
        self.tagBaseViewClosur?(send.tag,send)
    }
    
   

}
