//
//  RemindSetTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/25.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class RemindSetTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    
    
    @IBOutlet weak var mySeparatorView: UIView!
    @IBOutlet weak var xiantiaoH: NSLayoutConstraint!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        xiantiaoH.constant = 0.5
        
        
        
        let color = UIColor(red: 255/255.0, green: 241/255.0, blue: 235/255.0, alpha: 1)
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = color
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
