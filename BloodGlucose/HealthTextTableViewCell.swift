//
//  HealthTextTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/15.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class HealthTextTableViewCell: UITableViewCell ,UITextViewDelegate{

    
    typealias HealthTextTableViewCellTextClourse = (_ value: String)->Void
    
    var textClourse: HealthTextTableViewCellTextClourse?
    
    
    @IBOutlet weak var titLabel: UILabel!
    
    @IBOutlet weak var myTextView: UITextView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        self.myTextView.delegate = self
        
//        self.myTextView.editable = false
        
        self.myTextView.isUserInteractionEnabled = false
        
        
        
        
        
        
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        textView.resignFirstResponder()
        textView.isUserInteractionEnabled = false
        
        
        self.textClourse?(textView.text)
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
