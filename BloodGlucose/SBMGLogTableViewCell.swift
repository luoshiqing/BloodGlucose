//
//  SBMGLogTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/4.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SBMGLogTableViewCell: UITableViewCell {

    
    
    
    @IBOutlet weak var upLineVeiw: UIView!
    
    
    @IBOutlet weak var downLineView: UIView!
    
    
    @IBOutlet weak var pointView: UIView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        pointView.layer.cornerRadius = 6
        pointView.layer.masksToBounds = true
        
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
