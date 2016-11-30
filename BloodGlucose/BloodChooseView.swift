//
//  BloodChooseView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/26.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class BloodChooseView: UIView {

    typealias BloodChooseViewTouchValue = (_ tag: Int ,_ value: String?)->Void
    var touchValue:BloodChooseViewTouchValue?
    
    
    
    //记录刻度尺的值
    fileprivate var scaleValue: String!
    

    fileprivate let myWidth = UIScreen.main.bounds.width
    fileprivate let myHeight = UIScreen.main.bounds.height
    


    //标题高度
    fileprivate let titleH: CGFloat = 40
    //刻度尺高度
    fileprivate let scaleH: CGFloat = 100
    
    
    
  
    
    override func draw(_ rect: CGRect) {
        
  
        
    }
 
    func dismiss(){
        
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
            self.mbView.alpha = 0
            self.mbView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (cop: Bool) in
            if self.bgView != nil {
                self.bgView.removeFromSuperview()
                self.bgView = nil
            }
            if self.mbView != nil
            {
                self.mbView.removeFromSuperview()
                self.mbView = nil
            }
        }
   
        
    }
    

    var bgView: UIView!
    
    var mbView: UIView!
    
    
    var sectionIndex:Int?
    
    func initBloodChooseView(_ title: String ,value: Float ,section: Int?){
        
        if let tmpsec = section {
            self.sectionIndex = tmpsec
            
            print(tmpsec)
        }
        
        
        
        
        if bgView == nil {
            //底部透明背景
            bgView = UIView(frame: CGRect(x: 0,y: 0, width: myWidth, height: myHeight))
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 0.3
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(BloodChooseView.someViewAct(_:)))
            bgView.addGestureRecognizer(tap)
            bgView.tag = 3
            
            UIApplication.shared.keyWindow?.addSubview(bgView)
        }
        
        
        if mbView == nil {
            //-
            let xx: CGFloat = 33
            
            let hh: CGFloat = 205
            
            let ww = UIScreen.main.bounds.width - xx * 2
            
            let yy = (UIScreen.main.bounds.height - hh) / 2

            mbView = UIView(frame: CGRect(x: xx,y: yy,width: ww,height: hh))
            mbView.backgroundColor = UIColor.white
            
            
            mbView.layer.cornerRadius = 3
            mbView.layer.masksToBounds = true
            
            mbView.alpha = 0
            mbView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
            
            UIApplication.shared.keyWindow?.addSubview(mbView)
            
            
            //动画
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
                self.mbView.alpha = 1
                self.mbView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            
            
            
     
            
            
            //标题
            let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: ww,height: titleH))
            titleLabel.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            
            titleLabel.text = title
            
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont(name: PF_SC, size: 17)
            titleLabel.textColor = UIColor.white
            
            mbView.addSubview(titleLabel)
            
            //刻度尺
            let scaleView = MyScaleView(frame: CGRect(x: 0,y: titleH + 5,width: ww,height: scaleH))
            scaleView.backgroundColor = UIColor.white
            
            scaleView.realtimeValue = self.ScaleViewrealtimeValue
            
            scaleView.calculateAndUpdateOffset(value ,animated: true)
            
            mbView.addSubview(scaleView)
            
            
            //取消
            
            let y: CGFloat = titleH + scaleH + 20
            
            let h: CGFloat = 70
            
            let cancleBtn = UIButton(frame: CGRect(x: 30, y: y,width: h,height: 28))
            
            cancleBtn.setTitle("取消", for: UIControlState())
            cancleBtn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), for: UIControlState())
            
            cancleBtn.titleLabel?.font = UIFont(name: PF_SC, size: 15)
            
            cancleBtn.layer.cornerRadius = 4
            cancleBtn.layer.masksToBounds = true
            cancleBtn.layer.borderWidth = 0.5
            cancleBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
            
            cancleBtn.addTarget(self, action: #selector(BloodChooseView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            cancleBtn.tag = 0
            
            mbView.addSubview(cancleBtn)
            
            
            
            let okBtn = UIButton(frame: CGRect(x: ww - h - 30, y: y,width: h,height: 28))
            
            okBtn.setTitle("确定", for: UIControlState())
            okBtn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), for: UIControlState())
            
            okBtn.titleLabel?.font = UIFont(name: PF_SC, size: 15)
            
            okBtn.layer.cornerRadius = 4
            okBtn.layer.masksToBounds = true
            okBtn.layer.borderWidth = 0.5
            okBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
            
            okBtn.addTarget(self, action: #selector(BloodChooseView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            okBtn.tag = 1
            
            mbView.addSubview(okBtn)
        }
        
  
        
    }
    
    func someViewAct(_ send: UITapGestureRecognizer){
        

        self.dismiss()
  
    }
    
    
    func someBtnAct(_ send: UIButton){
        
        switch send.tag {
        case 0:
            print("取消")
            self.dismiss()
        case 1:
            print("确定")
            
            if self.scaleValue != nil {
                
                if self.sectionIndex != nil { //nil
                    //低血糖值
                    let minBlood = Float(remindSetValueArray[0])!
                    //高血糖值
                    let maxBlood = Float(remindSetValueArray[2])!
                    
                    let scale = Float(self.scaleValue)!
                    
                    if self.sectionIndex == 0 { //低血糖
                        
                        if scale < maxBlood - 1 {
                            
                            self.touchValue?(send.tag ,self.scaleValue)
                            
                            self.dismiss()
                            
                        }else{
      
                            let alrte = UIAlertView(title: "您当前输入的低血糖为\(self.scaleValue)mmol/L", message: "低、高血糖相差最少为1mmol/L，请查看并修改", delegate: nil, cancelButtonTitle: "确定")
                            alrte.show()
                        }

                    }else{ //高血糖
                        
                        
                        if scale < 7.8 {
                            let alrte = UIAlertView(title: "您当前输入的高血糖为\(self.scaleValue)mmol/L", message: "高血糖值最少为7.8mmol/L", delegate: nil, cancelButtonTitle: "确定")
                            alrte.show()
                        }else{
                            if scale > minBlood + 1 {
                                self.touchValue?(send.tag ,self.scaleValue)
                                self.dismiss()
                            }else{
                                
                                
                                let alrte = UIAlertView(title: "您当前输入的高血糖为\(self.scaleValue)mmol/L", message: "低、高血糖相差最少为1mmol/L，请查看并修改", delegate: nil, cancelButtonTitle: "确定")
                                alrte.show()
                            }
                        }
                        

                    }
   
                    
                }else{
                    self.touchValue?(send.tag ,self.scaleValue)
                    self.dismiss()
                }
         
            }
 
        default:
            break
        }
   
        
        
    }
    
    //刻度尺回调
    func ScaleViewrealtimeValue(_ value: String)->Void{
    
//        print("刻度尺回调值->\(value)")
        self.scaleValue = value
        
    }
    
    
    
}
