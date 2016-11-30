//
//  EndRiskTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/23.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class EndRiskTableViewCell: UITableViewCell {

    typealias EndRiskTableViewCellViewActClourse = (_ tag: Int,_ type: RiskType,_ cell: EndRiskTableViewCell)->Void
    var viewActClourse: EndRiskTableViewCellViewActClourse?
    
    let Hsize = (UIScreen.main.bounds.height - 64) / (667 - 64)
    
    let viewTypeArray:[RiskType] = [RiskType.sex,
                                    RiskType.birth,
                                    RiskType.height,
                                    RiskType.weight,
                                    RiskType.waist,
                                    RiskType.shrinkage,
                                    RiskType.family,
                                    RiskType.blood]
    
    
    @IBOutlet weak var circularView: UIView!
    
    @IBOutlet weak var cirH: NSLayoutConstraint!//38

    @IBOutlet weak var cirW: NSLayoutConstraint!//38
    
    
    @IBOutlet weak var cirRightView: UIView!
    
    
    @IBOutlet weak var cirRW: NSLayoutConstraint!
    @IBOutlet weak var cirRH: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var leftTouchView: UIView!
    @IBOutlet weak var rightTouchView: UIView!
    
    
    @IBOutlet weak var leftImgView: UIImageView!
    
    @IBOutlet weak var leftTitleLabel: UILabel!
    
    @IBOutlet weak var leftValueLabel: UILabel!
    
    @IBOutlet weak var rightImgView: UIImageView!
    
    @IBOutlet weak var rightTitleLabel: UILabel!
    
    @IBOutlet weak var rightValueLabel: UILabel!
    
    
    @IBOutlet weak var leftImgH: NSLayoutConstraint!
    @IBOutlet weak var leftImgW: NSLayoutConstraint!
    
    @IBOutlet weak var rightImgW: NSLayoutConstraint!
    @IBOutlet weak var rightImgH: NSLayoutConstraint!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cirH.constant = 38 * Hsize
        cirW.constant = 38 * Hsize
        
        cirRH.constant = 38 * Hsize
        cirRW.constant = 38 * Hsize
    

        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(EndRiskTableViewCell.someViewAct(_:)))
        self.leftTouchView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(EndRiskTableViewCell.someViewAct(_:)))
        self.rightTouchView.addGestureRecognizer(tap2)
        
        
        
    }
    
    
    
    
    func someViewAct(_ send: UITapGestureRecognizer){

        let cell = send.view?.superview?.superview as! EndRiskTableViewCell
 
        self.viewActClourse?(send.view!.tag,self.viewTypeArray[send.view!.tag],cell)
        
    }
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
