//
//  MyDateChooseView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/27.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyDateChooseView: UIView ,UIPickerViewDelegate ,UIPickerViewDataSource{

    typealias MyDateChooseViewOkBtnClourse = (_ value: String)->Void
    var okBtnClourse: MyDateChooseViewOkBtnClourse?
    
    let myww = UIScreen.main.bounds.size.width
    let myhh = UIScreen.main.bounds.size.height
    
    
    var bbView: UIView!
    var mainView: UIView!
    
    
    //时间选择
    var myDatePikcer: UIDatePicker!
    //
    var myPickerView: UIPickerView!
    
    
    fileprivate var myDataArray = [String]()
    
    
    fileprivate var isDate = false
    
    
    func initMyDateChooseView(_ title: String,dataArray: [String]?,isDate: Bool,currentDate: Date?,model: UIDatePickerMode?){
        
        self.isDate = isDate
        
        
        if let tmpArray = dataArray{
            self.myDataArray = tmpArray
        }
        
        
        
        
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
            
            
            //加载中间
            
            if isDate { //时间选择器
                
                myDatePikcer = UIDatePicker(frame: CGRect(x: 0,y: titleH,width: m_w,height: m_h - titleH - btnH - 15))
                
                let maxDate = Date()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let minDate = dateFormatter.date(from: "1930-07-07 08:00:00")
                
                
                myDatePikcer.maximumDate = maxDate
                myDatePikcer.minimumDate = minDate
                
                //默认选择时间
                if let tmpDate = currentDate {
                    myDatePikcer.date = tmpDate
                }else{
                    myDatePikcer.date = Date()
                }
                
                
                //模式
                if let tmpModel = model {
                    myDatePikcer.datePickerMode = tmpModel
                }
      
                self.mainView.addSubview(self.myDatePikcer)
                
            }else{
                
                myPickerView = UIPickerView(frame: CGRect(x: 0,y: titleH,width: m_w,height: m_h - titleH - btnH - 15))
                
                
                myPickerView.delegate = self
                myPickerView.dataSource = self
                
//                myPickerView.selectRow(myDataArray.count / 2, inComponent: 0, animated: false)
                
                self.mainView.addSubview(myPickerView)
   
            }
            
      
            
            //确定按钮
            let okBtn = UIButton(frame: CGRect(x: m_w - btnW * Wsize - 30,y: m_h - btnH - 15,width: btnW * Wsize,height: btnH))
            okBtn.setTitle("确定", for: UIControlState())
            okBtn.titleLabel?.font = UIFont(name: PF_SC, size: 16)
            
            okBtn.setTitleColor(myColor, for: UIControlState())
            
            okBtn.layer.cornerRadius = 4
            okBtn.layer.masksToBounds = true
            okBtn.layer.borderWidth = 0.5
            okBtn.layer.borderColor = myColor.cgColor
            
            okBtn.addTarget(self, action: #selector(MyDateChooseView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
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
            
            cancel.addTarget(self, action: #selector(MyDateChooseView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            cancel.tag = 0
            self.mainView.addSubview(cancel)
            
        }
        
        
     
    }
 
    func someBtnAct(_ send: UIButton){
        
        switch send.tag {
        case 0:
            print("取消")
            self.dismiss()
        case 1:
            print("确定")
            
            if self.isDate { //时间

                if let value = self.getDatePickerValue() {

                    self.okBtnClourse?(value)
                    
                    self.dismiss()
                }

            }else{
                if let value =  self.getPickerValue(){
 
                    self.okBtnClourse?(value)
                    
                    self.dismiss()
                }
            }
   
        default:
            break
        }
        
        
    }
    
    func getDatePickerValue()->String?{
        
        if self.myDatePikcer != nil {

            
            
            let formatter = DateFormatter()
            
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.dateFormat = "yyyy-MM-dd HH:mm"

            
           
            
            
            let timeStr = formatter.string(from: self.myDatePikcer.date)
            

            return timeStr
        }else{
            return nil
        }
  
    }
    
    func getPickerValue()->String?{
        
        
        if self.myPickerView != nil{
            let index = self.myPickerView.selectedRow(inComponent: 0)
            
            let value = self.myDataArray[index]

            return value
        }else{
            return nil
        }
        
    }
    
    
    
    
    func someViewAct(_ send: UITapGestureRecognizer){

        self.dismiss()
    
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
    
    //picker代理
    //列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //行
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.myDataArray.count
    }
    
    //
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if !self.myDataArray.isEmpty {
            return self.myDataArray[row]
        }else{
            return "not data"
        }
 
        
    }
    
    
    
    
    
    
    
    
    
    

}
