//
//  MyCommentViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyCommentViewController: UIViewController ,UITextViewDelegate{

    
    
    @IBOutlet weak var myTextView: UITextView!
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "意见反馈"
        
        
        self.myTextView.delegate = self
        
        self.setNav()
        
    }

    
    
    
    func setNav(){
        
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(MyCommentViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 1
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        //右
        let rightBtn = UIBarButtonItem(title:"提交", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MyCommentViewController.someBtnAct(_:)))
        rightBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
        rightBtn.tag = 2
        self.navigationItem.rightBarButtonItem = rightBtn
        
    }
    
    func someBtnAct(_ send:UIButton){
        switch send.tag {
        case 1:
            self.navigationController!.popViewController(animated: true)
        case 2:
            print("提交")
            
            self.myTextView.resignFirstResponder()
            
  
            //编辑过，字符不小于6个

            if self.isFirstEdit == false && self.myTextView.text.characters.count >= 6{
                //提交信息
                self.submitMessage(self.myTextView.text)
                
            }else{
                
                
                if self.isFirstEdit == true {

                    let alertView = UIAlertView(title: "您还没有开始编辑", message: "", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                    
                }else{
                    let alertView = UIAlertView(title: "至少输入6个字符", message: "", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }
                
                
                
                
            }
            
            
            
        default:
            break
        }
    }
    
    
    //第一次编辑
    var isFirstEdit = true
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //开始编辑
        if isFirstEdit {
            textView.text = nil
            isFirstEdit = false
        }
    }
    
    func setNavAndTabBar(){
        BaseTabBarView.isHidden = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        var frame = self.navigationController?.navigationBar.frame
        frame?.origin.x = 0
        self.navigationController?.navigationBar.frame = frame!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavAndTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        self.setNavAndTabBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var submit:JGProgressHUD!
    //
    func submitMessage(_ value:String){
        
        submit = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        submit.textLabel.text = "提交中.."
        submit.show(in: self.view, animated: true)
        
        
        let uid:String = String(ussssID)
        
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/addAdvise.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "content":value,
        ]
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res:Any?) -> Void in
            print("\(res)")
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
            
            if let massage = json["message"].string{
                print(massage)
                if massage == "提交成功" {
                    self.HUDMessage("提交成功")
                    
                    BGNetwork().delay(0.71, closure: { 
                        self.navigationController!.popViewController(animated: true)
                    })
  
                    
                }else{
                    self.HUDMessage("提交失败")
                }
                
                
            }else{
                self.HUDMessage("提交失败")
            }
            
            
            
            }, failure: { () -> Void in
                
                print("false")
                self.HUDMessage("网络错误")
                
        })
        
    }
    
    func HUDMessage(_ msg:String){
        
        self.submit.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.submit.textLabel.text = msg
        self.submit.dismiss(afterDelay: 0.7, animated: true)
    }
    

    

}
