//
//  MationIFViewController.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/2/2.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MationIFViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate ,UINavigationControllerDelegate,UIActionSheetDelegate{

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     var codes:Int = 100
    
    var finish:JGProgressHUD!
    var saveFF:JGProgressHUD!
    

    
    var phtoImage:UIImage!
    var image = UIImagePickerController()
    
    
    
    var phtoCell:MationTowTableViewCell!
    var birthCell:MationOneTableViewCell!
    
    var HeighTabCell:MationOneTableViewCell!
    var WeightTabCell:MationOneTableViewCell!
    var FuweiTabCell:MationOneTableViewCell!
    var TangniaobingTabCell:MationOneTableViewCell!
    
    //数据字典
    var userInformationDic = NSDictionary()
    
    
    @IBOutlet weak var myTabView: UITableView!
    
    //身高体重选择
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectTabView: UITableView!
    
    @IBOutlet weak var selectLabel: UILabel!
    

    //时间选择
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var myPicker: UIDatePicker!
    
    @IBOutlet weak var returnBtn: UIButton!
    
    
    
    var heightArray = NSMutableArray() //高度数组
    var weightArray = NSMutableArray() //体重数组
    var waistArray = NSMutableArray()  //腹围数组
    var tangniaobArray = NSMutableArray() //糖尿病数组
    
    
    
    //名称数组
    var nameArray = NSMutableArray()
    //提示数组
    var placeholderArray = NSMutableArray()
    
    
    

    var realname = "" //真实姓名
    var nickname = "" //个性昵称
    var mail = "" //电子邮箱
    var mobile = "" //手机号码
    var SEX:Int = 0 //性别
    var birth = "" //出生日期
    var heigh = "" //身高cm
    var weight = "" //体重kg
    var abdomen = "" //腹围cm
    var diabetesInt:Int = 0 //糖尿病症状
    var iconurl:String!
    var name = "" //姓名，不可修改
    
    var imgState:Bool = false //false 为选择网络图片
    
    
    //选择的是 （100 为 身高， 101 为体重，102 为腹围）
    var selecetInt:Int = 100
    //时间选择
    var pickerVcState:Bool = false
    //tab身高选择
    var selectTabViewState:Bool = false
    
    
    var realnameCell:MationOneTableViewCell!
    var nicknameCell:MationOneTableViewCell!
    var mailCell:MationOneTableViewCell!
    var mobileCell:MationOneTableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "完善资料"
        
        //设置导航栏
        self.setNav()
        
        //初始化名称数组
        self.setNameArray()
        
        //初始化数组数据（身高。体重）
        self.initData()
        
        //设置按钮
        self.setBtn()
        
        //设置时间选择最大值
        self.setDatepicker()
    }

    func setNameArray(){
        self.nameArray = ["真实姓名","个性昵称","个人头像","电子邮箱","手机号码","性别","出生日期","身高cm","体重kg","腹围cm","糖尿病","工作状态"]
        self.placeholderArray = ["输入姓名","输入昵称","个人头像","输入邮箱","输入手机号码","性别","选择日期","选择身高","选择体重","选择腹围","选择病况","工作共做"]
    }
    func setNav(){
        let leftBtn = UIBarButtonItem(title:"返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MationIFViewController.backAct))
        leftBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
        self.navigationItem.leftBarButtonItem = leftBtn
        
        let rightBtn = UIBarButtonItem(title:"完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MationIFViewController.saveAct))
        rightBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBtn
   
    }
    func backAct(){
        self.navigationController!.popViewController(animated: true)
    }
    
    func setDatepicker(){
        
        let today:Double = Date().timeIntervalSince1970
        
        let dayTime = Date(timeIntervalSince1970: today)
        
        self.myPicker.maximumDate = dayTime
        
    }
    
    func saveAct(){
        print("保存")
        
        //收起键盘
        self.view.becomeFirstResponder()
        self.view.endEditing(true )

        if (self.realname.characters.count <= 0){
            let alertView:UIAlertView = UIAlertView(title: "提示", message: "请填写真实姓名", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        if (self.nickname.characters.count <= 0){
            let alertView:UIAlertView = UIAlertView(title: "提示", message: "请填写昵称", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
//        if (self.mail.characters.count <= 0){
//            let alertView:UIAlertView = UIAlertView(title: "提示", message: "请填写电子邮箱", delegate: nil, cancelButtonTitle: "确定")
//            alertView.show()
//            return
//        }
        if (self.mobile.characters.count <= 0){
            let alertView:UIAlertView = UIAlertView(title: "提示", message: "请填写手机号码", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
        if (self.mobile.characters.count != 11) {
            let alertView:UIAlertView = UIAlertView(title: "提示", message: "请填写正确的手机号码", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
        if (self.birth.characters.count <= 0){
            let alertView:UIAlertView = UIAlertView(title: "提示", message: "请选择出生日期", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        if (self.heigh.characters.count <= 0){
            let alertView:UIAlertView = UIAlertView(title: "提示", message: "请选择身高", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        if (self.weight.characters.count <= 0){
            let alertView:UIAlertView = UIAlertView(title: "提示", message: "请选择体重", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        if (self.abdomen.characters.count <= 0){
            let alertView:UIAlertView = UIAlertView(title: "提示", message: "请选择腹围", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
        
        self.saveFF = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.saveFF.textLabel.text = "保存中..."
        self.saveFF.show(in: self.view, animated: true)
        
        
//        print(realname,nickname,mail,mobile,SEX,birth,heigh,weight,abdomen,diabetesInt)
        
        if (self.realnameCell != nil){
            self.realnameCell.inforTF.resignFirstResponder()
        }
        if (self.nicknameCell != nil){
            self.nicknameCell.inforTF.resignFirstResponder()
        }
        if (self.mailCell != nil){
            self.mailCell.inforTF.resignFirstResponder()
        }
        if (self.mobileCell != nil){
            self.mobileCell.inforTF.resignFirstResponder()
        }
//        print(realname,nickname,mail,mobile,SEX,birth,heigh,weight,abdomen,diabetesInt)
        var base64data:String = ""
        if self.phtoImage != nil{
            
            let imgData = UIImageJPEGRepresentation(self.phtoImage!, 0.2)
            base64data = (imgData! as NSData).base64EncodedString()
        }
        
//        print(base64data)
        
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
            "name":name,
            "nickname":self.nickname,
            "realname":self.realname,
            "mail":self.mail,
            "mobile":self.mobile,
            "sex":self.SEX,
            "birth":self.birth,
            "heigh":self.heigh,
            "weight":self.weight,
            "abdomen":self.abdomen,
            "stype":self.diabetesInt,
            "iconurl":base64data,
            "worktype":"1",
        ]
       
//        print("")
        
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
//            print("json:\(json)")
            
            if let tmpData:Int = json["code"].int{
                self.codes = tmpData
            }
            
            
            if (self.codes == 1){
                //成功
                
                self.saveFF.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveFF.textLabel.text = "修改成功"
                self.saveFF.dismiss(afterDelay: 1.0, animated: true)

                BGNetwork().delay(1.1, closure: { () -> () in
                    
//                    dateString = year1
                    
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
            
            
            }, failure: { () -> Void in
                
                print("false")
                
                self.saveFF.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveFF.textLabel.text = "网络错误"
                self.saveFF.dismiss(afterDelay: 0.5, animated: true)
        })
        
        
        
    }
    
    func setBtn(){
        self.returnBtn.addTarget(self, action: #selector(MationIFViewController.doseTimeOk), for: UIControlEvents.touchUpInside)
    }
    
    
    func initData(){
        //创建一个 1- 300 的数组
        for i in 100...250{
            
            let heigh = "\(i)"
            
            self.heightArray.add(heigh)
        }
        for w in 30...250{
            
            let weight = "\(w)"
            
            self.weightArray.add(weight)
        }
        for wai in 50...150{
            
            let wais = "\(wai)"
            
            self.waistArray.add(wais)
        }
        
        
        self.tangniaobArray = ["未诊断","妊娠糖尿病","1型糖尿病","2型糖尿病","青年糖尿病"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        BGNetwork().delay(0.3) { () -> () in
            //获取信息
            self.getIFmation()
        }
        
        
    }
    func getIFmation(){
        
        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = "努力加载中..."
        self.finish.show(in: self.view, animated: true)
        
        
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
            
            print("\(json)")
            
            self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.finish.textLabel.text = "加载成功！"
            self.finish.dismiss(afterDelay: 1.0, animated: true)
            
            
            if let tmpData:NSDictionary = json["data"].dictionaryObject as NSDictionary?{
                self.userInformationDic = tmpData
                
                if let realname1:String = tmpData.value(forKey: "realname") as? String {
                    self.realname = realname1
                }
                self.nickname = tmpData.value(forKey: "nickname") as! String
                
                if let mail1:String = tmpData.value(forKey: "mail") as? String {
                    self.mail = mail1
                }
                
//                self.mail = tmpData.valueForKey("mail") as! String
                
                if let mobile1 = tmpData.value(forKey: "mobile") as? String {
                    self.mobile = mobile1
                }
                
//                self.mobile = tmpData.valueForKey("mobile") as! String
                self.SEX = tmpData.value(forKey: "sex") as! Int
                self.birth = tmpData.value(forKey: "birth") as! String
                
                self.heigh = String(tmpData.value(forKey: "heigh") as! Int)
                self.weight = String(tmpData.value(forKey: "weight") as! Int)
                self.abdomen = String(tmpData.value(forKey: "abdomen") as! Int)
                
                self.diabetesInt = tmpData.value(forKey: "stype") as! Int
                
                self.name = tmpData.value(forKey: "name") as! String
             
                
                if let iconurl1 = tmpData.value(forKey: "iconurl") as? String {
                    self.iconurl = iconurl1
                }
//                self.iconurl = tmpData.valueForKey("iconurl") as! String
                

                
            }
            

            
            
            
            self.myTabView.reloadData()
            }, failure: { () -> Void in
                
                print("false")
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "加载失败！"
                self.finish.dismiss(afterDelay: 1.0, animated: true)
        })
        
        
    }
    
   
    
    
    
    //Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        
        switch tableView.tag {
        case 2016020301:
            print("myTabView")
            return self.nameArray.count
        case 2016020302:
            print("selectTabView")
            
            switch self.selecetInt{
            case 100:
                //身高
                return self.heightArray.count
            case 101:
                //体重
                return self.weightArray.count
            case 102:
                //腹围
                return self.waistArray.count
            case 103:
                //糖尿病
                return self.tangniaobArray.count
            default:
                return 10
            }
        default:
            return 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
        
        switch tableView.tag {
        case 2016020301:
            //myTabView
            switch (indexPath as NSIndexPath).row{
            case 2:
                return 55 * Hsize
            case 5:
                return 50 * Hsize
            default:
                return 45 * Hsize
            }
        case 2016020302:
            //选择身高的tabview
            return 44
            
        default:
            return 44
            
        }
   
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch tableView.tag {
        case 2016020301:
            //myTabView
            
            switch (indexPath as NSIndexPath).row{
            case 2:
                let ddd = "MationTowCell"
                var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? MationTowTableViewCell
                if cell == nil{
                    cell = Bundle.main.loadNibNamed("MationTowTableViewCell", owner: self, options: nil )?.last as? MationTowTableViewCell
                }
                
                cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                

                
                if (self.imgState == false){
                    if(self.iconurl != nil){
                        let url = self.iconurl
                        let imgurl:URL = URL(string: url!)!
                        cell?.imgView.sd_setImage(with: imgurl, placeholderImage: UIImage(named: "touxiang2.png"))
                    }
                    
                }else{
                    if(self.phtoImage != nil){
                        cell?.imgView.image = self.phtoImage
                    }
                }
                
                //设置选中cell 时的颜色
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                
                return cell!
            case 5:
                let ddd = "MationThreeCell"
                var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? MationThreeTableViewCell
                if cell == nil{
                    cell = Bundle.main.loadNibNamed("MationThreeTableViewCell", owner: self, options: nil )?.last as? MationThreeTableViewCell
                }
                cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                
                if (self.userInformationDic.count > 0){
                    let sex = self.userInformationDic.value(forKey: "sex") as! Int
                    
                    switch sex{
                    case 0:
                        cell?.boyBtn.setImage(UIImage(named: "dian2.png"), for: UIControlState())
                        cell?.girlBtn.setImage(UIImage(named: "dian1.png"), for: UIControlState())
                        self.SEX = 0
                    case 1:
                        cell?.boyBtn.setImage(UIImage(named: "dian1.png"), for: UIControlState())
                        cell?.girlBtn.setImage(UIImage(named: "dian2.png"), for: UIControlState())
                        self.SEX = 1
                    default:
                        break
                    }
                    
                    
                    
                }
                
                cell?.boyBtn.addTarget(self, action: #selector(MationIFViewController.sexAct(_:)), for: UIControlEvents.touchUpInside)
                cell?.boyBtn.tag = 1528
                cell?.girlBtn.addTarget(self, action: #selector(MationIFViewController.sexAct(_:)), for: UIControlEvents.touchUpInside)
                cell?.girlBtn.tag = 1529
                
                
                //右边箭头
                cell?.accessoryType = UITableViewCellAccessoryType.none
                //设置选中cell 时的颜色
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                
                return cell!
            default:
                let ddd = "MationOneCell"
                var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? MationOneTableViewCell
                if cell == nil
                {
                    cell = Bundle.main.loadNibNamed("MationOneTableViewCell", owner: self, options: nil )?.last as? MationOneTableViewCell
                    
                }
                cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                
                
                cell?.inforTF.tag = (indexPath as NSIndexPath).row + 1559
                
                if (self.userInformationDic.count > 0){
                    
                    switch (indexPath as NSIndexPath).row{
                    case 0:
                        if let realname1 = self.userInformationDic.value(forKey: "realname") as? String{
                            cell?.inforTF.text! = realname1
                        }
                        
//                        cell?.inforTF.text! = self.userInformationDic.valueForKey("realname") as! String
                    case 1:
                        if let nickname1 = self.userInformationDic.value(forKey: "nickname") as? String{
                            cell?.inforTF.text! = nickname1
                        }
//                        cell?.inforTF.text! = self.userInformationDic.valueForKey("nickname") as! String
                    case 3:
                        if let mail1 = self.userInformationDic.value(forKey: "mail") as? String{
                            cell?.inforTF.text! = mail1
                        }
//                        cell?.inforTF.text! = self.userInformationDic.valueForKey("mail") as! String
                    case 4:
                        if let mobile1 = self.userInformationDic.value(forKey: "mobile") as? String{
                            cell?.inforTF.text! = mobile1
                        }
//                        cell?.inforTF.text! = self.userInformationDic.valueForKey("mobile") as! String
                    case 6:
                        if let birth1 = self.userInformationDic.value(forKey: "birth") as? String{
                            cell?.inforTF.text! = birth1
                        }
//                        cell?.inforTF.text! = self.userInformationDic.valueForKey("birth") as! String
                    case 7:
                        if let heigh1 = self.userInformationDic.value(forKey: "heigh") as? Int{
                            cell?.inforTF.text! = "\(heigh1)"
                        }
//                        cell?.inforTF.text! = String(self.userInformationDic.valueForKey("heigh") as! Int)
                    case 8:
                        if let weight1 = self.userInformationDic.value(forKey: "weight") as? Int{
                            cell?.inforTF.text! = "\(weight1)"
                        }
//                        cell?.inforTF.text! = String(self.userInformationDic.valueForKey("weight") as! Int)
                    case 9:
                        if let abdomen1 = self.userInformationDic.value(forKey: "abdomen") as? Int{
                            cell?.inforTF.text! = "\(abdomen1)"
                        }
//                        cell?.inforTF.text! = String(self.userInformationDic.valueForKey("abdomen") as! Int)
                    case 10:
                        var stype:Int = 0
                        if let stype1 = self.userInformationDic.value(forKey: "stype1") as? Int{
                            stype = stype1
                        }
                        
                        
                        
                        switch stype{
                        case 0:
                            cell?.inforTF.text! = "未诊断"
                        case 1:
                            cell?.inforTF.text! = "妊娠糖尿病"
                        case 2:
                            cell?.inforTF.text! = "1型糖尿病"
                        case 3:
                            cell?.inforTF.text! = "2型糖尿病"
                        case 4:
                            cell?.inforTF.text! = "青年糖尿病"
                        default:
                            break
                        }
                        
                        
                    default:
                        break
                    }
                    
                    
                    
                    
                }
                
                cell?.nameLabel.text! = self.nameArray[(indexPath as NSIndexPath).row] as! String
                cell?.inforTF.placeholder! = self.placeholderArray[(indexPath as NSIndexPath).row] as! String
                
                switch (indexPath as NSIndexPath).row{
                case 6...self.nameArray.count:
                    cell?.inforTF.isEnabled = false
                default:
                    cell?.inforTF.isEnabled = true
                }
                //设置选中cell 时的颜色
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                
                return cell!
            }
            
        default:
            //选择tabview
            let ddd = "inforMtCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? InforMtTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("InforMtTableViewCell", owner: self, options: nil )?.last as? InforMtTableViewCell
                
            }
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            
            switch self.selecetInt{
            case 100:
                //身高
                cell?.nameLabel.text! = self.heightArray[(indexPath as NSIndexPath).row] as! String
            case 101:
                //体重
                cell?.nameLabel.text! = self.weightArray[(indexPath as NSIndexPath).row] as! String
            case 102:
                //腰围
                cell?.nameLabel.text! = self.waistArray[(indexPath as NSIndexPath).row] as! String
            case 103:
                //糖尿病
                cell?.nameLabel.text! = self.tangniaobArray[(indexPath as NSIndexPath).row] as! String
            default:
                break
            }
            
            
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            return cell!
        }
    
        
    }
    
    var workTypeView:WorkTypeView!
    
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView.tag {
        case 2016020301:
            //--

            switch (indexPath as NSIndexPath).row {
            case 0:
                print("姓名")
                
                let cell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
                
                cell.inforTF.becomeFirstResponder()
                
            case 1:
                print("昵称")
                let cell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
                
                cell.inforTF.becomeFirstResponder()
                
            case 2:
                print("个人头像")
                
                self.phtoCell = tableView.cellForRow(at: indexPath) as! MationTowTableViewCell
                

                //收起键盘
                self.view.becomeFirstResponder()
                
                self.view.endEditing(true )
                
                
                self.phtoSelecOr()
                
                
                
                
                
            case 3:
                print("电子邮箱")
                let cell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
                
                cell.inforTF.becomeFirstResponder()
            case 4:
                print("手机号码")
                let cell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
                
                cell.inforTF.becomeFirstResponder()
            case 5:
                print("性别")
            case 6:
                print("出生日期")
                
                self.birthCell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
                
                self.datePickerSet(pickerVcState)
            case 7:
                print("身高")
                
                self.selecetInt = 100
                self.HeighTabCell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
                
                self.selectLabel.text = "身高 cm"
                self.selectTabView.reloadData()
                
                BGNetwork().delay(0.1, closure: { () -> () in
                    self.myTableViewState(self.selectTabViewState)
                })
                
            case 8:
                print("体重")
                
                self.WeightTabCell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
                
                self.selecetInt = 101
                
                self.selectLabel.text = "体重 kg"
                self.selectTabView.reloadData()
                
                BGNetwork().delay(0.1, closure: { () -> () in
                    self.myTableViewState(self.selectTabViewState)
                })
            case 9:
                print("腹围")
                self.selecetInt = 102
                
                self.FuweiTabCell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
                
                self.selectLabel.text = "腹围 cm"
                self.selectTabView.reloadData()
                
                BGNetwork().delay(0.1, closure: { () -> () in
                    self.myTableViewState(self.selectTabViewState)
                })
                
            case 10:
                print("糖尿病")
                self.selecetInt = 103
                self.TangniaobingTabCell = tableView.cellForRow(at: indexPath) as! MationOneTableViewCell
                
                self.selectLabel.text = "糖尿病类型"
                self.selectTabView.reloadData()
                
                
                BGNetwork().delay(0.1, closure: { () -> () in
                    self.myTableViewState(self.selectTabViewState)
                })
            case 11:
                print("工作状态")
                
                if self.workTypeView == nil {
                    self.workTypeView = Bundle.main.loadNibNamed("WorkTypeView", owner: nil, options: nil)?.last as! WorkTypeView
                    
                    self.workTypeView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 220 - 64, width: UIScreen.main.bounds.width, height: 220)
                    
                    self.view.addSubview(self.workTypeView)
                    
                }
                
                
            default:
                break
            }
        default:
            
            self.myTableViewState(self.selectTabViewState)
            
            switch self.selecetInt{
            case 100:
                print("身高")
                self.HeighTabCell.inforTF.text! = self.heightArray[(indexPath as NSIndexPath).row] as! String
                
                self.heigh = self.heightArray[(indexPath as NSIndexPath).row] as! String
                
            case 101:
                print("体重")
                self.WeightTabCell.inforTF.text! = self.weightArray[(indexPath as NSIndexPath).row] as! String
                self.weight = self.weightArray[(indexPath as NSIndexPath).row] as! String
            case 102:
                print("腰围")
                self.FuweiTabCell.inforTF.text! = self.waistArray[(indexPath as NSIndexPath).row] as! String
                self.abdomen = self.waistArray[(indexPath as NSIndexPath).row] as! String
                
            case 103:
                print("血压")
                self.TangniaobingTabCell.inforTF.text! = self.tangniaobArray[(indexPath as NSIndexPath).row] as! String
                
                
                switch (indexPath as NSIndexPath).row{
                case 0:
                    self.diabetesInt = 0
                case 1:
                    self.diabetesInt = 1
                case 2:
                    self.diabetesInt = 2
                case 3:
                    self.diabetesInt = 3
                case 4:
                    self.diabetesInt = 4
                default:
                    break
                }
 
            default:
                break
            }
            
            
            
            

        }
        
   
        
    }
    
    
    //tab是否显示
    func myTableViewState(_ state:Bool){
        
        
        if(state == false){
            //出现
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.35)
            self.selectView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 220 - 64, width: UIScreen.main.bounds.width, height: 220)
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeOut) //设置动画相对速度
            UIView.commitAnimations()
            
            
            self.selectTabViewState = true
        }else{
            //消失
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.35)
            self.selectView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 64, width: UIScreen.main.bounds.width, height: 220)
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeOut) //设置动画相对速度
            UIView.commitAnimations()
            
            self.selectTabViewState = false
        }
        
        
        
    }
    
    //时间选择是否显示
    func datePickerSet(_ stateIn:Bool){

        if (stateIn == false){
            //出现
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.35)
            self.datePickerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 185 - 64, width: UIScreen.main.bounds.width, height: 185)
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeOut) //设置动画相对速度
            UIView.commitAnimations()
            
            self.pickerVcState = true
        }else{
            //消失
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.35)
            self.datePickerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 185)
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeOut) //设置动画相对速度
            UIView.commitAnimations()
            
            self.pickerVcState = false
        }
        

    }
    func doseTimeOk(){
        let aa = self.myPicker.date.timeIntervalSince1970 + (8 * 60 * 60)
        let dayTime = Date(timeIntervalSince1970: aa)
        let str = String(describing: dayTime)
        if (str.characters.count >= 16){
            let stri:String = (str as NSString).substring(to: 16)
            print("当前时间：\(stri)")
            
//            let hourTime = (str as NSString).substringWithRange(NSRange(location: 11, length: 5))
            let yearTime = (str as NSString).substring(to: 10)
            
            self.birthCell.inforTF.text! = yearTime
            
            //赋值给出生日期
            self.birth = yearTime
        }
        
        
        self.datePickerSet(pickerVcState)
    }

    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (self.pickerVcState == true){
            self.datePickerSet(pickerVcState)
        }
        if (self.selectTabViewState == true){
            self.myTableViewState(selectTabViewState)
        }
        
        print("textField.tag:\(textField.tag - 1559)")
        switch textField.tag - 1559 {
        case 0:
            self.realname = textField.text!
            let realnamecell = textField.superview?.superview as! MationOneTableViewCell
            self.realnameCell = realnamecell

        case 1:
            self.nickname = textField.text!
            let nicknamecell = textField.superview?.superview as! MationOneTableViewCell
            self.nicknameCell = nicknamecell

        case 3:
            self.mail = textField.text!
            let mailcell = textField.superview?.superview as! MationOneTableViewCell
            self.mailCell = mailcell

        case 4:
            self.mobile = textField.text!
            let mobilecell = textField.superview?.superview as! MationOneTableViewCell
            self.mobileCell = mobilecell

        default:
            break
        }
        
        
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textField.tag:\(textField.tag - 1559)")
        
        switch textField.tag - 1559 {
        case 0:
            self.realname = textField.text!
        case 1:
            self.nickname = textField.text!
        case 3:
            self.mail = textField.text!
        case 4:
            self.mobile = textField.text!
        default:
            break
        }
        print("tag:\(textField.tag - 1559),文字：\(textField.text!)")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //点击 return 收起键盘

        self.view.becomeFirstResponder()
        
        self.view.endEditing(true )
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.becomeFirstResponder()
        self.view.endEditing(true)
    }
    
    
    func sexAct(_ send:UIButton){
        
        
        let cell = send.superview?.superview as! MationThreeTableViewCell
        
//        print(cell)
        
        switch send.tag{
        case 1528:
            //男
            if(self.SEX == 0){
                cell.boyBtn.setImage(UIImage(named: "dian1.png"), for: UIControlState())
                cell.girlBtn.setImage(UIImage(named: "dian2.png"), for: UIControlState())
                self.SEX = 1
            }
            
        case 1529:
            //女
            if(self.SEX == 1){
                cell.boyBtn.setImage(UIImage(named: "dian2.png"), for: UIControlState())
                cell.girlBtn.setImage(UIImage(named: "dian1.png"), for: UIControlState())
                self.SEX = 0
            }
        default:
            break
        }
    }
    
    
    func phtoSelecOr(){
        let actSheet:UIActionSheet = UIActionSheet(title: "相片选择", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "拍照", otherButtonTitles: "相册")
        actSheet.show(in: self.view)
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        if (buttonIndex == 0){
            print("拍照")
            self.phtoAct()
        }else if (buttonIndex == 1){
            print("取消")
        }else{
            print("相册")
            self.selecetPhto()
            
        }
    }
    //相册选取
    func selecetPhto(){
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        image.allowsEditing = true
        
        self.present(image, animated: true, completion: nil)
    }
    //相册代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        
        self.dismiss(animated: true, completion: nil)
        
        let gotImg:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.phtoImage = gotImg
        
        self.phtoCell.imgView.image = gotImg
        
        self.imgState = true
//        self.myTabView.reloadData()
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        picker.dismiss(animated: true) { () -> Void in
            
            self.phtoImage = image
            
            if self.phtoImage != nil{
                
                self.phtoCell.imgView.image = image
            }

            self.imgState = true
//            self.myTabView.reloadData()
        }
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
        self .present(pickerC, animated: true) { () -> Void in
            
        }
    }
    
    
}
