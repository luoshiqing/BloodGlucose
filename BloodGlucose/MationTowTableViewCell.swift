//
//  MationTowTableViewCell.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/2/2.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MationTowTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
