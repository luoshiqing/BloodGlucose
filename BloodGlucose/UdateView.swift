//
//  UdateView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/29.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class UdateView: UIView ,UIPickerViewDelegate,UIPickerViewDataSource{

    var dateClosure:dateValueClosur?
    
    @IBOutlet weak var myPickerView: UIPickerView!
    
    @IBOutlet weak var canceBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    
    var dateArray = NSMutableArray()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    
    var pickerDefaultIndex = 0
    
    
    func initSetup(){
        
        
        
        
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        
        
        
        self.myPickerView.selectRow(self.pickerDefaultIndex, inComponent: 0, animated: false)
        
        
        //设置按钮
        self.setBtn()
        
    }
    
    func setBtn(){
        
        self.saveBtn.layer.cornerRadius = 4
        self.saveBtn.layer.masksToBounds = true
        self.saveBtn.layer.borderWidth = 1
        self.saveBtn.layer.borderColor = UIColor.white.cgColor
        
        
        self.canceBtn.layer.cornerRadius = 4
        self.canceBtn.layer.masksToBounds = true
        self.canceBtn.layer.borderWidth = 1
        self.canceBtn.layer.borderColor = UIColor.white.cgColor
        
        

        self.saveBtn.addTarget(self, action: #selector(UdateView.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.saveBtn.tag = 1
        self.canceBtn.addTarget(self, action: #selector(UdateView.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.canceBtn.tag = 0
    }
    
    
    func btnAct(_ send:UIButton){
        
        var value = ""
        var secInt = 0
        
        switch send.tag {
        case 0:
            print("取消")
        case 1:
            //print("确定")
            
            if self.dateArray.count > 0 {
                
                secInt = self.myPickerView.selectedRow(inComponent: 0)
                
                let val = self.dateArray[secInt] as! String
                
                if val.characters.count > 10 {
                    value = (val as NSString).substring(to: 10)
                }
            }
            
  
            
        default:
            break
        }
        
        
        //回调传值
        if self.dateClosure != nil {
            self.dateClosure!(send.tag,secInt,value)
        }
        
        
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dateArray.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let value = self.dateArray[row] as! String
        
        var stri = ""
        
        if value.characters.count > 10 {
            stri = (value as NSString).substring(to: 10)
        }else{
            stri = "错误"
        }
        
        
        
        return stri
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel:UILabel!
        
        if pickerLabel == nil {
            
            pickerLabel = UILabel()
            
            pickerLabel.textAlignment = .center
            pickerLabel.adjustsFontSizeToFitWidth = true
            pickerLabel.font = UIFont.systemFont(ofSize: 25)
            pickerLabel.textColor = UIColor.white
        }
        
        pickerLabel.text = self.pickerView(myPickerView, titleForRow: row, forComponent: component)
        
        self.myPickerView.subviews[1].isHidden = true
        self.myPickerView.subviews[2].isHidden = true
        
        return pickerLabel
        
    }
    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
