//
//  PHTBloodSecView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/22.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class PHTBloodSecView: UIView ,UIPickerViewDelegate ,UIPickerViewDataSource{

    typealias PHTBloodSecViewOkClourse = (_ leftValue: String ,_ rightValue: String)->Void
    var okClourse: PHTBloodSecViewOkClourse?
    
    
    let myww = UIScreen.main.bounds.size.width
    let myhh = UIScreen.main.bounds.size.height
    
    
    var bbView: UIView!
    var mainView: UIView!
    
    
    
    var myPickerView: UIPickerView!
    
    
    fileprivate var leftTit: String?
    fileprivate var rightTit: String?
    fileprivate var leftData = [String]()
    fileprivate var rightData = [String]()
    
    
    func initBloodSecView(_ leftTitle: String? ,rightTitle: String?,leftDataArray: [String] ,rightDataArray: [String]){
        
        self.leftTit = leftTitle
        self.rightTit = rightTitle
        self.leftData = leftDataArray
        self.rightData = rightDataArray
        
        self.loadBgView()
        
        self.loadMainView()
        
    }
    
    
    //背景
    func loadBgView(){
        
        if self.bbView == nil {
            self.bbView = UIView(frame: CGRect(x: 0,y: 0,width: myww,height: myhh))
            self.bbView.backgroundColor = UIColor.black
            self.bbView.alpha = 0.3
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(PHTBloodSecView.someViewAct(_:)))
            
            self.bbView.addGestureRecognizer(tap)
            self.bbView.tag = 3
            
            
            UIApplication.shared.keyWindow?.addSubview(self.bbView)
        }
    }
    
    func loadMainView(){
        
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
            
            let leftTitleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: m_w / 2,height: titleH))
            leftTitleLabel.backgroundColor = myColor
 
            leftTitleLabel.text = self.leftTit
            
            leftTitleLabel.textAlignment = .center
            leftTitleLabel.font = UIFont(name: PF_SC, size: 17)
            leftTitleLabel.textColor = UIColor.white
            
            self.mainView.addSubview(leftTitleLabel)
            
            
            let rightTitleLabel = UILabel(frame: CGRect(x: m_w / 2,y: 0,width: m_w / 2,height: titleH))
            rightTitleLabel.backgroundColor = myColor
            
            rightTitleLabel.text = self.rightTit
            
            rightTitleLabel.textAlignment = .center
            rightTitleLabel.font = UIFont(name: PF_SC, size: 17)
            rightTitleLabel.textColor = UIColor.white
            
            self.mainView.addSubview(rightTitleLabel)
            
        
            //加载中间
            
            myPickerView = UIPickerView(frame: CGRect(x: 0,y: titleH,width: m_w,height: m_h - titleH - btnH - 15))
            
            
            myPickerView.delegate = self
            myPickerView.dataSource = self

            self.mainView.addSubview(myPickerView)
            
            
            //确定按钮
            let okBtn = UIButton(frame: CGRect(x: m_w - btnW * Wsize - 30,y: m_h - btnH - 15,width: btnW * Wsize,height: btnH))
            okBtn.setTitle("确定", for: UIControlState())
            okBtn.titleLabel?.font = UIFont(name: PF_SC, size: 16)
            
            okBtn.setTitleColor(myColor, for: UIControlState())
            
            okBtn.layer.cornerRadius = 4
            okBtn.layer.masksToBounds = true
            okBtn.layer.borderWidth = 0.5
            okBtn.layer.borderColor = myColor.cgColor
            
            okBtn.addTarget(self, action: #selector(PHTBloodSecView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
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
            
            cancel.addTarget(self, action: #selector(PHTBloodSecView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            cancel.tag = 0
            self.mainView.addSubview(cancel)
            
        
        }
 
        
    }
    
    
  
    //picker代理
    //列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    //行
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return self.leftData.count
        default:
            return self.rightData.count
        }
   
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        

        switch component {
        case 0:
            if !self.leftData.isEmpty {
                return self.leftData[row]
            }else{
                return "not data"
            }
  
        default:
            if !self.rightData.isEmpty {
                return self.rightData[row]
            }else{
                return "not data"
            }
        }
        
    }
    

    func someViewAct(_ send: UITapGestureRecognizer){
        
        self.dismiss()
        
    }

    func someBtnAct(_ send: UIButton){
        
        switch send.tag {
        case 0:
            //取消
            self.dismiss()
        case 1:
            //确定
            
            let (leftvalue,rightValue) =  self.getPickerValue()
                
            self.okClourse?(leftvalue ,rightValue)

            self.dismiss()

        default:
            break
        }
        
        
    }
    func getPickerValue()->(String,String){
        
        
        let leftIndex = self.myPickerView.selectedRow(inComponent: 0)
        
        let leftValue = self.leftData[leftIndex]
        
        let rightIndex = self.myPickerView.selectedRow(inComponent: 1)
        
        let rightValue = self.rightData[rightIndex]
        
        
        return (leftValue,rightValue)
        
       
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
