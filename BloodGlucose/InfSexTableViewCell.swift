//
//  InfSexTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/31.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit


protocol InfSexTableViewCellDelegate {
    func sexSelectInt(_ value:Int)
}

class InfSexTableViewCell: UITableViewCell {

    var delegate:InfSexTableViewCellDelegate?
    

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var manView: UIView!
    @IBOutlet weak var manImgView: UIImageView!
    @IBOutlet weak var manLabel: UILabel!
    
    
    @IBOutlet weak var womenView: UIView!
    @IBOutlet weak var womenImgView: UIImageView!
    @IBOutlet weak var womenLabel: UILabel!
    
    
    @IBOutlet weak var sepView: UIView!
    
    @IBOutlet weak var sepH: NSLayoutConstraint!
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        sepH.constant = 0.5
        
        
        //设置视图点击事件
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(InfSexTableViewCell.someViewAct(_:)))
        self.manView.tag = 1
        self.manView.addGestureRecognizer(tap1)
        
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(InfSexTableViewCell.someViewAct(_:)))
        self.womenView.tag = 0
        self.womenView.addGestureRecognizer(tap2)
        
        
        
        
        
    }
    

    func someViewAct(_ send:UITapGestureRecognizer){
        let selectTag = send.view!.tag

        
        if selectTag == 0 { //女
            self.manImgView.image = UIImage(named: "menuMan")
            self.manLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
            
            self.womenImgView.image = UIImage(named: "menuwomen")
            self.womenLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            
        }else{//男
            self.manImgView.image = UIImage(named: "menuManL")
            self.manLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            
            self.womenImgView.image = UIImage(named: "menuwomenA")
            self.womenLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
            
        }
        
        self.delegate?.sexSelectInt(selectTag)
        
    }
    
    
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
