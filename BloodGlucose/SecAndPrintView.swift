//
//  SecAndPrintView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/20.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SecAndPrintView: UIView ,UIPickerViewDelegate,UIPickerViewDataSource{

    //日期选择
    typealias SecAndPrintViewValueClosur = (_ isMoreBtnAct:Bool,_ tag: Int,_ secInt:Int,_ value:String)->Void
    
    var secAndPrintViewValueClosur:SecAndPrintViewValueClosur?
    
    
    //是否显示头部 输入更多
    var isShowHeadView = true
    

    var myPickerView:UIPickerView!
    
    
    //数据源
    var dataArray = [String]()
    
    
    
    override func draw(_ rect: CGRect) {
        
        
        self.loadSomeView(rect, isShowHead: self.isShowHeadView)
        
        
    
        
    }
    var pickerDefaultIndex = 0
    
    func loadSomeView(_ rect: CGRect,isShowHead: Bool){

        if isShowHead {
            
            let headView = UIView(frame: CGRect(x: 0,y: 0,width: rect.width,height: 40))
            headView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
            self.addSubview(headView)
            
            //添加更多按钮
            let moreBtn = UIButton(frame: CGRect(x: 20,y: 5,width: headView.frame.size.width - 40,height: 35))
            moreBtn.backgroundColor = UIColor.white
            moreBtn.setTitle("点击这里可以添加更多哦", for: UIControlState())
            moreBtn.setTitleColor(UIColor(red: 177/255.0, green: 177/255.0, blue: 177/255.0, alpha: 1) , for: UIControlState.highlighted)
            moreBtn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1) , for: UIControlState())
            moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            moreBtn.addTarget(self, action: #selector(SecAndPrintView.moreBtnAct(_:)), for: UIControlEvents.touchUpInside)
            moreBtn.tag = 2
            
            headView.addSubview(moreBtn)
            
            moreBtn.layer.cornerRadius = 4
            moreBtn.clipsToBounds = true
            
            myPickerView = UIPickerView(frame: CGRect(x: 0,y: 45,width: rect.width,height: rect.height - 40))

            
            self.addSubview(myPickerView)
            
 
        }else{
            
            
            myPickerView = UIPickerView(frame: CGRect(x: 0,y: 0,width: rect.width,height: rect.height))
    
            
            self.addSubview(myPickerView)
            
            
            
        }
        
 
        
        
        let canceBtn = UIButton(frame: CGRect(x: 20,y: 50,width: 80,height: 30))
        canceBtn.setTitle("取消", for: UIControlState())
        canceBtn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), for: UIControlState())
        canceBtn.setTitleColor(UIColor(red: 177/255.0, green: 177/255.0, blue: 177/255.0, alpha: 1), for: UIControlState.highlighted)
        canceBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        canceBtn.addTarget(self, action: #selector(SecAndPrintView.moreBtnAct(_:)), for: UIControlEvents.touchUpInside)
        canceBtn.tag = 0
        
//        canceBtn.layer.cornerRadius = 3
//        canceBtn.layer.masksToBounds = true
//        canceBtn.layer.borderWidth = 0.5
//        canceBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).CGColor
        
        self.addSubview(canceBtn)
        
        
        let saveBtn = UIButton(frame: CGRect(x: rect.width - 80 - 20,y: 50,width: 80,height: 30))
        saveBtn.setTitle("确定", for: UIControlState())
        saveBtn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), for: UIControlState())
        saveBtn.setTitleColor(UIColor(red: 177/255.0, green: 177/255.0, blue: 177/255.0, alpha: 1), for: UIControlState.highlighted)
        
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        saveBtn.addTarget(self, action: #selector(SecAndPrintView.moreBtnAct(_:)), for: UIControlEvents.touchUpInside)
        saveBtn.tag = 1
        
//        saveBtn.layer.cornerRadius = 3
//        saveBtn.layer.masksToBounds = true
//        saveBtn.layer.borderWidth = 0.5
//        saveBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).CGColor
        
        self.addSubview(saveBtn)
        
        
        
        myPickerView.delegate = self
        myPickerView.dataSource = self
        
        myPickerView.selectRow(self.pickerDefaultIndex, inComponent: 0, animated: false)
        
    }
    
    //点击更多按钮
    func moreBtnAct(_ send: UIButton){
        
        let tag = send.tag
        print("点击的是->:\(tag)")

        switch tag {
        case 0:
            print("取消")
            secAndPrintViewValueClosur?(false,tag,0,"cance")
        case 1:
            print("确定")
            
            let secInt = self.myPickerView.selectedRow(inComponent: 0)
            
            let val = self.dataArray[secInt] 
            
            secAndPrintViewValueClosur?(false,tag,secInt,val)
            
        case 2:
            print("更多按钮")
            secAndPrintViewValueClosur?(true,tag,0,"more")
        default:
            break
        }
        
        
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataArray.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let value = self.dataArray[row]
 
        
        return value
    }
    
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
//        
//        var pickerLabel:UILabel!
//        
//        if pickerLabel == nil {
//            
//            pickerLabel = UILabel()
//            
//            pickerLabel.textAlignment = .Center
//            pickerLabel.adjustsFontSizeToFitWidth = true
//            pickerLabel.font = UIFont.systemFontOfSize(25)
//            pickerLabel.textColor = UIColor.whiteColor()
//        }
//        
//        pickerLabel.text = self.pickerView(myPickerView, titleForRow: row, forComponent: component)
//        
//        self.myPickerView.subviews[1].hidden = true
//        self.myPickerView.subviews[2].hidden = true
//        
//        return pickerLabel
//        
//    }
    
    
    
    
    

}
