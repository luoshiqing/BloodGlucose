//
//  FoodTypeView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/13.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class FoodTypeView: UIView {

    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var energyLabel: UILabel!
    
    
    @IBOutlet weak var oneToLeftW: NSLayoutConstraint!//71
    @IBOutlet weak var oneW: NSLayoutConstraint!//91
    
    @IBOutlet weak var towToRihgtW: NSLayoutConstraint!//72
    @IBOutlet weak var towW: NSLayoutConstraint!//40
    
    @IBOutlet weak var threeToLeftW: NSLayoutConstraint!//100
    @IBOutlet weak var threeW: NSLayoutConstraint!//26
    
    @IBOutlet weak var fourToRightW: NSLayoutConstraint!//99
    @IBOutlet weak var fourW: NSLayoutConstraint!//35
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    func initSetup(){
        let Hsize = UIScreen.main.bounds.width / 320
        
        self.oneToLeftW.constant = Hsize * 71
        self.oneW.constant = Hsize * 91
        
        self.towToRihgtW.constant = Hsize * 72
        self.towW.constant = Hsize * 40
        
        self.threeToLeftW.constant = Hsize * 100
        self.threeW.constant = Hsize * 26
        
        self.fourToRightW.constant = Hsize * 99
        self.fourW.constant = Hsize * 35
        
        
    }

}
