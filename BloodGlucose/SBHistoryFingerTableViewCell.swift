//
//  SBHistoryFingerTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/29.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SBHistoryFingerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fingerBloodLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
