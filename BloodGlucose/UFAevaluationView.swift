//
//  UFAevaluationView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/9.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class UFAevaluationView: UIView {


//    override func drawRect(rect: CGRect) {
//        
//    }
 
    
    
    func loadUFAevaluationView(_ bjDic:NSDictionary){
        
        let tmpcount = bjDic.value(forKey: "count") as! String
        let countDouble:Double = Double(tmpcount)!
        let count = NSString(format: "%.1f", countDouble)
        
        let tmpvalue:Float = Float(count as String)!
        
        print(tmpvalue)
        
        switch tmpvalue {
        case 0..<60:
            print("差")
            self.loadEvaluateView()
        case 60..<80:
            print("良")
            self.loadWellView()
        default:
            print("优")
            self.loadSnowWellView()
        }
        
        
        
        
    }
    
    
    
    //MARK:1.加载报警动画视图（较差）
    func loadEvaluateView(){

        let evaluateView = Bundle.main.loadNibNamed("EvaluateView", owner: nil, options: nil)?.first as! EvaluateView
        evaluateView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(evaluateView)
        
    }
    //MARK:2.加载报星星动画视图（良好）
    func loadWellView(){
        
        let wellView = Bundle.main.loadNibNamed("WellView", owner: nil, options: nil)?.first as! WellView
        wellView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(wellView)
        
    }
    //MARK:3.加载雪花动画视图（优秀）
    
    func loadSnowWellView(){
        let snowWellView = Bundle.main.loadNibNamed("WellSnowView", owner: nil, options: nil)?.first as! WellSnowView
        snowWellView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(snowWellView)
        
    }

}
