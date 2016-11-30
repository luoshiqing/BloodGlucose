//
//  MyAddTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyAddTableViewCell: UITableViewCell {

    //回调
    typealias cellValueClosur = (_ cell: AnyObject,_ index: Int)->Void
    
    var addCellValueClosur:cellValueClosur?
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    
    @IBOutlet weak var defaultView: UIView!
    @IBOutlet weak var defaultImgView: UIImageView!
    @IBOutlet weak var defaultLabel: UILabel!
    
    
    @IBOutlet weak var editView: UIView!
    
    
    @IBOutlet weak var deleteView: UIView!
    
    
    @IBOutlet weak var addressW: NSLayoutConstraint!
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let Wsize = UIScreen.main.bounds.width / 320.0
        
        addressW.constant = 255 * Wsize
        
        
        self.addressLabel.sizeToFit()
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        
        
        //设置视图点击
        self.setViewAct()
        
        //设置圆角
        //设置label 圆角
        bgView.layer.cornerRadius = 4
        bgView.clipsToBounds = true
        
    }

    
    func setViewAct(){
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(MyAddTableViewCell.viewAct(_:)))
        self.defaultView.addGestureRecognizer(tap1)
        self.defaultView.tag = 1
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(MyAddTableViewCell.viewAct(_:)))
        self.editView.addGestureRecognizer(tap2)
        self.editView.tag = 2
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(MyAddTableViewCell.viewAct(_:)))
        self.deleteView.addGestureRecognizer(tap3)
        self.deleteView.tag = 3
        
    }
    
    
    func viewAct(_ send:UITapGestureRecognizer){
        
        let selecTag = send.view!.tag
        
        print(selecTag)
        
//        let vvv = send.view?.superview?.superview?.superview as! MyAddTableViewCell
//        
//        print(vvv)
        
        self.addCellValueClosur?(self,selecTag)
        
    }
    
    
    
    
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
