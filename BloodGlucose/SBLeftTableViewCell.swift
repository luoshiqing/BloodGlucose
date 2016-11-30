//
//  SBLeftTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/21.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SBLeftTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        
        
        let color = UIColor(red: 255/255.0, green: 211/255.0, blue: 194/255.0, alpha: 1)
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = color
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
