//
//  BloodListTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/3/30.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class BloodListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bloodNumLabel: UILabel!
    
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
