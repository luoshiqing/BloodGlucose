//
//  EventTypeTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/17.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class EventTypeTableViewCell: UITableViewCell ,UITextFieldDelegate{

    
    @IBOutlet weak var titLabel: UILabel!
    
    @IBOutlet weak var valueTF: UITextField!
    
    
    @IBOutlet weak var rightImg: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.valueTF.isEnabled = false
        
        
        self.valueTF.delegate = self
        
        self.valueTF.returnKeyType = .done
        
        
        
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.valueTF.isEnabled = false
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
