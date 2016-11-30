//
//  HomeMideTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/19.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class HomeMideTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var biaotiLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    
    
    @IBOutlet weak var imgH: NSLayoutConstraint!//22
    
    @IBOutlet weak var imgW: NSLayoutConstraint!//27
    
    
    @IBOutlet weak var rightJTw: NSLayoutConstraint!//6
    @IBOutlet weak var RightJTh: NSLayoutConstraint!//11
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //布局
        self.setLayOut()
        
        
        let color = UIColor(red: 255/255.0, green: 241/255.0, blue: 235/255.0, alpha: 1)
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = color
        
    }

    func setLayOut(){
        
        let Wsize = UIScreen.main.bounds.width / 375
        
//        imgH.constant = Wsize * 22
//        imgW.constant = Wsize * 27
        
        rightJTw.constant = Wsize * 6
        RightJTh.constant = Wsize * 11
        
        
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}
