//
//  StatisticalService.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/13.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class StatisticalService: NSObject {

    func getCustomView(_ name: String,width: CGFloat,height: CGFloat ,fontSize: CGFloat) ->UILabel{
        
        let label = UILabel(frame: CGRect(x: 0,y: 0,width: width,height: height))
        label.backgroundColor = UIColor.clear
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = name
        
        label.textAlignment = .center
        
        label.textColor = UIColor.white
        
//        label.font = UIFont(name: "ZoomlaShiShang-A022", size: 24)
        label.font = UIFont(name: "ZoomlaShiShang-A022", size: fontSize)
        label.isUserInteractionEnabled = false
        
        return label
        
    }
    
    func getCustomeArrowView(_ height: CGFloat,transform: CGFloat)->UIView{
        
        
        let view = UIView(frame: CGRect(x: 0,y: 0,width: height,height: height))
        
        view.backgroundColor = UIColor.clear

        let arrowImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: height, height: height))
        
        arrowImgView.backgroundColor = UIColor.clear
        
        arrowImgView.contentMode = UIViewContentMode.scaleAspectFit
        
        arrowImgView.image = UIImage(named: "SJT")
        
        arrowImgView.transform = CGAffineTransform(rotationAngle: transform)

        view.addSubview(arrowImgView)
        
        return view
    }
    
    
    func getCustomeBtn(_ title: String)->UIButton{
        
        let frame_hgight: CGFloat = 37
        
        let btn = UIButton(frame: CGRect(x: 0,y: 0,width: 150,height: frame_hgight))
        
        btn.setTitle(title, for: UIControlState())
        
        btn.backgroundColor = UIColor.clear
        
        btn.titleLabel?.font = UIFont(name: "ZoomlaShiShang-A022", size: 25)
        
        btn.layer.cornerRadius = frame_hgight / 2.0
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        
        btn.isUserInteractionEnabled = false
        
        return btn
        
    }
    
    
    
    //获取当前选择的时间
    func getCurrentTime(_ andSecTime: Bool,currentSec: String)->(Double,Double){
        
        //当前时间
        let today = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let abc = dateFormatter.string(from: today)
        
        let shijian:String = (abc as NSString).substring(to: 10)
        
        let todayStr: String = "\(shijian) 00:00:00"
        let todayDate = dateFormatter.date(from: todayStr)!
        
        let todayDouble: Double = todayDate.timeIntervalSince1970 + (8 * 60 * 60)
        
        //        print("当前时间->\(todayDate)，--时间戳-->\(dodayDouble)")
        
        
        var currentSecDouble: Double = 0
        
        if andSecTime {
            //选择的时间
//            let currentSec: String = (self.sRightView.sRTopView.timeBtn.titleLabel?.text)!
            
            let str: String = "\(currentSec) 00:00:00"
            
            let currentSecDate = dateFormatter.date(from: str)!
            
            currentSecDouble = currentSecDate.timeIntervalSince1970 + (8 * 60 * 60)
            //print("选择时间->\(currentSecDate)，--时间戳-->\(currentSecDouble)")
        }
        
        
        return (todayDouble,currentSecDouble)
        
    }
    
    //上一天时间
    func lastDay(_ time:Double) ->String{
        
        let inTime = time - 24 * 60 * 60
        let dayTime = Date(timeIntervalSince1970: inTime)
        let str = String(describing: dayTime)
        let stri:String = (str as NSString).substring(to: 10)

        return stri
    }
    
    //下一天时间
    func nextDay(_ time:Double) ->(String,Double){
        let inTime = time + 24 * 60 * 60
        
        let dayTime = Date(timeIntervalSince1970: inTime)
        let str = String(describing: dayTime)

        let stri:String = (str as NSString).substring(to: 10)
        
        return (stri,inTime)
        
    }
    
    //获取当前时间
    func getCurrentDate()->(String,Double,Date){
        
        //当前时间
        let today = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let abc = dateFormatter.string(from: today)
        
        let shijian:String = (abc as NSString).substring(to: 10)
        
        let str: String = "\(shijian) 00:00:00"
        
        let agaldsjafl = dateFormatter.date(from: str)!
        
        let aa:Double = agaldsjafl.timeIntervalSince1970 + (8 * 60 * 60)
        print(aa)
        return (shijian,aa,today)
        
    }
    
    
}
