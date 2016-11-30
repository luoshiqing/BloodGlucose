//
//  InfSection1TableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/31.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class InfSection1TableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        //设置 圆角
        imgView.layer.cornerRadius = 75.0 / 2.0
        imgView.clipsToBounds = true
        
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
