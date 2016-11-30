//
//  RegisterViewController.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 15/10/19.
//  Copyright (c) 2015 Sqluo. All rights reserved.
//

import UIKit
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


class RegisterViewController: UIViewController, UITextFieldDelegate {
    

    
    
    //记录用户名是否可用
    var isAvailable = true

    //用户名是否可用
    @IBOutlet weak var yonghumingLabel: UILabel!

    @IBOutlet weak var usernameTextField: UITextField!  //用户名
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var captchaTextField: UITextField!
   
    @IBOutlet weak var captchaBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var captchaView: UIView!
    

    
    var timeIndex:Int = 60      //倒计时数字
    
    var timme:Timer!
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "注册"

        //自定义返回按钮
        creatBackBtn()
        //设置
        setIb()
        //设置视图圆角跟边框
        self.setViewAndRound()


    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if ((self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer))) != nil) {
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
        }
    }
    func setViewAndRound(){
        //用户名视图
        self.usernameView.layer.cornerRadius = 4
        self.usernameView.layer.masksToBounds = true
        self.usernameView.layer.borderWidth = 0.5
        self.usernameView.layer.borderColor = UIColor.gray.cgColor
        
        //密码视图
        self.passwordView.layer.cornerRadius = 4
        self.passwordView.layer.masksToBounds = true
        self.passwordView.layer.borderWidth = 0.5
        self.passwordView.layer.borderColor = UIColor.gray.cgColor
        
        //验证码视图
        self.captchaView.layer.cornerRadius = 4
        self.captchaView.layer.masksToBounds = true
        self.captchaView.layer.borderWidth = 0.5
        self.captchaView.layer.borderColor = UIColor.gray.cgColor
        
        self.registerBtn.layer.cornerRadius = 4
        self.registerBtn.layer.masksToBounds = true
        
        self.captchaBtn.layer.cornerRadius = 4
        self.captchaBtn.layer.masksToBounds = true
    }
    
    

    
    //自定义返回按钮
    func creatBackBtn(){
        
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(RegisterViewController.backAction), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
    
    }
    func setIb(){
        //设置代理
        usernameTextField.delegate = self
        //添加点击事件
        captchaBtn.addTarget(self, action: #selector(RegisterViewController.captchaBtnAction), for: UIControlEvents.touchUpInside)
        registerBtn.addTarget(self, action: #selector(RegisterViewController.registerNew), for: UIControlEvents.touchUpInside)
    }
    func creatTimmer(){
        timme = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(RegisterViewController.timmerAction), userInfo: nil, repeats: true)
        timme.fire()
    }
    func timmerAction(){
        if (timeIndex > -1){
            self.captchaBtn.isEnabled = false
            self.captchaBtn.setTitle("\(String(timeIndex))s", for: UIControlState())
            timeIndex = timeIndex - 1
            print("倒计时：\(timeIndex)")
            
        }else {
            self.captchaBtn.backgroundColor =  UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            self.captchaBtn.setTitleColor(UIColor.white, for: UIControlState())
            captchaBtn.setTitle("获取验证码", for: UIControlState())
            captchaBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            if (timme != nil){
                timme.invalidate()
                timme = nil
            }
            captchaBtn.isEnabled = true
            self.timeIndex = 60
        }
        
    }
    

    func backAction(){
        if (timme != nil){
            timme.invalidate()
            timme = nil
        }
        self.navigationController!.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
 
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let username = usernameTextField.text! as NSString
        
        //检查用户名长度
        if username.length == 11{
            BGNetwork().checkUsername(username as String, onComplete: { (finished, state, reason) -> Void in
                if finished == true{
                    if state {
                        //不可用
                        self.showYongHuMingLabel(false, show: true)
                        
                        self.isAvailable = false
                        
                        self.captchaBtn.isEnabled = false
                        
                        self.registerBtn.isEnabled = false
                        
                    }else{
                        //可用
                        self.showYongHuMingLabel(true, show: true)
                        
                        self.isAvailable = true
                        
                        self.captchaBtn.isEnabled = true
                        
                        self.registerBtn.isEnabled = true
                    }
                }
                }, onError: { (error) -> Void in
                    //网络错误
                    self.showYongHuMingLabel(false, show: false)
                    let alertView:UIAlertView = UIAlertView(title: "网络错误", message: "请检查网络", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
            })
        }else{
            
            let alertView:UIAlertView = UIAlertView(title: "手机号错误", message: "请输入正确的手机号码", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
    }
    
    
    
    //显示用户名是否可用
    func showYongHuMingLabel(_ status:Bool,show:Bool){
        if (show == true){
            self.yonghumingLabel.isHidden = false
            //用户名可用
            if(status == true){
                self.yonghumingLabel.text = "用户名可用"
                self.yonghumingLabel.textColor = UIColor(red: 0.16, green: 0.64, blue: 0.85, alpha: 1)
            }else{
                //用户名不可用
                self.yonghumingLabel.text = "用户名已被用"
                self.yonghumingLabel.textColor = UIColor.red
            }
            
        }else{
           self.yonghumingLabel.isHidden = true
        }
    }

    //MARK:- 获取验证码
    func captchaBtnAction(){
     
        print("获取验证码！")

    
        if let userName:String = usernameTextField.text{
             print("userName\(userName)")
            
            if (userName.characters.count == 11){
                
                
                
                BGNetwork().getYanZhengMa(userName as String, onComplete: { (finished, reason, userInfo) -> Void in
                    if finished{
                        let alertView:UIAlertView = UIAlertView(title: "验证码已发送至您的手机", message: "请注意查收", delegate: nil, cancelButtonTitle: "确定")
                        alertView.show()
                    }
                    }, onError: { (error) -> Void in

                        let alertView:UIAlertView = UIAlertView(title: "网络错误", message: "请稍后重试", delegate: nil, cancelButtonTitle: "确定")
                        alertView.show()
               
                    })

                if (timeIndex == 60){
                    //添加一个定时器

                    self.captchaBtn.backgroundColor = UIColor.white
                    self.captchaBtn.setTitle("60s", for: UIControlState())
                    self.captchaBtn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), for: UIControlState())
                    
                    self.captchaBtn.layer.cornerRadius = 4
                    self.captchaBtn.layer.masksToBounds = true
                    self.captchaBtn.layer.borderWidth = 0.5
                    self.captchaBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
                    
                    
                    self.creatTimmer()
                }else{
                    if (timeIndex == -1){
                        
                        captchaBtn.setTitle("发送中..", for: UIControlState())
                        captchaBtn.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
                        timeIndex = 60
                        if (timme != nil){
                            timme.invalidate()
                            timme = nil
                        }
                        self.creatTimmer()
                    }
                }
                
                
            }else{
                print("请输入正确的手机号")
                let alertView:UIAlertView = UIAlertView(title: "请输入正确的手机号", message: "", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()

            }
            

        }
    }

    
    //接受上级的数据
    var infoDataDic = [String:String]()
    
    
     var finish:JGProgressHUD!
    
    //MARK:新注册
    func registerNew(){
        
        if (usernameTextField.text?.characters.count < 11){
            let alertView:UIAlertView = UIAlertView(title: "请输入正确的手机号", message: "手机号为11位", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
        if (passwordTextField.text?.characters.count < 6){
            let alertView:UIAlertView = UIAlertView(title: "密码太过简单", message: "密码最小为六位", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
        if (captchaTextField.text?.characters.count <= 0){
            let alertView:UIAlertView = UIAlertView(title: "请输入验证码", message: "输入收到的验证码", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = "注册中"
        self.finish.show(in: self.view, animated: true)
        
        
        
        let reqUrl:String = "\(TEST_HTTP)/jsp/reguser.jsp"

        var dicDPost = NSDictionary()
        dicDPost = [
            "name":usernameTextField.text!,
            "pwd":passwordTextField.text!,
            "code":captchaTextField.text!,
            "clientid":"10002",
            
        ]
        
        
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
            
            let state:String = json["state"].stringValue
                
            if state == "ok" {
                print("注册成功")
                
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "注册成功"
                self.finish.dismiss(afterDelay: 0.5, animated: true)
                
                
                
                
                BGNetwork().delay(0.51, closure: {
                    
                    if self.timme != nil{
                        self.timme.invalidate()
                        self.timme = nil
                    }
                    
                    UserDefaults.standard.set(self.usernameTextField.text!, forKey: "username")
                    UserDefaults.standard.set(self.passwordTextField.text!, forKey: "password")
                    self.navigationController!.popViewController(animated: true)
                })
                
            }else{
                print("注册失败")
                
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "注册失败"
                self.finish.dismiss(afterDelay: 0.5, animated: true)
            }
            
            
            }, failure: { () -> Void in
                
                print("false错误")
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "网络错误"
                self.finish.dismiss(afterDelay: 0.5, animated: true)
        })
  
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //点击 return 收起键盘
        if(textField == self.usernameTextField || textField == self.passwordTextField || textField == self.captchaTextField){
            //            textField.resignFirstResponder()
            self.view.becomeFirstResponder()
        }
        
        self.view.endEditing(true )
        return true
    }

    //点击空白，收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.passwordTextField.resignFirstResponder()
        self.usernameTextField.resignFirstResponder()
        self.captchaTextField.resignFirstResponder()
   
    }
    
  

}
