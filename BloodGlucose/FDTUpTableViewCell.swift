//
//  FDTUpTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/27.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class FDTUpTableViewCell: UITableViewCell {

    typealias FdtupCellClourse = (_ send: UITapGestureRecognizer)->Void
    var fdtupCellClourse:FdtupCellClourse?
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var tagOneLabel: UILabel!

    @IBOutlet weak var tagTowLabel: UILabel!
    
    @IBOutlet weak var tagThreeLabel: UILabel!
    
    @IBOutlet weak var tagFourLabel: UILabel!
    
 
    
    var tagArray = [UILabel]()
    
    
    
    
    
    
    @IBOutlet weak var oneW: NSLayoutConstraint!//60
    
    @IBOutlet weak var towW: NSLayoutConstraint!
    
    @IBOutlet weak var threeW: NSLayoutConstraint!
    
    @IBOutlet weak var fourW: NSLayoutConstraint!
    
    @IBOutlet weak var oneTowW: NSLayoutConstraint!//17
    
    @IBOutlet weak var towThreeW: NSLayoutConstraint!//18
    
    @IBOutlet weak var threeFourW: NSLayoutConstraint!//17
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.reviewLabel.sizeToFit()
        
        
        self.tagOneLabel.isHidden = true
        self.tagTowLabel.isHidden = true
        self.tagThreeLabel.isHidden = true
        self.tagFourLabel.isHidden = true
        
        self.tagArray.append(tagOneLabel)
        self.tagArray.append(tagTowLabel)
        self.tagArray.append(tagThreeLabel)
        self.tagArray.append(tagFourLabel)
        
        
        self.tagOneLabel.layer.cornerRadius = 2
        self.tagOneLabel.layer.masksToBounds = true
        self.tagOneLabel.layer.borderWidth = 0.5
        self.tagOneLabel.layer.borderColor = UIColor(red: 85/255.0, green: 187/255.0, blue: 36/255.0, alpha: 1).cgColor
        
        self.tagTowLabel.layer.cornerRadius = 2
        self.tagTowLabel.layer.masksToBounds = true
        self.tagTowLabel.layer.borderWidth = 0.5
        self.tagTowLabel.layer.borderColor = UIColor(red: 36/255.0, green: 187/255.0, blue: 174/255.0, alpha: 1).cgColor
        
        self.tagThreeLabel.layer.cornerRadius = 2
        self.tagThreeLabel.layer.masksToBounds = true
        self.tagThreeLabel.layer.borderWidth = 0.5
        self.tagThreeLabel.layer.borderColor = UIColor(red: 36/255.0, green: 68/255.0, blue: 187/255.0, alpha: 1).cgColor
        
        self.tagFourLabel.layer.cornerRadius = 2
        self.tagFourLabel.layer.masksToBounds = true
        self.tagFourLabel.layer.borderWidth = 0.5
        self.tagFourLabel.layer.borderColor = UIColor(red: 20/255.0, green: 113/255.0, blue: 86/255.0, alpha: 1).cgColor
        
 
        let Wsize = (UIScreen.main.bounds.width - 14 * 2) / (320 - 14 * 2)
        
        oneW.constant = Wsize * 60
        towW.constant = Wsize * 60
        threeW.constant = Wsize * 60
        fourW.constant = Wsize * 60
        
        oneTowW.constant = Wsize * 17
        towThreeW.constant = Wsize * 18
        threeFourW.constant = Wsize * 17
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
