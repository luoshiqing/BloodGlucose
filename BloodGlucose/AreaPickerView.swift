//
//  AreaPickerView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class AreaPickerView: UIView ,UIPickerViewDelegate ,UIPickerViewDataSource{

    //回调
    typealias AreaValueClosur = (_ tag: Int,_ province: String,_ city: String,_ area: String)->Void
    var areaViewValueClosur:AreaValueClosur?
    
    
    @IBOutlet weak var canceBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    
    @IBOutlet weak var myPickerView: UIPickerView!
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    //接受数据
    var dataDic = NSDictionary()
    
    
    //省份数组
    var provincesArray = [String]()
    //市区数组
    var cityArray = [String]()
    //地区数组
    var areaArray = [String]()
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        //设置边框和圆角
        self.setView()
        
        //设置按钮
        self.setBtn()
        
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        
        
        
        
            
        for index in 0..<dataDic.count {
            
            let tmp1 = dataDic["\(index)"] as! NSDictionary
            
            let key = tmp1.allKeys.first as! String //省份
            
            self.provincesArray.append(key)
  
            
        }
        
        //第一个省的市区
        let vv = self.dataDic["0"] as! NSDictionary
        let kk = vv.allKeys.first as! String
        
        let sss = (vv[kk] as! NSDictionary).allKeys
        
        for index in 0..<sss.count {
            let vvvvva = ((vv[kk] as! NSDictionary)["\(index)"] as! NSDictionary).allKeys
            let ppppp = vvvvva.first as! String //市区
            print(ppppp)
            
            self.cityArray.append(ppppp)
   
        }
        
        let abc = ((vv[kk] as! NSDictionary)["\(0)"] as! NSDictionary).allKeys.first as! String
        
//        print(abc)
        let vals = ((vv[kk] as! NSDictionary)["\(0)"] as! NSDictionary)[abc] as! NSArray
        
        for index in vals {
            let vvvsss = index as! String
            
            print(vvvsss)
            self.areaArray.append(vvvsss)
            
        }
        
        
        
        
        self.myPickerView.reloadAllComponents()
        
    }
    
    func setBtn(){
        canceBtn.addTarget(self, action: #selector(AreaPickerView.btnAct(_:)), for: UIControlEvents.touchUpInside)
        canceBtn.tag = 0
        
        saveBtn.addTarget(self, action: #selector(AreaPickerView.btnAct(_:)), for: UIControlEvents.touchUpInside)
        saveBtn.tag = 1
        
    }
    func btnAct(_ send:UIButton){

        switch send.tag {
        case 0:
            print("cance")
            self.areaViewValueClosur?(send.tag,"","","")
        case 1:

            let proValue:String = self.provincesArray[myPickerView.selectedRow(inComponent: 0)]
            let cityValue:String = self.cityArray[myPickerView.selectedRow(inComponent: 1)]
            let areaValue:String = self.areaArray[myPickerView.selectedRow(inComponent: 2)]

            self.areaViewValueClosur?(send.tag,proValue,cityValue,areaValue)
            
        default:
            break
        }
        
        
        
    }
    
 
    
    func setView(){
        
        self.canceBtn.layer.cornerRadius = 4
        self.canceBtn.layer.masksToBounds = true
        self.canceBtn.layer.borderWidth = 0.5
        self.canceBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
        
        self.saveBtn.layer.cornerRadius = 4
        self.saveBtn.layer.masksToBounds = true
        self.saveBtn.layer.borderWidth = 0.5
        self.saveBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
    }
    
    
    //picker代理
    //多少列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    //每行多少个
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.provincesArray.count
        case 1:
            return self.cityArray.count
        default:
            return self.areaArray.count
        }
        
    }
    
    //每行什么内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return self.provincesArray[row]
        case 1:
            return self.cityArray[row]
        default:
            return self.areaArray[row]
        }
        
        
        
    }
    
    //记录选择的列
    var selectComponet = 0
    //记录选择的省份 row
    var selectPro = 0
    //记录选择的市区 row
    var selecCity = 0
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(row)-\(component)")

        self.selectComponet = component
        
        switch component {
        case 0: //滑动了省份
            
            if self.selectPro != row {
                self.selectPro = row
                self.getCity(row)
            }
 
        case 1:
            print("...")
            if self.selecCity != row {
                self.selecCity = row
                self.getArea(self.selectPro, row: row)
            }

        case 2:
            print("..*****.")
        default:
            break
        }
        
        
        
        
    }
    
    //MARK:1.滑动第一列时
    func getCity(_ row: Int){
        //获得对应省的市区
        let vv = self.dataDic["\(row)"] as! NSDictionary
        let kk = vv.allValues.first as! NSDictionary
 
        var tmpCityArray = [String]()
        var tmpAreaArray = [String]()
        
        for index in 0..<kk.count {
            let city = (kk["\(index)"] as! NSDictionary).allKeys.first as! String
            
//            print(city)
            tmpCityArray.append(city)
            
            
            
            tmpAreaArray = (kk["\(index)"] as! NSDictionary).allValues.first as! [String]
            
//            print(tmpAreaArray)
   
            
        }
        self.cityArray = tmpCityArray
        self.areaArray = tmpAreaArray
        
        //获得对应市区的地区

        self.myPickerView.reloadComponent(1)
        self.myPickerView.reloadComponent(2)
        
        self.myPickerView.selectRow(0, inComponent: 1, animated: true)
        self.myPickerView.selectRow(0, inComponent: 2, animated: true)
    }
    
    //MARK:2.滑动第二列时
    func getArea(_ selectPro: Int,row: Int){
        //首先拿到对应省份的 数据
        //获得对应省的市区
        let vv = self.dataDic["\(selectPro)"] as! NSDictionary
        let kk = vv.allValues.first as! NSDictionary
        
        var tmpAreaArray = [String]()

        tmpAreaArray = (kk["\(row)"] as! NSDictionary).allValues.first as! [String]

        self.areaArray = tmpAreaArray
        
        self.myPickerView.reloadComponent(2)
        self.myPickerView.selectRow(0, inComponent: 2, animated: true)
    }
    
    
    
    
    
    
}
