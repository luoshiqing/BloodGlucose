//
//  DayHisetoryTableViewCell.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/25.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class DayHisetoryTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var bloodLabel: UILabel!
    @IBOutlet weak var elecLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var sortW: NSLayoutConstraint!
    @IBOutlet weak var sortToLeftW: NSLayoutConstraint!
    @IBOutlet weak var bloodToLeftW: NSLayoutConstraint!
    @IBOutlet weak var bloodW: NSLayoutConstraint!
    @IBOutlet weak var elecToLeftW: NSLayoutConstraint!
    @IBOutlet weak var elecW: NSLayoutConstraint!
    
    @IBOutlet weak var timeToLeft: NSLayoutConstraint!
    @IBOutlet weak var timeToRight: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let Wsize = UIScreen.main.bounds.width / 320
        
        sortW.constant = Wsize * 50
        sortToLeftW.constant = Wsize * 24
        bloodToLeftW.constant = Wsize * 24
        bloodW.constant = Wsize * 50
        
        elecToLeftW.constant = Wsize * 10
        elecW.constant = Wsize * 50
        
        timeToLeft.constant = Wsize * 5
        timeToRight.constant = Wsize * 0
        
        
        
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
