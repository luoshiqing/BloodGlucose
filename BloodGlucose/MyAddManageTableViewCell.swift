//
//  MyAddManageTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyAddManageTableViewCell: UITableViewCell ,UITextFieldDelegate{

    //回调
    typealias textFValueClosur = (_ value:String)->Void
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var valueTF: UITextField!
    
    var textFiledValueClosur:textFValueClosur?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.valueTF.isEnabled = false
        self.valueTF.delegate = self
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print(textField.text!)
        
        self.valueTF.isEnabled = false
        
        
        self.textFiledValueClosur?(textField.text!)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    
    
    
}
