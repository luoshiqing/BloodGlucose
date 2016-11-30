//
//  STowView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/12.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class STowView: UIView {

    
    
    var names = [String](repeating: "哦", count: 3)
    
    var topLabel: UILabel!
    var leftLabel: UILabel!
    var rightLabel: UILabel!
    
    
    override func draw(_ rect: CGRect) {
        
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1).cgColor
        
        let frame_height: CGFloat = 0.5
        
        let VxView = UIView(frame: CGRect(x: 0,y: (rect.height - frame_height) / 2,width: rect.width,height: frame_height))
        VxView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1)
        self.addSubview(VxView)
        
        let HxView = UIView(frame: CGRect(x: (rect.width - frame_height) / 2,y: rect.height / 2,width: frame_height,height: rect.height / 2))
 
        HxView.backgroundColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1)
        self.addSubview(HxView)
   
        //
        topLabel = UILabel(frame: CGRect(x: 0,y: 0,width: rect.width,height: rect.height / 2))
        topLabel.textAlignment = .center
        topLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
        topLabel.text = self.names[0]
        topLabel.font = UIFont.systemFont(ofSize: 13)
        
        self.addSubview(topLabel)
        
        
        leftLabel = UILabel(frame: CGRect(x: 0,y: rect.height / 2,width: rect.width / 2,height: rect.height / 2))
        leftLabel.textAlignment = .center
        leftLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
        leftLabel.text = self.names[1]
        leftLabel.font = UIFont.systemFont(ofSize: 13)
        
        self.addSubview(leftLabel)
        
        rightLabel = UILabel(frame: CGRect(x: rect.width / 2,y: rect.height / 2,width: rect.width / 2,height: rect.height / 2))
        rightLabel.textAlignment = .center
        rightLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
        rightLabel.text = self.names[2]
        rightLabel.font = UIFont.systemFont(ofSize: 13)
        
        self.addSubview(rightLabel)
        
        
    }
 

}
