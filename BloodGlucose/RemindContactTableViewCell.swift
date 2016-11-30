//
//  RemindContactTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class RemindContactTableViewCell: UITableViewCell ,UITextFieldDelegate{

    
    
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var valueTF: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        
//        let color = UIColor(red: 255/255.0, green: 241/255.0, blue: 235/255.0, alpha: 1)
//        self.selectedBackgroundView = UIView(frame: self.frame)
//        self.selectedBackgroundView?.backgroundColor = color
        
        
        self.valueTF.isEnabled = false
        
        self.valueTF.delegate = self
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.valueTF.resignFirstResponder()
        
        
        
        return true
        
    }
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
