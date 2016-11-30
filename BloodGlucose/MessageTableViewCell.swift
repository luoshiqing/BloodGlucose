//
//  MessageTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    //距离您上次监测已经1个月，如需再次监测请关注优医糖公众号或者拨打电话4008-059-359联系再次佩戴。
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var pointView: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.pointView.layer.cornerRadius = 3
        self.pointView.layer.masksToBounds = true
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
