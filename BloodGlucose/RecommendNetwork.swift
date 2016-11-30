//
//  RecommendNetwork.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/24.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit



class RecommendNetwork: NSObject {


    fileprivate var savefinishHUD:JGProgressHUD!
    
    //获取三个随机数
    func randomABC(min: Int, max: Int) -> (Int,Int,Int){
        
        let a = BGNetwork().randomInRange(min...max)
        var b:Int = a
        var c:Int = b
        while a == b {
            b = BGNetwork().randomInRange(min...max)
        }
        
        while a == c || b == c{
            c = BGNetwork().randomInRange(min...max)
        }
        
        return (a,b,c)
    }
    
    
    
    //获取12种食材
    func getTwelveFood(_ showHUD: UIView, clourse: @escaping ((_ imgUrlArray: [String],_ nameArray: [String],_ idArray: [String])->Void)){
    
        self.initHUDView(inView: showHUD, title: "加 载 中")
    
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/getmateriallist.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            ]

        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            //print("\(json)")
            
            if let code:Int = json["code"].int{
                if (code == 1){
                    self.removeHUDView(title: "加载完成", delay: 0.5)
                    
                    if let tmpData = json["data"].arrayObject as? [[String:AnyObject]] {
                        
                        var imgUrlArray = [String]()
                        var nameArray = [String]()
                        var idArray = [String]()
                        
                        for dic in tmpData {
                            
                            let imgUrl = dic["i"] as! String
                            let name = dic["n"] as! String
                            let id = String(describing: dic["id"] as! NSNumber)
                            
                            imgUrlArray.append(imgUrl)
                            nameArray.append(name)
                            idArray.append(id)

                        }
                        clourse(imgUrlArray, nameArray, idArray)
                    }
  
                }else{
                    self.removeHUDView(title: "加载失败", delay: 0.5)
                }
            }

            }, failure: { () -> Void in
                
                print("false错误")

                self.removeHUDView(title: "加载失败", delay: 0.5)
        })
        

    
    }
    
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
