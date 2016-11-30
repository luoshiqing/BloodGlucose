//
//  DateView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/18.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

protocol DateViewDelegate {
    func saveBtnAct(_ date:String)
    
    func closeDateView()
    
    
}



class DateView: UIView {

    var delegate:DateViewDelegate!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    
    @IBOutlet weak var datePick: UIDatePicker!
    
    @IBOutlet weak var canceBtn: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    
    var isDateAndTime = false
    
    
    var currentDate: Date?
    
    
    override func draw(_ rect: CGRect) {
        
        //设置按钮
        self.setBtn()
        
        
        self.initSetup()
        //设置时间最大值
        self.setDatePickMax()
    }
    
    func initSetup(){
        
        self.saveBtn.addTarget(self, action: #selector(DateView.saveBtnAct), for: UIControlEvents.touchUpInside)
        

    }
    func setBtn(){
        
        
        
        self.canceBtn.layer.cornerRadius = 4
        self.canceBtn.layer.masksToBounds = true
        self.canceBtn.layer.borderWidth = 1
        self.canceBtn.layer.borderColor = UIColor.orange.cgColor
        
        
        self.saveBtn.layer.cornerRadius = 4
        self.saveBtn.layer.masksToBounds = true
        self.saveBtn.layer.borderWidth = 1
        self.saveBtn.layer.borderColor = UIColor.orange.cgColor
        
        
        
        self.saveBtn.addTarget(self, action: #selector(DateView.saveBtnAct), for: UIControlEvents.touchUpInside)
        self.canceBtn.addTarget(self, action: #selector(DateView.canceAct), for: UIControlEvents.touchUpInside)

        
        
        
        
        
        
    }
    
    
    
    func setDatePickMax(){
        let today:Double = Date().timeIntervalSince1970
        let dayTime = Date(timeIntervalSince1970: today)
        self.datePick.maximumDate = dayTime
        
        
        if let tmpDate = self.currentDate {
            self.datePick.date = tmpDate
        }else{
            self.datePick.date = Date()
        }
        
    }
    
    func saveBtnAct(){
        //print("确定")
        
        let aa = self.datePick.date.timeIntervalSince1970 + (8 * 60 * 60)
        let dayTime = Date(timeIntervalSince1970: aa)
        let str = String(describing: dayTime)
        
//        let time = (str as NSString).substring(with: NSRange(0...9))
//        let isDateAndTime = (str as NSString).substring(with: NSRange(0...18))
        
        let time = (str as NSString).substring(with: NSRange(location: 0, length: 10))
        let isDateAndTime = (str as NSString).substring(with: NSRange(location: 0, length: 19))
        
        
        if self.isDateAndTime == true {
            self.delegate.saveBtnAct(isDateAndTime)
        }else{
            self.delegate.saveBtnAct(time)
        }
        
        
        
        
    }
    
    func canceAct(){
        print("取消")
        self.delegate.closeDateView()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
