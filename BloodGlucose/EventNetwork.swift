//
//  EventNetwork.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/18.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit


func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}



class EventNetwork: NSObject {

 
    
    fileprivate var savefinishHUD:JGProgressHUD!
    //MARK:提交保存
    func saveMedicData(_ showHUD: UIView,dataDic: [String:String], clourse: @escaping ((_ success: Bool)->Void)){

        self.savefinishHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.savefinishHUD.textLabel.text = "提交中..."
        self.savefinishHUD.show(in: showHUD, animated: true)
  
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/event/newLog.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost: [String:String] = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "type":"medicine"
        ]

        dicDPost += dataDic

        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print(json)
            
            
            let code1 = json["code"].intValue
            if code1 == 1 {
                self.savefinishHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.savefinishHUD.textLabel.text = "提交成功"
                self.savefinishHUD.dismiss(afterDelay: 0.5, animated: true)
                
                clourse(true)

            }else{
                self.savefinishHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.savefinishHUD.textLabel.text = "提交失败"
                self.savefinishHUD.dismiss(afterDelay: 0.5, animated: true)
                
            }
            
            }, failure: { () -> Void in
                
                print("false")
                self.savefinishHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.savefinishHUD.textLabel.text = "网络错误"
                self.savefinishHUD.dismiss(afterDelay: 0.5, animated: true)
        })
        
        
        
    }
    
    
    
}
