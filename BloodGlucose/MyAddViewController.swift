//
//  MyAddViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyAddViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    var myTabView:UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "收货地址"
        self.view.backgroundColor = UIColor.white
        
        //设置导航栏
        self.setNav()
        
        //tabview
        self.setTabView()
        
        
        
    }

    func setNav(){
        
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(MyAddViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 1
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        //右
        let (rightBtn,rightspacer,rightItem) = BGNetwork().creatRightBtn()
        rightBtn.addTarget(self, action: #selector(MyAddViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        rightBtn.tag = 2
        self.navigationItem.rightBarButtonItems = [rightspacer,rightItem]
        
        
        
    }
    func someBtnAct(_ send:UIButton){
        switch send.tag {
        case 1:
            self.navigationController!.popViewController(animated: true)
        case 2:
            print("添加")
            
            let myAddManageVC = MyAddManageViewController()
            self.navigationController?.pushViewController(myAddManageVC, animated: true)

        default:
            break
        }
    }
    func setTabView(){
        self.myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height - 64 + 49))
        
        self.myTabView.delegate = self
        self.myTabView.dataSource = self
        
        
        
        self.view.addSubview(self.myTabView)
        
        myTabView.tableFooterView = UIView()
        
        myTabView.estimatedRowHeight = 44.0
        myTabView.rowHeight = UITableViewAutomaticDimension
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setNavAndTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("已经出现")
        
        self.setNavAndTabBar()
  
 
        self.getAdds()

    }
    
    
    func setNavAndTabBar(){
        BaseTabBarView.isHidden = true
        CAGradientLayerEXT().animation(false)
        
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        var frame = self.navigationController?.navigationBar.frame
        frame?.origin.x = 0
        self.navigationController?.navigationBar.frame = frame!
    }
    
    
    
    //--------------
    var addNameArray    = [String]()
    var addPhoneArray   = [String]()
    var addAreaArray    = [String]()
    var addDefualtArray = [String]()
    var addRessidArray  = [String]()
    //省市区
    var addProArray     = [String]()
    var addCityArray    = [String]()
    var addCountyArray  = [String]()
    
    
    //。。。菊花
    var finish:JGProgressHUD!
    
    
    var imgView:UIImageView!
    var promptLabel:UILabel!
    func getAdds(){
 
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
   
            if let dataArray = json["data"].arrayObject{
                
                if dataArray.isEmpty {
                    //没有数据

                    self.imgView = UIImageView(frame: CGRect(x: (UIScreen.main.bounds.width - 133 / 2) / 2, y: 100, width: 133 / 2, height: 114 / 2))
                    self.imgView.image = UIImage(named: "menunotAdd")
                    self.view.addSubview(self.imgView)
                    
                    self.promptLabel = UILabel(frame: CGRect(x: 0,y: 100 + 114 / 2 + 15,width: UIScreen.main.bounds.width,height: 30))
                    self.promptLabel.textColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
                    self.promptLabel.font = UIFont.systemFont(ofSize: 16)
                    self.promptLabel.text = "您还没有添加任何地址"
                    self.promptLabel.textAlignment = NSTextAlignment.center
                    self.view.addSubview(self.promptLabel)
                    
                    
                }else{
                    //有数据
                    if self.imgView != nil{
                        self.imgView.removeFromSuperview()
                        self.imgView = nil
                    }
                    if self.promptLabel != nil{
                        self.promptLabel.removeFromSuperview()
                        self.promptLabel = nil
                    }

                    var tmpNameArray    = [String]()
                    var tmpPhoneArray   = [String]()
                    var tmpAreaArray    = [String]()
                    var tmpDefualtArray = [String]()
                    var tmpRessidArray  = [String]()
                    
                    //省市区
                    var tmpProArray     = [String]()
                    var tmpCityArray    = [String]()
                    var tmpCountyArray  = [String]()
                    
                    for item in dataArray{
                        
                        let tmpdic = item as! NSDictionary
                        
                        let recipient       = tmpdic.value(forKey: "recipient") as! String
                        let phone           = tmpdic.value(forKey: "phone") as! String
                        
                        let province        = tmpdic.value(forKey: "province") as! String
                        let city            = tmpdic.value(forKey: "city") as! String
                        let county          = tmpdic.value(forKey: "county") as! String
                        let detailaddress   = tmpdic.value(forKey: "detailaddress") as! String
                        
                        let ressid:String   = String(describing: tmpdic.value(forKey: "ressid") as! NSNumber)
                        
                        
                        //地区
                        let area            = province + city + county
                        
                        
                        tmpNameArray.append(recipient)
                        tmpPhoneArray.append(phone)
                        tmpAreaArray.append(area)
                        tmpDefualtArray.append(detailaddress)
                        tmpRessidArray.append(ressid)
                        //省市区
                        tmpProArray.append(province)
                        tmpCityArray.append(city)
                        tmpCountyArray.append(county)
                        
                    }
                    
                    self.addNameArray       = tmpNameArray
                    self.addPhoneArray      = tmpPhoneArray
                    self.addAreaArray       = tmpAreaArray
                    self.addDefualtArray    = tmpDefualtArray
                    self.addRessidArray     = tmpRessidArray
                    //省市区
                    self.addProArray        = tmpProArray
                    self.addCityArray       = tmpCityArray
                    self.addCountyArray     = tmpCountyArray
                    
                }
  
                
            }
            
            self.myTabView.reloadData()
     
            
            }, failure: { () -> Void in
                
                print("false")

                let alrtView = UIAlertView(title: "网络错误", message: "请检查网络或稍后重试", delegate: nil, cancelButtonTitle: "确定")
                alrtView.show()
                
                
        })
        
        
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tableView 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addNameArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "MyAddCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? MyAddTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("MyAddTableViewCell", owner: self, options: nil )?.last as? MyAddTableViewCell
            
        }
        
        cell?.addCellValueClosur = self.cellValueClosur
        
        
        cell?.nameLabel.text = self.addNameArray[(indexPath as NSIndexPath).row]
        cell?.phoneLabel.text = self.addPhoneArray[(indexPath as NSIndexPath).row]
        cell?.addressLabel.text = self.addAreaArray[(indexPath as NSIndexPath).row] + self.addDefualtArray[(indexPath as NSIndexPath).row]
        
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        return cell!
    }
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        print("123456")
        
        
        
        
    }
    //回调
    func cellValueClosur(_ cell: AnyObject,index: Int)->Void{
        let myAddCell = cell as! MyAddTableViewCell

        let indexPaht:IndexPath = myTabView.indexPath(for: myAddCell)!
        
        print((indexPaht as NSIndexPath).row)
        
        switch index {
        case 1:
            print("默认地址")
   
        case 2:
            print("编辑")
            
            let name:String = self.addNameArray[(indexPaht as NSIndexPath).row]
            let phone = self.addPhoneArray[(indexPaht as NSIndexPath).row]
            let area = self.addAreaArray[(indexPaht as NSIndexPath).row]
            let defualt = self.addDefualtArray[(indexPaht as NSIndexPath).row]
            
            let tmpArray = [name,phone,area,defualt,""]

            let tmpUploadDic:[String:String] = ["consignee":name,
                                                "phone":phone,
                                                "province_name":self.addProArray[(indexPaht as NSIndexPath).row],
                                                "city_name":self.addCityArray[(indexPaht as NSIndexPath).row],
                                                "county_name":self.addCountyArray[(indexPaht as NSIndexPath).row],
                                                "contaddr":defualt,
                                                "editId":self.addRessidArray[(indexPaht as NSIndexPath).row]]
            
            let myAddManageVC = MyAddManageViewController()
            
            myAddManageVC.valueArray = tmpArray
            myAddManageVC.isEdit = true
            myAddManageVC.uploadADMDic = tmpUploadDic
            self.navigationController?.pushViewController(myAddManageVC, animated: true)

        case 3:
            print("删除")
            
            let actionSheet = UIAlertController(title: "是否删除该地址", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in

                let tmpEditId = self.addRessidArray[(indexPaht as NSIndexPath).row]
                self.removeId(tmpEditId,indexRow: (indexPaht as NSIndexPath).row)
                
            }))
            actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)

        default:
            break
        }
   
        
    }
    
    //删除地址
    func removeId(_ editId: String,indexRow: Int){
        
        
        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = "删除中..."
        self.finish.show(in: self.view, animated: true)
        
        
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
            self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.finish.textLabel.text = "删除成功"
            self.finish.dismiss(afterDelay: 0.5, animated: true)
            
            self.addNameArray.remove(at: indexRow)
            self.addPhoneArray.remove(at: indexRow)
            self.addAreaArray.remove(at: indexRow)
            self.addDefualtArray.remove(at: indexRow)
            self.addRessidArray.remove(at: indexRow)
            
            self.addProArray.remove(at: indexRow)
            self.addCityArray.remove(at: indexRow)
            self.addCountyArray.remove(at: indexRow)
            
            self.myTabView.reloadData()

            
            }, failure: { () -> Void in
                
                print("false")
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "网络错误"
                self.finish.dismiss(afterDelay: 0.5, animated: true)
        })
        
        
        
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
