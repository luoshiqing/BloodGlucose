//
//  DSNameTableViewCell.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/1/28.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class DSNameTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var inforTF: UITextField!
    
    
    @IBOutlet weak var testBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
