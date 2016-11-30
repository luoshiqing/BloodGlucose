//
//  AddViewController.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 15/12/30.
//  Copyright © 2015年 nash_su. All rights reserved.
//

import UIKit

var TOADDMANAGE:Bool = false



class AddViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //。。。菊花
    var finish:JGProgressHUD!
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var myHiddenView: UIView!
    
    @IBOutlet weak var addDBtn: UIButton!
    
    
    var dataArray = NSMutableArray()
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "地址"
        //设置导航栏按钮
        self.setNavBtn()
        //设置按钮
        self.setBtn()
        
        self.myTableView.tableFooterView = UIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.myTableView.reloadData()
        //获取用户收货地址
        self.getAdds()
    }
    func setBtn(){
        self.addDBtn.tag = 16010401
        self.addDBtn.addTarget(self, action: #selector(AddViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
    }
    func setNavBtn(){
        //返回
        let leftBtn = UIBarButtonItem(title:"返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddViewController.btnAct(_:)))
        leftBtn.tag = 123031
        leftBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
        self.navigationItem.leftBarButtonItem = leftBtn
        
        //添加
        let rightBtn = UIBarButtonItem(title:"添加", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddViewController.btnAct(_:)))
        rightBtn.tag = 123032
        rightBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    func btnAct(_ send:UIButton){
        switch send.tag{
        case 123031:
            print("返回")
            
            self.navigationController!.popViewController(animated: true)
            
        case 123032:
            print("添加")
           
            self.dataArray.removeAllObjects()
            
            TOADDMANAGE = false
            
            let addmanageVC = AddManageViewController(nibName: "AddManageViewController", bundle: Bundle.main)
            
            self.navigationController?.pushViewController(addmanageVC, animated: true)
        case 16010401:
            print("16010401")
            
            
            self.dataArray.removeAllObjects()
            
            TOADDMANAGE = false
            
            let addmanageVC = AddManageViewController(nibName: "AddManageViewController", bundle: Bundle.main)
            
            self.navigationController?.pushViewController(addmanageVC, animated: true)
            
            
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAdds(){
        
        
        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = "加载中..."
        self.finish.show(in: self.view, animated: true)
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/getresslist.jsp"
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
            
            print("json:\(json)")

            
            self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.finish.textLabel.text = "加载成功"
            self.finish.dismiss(afterDelay: 0.5, animated: true)
            
            
            var userDic:NSDictionary = NSDictionary()
            
            
            var array = NSArray()
            
            if let tmpData:NSArray = json["data"].arrayObject as NSArray?{
                array = tmpData
                print("array:\(array)")
            }
            
            if(array.count <= 0){
                self.myHiddenView.isHidden = false
                self.myTableView.isHidden = true
            }else{
                self.myHiddenView.isHidden = true
                self.myTableView.isHidden = false
                
            }
            
            
            for dataDic in array {
                
                
                
//                print("dataDic:\(dataDic)")
                let dateAArray = NSMutableArray()
                
                var city = ""
                var county = ""
                var detailaddress = ""
                var phone = ""
                var province = ""
                var recipient = ""
                var ressid = ""
                var type = 0
                
                
                
                if let ressid1 = (dataDic as AnyObject).value(forKey: "ressid") {
                    ressid = String(describing: ressid1)
                }
                
                if let city1:String = (dataDic as AnyObject).value(forKey: "city") as? String{
                    city = city1
//                    print("city:\(city)")
                }
                if let county1:String = (dataDic as AnyObject).value(forKey: "county") as? String{
                    county = county1
//                    print("county:\(county1)")
                }
                if let detailaddress1:String = (dataDic as AnyObject).value(forKey: "detailaddress") as? String{
                    detailaddress = detailaddress1
//                    print("detailaddress:\(detailaddress)")
                }
                if let phone1:String = (dataDic as AnyObject).value(forKey: "phone") as? String{
                    phone = phone1
//                    print("phone:\(phone)")
                }
                if let province1:String = (dataDic as AnyObject).value(forKey: "province") as? String{
                    province = province1
//                    print("province:\(province)")
                }
                if let recipient1:String = (dataDic as AnyObject).value(forKey: "recipient") as? String{
                    recipient = recipient1
//                    print("recipient:\(recipient)")
                }

                if let type1:Int = (dataDic as AnyObject).value(forKey: "type") as? Int{
                    type = type1
//                    print("type:\(type)")
                }
                
                userDic = [
                    "city":city,
                    "county":county,
                    "detailaddress":detailaddress,
                    "phone":phone,
                    "province":province,
                    "recipient":recipient,
                    "ressid":ressid,
                    "type":type,
                
                ]
                
                
                dateAArray.add(userDic)
                self.dataArray.addObjects(from: dateAArray as [AnyObject])
                
                
                
            }
            
            
            print("dataArray:\(self.dataArray)")
            
            self.myTableView.reloadData()

            }, failure: { () -> Void in
                
                print("false")
        })
        
        
    }

   

    //tableView 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "addtCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? AddTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("AddTableViewCell", owner: self, options: nil )?.last as? AddTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell?.nameLabel.text = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "recipient") as? String
        cell?.phoneNumLabel.text = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "phone") as? String
        
        var province = ""
        var city = ""
        var county = ""
        var detailaddress = ""
        
        if let province1:String = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "province") as? String{
            province = province1
        }
        if let city1:String = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "city") as? String{
            
            if (city1 == "市辖区"){
                city = ""
            }else{
                city = city1
            }
        }
        
        if let county1:String = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "county") as? String{
            county = county1
        }
        if let detailaddress1 = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "detailaddress") as? String{
            detailaddress = detailaddress1
        }
        
        
        
        cell?.addLabel.text = "\(province)\(city)\(county)\(detailaddress)"
        
        
        return cell!
    }

    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        TOADDMANAGE = true
        
        let addmanageVC = AddManageViewController(nibName: "AddManageViewController", bundle: Bundle.main)
        
        self.navigationController?.pushViewController(addmanageVC, animated: true)
        
        addmanageVC.dataDic = self.dataArray[(indexPath as NSIndexPath).row] as! NSDictionary
        
        self.dataArray.removeAllObjects()
        
        
    }
    
}
