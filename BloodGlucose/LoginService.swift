//
//  LoginService.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/11.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class LoginService: NSObject {

    fileprivate var showHUD: JGProgressHUD!
    
    
    func login(_ showHUDIn: UIView ,username: String, password: String, clourse: @escaping ((_ success: Bool,_ isShow: Bool)->Void)){
        
        self.initHUD(title: "登录中", inView: showHUDIn)
        
        // 得到当前应用的版本号
        let infoDictionary = Bundle.main.infoDictionary
        let currentVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        //设备号
        let model1:String = UIDevice.current.systemVersion
        let model3:String = BGNetwork().getSevrice()
        let sleep:String = "ios#\(model3)#\(model1)#\(currentVersion)"
        
        
        let reqUrl:String = "\(TEST_HTTP)/jsp/login.jsp"
        let code:String = "\(username)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        
        let dicDPost = [
            "name":username,
            "pwd":password,
            "clientid":CLIENTID,
            "sleep":sleep,
            "random":RandoM,
            "code":codeMD5]
        
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            print("\(json)")
            
            
            if let state = json["state"].string {
                
                if state == "ok" {
 
                    var show = true
      
                    if let avg1 = json["avg"].double {
                        pingjunTime = Float(avg1)
                    }
                    if let nickname1 = json["nickname"].string {
                        nickname = nickname1
                    }
                    if let show1 = json["show"].bool {
                        show = show1
                    }

                    if let id1 = json["id"].int64 {
                        ussssID = id1
                    }
                    if let totalNum1 = json["totalNum"].int {
                        jiancheNum = totalNum1
                    }
                    if let totalTime1 = json["totalTime"].int {
                        jiancheTime = totalTime1
                    }

                    if let iconurl1 = json["iconurl"].string {
                        if !iconurl1.isEmpty{
                            iconurl = iconurl1
                        }
                        
                    }
                    
                    if let datamuch1 = json["datamuch"].string {
                        if !datamuch1.isEmpty{
                            datamuch = datamuch1
                        }
                    }
                    
                    if let banner = json["banner"].arrayObject{
                        bannerArray = (banner as NSArray) as [AnyObject]
                    }
                    
                    if let tmpLastbstime = json["lastbstime"].string{
                        lastbstime = tmpLastbstime
                    }
       
                    self.removeHUD(title: "登录成功", time: 0.5)
                    
                    clourse(true, show)
                    
                }else{
                    self.removeHUD(title: "密码错误", time: 0.5)
                }
                
            }else{
                self.removeHUD(title: "登录失败", time: 0.5)
            }
            
            }, failure: { () -> Void in
                
                print("false错误")
                self.removeHUD(title: "网络错误", time: 0.5)
        })
        
        
        
        
    }
    
    
    
    //MARK:获取服务器版本号
    func getInterVersion(_ showHUDIn: UIView, clourse: @escaping ((_ success: Bool ,_ version : String? ,_ explain: String?)->Void)){
        
        self.initHUD(title: "校对版本信息", inView: showHUDIn)
        
        let today:Double = Date().timeIntervalSince1970
        let newTiem:Double = today + 8 * 60 * 60
        
        let userid:String = String(newTiem)
        let reqUrl:String = "\(TEST_HTTP)/jsp/appversion/getappversion.jsp"
        
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost: [String:String] = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "type":"ios"]
        
        
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            print("\(json)")
            self.removeHUD(title: "校对成功", time: 1.1)
            
            if let data = json["data"].dictionaryObject as? [String:String] {
                
                let version = data["version"]
                let explain = data["explain"]
                
                clourse(true, version, explain)
            }

            }, failure: { () -> Void in
                //print("网络错误")
                clourse(false, nil, nil)
                self.removeHUD(title: "网络错误", time: 0.5)

        })
        
        
    }
    
    
    
    //MARK:找回密码
    func getPwd(_ showHUDIn: UIView, phoneNum: String, clourse: @escaping ((_ success: Bool)->Void)){
    
        self.initHUD(title: "密码发送中", inView: showHUDIn)
        
        let mobile = phoneNum
        let reqUrl = "\(TEST_HTTP)/jsp/sendpwd.jsp"
        let dicDPost: [String:String] = ["mobile":mobile]
 
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("json:\(json)")
            
            let state = json["state"].stringValue
            
            if(state == "ok"){
                self.removeHUD(title: "找回密码成功", time: 1.1)
                clourse(true)
            }else{
                self.removeHUD(title: "用户不存在", time: 1.0)
                clourse(false)
            }
            
            
            }, failure: { () -> Void in
                //print("手机号未注册或不存在")
                self.removeHUD(title: "找回密码失败", time: 0.5)
                clourse(false)
        })
    
    
    }
    
    fileprivate func initHUD(title: String, inView: UIView){
        self.showHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.showHUD.textLabel.text = title
        self.showHUD.show(in: inView, animated: true)
    }
    
    fileprivate func removeHUD(title: String, time: TimeInterval){
        
        if self.showHUD != nil {
            self.showHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.showHUD.textLabel.text = title
            self.showHUD.dismiss(afterDelay: time, animated: true)
        }
        
    }
    
    
}
