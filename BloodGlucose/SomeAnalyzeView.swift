//
//  SomeAnalyzeView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/9.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SomeAnalyzeView: UIView {

    
    
    //分析
    @IBOutlet weak var analyzeTextView: UITextView!
    //同龄
    @IBOutlet weak var sameageTextView: UITextView!
    //同时
    @IBOutlet weak var sametimeTextView: UITextView!
    
    
    func insertDateLoadSomeAnalyzeView(_ analy:String,tlong:String,age:String){
        print(analy,tlong,age)
        
        self.analyzeTextView.text = analy
        self.sameageTextView.text = age
        self.sametimeTextView.text = tlong
        
        
        
    }
    
    
    
    
    
    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
