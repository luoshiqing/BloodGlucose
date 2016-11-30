//
//  BloodTowTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/26.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class BloodTowTableViewCell: UITableViewCell ,UITextViewDelegate{

    
    typealias BloodTowTableViewCellTextClourse = (_ value: String)->Void
    var textClourse:BloodTowTableViewCellTextClourse?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
//        let color = UIColor(red: 255/255.0, green: 241/255.0, blue: 235/255.0, alpha: 1)
//        self.selectedBackgroundView = UIView(frame: self.frame)
//        self.selectedBackgroundView?.backgroundColor = color
        
        textView.delegate = self
        
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {

        self.textView.isEditable = false
        self.textView.isUserInteractionEnabled = false
        
        textClourse?(textView.text)
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
