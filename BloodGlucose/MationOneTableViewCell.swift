//
//  MationOneTableViewCell.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/2/2.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MationOneTableViewCell: UITableViewCell ,UITextFieldDelegate{

    //日期选择
    typealias textFiledValueClosur = (_ value:String)->Void
    
    var textFiledValueClosure:textFiledValueClosur? //回调值
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var inforTF: UITextField!
    
    
    @IBOutlet weak var sepH: NSLayoutConstraint!
    
    @IBOutlet weak var sepView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        sepH.constant = 0.5
        
        self.inforTF.delegate = self
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
//        print(textField.text!)
        textField.isEnabled = false
        
        
        
        self.textFiledValueClosure?(textField.text!)
    
        
    }
    
   
    
}
