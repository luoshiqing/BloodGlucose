  //
//  MyNetworkRequest.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/11.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyNetworkRequest: NSObject {

    
    //图片上传
    func doFormData(_ url: String, dict: [String: String], imgData: [Data], success: @escaping (_ data: Any) -> Void, failure failue: @escaping () -> Void) {
        let manager = self.createManager()

        manager.post(url, parameters: dict, constructingBodyWith: { (formData: AFMultipartFormData?) in
            for i in 0..<imgData.count {
                let imageData: Data = imgData[i]
                // 上传的参数名
                let Name = "Img\(i + 1)"
                // 上传filename
                let fileName = "\(Name).jpg"
                
                formData?.appendPart(withFileData: imageData, name: Name, fileName: fileName, mimeType: "image/jpeg")
                
            }
            
        }, success: { (operation: AFHTTPRequestOperation?, responseObject: Any?) in
            success(operation!.responseData)
        }) { (operation: AFHTTPRequestOperation?, error: Error?) in
            failue()
        }
 
    }
    
    func createManager() -> AFHTTPRequestOperationManager {
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.timeoutInterval = 20.0
        manager.securityPolicy.allowInvalidCertificates = true
        manager.responseSerializer.acceptableContentTypes = Set<AnyHashable>(["application/json", "text/json", "text/plain", "text/html"])
        manager.responseSerializer = AFHTTPResponseSerializer()
        return manager
    }


    
    fileprivate var userIcvalueHUD:JGProgressHUD!
    
    
    //提交填写信息
    func addUserInfoJsp(_ showHUD: UIView,dataDic: [String:String], clourse: @escaping ((_ success: Bool)->Void)){

        
        self.userIcvalueHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.userIcvalueHUD.textLabel.text = "提交中.."
        self.userIcvalueHUD.show(in: showHUD, animated: true)
        
  
        if let _ = dataDic["stype"] {
            let uid:String = String(ussssID)
            let reqUrl:String = "\(TEST_HTTP)/jsp/help/adduserinfo.jsp"
            let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
            let codeMD5 = code.md5.uppercased()
            
            var dicDPost = [
                "userid":uid,
                "clientid":CLIENTID,
                "random":RandoM,
                "code":codeMD5]
            
            dicDPost += dataDic

            
            RequestBase().doPost(reqUrl, dicDPost , success: { (res: Any?) in
                
                let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)

                print(json)
                
                let coded:Int = json["code"].intValue
                
                if coded == 1 {
                    
                    self.userIcvalueHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.userIcvalueHUD.textLabel.text = "提交成功"
                    self.userIcvalueHUD.dismiss(afterDelay: 0.5, animated: true)
                    
                    clourse(true)
                }else{
                    self.userIcvalueHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.userIcvalueHUD.textLabel.text = "提交失败"
                    self.userIcvalueHUD.dismiss(afterDelay: 0.5, animated: true)
                }
                
                }, failure: { () -> Void in
                    
                    print("RequestBase------false")
                    self.userIcvalueHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.userIcvalueHUD.textLabel.text = "网络错误"
                    self.userIcvalueHUD.dismiss(afterDelay: 0.5, animated: true)
            })
            
            
        }
        
    }

    //MARK:风险评估请求
    func getRiskAssessment(_ view: UIView,clourse: @escaping ((_ success: Bool,_ value: Any ,_ upDic: [String:Any])->Void)){
        
        self.userIcvalueHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.userIcvalueHUD.textLabel.text = "加载中.."
        self.userIcvalueHUD.show(in: view, animated: true)
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/getusericvalue.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
        ]
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            //print("json:\(json)")
            
            self.userIcvalueHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.userIcvalueHUD.textLabel.text = "加载成功"
            self.userIcvalueHUD.dismiss(afterDelay: 0.5, animated: true)
            
            
            let message:String = json["message"].stringValue
            if message == "成功" {
                
                if let dataDic:NSDictionary = json["data"].dictionaryObject as NSDictionary?{
                    
                    let sex = dataDic.value(forKey: "sex") as! Int
                    
                    let sexStr = sex == 0 ? "女" : "男"
                    
                    
                    //icvalue  返回结果0未检测、1正常、2危险
                    let icvalue = dataDic.value(forKey: "icvalue") as! String
                    //空腹血糖
                    let fbg = dataDic.value(forKey: "fbg") as! Float
                    
                    
                    let birth = dataDic.value(forKey: "birth") as! String     //出生日期
                    let heigh = dataDic.value(forKey: "heigh") as! Int        //身高
                    let weight = dataDic.value(forKey: "weight") as! Int      //体重
                    let abdomen = dataDic.value(forKey: "abdomen") as! Int    //腹围
                    let pht = dataDic.value(forKey: "pht") as! Int            //高压
                    
                    var range: String!
                    if let tmpRange = dataDic.value(forKey: "range") as? String{
                        range = tmpRange
                    }
                    
                    
                    //计算BMI
                    //BMI = 体重（kg）/ ( 身高（m） ＊ 身高（m）)
                    let H:Float = Float(heigh) / 100.0
                    let W:Float = Float(weight)
                    
                    var bmi = ""
                    if H == 0 {
                        bmi = "0"
                    }else{
                        let bmiValue = W / (H * H)
                        let newValue = NSString(format: "%.1f", bmiValue)
                        bmi = "\(newValue)"
                    }
                    
                    var familydiabetes = 0
                    if let tmpfamilydiabetes = dataDic.value(forKey: "familydiabetes") as? Int{
                        
                        familydiabetes = tmpfamilydiabetes
                        
                    }
                    
                    let familydiabetesStr = familydiabetes == 0 ? "无" : "有"
                    
                    
                    
                    //数组
                    let tmpArray = [["\(sexStr)","\(birth)"],
                                    ["\(heigh)","\(weight)"],
                                    ["\(abdomen)","\(pht)"],
                                    ["\(familydiabetesStr)","\(fbg)"]]
                    
                    var tmpDic:[String:Any] = ["icvalue":icvalue,
                                                     "bmi":bmi,
                                                     "values":tmpArray]
                    
                    if range != nil{
                        tmpDic["range"] = range
                        
                    }
                    
                    
                    let upDic: [String:Any] = ["sex":"\(sex)",
                        "birth":"\(birth)",
                        "heigh":"\(heigh)",
                        "weight":"\(weight)",
                        "abdomen":"\(abdomen)",
                        "pht":"\(pht)",
                        "familydiabetes":"\(familydiabetes)",
                        "fbg":"\(fbg)",
                    ]
                    
                    
                    clourse(true, tmpDic, upDic)
                    
                }
                
            }
            
            
            }, failure: { () -> Void in
                
                print("false")

                self.userIcvalueHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.userIcvalueHUD.textLabel.text = "网络错误"
                self.userIcvalueHUD.dismiss(afterDelay: 0.5, animated: true)
                
                
        })
        
   
    }

    
    //提交userIcvalue
    
    fileprivate var saveHUD:JGProgressHUD!
    
    func saveRiskAssessment(_ dic: [String:Any],view: UIView,clourse: @escaping ((_ value: [String:String])->Void)){
  
        self.saveHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.saveHUD.textLabel.text = "提交中.."
        self.saveHUD.show(in: view, animated: true)
        
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/help/setusericvalue.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost: [String:Any] = [
        "userid":userid,
        "clientid":CLIENTID,
        "random":RandoM,
        "code":codeMD5,
        ]

        dicDPost += dic
        

        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            //print("\(json)")
            
            if let tmpMessage: Int = json["code"].int {
                
                if tmpMessage == 1 { //ok
                    
                    self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveHUD.textLabel.text = "提交成功"
                    self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
                    
                    if let dataDic: NSDictionary = json["data"].dictionaryObject as NSDictionary?{
                        
                        var icvalue = "" //评分
                        
                        var icvaluedata = "" //评分提示
                        
                        
                        var range = "" //评分系数
                        
                        
                        if let tmpicvalue = dataDic.value(forKey: "icvalue") as? String{
                            
                            icvalue = tmpicvalue
                            
                        }

                        if let tmpicvaluedata = dataDic.value(forKey: "icvaluedata") as? String{
                            icvaluedata = tmpicvaluedata
                        }
                        
                        
                        if let tmpRange = dataDic.value(forKey: "range") as? String{
                            range = tmpRange
                        }
                        

                        //计算BMI
                        let hei = Float(dic["heigh"] as! String)! / 100
                        let wei = Float(dic["weight"] as! String)!
                        
                        let newValue = wei / hei / hei
                        
                        let bmi = NSString(format: "%.1f", newValue)
                        
                        let tmpDic:[String:String] = ["icvalue":icvalue,"icvaluedata":icvaluedata,"bmi":"\(bmi)","range":range]
                        
                        clourse(tmpDic)
                        
                    }
                    
                }else{
                    //false
                    
                    self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveHUD.textLabel.text = "提交失败"
                    self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
                }

            }else{
                self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveHUD.textLabel.text = "网络错误"
                self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
            }
            
            
            }, failure: { () -> Void in
                
                print("false错误")
                self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveHUD.textLabel.text = "网络错误"
                self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
        })
    }

    //提交血糖录入
    func submitBloodsugar(_ view: UIView ,dic: [String:String] ,clourse: @escaping ((_ success: Bool)->Void)){
        
        
        
        
        self.saveHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.saveHUD.textLabel.text = "提交中.."
        self.saveHUD.show(in: view, animated: true)
        
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/event/newLog.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
        ]
        
        print(dicDPost)
        
        var dicc = [AnyHashable: Any]()
        
//        dicc.addEntries(from: dic as [AnyHashable: Any])
//        dicc.addEntries(from: dicDPost as! [AnyHashable: Any])
        for (key,value) in dic {
            dicc.updateValue(value, forKey: key as AnyHashable)
        }
        for (key,value) in dicDPost {
            dicc.updateValue(value, forKey: key as! AnyHashable)
        }
        
        RequestBase().doPost(reqUrl, dicc, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            //print("\(json)")
            
            if let tmpCode = json["code"].int{
                
                if tmpCode == 1 {
                    
                    self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveHUD.textLabel.text = "提交成功"
                    self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
                    
                    clourse(true)
                }else{
                    
                    self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveHUD.textLabel.text = "提交失败"
                    self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
                    
                    clourse(false)
                }
                
                
                
            }
  
            }, failure: { () -> Void in
                
                print("false")
                self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveHUD.textLabel.text = "网络错误"
                self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
        })
        
        
    
        
    }
  
    func getStatisticalBloodsugar(_ view: UIView ,dic: [String:String] ,clourse: @escaping ((_ success: Bool,_ valueArray: [[String]],_ ChartDataDic: [String:Any])->Void)){
        
        
        
        self.saveHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.saveHUD.textLabel.text = "加载中.."
        self.saveHUD.show(in: view, animated: true)
        
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/event/getlogbloodsugarbytime.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost: [String:String] = ["userid":uid,
                                         "clientid":CLIENTID,
                                         "random":RandoM,
                                         "code":codeMD5]
        
        dicDPost += dic


        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            //print("\(json)")

            if let cod = json["code"].int{
                
                if cod == 0{//成功
                    
                    self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveHUD.textLabel.text = "加载成功"
                    self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
                    
                    
                    if let data = json["data"].arrayObject {
                        
                        //图形数据
                        let xVals: [String] = ["凌\n晨","早\n餐\n前","早\n餐\n后","午\n餐\n前","午\n餐\n后","晚\n餐\n前","晚\n餐\n后","睡\n前","随\n机"]
                        //日期
                        var dateArray = [String]()
                        
                        var myYVals = [[ChartDataEntry]]()
                        
                        
                        var valueArray = [[String]]()
                        
                        for item in data{
                            
                            
                            let dic = item as! NSDictionary
                            
                            //日期
                            let day = dic.value(forKey: "day") as! String
                            //处理
//                            let dayA = (day as NSString).substring(with: NSRange(5...9))
                            let dayA = (day as NSString).substring(with: NSRange(location: 5, length: 5))
                            
                            dateArray.append(dayA)
                            
                            let tmpData = dic.value(forKey: "data") as! NSArray
                            
                            var oneDayArray = [dayA,"","","","","","","","",""]
                            
                            var yVals = [ChartDataEntry]()
                            
                            for index in tmpData{
                                
                                
                                let tmpDic = index as! NSDictionary
                                
                                //时间段
                                let e = tmpDic.value(forKey: "e") as! String
                                //血糖值
                                let d = tmpDic.value(forKey: "d") as! String
                                
//                                yVals.append(ChartDataEntry(value: Double(d)!, xIndex: Int(e)!))
                                
                                print(d,e)
                                
                                yVals.append(ChartDataEntry(x: Double(e)!, y: Double(d)!))
                                
//                                yVals.append(ChartDataEntry(x: Double(d)!, y: Int(e)!)
                                
                                
                                oneDayArray[Int(e)! + 1] = d
                                
                                
                            }
                            
                            myYVals.append(yVals)
                            
                            valueArray.append(oneDayArray)
                            
                        }
                        
                        
                        let chartDic: [String : Any] = ["xVals":xVals,"myYVals":myYVals,"dateArray":dateArray]
                        
                        //倒序
                        valueArray = valueArray.reversed()
                        clourse(true, valueArray, chartDic)
                    }
                    
                    
                }else{//没有数据
                    
                    self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveHUD.textLabel.text = "暂无数据"
                    self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
                    
                    
                    clourse(false, [["nil"]], ["false":"nil"])
                    
                    
                }
                
      
            }
 
            
            }, failure: { () -> Void in
                
                print("false")
                self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveHUD.textLabel.text = "网络错误"
                self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
        })

      
        
    }
  
    //获取所有血糖记录
    
    func getAllStatisticalBloodsugar(_ view: UIView ,dic: [String:String] ,clourse: @escaping ((_ success: Bool,_ dateArray: [String],_ valueArray: [[[String]]])->Void)){
        
        self.saveHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.saveHUD.textLabel.text = "加载中.."
        self.saveHUD.show(in: view, animated: true)
        
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/event/getlogbloodsugarbyalltime.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
        ]
        
        var dicc = [AnyHashable: Any]()
        
//        dicc.addEntries(from: dic as [AnyHashable: Any])
//        dicc.addEntries(from: dicDPost as! [AnyHashable: Any])
        for (key,value) in dic {
            dicc.updateValue(value, forKey: key)
        }
        for (key,value) in dicDPost {
            dicc.updateValue(value, forKey: key as! AnyHashable)
        }
        
        
        
        RequestBase().doPost(reqUrl, dicc, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
//            print("\(json)")
            
            
            
            
            if let cod = json["code"].int{
                
                if cod == 0{//ok
                    
                    self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveHUD.textLabel.text = "加载成功"
                    self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
                    
                    
                    if let data = json["data"].arrayObject{
                        
                        let titleArray = ["凌晨",
                            "早餐前",
                            "早餐后",
                            "午餐前",
                            "午餐后",
                            "晚餐前",
                            "晚餐后",
                            "睡前",
                            "随机"]
                        
                        
                        var dateArray = [String]()
                        
                        var valueArray = [[[String]]]()
                        
                        for item in data{
                            
                            let dic = item as! NSDictionary
                            
                            
                            let day = dic.value(forKey: "day") as! String
                            
                            dateArray.append(day)
                            
                            
                            let tmpData = dic.value(forKey: "data") as! NSArray
                            
                            var dayArray = [[String]]()
                            
                            for index in tmpData{
                                
                                let tmpDci = index as! NSDictionary
                                
                                let e = tmpDci.value(forKey: "e") as! String
                                let d = tmpDci.value(forKey: "d") as! String
                                
                                let t = tmpDci.value(forKey: "t") as! String
                                
                                let id = tmpDci.value(forKey: "id") as! String
                                
                                let nameT = titleArray[Int(e)!]
                                
                                let tmpArray = [nameT,t,d,id]
                                
                                dayArray.append(tmpArray)
                                
                            }
                            valueArray.append(dayArray)
                        }
                        
                        dateArray = dateArray.reversed()
                        valueArray = valueArray.reversed()
                        
                        clourse(true,dateArray, valueArray)

                        
                    }
     
                }else{//没有数据或者错误
                    
                    
                    self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveHUD.textLabel.text = "暂无数据"
                    self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
                    
                    clourse(false, ["nil"], [[["nil"]]])
                    
                    
                }
                
                
                
            }
   
            }, failure: { () -> Void in
                
                print("false")
                self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveHUD.textLabel.text = "网络错误"
                self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
        })
        
        
        
    }
    
    //删除单挑血糖记录
    func removeBloodsugar(_ view: UIView ,removeid: [String:String] ,clourse: @escaping ((_ success: Bool)->Void)){
        
        self.saveHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.saveHUD.textLabel.text = "删除中..."
        self.saveHUD.show(in: view, animated: true)
        
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/event/newLog.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
        ]
        
        var dicc = [AnyHashable: Any]()
        
//        dicc.addEntries(from: removeid as [AnyHashable: Any])
//        dicc.addEntries(from: dicDPost as! [AnyHashable: Any])
        for (key,value) in removeid {
            dicc.updateValue(value, forKey: key)
        }
        for (key,value) in dicDPost {
            dicc.updateValue(value, forKey: key as! AnyHashable)
        }
        
        
        RequestBase().doPost(reqUrl, dicc, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            //print("\(json)")
            
            self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.saveHUD.textLabel.text = "删除成功"
            self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
            
            if let tmpCode = json["code"].int{
                if tmpCode == 1{
                    clourse(true)
                }
            }
            
            
            }, failure: { () -> Void in
                
                print("false")
                self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveHUD.textLabel.text = "网络错误"
                self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
        })
        
        
        
    }

    //MARK: 健康圈子
    //删除单条血糖记录
    func getHealthCircleData(_ view: UIView ,showHUD: Bool,page: Int ,shownum: Int ,clourse: @escaping ((_ haveData: Bool,_ listArray: [[String:Any]]?)->Void)){
        if showHUD {
            self.saveHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
            self.saveHUD.textLabel.text = "加载中..."
            self.saveHUD.show(in: view, animated: true)
        }
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/circle/getcircle.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost: [String:Any] = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "page":page,
            "shownum":shownum
        ]
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            
            
            if showHUD{
                self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveHUD.textLabel.text = "加载成功"
                self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
            }
            if let tmpCode = json["code"].int{
                if tmpCode == 0{
                    if let data = json["data"].dictionaryObject{
                        let listArray = data["list"] as! [[String:Any]]
                        clourse(true, listArray)
                    }
                }else if tmpCode == 10002{
                    //数据为空
                    clourse(false, nil)
                }
            }
            }, failure: { () -> Void in
                
                print("false")
                if showHUD{
                    self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveHUD.textLabel.text = "网络错误"
                    self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
                }
        })
    }
    
    //MARK:获取消息size
    func getMessageData(_ view: UIView ,clourse: @escaping ((_ size: Int)->Void)){

        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/message/getmessagesize.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            ]
        
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            //print("\(json)")
 
            if let tmpCode = json["code"].int{
                if tmpCode == 0{ //成功
                    
                    if let data = json["data"].dictionaryObject{
                        
                        let size = Int(data["size"] as! String)!
                        
                        
                        clourse(size)
                        
                    }
                    
                }
            }
            
            
            }, failure: { () -> Void in
                
                print("false")
    
        })
  
        
    }
    
    //获取消息文本
    
    //MARK:获取消息size
    func getMessageTextData(_ view: UIView, showHUD: Bool,page: Int, shownum: Int, clourse: @escaping ((_ haveData: Bool,_ dataArray: [(intro: String,time: String,state: String,id: String,title: String,type: String)]?,_ notsize: Int)->Void)){
        
        if showHUD {
            self.saveHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
            self.saveHUD.textLabel.text = "加载中..."
            self.saveHUD.show(in: view, animated: true)
        }
        
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/message/getmessagelist.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "page":page,
            "shownum":shownum
        ]
 
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            //print("\(json)")
            if showHUD {
                self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveHUD.textLabel.text = "加载成功"
                self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
            }
            
            
            if let tmpCode = json["code"].int{
                if tmpCode == 0{ //成功
                    
                    if let data = json["data"].dictionaryObject{
                        
                        let list = data["list"] as! [NSDictionary]
                        
                        var dataArray = [(intro: String,time: String,state: String,id: String,title: String,type: String)]()
                        
                        let notsize = Int(data["notsize"] as! String)!
                        
                        
                        if list.isEmpty{
                            clourse(false, nil, notsize)
                            
                        }else{
                            for tmpDic in list{
                                
                                let id = tmpDic.value(forKey: "id") as! String
                                
                                let title = tmpDic.value(forKey: "title") as! String
                                
                                let state = tmpDic.value(forKey: "state") as! String //0未读
                                
                                let intro = tmpDic.value(forKey: "intro") as! String //显示的
                                
                                let time = tmpDic.value(forKey: "time") as! String
                                
                                let type = tmpDic.value(forKey: "type") as! String
                                
                                //let tmpArray = [intro,time,state,id]
                                
                                let tmp = (intro:intro,time:time,state:state,id:id,title:title,type:type)

                                dataArray.append(tmp)
                            }
                            
                            
                            clourse(true,dataArray, notsize)
                        }
                        
    
   
                    }
                    
                }
            }
            
            
            }, failure: { () -> Void in
                
                print("false")
                if showHUD {
                    self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveHUD.textLabel.text = "网络错误"
                    self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
                }

        })
        
        
    }
    
 
    func getPieData(_ view: UIView,day: String,sensorsid: String,clourse: @escaping ((_ pieDataDic: NSMutableDictionary, _ binXJText: String)->Void)){
        
        self.saveHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.saveHUD.textLabel.text = "加载中.."
        self.saveHUD.show(in: view, animated: true)
        
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/report/getpie.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "sensorsid":sensorsid,
            "day":day
        ]
        
 
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            //print("\(json)")
            
            if let tmpMessage: Int = json["code"].int {
                
                if tmpMessage == 1 { //ok
                    
                    self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveHUD.textLabel.text = "加载成功"
                    self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
                    
                    let pieDataDic = NSMutableDictionary()
                    
                    
                    
                    if let dataDic: NSDictionary = json["data"].dictionaryObject as NSDictionary?{
                        
                        let a = Double((dataDic.value(forKey: "a") as! String).components(separatedBy: "%")[0])!
                        let b = Double((dataDic.value(forKey: "b") as! String).components(separatedBy: "%")[0])!
                        let c = Double((dataDic.value(forKey: "c") as! String).components(separatedBy: "%")[0])!
                        
                        pieDataDic["a"] = a
                        pieDataDic["b"] = b
                        pieDataDic["c"] = c
                        
                        
                        let desc = dataDic.value(forKey: "desc") as! String
                        let doctorAdvise = dataDic.value(forKey: "doctorAdvise") as! String
                        let dieticianAdvise = dataDic.value(forKey: "dieticianAdvise") as! String
                        
                        let binXJText = "\(desc)\n医生建议:\(doctorAdvise)\n饮食建议:\(dieticianAdvise)"
    
                        clourse(pieDataDic, binXJText)
                    }
                    
                }else{
                    //false
                    
                    self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.saveHUD.textLabel.text = "加载失败"
                    self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
                }
                
            }else{
                self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveHUD.textLabel.text = "网络错误"
                self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
            }
            
            
            }, failure: { () -> Void in
                
                print("false错误")
                self.saveHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.saveHUD.textLabel.text = "网络错误"
                self.saveHUD.dismiss(afterDelay: 0.5, animated: true)
        })
    }
    //获取HbA1c
    func getHbA1c(_ sid: String, clourse: @escaping ((_ hba1c: String)->Void)){
    
    
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/gethb.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":uid,
            "sid":sid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            
        ]
        
        print(dicDPost)
        
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            //            print("\(res)")
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print(json)

            if let hba1c:String = json["data"].string{

                print("hba1c------:\(hba1c)")

                clourse(hba1c)
                
            }
            }, failure: { () -> Void in
                print("false")
        })
 
    }
    
    
       
    
   
    
}
