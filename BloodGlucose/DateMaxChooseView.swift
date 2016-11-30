//
//  DateMaxChooseView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/17.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class DateMaxChooseView: UIView {

    typealias DateMaxChooseViewOkBtnClourse = (_ value: String)->Void
    var okBtnClourse: DateMaxChooseViewOkBtnClourse?
    
    var myDateView: UIDatePicker?
    
    
    
    var bbView: UIView!
    var mainView: UIView!
    
    
    let myww = UIScreen.main.bounds.size.width
    let myhh = UIScreen.main.bounds.size.height
    
    func initDateMaxChooseView(_ title: String?,model:UIDatePickerMode?,currentDate: Date?,minDate: Date?,maxDate: Date?){
        
        if self.bbView == nil {
            self.bbView = UIView(frame: CGRect(x: 0,y: 0,width: myww,height: myhh))
            self.bbView.backgroundColor = UIColor.black
            self.bbView.alpha = 0.3
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(MyDateChooseView.someViewAct(_:)))
            
            self.bbView.addGestureRecognizer(tap)
            self.bbView.tag = 3
            
            
            UIApplication.shared.keyWindow?.addSubview(self.bbView)
        }
        
        
        if self.mainView == nil {
            
            let titleH: CGFloat = 40
            let btnH: CGFloat = 30
            let btnW: CGFloat = 70
            
            let Hsize = UIScreen.main.bounds.height / 667
            let Wsize = UIScreen.main.bounds.width / 375
            
            let m_x: CGFloat = 20
            let m_w = self.myww - m_x * 2
            //高度
            let m_h = 200 * Hsize + titleH + btnH
            
            self.mainView = UIView(frame: CGRect(x: m_x,y: (self.myhh - m_h) / 2,width: m_w,height: m_h))
            
            self.mainView.backgroundColor = UIColor.white
            
            self.mainView.layer.cornerRadius = 4.0
            self.mainView.layer.masksToBounds = true
            
            
            self.mainView.alpha = 0
            self.mainView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
            UIApplication.shared.keyWindow?.addSubview(self.mainView)
            
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.mainView.alpha = 1
                self.mainView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            
            
            
            
            //标题
            //-颜色
            let myColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            
            let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: m_w,height: titleH))
            titleLabel.backgroundColor = myColor
            
            titleLabel.text = title
            
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont(name: PF_SC, size: 17)
            titleLabel.textColor = UIColor.white
            
            self.mainView.addSubview(titleLabel)
            
            
            
            
            myDateView = UIDatePicker(frame: CGRect(x: 0,y: titleH,width: m_w,height: m_h - titleH - btnH - 15))
            
            if let min = minDate {
                myDateView?.minimumDate = min
            }else{
                myDateView?.minimumDate = self.getDate(false)
            }
            
            if let max = maxDate {
                myDateView?.maximumDate = max
            }else{
                myDateView?.maximumDate = self.getDate(true)
            }
            
     
            
            //默认选择时间
            if let curr = currentDate {
                myDateView?.date = curr
            }
 
            //模式
            if let tmpModel = model {
                myDateView?.datePickerMode = tmpModel
            }
            
            self.mainView.addSubview(self.myDateView!)
            
    
            
            //确定按钮
            let okBtn = UIButton(frame: CGRect(x: m_w - btnW * Wsize - 30,y: m_h - btnH - 15,width: btnW * Wsize,height: btnH))
            okBtn.setTitle("确定", for: UIControlState())
            okBtn.titleLabel?.font = UIFont(name: PF_SC, size: 16)
            
            okBtn.setTitleColor(myColor, for: UIControlState())
            
            okBtn.layer.cornerRadius = 4
            okBtn.layer.masksToBounds = true
            okBtn.layer.borderWidth = 0.5
            okBtn.layer.borderColor = myColor.cgColor
            
            okBtn.addTarget(self, action: #selector(DateMaxChooseView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            okBtn.tag = 1
            self.mainView.addSubview(okBtn)
            //取消按钮
            let cancel = UIButton(frame: CGRect(x: 30,y: m_h - btnH - 15,width: btnW * Wsize,height: btnH))
            cancel.setTitle("取消", for: UIControlState())
            cancel.titleLabel?.font = UIFont(name: PF_SC, size: 16)
            
            cancel.setTitleColor(myColor, for: UIControlState())
            
            cancel.layer.cornerRadius = 4
            cancel.layer.masksToBounds = true
            cancel.layer.borderWidth = 0.5
            cancel.layer.borderColor = myColor.cgColor
            
            cancel.addTarget(self, action: #selector(DateMaxChooseView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            cancel.tag = 0
            self.mainView.addSubview(cancel)
            
 
        }
        
        
        
        
        
        
    }
    
    
    func getDate(_ isMax: Bool) ->Date?{
        
        if isMax {
            let maxDate = Date()
            
            return maxDate
        }else{

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let minDate = dateFormatter.date(from: "2016-07-07 08:00:00")
            
            return minDate
        }
  
    }
    
    
    func someBtnAct(_ send: UIButton){
    
        switch send.tag {
        case 0:
            print("取消")
        case 1:
            print("确定")
            
            if let value = self.getDatePickerValue() {
                
                self.okBtnClourse?(value)

            }
            
            
        default:
            break
        }
        
        self.dismiss()
    }
    func someViewAct(_ send: UITapGestureRecognizer){
        
        self.dismiss()
        
    }
    
    
    func getDatePickerValue()->String?{
        
        if self.myDateView != nil {
            
 
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let timeStr = formatter.string(from: self.myDateView!.date)

            return timeStr
        }else{
            return nil
        }
        
    }
    
    
    func dismiss(){
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.mainView.alpha = 0
            self.mainView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (cop: Bool) in
            if self.bbView != nil {
                self.bbView.removeFromSuperview()
                self.bbView = nil
            }
            if self.mainView != nil{
                self.mainView.removeFromSuperview()
                self.mainView = nil
            }
        }
        
        
        
        
        
    }

}
