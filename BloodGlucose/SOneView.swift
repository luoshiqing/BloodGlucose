//
//  SOneView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/12.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SOneView: UIView {

    var names: [String]!
    
    var myLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        
        
        myLabel = UILabel(frame: rect)
        myLabel.font = UIFont.systemFont(ofSize: 13)
        myLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
        
        myLabel.textAlignment = .center
        
        if names == nil {
            myLabel.text = "嗨"
        }else{
            myLabel.text = names.last
        }
        
        self.addSubview(myLabel)
        

        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1).cgColor
        
    }
}
