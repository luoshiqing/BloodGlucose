//
//  HealthCirclesTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/31.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class HealthCirclesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
