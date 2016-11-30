//
//  MenuTableViewCell.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/2/2.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var hongdianImg: UIImageView!
    
    @IBOutlet weak var cachLabel: UILabel!
    
    
    
    
    
    @IBOutlet weak var imgH: NSLayoutConstraint!
    
    @IBOutlet weak var imgW: NSLayoutConstraint!
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
        let color = UIColor(red: 255/255.0, green: 211/255.0, blue: 194/255.0, alpha: 1)
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = color
   
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
