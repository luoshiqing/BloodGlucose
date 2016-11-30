//
//  LocalNotificationUtils.swift
//  BloodGlucose
//
//  Created by sqluo on 16/9/6.
//  Copyright © 2016年 nash_su. All rights reserved.
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

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class LocalNotificationUtils: NSObject {

    func addNotification(_ isHeight: Bool,bloodSugar: Float){
        
        
        let app = UIApplication.shared

        let localArr = app.scheduledLocalNotifications

        
        if let tmpLocalArr = localArr {
            
            for item in tmpLocalArr{
                
                let dict = item.userInfo!
                
                let value = dict["name"] as? String

                if value == "bloodNoti"{
                    app.cancelLocalNotification(item)
                    print("有了，不需要注册了")

                    break
                }
                
            }
 
        }
        
        
        let localNoti = UILocalNotification()
        
 
        let fireDate = Date().addingTimeInterval(1)

        localNoti.fireDate = fireDate
        
        // 设置时区
        localNoti.timeZone = TimeZone.current
        
        // 通知上显示的主题内容
        
        let body = isHeight ? "高血糖提醒,血糖值为 \(bloodSugar)" : "低血糖提醒,血糖值为 \(bloodSugar)"
        
        localNoti.alertBody = body
        
        // 收到通知时播放的声音，默认消息声音
        localNoti.soundName = UILocalNotificationDefaultSoundName
        
        //待机界面的滑动动作提示
        localNoti.alertAction = "打开应用"
        
        // 应用程序图标右上角显示的消息数
        localNoti.applicationIconBadgeNumber = 0
        
        // 通知上绑定的其他信息，为键值对
        localNoti.userInfo = ["name": "bloodNoti"]
        
        // 添加通知到系统队列中，系统会在指定的时间触发
        UIApplication.shared.scheduleLocalNotification(localNoti)
        
    }
    //每日七点提醒
    func addAtSevenClockNotification(){
        
        var serverIsNoti = true
        var sqlIsNoti = true
        
        let towDay: Double = 2 * 24 * 60 * 60
        
        let currentTime = Date().timeIntervalSince1970
        
        //1473156750
        print(currentTime)

        
        if let lasttime = lastbstime {
            
            let last = Double(lasttime)! / 1000
            
            print(last)
            
            let cha = currentTime - last
            
            
            if cha > towDay {
                serverIsNoti = false
            }
 
  
        }
        
        let mySQLLastTime = self.getLastFMDBBloodData()
        
        if let tmpSQL = mySQLLastTime {
            let sqlChar = currentTime - tmpSQL

            if sqlChar > towDay {
                sqlIsNoti = false
            }
     
        }
        
        
        if serverIsNoti || sqlIsNoti {
            print("发送通知")
            
            let app = UIApplication.shared
   
            let localArr = app.scheduledLocalNotifications
 
            var localNoti: UILocalNotification!

            var isRegistered = true
            
            if let tmpLocalArr = localArr {
                
                for item in tmpLocalArr{
                    
                    let dict = item.userInfo
                    
                    if let tmpDic = dict {
                        let value = tmpDic["name"] as? String
                        
                        if value == "SevenDaysNoti"{
                            print("有了，不需要注册了")
                            isRegistered = false
                            localNoti = item
                            break
                        }
                    }
   
                }
                
            }
            
            if isRegistered {
                localNoti = UILocalNotification()
            }
            
            let fireDate = Date(timeIntervalSince1970: -1 * 60 * 60)
            
            localNoti.fireDate = fireDate
            
            localNoti.repeatInterval = .day
            
            
            // 设置时区
            localNoti.timeZone = TimeZone.current
            
            // 通知上显示的主题内容
            
            let body = "您今天还没有输入参比血糖，快输入一个吧"
            
            localNoti.alertBody = body
            
            // 收到通知时播放的声音，默认消息声音
            localNoti.soundName = UILocalNotificationDefaultSoundName
            
            //待机界面的滑动动作提示
            localNoti.alertAction = "打开应用"
            
            // 应用程序图标右上角显示的消息数
            localNoti.applicationIconBadgeNumber = 0
            
            // 通知上绑定的其他信息，为键值对
            localNoti.userInfo = ["name": "SevenDaysNoti"]
            
            if isRegistered {
                // 添加通知到系统队列中，系统会在指定的时间触发
                UIApplication.shared.scheduleLocalNotification(localNoti)
            }
 
        }else{
            
            //去除通知

            let app = UIApplication.shared
            
            let localArr = app.scheduledLocalNotifications

            if let tmpLocalArr = localArr {
                
                for item in tmpLocalArr{
                    
                    let dict = item.userInfo!
                    
                    let value = dict["name"] as? String
                    
                    if value == "SevenDaysNoti"{
                        app.cancelLocalNotification(item)
                    }
                    
                }
                
            }
            
            
        }
        
        
        
        
        
    }
   
    
    //极化结束通知
    func addPolarizationEndNotification(_ remainTime: Double){
        
        
        let app = UIApplication.shared

        let localArr = app.scheduledLocalNotifications
        
        
        var localNoti: UILocalNotification!
        
        
        var isRegistered = true
        
        if let tmpLocalArr = localArr {
            
            for item in tmpLocalArr{
                
                let dict = item.userInfo!
                
                let value = dict["name"] as? String
                
                if value == "polarization"{
//                    app.cancelLocalNotification(item)
                    print("有了，不需要注册了")
                    isRegistered = false
                    localNoti = item
                    break
                }
                
            }
            
        }
        
        if isRegistered {
            localNoti = UILocalNotification()
        }
        
        let fireDate = Date(timeIntervalSinceNow: remainTime)
        
        localNoti.fireDate = fireDate
        
        // 设置时区
        localNoti.timeZone = TimeZone.current
        
        // 通知上显示的主题内容
        
        let body = "传感器极化结束，请输入指血数据"
        
        localNoti.alertBody = body
        
        // 收到通知时播放的声音，默认消息声音
        localNoti.soundName = UILocalNotificationDefaultSoundName
        
        //待机界面的滑动动作提示
        localNoti.alertAction = "打开应用"
        
        // 应用程序图标右上角显示的消息数
        localNoti.applicationIconBadgeNumber = 0
        
        // 通知上绑定的其他信息，为键值对
        localNoti.userInfo = ["name": "polarization"]
        
        if isRegistered{
            // 添加通知到系统队列中，系统会在指定的时间触发
            UIApplication.shared.scheduleLocalNotification(localNoti)
        }
        
      
        
 
   
    }


    
    
    //MARK:获取数据库最后一条数据
    func getLastFMDBBloodData() ->Double?{
        //获取原始电流数据并对其排序
        var recordsArray:NSArray = BloodSugarDB().selectAll()
        if recordsArray.count <= 0 {
            return nil
        }
        recordsArray = recordsArray.sortedArray(comparator: { (obj1, obj2) -> ComparisonResult in
            
            let b = obj1 as! BloodSugarModel
            let a = obj2 as! BloodSugarModel
            
            if Int(a.timeStamp) > Int(b.timeStamp) {
                return ComparisonResult.orderedAscending
            }else{
                return ComparisonResult.orderedDescending
            }
        }) as NSArray

        let lastTime = (recordsArray.lastObject as! BloodSugarModel).timeStamp


        return Double(lastTime!)!
    }
    
    
    
    
}
