//
//  HealthService.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/15.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class HealthService: NSObject {

    func getDataArray(_ section: Int,row: Int) ->[String]{
        
        
        var tmpArray = [String]()
        
        switch section {
        case 0:
            switch row {
            case 1:
                tmpArray = ["女","男"]
            default:
                break
            }
        case 1:
            
            switch row {
            case 0://身高
                for index in 100...200{
                    tmpArray.append("\(index)")
                }
            case 1://体重
                for index in 35...180{
                    tmpArray.append("\(index)")
                }
            default:
                break
            }
            
        case 2:
            switch row {
            case 0://糖尿病类型 ["未诊断","妊娠糖尿病","2型糖尿病","糖前高危","1型糖尿病","确诊人群","继发性","特殊类型"]
                tmpArray = ["未诊断","妊娠糖尿病","2型糖尿病","糖前高危","1型糖尿病","确诊人群","继发性","特殊类型"]
            case 2://并发症情况 ["无并发症","糖尿病心血管并发症","糖尿病肾病","糖尿病眼部并发症","糖尿病足","糖尿病性脑血管病","糖尿病神经病变"]
                tmpArray = ["无并发症","糖尿病心血管并发症","糖尿病肾病","糖尿病眼部并发症","糖尿病足","糖尿病性脑血管病","糖尿病神经病变"]
            default:
                break
            }
        case 5:
            tmpArray = ["否","是"]
        case 7:
            
            switch row {
            case 1:

                for i in stride(from: 1, to: 15.1, by: 0.1){
                    
                    tmpArray.append("\(i)%")
                    
                }
                
            case 2:
                
                for item in 40...240 {
                    
                    if item % 10 == 0 {
                        tmpArray.append("\(item)")
                    }
                    
                }
                
            default:
                break
            }
            
            
        default:
            break
        }
        
        
        return tmpArray
        
    }
    
    
    
    
    
    func bloodTypeCase(_ key: String) -> String{
        
        var value = "0"
        switch key {
        case "未诊断":
            value = "0"
        case "妊娠糖尿病":
            value = "1"
        case "2型糖尿病":
            value = "2"
        case "糖前高危":
            value = "3"
        case "1型糖尿病":
            value = "4"
        case "确诊人群":
            value = "5"
        case "继发性":
            value = "6"
        case "特殊类型":
            value = "7"
        default:
            value = "0"
        }
        
        return value
        
    }
    func bloodTypeCaseNumToStr(_ num: String) -> String{
        let bloodArray = ["未诊断","妊娠糖尿病","2型糖尿病","糖前高危","1型糖尿病","确诊人群","继发性","特殊类型"]
        
        if let tmp = Int(num){
            
            return bloodArray[tmp]
        }else{
            
            return bloodArray[0]
        }
        
        
        
    }
    
    
    
    func comolicaCase(_ comolica: String) -> String{
        //        ["无并发症","糖尿病心血管并发症","糖尿病肾病","糖尿病眼部并发症","糖尿病足","糖尿病性脑血管病","糖尿病神经病变"]
        
        var value = "0"
        switch comolica {
        case "无并发症":
            value = "0"
        case "糖尿病心血管并发症":
            value = "1"
        case "糖尿病肾病":
            value = "2"
        case "糖尿病眼部并发症":
            value = "3"
        case "糖尿病足":
            value = "4"
        case "糖尿病性脑血管病":
            value = "5"
        case "糖尿病神经病变":
            value = "6"
        default:
            value = "0"
        }
        
        return value
        
        
    }
    
    func comolicaCaseNumToStr(_ num: String) -> String{
        let comolicaArray = ["无并发症","糖尿病心血管并发症","糖尿病肾病","糖尿病眼部并发症","糖尿病足","糖尿病性脑血管病","糖尿病神经病变"]
        
        
        if let tmp = Int(num) {
            return comolicaArray[tmp]
        }else{
            return comolicaArray[0]
        }
  
        
    }
    
    
    
}
