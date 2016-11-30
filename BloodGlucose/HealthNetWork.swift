//
//  HealthNetWork.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/22.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class HealthNetWork: NSObject {

    fileprivate var userIcvalueHUD:JGProgressHUD!
    
    func getHealthDocument(_ view: UIView,clourse: @escaping ((_ showArray: [Array<Any>] ,_ upDic: [String:String])->Void)){
    
    
        self.userIcvalueHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.userIcvalueHUD.textLabel.text = "加载中.."
        self.userIcvalueHUD.show(in: view, animated: true)
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/person/getpomr.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
    
    
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
        ]
    
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res:Any?) -> Void in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("json:\(json)")

            if let cod = json["code"].int {
                if cod == 1 { //ok
                    self.userIcvalueHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.userIcvalueHUD.textLabel.text = "加载成功"
                    self.userIcvalueHUD.dismiss(afterDelay: 0.5, animated: true)
                    
                    
                    if let dataDic: NSDictionary = json["data"].dictionaryObject as NSDictionary?{
                        //姓名
                        let realname = dataDic.value(forKey: "realname") as! String
                        //性别
                        let sex = dataDic.value(forKey: "sex") as! String
                        
                        var sexA = ""
                        if sex == "0"{
                            sexA = "女"
                        }else{
                            sexA = "男"
                        }
                        
                        //出生日期
                        let birth = dataDic.value(forKey: "birth") as! String
                        //身高
                        let heigh = (dataDic.value(forKey: "heigh") as! String) == "0" ? "" : (dataDic.value(forKey: "heigh") as! String)
                        //体重
                        let weight = (dataDic.value(forKey: "weight") as! String) == "0" ? "" : (dataDic.value(forKey: "weight") as! String)
                        //计算BMI
                        let tmpBmi = Double(dataDic.value(forKey: "bmi") as! String)!

                        let bmi = String(format: "%.1f", tmpBmi)
    
                        //糖尿病类型
                        let bloodtype = dataDic.value(forKey: "bloodtype") as! String
                        
                        let tmpBloodType = HealthService().bloodTypeCaseNumToStr(bloodtype)
    
                        //确诊时间
                        let diagnosistime = dataDic.value(forKey: "diagnosistime") == nil ? "" : dataDic.value(forKey: "diagnosistime") as! String
                        //并发症情况
                        let comolica = dataDic.value(forKey: "comolica") as! String
                        
                        let tmpComolica = HealthService().comolicaCaseNumToStr(comolica)
                        
                        
                        
                        
                        
                        
                        
                        //既往病史
                        let history = dataDic.value(forKey: "history") == nil ? "" : dataDic.value(forKey: "history") as! String
                        //目前用药
                        let pharmacy = dataDic.value(forKey: "pharmacy") == nil ? "" : dataDic.value(forKey: "pharmacy") as! String
                        //父母是否患有糖尿病
                        let familydiabetes = dataDic.value(forKey: "familydiabetes") as! String
                        
                        var familyA = ""
                        
                        if familydiabetes == "0"{
                            familyA = "否"
                        }else{
                            familyA = "是"
                        }
                        
                        
                        //药物过敏情况
                        let drugallergy = dataDic.value(forKey: "drugallergy") == nil ? "" : dataDic.value(forKey: "drugallergy") as! String
                        //最近空腹血糖
                        let fbg = dataDic.value(forKey: "fbg") as! String
                        //糖化血红蛋白
                        let ghbaic = dataDic.value(forKey: "ghbaic") as! String
                        //高压
                        let pht = dataDic.value(forKey: "pht") as! String
                        //低压
                        let lp = dataDic.value(forKey: "lp") as! String
                        //图片数组
                        let reportresaltsimg = dataDic.value(forKey: "reportresaltsimg") as! [String]
                        print(reportresaltsimg)

                        //内容文字
                        let reportresaltsvalue = dataDic.value(forKey: "reportresaltsvalue") as! String
                        
                        
                        let valueArray: [Array<Any>] = [[realname,sexA,birth],
                            [heigh,weight,bmi,],
                            [tmpBloodType,diagnosistime,tmpComolica,],
                            [history],
                            [pharmacy],
                            [familyA],
                            [drugallergy],
                            [fbg,"\(ghbaic)","\(pht)/\(lp)",],
                            [reportresaltsimg,reportresaltsvalue]]
                        
                        let upDic: [String:String] = ["realname":realname,
                            "sex":sex,
                            "birth":birth,
                            "heigh":heigh,
                            "weight":weight,
                            "bloodtype":bloodtype,
                            "diagnosistime":diagnosistime,
                            "comolica":comolica,
                            "history":history,
                            "pharmacy":pharmacy,
                            "familydiabetes":familydiabetes,
                            "drugallergy":drugallergy,
                            "fbg":fbg,
                            "ghbaic":ghbaic,
                            "pht":pht,
                            "lp":lp,
//                            "reportresaltsimg":reportresaltsimg,
                            "reportresaltsvalue":reportresaltsvalue]
                        
            
                        clourse(valueArray, upDic)
                        
                    }
       
                }else{
                    self.userIcvalueHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.userIcvalueHUD.textLabel.text = "加载失败"
                    self.userIcvalueHUD.dismiss(afterDelay: 0.5, animated: true)
                }
               
                
            }
            
            
            }, failure: { () -> Void in
                
                print("false")
                
                self.userIcvalueHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.userIcvalueHUD.textLabel.text = "网络错误"
                self.userIcvalueHUD.dismiss(afterDelay: 0.5, animated: true)
                
                
        })
    
    
    }
    
    
    
      
    func subitHealtDocument(_ view: UIView,upDic: [String:String],parameters: [Data],clourse: @escaping ((_ success: Bool)->Void)){
        
        self.userIcvalueHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.userIcvalueHUD.textLabel.text = "提交中.."
        self.userIcvalueHUD.show(in: view, animated: true)
        
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/person/setpomr.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        
        var dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5]
 
        dicDPost += upDic
        
        
        
        MyNetworkRequest().doFormData(reqUrl, dict: dicDPost, imgData: parameters, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
            
            if let cod = json["code"].int{
                
                if cod == 1{
                    self.userIcvalueHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.userIcvalueHUD.textLabel.text = "提交成功"
                    self.userIcvalueHUD.dismiss(afterDelay: 0.5, animated: true)
                    
                    clourse(true)
                    
                }else{
                    self.userIcvalueHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.userIcvalueHUD.textLabel.text = "提交失败"
                    self.userIcvalueHUD.dismiss(afterDelay: 0.5, animated: true)
                    
                    
                }
                
     
            }

            
            }, failure: {
                print("false")
                
                
                self.userIcvalueHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.userIcvalueHUD.textLabel.text = "网络错误"
                self.userIcvalueHUD.dismiss(afterDelay: 0.5, animated: true)
                
        })
    
    
    }
   
    
    
}
