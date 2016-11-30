//
//  BloodRecordView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/26.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class BloodRecordView: UIView ,UITableViewDelegate ,UITableViewDataSource{

    //返回控制器
    var backCtr: UIViewController?
    
    //父控制器
    var superCtr: UIViewController?
    
   
    
    
    var myTabView: UITableView!
    
    
    fileprivate let Hsize = (UIScreen.main.bounds.height - 64) / (667 - 64)
    
    fileprivate let Wsize = UIScreen.main.bounds.width / 375
    
    fileprivate let headHeight: CGFloat = 144
    
    fileprivate let myWidth = UIScreen.main.bounds.width
    
    
    fileprivate let titleArray = ["记录时间","血糖时段","添加备注"]
    
    fileprivate var valueArray = ["","",""]
    
    
    fileprivate var upDic = [String:String]()
    
    
    fileprivate var currentDate: Date?
    
    
    //记录血糖数值
    var bloodValue: Float = 0.0
    
    override func draw(_ rect: CGRect) {
        
        
        let dates = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        
        let tmpTime = dateFormatter.string(from: dates)
 
//        let date = (tmpTime as NSString).substring(with: NSRange(0...9))
//        let time = (tmpTime as NSString).substring(with: NSRange(11...15))
        
        let date = (tmpTime as NSString).substring(with: NSRange(location: 0, length: 10))
        let time = (tmpTime as NSString).substring(with: NSRange(location: 11, length: 5))
        

        self.upDic["date"] = date
        self.upDic["time"] = time
        
        self.valueArray[0] = tmpTime
        

        
        myTabView = UITableView(frame: rect, style: UITableViewStyle.grouped)
        
        myTabView.backgroundColor = UIColor.white
        
        myTabView.delegate = self
        myTabView.dataSource = self
        
        myTabView.separatorStyle = .none
        
        
        self.addSubview(myTabView)
        
        
        
        
        
        //底部
        let upHAnd = headHeight * Hsize + 50 * 2 + 5
        
        let downH = rect.height - upHAnd - 64
        
        let downView = UIView(frame: CGRect(x: 0,y: upHAnd,width: rect.width,height: downH))
        downView.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1)
        
        //提交按钮
        let okBtn = UIButton(frame: CGRect(x: (rect.width - 197 * Wsize) / 2,y: downH / 3 * 2 - 37 / 2,width: 197 * Wsize,height: 37))
        okBtn.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        okBtn.setTitle("提交", for: UIControlState())
        okBtn.layer.cornerRadius = 37 / 2
        okBtn.layer.masksToBounds = true
        okBtn.setTitleColor(UIColor.white, for: UIControlState())
        
        okBtn.setTitleColor(UIColor.groupTableViewBackground, for: UIControlState.highlighted)
        
        okBtn.titleLabel?.font = UIFont(name: PF_SC, size: 18)
        
        okBtn.addTarget(self, action: #selector(BloodRecordView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        okBtn.tag = 1
        
        downView.addSubview(okBtn)
        
 
        
        self.myTabView.tableFooterView = downView
        
        
        
    }
    
    func someBtnAct(_ send: UIButton){
        switch send.tag {
        case 1:
            print("提交")
            
            let date = self.upDic["date"]

            let event = self.upDic["event"]
            
            let bloodSugar = self.upDic["bloodSugar"]
            
            
            print("血糖值:\(bloodSugar)")
            
            if bloodSugar == nil {
                let alret = UIAlertView(title: "请选择血糖值", message: "滑动刻度尺即可选择", delegate: nil, cancelButtonTitle: "确定")
                alret.show()
                
                return
            }else{
                
                if bloodSugar == "0.0" && bloodSugar == "0.1" {
                    let alret = UIAlertView(title: "血糖不能选择为0", message: "滑动刻度尺即可选择", delegate: nil, cancelButtonTitle: "确定")
                    alret.show()
                    
                    return
                }
                
                
            }
            
            if date == nil {
                let alret = UIAlertView(title: "请选择时间", message: "", delegate: nil, cancelButtonTitle: "确定")
                alret.show()
                
                return
            }
            
            if event == nil {
                let alret = UIAlertView(title: "请选择时段", message: "", delegate: nil, cancelButtonTitle: "确定")
                alret.show()
                
                return
            }

            
            self.upDic["type"] = "bloodsugar"
            

            
            MyNetworkRequest().submitBloodsugar(self, dic: self.upDic, clourse: { (success) in
                
                isSecBlood = true
                
                if Float(bloodSugar!)! <= 3.9 || Float(bloodSugar!)! >= 6.1 {
                    self.bloodPromptV = BloodPromptView()
                    self.bloodPromptV?.initBloodPromptView(Float(bloodSugar!)!, superCtr: self.superCtr, backCtr: self.backCtr)
                }else{
                    
                    if let ctr = self.backCtr{
                        if self.superCtr != nil{
                            self.superCtr!.navigationController!.popToViewController(ctr, animated: true)
                        }
                    }else{
                        if self.superCtr != nil{
                            self.superCtr!.navigationController!.popViewController(animated: true)
                        }
                    }
    
                }
                
                
                
            })

            
        default:
            break
        }
    }
    
    var bloodPromptV: BloodPromptView?
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //MARK:Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return 0.01
    
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return headHeight * Hsize
        default:
            return 5
        }

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        switch section {
        case 0:
            let headView = UIView(frame: CGRect(x: 0,y: 0,width: myWidth,height: headHeight * Hsize))
            headView.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1)
            
            let scaleView = MyScaleView(frame: CGRect(x: 31,y: (headHeight * Hsize - 100) / 2,width: myWidth - 31 * 2,height: 100))
            scaleView.backgroundColor = UIColor.clear
            
            scaleView.realtimeValue = self.ScaleViewrealtimeValue
            
            scaleView.calculateAndUpdateOffset(self.bloodValue ,animated: false)
            
            headView.addSubview(scaleView)
            
            return headView
            
  
        default:
            let headView = UIView(frame: CGRect(x: 0,y: 0,width: myWidth,height: 5))
            headView.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1)

            return headView
        }
        

        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).section == 2 {
            return 150
        }else{
            return 50
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).section {
        case 2:
            
            let ddd = "BloodTowCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? BloodTowTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("BloodTowTableViewCell", owner: self, options: nil )?.last as? BloodTowTableViewCell
                
            }
            
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            cell?.titleLabel.text = self.titleArray[(indexPath as NSIndexPath).section]
            cell?.textView.text = self.valueArray[(indexPath as NSIndexPath).section]
            
            
            return cell!
        default:
            let ddd = "BloodOneCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? BloodOneTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("BloodOneTableViewCell", owner: self, options: nil )?.last as? BloodOneTableViewCell
                
            }
            
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            cell?.titleLabel.text = self.titleArray[(indexPath as NSIndexPath).section]
            cell?.valueLabel.text = self.valueArray[(indexPath as NSIndexPath).section]
 
            return cell!
        }
        
        
        
    }
    
    var periodTimeArray = ["凌晨","早餐前","早餐后","午餐前","午餐后","晚餐前","晚餐后","睡前","随机"]
    var dateChooseView: MyDateChooseView!
    
    //记录选择的index
    var secCellIndex = 0
    var secOneCell: BloodOneTableViewCell!
    var secTowCell: BloodTowTableViewCell!
    
    var secIndexPath: IndexPath!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.secCellIndex = (indexPath as NSIndexPath).section
        
        self.secIndexPath = indexPath
        
        let value = self.titleArray[(indexPath as NSIndexPath).section]

        print(value)
        
  
        switch (indexPath as NSIndexPath).section {
        case 0:
            
            secOneCell = tableView.cellForRow(at: indexPath) as! BloodOneTableViewCell
            
            dateChooseView = MyDateChooseView()
            dateChooseView.okBtnClourse = self.MyDateChooseViewOkBtnClourse
            
//            dateChooseView.initMyDateChooseView(value, dataArray: nil,isDate: true,model: nil)
            
            dateChooseView.initMyDateChooseView(value, dataArray: nil, isDate: true, currentDate: self.currentDate, model: nil)
            
            self.addSubview(dateChooseView)
            
            
            self.myTabView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            
        case 1:
            
            secOneCell = tableView.cellForRow(at: indexPath) as! BloodOneTableViewCell
            
            dateChooseView = MyDateChooseView()
            
            dateChooseView.okBtnClourse = self.MyDateChooseViewOkBtnClourse
            
//            dateChooseView.initMyDateChooseView(value, dataArray: self.periodTimeArray,isDate: false,model: nil)
            
            dateChooseView.initMyDateChooseView(value, dataArray: self.periodTimeArray, isDate: false, currentDate: nil, model: nil)
            
            self.addSubview(dateChooseView)
            
            
            self.myTabView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            
        default:
            secTowCell = tableView.cellForRow(at: indexPath) as! BloodTowTableViewCell
            
            secTowCell.textView.isUserInteractionEnabled = true
            secTowCell.textView.isEditable = true
            
            secTowCell.textClourse = self.BloodTowTableViewCellTextClourse
            
            secTowCell.textView.becomeFirstResponder()
            
            
        }
        

        
        
        
        
    }
    
    
    
    //选择回调
    func MyDateChooseViewOkBtnClourse(_ value: String)->Void{
        
        switch self.secCellIndex {
        case 0,1:
            
            print(value)
            
           
            
            
            
            secOneCell.valueLabel.text = value
            
            self.valueArray[self.secCellIndex] = value

            self.myTabView.reloadRows(at: [self.secIndexPath], with: UITableViewRowAnimation.none)

            
            if self.secCellIndex == 0 {

                let formatter = DateFormatter()
                
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                let tmpDate = formatter.date(from: value)
                
                self.currentDate = tmpDate
                
                
                let date = (value as NSString).substring(with: NSRange(location: 0, length: 10))
                let time = (value as NSString).substring(with: NSRange(location: 11, length: 5))

                print(date,time)
                
                self.upDic["date"] = date
                self.upDic["time"] = time
            }else{
                
                
                self.upDic["event"] = self.getEventNum(value)
            }
  
        default:
            break
        }
    
    }
    
    func getEventNum(_ value: String) -> String{
        
        
        var tmm = "0"
        
        for item in 0..<self.periodTimeArray.count {
            
            let tmpValue = self.periodTimeArray[item]
            
            if tmpValue == value {
                
                tmm = "\(item)"
                
                break
            }
   
        }
        
        print(tmm)
        return tmm
        
    }
    
    
    
    
    
    
    //血糖回调
    func ScaleViewrealtimeValue(_ value: String)->Void{
//        print(value)
        
        self.bloodValue = Float(value)!
        
        if value != "0.0" {
            upDic["bloodSugar"] = value
        }
   
    }
    
    //备注回调
    func BloodTowTableViewCellTextClourse(_ value: String)->Void{
        
        
        print("备注回调->\(value)")
        self.upDic["content"] = value
    }
    
    
 

}
