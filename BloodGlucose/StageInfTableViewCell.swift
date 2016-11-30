//
//  StageInfTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/18.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class StageInfTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    

    @IBOutlet weak var valueLabel: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
