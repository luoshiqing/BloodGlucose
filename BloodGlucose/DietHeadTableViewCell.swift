//
//  DietHeadTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/21.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class DietHeadTableViewCell: UITableViewCell {

    
    fileprivate let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64) //高度比例
    
    @IBOutlet weak var topImgH: NSLayoutConstraint!     //100
    
    @IBOutlet weak var roundImgH: NSLayoutConstraint!   //85
    
    @IBOutlet weak var roundImgW: NSLayoutConstraint!   //85
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        topImgH.constant = Hsize * 100
        roundImgH.constant = Hsize * 85
        roundImgW.constant = Hsize * 85
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
