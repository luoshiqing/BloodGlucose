//
//  ElipseView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/12.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class ElipseView: UIView {

    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        
        context?.addEllipse(in: CGRect(x: (rect.width - 60) / 2, y: (rect.height - 20) / 2, width: 60, height: 20))
        
        
        context?.setFillColor(UIColor.clear.cgColor)
        
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
    }
 
    
    
    
    
    
    
    

}
