//
//  MyShopView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/6.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyShopView: UIView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    @IBOutlet weak var toTopH: NSLayoutConstraint! //70
    
    override func draw(_ rect: CGRect) {
        
        let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
        
        toTopH.constant = Hsize * 70
        
    }

}
