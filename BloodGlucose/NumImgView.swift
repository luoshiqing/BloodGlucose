//
//  NumImgView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/7.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class NumImgView: UIView {

    //评分
    @IBOutlet weak var numLabel: UILabel!
    //等级
    @IBOutlet weak var levelLabel: UILabel!
    //表情
    @IBOutlet weak var imgView: UIImageView!
    
    //日期
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    @IBOutlet weak var jtImgView: UIImageView!
    
    
    
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    func initSetup(){
        
        
        //设置label 圆角
        dateView.layer.cornerRadius = 14.5
        dateView.clipsToBounds = true
        
        dateLabel.layer.cornerRadius = 13.5
        dateLabel.clipsToBounds = true
        
        jtImgView.layer.cornerRadius = 12.5
        jtImgView.clipsToBounds = true
        
    }
    
    //评分等级（1.差 2.良 3.优）
    var rating = 2
    
    func setNumImgView(_ bj:NSDictionary){
        let tmpcount = bj.value(forKey: "count") as! String
        let countDouble:Double = Double(tmpcount)!
        let count = NSString(format: "%.1f", countDouble)

        self.numLabel.text = "\(count)"

        switch countDouble {
        case 0..<60:
            //设置评分等级
            self.rating = 1
            
            self.levelLabel.text = "差"
            self.imgView.image = UIImage(named: "reportcha")
            
            //设置颜色
            self.levelLabel.textColor = UIColor(red: 220/255.0, green: 33/255.0, blue: 14/255.0, alpha: 1)
            self.numLabel.textColor = UIColor(red: 220/255.0, green: 33/255.0, blue: 14/255.0, alpha: 1)
            break
        case 60..<80:
            //设置评分等级
            self.rating = 2
            
            self.levelLabel.text = "良"
            self.imgView.image = UIImage(named: "reportliang")
            
            self.levelLabel.textColor = UIColor(red: 53/255.0, green: 208/255.0, blue: 192/255.0, alpha: 1)
            self.numLabel.textColor = UIColor(red: 53/255.0, green: 208/255.0, blue: 192/255.0, alpha: 1)
        default:
            //设置评分等级
            self.rating = 3
            
            self.levelLabel.text = "优"
            self.imgView.image = UIImage(named: "reportyou")
            
            self.levelLabel.textColor = UIColor(red: 235/255.0, green: 131/255.0, blue: 9/255.0, alpha: 1)
            self.numLabel.textColor = UIColor(red: 235/255.0, green: 131/255.0, blue: 9/255.0, alpha: 1)
            break
        }
    }
    
    

}
