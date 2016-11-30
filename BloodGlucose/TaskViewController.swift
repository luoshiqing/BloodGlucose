//
//  TaskViewController.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/1/14.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var jiazai:JGProgressHUD!
    
    //未加载完成显示的图片名称
    var imgString = "loadlogo.png"
    var imgFaild = "loading_failed.png"
    
    
    var fstatusArray = [Int]()
    var frecArray = [Int]()
    var midArray = [String]()
    var mmaterialArray = [String]()
    var fidArray = [String]()
    var mnameArray = [String]()
    var mimgArray = [String]()

    
    @IBOutlet weak var myTabView: UITableView!
    
    @IBOutlet weak var integralLabel: UILabel!//积分
    
    @IBOutlet weak var userNickNameLabel: UILabel!//用户名
    
    
    @IBOutlet weak var iconImgView: UIImageView!// 头像
    
    
    
    
    
    
    @IBOutlet weak var upViewH: NSLayoutConstraint!//160
    
    @IBOutlet weak var diandianViewH: NSLayoutConstraint!//25
    
    
    @IBOutlet weak var nameToImgH: NSLayoutConstraint!//6
    
    @IBOutlet weak var jifenTonameH: NSLayoutConstraint!//9
    
    @IBOutlet weak var ImgToupH: NSLayoutConstraint!//21
    
    @IBOutlet weak var touxH: NSLayoutConstraint!//65
    
    @IBOutlet weak var touxW: NSLayoutConstraint!//65
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "食物清单"

        //设置导航栏
        self.setNav()
        
        //布局
        self.setLayOut()
        
        
        
        
        
        self.myTabView.tableFooterView = UIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //获取任务
        self.getTask()
    }
    

    func setLayOut(){
        let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
        let Wsize = UIScreen.main.bounds.width / 320
        
        upViewH.constant = Hsize * 160
        diandianViewH.constant = Hsize * 25
        nameToImgH.constant = Hsize * 6
        jifenTonameH.constant = Hsize * 9
        ImgToupH.constant = Hsize * 21
        touxH.constant = Wsize * 65
        touxW.constant = Wsize * 65
        
        //设置图片 圆角
        self.iconImgView.layer.cornerRadius = Wsize * 65 / 2.0
        self.iconImgView.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setNav(){
        //返回

        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(self.backAct), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
        //了解积分
        let rightBtn = UIBarButtonItem(title:"了解积分", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.rightAct))
        rightBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    func backAct(){
        self.navigationController!.popViewController(animated: true)
    }
    func rightAct(){
        let integralVC = IntegralViewController(nibName: "IntegralViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(integralVC, animated: true)
    }
    //获取任务列表
    func getTask(){
        
        self.jiazai = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.jiazai.textLabel.text = "加载中."
        self.jiazai.show(in: self.view, animated: true)

        //名称
        var uname = ""
        //积分
        var integral = ""
        //头像url
        var icon = ""
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/getfoodtask.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5]
 

        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
 
            
            if let code:Int = json["code"].int{
                if (code == 1){
                    
                    
                    self.jiazai.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.jiazai.textLabel.text = "加载完成"
                    self.jiazai.dismiss(afterDelay: 0.5, animated: true)

                    
                    self.fstatusArray.removeAll()
                    self.frecArray.removeAll()
                    self.midArray.removeAll()
                    
                    self.mmaterialArray.removeAll()
                    self.fidArray.removeAll()
                    self.mnameArray.removeAll()
                    self.mimgArray.removeAll()
                    
                    //所有数据
                    if let dataDic = json["data"].dictionaryObject as? [String:AnyObject]{

                        if let uname1:String = dataDic["uname"] as? String{
                            uname = uname1
                        }
                        if let integral1:Int = dataDic["integral"] as? Int{
                            integral = String(integral1)
                        }
                        
                        if let icon1:String = dataDic["icon"] as? String {
                            icon = icon1
                        }
                        
                        //食材数组
                        
                        if let shicaiArray = dataDic["data"] as? [[String:AnyObject]]{

                            for tttDic in shicaiArray{
                                
                                //任务状态
                                let fstatus = tttDic["fstatus"] as! Int
                                //是否领取过积分
                                let frec = tttDic["frec"] as! Int
                                //食谱id
                                let mid = String(describing: tttDic["mid"] as! NSNumber)
                                //说明
                                let mmaterial = tttDic["mmaterial"] as! String
                                //任务id
                                let fid = String(describing: tttDic["fid"] as! NSNumber)
                                
                                //食物名称
                                let mname = tttDic["mname"] as! String
                                //食物 url
                                let mimg = tttDic["mimg"] as! String
                                
                                
                                self.fstatusArray.append(fstatus)
                                self.frecArray.append(frec)
                                self.midArray.append(mid)
                                
                                self.mmaterialArray.append(mmaterial)
                                self.fidArray.append(fid)
                                self.mnameArray.append(mname)
                                self.mimgArray.append(mimg)
                                
                                
                            }
                            
                        }
     
                    }
   
 
                }
            }
            
            //刷新表示图
            self.myTabView.reloadData()
            //设置ui
            self.setUI(uname, integral: integral,icon: icon)
            
            }, failure: { () -> Void in
                
                print("false错误")
                self.jiazai.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.jiazai.textLabel.text = "网络错误"
                self.jiazai.dismiss(afterDelay: 0.5, animated: true)
        })

    }
    //设置 名称 积分
    func setUI(_ uname:String,integral:String,icon:String){
        self.userNickNameLabel.text = uname
        self.integralLabel.text = integral
        

        let imgurl:URL = URL(string: icon)!
        self.iconImgView.sd_setImage(with: imgurl, placeholderImage: UIImage(named: "touxiang2.png"))
    }

    //tableview代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(self.mnameArray.count)
        
        if (self.mnameArray.count >= 8 ){
            return 8
        }else{
            return self.mnameArray.count
        }
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let ddd = "taskCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? TaskTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("TaskTableViewCell", owner: self, options: nil )?.last as? TaskTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        if (self.mnameArray.count > 0){
            
            let fstatus = self.fstatusArray[indexPath.row]
            
            let frec = self.frecArray[indexPath.row]
            
            switch fstatus{
            case 0:
                print("未准备")
                cell?.lingquBtn.setTitle("未准备", for: UIControlState())
                cell?.lingquBtn.setTitleColor(UIColor.black, for: UIControlState())
                cell?.lingquBtn.backgroundColor = UIColor(red: 231/255.0, green: 221/255.0, blue: 207/255.0, alpha: 1)
                cell?.lingquBtn.isEnabled = false
                cell?.jinduLabel.text = "未准备"
            case 1:
                print("已准备")
                cell?.lingquBtn.setTitle("未完成", for: UIControlState())
                cell?.lingquBtn.setTitleColor(UIColor.white, for: UIControlState())
                cell?.lingquBtn.backgroundColor = UIColor(red: 214/255.0, green: 105/255.0, blue: 166/255.0, alpha: 1)
                cell?.lingquBtn.isEnabled = false
                cell?.jinduLabel.text = "未完成"
            case 2:
                print("已完成")
                if (frec == 1){
                    //已经领取了积分
                    cell?.lingquBtn.setTitle("已完成", for: UIControlState())
                    cell?.lingquBtn.setTitleColor(UIColor.white, for: UIControlState())
                    cell?.lingquBtn.backgroundColor = UIColor(red: 63/255.0, green: 181/255.0, blue: 97/255.0, alpha: 1)
                    cell?.lingquBtn.isEnabled = false
                    cell?.jinduLabel.text = "已完成"
                }else{
                   //未领取积分
                    cell?.lingquBtn.tag = 2016 + (indexPath as NSIndexPath).row
                    cell?.lingquBtn.addTarget(self, action: #selector(TaskViewController.cellBtnAct(_:)), for: UIControlEvents.touchUpInside)
                    cell?.lingquBtn.setTitle("领取积分", for: UIControlState())
                    cell?.lingquBtn.backgroundColor = UIColor.red
                    cell?.lingquBtn.setTitleColor(UIColor.white, for: UIControlState())
                    cell?.lingquBtn.isEnabled = true
                    cell?.jinduLabel.text = "已完成"
                }
                
            default:
                break
            }

            cell?.nameLabel.text! = self.mnameArray[indexPath.row]

            cell?.shuomLabel.text! = self.mmaterialArray[indexPath.row]
            
            let url1:String = "http://\(self.mimgArray[indexPath.row])"
            //编译
            let aaurl1 = url1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
            let imgurl1:URL = URL(string: aaurl1!)!
            cell?.imgView.sd_setImage(with: imgurl1, placeholderImage: UIImage(named: self.imgString))

            
        }
        
        
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let name = self.mnameArray[indexPath.row]
        let mid = self.midArray[indexPath.row]

        let taskDetailVC = TaskDetailViewController(title: name, mid: mid)
        self.navigationController?.pushViewController(taskDetailVC, animated: true)

    }
    
    
   
    func cellBtnAct(_ send:UIButton){
        let fid:String!
        switch send.tag{
        case 2016:
            print("1")
            fid = self.fidArray[0]
        case 2017:
            print("2")
            fid = self.fidArray[1]
        case 2018:
            print("3")
            fid = self.fidArray[2]
        case 2019:
            print("4")
            fid = self.fidArray[3]
        case 2020:
            print("5")
            fid = self.fidArray[4]
        case 2021:
            print("6")
            fid = self.fidArray[5]
        case 2022:
            print("7")
            fid = self.fidArray[6]
        case 2023:
            print("8")
            fid = self.fidArray[7]
        default:
            fid = "Null"
            break
        }

        if (fid != nil && fid != "Null"){
            self.getIntegral(fid)
        }else{
            print("没有任务fid")
        }
      
    }
    
    //获取积分
    func getIntegral(_ fid:String){

        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/onefoodtaskrec.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "fid":fid]

        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
 
            if let code:Int = json["code"].int{
                if (code == 1){
                    print("加载成功")
                    
                    if let data = json["data"].dictionaryObject as? [String:AnyObject]{
                        let integral:Int = data["integral"] as! Int
                        self.integralLabel.text = "\(integral)"
                    }
                    
                }
    
            }
            
            //重新加载
            self.getTask()
            
            }, failure: { () -> Void in
                
                print("false错误")
                
        })
        
        
    }
    
    
    
    
    
    
    
    
}
