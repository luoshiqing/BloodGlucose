//
//  LeftHeadView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/6.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class LeftHeadView: UIView {

    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var donwView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    
    @IBOutlet weak var completeLabel: UILabel!
    
    @IBOutlet weak var BGW: NSLayoutConstraint! //163

    var BBBBWWW: CGFloat = 163
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let Wsize = UIScreen.main.bounds.width / 375
    
    override func draw(_ rect: CGRect) {
        

        
        
        BGW.constant = Wsize * 163
        
        BBBBWWW = Wsize * 163
        
        
        
        //用户名视图
        self.imgView.layer.cornerRadius = 50 / 2.0
        self.imgView.layer.masksToBounds = true
        
        
        self.donwView.layer.cornerRadius = 4
        self.donwView.backgroundColor = UIColor.clear
        self.donwView.layer.masksToBounds = true
        self.donwView.layer.borderWidth = 0.5
        self.donwView.layer.borderColor = UIColor(red: 254/255.0, green: 144/255.0, blue: 94/255.0, alpha: 1).cgColor
        
        self.topView.layer.cornerRadius = 4
        self.topView.layer.masksToBounds = true
        self.topView.backgroundColor = UIColor(red: 254/255.0, green: 144/255.0, blue: 94/255.0, alpha: 1)
 
        
    }
    
    
    func compeletSetValue(_ imageName: String,name: String,progress: String,isUrl: Bool){
        
        //赋值
        
        
        if isUrl {
            imgView.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: "lefticon"))
        }else{
            imgView.image = UIImage(named: imageName)
        }
   
        
        nameLabel.text = name
        completeLabel.text = "资料完善度：\(progress)"
        
        
        let datamuch = (progress as NSString).replacingOccurrences(of: "%", with: "")
        print(datamuch)
        
        
        
        
        //163
        let width: CGFloat = BBBBWWW * CGFloat(Float(datamuch)!) / 100

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        self.topView.frame = CGRect(x: 0, y: 0, width: width, height: 8)
        
        UIView.setAnimationCurve(UIViewAnimationCurve.easeOut) //设置动画相对速度
        UIView.commitAnimations()
        

    }
    
    func restValue(){
        self.topView.frame = CGRect(x: 0, y: 0, width: 1, height: 8)
    }
    
    

}
