//
//  BorderView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/16.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class BorderView: UIView {

    
    
    fileprivate var showTop = true
    fileprivate var showRight = true
    fileprivate var showDown = true
    fileprivate var showLeft = true
    
    fileprivate var myTitle: String?
    
    var lineColor = UIColor().rgb(151, g: 151, b: 151, alpha: 1)
 
    var lineWidth: CGFloat = 0.5
    
    
    var label: UILabel?
    
    func initBordeView(_ showTop: Bool ,showRight: Bool ,showDown: Bool ,showLeft: Bool,title: String?){
        
        self.showTop = showTop
        self.showRight = showRight
        self.showDown = showDown
        self.showLeft = showLeft
        
        self.myTitle = title

    }
    
    
    override func draw(_ rect: CGRect) {
        
        if self.showTop {
            let vie = UIView(frame: CGRect(x: 0,y: 0,width: rect.width,height: lineWidth))
            vie.backgroundColor = self.lineColor
            self.addSubview(vie)
        }
        
        if self.showRight {
            let vie = UIView(frame: CGRect(x: rect.width - lineWidth,y: 0,width: lineWidth,height: rect.height))
            vie.backgroundColor = self.lineColor
            self.addSubview(vie)
        }
        if self.showDown {
            let vie = UIView(frame: CGRect(x: 0,y: rect.height - lineWidth,width: rect.width,height: lineWidth))
            vie.backgroundColor = self.lineColor
            self.addSubview(vie)
        }
        if self.showLeft {
            let vie = UIView(frame: CGRect(x: 0,y: 0,width: lineWidth,height: rect.height))
            vie.backgroundColor = self.lineColor
            self.addSubview(vie)
        }
        
        
        label = UILabel(frame: CGRect(x: lineWidth,y: lineWidth,width: rect.width - lineWidth ,height: rect.height - lineWidth * 2))
        label?.backgroundColor = UIColor.clear
        
        label?.textAlignment = .center
        if let tit = self.myTitle {
            label?.text = tit
        }
        
        
        label?.textColor = UIColor().rgb(85, g: 85, b: 85, alpha: 1)

        label?.font = UIFont(name: PF_SC, size: 11)
        self.addSubview(label!)
        
        
    }
    
    
    
    
    
    
    
    
    
    

}
