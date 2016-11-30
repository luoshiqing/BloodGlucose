//
//  NewEventTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/24.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class NewEventTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bigImgView: UIImageView!
    
    
    @IBOutlet weak var infLabel: UILabel!
    
    
    @IBOutlet weak var typeImgView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var timeImgView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var feelImgView: UIImageView!
    @IBOutlet weak var feelLabel: UILabel!
    
    
    @IBOutlet weak var rightArrowImgView: UIImageView!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //设置label 圆角
        bigImgView.layer.cornerRadius = 5
        bigImgView.clipsToBounds = true
        
        
        
        
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
