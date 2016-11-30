//
//  LsqTableViewCell.swift
//  CeLa
//
//  Created by sqluo on 16/9/8.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class LsqTableViewCell: UITableViewCell {

    
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
