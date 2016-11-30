//
//  SBInputFingerView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/29.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SBInputFingerView: UIView {

    
    typealias SBInputFingerViewToCalculateClourse = (_ tag: Int,_ isEdit: Bool,_ fingerBloodArray: [Any]?,_ secIndx: Int?) -> Void
    var toCalculateClourse:SBInputFingerViewToCalculateClourse?
    
    
    
    fileprivate let myWidth = UIScreen.main.bounds.size.width
    fileprivate let myHeight = UIScreen.main.bounds.size.height
    
    //比例
    fileprivate let WScale = UIScreen.main.bounds.size.width / 375
    fileprivate let Hscale = UIScreen.main.bounds.size.height / 667
    
    
    
    
    
    var bgView: UIView!
    
    var mainView: UIView!
    
    
    //左右边距
    fileprivate let leftWidth: CGFloat = 15
    //main高度
    fileprivate let mainH: CGFloat = 387
    
//    
//    override func drawRect(rect: CGRect) {
//
//        
//    }
    
    fileprivate var myDatePikcer: UIDatePicker!
    
    
    fileprivate var isEdit = false //false 为添加，true为修改
    fileprivate var index: Int?
    
    
    var currentDate: Date?
    var minDate: Date?
    var maxDate: Date?
    
    
    func initSBInputFingerView(_ scaleValue: Float, animated: Bool,isEdit: Bool,index: Int?,currentDate: Date?,minDate: Date?,maxDate: Date?){
        
        self.currentDate = currentDate
        self.minDate = minDate
        self.maxDate = maxDate

        
        self.isEdit = isEdit
        self.index = index
        self.loadBgView()
        
        self.loadMainView(scaleValue, animated: animated)
    }
    
    
    
    
    func dismiss(){
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
            if self.mainView != nil{
                
                self.mainView.alpha = 0
                self.mainView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
        }) { (cop: Bool) in
            
            print("cop->\(cop)")
            
            
            if self.mainView != nil{
                self.mainView.removeFromSuperview()
                self.mainView = nil
            }
            if self.bgView != nil{
                self.bgView.removeFromSuperview()
                self.bgView = nil
            }
        }
  
    }
    
    func loadBgView(){
        if bgView == nil {
            bgView = UIView(frame: CGRect(x: 0,y: 0,width: myWidth,height: myHeight))
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 0.25
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(SBInputFingerView.someViewAct(_:)))
            bgView.addGestureRecognizer(tap)
            bgView.tag = 3
            
            UIApplication.shared.keyWindow?.addSubview(bgView)
            
        }
    }
    
    func loadMainView(_ scaleValue: Float,animated: Bool){
        
        if self.mainView == nil {
            
            let mainW = self.myWidth - self.leftWidth * 2
            let mainHi = self.mainH * self.Hscale
            
            
            let frames = CGRect(x: leftWidth, y: (myHeight - mainH * Hscale) / 2, width: mainW, height: mainHi)
            
            self.mainView = UIView(frame: frames)
            
            self.mainView.backgroundColor = UIColor.white
            
            self.mainView.alpha = 0
            self.mainView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
            
            self.mainView.layer.cornerRadius = 4
            self.mainView.layer.masksToBounds = true
            
            
            UIApplication.shared.keyWindow?.addSubview(self.mainView)
            
            
            
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
                self.mainView.alpha = 1
                self.mainView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            
            
    
            //底部标题视图

            let upView = UIView(frame: CGRect(x: 0,y: 0,width: mainW,height: 40))
            upView.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            self.mainView.addSubview(upView)
            
            //标题
            let titleLabel = UILabel(frame: CGRect(x: (mainW - 100) / 2,y: 0,width: 100,height: 40))
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont(name: PF_SC, size: 17)
            titleLabel.textAlignment = .center
            titleLabel.text = "输入指血"
            upView.addSubview(titleLabel)
            
            //历史按钮
            let historyBtn = UIButton(frame: CGRect(x: mainW - 64,y: 0,width: 64,height: 40))
            historyBtn.setTitle("历史", for: UIControlState())
            historyBtn.setTitleColor(UIColor.white, for: UIControlState())
            historyBtn.titleLabel?.font = UIFont(name: PF_SC, size: 17)
            
            historyBtn.addTarget(self, action: #selector(SBInputFingerView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            historyBtn.tag = 2
            upView.addSubview(historyBtn)
            
            //中间刻度尺
            let scaleView = MyScaleView(frame: CGRect(x: 18,y: 40,width: mainW - 18 * 2,height: 100))
            scaleView.backgroundColor = UIColor.clear
            
            scaleView.realtimeValue = self.ScaleViewrealtimeValue
            
            scaleView.calculateAndUpdateOffset(scaleValue ,animated: animated)
            self.mainView.addSubview(scaleView)
            
            //选择指血时间
            let figerLabel = UILabel(frame: CGRect(x: 0,y: 90 + 40 + 15,width: mainW,height: 19))
            figerLabel.textAlignment = .center
            figerLabel.text = "选择指血时间"
            figerLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            figerLabel.font = UIFont(name: PF_SC, size: 17)
            self.mainView.addSubview(figerLabel)
            
 
            
            //时间选择
            
            let dy: CGFloat = 100 + 40 + 15 + 15
            let dh: CGFloat = mainHi - dy - 15 - 28
            
            
            myDatePikcer = UIDatePicker(frame: CGRect(x: 0,y: dy,width: mainW,height: dh))
            
            if let max = self.maxDate {
                myDatePikcer.maximumDate = max
            }
            
            if let min = self.minDate {
                myDatePikcer.minimumDate = min
            }

            if let cur = self.currentDate {
                myDatePikcer.date = cur
            }else{
                //默认选择时间
                myDatePikcer.date = Date()
            }
            
 
            self.mainView.addSubview(myDatePikcer)
            
            
            
            
            //取消按钮
            
            let btnH: CGFloat = 28 //高
            
            let btnW: CGFloat = 65 //宽
            
            let leftW: CGFloat = 20 //左右距离
            
            let downW: CGFloat = 15 //底部距离
            
            
            let cancleBtn = UIButton(frame: CGRect(x: leftW,y: mainHi - btnH - downW,width: btnW,height: btnH))
    
            cancleBtn.setTitle("取消", for: UIControlState())
            cancleBtn.titleLabel?.font = UIFont(name: PF_SC, size: 15)
            
            cancleBtn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), for: UIControlState())
            cancleBtn.setTitleColor(UIColor.white, for: UIControlState.highlighted)

            cancleBtn.addTarget(self, action: #selector(SBInputFingerView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            cancleBtn.tag = 0

            cancleBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor.white) , for: UIControlState())
            cancleBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)) , for: UIControlState.highlighted)
            
            
            cancleBtn.layer.cornerRadius = 3
            cancleBtn.layer.masksToBounds = true
            cancleBtn.layer.borderWidth = 0.5
            cancleBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
            
            self.mainView.addSubview(cancleBtn)
            
    
            
            //确定
            let okBtn = UIButton(frame: CGRect(x: mainW - leftW - btnW,y: mainHi - btnH - downW,width: btnW,height: btnH))
            
            okBtn.setTitle("提交", for: UIControlState())
            okBtn.titleLabel?.font = UIFont(name: PF_SC, size: 15)
            
            okBtn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), for: UIControlState())
            okBtn.setTitleColor(UIColor.white, for: UIControlState.highlighted)
            
            okBtn.addTarget(self, action: #selector(SBInputFingerView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            okBtn.tag = 1
            
            okBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor.white) , for: UIControlState())
            okBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)) , for: UIControlState.highlighted)
            
            
            okBtn.layer.cornerRadius = 3
            okBtn.layer.masksToBounds = true
            okBtn.layer.borderWidth = 0.5
            okBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
            
            self.mainView.addSubview(okBtn)
            
            
        }
        
        
        
        
        
        
        
    }
    
 
    
    
    
    
    func someViewAct(_ send: UITapGestureRecognizer){

        self.toCalculateClourse?(send.view!.tag,self.isEdit,nil,nil)

        
        self.dismiss()
        
    }
    
    
    var figerBloodArray = [Any]() //参比指血记录
    
    
    func someBtnAct(_ send: UIButton){
        print("按钮->\(send.tag)")
        
        switch send.tag {
        case 0:
            print("取消")
            
            self.toCalculateClourse?(send.tag,self.isEdit,nil,nil)
            
            
        case 1:
            print("提交")

            print("指血->\(self.scaleValue)-->时间->\(self.myDatePikcer.date)编辑状态->\(self.isEdit)")
            
            if self.isEdit {
                
                
                if let i = self.index {
                    

                    self.figerBloodArray.append([self.scaleValue,self.myDatePikcer.date])
                    
                    print(self.figerBloodArray)
                    
                    self.toCalculateClourse?(send.tag,self.isEdit,self.figerBloodArray,i)
                    
                }
                
            }else{
                
                self.figerBloodArray.append([self.scaleValue,self.myDatePikcer.date])
                    
                self.toCalculateClourse?(send.tag,self.isEdit,self.figerBloodArray,nil)
                    
                
                
            }
            
   
        case 2:
            print("历史")
            

            self.toCalculateClourse?(send.tag,self.isEdit,nil,nil)
            
            
            
        default:
            break
        }
     
        self.dismiss()
        
    }
    
    
    
    
    
    

    //刻度尺选择
    var scaleValue = "0.0"
    
    //刻度尺回调
    func ScaleViewrealtimeValue(_ value: String)->Void{
        
//        print("刻度尺回调值->\(value)")
        self.scaleValue = value
        
    }
    
    
    
}
