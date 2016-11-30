//
//  CalculationMethod.swift
//  BloodGlucose
//
//  Created by sqluo on 16/9/6.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class CalculationMethod: NSObject {

    //MARK:计算BMI
    func getBmiMethod(_ heigh: Float,weight: Float)->String{
        //计算BMI
        //BMI = 体重（kg）/ ( 身高（m） ＊ 身高（m）)
        var H: Float = 1
        if heigh < 2 {
            H = heigh
        }else{
            H = heigh / 100.0
        }

        let W = weight
        
        var bmi = ""
        if H == 0 {
            bmi = "0"
        }else{
            let bmiValue = W / (H * H)
            let newValue = NSString(format: "%.1f", bmiValue)
            bmi = "\(newValue)"
        }

        return bmi
    }
    
    
    
    
    
    
}
