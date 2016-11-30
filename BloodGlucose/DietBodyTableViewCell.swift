//
//  DietBodyTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/21.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class DietBodyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var imgH: NSLayoutConstraint!
    
    @IBOutlet weak var imgW: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
