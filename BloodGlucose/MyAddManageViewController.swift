//
//  MyAddManageViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyAddManageViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate{

    
    
    var myTabView:UITableView!
    
    
    var nameArray = ["收货人:","联系电话:","所在地区:","详细地址:","设为默认地址"]
    var valueArray = ["","","","","",]
    var placArray = ["输入姓名","输入手机号码","选择地区","输入街道名称","",]
    
    
    
    //---是否为编辑状态
    var isEdit = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isEdit {
            self.title = "编辑地址"
        }else{
            self.title = "添加新地址"
        }
        
        self.view.backgroundColor = UIColor.white
        
        //
        self.setNav()
        //
        self.setTabView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    func setNav(){
        
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(MyAddManageViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 1
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
        
        if self.isEdit == false {
            //右
            let rightBtn = UIBarButtonItem(title:"添加", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyAddManageViewController.someBtnAct(_:)))
            rightBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
            rightBtn.tag = 2
            self.navigationItem.rightBarButtonItem = rightBtn
        }else{
            //编辑状态
            let rightBtn = UIBarButtonItem(title:"修改", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyAddManageViewController.someBtnAct(_:)))
            rightBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
            rightBtn.tag = 3
            self.navigationItem.rightBarButtonItem = rightBtn
        }
        
        
    }
    
    func someBtnAct(_ send:UIButton){
        switch send.tag {
        case 1:
            
            let actionSheet = UIAlertController(title: "是否放弃本次编辑", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
                
                self.navigationController!.popViewController(animated: true)

            }))
            actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
            
            
            
        case 2:
            print("添加")
            if self.myAddManageCell != nil {
                self.myAddManageCell.valueTF.resignFirstResponder()
            }
            if self.addDetailCell != nil{
                self.addDetailCell.valueTV.resignFirstResponder()
            }
            print(self.uploadADMDic)
            self.addId(self.uploadADMDic)
        case 3:
            print("修改")
            if self.myAddManageCell != nil {
                self.myAddManageCell.valueTF.resignFirstResponder()
            }
            if self.addDetailCell != nil{
                self.addDetailCell.valueTV.resignFirstResponder()
            }

            print(self.uploadADMDic)
            
            self.editId(self.uploadADMDic)
            
        default:
            break
        }
    }
    
    var finish:JGProgressHUD!
    //添加地址
    func addId(_ dic:[String:String]){
        
        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = "添加中.."
        self.finish.show(in: self.view, animated: true)

        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/ressmanage.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        //--------------------------

        var dicDPost = [String:String]()
        
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            
            "addId":"15959",
            "contzipcode":"100010",//邮编
            "province":"123456",
            "city":"123457",
            "county":"123458",

            "default":"0"
        ]

        var endDic = [AnyHashable: Any]()
//        endDic.addEntries(from: dic)
//        endDic.addEntries(from: dicDPost)
        
        for (key,value) in dic {
            endDic.updateValue(value, forKey: key)
        }
        for (key,value) in dicDPost {
            endDic.updateValue(value, forKey: key)
        }
        

        RequestBase().doPost(reqUrl, endDic, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("json:\(json)")
            let tmpData:String = json["message"].stringValue
            
            if tmpData == "添加成功"{
                print("添加成功")
                
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "添加成功"
                self.finish.dismiss(afterDelay: 0.5, animated: true)
                
                BGNetwork().delay(0.51, closure: { () -> () in
                    self.navigationController!.popViewController(animated: true)
                })
                
            }else{
                print("添加失败")
                
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "添加失败"
                self.finish.dismiss(afterDelay: 0.5, animated: true)
            }
            
            }, failure: { () -> Void in
                
                print("false")
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "网络错误"
                self.finish.dismiss(afterDelay: 0.5, animated: true)
        })
        
        
        
    }
    //修改
    func editId(_ dic:[String:String]){

        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = "修改中..."
        self.finish.show(in: self.view, animated: true)
        
  
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/ressmanage.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        //--------------------------
        
        let dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "contzipcode":"100000",//邮编
            "province":"200000",
            "city":"300000",
            "county":"400000",
            "default":"0"]
        
        var endDic = [AnyHashable: Any]()
//        endDic.addEntries(from: dic)
//        endDic.addEntries(from: dicDPost)
        
        for (key,value) in dic {
            endDic.updateValue(value, forKey: key as AnyHashable)
        }
        for (key,value) in dicDPost {
            endDic.updateValue(value, forKey: key as AnyHashable)
        }
        
        RequestBase().doPost(reqUrl, endDic, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("json:\(json)")

            self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.finish.textLabel.text = "修改成功"
            self.finish.dismiss(afterDelay: 0.5, animated: true)
            
            BGNetwork().delay(0.51, closure: { () -> () in
                self.navigationController!.popViewController(animated: true)
            })
            
            
            }, failure: { () -> Void in
                
                print("false")
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "网络错误"
                self.finish.dismiss(afterDelay: 1.1, animated: true)
        })
        
        
    }
 
    
    func setTabView(){
        
        self.myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height - 64 + 49))
        self.view.addSubview(self.myTabView)
        
        self.myTabView.delegate = self
        self.myTabView.dataSource = self
        
 
        
        self.myTabView.tableFooterView = UIView()
    }
    
    
    //tableView 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == 3 {
            return 81
        }else{
            return 49
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let TFvalue = self.valueArray[(indexPath as NSIndexPath).row]
        
        
        switch (indexPath as NSIndexPath).row {
        case 0...2:
            let ddd = "MyAddManageCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? MyAddManageTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("MyAddManageTableViewCell", owner: self, options: nil )?.last as? MyAddManageTableViewCell
                
            }
            
            cell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row]
            
            
            if TFvalue.isEmpty {
                cell?.valueTF.placeholder = self.placArray[(indexPath as NSIndexPath).row]
            }else{
                cell?.valueTF.text = TFvalue
            }
            
            
            
            if (indexPath as NSIndexPath).row != 2 {
                //右边箭头
                cell?.accessoryType = UITableViewCellAccessoryType.none
            }else{
                cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            
            
            return cell!
        case 3:
            let ddd = "AddDetailCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? AddDetailTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("AddDetailTableViewCell", owner: self, options: nil )?.last as? AddDetailTableViewCell
                
            }
            
            cell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row]
            
            
            if TFvalue.isEmpty {
                cell?.valueTV.text = self.placArray[(indexPath as NSIndexPath).row]
            }else{
                cell?.valueTV.text = TFvalue
            }
            
            
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            return cell!
        default:
            let ddd = "AddDefualtCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? AddDefualtTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("AddDefualtTableViewCell", owner: self, options: nil )?.last as? AddDefualtTableViewCell
                
            }
            
            cell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row]
            
            
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            return cell!
        }
        
        
    }
    
    //0..2cell
    var myAddManageCell:MyAddManageTableViewCell!
    //3 cell
    var addDetailCell:AddDetailTableViewCell!
    //4 cel
    var addDefualtCell:AddDefualtTableViewCell!
    //记录选择的cell
    var selectCellIndexPathRow = 0
    
    
    var areaPickerView:AreaPickerView!
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        print("点击了\((indexPath as NSIndexPath).row)")
        switch (indexPath as NSIndexPath).row {
        case 0...2:
            
            if (indexPath as NSIndexPath).row != 2 {
                IQKeyboardManager.sharedManager().enableAutoToolbar = false
                
                
                if self.myAddManageCell != nil {
                    self.myAddManageCell.valueTF.resignFirstResponder()
                }
                
                self.myAddManageCell = tableView.cellForRow(at: indexPath) as! MyAddManageTableViewCell
                
                self.myAddManageCell.textFiledValueClosur = self.textFValueClosur
                
                self.myAddManageCell.valueTF.isEnabled = true
                self.myAddManageCell.valueTF.becomeFirstResponder()
            }else{
                print("选择地址")
                let areaPlistPath = Bundle.main.path(forResource: "area", ofType: "plist")
                
                let dataDic:NSDictionary = NSDictionary(contentsOfFile: areaPlistPath!)!
                
                if self.myAddManageCell != nil {
                    self.myAddManageCell.valueTF.resignFirstResponder()
                }
                self.myAddManageCell = tableView.cellForRow(at: indexPath) as! MyAddManageTableViewCell

                
                //加载地区选择背景视图
                self.loadAreaPickerBgView()
                
                //加载地区选择picker
                self.loadAreaPickerView(dataDic)
   
                
            }
            
            

        case 3:
            
            self.addDetailCell = tableView.cellForRow(at: indexPath) as! AddDetailTableViewCell
            
            self.addDetailCell.textViewValueClosur = self.textVValueClosur
            
            self.addDetailCell.isFirstEdit = self.textViewisFirstEdit
            self.addDetailCell.valueTV.isEditable = true
            self.addDetailCell.valueTV.isUserInteractionEnabled = true
            self.addDetailCell.valueTV.becomeFirstResponder()
            
        case 4:
            self.addDefualtCell = tableView.cellForRow(at: indexPath) as! AddDefualtTableViewCell
        default:
            break
        }
        self.selectCellIndexPathRow = (indexPath as NSIndexPath).row
        
    }
    //textView是否为第一次编辑
    var textViewisFirstEdit = true
    
    
    var areaPickerBgView:UIView!
    func loadAreaPickerBgView(){
        if self.areaPickerBgView == nil {
            self.areaPickerBgView = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height - 64))
            self.areaPickerBgView.backgroundColor = UIColor.clear
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(MyAddManageViewController.closeAreaView))
            self.areaPickerBgView.addGestureRecognizer(tap)
            
            self.view.addSubview(self.areaPickerBgView)
        }
    }
    
    
    func loadAreaPickerView(_ dataDic: NSDictionary){
        if self.areaPickerView == nil {
            self.areaPickerView = Bundle.main.loadNibNamed("AreaPickerView", owner: nil, options: nil)?.last as! AreaPickerView
            self.areaPickerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 240 - 64 , width: UIScreen.main.bounds.width, height: 240)
            
            self.areaPickerView.areaViewValueClosur = self.areaValueClosur
            
            self.areaPickerView.dataDic = dataDic
            self.view.addSubview(self.areaPickerView)
     
        }
    }
    
    func closeAreaView(){
        if self.areaPickerBgView != nil {
            self.areaPickerBgView.removeFromSuperview()
            self.areaPickerBgView = nil
        }
        if self.areaPickerView != nil {
            self.areaPickerView.removeFromSuperview()
            self.areaPickerView = nil
        }
    }
    
    

    
    
    var uploadADMDic = [String:String]()
    
    //textf回调值
    func textFValueClosur(_ value: String)->Void{
        print("回调的值:\(value)")
        
        print(self.selectCellIndexPathRow)
        
        self.valueArray[self.selectCellIndexPathRow] = value
        switch self.selectCellIndexPathRow {
        case 0:
            self.uploadADMDic["consignee"] = value
        case 1:
            self.uploadADMDic["phone"] = value
        default:
            break
        }
  
    }
    //textView回调
    func textVValueClosur(_ value: String)->Void{
        print(self.selectCellIndexPathRow)
        
        self.textViewisFirstEdit = false
        
        self.uploadADMDic["contaddr"] = value
        
        print("回调的值:\(value)")
    }
    
    func areaValueClosur(_ tag: Int,province: String,city: String,area: String)->Void{
        print("地区选择回调:\(tag) - \(province) -\(city) - \(area)")
        
        let value = province + city + area
        self.valueArray[self.selectCellIndexPathRow] = value
        self.myAddManageCell.valueTF.text = value
        
        self.uploadADMDic["province_name"] = province
        self.uploadADMDic["city_name"] = city
        self.uploadADMDic["county_name"] = area
        
        
        
        self.closeAreaView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
