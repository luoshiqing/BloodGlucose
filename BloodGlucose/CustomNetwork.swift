//
//  CustomNetwork.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/25.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class CustomNetwork: NSObject {

    
    
    //获取食谱
    func getFoodMenu(_ showHud: UIView, ids: String, clourse: @escaping ((_ imgUrlArray: [String],_ nameArray: [String],_ idArray: [String])->Void)){
        
        self.initHUDView(inView: showHud, title: "加 载 中")
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/getmenulist.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "ids":ids]
  
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            //print("\(json)")

            if let code:Int = json["code"].int{
                if (code == 1){ //加载成功
                    self.removeHUDView(title: "加载成功", delay: 0.5)
                    
                    if let tmpDataArray = json["data"].arrayObject as? [[String:AnyObject]]{

                        var imgUrlArray = [String]()
                        var nameArray   = [String]()
                        var idArray     = [String]()
                        
                        for dic in tmpDataArray {
                            
                            let id = String(describing: dic["id"] as! NSNumber)
                            let imgUrl = dic["i"] as! String
                            let name = dic["n"] as! String
                            
                            imgUrlArray.append(imgUrl)
                            nameArray.append(name)
                            idArray.append(id)
                            
                        }
                        
                        clourse(imgUrlArray, nameArray, idArray) //回调

                    }
                }else{
                    self.removeHUDView(title: "加载失败", delay: 0.5)
                }
            }else{
                self.removeHUDView(title: "加载失败", delay: 0.5)
            }
            
            }, failure: { () -> Void in
                
                print("false错误")
                self.removeHUDView(title: "网络错误", delay: 0.5)
        })
    }
    
    
    //提交食谱
    func submitTheRecipes(_ showHud: UIView, ids: String, clourse: @escaping ((_ success: Bool, _ message: String?)->Void)){
    
        self.initHUDView(inView: showHud, title: "提 交 中")
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/createtask.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "ids":ids]
 
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
   
            
            let message = json["message"].stringValue
            
            let msg = "失败，最多加8个食谱"
            
            switch message {
                
            case "成功":
                self.removeHUDView(title: "提交成功", delay: 0.25)
                clourse(true, nil)
            case msg:
                self.removeHUDView(title: "提交失败", delay: 0.25)
                clourse(false, msg)
            default:
                self.removeHUDView(title: "提交失败", delay: 0.25)
                clourse(false, message)
                break
            }
  
            
            }, failure: { () -> Void in
                
                print("false错误")
                self.removeHUDView(title: "网络错误", delay: 0.5)
                
        })
        
        
        
    }
    
    
    

    
    fileprivate var savefinishHUD:JGProgressHUD!

    fileprivate func initHUDView(inView:UIView,title: String){
        self.savefinishHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.savefinishHUD.textLabel.text = title
        self.savefinishHUD.show(in: inView, animated: true)
    }
    
    fileprivate func removeHUDView(title: String,delay: TimeInterval){
        if self.savefinishHUD != nil {
            self.savefinishHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.savefinishHUD.textLabel.text = title
            self.savefinishHUD.dismiss(afterDelay: delay, animated: true)
        }
        
    }
    
}
