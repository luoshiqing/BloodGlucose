//
//  BGNetwork.swift
//  BloodGlucose
//
//  Created by Sqluo on 4/18/15.
//  Copyright (c) 2015 Sqluo. All rights reserved.
//

import UIKit


let SERVER_PREFIX:String = "http://115.28.148.220:8089/jsp/"


//-------------网址----->>>>>>>>>>>>>>>>
//MARK:测试
//let TEST_HTTP:String = "http://192.168.1.4:8089"
//let TEST_HTTP:String = "http://192.168.1.10:8090"
//MARK:线上
let TEST_HTTP:String = "http://www.59medi.com"
//-------------网址----->>>>>>>>>>>>>>>>

let CLIENTID:String = "10002"
var jiancheTime:Int = 0
var jiancheNum:Int = 0
var pingjunTime:Float = 0
var datahis = NSMutableArray()
var ussssID:Int64 = 0

//昵称
var NICKNAME:String!



class BGNetwork: NSObject {
    
    //利用NSJSONSerialization序列化成NSData,再通过NSString 转成JSON字符串

    func toJSONString(_ dict:NSDictionary!)->NSString{
        
       
        
        let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return string!
    
    }
    //转化
    func AnyObjectToJSONString(_ anyObjcet: AnyObject) ->String{
        let jsonData = try? JSONSerialization.data(withJSONObject: anyObjcet, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let jsonStr = String(data: jsonData!, encoding: String.Encoding.utf8)
        
        return jsonStr!
    }
    
 
    //延迟异步执行方法
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
        
              
        
    }
    
    //随机数算法
    func randomInRange(_ range: CountableClosedRange<Int>) -> Int {
        let count = UInt32(range.upperBound - range.lowerBound + 1)
        return  Int(arc4random_uniform(count)) + range.lowerBound
        
//        let a = randomInRange(0...6)
        //        print(a)
    }
    
    //检查用户名可用性

    func checkUsername(_ username:String,onComplete:@escaping (_ finished:Bool, _ state:Bool, _ reason:String) -> Void, onError:@escaping (_ error:NSError) -> Void){
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes  = nil
        
   
        
        let encodedUsername:String = username.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        
   
        
        let reqUrl:String = "\(TEST_HTTP)/jsp/checkname.jsp?name=\(encodedUsername)"
        
        let urlRequest = URLRequest(url: URL(string: reqUrl)!)
        
        let getOperation = AFHTTPRequestOperation(request: urlRequest)
        
        getOperation?.responseSerializer = AFHTTPResponseSerializer()
        
 
        getOperation?.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation?, res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            if let state:String = json["state"].string{
                
                if let reason:String = json["reason"].string {
                    if state == "ok"{
                        onComplete(true, true, reason)
                    }else{
                        onComplete(true, false, reason)
                    }
                }else{
                    onComplete(false, false, "")
                }
                
            }else{
                onComplete(false, false, "")
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            
            
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                onError(error as! NSError)
        })

        getOperation?.start()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
  
    
    //新用户注册
    func register(_ username:String,password:String,yanzhengma:String,onComplete:@escaping (_ finished:Bool, _ reason:String, _ userInfo:NSDictionary) -> Void, onError:@escaping (_ error:NSError) -> Void){
        
        
        print("1.\(username)+2.\(password)+3.\(yanzhengma)+4.\(CLIENTID)")
        
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes  = nil
        
        let encodedUsername:String = username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        
//        let reqUrl:String = "\(SERVER_PREFIX)/reguser.jsp?name=\(encodedUsername)&pwd=\(password)&code=\(yanzhengma)&clientid=\(CLIENTID)"
        let reqUrl:String = "\(TEST_HTTP)/jsp/reguser.jsp?name=\(encodedUsername)&pwd=\(password)&code=\(yanzhengma)&clientid=\(CLIENTID)"
        let urlRequest = URLRequest(url: URL(string: reqUrl)!)
 
        let getOperation = AFHTTPRequestOperation(request: urlRequest)
        
        getOperation?.responseSerializer = AFHTTPResponseSerializer()
        
        
        getOperation?.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation?, res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            
            var userInfo:NSDictionary = NSDictionary()
            
            if let state:String = json["state"].string{
                
                if let reason:String = json["reason"].string {
                    if state == "ok"{
                        
                        var id = ""
                        var name = ""
                        var nickname = ""
                        var height = 0
                        var weight = 0
                        var sex = 0
                        var age = ""
                        var data = ""
                        var probe = ""
                        var limitmax = 0
                        var limitmin = 0
                        var sessionid = ""
                        
                        if let tmpId:String = json["id"].string{
                            id = tmpId
                            
                        }
                        
                        
                        if let tmpName:String = json["name"].string{
                            name = tmpName
                        }
                        if let tmpNickName:String = json["nickname"].string{
                            nickname = tmpNickName
                        }
                        if let tmpHeight:Int = json["height"].int{
                            height = tmpHeight
                        }
                        if let tmpWeight:Int = json["weight"].int{
                            weight = tmpWeight
                        }
                        if let tmpSex:Int = json["sex"].int{
                            sex = tmpSex
                        }
                        if let tmpAge:String = json["age"].string{
                            age = tmpAge
                        }
                        if let tmpData:String = json["data"].string{
                            data = tmpData
                        }
                        if let tmpProbe:String = json["probe"].string{
                            probe = tmpProbe
                        }
                        if let tmpLimitmax:Int = json["limitmax"].int{
                            limitmax = tmpLimitmax
                        }
                        if let tmpLimitmin:Int = json["limitmin"].int{
                            limitmin = tmpLimitmin
                        }
                        if let tmpSessionidString = json["sessionid"].string{
                            sessionid = tmpSessionidString
                        }
                        
                        userInfo = [
                            "id":id,
                            "name":name,
                            "nickname":nickname,
                            "height":height,
                            "weight":weight,
                            "sex":sex,
                            "age":age,
                            "data":data,
                            "probe":probe,
                            "limitmax":limitmax,
                            "limitmin":limitmin,
                            "sessionid":sessionid
                        ]
                        
                        
                        
                        onComplete(true, reason, userInfo)
                        
                    }else{
                        onComplete(false, reason, userInfo)
                    }
                }else{
                    onComplete(false, "", userInfo)
                }
                
            }else{
                onComplete(false, "", userInfo)
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                onError(error as! NSError)
        })
        
        getOperation?.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation?, res: Any?) in
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            
            var userInfo:NSDictionary = NSDictionary()
            
            if let state:String = json["state"].string{
                
                if let reason:String = json["reason"].string {
                    if state == "ok"{
                        
                        var id = ""
                        var name = ""
                        var nickname = ""
                        var height = 0
                        var weight = 0
                        var sex = 0
                        var age = ""
                        var data = ""
                        var probe = ""
                        var limitmax = 0
                        var limitmin = 0
                        var sessionid = ""
                        
                        if let tmpId:String = json["id"].string{
                            id = tmpId
                            
                        }
                        
                        
                        if let tmpName:String = json["name"].string{
                            name = tmpName
                        }
                        if let tmpNickName:String = json["nickname"].string{
                            nickname = tmpNickName
                        }
                        if let tmpHeight:Int = json["height"].int{
                            height = tmpHeight
                        }
                        if let tmpWeight:Int = json["weight"].int{
                            weight = tmpWeight
                        }
                        if let tmpSex:Int = json["sex"].int{
                            sex = tmpSex
                        }
                        if let tmpAge:String = json["age"].string{
                            age = tmpAge
                        }
                        if let tmpData:String = json["data"].string{
                            data = tmpData
                        }
                        if let tmpProbe:String = json["probe"].string{
                            probe = tmpProbe
                        }
                        if let tmpLimitmax:Int = json["limitmax"].int{
                            limitmax = tmpLimitmax
                        }
                        if let tmpLimitmin:Int = json["limitmin"].int{
                            limitmin = tmpLimitmin
                        }
                        if let tmpSessionidString = json["sessionid"].string{
                            sessionid = tmpSessionidString
                        }
                        
                        userInfo = [
                            "id":id,
                            "name":name,
                            "nickname":nickname,
                            "height":height,
                            "weight":weight,
                            "sex":sex,
                            "age":age,
                            "data":data,
                            "probe":probe,
                            "limitmax":limitmax,
                            "limitmin":limitmin,
                            "sessionid":sessionid
                        ]
                        
                        
                        
                        onComplete(true, reason, userInfo)
                        
                    }else{
                        onComplete(false, reason, userInfo)
                    }
                }else{
                    onComplete(false, "", userInfo)
                }
                
            }else{
                onComplete(false, "", userInfo)
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                onError(error as! NSError)
        })
 
        getOperation?.start()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
 
 
    
    //获取密码
    func getPwdNub(_ username:String!,onComplete:(_ finished:Bool, _ reason:String, _ userInfo:NSDictionary) -> Void, onError:@escaping (_ error:NSError) -> Void){
    
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes  = nil
        

        let reqUrl:String = "\(TEST_HTTP)/jsp/sendpwd.jsp?mobile=\(username)"
        
        let urlRequest = NSMutableURLRequest(url: URL(string: reqUrl)!)
        
        urlRequest.httpMethod  = "GET"
        
        let getOperation = AFHTTPRequestOperation(request: urlRequest as URLRequest!)
        
        getOperation?.responseSerializer = AFHTTPResponseSerializer()
        

        getOperation?.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation?, res: Any?) in
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("login json : \(json)")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                onError(error as! NSError)
        })
        
  
        getOperation?.start()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        
    }
    
    //获取验证码
    func getYanZhengMa(_ username:String!, onComplete:(_ finished:Bool, _ reason:String, _ userInfo:NSDictionary) -> Void, onError:(_ error:NSError) -> Void){
    
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes  = nil
        
        
//        let reqUrl:String = "\(SERVER_PREFIX)/sendcode.jsp?mobile=\(username)"
        
        let reqUrl:String = "\(TEST_HTTP)/jsp/sendcode.jsp?mobile=\(username)"
        
        let urlRequest = NSMutableURLRequest(url: URL(string: reqUrl)!)
        
        urlRequest.httpMethod  = "GET"
        
        let getOperation = AFHTTPRequestOperation(request: urlRequest as URLRequest!)
        
        getOperation?.responseSerializer = AFHTTPResponseSerializer()
        
        
        
        getOperation?.start()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    }
    
    //上传血糖数据
    func uploadBloodGlucoseData(_ userId:String, bloodGlucose:String, time:Date,  sid:String, tid:String,bloodElectricData:Int,clientid:String,random:String,code:String, onComplete:@escaping (_ finished:Bool, _ reason:String) -> Void, onError:@escaping (_ error:NSError) -> Void){
        
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes  = nil
     
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //formatter.timeZone = NSTimeZone(abbreviation: "GMT+0800")
        let timeStr = formatter.string(from: time)
        
        
        let encodedTime:String = timeStr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let reqUrl:String = "\(TEST_HTTP)/jsp/uploaddata.jsp?id=\(userId)&sid=\(sid)&tid=\(tid)&v=\(bloodGlucose)&time=\(encodedTime)&e=\(bloodElectricData)&clientid=\(clientid)&random=\(random)&code=\(code)"

        
        print(userId,sid,tid,bloodGlucose,encodedTime,bloodElectricData)
 
        
        let urlRequest = NSMutableURLRequest(url: URL(string: reqUrl)!)
        
        urlRequest.httpMethod  = "POST"
        
        let getOperation = AFHTTPRequestOperation(request: urlRequest as URLRequest!)
        
        getOperation?.responseSerializer = AFHTTPResponseSerializer()
        
        
        getOperation?.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation?, res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            //{"state":"ok", "reason":""}
            
            if let state:NSString = json["state"].string as NSString?, let reason:String = json["reason"].string {
                if state == "ok"{
                    onComplete(true, "")
                }else{
                    onComplete(false, reason)
                }
                
            }else{
                onComplete(false,"返回信息错误")
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                onError(error as! NSError)
        })
        

        getOperation?.start()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
   
    
    
    
    //使用批量接口上传血糖数据
    func uploadBloodGlucoseDataInBatch(_ postString:NSString, onComplete:@escaping (_ finished:Bool, _ reason:String) -> Void, onError:@escaping (_ error:NSError) -> Void){
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes  = nil
        
//        let reqUrl:String = "\(SERVER_PREFIX)/batchuploaddata.jsp"
        let reqUrl:String = "\(TEST_HTTP)/jsp/batchuploaddata.jsp"
        
        let urlRequest = NSMutableURLRequest(url: URL(string: reqUrl)!)
        
        urlRequest.httpMethod  = "POST"
        urlRequest.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
        
        let getOperation = AFHTTPRequestOperation(request: urlRequest as URLRequest!)
        
        getOperation?.responseSerializer = AFHTTPResponseSerializer()
        
        
        
        getOperation?.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation?, res: Any?) in
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            //{"state":"ok", "reason":""}
            
            print("uploadBloodGlucoseDataInBatch : \(json)")
            
            if let state:NSString = json["state"].string as NSString?, let reason:String = json["reason"].string {
                if state == "ok"{
                    onComplete(true, "")
                }else{
                    onComplete(false, reason)
                }
                
            }else{
                onComplete(false,"返回信息错误")
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                onError(error as! NSError)
        })

        
        getOperation?.start()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }

    
    //历史数据查询
    func getHistoryData(_ userId:String!, day:Int,  onComplete:@escaping (_ finished:Bool, _ reason:String, _ bloodData:NSDictionary) -> Void, onError:@escaping (_ error:NSError) -> Void){
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes  = nil
        
 
        
        let reqUrl:String = "\(SERVER_PREFIX)/querydata.jsp?id=\(userId)&type=\(day)"
        
        //print("reqUrl : \(reqUrl) \n")
        
        let urlRequest = NSMutableURLRequest(url: URL(string: reqUrl)!)
        
        urlRequest.httpMethod  = "GET"
        
        let getOperation = AFHTTPRequestOperation(request: urlRequest as URLRequest!)
        
        getOperation?.responseSerializer = AFHTTPResponseSerializer()
        
        
        
        getOperation?.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation?, res: Any?) in
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            //{"state":"ok", "reason":""}
            
            //            if let state:NSString = json["state"].string, reason:String = json["reason"].string {
            if let state:NSString = json["state"].string as NSString?, let _:String = json["reason"].string {
                if state == "ok"{
                    
                    if let data:[JSON] = json["data"].array{
                        let bloodDataArray1 = NSMutableArray()
                        let bloodTimeArray1 = NSMutableArray()
                        
                        let bloodDataArray2 = NSMutableArray()
                        let bloodTimeArray2 = NSMutableArray()
                        
                        let bloodDataArray3 = NSMutableArray()
                        let bloodTimeArray3 = NSMutableArray()
                        
                        let bloodDataArray4 = NSMutableArray()
                        let bloodTimeArray4 = NSMutableArray()
                        
                        let bloodDataArray5 = NSMutableArray()
                        let bloodTimeArray5 = NSMutableArray()
                        
                        let bloodDataArray6 = NSMutableArray()
                        let bloodTimeArray6 = NSMutableArray()
                        
                        
                        for item in data{
                            if let blood:Int = item["d"].int, let time:Int = item["t"].int{
                                
                                var str = "\(time)" as NSString
                                str  = str.substring(with: NSRange(location: 0, length: 10)) as NSString
                                let formatter = DateFormatter()
                                formatter.dateFormat = "HH"
                                formatter.timeZone = TimeZone(abbreviation: "GMT+0000")
                                
                                let recordDate = Date(timeIntervalSince1970: Double(str.integerValue))
                                
                                let timeStr = formatter.string(from: recordDate)
                                
                                switch self.daysBeforeToday(recordDate){
                                case 0:
                                    bloodDataArray1.add(blood/10)
                                    bloodTimeArray1.add(timeStr)
                                    
                                    break
                                case 1:
                                    bloodDataArray2.add(blood/10)
                                    bloodTimeArray2.add(timeStr)
                                    
                                    break
                                case 2:
                                    bloodDataArray3.add(blood/10)
                                    bloodTimeArray3.add(timeStr)
                                    break
                                case 3:
                                    bloodDataArray4.add(blood/10)
                                    bloodTimeArray4.add(timeStr)
                                    break
                                case 4:
                                    bloodDataArray5.add(blood/10)
                                    bloodTimeArray5.add(timeStr)
                                    break
                                case 5:
                                    bloodDataArray6.add(blood/10)
                                    bloodTimeArray6.add(timeStr)
                                    break
                                default:
                                    break
                                }
                                
                                
                            }
                        }
                        
                        
                        let parsedBloodTimeArray1 = self.parseTimeArray(bloodTimeArray1).reverseObjectEnumerator().allObjects
                        let parsedBloodTimeArray2 = self.parseTimeArray(bloodTimeArray2).reverseObjectEnumerator().allObjects
                        let parsedBloodTimeArray3 = self.parseTimeArray(bloodTimeArray3).reverseObjectEnumerator().allObjects
                        let parsedBloodTimeArray4 = self.parseTimeArray(bloodTimeArray4).reverseObjectEnumerator().allObjects
                        let parsedBloodTimeArray5 = self.parseTimeArray(bloodTimeArray5).reverseObjectEnumerator().allObjects
                        let parsedBloodTimeArray6 = self.parseTimeArray(bloodTimeArray6).reverseObjectEnumerator().allObjects
                        
                        let bloodDate = [
                            "1":[bloodDataArray1.reverseObjectEnumerator().allObjects,parsedBloodTimeArray1],
                            "2":[bloodDataArray2.reverseObjectEnumerator().allObjects,parsedBloodTimeArray2],
                            "3":[bloodDataArray3.reverseObjectEnumerator().allObjects,parsedBloodTimeArray3],
                            "4":[bloodDataArray4.reverseObjectEnumerator().allObjects,parsedBloodTimeArray4],
                            "5":[bloodDataArray5.reverseObjectEnumerator().allObjects,parsedBloodTimeArray5],
                            "6":[bloodDataArray6.reverseObjectEnumerator().allObjects,parsedBloodTimeArray6],
                            ]
                        
                        
                        onComplete(true, "", bloodDate as NSDictionary)
                    }else{
                    }
                }else{
                    onComplete(false, "返回数据不完整", NSDictionary())
                }
                
            }else{
                
                onComplete(false, "返回数据错误", NSDictionary())
                
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                onError(error as! NSError)
        })
        
        
        
        getOperation?.start()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    //按日历史数据查询
    func getHistoryDataByDay(_ userId:String!, daysAgo:Int,  onComplete:@escaping (_ finished:Bool, _ reason:String, _ bloodDataArray:NSArray, _ bloodTimeArray:NSArray) -> Void, onError:@escaping (_ error:NSError) -> Void){
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes  = nil
        
        
        
        let reqUrl:String = "\(SERVER_PREFIX)/querydataforclient.jsp?id=\(userId)&type=\(daysAgo)"
        
        
        let urlRequest = NSMutableURLRequest(url: URL(string: reqUrl)!)
        
        urlRequest.httpMethod  = "GET"
        
        let getOperation = AFHTTPRequestOperation(request: urlRequest as URLRequest!)
        
        getOperation?.responseSerializer = AFHTTPResponseSerializer()
        
        
        
        getOperation?.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation?, res: Any?) in
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            //{"state":"ok", "reason":""}
            
            if let state:NSString = json["state"].string as NSString?, let _:String = json["reason"].string {
                if state == "ok"{
                    
                    if let data:[JSON] = json["data"].array{
                        let bloodDataArray = NSMutableArray()
                        let bloodTimeArray = NSMutableArray()
                        
                        let sortedResults = data.sorted {
                            (dictOne, dictTwo) -> Bool in
                            // put your comparison logic here
                            return dictOne["t"].int! > dictTwo["t"].int!
                        }
                        
                        for item in sortedResults{
                            if let blood:Int = item["d"].int, let time:Int = item["t"].int{
                                
                                var str = "\(time)" as NSString
                                str  = str.substring(with: NSRange(location: 0, length: 10)) as NSString
                                let formatter = DateFormatter()
                                formatter.dateFormat = "HH"
                                formatter.timeZone = TimeZone(abbreviation: "GMT+0800")
                                
                                let recordDate = Date(timeIntervalSince1970: Double(str.integerValue))
                                
                                let timeStr = formatter.string(from: recordDate)
                                
                                
                                bloodDataArray.add(blood/10)
                                bloodTimeArray.add(timeStr)
                                
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                
                                print("数据时间：\(formatter.string(from: recordDate))")
                                
                                
                                
                            }
                        }
                        
                        
                        
                        _ = self.parseTimeArray(bloodTimeArray).reverseObjectEnumerator().allObjects
                        //                        var parsedBloodTimeArray = self.parseTimeArray(bloodTimeArray).reverseObjectEnumerator().allObjects
                        
                        onComplete(true, "", bloodDataArray.reverseObjectEnumerator().allObjects as NSArray, bloodTimeArray.reverseObjectEnumerator().allObjects as NSArray)
                    }else{
                    }
                }else{
                    onComplete(false, "返回数据不完整", NSArray(), NSArray())
                }
                
            }else{
                
                onComplete(false, "返回数据错误", NSArray(), NSArray())
                
                
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error?) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                onError(error as! NSError)
        })
        
  
        getOperation?.start()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    
    

    
    func daysBeforeToday(_ date:Date) -> Int{
        
        
        let cal = Calendar.current
        
        let unit:NSCalendar.Unit = NSCalendar.Unit.day
        
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let timeStr = formatter.string(from: date)
        
        
        let currentTimeStr = formatter.string(from: Date())
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = formatter.date(from: "\(timeStr) 00:00:00")
        let currentTime = formatter.date(from: "\(currentTimeStr) 00:00:00")
        
        
        
        let components = (cal as NSCalendar).components(unit, from: date1!, to: currentTime!, options: [])
        
        return components.day!
        
    }
    //将["00","00","00","00","00","01","01","01","01","01","02","02","02","02","02"]
    //转化为：
    //["00", "", "", "", "", "01", "", "", "", "", "02", "", "", "", ""]
    func parseTimeArray(_ timeData:NSMutableArray) -> NSArray{
        
        let reverseTimeData = timeData.reverseObjectEnumerator()
        
        if timeData.count > 0{
            var count = 0
            var tmp = timeData[timeData.count - 1] as! NSString
            let parsedTimeData = NSMutableArray()
            var currentItem = ""
            
            
            for item in reverseTimeData{
                
                let value = item as! NSString
                
                if value == tmp {
                    if count == 0{
                        currentItem = value as String
                    }else{
                        currentItem = ""
                    }
                    count = count + 1
                }else{
                    
                    count = 1
                    currentItem = value as String
                }
                
                tmp = value
                
                parsedTimeData.add(currentItem)
                
            }
            
 
            return parsedTimeData
        }else{
            return []
        }
        
        
    }
    
    
    
    func myShare(_ text1:String,url:String,title:String,tag:Int){
        
       var text = text1
        
        var type:SSDKPlatformType!
        
        if tag == 1
        {
            type = SSDKPlatformType.typeWechat
        }
        else if tag == 3
        {
            type = SSDKPlatformType.typeQQ
        }
        else if tag == 4
        {
            type = SSDKPlatformType.typeSinaWeibo
            let tmpstr = text as NSString
            if tmpstr.length > 140
            {
                text = tmpstr.substring(to: 140)
            }
        }
        else
        {
            type = SSDKPlatformType.subTypeWechatTimeline
        }
        
        
        let shareParames = NSMutableDictionary()
        //设置分享参数
        shareParames.ssdkSetupShareParams(byText: text,
            images : UIImage (named: "yltlog.png"),
            url : URL(string:url),
            title : title,
            type : SSDKContentType.auto)
        
        //2.进行分享

        
        ShareSDK.share(type, parameters: shareParames) { (state: SSDKResponseState, userData: [AnyHashable : Any]?, contentEntity: SSDKContentEntity?, error: Error?) in

            switch state
            {
                
            case SSDKResponseState.success:
                
                let alrtView = UIAlertView(title: "分享成功", message: "", delegate: nil, cancelButtonTitle: "确定")
                alrtView.show()
                
                print("成功")
            case SSDKResponseState.fail:
                
                print(error!)
                
                let alrtView = UIAlertView(title: "分享失败", message: "", delegate: nil, cancelButtonTitle: "确定")
                alrtView.show()
                
                print("失败")
            case SSDKResponseState.cancel:
                
                let alrtView = UIAlertView(title: "分享取消", message: "", delegate: nil, cancelButtonTitle: "确定")
                alrtView.show()
                print("取消")
            default:
                break
            }
        
        }
        
        
    }
    
    
    
    
    
    //自定义返回按钮
    func creatBackBtn() ->(UIButton,UIBarButtonItem,UIBarButtonItem){
        
        let leftBtn = UIButton(frame: CGRect(x: 0,y: 0,width: 13,height: 26))
        leftBtn.setImage(UIImage(named: "tmBack"), for: UIControlState())
        

        let backItem = UIBarButtonItem(customView: leftBtn)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spacer.width = -5

        return (leftBtn,spacer,backItem)
        
    }
    //自定义右边添加按钮
    func creatRightBtn() ->(UIButton,UIBarButtonItem,UIBarButtonItem){
        let rightBtn = UIButton(frame: CGRect(x: 0,y: 0,width: 20,height: 20))
        
        rightBtn.setImage(UIImage(named: "rizhiAdd"), for: UIControlState())
        
        let rightItem = UIBarButtonItem(customView: rightBtn)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spacer.width = 0

        return (rightBtn,spacer,rightItem)
        
    }
    //自定义右边帮助按钮
    func creatRightHelpBtn() ->(UIButton,UIBarButtonItem,UIBarButtonItem){
        let rightBtn = UIButton(frame: CGRect(x: 0,y: 0,width: 20,height: 20))
        
        rightBtn.setImage(UIImage(named: "SHelp"), for: UIControlState())
        
        let rightItem = UIBarButtonItem(customView: rightBtn)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spacer.width = 20
        
        return (rightBtn,spacer,rightItem)
        
    }
       
    
    
    func creatRightBtnAtt(_ isImg: Bool,title: String?) ->(UIButton,UIBarButtonItem,UIBarButtonItem){
        let rightBtn = UIButton(frame: CGRect(x: 0,y: 0,width: 35,height: 18))
        
        if isImg {
            rightBtn.setImage(UIImage(named: "rizhiAdd"), for: UIControlState())
        }else{
            rightBtn.setTitle(title, for: UIControlState())
            rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }

        let rightItem = UIBarButtonItem(customView: rightBtn)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spacer.width = 0
        
        return (rightBtn,spacer,rightItem)
        
    }

    //获取手机型号
    func getSevrice() ->String{
        
        let name = UnsafeMutablePointer<utsname>.allocate(capacity: 1)
        uname(name)
        
        let machine = withUnsafePointer(to: &name.pointee.machine, { (ptr) -> String? in
            
            let int8Ptr = unsafeBitCast(ptr, to: UnsafePointer<CChar>.self)
            
            return String(cString: int8Ptr)
        })
        name.deallocate(capacity: 1)

        if let deviceString = machine {
            switch deviceString {
                //iPhone
                case "iPhone4,1":               return "iPhone 4S"
                case "iPhone5,1","iPhone5,2":   return "iPhone 5"
                case "iPhone5,3","iPhone5,4":   return "iPhone 5C"
                case "iPhone6,1","iPhone6,2":   return "iPhone 5S"
                case "iPhone7,1":               return "iPhone 6 Plus"
                case "iPhone7,2":               return "iPhone 6"
                case "iPhone8,1":               return "iPhone 6S"
                case "iPhone8,2":               return "iPhone 6S Plus"
                case "iPhone8,4":               return "iPhone SE"
                case "iPhone9,1","iPhone9,3":  return "iPhone 7"
                case "iPhone9,2","iPhone9,4":  return "iPhone 7 Plus"
                //iPad
                case "iPad1,1":                                 return "iPad"
                case "iPad2,1","iPad2,2","iPad2,3","iPad2,4":   return "iPad 2"
                case "iPad3,1","iPad3,2","iPad3,3":             return "iPad 3"
                case "iPad3,4","iPad3,5","iPad3,6":             return "iPad 4"
                case "iPad4,1","iPad4,2","iPad4,3":             return "iPad Air"
                case "iPad5,3","iPad5,4":                       return "iPad Air 2"
                case "iPad6,3","iPad6,4":                       return "iPad Pro(9.7inch)"
                case "iPad6,7","iPad6,8":                       return "iPad Pro(12.9inch)"
                case "iPad2,5","iPad2,6","iPad2,7":             return "iPad mini"
                case "iPad4,4","iPad4,5","iPad4,6":             return "iPad mini 2"
                case "iPad4,7","iPad4,8","iPad4,9":             return "iPad mini 3"
                case "iPad5,1","iPad5,2":                       return "iPad mini 4"
            default:
                return deviceString
            }
        }else{
            return "unknown"
        }
   
    }
    
  
    //MARK：获取图片缓存
    func cacheALG(_ cache:UInt)->String{

        let cacheFloat:Float = Float(cache)
        let caca = cacheFloat / 1024 / 1024

        let aaa = String(format: "%.1f", caca)

        switch caca{
        case 0...1024:
            return "\(aaa)MB"
        default:
            
            let bbb = caca / 1024
            let bbbaaa = String(format: "%.1f", bbb)

            return "\(bbbaaa)GB"
            
        }
        
    }
    
   
    
    
    
}
