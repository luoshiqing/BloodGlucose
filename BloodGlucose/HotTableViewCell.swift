//
//  HotTableViewCell.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/1/19.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class HotTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var shuomLabel: UILabel!
    
    @IBOutlet weak var gggLabel: UILabel!
    
    @IBOutlet weak var xinxinImgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //设置图片 圆角
        self.imgView.layer.cornerRadius = 5
        self.imgView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
