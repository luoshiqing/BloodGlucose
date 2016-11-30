//
//  SubCollectionViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/7.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SubCollectionViewCell: UICollectionViewCell {

    
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contLabel: UILabel!
    
    
    @IBOutlet weak var trueImgView: UIImageView!
    
    
    
    @IBOutlet weak var bgView: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //设置圆角
        bgView.layer.cornerRadius = 2
        bgView.clipsToBounds = true
        
        
        
    }

}
