//
//  FindpwdCtr.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 15/10/19.
//  Copyright © 2015年 Sqluo. All rights reserved.
//

import UIKit

class FindpwdCtr: UIViewController, UITextFieldDelegate {
    
    var lastNum:String = ""
    
    @IBOutlet weak var findpwdTextField: UITextField!
    @IBOutlet weak var getpwdBtn: UIButton!
    
    @IBOutlet weak var getPwdLabel: UILabel!
    
    @IBOutlet weak var uNameView: UIView!

    
    var timeIndex:Int = 60      //倒计时数字
    var timme:Timer!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if ((self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer))) != nil) {
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
        }
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        self.getPwdLabel.text = ""

        
        
        findpwdTextField.delegate = self

        //自定义返回按钮
        
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(FindpwdCtr.backAction1), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]

        //设置圆角
        self.setViewRound()
        
    }
 
    func setViewRound(){
        //用户名视图
        self.uNameView.layer.cornerRadius = 4
        self.uNameView.layer.masksToBounds = true
        self.uNameView.layer.borderWidth = 0.5
        self.uNameView.layer.borderColor = UIColor.gray.cgColor
    }
 
    
    func backAction1(){
        
        if(self.timme != nil){
            self.timme.invalidate()
            self.timme = nil
        }
        
        self.navigationController!.popViewController(animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //点击 return 收起键盘
        if(textField == self.findpwdTextField){
            //            textField.resignFirstResponder()
            self.view.becomeFirstResponder()
        }
        
        self.view.endEditing(true )
        return true
    }
    
    //点击空白，收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.findpwdTextField.resignFirstResponder()

    }
   
 

    
    @IBAction func findpwdAct(_ sender: AnyObject) {
        

        getpwdBtn.isEnabled = false
        
        if let userTleNum:String = findpwdTextField.text{
            

            print("\(userTleNum) and count \(userTleNum.characters.count)")
            
            
            if (userTleNum.characters.count == 11){
                
                lastNum = findpwdTextField.text!
                print("输入的手机号为：\(lastNum)")
                

                //倒计时
                if (self.timeIndex == 60){
                    //添加一个定时器
                    self.creatTimmer()
                    
                }else{
                    self.timeIndex = 60
                    if (self.timme != nil){
                        self.timme.invalidate()
                        self.timme = nil
                    }
                    self.creatTimmer()
                }
                
                //找回密码
                LoginService().getPwd(self.view, phoneNum: self.lastNum, clourse: { (isSuccess: Bool) in
                    
                    if !isSuccess {
                        
                        self.getpwdBtn.setTitle("获取密码", for: UIControlState())
                        self.getPwdLabel.text = ""
                        if (self.timme != nil){
                            self.timme.invalidate()
                            self.timme = nil
                        }
                        self.getpwdBtn.isEnabled = true
                        
                        let alertView:UIAlertView = UIAlertView(title: "温馨提示", message: "手机号未注册或不存在", delegate: nil, cancelButtonTitle: "确定")
                        alertView.show()
                    }
                    
                    
                })
  
            }else{
                if (userTleNum.characters.count == 0 ){
                    print("请输入手机号！")
                    
                    let alertView:UIAlertView = UIAlertView(title: NSLocalizedString("PhoneNuberNill", tableName: nil, bundle: Bundle.main, value: "", comment: ""), message:NSLocalizedString("PleaseEnterThePhoneNumber", tableName: nil, bundle: Bundle.main, value: "", comment: ""), delegate: nil, cancelButtonTitle: NSLocalizedString("CONFIRM", tableName: nil, bundle: Bundle.main, value: "", comment: ""))
                    alertView.show()
                    
                    
                    getpwdBtn.isEnabled = true
                }else{
                    print("请输入正确的手机号")
                    
                    let alertView:UIAlertView = UIAlertView(title: NSLocalizedString("PhoneNuberFails", tableName: nil, bundle: Bundle.main, value: "", comment: ""), message:NSLocalizedString("PleaseEnterACorrectNumber", tableName: nil, bundle: Bundle.main, value: "", comment: ""), delegate: nil, cancelButtonTitle: NSLocalizedString("CONFIRM", tableName: nil, bundle: Bundle.main, value: "", comment: ""))
                    alertView.show()
                
                    getpwdBtn.isEnabled = true
                }
                
                
            }

        }
    }
    
    

    
    func creatTimmer(){
        
        timme = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(FindpwdCtr.timmerAction), userInfo: nil, repeats: true)
        timme.fire()
    }

    func timmerAction(){
        if (timeIndex > -1){
            self.getpwdBtn.isEnabled = false

            self.getpwdBtn.setTitle("", for: UIControlState())
            
            self.getPwdLabel.text = "请等待\(String(timeIndex))秒后重新获取"
            
            print("倒计时：\(String(timeIndex))")
            timeIndex = timeIndex - 1
            
        }else {
            
            self.getpwdBtn.setTitle("获取密码", for: UIControlState())
            self.getPwdLabel.text = ""
            if (timme != nil){
                timme.invalidate()
                timme = nil
            }

            self.getpwdBtn.isEnabled = true
        }

    }
}
    
    
    
    
    
    


