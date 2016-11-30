//
//  MyInfViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/31.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyInfViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate ,DateViewDelegate ,InfSexTableViewCellDelegate ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    enum SelectedType {
        case height,weight,abdomen,illness,workType
    }
    
    
    
    
    var myTabView:UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "完善资料"
        self.view.backgroundColor = UIColor.white
        
        //初始化数据
        self.initData()
        
        
        //定制导航栏
        self.setNav()
        
        //tabView
        self.setMyTabView()
        
        //去掉分割线
        self.myTabView.separatorStyle = UITableViewCellSeparatorStyle.none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        BaseTabBarView.isHidden = true
        CAGradientLayerEXT().animation(false)

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        var frame = self.navigationController?.navigationBar.frame
        frame?.origin.x = 0
        self.navigationController?.navigationBar.frame = frame!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        var frame = self.navigationController?.navigationBar.frame
        frame?.origin.x = 0
        self.navigationController?.navigationBar.frame = frame!
        
        
        self.getInforMation()
     
    }
    
    var getInfHUD:JGProgressHUD!
    func getInforMation(){
        
        self.getInfHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.getInfHUD.textLabel.text = "加载中.."
        self.getInfHUD.show(in: self.view, animated: true)
        
        
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/userdata.jsp?"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
        ]
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in

            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            
            print(json)

            self.getInfHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.getInfHUD.textLabel.text = "加载成功"
            self.getInfHUD.dismiss(afterDelay: 0.5, animated: true)
            
            
            
            
            if let tmpData:NSDictionary = json["data"].dictionaryObject as NSDictionary?{

                //头像
                if let iconurl = tmpData.value(forKey: "iconurl") as? String{
                    self.valueArray[0] = iconurl
//                    self.uploadDic
                }
                //昵称
                if let nickname = tmpData.value(forKey: "nickname") as? String{
                    self.valueArray[1] = nickname
                    self.uploadDic["nickname"] = nickname
                }
                //真实姓名
                if let realname = tmpData.value(forKey: "realname") as? String{
                    self.valueArray[2] = realname
                    self.uploadDic["realname"] = realname
                }
                //性别
                if let sex = tmpData.value(forKey: "sex") as? Int{
                    self.valueArray[3] = "\(sex)"
                    self.uploadDic["sex"] = "\(sex)"
                }
                //手机号
                if let mobile = tmpData.value(forKey: "mobile") as? String{
                    self.valueArray[4] = mobile
                    self.uploadDic["mobile"] = mobile
                }
                //电子邮件
                if let mail = tmpData.value(forKey: "mail") as? String{
                    self.valueArray[5] = mail
                    self.uploadDic["mail"] = mail
                }
                //出生日期
                if let birth = tmpData.value(forKey: "birth") as? String{
                    self.valueArray[6] = birth
                    self.uploadDic["birth"] = birth
                }
                //身高
                if let heigh = tmpData.value(forKey: "heigh") as? Int{
                    self.valueArray[7] = "\(heigh)"
                    self.uploadDic["heigh"] = "\(heigh)"
                }
                //体重
                if let weight = tmpData.value(forKey: "weight") as? Int{
                    self.valueArray[8] = "\(weight)"
                    self.uploadDic["weight"] = "\(weight)"
                }
                //腹围
                if let abdomen = tmpData.value(forKey: "abdomen") as? Int{
                    self.valueArray[9] = "\(abdomen)"
                    self.uploadDic["abdomen"] = "\(abdomen)"
                }
                //病情
                if let stype = tmpData.value(forKey: "stype") as? Int{
                    self.valueArray[10] = "\(stype)"
                    self.uploadDic["stype"] = "\(stype)"
                }
                //工作类型
                if let worktype = tmpData.value(forKey: "worktype") as? Int{
                    self.valueArray[11] = "\(worktype)"
                    self.uploadDic["worktype"] = "\(worktype)"
                }
      
                
            }
            
           
            
            self.myTabView.reloadData()
            
            }, failure: { () -> Void in
                
                print("false")
                
                self.getInfHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.getInfHUD.textLabel.text = "网络错误"
                self.getInfHUD.dismiss(afterDelay: 0.5, animated: true)
                
        })
    }
    
    var saveFF:JGProgressHUD!
    //MARK:提交填写信息
    func addUserInfoJsp(_ dataDic:NSDictionary){
        
        self.saveFF = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.saveFF.textLabel.text = "保存中..."
        self.saveFF.show(in: self.view, animated: true)
        
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/adduserinfo.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        
        
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
        ]
        
        var dicc = [AnyHashable: Any]()
        
//        dicc.addEntries(from: dataDic as! [AnyHashable: Any])
//        dicc.addEntries(from: dicDPost as! [AnyHashable: Any])
//        print(dicc)

        for (key,value) in dataDic {
            dicc.updateValue(value, forKey: key as! AnyHashable)
        }
        for (key,value) in dicDPost {
            dicc.updateValue(value, forKey: key as! AnyHashable)
        }
        
        
        
        RequestBase().doPost(reqUrl, dicc, success: { (res: Any?) in
            //            print("\(res)")
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
            
            
            if let tmpData:Int = json["code"].int{
                
                if (tmpData == 1){
                    //成功
                    
                    self.saveFF.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveFF.textLabel.text = "修改成功"
                    self.saveFF.dismiss(afterDelay: 0.5, animated: true)
                    
                    if let dddic = json["data"].dictionaryObject{
     
                        if let datamuch1 = dddic["datamuch"] as? String{

                            datamuch = datamuch1
                            
                        }
                        if let iconurl1 = dddic["iconurl"] as? String{

                            iconurl = iconurl1
                            
                        }
                        
                        
                    }
                    
                    
//                    iconurl iconurl, name: nickname, progress: datamuch
                    
                    
                    
                    BGNetwork().delay(0.51, closure: { () -> () in

//                        XXXOOO = true
                        self.navigationController!.popViewController(animated: true)
                    })
                    
                    
                }else{
                    //失败
                    
                    self.saveFF.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveFF.textLabel.text = "修改失败"
                    self.saveFF.dismiss(afterDelay: 0.5, animated: true)
                    
                    let alertView:UIAlertView = UIAlertView(title: "温馨提示", message: "修改失败了", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }
                
            }
            
            
            
            }, failure: { () -> Void in
                
                print("RequestBase------false")
                self.saveFF.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveFF.textLabel.text = "网络错误"
                self.saveFF.dismiss(afterDelay: 0.5, animated: true)
                
        })
        
    }
    
    
    
    func initData(){
        for _ in 0...11 {
            self.valueArray.append("")
        }
    }
    
    
    func setNav(){
        
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(MyInfViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 1
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        //右
        let rightBtn = UIBarButtonItem(title:"保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyInfViewController.someBtnAct(_:)))
        rightBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
        rightBtn.tag = 2
        self.navigationItem.rightBarButtonItem = rightBtn
        
    }
    //MARK:### 按钮点击事件
    func someBtnAct(_ send:UIButton){
        
        switch send.tag {
        case 1:
            //返回
            self.navigationController!.popViewController(animated: true)
        case 2:
            print("保存啦")
            
            if self.selectdePickerCell != nil {
                self.selectdePickerCell.inforTF.resignFirstResponder()
//                self.view.becomeFirstResponder()
                
            }
            
//            print(self.uploadDic)
          self.addUserInfoJsp(self.uploadDic as NSDictionary)
            
            
        default:
            break
        }
  
    }
    
    func setMyTabView(){

        self.myTabView = UITableView(frame: CGRect( x: 0, y: 0,width: self.view.frame.size.width ,height: self.view.frame.size.height - 64))
        
        self.myTabView.delegate = self
        self.myTabView.dataSource = self
        
        self.view.addSubview(self.myTabView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:###tabView代理
    //有多少分组
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    //每个分组有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0,4:
            return 3
        default:
            return 2
        }

    }
    
    //每个分组的头高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0.001
        }else{
            return 10.0
        }
   
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).section == 0 {
            
            if (indexPath as NSIndexPath).row == 0 {
                return 104
            }else{
                return 49
            }

        }else{
            return 49
        }

    }

    var nameArray = ["头像","昵称","真实姓名","性别","手机号","电子邮件","出生日期","身高","体重","腹围","病情","工作类型"]
    var placeholderArray = ["头像","输入昵称","输入姓名","性别","输入手机号码","输入邮箱","选择日期","选择身高","选择体重","选择腹围","选择病况","选择工作类型"]
    //显示的数组
    var valueArray = [String]()
    //MARK:要上传的字典
    var uploadDic = [String:String]()
    
    
    var imgState:Bool = false //false 为选择网络图片
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let MationOneCell = "MationOneCell"
        var Mationcell = tableView.dequeueReusableCell(withIdentifier: MationOneCell) as? MationOneTableViewCell
        
        
        
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            if (indexPath as NSIndexPath).row == 0 {
                
                let ddd = "InfSection1Cell"
                var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? InfSection1TableViewCell
                if cell == nil
                {
                    cell = Bundle.main.loadNibNamed("InfSection1TableViewCell", owner: self, options: nil )?.last as? InfSection1TableViewCell
                    
                }
                
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                
                cell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row]
                
                let imgurl = self.valueArray[(indexPath as NSIndexPath).row]
                if !imgurl.characters.isEmpty {
                    if (self.imgState == false){
 
                        let imgurl:URL = URL(string: imgurl)!

                        cell?.imgView.sd_setImage(with: imgurl, placeholderImage: UIImage(named: "menuPhto.png"))

                        
                    }else{
                        if(self.phtoImage != nil){
                            cell?.imgView.image = self.phtoImage
                        }
                    }

                }
   

                return cell!
  
                
            }else{
                
                if Mationcell == nil
                {
                    Mationcell = Bundle.main.loadNibNamed("MationOneTableViewCell", owner: self, options: nil )?.last as? MationOneTableViewCell
                    
                }
                
                if (indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == 2 {
                    Mationcell?.sepView.isHidden = true
                }else{
                    Mationcell?.sepView.isHidden = false
                }
                
                Mationcell?.inforTF.isEnabled = false
                
                Mationcell?.selectionStyle = UITableViewCellSelectionStyle.none
                
                Mationcell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row]
                
                
                let value:String = self.valueArray[(indexPath as NSIndexPath).row]
                
                if value.characters.isEmpty {
                    Mationcell?.inforTF.placeholder = self.placeholderArray[(indexPath as NSIndexPath).row]
                }else{
                    Mationcell?.inforTF.text = value
                }

                return Mationcell!
                
                
            }
        case 1:
            
            if (indexPath as NSIndexPath).row == 0{ //性别
                let ddd = "InfSexCell"
                var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? InfSexTableViewCell
                if cell == nil
                {
                    cell = Bundle.main.loadNibNamed("InfSexTableViewCell", owner: self, options: nil )?.last as? InfSexTableViewCell
                    
                }
                
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                
                cell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row + 3]
                
                //设置代理
                cell?.delegate = self
                
                let nameValue = self.valueArray[(indexPath as NSIndexPath).row + 3]
                
                switch nameValue {
                case "0": //女
                    print("女")
                    cell?.womenImgView.image = UIImage(named: "menuwomen")
                    cell?.womenLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
                    
                    cell?.manImgView.image = UIImage(named: "menuMan")
                    cell?.manLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
                default:
                    print("男")
                    cell?.womenImgView.image = UIImage(named: "menuwomenA")
                    cell?.womenLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
                    
                    cell?.manImgView.image = UIImage(named: "menuManL")
                    cell?.manLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
                }

                return cell!
                
            }else{//手机号
                
                if Mationcell == nil
                {
                    Mationcell = Bundle.main.loadNibNamed("MationOneTableViewCell", owner: self, options: nil )?.last as? MationOneTableViewCell
                    
                }
                Mationcell?.inforTF.isEnabled = false
                
                Mationcell?.sepView.isHidden = true

                Mationcell?.selectionStyle = UITableViewCellSelectionStyle.none
                
                Mationcell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row + 3]
                
                let value:String = self.valueArray[(indexPath as NSIndexPath).row + 3]
                if value.characters.isEmpty {
                    Mationcell?.inforTF.placeholder = self.placeholderArray[(indexPath as NSIndexPath).row + 3]
                }else{
                    Mationcell?.inforTF.text = value
                }

                
                return Mationcell!
            }
  
            
        default:
            if Mationcell == nil
            {
                Mationcell = Bundle.main.loadNibNamed("MationOneTableViewCell", owner: self, options: nil )?.last as? MationOneTableViewCell
                
            }
            Mationcell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            //禁止textf点击
            Mationcell?.inforTF.isEnabled = false
            
            switch (indexPath as NSIndexPath).section {
            case 2:

                if (indexPath as NSIndexPath).row == 1{ //出生日期
                    Mationcell?.sepView.isHidden = true
                }else{//电子邮件
                    Mationcell?.sepView.isHidden = false
                }
                
                Mationcell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row + 5]
                
                let value:String = self.valueArray[(indexPath as NSIndexPath).row + 5]
                if value.characters.isEmpty {
                    Mationcell?.inforTF.placeholder = self.placeholderArray[(indexPath as NSIndexPath).row + 5]
                }else{
                    Mationcell?.inforTF.text = value
                }
            case 3:
                if (indexPath as NSIndexPath).row == 1{
                    Mationcell?.sepView.isHidden = true
                }else{
                    Mationcell?.sepView.isHidden = false
                }
                
                
                Mationcell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row + 7]
                let value:String = self.valueArray[(indexPath as NSIndexPath).row + 7]
                if value.characters.isEmpty {
                    Mationcell?.inforTF.placeholder = self.placeholderArray[(indexPath as NSIndexPath).row + 7]
                }else{
                    Mationcell?.inforTF.text = value
                }
               
            default:
                
                
               
                
                let value:String = self.valueArray[(indexPath as NSIndexPath).row + 9]

                Mationcell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row + 9]
                
                switch (indexPath as NSIndexPath).row {
                case 0:
                    Mationcell?.sepView.isHidden = false
 
                    
                    if value.characters.isEmpty {
                        Mationcell?.inforTF.placeholder = self.placeholderArray[(indexPath as NSIndexPath).row + 9]
  
                    }else{
                        Mationcell?.inforTF.text = value
                    }
                case 1:
                    Mationcell?.sepView.isHidden = false

                    if value.characters.isEmpty {
                        Mationcell?.inforTF.placeholder = self.placeholderArray[(indexPath as NSIndexPath).row + 9]
                    }else{
                        
                        
                        let tmp = HealthService().bloodTypeCaseNumToStr(value)
                        print(tmp)
                        Mationcell?.inforTF.text = tmp
                        
                        
//                        switch value {
//                        case "0":
//                            Mationcell?.inforTF.text = "未诊断"
//                        case "1":
//                            Mationcell?.inforTF.text = "妊娠糖尿病患者"
//                        case "2":
//                            Mationcell?.inforTF.text = "2型糖尿病"
//                        case "3":
//                            Mationcell?.inforTF.text = "糖前高危"
//                        case "4":
//                            Mationcell?.inforTF.text = "1型糖尿病"
//                        case "5":
//                            Mationcell?.inforTF.text = "确诊人群"
//                        default:
//                            break
//                        }
                    }
                    
                default:

                    Mationcell?.sepView.isHidden = true

                    if value.characters.isEmpty {
                        Mationcell?.inforTF.placeholder = self.placeholderArray[(indexPath as NSIndexPath).row + 9]
                    }else{
                        
                        switch value {
                        case "0":
                            Mationcell?.inforTF.text = "轻体力(办公职员、教师)"
                        case "1":
                            Mationcell?.inforTF.text = "中体力(学生、司机)"
                        case "2":
                            Mationcell?.inforTF.text = "重体力(农民工、搬运工)"
                        default:
                            break
                        }
                    }
                    
                    
                    
                }
 
               
                

            }
            
            
            
            return Mationcell!
            
        }

        
    }
    //记录选择的cell
    var selectedIndexPathRow = 0
    
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print((indexPath as NSIndexPath).section,(indexPath as NSIndexPath).row)
        
        switch (indexPath as NSIndexPath).section {
        case 0:

            if (indexPath as NSIndexPath).row != 0 {

                if (indexPath as NSIndexPath).row == 1 {
                    self.selectedIndexPathRow = 1
                    print("昵称")
                }else{
                    self.selectedIndexPathRow = 2
                    print("姓名")
                }

                let cell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
                
                cell.textFiledValueClosure = self.textFiledValueClosur

                cell.inforTF.isEnabled = true
                cell.inforTF.becomeFirstResponder()
                self.selectdePickerCell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
            }else{
                print("相册")
                self.selectedIndexPathRow = 0
                
                self.phtoCell = tableView.cellForRow(at: indexPath) as! InfSection1TableViewCell
                
                if self.selectdePickerCell != nil {
                    self.selectdePickerCell.inforTF.resignFirstResponder()
                }
                self.phtoSelecOr()
                
            }
        case 1:
            if (indexPath as NSIndexPath).row == 0 {
                print("性别")
                self.selectedIndexPathRow = 3
//                let cell = tableView.cellForRowAtIndexPath(indexPath) as! InfSexTableViewCell
//                cell.delegate = self
  
                
            }else{
                print("手机号")
                self.selectedIndexPathRow = 4
                let cell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
                
                cell.textFiledValueClosure = self.textFiledValueClosur
                
                cell.inforTF.isEnabled = true
                cell.inforTF.becomeFirstResponder()
                self.selectdePickerCell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
            }
        case 2:
            if (indexPath as NSIndexPath).row == 0 {
                print("电子邮件")
                self.selectedIndexPathRow = 5
                let cell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
                
                cell.textFiledValueClosure = self.textFiledValueClosur
                
                cell.inforTF.isEnabled = true
                cell.inforTF.becomeFirstResponder()
            }else{
                print("选择出生日期")
                self.selectedIndexPathRow = 6
                self.loadDateView("出生日期")
            }
            self.selectdePickerCell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
        case 3:
            
            if (indexPath as NSIndexPath).row == 0 {
                print("身高")
                self.selectedIndexPathRow = 7
                self.loadDataAndPickerView(SelectedType.height)
                
            }else{
                print("体重")
                self.selectedIndexPathRow = 8
                self.loadDataAndPickerView(SelectedType.weight)
            }
            self.selectdePickerCell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
        case 4:
            switch (indexPath as NSIndexPath).row {
            case 0:
                print("腹围")
                self.selectedIndexPathRow = 9
                self.loadDataAndPickerView(SelectedType.abdomen)
            case 1:
                print("病情")
                self.selectedIndexPathRow = 10
                self.loadDataAndPickerView(SelectedType.illness)
            case 2:
                print("工作类型")
                self.selectedIndexPathRow = 11
                self.loadDataAndPickerView(SelectedType.workType)
            default:
                break
            }
            self.selectdePickerCell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
        default:

            break
        }
        
   
        
    }
    
    var dateView:DateView!

    func loadDateView(_ name:String){

        
        self.loadSexBgView()
        if self.dateView == nil {
            
            let tmpRect = UIScreen.main.bounds
            
            self.dateView = Bundle.main.loadNibNamed("DateView", owner: nil, options: nil)?.first as! DateView
            self.dateView.frame = CGRect(x: 0, y: tmpRect.height - 240 - 64, width: tmpRect.width, height: 240)
            self.dateView.nameLabel.text = name
            
            self.dateView.delegate = self
            
            self.view.addSubview(self.dateView)
        }
        
        
        
    }
    
    
    
    
    
    
    //记录选择picker的cell
    var selectdePickerCell:MationOneTableViewCell!
    //记录头像cell
    var phtoCell:InfSection1TableViewCell!
    
    var heightArray:NSMutableArray!
    var weighArray:NSMutableArray!
    var abdominalArray:NSMutableArray!
    var illnessArray:NSMutableArray!
    var workTypeArray:NSMutableArray!
    
    func loadDataAndPickerView(_ type: SelectedType){
        
        switch type {
        case .height:
            print("加载身高")
            var HtmpDataArray = NSMutableArray()
            if self.heightArray == nil {
                HtmpDataArray = self.loadData(type)
            }else{
                HtmpDataArray = self.heightArray
            }
            self.loadStagePickerView("身高cm", dataArray: HtmpDataArray, uSecIndex: self.staSecInt)
            
        case .weight:
            print("加载体重")
            var HtmpDataArray = NSMutableArray()
            if self.weighArray == nil {
                HtmpDataArray = self.loadData(type)
            }else{
                HtmpDataArray = self.weighArray
            }
            self.loadStagePickerView("体重kg", dataArray: HtmpDataArray, uSecIndex: self.staSecInt)
            
        case .abdomen:
             print("加载腹围")
             var HtmpDataArray = NSMutableArray()
             if self.abdominalArray == nil {
                HtmpDataArray = self.loadData(type)
             }else{
                HtmpDataArray = self.abdominalArray
             }
            self.loadStagePickerView("腹围cm", dataArray: HtmpDataArray, uSecIndex: self.staSecInt)
        case .illness:
             print("加载病情")
             var HtmpDataArray = NSMutableArray()
             if self.illnessArray == nil {
                HtmpDataArray = self.loadData(type)
             }else{
                HtmpDataArray = self.illnessArray
             }
             self.loadStagePickerView("病情", dataArray: HtmpDataArray, uSecIndex: self.staSecInt)

        case .workType:
            var HtmpDataArray = NSMutableArray()
            if self.workTypeArray == nil {
                HtmpDataArray = self.loadData(type)
            }else{
                HtmpDataArray = self.workTypeArray
            }
            self.loadStagePickerView("工作类型", dataArray: HtmpDataArray, uSecIndex: self.staSecInt)
            print("加载工作类型")
        }
     
        
    }
    
    func loadData(_ type: SelectedType) ->NSMutableArray{
        
        var tmpArray = NSMutableArray()
        
        switch type {
        case .height:
            for item in 100...200 {
                tmpArray.add("\(item)")
            }
            self.heightArray = tmpArray
        case .weight:
            for item in 35...180 {
                tmpArray.add("\(item)")
            }
            self.weighArray = tmpArray
        case .abdomen:
            for item in 50...100 {
                tmpArray.add("\(item)")
            }
            self.abdominalArray = tmpArray
        case .illness:
            
//            tmpArray = ["未诊断","妊娠糖尿病患者","2型糖尿病","糖前高危","1型糖尿病","确诊人群"]
            tmpArray = ["未诊断","妊娠糖尿病","2型糖尿病","糖前高危","1型糖尿病","确诊人群","继发性","特殊类型"]
            self.illnessArray = tmpArray
        case .workType:
            tmpArray = ["轻体力(办公职员、教师)","中体力(学生、司机)","重体力(农民工、搬运工)"]
            self.workTypeArray = tmpArray
        }
        
        return tmpArray
    }
    
    
    
    var stagePickeView:StagePickerView!
    //加载 性别 体重 选择视图
    func loadStagePickerView(_ title:String,dataArray:NSMutableArray,uSecIndex:Int){
        
        self.loadSexBgView()
        
        
        if self.stagePickeView == nil {
            
            let tmpRect = UIScreen.main.bounds
            
            self.stagePickeView = Bundle.main.loadNibNamed("StagePickerView", owner: nil, options: nil)?.last as! StagePickerView
            self.stagePickeView.frame = CGRect(x: 0, y: tmpRect.height - 240 - 64, width: tmpRect.width, height: 240)
            //传值
            self.stagePickeView.titStr = title //标题
            
            self.stagePickeView.dataArray = dataArray //数据源
            
            self.stagePickeView.pickerDefaultIndex = uSecIndex //默认选择的第几个
            
            self.stagePickeView.dateClosure = self.dateClosure //回调方法
            
            
            self.view.addSubview(self.stagePickeView)
        }
        
        
    }
    //sexView背景视图
    var sexBgView:UIView!
    
    func loadSexBgView(){
        if self.sexBgView == nil {
            self.sexBgView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height))
            self.sexBgView.backgroundColor = UIColor.clear
            self.view.addSubview(self.sexBgView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(MyInfViewController.complicatGgViewAct))
            self.sexBgView.addGestureRecognizer(tap)
            
        }
    }
    

    
    
    //输入文本框值回调
    func textFiledValueClosur(_ value:String)->Void {

        switch self.selectedIndexPathRow {
        case 1:     //print("昵称")
            self.uploadDic["nickname"] = value
            if value.isEmpty{
                self.selectdePickerCell.inforTF.placeholder = "输入昵称"
            }
        case 2:     //print("姓名")
            self.uploadDic["realname"] = value
            if value.isEmpty{
                self.selectdePickerCell.inforTF.placeholder = "输入姓名"
            }
        case 4:     //print("手机号")
            self.uploadDic["mobile"] = value
            if value.isEmpty{
                self.selectdePickerCell.inforTF.placeholder = "输入手机号"
            }
        case 5:     //print("电子邮箱")
            self.uploadDic["mail"] = value
        default:
            break
        }
        
        
        self.valueArray[self.selectedIndexPathRow] = value
    
        
    }
    var staSecInt = 0
    
    //回调
    func dateClosure(_ tag:Int,secInt:Int,value:String)->Void{
        
        
        if tag != 0 { //不是取消
            print(secInt,value)
            if value.isEmpty {
                self.selectdePickerCell.inforTF.text = ""
                
            }else{
                self.selectdePickerCell.inforTF.text = value
                
            }
            
            switch self.selectedIndexPathRow {
            case 7:
                self.uploadDic["heigh"] = value
            case 8:
                self.uploadDic["weight"] = value
            case 9:
                self.uploadDic["abdomen"] = value
            case 10:
                self.uploadDic["stype"] = "\(secInt)"
            case 11:
                self.uploadDic["worktype"] = "\(secInt)"
            default:
                break
            }
            
            self.valueArray[7] = value
        }

        self.complicatGgViewAct()
  
    }
    //日期回调DateViewDelegate
    func saveBtnAct(_ date: String) {

        self.selectdePickerCell.inforTF.text = date
  
        self.valueArray[6] = date
        self.uploadDic["birth"] = date
        
        self.complicatGgViewAct()
    }
    func closeDateView() {
        self.complicatGgViewAct()
    }
    //性别选择回调
    func sexSelectInt(_ value: Int) {
        print(value)
        
        self.valueArray[3] = "\(value)"
        self.uploadDic["sex"] = "\(value)"
  
        
    }
    
    
    
    
    func complicatGgViewAct(){
        
        if self.sexBgView != nil {
            self.sexBgView.removeFromSuperview()
            self.sexBgView = nil
        }
        if self.stagePickeView != nil {
            self.stagePickeView.removeFromSuperview()
            self.stagePickeView = nil
        }
        if self.dateView != nil {
            self.dateView.removeFromSuperview()
            self.dateView = nil
        }
        
    }
    
    
    //MARK:相机相册
    //拍照选择
    func phtoSelecOr(){

        let actionSheet = UIAlertController(title: "相片选择", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "拍照", style: UIAlertActionStyle.destructive, handler: { (myAlert:UIAlertAction) in
            print("拍照")
            self.phtoAct()
        }))
        actionSheet.addAction(UIAlertAction(title: "相册", style: UIAlertActionStyle.default, handler: { (myAlert:UIAlertAction) in
            print("相册")
            self.selecetPhto()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(actionSheet, animated: false, completion: nil)
        
        
        
    }
    //拍照
    func phtoAct(){
        var sourceTyte = UIImagePickerControllerSourceType.camera
        if !UIImagePickerController .isSourceTypeAvailable(.camera)
        {
            sourceTyte = UIImagePickerControllerSourceType.photoLibrary
        }
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        pickerC.allowsEditing = true
        pickerC.sourceType = sourceTyte
        pickerC.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
//        self.present(pickerC, animated: false) { () -> Void in
//            
//        }
        self.present(pickerC, animated: false, completion: nil)
        
    }
    
    var phtoImage:UIImage!
    var image = UIImagePickerController()
    
    //相册选取
    func selecetPhto(){
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        image.allowsEditing = true
        
        self.present(image, animated: false, completion: nil)
    }
    //相册代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        picker.dismiss(animated: false, completion: nil)
        
        
        var image: UIImage!
        
        if picker.allowsEditing {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }

//        
//        self.dismissViewControllerAnimated(false, completion: nil)
//        
//        let gotImg:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.phtoImage = image
        
        self.phtoCell.imgView.image = image
        
        self.imgState = true
        
        var base64data:String = ""
        if self.phtoImage != nil{
            let imgData = UIImageJPEGRepresentation(self.phtoImage!, 0.2)
            base64data = (imgData! as NSData).base64EncodedString()
 
        }
        
        self.uploadDic["iconurl"] = base64data

    }

}
