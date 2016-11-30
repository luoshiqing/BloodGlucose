//
//  SBRTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/18.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SBRTableViewCell: UITableViewCell {

    @IBOutlet weak var sepH: NSLayoutConstraint!
    
    @IBOutlet weak var titleTimeLabel: UILabel!
    
    @IBOutlet weak var bloodLabel: UILabel!
    
    @IBOutlet weak var sepView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

        sepH.constant = 0.5
    
    
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
