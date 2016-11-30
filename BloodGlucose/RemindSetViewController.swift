//
//  RemindSetViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/25.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit



//var remindSetValueArray = ["3.9","只提醒一次","7.8","只提醒一次","0","0"]
var remindSetValueArray = ["3.9","15分钟","7.8","15分钟","0","0"]
//是否开启提醒
var isRemind = [true,true]



class RemindSetViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate{

    
    var myTabView: UITableView!
    
    var nameArray = ["低血糖值提醒(mmol/L)","提醒时间间隔","高血糖值提醒(mmol/L)","提醒时间间隔","紧急联络人(电话)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
        self.title = "提醒设置"
        
        self.setNav()
        
        self.setMyTabView()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BaseTabBarView.isHidden = true
        
        BaseTabBarView.isHidden = true

        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        

    }
    
    func setNav(){
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(RemindSetViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
    }
    func someBtnAct(_ send: UIButton){
        switch send.tag {
        case 0:
            self.navigationController!.popViewController(animated: true)
        default:
            break
        }
    }
    
    func setMyTabView(){
        
        myTabView = UITableView(frame: self.view.bounds, style: UITableViewStyle.grouped)
        myTabView.delegate = self
        myTabView.dataSource = self
        
        myTabView.separatorStyle = .none
        
        self.view.addSubview(myTabView)
   
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //MARK:Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0,1:
            let ist = isRemind[section]
            
            if ist {
                return 2
            }else{
                return 0
            }

        default:
            return 1
        }
    }

    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section != 2 {
            return 40 + 49
        }else{
 
            return 40
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: 40 + 49))
        headView.backgroundColor = UIColor.white

        //标题背景
        let titBgView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: 40))
        titBgView.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
        headView.addSubview(titBgView)
 
        let titleLabel = UILabel(frame: CGRect(x: 19,y: 0,width: self.view.frame.size.width - 19,height: 40))
        titleLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        titleLabel.font = UIFont(name: PF_SC, size: 16)
        titleLabel.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
        switch section {
        case 0:
            titleLabel.text = "低血糖提醒"
        case 1:
            titleLabel.text = "高血糖提醒"
        case 2:
            titleLabel.text = "紧急联络人"
        default:
            break
        }
        titBgView.addSubview(titleLabel)
        
        if section != 2 {
            //是否提醒
            let isLabel = UILabel(frame: CGRect(x: 19,y: 40,width: 100,height: 49))
            
            isLabel.text = "是否提醒"
            isLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
            isLabel.font = UIFont(name: PF_SC, size: 16)
            headView.addSubview(isLabel)
            
            
            let switchs = UISwitch(frame: CGRect(x: self.view.frame.size.width - 51 - 23,y: 40 + (49 - 31) / 2,width: 51,height: 31))
            switchs.addTarget(self, action:#selector(RemindSetViewController.stateChanged(_:)), for: UIControlEvents.valueChanged)
            
            let ist = isRemind[section]
            
            switchs.isOn = ist
            
            switchs.tag = section
            
            headView.addSubview(switchs)
        }
        
        
        
        
        return headView
        
    }
    
 
    func stateChanged(_ state: UISwitch){
        
        
        
        if state.isOn {
            print("开启了")
            isRemind[state.tag] = true
  
        }else{
            print("关闭了")
            isRemind[state.tag] = false
            
            if state.tag == 0 { //关闭，则删除历史提醒时间
                UserDefaults.standard.removeObject(forKey: "remindUsersMinTime")
            }else{
                UserDefaults.standard.removeObject(forKey: "remindUsersMaxTime")
            }
            
        }
        //保存提醒开关设置
        UserDefaults.standard.set(isRemind, forKey: "isRemind")
        
        self.myTabView.reloadData()
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 
        if (indexPath as NSIndexPath).section != 2 {
            let ist = isRemind[(indexPath as NSIndexPath).section]
            
            if ist {
                return 49
            }else{
                return 0.01
            }
        }else{
            return 49
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch (indexPath as NSIndexPath).section {
        case 0,1:
            let ddd = "RemindSetCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? RemindSetTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("RemindSetTableViewCell", owner: self, options: nil )?.last as? RemindSetTableViewCell
                
            }
            
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            cell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).section * 2 + (indexPath as NSIndexPath).row]

            cell?.valueLabel.text = remindSetValueArray[(indexPath as NSIndexPath).section * 2 + (indexPath as NSIndexPath).row]
            
            
            return cell!
        default:
            let ddd = "RemindContactCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? RemindContactTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("RemindContactTableViewCell", owner: self, options: nil )?.last as? RemindContactTableViewCell
                
            }
            
            cell?.accessoryType = UITableViewCellAccessoryType.none

            return cell!
        }
        
        
   
    }
    
 
    
    var remindArray = ["低血糖值提醒","提醒时间间隔","高血糖值提醒","提醒时间间隔"]
    
    var secInt = 0
    
    var secCell: RemindSetTableViewCell!
    
    var contactCell: RemindContactTableViewCell!
 
    //时间选择
    
    var timeChooseView: TimeChooseView!
    
    
    
    var timeDataArray: NSMutableArray = ["只提醒一次","15分钟","30分钟","1小时"]
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sec = (indexPath as NSIndexPath).section * 2 + (indexPath as NSIndexPath).row

        self.secInt = sec
        
        switch (indexPath as NSIndexPath).section {
        case 0,1:
            secCell = tableView.cellForRow(at: indexPath) as! RemindSetTableViewCell
            
            if (indexPath as NSIndexPath).row == 0 {
                let value = Float(secCell.valueLabel.text!)!
                
                self.loadScaleView(sec , value: value)
            }else{
                
                if timeChooseView == nil {
                    
                    timeChooseView = TimeChooseView()
                    
                    timeChooseView.valueClourse = self.TimeChooseViewValueClourse
                    
                    var tmpSecIndex = 0
                    
                    switch sec {
                    case 1:
                        tmpSecIndex = Int(remindSetValueArray[4])!
                    case 3:
                        tmpSecIndex = Int(remindSetValueArray[5])!
                    default:
                        break
                    }
                    
                    timeChooseView.initTimeChooseView(self.remindArray[sec], dataArray: self.timeDataArray, secIndex: tmpSecIndex)
                    
                }
                
            }
            
            self.myTabView.reloadData()
            
        default:
            
            contactCell = tableView.cellForRow(at: indexPath) as! RemindContactTableViewCell
            
            contactCell.valueTF.isEnabled = true
            
            contactCell.valueTF.becomeFirstResponder()
            
    
        }
        
        
   
        
    }
    

    var bloodChooseView: BloodChooseView!
    
    
    func loadScaleView(_ index: Int ,value: Float){
        
        
        bloodChooseView = BloodChooseView()
        
        bloodChooseView.touchValue = self.BloodChooseViewTouchValue
        
        bloodChooseView.initBloodChooseView(remindArray[index] ,value: value ,section: index)
    
    }
    //回调
    func BloodChooseViewTouchValue(_ tag: Int ,value: String?)->Void{
        
        
        if self.secCell != nil{
            
            if let vas = value{
                
                print("回调的value->\(vas)")
                
                self.secCell.valueLabel.text = vas
                
                remindSetValueArray[self.secInt] = vas
                
                UserDefaults.standard.set(remindSetValueArray, forKey: "SetRemind")
                
            }
            
        }
        
   
        
    }
    
  
    func TimeChooseViewValueClourse(_ tag: Int,secInt: Int?,value: String?)->Void{
        
        if tag == 1 {
            
            if secCell != nil {
                
                if let val = value {
                    secCell.valueLabel.text = val
                    
                    remindSetValueArray[self.secInt] = val
                    
                    switch self.secInt {
                    case 1:
                        remindSetValueArray[4] = "\(secInt!)"
                    case 3:
                        remindSetValueArray[5] = "\(secInt!)"
                    default:
                        break
                    }

                    UserDefaults.standard.set(remindSetValueArray, forKey: "SetRemind")
                }
                
            }
            
            
        }
        
        if timeChooseView != nil {
            timeChooseView.dismiss()
            
            timeChooseView.removeFromSuperview()
            timeChooseView = nil
            
        }
    
    }
    
    
    
    
}
