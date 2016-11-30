//
//  LoginViewController.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 15/10/19.
//  Copyright (c) 2015 Sqluo. All rights reserved.
//

import UIKit

//第一次注册用户是否退出登录
var isLogOutIn = false




//头像
var iconurl: String!
//资料完成度
var datamuch: String!
//昵称
var nickname = ""

//banner四图
var bannerArray: [AnyObject]!

//最后一次检测时间
var lastbstime: String?

class LoginViewController: UIViewController, UITextFieldDelegate ,UIGestureRecognizerDelegate,UINavigationControllerDelegate{
    
    var finish:JGProgressHUD!
    //新界面--------------->>>>>>>>>>>>>>>>>>>>>
    //用户名
    @IBOutlet weak var uNameView: UIView!
    @IBOutlet weak var uNameTF: UITextField!
    //密码
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var pwdTF: UITextField!
    //登录按钮
    @IBOutlet weak var uLoginBtn: UIButton!
    //同意协议按钮
    @IBOutlet weak var uAgreedBtn: UIButton!
    @IBOutlet weak var uAgreedLabel: UILabel!
    //忘记密码按钮
    @IBOutlet weak var uPassPwdView: UIView!
    @IBOutlet weak var uPassPwdBtn: UIButton!
    //注册按钮
    @IBOutlet weak var uRegisterBtn: UIButton!
    //新界面---------------<<<<<<<<<<<<<<<<<<<<<<
    
    
    
    
    //用户协议
    @IBOutlet weak var informedConsentBtn: UIButton!
    //复选框
    @IBOutlet weak var selectBtn: UIButton!
    
 
    
    
    @IBOutlet weak var uNameViewToLeft: NSLayoutConstraint!//47
    @IBOutlet weak var uNameViewToRight: NSLayoutConstraint!//48
    
    
    @IBOutlet weak var versionLabel: UILabel!
    
    
  
    
    var to999Btn:UIButton!
    
    
    var attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: 12.0),
        NSForegroundColorAttributeName:UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1),
        NSUnderlineStyleAttributeName : 1] as [String : Any]
    var attributedString = NSMutableAttributedString(string:"")
    
    
    
    //是否同意 用户协议（false 为未同意）
    var xieyiState:Bool = false
    
    //是否弹出阅读协议
    var tanchu:Bool = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.pwdTF.delegate = self
        self.uNameTF.delegate = self
        
        self.setLayOut()//适配布局
        self.setNavBack()//设置导航栏标题跟背景颜色
        self.setBtn()//设置按钮
        
        //-------------新>>>>>>>>>>>
        self.setuView()
    
        // 得到当前应用的版本号
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as? String
        
        if let version = currentAppVersion {
            self.versionLabel.text = "v" + version
        }
        
    }
    
    func setLayOut(){
        
        let Wsize = UIScreen.main.bounds.width / 375.0
        self.uNameViewToLeft.constant = 47 * Wsize
        self.uNameViewToRight.constant = 48 * Wsize
        
    }
    
    //设置视图
    func setuView(){
        //用户名视图
        self.uNameView.layer.cornerRadius = 4
        self.uNameView.layer.masksToBounds = true
        self.uNameView.layer.borderWidth = 0.5
        self.uNameView.layer.borderColor = UIColor.gray.cgColor
        
        //密码视图
        self.pwdView.layer.cornerRadius = 4
        self.pwdView.layer.masksToBounds = true
        self.pwdView.layer.borderWidth = 0.5
        self.pwdView.layer.borderColor = UIColor.gray.cgColor
        
        //设置登录 圆角
        self.uLoginBtn.layer.cornerRadius = 4
        uLoginBtn.clipsToBounds = true
        //注册按钮
        
        self.uRegisterBtn.layer.cornerRadius = 4
        self.uRegisterBtn.layer.masksToBounds = true
        self.uRegisterBtn.layer.borderWidth = 0.5
        self.uRegisterBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
        
  
    }
        

    
    func setBtn(){
        self.uRegisterBtn.addTarget(self, action: #selector(self.goToRegister), for: UIControlEvents.touchUpInside)
        self.uLoginBtn.addTarget(self, action: #selector(self.loginAction), for: UIControlEvents.touchUpInside)
        self.uPassPwdBtn.addTarget(self, action: #selector(self.goTOFindpwd), for: UIControlEvents.touchUpInside)
  
        //协议按钮
        let buttonTitleStr = NSMutableAttributedString(string:"已阅读并同意《用户协议》", attributes:attrs)
        self.attributedString.append(buttonTitleStr)
        self.informedConsentBtn.setAttributedTitle(attributedString, for: UIControlState())
        
        self.informedConsentBtn.addTarget(self, action: #selector(self.informedConsentAct), for: UIControlEvents.touchUpInside)
        self.selectBtn.addTarget(self, action: #selector(self.selectAct), for: UIControlEvents.touchUpInside)
        
    }
    
    func informedConsentAct(){
        

        let userAgreeVC = UserAgreementViewController()
        
        self.navigationController?.pushViewController(userAgreeVC, animated: true)
    
    }
    
    func selectAct(){
        if (self.xieyiState == true) {
            //已经同意协议->
            self.selectBtn.setImage(UIImage(named: "Rectangle41"), for: UIControlState())
            self.xieyiState = false

            UserDefaults.standard.set(false, forKey: "XIEYIKEY")
            
        }else{
            //没有同意协议->
            self.selectBtn.setImage(UIImage(named: "group3.png"), for: UIControlState())
            self.xieyiState = true

            UserDefaults.standard.set(true, forKey: "XIEYIKEY")
            
        }
    }

    //MARK:- 设置 导航栏背景图片。名字
    func setNavBack(){
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
 
        self.navigationItem.title = "登录"

        //设置导航栏背景颜色
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
    }
    //MARK:版本号
    var currentAppVersion:String!
    var appVersion:String!
    var upDataValue:String = ""
    
    
    func backAct(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isLogOutIn = false
//        (UIApplication.sharedApplication().delegate as! AppDelegate).baseTabBarVC!.tabBarBgView.hidden = true
        
        let backBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backAct))
        backBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1, green: 1, blue: 1, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
        self.navigationItem.leftBarButtonItem = backBtn
        
        
        // 得到当前应用的版本号
        let infoDictionary = Bundle.main.infoDictionary
        let currentVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        self.currentAppVersion = currentVersion

 
       self.setNavBack()
       
        if let xieyi:Bool = UserDefaults.standard.value(forKey: "XIEYIKEY") as? Bool{
            self.xieyiState = xieyi
            
            if (xieyi == true) {

                
                self.selectBtn.setImage(UIImage(named: "group3.png"), for: UIControlState())
                
            }else{

                self.selectBtn.setImage(UIImage(named: "Rectangle41"), for: UIControlState())
            }

        }else{
            //如果没有，就创建一个 值为 false
            UserDefaults.standard.set(false, forKey: "XIEYIKEY")
            self.xieyiState = false

            self.selectBtn.setImage(UIImage(named: "Rectangle41"), for: UIControlState())
        }
        
        
        
        if let username:String = UserDefaults.standard.object(forKey: "username") as? String,
            let password:String = UserDefaults.standard.object(forKey: "password") as? String{
            self.uNameTF.text = username
            self.pwdTF.text = password

            
        }

        
        if self.appVersion == nil {
            //MARK:获取后台版本号
            self.getInterVersion()
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if ((self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer))) != nil) {
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        }
        
   

    }
    

    
    func getInterVersion(){
        LoginService().getInterVersion(self.view) { (success, version, explain) in
            
            if success {
                
                if let vers = version {
                    self.appVersion = vers
                }
                if let exp = explain {
                    self.upDataValue = exp
                }
                
                //登录 or 更新
                self.isToUpdateOrLogin()
                
            }else{
                if let username = UserDefaults.standard.object(forKey: "username") as? String,
                    let password = UserDefaults.standard.object(forKey: "password") as? String{
                    self.uNameTF.text = username
                    self.pwdTF.text = password
                 
                }
            }
            
            
            
        }
    }
    
    
    
    //isToUpdate
    func isToUpdateOrLogin(){

        if self.appVersion != nil {
            
            let bendi:Double = Double(self.currentAppVersion)!
            let fuwuqi:Double = Double(self.appVersion)!
            
            if fuwuqi > bendi { //需要更新了
                let actionSheet = UIAlertController(title: "发现新版本", message: "\(self.upDataValue)", preferredStyle: UIAlertControllerStyle.alert)
                actionSheet.addAction(UIAlertAction(title: "前往下载", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
                    var str = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1046344761"
//                    var str = "http://www.59medi.com/mobile/down/download.jsp"
                    if let bundleID = Bundle.main.bundleIdentifier{
                        switch bundleID{
                            
                        case "com.59medi.app.BloodGlucose":
                            str = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1046344761"
                        default:
                            str = "http://www.59medi.com/mobile/down/download.jsp"
                        }
                    }

                    let url:URL = URL(string: str)!
                    
                    //如果有之前保存的登陆记录，则填写之前的用户名密码
                    if let username = UserDefaults.standard.object(forKey: "username") as? String,
                        let password = UserDefaults.standard.object(forKey: "password") as? String{
                        self.uNameTF.text = username
                        self.pwdTF.text = password
                    }
                    UIApplication.shared.openURL(url)
                    
                }))

                actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (alrt:UIAlertAction) in
                    //取消更新，直接登录
                    if (self.xieyiState == true){
                        //如果有之前保存的登陆记录，则填写之前的用户名密码
                        if let username:String = UserDefaults.standard.object(forKey: "username") as? String,
                            let password:String = UserDefaults.standard.object(forKey: "password") as? String{
                            self.uNameTF.text = username
                            self.pwdTF.text = password

                            //自动登陆
                            self.loginAction()
                            
                        }else{
                            self.uNameTF.text = ""
                            self.pwdTF.text = ""
                        }
  
                    }else{
                        print("请阅读并同意用户协议")
                        if (self.tanchu == true) {
                            self.tanchu = false
                            //如果有之前保存的登陆记录，则填写之前的用户名密码
                            if let username:String = UserDefaults.standard.object(forKey: "username") as? String,
                                let password:String = UserDefaults.standard.object(forKey: "password") as? String{
                                self.uNameTF.text = username
                                self.pwdTF.text = password
                            }

                            let alrtView = UIAlertView(title: "请您阅读用户协议", message: "", delegate: nil, cancelButtonTitle: "确定")
                            alrtView.show()
                        }
                    }
   
                }))
                
                self.present(actionSheet, animated: true, completion: nil)

            }else{
                print("登录")

                
                if (self.xieyiState == true){
                    //如果有之前保存的登陆记录，则填写之前的用户名密码
                    if let username:String = UserDefaults.standard.object(forKey: "username") as? String,
                        let password:String = UserDefaults.standard.object(forKey: "password") as? String{
                        uNameTF.text = username
                        pwdTF.text = password

                        //自动登陆
                        loginAction()
                        
                    }
                }else{
                    print("请阅读并同意用户协议")
                    if (self.tanchu == true) {
                        self.tanchu = false
                        let alrtView = UIAlertView(title: "请您阅读用户协议", message: "", delegate: nil, cancelButtonTitle: "确定")
                        alrtView.show()
                    }
                    
                }
                
                
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    func goTOFindpwd(){
        
        self.performSegue(withIdentifier: "toFindpwd", sender: self)
    }

    
    func goToRegister(){
        self.performSegue(withIdentifier: "toRegister", sender: self)

    }

    func loginAction(){
        
        self.pwdTF.resignFirstResponder()
        
        if (self.xieyiState == true) {

            let username = self.uNameTF.text!
            let password = self.pwdTF.text!
            
            if (username.characters.count <= 0 || password.characters.count <= 0) {
                
                let alertView:UIAlertView = UIAlertView(title: "请输入用户名或密码", message: "请确保用户名和密码均正确输入", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()

                return
            }
            
            
            LoginService().login(self.view, username: username, password: password, clourse: { (success, isShow) in
                
                if success {
                    self.perfToFirstView(username, psd: password ,show: isShow)
                }
 
            })

     
        }else{
            
            let alrtView = UIAlertView(title: "您还没有同意用户协议", message:  "", delegate: nil, cancelButtonTitle: "确定")
            alrtView.show()
            
        }
    
    }
    
    //入口分流
    func perfToFirstView(_ name:String,psd:String,show:Bool){
        
        //保存账号密码
        UserDefaults.standard.set(name, forKey: "username")
        UserDefaults.standard.set(psd, forKey: "password")
    
        //true 进入入口 false 进入首页  此处 应该写 false
        if show == false{

            self.performSegue(withIdentifier: "toBaseTabBar", sender: self)
        }else{
            self.performSegue(withIdentifier: "toStage", sender: self)
        }
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if (textField == self.pwdTF){
            self.view.becomeFirstResponder()
            self.loginAction()
        }
        if (textField == self.uNameTF){
            self.pwdTF.becomeFirstResponder()
        }
        return true
    }
    //点击空白，收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pwdTF.resignFirstResponder()
        self.uNameTF.resignFirstResponder()
    }
    
    
   
    
}
