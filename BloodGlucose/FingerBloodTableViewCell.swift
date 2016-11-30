//
//  FingerBloodTableViewCell.swift
//  BloodGlucoseHospital
//
//  Created by nash_su on 7/28/15.
//  Copyright (c) 2015 Sqluo. All rights reserved.
//

import UIKit

class FingerBloodTableViewCell: UITableViewCell {

    @IBOutlet weak var fingerBloodLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
