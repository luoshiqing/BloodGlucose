//
//  DateTableViewCell.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/7.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    
    
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
