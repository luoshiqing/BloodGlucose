//
//  StageSelectTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/9/13.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class StageSelectTableViewCell: UITableViewCell {

    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        //设置 圆角
        self.nameLabel.layer.cornerRadius = 6
        self.nameLabel.clipsToBounds = true
        //边框
        self.nameLabel.layer.borderWidth = 0.5
        self.nameLabel.layer.borderColor = UIColor().hexStringToColor("#ef3f02").cgColor
        
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
