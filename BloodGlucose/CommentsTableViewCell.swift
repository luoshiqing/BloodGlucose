//
//  CommentsTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/28.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        commentLabel.sizeToFit()
        
        imgView.layer.cornerRadius = 30
        imgView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
