//
//  SubDownView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/7.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SubDownView: UIView {
    
    typealias typeClours = (_ tag: Int,_ value: String,_ tagValue: Int)->Void
    
    var subTypeClours:typeClours?
    
    
    var nameArray:[String] = ["1两","2两","3两","4两","半斤","一斤","更多"]
    
    
    //选择的颜色
    var selectColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
    //默认的颜色
    var defaultColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1)
    
    var labelArray = [UILabel]()
    
    
    override func draw(_ rect: CGRect) {
        
        
        let anyWitdh = self.frame.size.width / CGFloat(self.nameArray.count)
        let anyHeight = self.frame.size.height
        
        
        for index in 0..<self.nameArray.count {
            //点击的视图
            let anyView = UIView(frame: CGRect(x: CGFloat(index) * anyWitdh, y: 0, width: anyWitdh, height: anyHeight))
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(SubDownView.someViewAct(_:)))
            anyView.addGestureRecognizer(tap)
            anyView.tag = index
            
            self.addSubview(anyView)
            
            //名字
            let anyLabel = UILabel(frame: CGRect(x: 0,y: 0,width: anyView.frame.size.width,height: anyView.frame.size.height))
            anyLabel.textAlignment = .center
            anyLabel.font = UIFont.systemFont(ofSize: 14)
            anyLabel.textColor = defaultColor
            anyLabel.text = nameArray[index]
            
            anyView.addSubview(anyLabel)
            
            self.labelArray.append(anyLabel)
            
            
        }
        
        //上边线条视图
        let upXiantView = UIView(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: 0.5))
        upXiantView.backgroundColor = UIColor(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1)
        self.addSubview(upXiantView)
        
        
        
    }
 
    func someViewAct(_ send: UITapGestureRecognizer){
        let selectTag = send.view!.tag
        print("点击了:\(selectTag),是：\(self.nameArray[selectTag])")
        
        
        for index in 0..<self.labelArray.count {
            let label = self.labelArray[index]
            
            
            if selectTag == index {
                label.textColor = self.selectColor
            }else{
                label.textColor = self.defaultColor
            }

        }
        
        var tagValue:Int = 0
        
        switch selectTag {
        case 0...4:
            tagValue = selectTag + 1
        case 5:
            tagValue = 10
        default:
            tagValue = 20
        }
        
        
        
        self.subTypeClours?(selectTag,self.nameArray[selectTag],tagValue)
        
    }
    
    //重置
    func reloadDownView(){
        for item in self.labelArray {
            item.textColor = self.defaultColor
        }
    }
    
    
    
    
    
    
    

}
