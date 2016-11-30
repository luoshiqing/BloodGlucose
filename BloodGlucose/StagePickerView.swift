//
//  StagePickerView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/6.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class StagePickerView: UIView ,UIPickerViewDelegate ,UIPickerViewDataSource{

    
    var dateClosure:dateValueClosur?
    
    @IBOutlet weak var titLabel: UILabel!
    
    @IBOutlet weak var myPickerView: UIPickerView!
    
    
    @IBOutlet weak var canceBtn: UIButton!
    
    @IBOutlet weak var okBtn: UIButton!
    
    
    
    
    
    
    var dataArray:NSMutableArray!
    var titStr:String!
    //设置初始选择位置
    var pickerDefaultIndex = 0
    
    override func draw(_ rect: CGRect) {
        
        //设置代理
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        //设置初始值
        self.myPickerView.selectRow(self.pickerDefaultIndex, inComponent: 0, animated: false)
        
        //设置按钮
        self.setBtn()
        
        //标题赋值
        if self.titStr != nil{
            self.titLabel.text = self.titStr
        }
        
    }
    
    func setBtn(){
        
        self.canceBtn.layer.cornerRadius = 4
        self.canceBtn.layer.masksToBounds = true
        self.canceBtn.layer.borderWidth = 0.5
        self.canceBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
        
        
        self.okBtn.layer.cornerRadius = 4
        self.okBtn.layer.masksToBounds = true
        self.okBtn.layer.borderWidth = 0.5
        self.okBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
        
        
        
        self.okBtn.addTarget(self, action: #selector(StagePickerView.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.okBtn.tag = 1
        self.canceBtn.addTarget(self, action: #selector(StagePickerView.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.canceBtn.tag = 0
    }
    //点击事件
    func btnAct(_ send:UIButton){

        var secInt = 0
        var value = ""
        
        
        switch send.tag {
        case 0:
            print("取消")
            
            secInt = self.myPickerView.selectedRow(inComponent: 0)
            value = self.dataArray[secInt] as! String
            
        default:
            print("确定")
            secInt = self.myPickerView.selectedRow(inComponent: 0)
            value = self.dataArray[secInt] as! String
            
//            print(secInt,value)
        }
        //回调传值
        if self.dateClosure != nil {
            self.dateClosure!(send.tag,secInt,value)
        }
        
    }
    
  
    
    //代理
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.dataArray != nil {
            return self.dataArray.count
        }else{
            return 0
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.dataArray != nil {
            let value = self.dataArray[row] as! String
            return value
        }else{
            return ""
        }
        
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
//            pickerLabel.textColor = UIColor(red: 17/255.0, green: 17/255.0, blue: 17/255.0, alpha: 1)
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
