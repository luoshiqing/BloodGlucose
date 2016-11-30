//
//  PregnancyTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/19.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class PregnancyTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
