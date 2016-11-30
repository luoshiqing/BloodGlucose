//
//  AddManageViewController.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 15/12/30.
//  Copyright © 2015年 nash_su. All rights reserved.
//

import UIKit

//定义一个 回调
typealias sendValueClosure = (_ tag:Int)->Void
//日期选择
typealias dateValueClosur = (_ tag:Int,_ secInt:Int,_ value:String)->Void




fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class AddManageViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource ,UITextFieldDelegate{

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var finish:JGProgressHUD!
    var deleteHud:JGProgressHUD!
    
    var proNameArray = NSMutableArray()
    var proValArray = NSMutableArray()
    var proDic = NSMutableDictionary()
    var myTBState:Int = 0
    
    var selectRow = ""
    
    var dataDic = NSDictionary()
    
    var pcaState:Bool = false
    
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneTF: UITextField!
    
    
    @IBOutlet weak var proView: UIView!
    
    @IBOutlet weak var detailAddView: UIView!
    @IBOutlet weak var detailAddTF: UITextField!
    
    @IBOutlet weak var zipCodeView: UIView!
    @IBOutlet weak var zipCodeTF: UITextField!
    
    
    @IBOutlet weak var proBtn: UIButton!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var areaBtn: UIButton!
    
    @IBOutlet weak var proLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    @IBOutlet weak var PCAView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var PCALabel: UILabel!
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "管理"
        //设置导航栏按钮
        self.setNavBtn()
        //设置按钮点击事件
        self.setBtnAct()
        
        //设置代理
        self.setDelegate()
        
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 148/255.0, green: 211/255.0, blue: 232/255.0, alpha: 1)
        
        
        
        if(TOADDMANAGE == true){
            //如果是点击地址进来的
            self.deleteBtn.isHidden = false
            self.getAddByid()

        }else{
            //如果是点击添加进来的
            self.deleteBtn.isHidden = true

        }
    }
    func setDelegate(){
        self.nameTF.delegate = self
        self.phoneTF.delegate = self
        self.detailAddTF.delegate = self
        self.zipCodeTF.delegate = self
    }
    
    func setBtnAct(){
        self.deleteBtn.tag = 123154
        self.deleteBtn.addTarget(self, action: #selector(AddManageViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        
        self.proBtn.tag = 123155
        self.proBtn.addTarget(self, action: #selector(AddManageViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        
        self.cityBtn.tag = 123156
        self.cityBtn.addTarget(self, action: #selector(AddManageViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        
        self.areaBtn.tag = 123157
        self.areaBtn.addTarget(self, action: #selector(AddManageViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    func setNavBtn(){
        
        //设置导航栏颜色
        
        
        //返回
        let leftBtn = UIBarButtonItem(title:"返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddManageViewController.btnAct(_:)))
        leftBtn.tag = 123152
        leftBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
        self.navigationItem.leftBarButtonItem = leftBtn
        
        
        
        
        if(TOADDMANAGE == true){
            //如果是点击地址进来的
            
            
            
            //修改
            let rightBtn = UIBarButtonItem(title:"修改", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddManageViewController.btnAct(_:)))
            rightBtn.tag = 123151
            rightBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
            self.navigationItem.rightBarButtonItem = rightBtn
            
            
        }else{
            //如果是点击添加进来的

            //添加
            let rightBtn = UIBarButtonItem(title:"添加", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddManageViewController.btnAct(_:)))
            rightBtn.tag = 123153
            rightBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
            self.navigationItem.rightBarButtonItem = rightBtn
            
            
        }
    }
    
    func btnAct(_ send:UIButton){
        switch send.tag{
        case 123152:
            print("返回")
            
            self.navigationController!.popViewController(animated: true)
            
        case 123151:
            print("修改")
            self.editId()
            
        case 123153:
            print("添加")
            
            
            if(nameTF.text?.characters.count <= 0 || phoneTF.text?.characters.count <= 0 || detailAddTF.text?.characters.count <= 0 || proLabel.text == "省份" || cityLabel.text == "市区" || areaLabel.text == "地区"){
                
                print("信息不完整")
                
                
            }else{
                
                self.addId()
            }
            
            
            
            
        case 123154:
            print("删除")
            
            self.removeId()
            
        case 123155:
            print("省")

            self.deleteArray()
            
            self.PCAState(pcaState)

//            self.myTableView.reloadData()
            
            self.myTBState = 0
            let all = "all"
            self.getPro(all)
            
        case 123156:
            print("市")
            
            self.deleteArray()
            
            self.PCAState(pcaState)
            
            
//            self.myTableView.reloadData()
            
            self.myTBState = 1
            
            var val = ""
            if let proADD:String = UserDefaults.standard.value(forKey: "proselectRow") as? String{
                val = proADD
                print("val\(val)")
            }

            self.getCity(val,state: 2)
            
        case 123157:
            print("区")
            
            self.deleteArray()
            
            self.PCAState(pcaState)
            
//            self.myTableView.reloadData()
            self.myTBState = 2

            
            var val = ""
            if let proADD:String = UserDefaults.standard.value(forKey: "cityselectRow") as? String{
                val = proADD
                print("val\(val)")
            }
            

            
            self.getCity(val,state: 3)
            
        default:
            break
        }
    }
    
    
    
    func PCAState(_ state:Bool){
        
        if (state == false){
            //出现
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.35)
            self.PCAView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 285 - 64, width: UIScreen.main.bounds.width, height: 285)
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeOut) //设置动画相对速度
            UIView.commitAnimations()
            
            
            self.pcaState = true
        }else{
            //消失
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.35)
            self.PCAView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 64, height: 285)
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeOut) //设置动画相对速度
            UIView.commitAnimations()
            
            self.pcaState = false
        }
        
    }
    
    
    
    //获取地址详情
    func getAddByid(){
        var ressid = ""
        if let ressid1:String = self.dataDic.value(forKey: "ressid") as? String{
            ressid = ressid1
        }
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/getressbyid.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "ressid":ressid,
        ]
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
//            print("\(json)")
            
            var ddDic = NSDictionary()

            if let tmpData1:NSDictionary = json["data"].dictionaryObject as NSDictionary?{
                ddDic = tmpData1
//                print("ddDic:\(ddDic)")
            }
            
            var consignee = ""
            var phone = ""
            var provincename = ""
            var cityname = ""
            var countyname = ""
            
            var detailaddress = ""
            var contzipcode = ""
            
            if let contzipcode1 = ddDic.value(forKey: "contzipcode"){
                contzipcode = String(describing: contzipcode1)
            }
            
            if let detailaddress1 = ddDic.value(forKey: "detailaddress"){
                detailaddress = String(describing: detailaddress1)
            }
            if let countyname1 = ddDic.value(forKey: "countyname"){
                countyname = String(describing: countyname1)
            }
            if let cityname1 = ddDic.value(forKey: "cityname"){
                cityname = String(describing: cityname1)
            }
            if let provincename1 = ddDic.value(forKey: "provincename"){
                provincename = String(describing: provincename1)
            }
            if let phone1 = ddDic.value(forKey: "phone"){
                phone = String(describing: phone1)
            }
            
            if let consignee1 = ddDic.value(forKey: "consignee"){
                consignee = String(describing: consignee1)
            }
            
            //赋值
            self.nameTF.text = consignee
            self.phoneTF.text = phone
            self.proLabel.text = provincename
            self.cityLabel.text = cityname
            self.areaLabel.text = countyname
            
            self.detailAddTF.text = detailaddress
            self.zipCodeTF.text = contzipcode
            
            
            
            }, failure: { () -> Void in
                
                print("false")
        })
    }
    
    
    
    //获取省份
    func getPro(_ val:String){
        

        var dic = NSDictionary()
        
        dic = ["area":val,]
        
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/addAddress.jsp"
        
        RequestBase().doPost(reqUrl, dic as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("json:\(json)")
            
//            var ddDic = NSDictionary()
            
            var proArray = NSArray()
            if let proArray1:NSArray = json.arrayObject as NSArray? {
                proArray = proArray1
            }

            
            for tmp in proArray {
                print("tmp:\(tmp)")
                
                
                let nameArray = NSMutableArray()
                let valArray = NSMutableArray()
                
                var name = ""
                var val = ""
                
                if let name1 = (tmp as AnyObject).value(forKey: "name"){
                    name = String(describing: name1)
                    print("name:\(name)")
                }
                
                nameArray.add(name)
                self.proNameArray.addObjects(from: nameArray as [AnyObject])
                
                if let val1 = (tmp as AnyObject).value(forKey: "val"){
                    val = String(describing: val1)
                    print("name:\(val)")
                }
                valArray.add(val)
                self.proValArray.addObjects(from: valArray as [AnyObject])
                
                
                self.proDic[name] = val
    
                
            }
            
            //永久保存 省份对应列表
            UserDefaults.standard.set(self.proDic, forKey: "selfproDic")
            
            self.myTableView.reloadData()
            
            }, failure: { () -> Void in
                
                print("false")
        })
        
    }
    //获取市
    func getCity(_ val:String,state:Int){
        
        var dic = NSDictionary()
        
        dic = ["area":val,]
        
        print("dic:\(dic)")
        
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/addAddress.jsp"
        
        RequestBase().doPost(reqUrl, dic as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
//            print("json:\(json)")

            
            var proArray = NSArray()
            if let proArray1:NSArray = json.arrayObject as NSArray? {
                proArray = proArray1
            }
            
            //           print("proArray:\(proArray)")
            
            //            var nameArray = NSMutableArray()
            //            var valArray = NSMutableArray()
            
            for tmp in proArray {
                print("tmp:\(tmp)")
                
                
                let nameArray = NSMutableArray()
                let valArray = NSMutableArray()
                
                var name = ""
                var val = ""
                
                if let name1 = (tmp as AnyObject).value(forKey: "name"){
                    name = String(describing: name1)
                    print("name:\(name)")
                }
                
                nameArray.add(name)
                self.proNameArray.addObjects(from: nameArray as [AnyObject])
                
                if let val1 = (tmp as AnyObject).value(forKey: "val"){
                    val = String(describing: val1)
                    print("name:\(val)")
                }
                valArray.add(val)
                self.proValArray.addObjects(from: valArray as [AnyObject])
                
                
                self.proDic[name] = val
                
            }
            
            
            switch state{
            case 2:
                print("市")
                //永久保存 市对应列表
                UserDefaults.standard.set(self.proDic, forKey: "selfcityDic")
            case 3:
                print("区")
                //永久保存 区对应列表
                UserDefaults.standard.set(self.proDic, forKey: "selfareaDic")
            default:
                break
            }
            
            self.myTableView.reloadData()
            
            }, failure: { () -> Void in
                
                print("false")
        })
        
        
        
    }
    //获取地区
    func getArea(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tableView 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return self.proNameArray.count

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "addManageCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? AddManageTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("AddManageTableViewCell", owner: self, options: nil )?.last as? AddManageTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
  
        cell?.nameLabel.text = self.proNameArray[(indexPath as NSIndexPath).row] as? String

        return cell!
    }
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        switch self.myTBState{
        case 0:
            self.proLabel.text = self.proNameArray[(indexPath as NSIndexPath).row] as? String
            self.selectRow = self.proNameArray[(indexPath as NSIndexPath).row] as! String
            
            
            var propro = ""
            if let propro1:String = self.proDic.value(forKey: self.selectRow) as? String{
                propro = propro1
            }
            print("propro:\(propro)")
            //永久保存选择的 省份
            UserDefaults.standard.set(propro, forKey: "proselectRow")
            
            self.PCAState(true)
            
        case 1:
            self.cityLabel.text = self.proNameArray[(indexPath as NSIndexPath).row] as? String
            self.selectRow = self.proNameArray[(indexPath as NSIndexPath).row] as! String
            
            var propro = ""
            if let propro1:String = self.proDic.value(forKey: self.selectRow) as? String{
                propro = propro1
            }
            print("propro:\(propro)")
            
            
            //永久保存选择的 市区
            UserDefaults.standard.set(propro, forKey: "cityselectRow")
            
            self.PCAState(true)
        case 2:
            self.areaLabel.text = self.proNameArray[(indexPath as NSIndexPath).row] as? String
            self.selectRow = self.proNameArray[(indexPath as NSIndexPath).row] as! String
            
            var propro = ""
            if let propro1:String = self.proDic.value(forKey: self.selectRow) as? String{
                propro = propro1
            }
            print("propro:\(propro)")
            
            //永久保存选择的 地区
            UserDefaults.standard.set(propro, forKey: "areaselectRow")
            
            self.PCAState(true)
            
        default:
            break
        }

        
        self.deleteArray()
        
    }
   

    
    func deleteArray(){
        self.proNameArray.removeAllObjects()
        self.proValArray.removeAllObjects()
        self.proDic.removeAllObjects()
    }
    
    //删除地址
    func removeId(){
        
        
        self.deleteHud = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.deleteHud.textLabel.text = "删除中..."
        self.deleteHud.show(in: self.view, animated: true)
        
        
        var editId = ""
        if let editId1:String = self.dataDic.value(forKey: "ressid") as? String {
            editId = editId1
            print("editId1:\(editId1)")
        }
        
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/ressmanage.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "removeId":editId,
        ]
        
        print("dicDPost:\(dicDPost)")

        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
             print("json:\(json)")
            self.deleteHud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.deleteHud.textLabel.text = "删除成功！"
            self.deleteHud.dismiss(afterDelay: 1.1, animated: true)
            
            BGNetwork().delay(1.1, closure: { () -> () in
                self.navigationController!.popViewController(animated: true)
            })

            
            }, failure: { () -> Void in
                
                print("false")
                self.deleteHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.deleteHud.textLabel.text = "删除失败！"
                self.deleteHud.dismiss(afterDelay: 1.1, animated: true)
        })
        
        
        
    }
    //添加地址
    func addId(){
        
        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = ""
        self.finish.show(in: self.view, animated: true)
        
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/ressmanage.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        //--------------------------
        
        let consignee:String = self.nameTF.text! //收货人姓名
        let phone:String = self.phoneTF.text! //手机号
        let contaddr:String = self.detailAddTF.text! //详细地址
        let contzipcode:String = self.zipCodeTF.text! //邮编
        
        //省市区
        
        //省
        let pro:String = self.proLabel.text!
        print("省份：\(pro)")
        var proVal = ""
        
        if let tepProDic:NSDictionary = UserDefaults.standard.value(forKey: "selfproDic") as? NSDictionary{
            let proVal1:String = (tepProDic.value(forKey: pro) as? String)!
            proVal = proVal1
            print("proVal:\(proVal)")
        }
        
        
        //市
        let city:String = self.cityLabel.text!
        print("市区：\(city)")
        var cityVal = ""
        
        if let tepcCityDic:NSDictionary = UserDefaults.standard.value(forKey: "selfcityDic") as? NSDictionary{
            
            let cityVal1:String = (tepcCityDic.value(forKey: city) as? String)!
            cityVal = cityVal1
            print("cityVal:\(cityVal)")
            
        }
        
       
        //区
        let area:String = self.areaLabel.text!
        print("区域：\(area)")
        var areaVal = ""
        
        if let tepcAreaDic:NSDictionary = UserDefaults.standard.value(forKey: "selfareaDic") as? NSDictionary{
            let areaVal1:String = (tepcAreaDic.value(forKey: area) as? String)!
            areaVal = areaVal1
            print("areaVal\(areaVal)")
        }
        
        
        var dicDPost = NSDictionary()
        
  
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            
            "consignee":consignee,//姓名
            "phone":phone,//手机号
            "contaddr":contaddr,//详细地址
            "contzipcode":contzipcode,//邮编
            "province":proVal,
            "province_name":pro,
            "city":cityVal,
            "city_name":city,
            "county":areaVal,
            "county_name":area,
            "default":"0",
            "addId":"15959",
        ]
        
        print("dicDPost:\(dicDPost)")
        
        
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("json:\(json)")
            let tmpData:String = json["message"].stringValue

            if (tmpData == "添加成功"){
                print("添加成功")
                
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "添加地址成功"
                self.finish.dismiss(afterDelay: 1.1, animated: true)
                
                BGNetwork().delay(1.1, closure: { () -> () in
                    self.navigationController!.popViewController(animated: true)
                })
                
                
                
            }else{
                print("添加失败")
                
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "添加失败"
                self.finish.dismiss(afterDelay: 1.1, animated: true)
            }
            
            
            }, failure: { () -> Void in
                
                print("false")
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "添加失败"
                self.finish.dismiss(afterDelay: 1.1, animated: true)
        })

        
        
    }
    //修改地址
    func editId(){
        
        
        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = "修改中..."
        self.finish.show(in: self.view, animated: true)
        
        var editId = ""
        if let editId1:String = self.dataDic.value(forKey: "ressid") as? String {
            editId = editId1
            print("editId1:\(editId1)")
        }
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/ressmanage.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        //--------------------------
        
        let consignee:String = self.nameTF.text! //收货人姓名
        let phone:String = self.phoneTF.text! //手机号
        let contaddr:String = self.detailAddTF.text! //详细地址
        let contzipcode:String = self.zipCodeTF.text! //邮编
        
        //省市区
        
        //省
        let pro:String = self.proLabel.text!
        print("省份：\(pro)")
        var proVal = ""
        
        if let tepProDic:NSDictionary = UserDefaults.standard.value(forKey: "selfproDic") as? NSDictionary{
            let proVal1:String = (tepProDic.value(forKey: pro) as? String)!
            proVal = proVal1
            print("proVal:\(proVal)")
        }
        
        
        //市
        let city:String = self.cityLabel.text!
        print("市区：\(city)")
        var cityVal = ""
        
        if let tepcCityDic:NSDictionary = UserDefaults.standard.value(forKey: "selfcityDic") as? NSDictionary{
            
            let cityVal1:String = (tepcCityDic.value(forKey: city) as? String)!
            cityVal = cityVal1
            print("cityVal:\(cityVal)")
            
        }
        
        
        //区
        let area:String = self.areaLabel.text!
        print("区域：\(area)")
        var areaVal = ""
        
        if let tepcAreaDic:NSDictionary = UserDefaults.standard.value(forKey: "selfareaDic") as? NSDictionary{
            let areaVal1:String = (tepcAreaDic.value(forKey: area) as? String)!
            areaVal = areaVal1
            print("areaVal\(areaVal)")
        }
        
        var dicDPost = NSDictionary()
        
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            
            "consignee":consignee,//姓名
            "phone":phone,//手机号
            "contaddr":contaddr,//详细地址
            "contzipcode":contzipcode,//邮编
            "province":proVal,
            "province_name":pro,
            "city":cityVal,
            "city_name":city,
            "county":areaVal,
            "county_name":area,
            "default":"0",
            "editId":editId,
        ]
        
        
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("json:\(json)")


                    
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "修改地址成功"
                self.finish.dismiss(afterDelay: 1.1, animated: true)
                    
                BGNetwork().delay(1.1, closure: { () -> () in
                    self.navigationController!.popViewController(animated: true)
                })

            
            }, failure: { () -> Void in
                
                print("false")
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "修改地址失败"
                self.finish.dismiss(afterDelay: 1.1, animated: true)
        })
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        self.nameTF.delegate = self
        self.phoneTF.delegate = self
        self.detailAddTF.delegate = self
        self.zipCodeTF.delegate = self
        
        //点击 return 收起键盘
        if(textField == self.nameTF || textField == self.phoneTF) || textField == self.detailAddTF || textField == zipCodeTF {
            
            self.view.becomeFirstResponder()
        }
        
        self.view.endEditing(true )
        return true
    }
    //点击空白，收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nameTF.resignFirstResponder()
        self.phoneTF.resignFirstResponder()
        self.detailAddTF.resignFirstResponder()
        self.zipCodeTF.resignFirstResponder()
    }
    
    
    
}
