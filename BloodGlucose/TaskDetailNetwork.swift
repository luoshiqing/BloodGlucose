//
//  TaskDetailNetwork.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/26.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class TaskDetailNetwork: NSObject {
    
    
    //生产分享的食物属性
    func generateShareText(menu: [String:Any]) -> String{
        
        var text = ""
        
        let lb1:String = menu["lb1"] as! String
        let lb2:String = menu["lb2"] as! String
        let lb3:String = menu["lb3"] as! String
        let lb4:String = menu["lb4"] as! String
        
        if !lb1.isEmpty {
            text += "\(lb1)"
        }
        if !lb2.isEmpty {
            text += "、\(lb2)"
        }
        if !lb3.isEmpty {
            text += "、\(lb3)"
        }
        if !lb4.isEmpty {
            text += "、\(lb4)"
        }
        
        return text
    }
    

    //获取标签
    func getTagText(menu: [String:Any]) -> [String]{
        
        var valueArray = [String]()
 
        if let lb1 = menu["lb1"] as? String{
            
            if !lb1.isEmpty {
                valueArray.append(lb1)
            }
            
        }
        if let lb2 = menu["lb2"] as? String{
            if !lb2.isEmpty {
                valueArray.append(lb2)
            }
        }
        if let lb3 = menu["lb3"] as? String{
            if !lb3.isEmpty {
                valueArray.append(lb3)
            }
        }
        if let lb4 = menu["lb4"] as? String{
            if !lb4.isEmpty {
                valueArray.append(lb4)
            }
        }
        
        return valueArray
        
    }
    //获取做法
    func getMethodsText( menu: [String:Any]) -> String{
        //材料
        let material:String = menu["material"] as! String
        
        var value = ""
        
        //做法
        let st1:String = menu["st1"] as! String
        let st2:String = menu["st2"] as! String
        let st3:String = menu["st3"] as! String
        let st4:String = menu["st4"] as! String
        let st5:String = menu["st5"] as! String
        let st6:String = menu["st6"] as! String
        
        if !st1.isEmpty {
            value += "\(st1)\n"
        }
        if !st2.isEmpty {
            value += "\(st2)\n"
        }
        if !st3.isEmpty {
            value += "\(st3)\n"
        }
        if !st4.isEmpty {
            value += "\(st4)\n"
        }
        if !st5.isEmpty {
            value += "\(st5)\n"
        }
        if !st6.isEmpty {
            value += "\(st6)"
        }
        
        return ("\(material)\n\(value)")
    }
    
    
    
    //获取食物详细
    func getFoodDetail(_ showHUD: UIView, mid: String, clourse: @escaping ((_ dic: [String:Any])->Void)){

        self.initHUDView(inView: showHUD, title: "加载中.")
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/getftmenuinfo.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "mid":mid]
        
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("json:\(json)")
            
            self.removeHUDView(title: "加载成功", delay: 0.5)

            if let tmpData = json["data"].dictionaryObject as? [String:AnyObject]{
 
                //食物详情字典
                let menu = tmpData["menu"] as! [String:Any]
                //评论数组
                let commentArray = tmpData["comment"] as! [[String:String]]
                //点赞个数
                let good = tmpData["good"] as! Int
                //是否点赞
                let isgood = tmpData["isgood"] as! Int
                //任务状态
                let status = tmpData["status"] as! Int
                //评论的个数
                let commentNum = tmpData["commentNum"] as! Int
                
                
                let dataDic: [String:Any] = ["menu":menu,
                                  "good":good,
                                  "isgood":isgood,
                                  "status":status,
                                  "commentNum":commentNum,
                                  "commentArray":commentArray]
                
                clourse(dataDic)
            }

            }, failure: { () -> Void in
                self.removeHUDView(title: "网络错误", delay: 0.5)
        })
        
        
    }
    
    
    //获取评论
    func getSomeDetailCommentsFor(page: Int, shownum: Int, mid: String , clourse: @escaping ((_ success: Bool,_ isHaveData: Bool, _ clistArray: [[String:String]]?)->Void)){
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/getcommentlist.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost: [String:Any] = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "mid":mid,
            "page":page,
            "shownum":shownum]

        
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
            
            if let code = json["code"].int {
                
                if code == 1 { //加载成功
                    
                    if let dataDic = json["data"].dictionaryObject{
                        
                        let clistArray = dataDic["clist"] as! [[String:String]]
                        
                        if clistArray.count < shownum {
                            clourse(true,false, clistArray)
                        }else{
                            clourse(true,true, clistArray)
                        }
   
                    }
                    
                    
                }
    
            }

        
            }, failure: { () -> Void in
                print("错误，失败")
                clourse(false,false, nil)
        })
        
  
    }
    
    
    //提交评论
    func submitComments(_ showHUD: UIView, _ mid: String , content :String ,clourse: @escaping ((_ success: Bool)->Void)){
        
        self.initHUDView(inView: showHUD, title: "提交中.")
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/writecomment.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "mid":mid,
            "content":content]

        
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")

            
            if let code:Int = json["code"].int{
                if (code == 1){
                    self.removeHUDView(title: "发表成功", delay: 0.5)
                    clourse(true)
                }else{
                    self.removeHUDView(title: "发表失败", delay: 0.5)
                    clourse(false)
                }
                
            }else{
                self.removeHUDView(title: "发表失败", delay: 0.5)
                clourse(false)
            }
            
            }, failure: { () -> Void in
                self.removeHUDView(title: "网络错误", delay: 0.5)
                clourse(false)
        })
        
    }
    
    //点赞
    func thumbUp(_ mid: String, clourse: @escaping ((_ good: Int)->Void)){
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/setftmenuinfogoodbad.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "mid":mid,
            "good":"true",
            "bad":"false"]
        
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            if let code = json["code"].int{
                if code == 1{
                    
                    if let data1 = json["data"].dictionaryObject{
                        let good = data1["good"] as! Int
                        clourse(good)
                    }
                    
                }else{
                    print("点赞失败")
                }
            }else{
                print("网络错误")
            }
            
            
            }, failure: { () -> Void in
                
                print("false错误")
                
        })
        
    }
    
    
    
    //MARK:提交任务
    func submitTask(_ showHUD: UIView,_ mid: String , clourse: @escaping (()->Void)){
        
        self.initHUDView(inView: showHUD, title: "提交中.")
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/setftmenuinfostatus.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "mid":mid,
            "commit":"true"]

        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
            self.removeHUDView(title: "提交成功", delay: 0.5)
            if let code:Int = json["code"].int{
                if (code == 1){
                    clourse()
                }
                
            }
            
            }, failure: { () -> Void in
                self.removeHUDView(title: "网络错误", delay: 0.5)
        })
    }
    
    //MARK:把未添加的食谱添加到任务
    func addToTask(_ showHUD: UIView, _ mid:String , clourse: @escaping (()->Void)){
        
        self.initHUDView(inView: showHUD, title: "添加任务")
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/createtask.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "ids":mid]

        
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
            self.removeHUDView(title: "添加成功", delay: 0.5)
            if let code:Int = json["code"].int{
                if (code == 1){

                    clourse()
                    
                }else{
                    let message:String = json["message"].stringValue
                    let msg = "失败，最多加8个食谱"
                    if message == msg{
                        let alertView:UIAlertView = UIAlertView(title: "您今天已经选择了8种食物了", message: "快到－我的任务－里面看看吧", delegate: nil, cancelButtonTitle: "确定")
                        alertView.show()
                    }
                }
            }
            
            }, failure: { () -> Void in
                self.removeHUDView(title: "网络错误", delay: 0.5)
                print("false错误")
                
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
