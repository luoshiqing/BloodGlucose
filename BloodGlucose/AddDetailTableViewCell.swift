//
//  AddDetailTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class AddDetailTableViewCell: UITableViewCell ,UITextViewDelegate{

    //回调
    typealias textVValueClosur = (_ value:String)->Void
    
    var textViewValueClosur:textVValueClosur?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var valueTV: UITextView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.valueTV.delegate = self
        
        self.valueTV.isEditable = false
        self.valueTV.isUserInteractionEnabled = false
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var isFirstEdit = true
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        if isFirstEdit {
            textView.text = nil
        }
        
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        

        self.valueTV.isUserInteractionEnabled = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false

        self.textViewValueClosur?(textView.text)
        
    }
    
    
    
    
}
