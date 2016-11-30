//
//  HealthDTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/15.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class HealthDTableViewCell: UITableViewCell ,UITextFieldDelegate{

    typealias HealthDTableViewCellTextClourse = (_ text: String)->Void
    var textClourse: HealthDTableViewCellTextClourse?
    
    @IBOutlet weak var titLabel: UILabel!
    
    @IBOutlet weak var valueTextF: UITextField!
 
    @IBOutlet weak var sepH: NSLayoutConstraint!
    
    @IBOutlet weak var sepView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        sepH.constant = 0.5
 
        self.valueTextF.delegate = self
        
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isEnabled = false
        
        self.textClourse?(textField.text!)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
