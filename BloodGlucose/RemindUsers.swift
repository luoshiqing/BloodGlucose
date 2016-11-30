//
//  RemindUsers.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

import AudioToolbox

//var remindSetValueArray = ["3.9","只提醒一次","7.8","只提醒一次","0","0"]




class RemindUsers: NSObject {
    
    let MinCurrent = 8000   //电流最小值
    let MaxCurrent = 65530  //电流最大值
    
    //是否开启提醒
//    var isRemind = [true,true]

    func setRemindAndSendSomeInformation(_ time: TimeInterval,bloodSugar: Float){
        

        
        //time 该条血糖的时间戳

        //低血糖值
        let minBlood = Float(remindSetValueArray[0])!
        
 
        //高血糖值
        let maxBlood = Float(remindSetValueArray[2])!
   
        
        //提醒
        
        switch bloodSugar {
        case 0..<minBlood:

            if isRemind[0] {
//                print("血糖过低，提醒一下")
                //提醒间隔
                let tmpMinInterval = remindSetValueArray[1]
                
                
                let minInterval = self.getDoubleTime(tmpMinInterval)
                
                
                if let minTime:TimeInterval = UserDefaults.standard.value(forKey: "remindUsersMinTime") as? TimeInterval{

                    let x = time - minTime //数据时间 减去上次 的时间
 
                    if minInterval != 1 {
                        
                        let minDouble = minInterval * 60
                        
                        if x > minDouble { //如果大于设置的时间
                            print("发送低血糖提醒")
                            UserDefaults.standard.setValue(time, forKey: "remindUsersMinTime")
                            
//                            self.sendPushValue(false, bloodSugar: bloodSugar)
                            
                            
                            
                            LocalNotificationUtils().addNotification(false, bloodSugar: bloodSugar)
                            
                            
                            
                            self.sendSystemVibration()
                            
                        }
                        
                    }
      
                }else{
                    
                    
                    let currentTime = Date().timeIntervalSince1970
                    
//                    print(currentTime)
                    //第一次，设置为单前时间
                    UserDefaults.standard.setValue(currentTime, forKey: "remindUsersMinTime")
                    
                    //发送
                    print("发送第一次低血糖提醒")
//                    self.sendPushValue(false, bloodSugar: bloodSugar)
                    LocalNotificationUtils().addNotification(false, bloodSugar: bloodSugar)
                    self.sendSystemVibration()
                }
            }else{
                print("低血糖提醒未开启")
            }
            
 
        case minBlood...maxBlood:
            //print("正常范围")
            break
        default:
            
            if isRemind[1] {
//                print("血糖过高了，提醒一下")
                
                //提醒间隔
                let tmpMaxInterval = remindSetValueArray[3]
                
                let maxInterval = self.getDoubleTime(tmpMaxInterval)
                
                if let maxTime:TimeInterval = UserDefaults.standard.value(forKey: "remindUsersMaxTime") as? TimeInterval{

                    let x = time - maxTime

                    if maxInterval != 1 {
                        
                        
                        let maxDouble = maxInterval * 60
                        
                        if x > maxDouble {
                            print("发送高血糖提醒")
                            UserDefaults.standard.setValue(time, forKey: "remindUsersMaxTime")
                            
//                            self.sendPushValue(true, bloodSugar: bloodSugar)
                            LocalNotificationUtils().addNotification(true, bloodSugar: bloodSugar)
                            self.sendSystemVibration()
                        }
                        
                    }
                    
                    
                }else{
                    
                    
                    let currentTime = Date().timeIntervalSince1970
                    
                    print(currentTime)
                    
                    UserDefaults.standard.setValue(currentTime, forKey: "remindUsersMaxTime")
                    
                    //发送
                    print("发送第一次高血糖提醒")
//                    self.sendPushValue(true, bloodSugar: bloodSugar)
                    LocalNotificationUtils().addNotification(true, bloodSugar: bloodSugar)
                    
                    self.sendSystemVibration()
                }
            }else{
                print("高血糖提醒未开启")
            }
  
            
        }
    
    }
    
    
    func sendPushValue(_ isHeight: Bool,bloodSugar: Float){
        
        print("是否为高->\(isHeight) 血糖->\(bloodSugar)")
        
        let initCompleteNotification = UILocalNotification()
        
        
        let body = isHeight ? "高血糖提醒,血糖值为 \(bloodSugar)" : "低血糖提醒,血糖值为 \(bloodSugar)"
        
        initCompleteNotification.alertBody = body

        initCompleteNotification.soundName = UILocalNotificationDefaultSoundName
        
        initCompleteNotification.fireDate = Date(timeIntervalSinceNow: Date().timeIntervalSinceNow)
        
        
        initCompleteNotification.timeZone = TimeZone.current
        
        
//        initCompleteNotification.applicationIconBadgeNumber = 1
        
        
        UIApplication.shared.scheduleLocalNotification(initCompleteNotification)
        
        
    }
    
    
    
    
    func getDoubleTime(_ value: String) ->Double{
        
        var minInterval: TimeInterval = 1
        switch value {
        case "只提醒一次":
            minInterval = 1
        case "15分钟":
            //print("15")
            minInterval = 15
        case "30分钟":
            minInterval = 30
        case "1小时":
            minInterval = 60
        default:
            break
        }
        
        return minInterval
    }
    
    
    //计算血糖是否越界
    func currentIsCorrect(_ current: Int) -> Bool{

        switch current {
        case self.MinCurrent...self.MaxCurrent:
            return true
        default:
            return false
        }
   
    }
    
    func sendSystemVibration(){
        
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        
        AudioServicesPlaySystemSound(soundID)
        
    }
    
    
    
    
    
    
    
    
}
