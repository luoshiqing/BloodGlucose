//
//  PracticeTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/29.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class PracticeTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var practiceLabel: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        practiceLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
