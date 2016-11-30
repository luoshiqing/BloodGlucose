//
//  SThreeView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/12.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SThreeView: UIView {

    
    var leftLabel: UILabel!
    var rightLabel: UILabel!
    
    var names = [String](repeating: "哦", count: 2)
    
    override func draw(_ rect: CGRect) {
        
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1).cgColor
        
        let frame_height: CGFloat = 0.5
        
        let HxView = UIView(frame: CGRect(x: (rect.width - frame_height) / 2,y: 0,width: frame_height,height: rect.height))
        
        HxView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1)
        self.addSubview(HxView)
        
        //
        
        leftLabel = UILabel(frame: CGRect(x: 0,y: 0,width: rect.width / 2,height: rect.height))
        leftLabel.textAlignment = .center
        leftLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
        leftLabel.text = self.names[0]
        leftLabel.font = UIFont.systemFont(ofSize: 12)
        
        self.addSubview(leftLabel)
        
        rightLabel = UILabel(frame: CGRect(x: rect.width / 2,y: 0,width: rect.width / 2,height: rect.height ))
        rightLabel.textAlignment = .center
        rightLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
        rightLabel.text = self.names[1]
        rightLabel.font = UIFont.systemFont(ofSize: 12)
        
        self.addSubview(rightLabel)
        
        
        
    }
 

}
