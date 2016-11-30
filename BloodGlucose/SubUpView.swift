//
//  SubUpView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/7.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SubUpView: UIView {

    
    typealias upViewValueClours = (_ tag: Int,_ nameStr: String)->Void
    
    var subUpViewValueClours:upViewValueClours?
    
    
    var nameArray:[String]! //视图类型名称

    var translationView:UIView! //移动的视图
    
    
    var labelArray = [UILabel]()//名称数组
    
    //选中的颜色
    var selectColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
    //默认的颜色
    var nomarlColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1)
    
    
    override func draw(_ rect: CGRect) {
        
       
        
        if self.nameArray == nil {
            self.nameArray = ["米面豆乳","肉禽类","蔬菜类","果品类","水产品"]
        }
        
        
        let anyWidth = self.frame.size.width / CGFloat(self.nameArray.count)
        let anyHeight = self.frame.size.height
        
        for index in 0..<self.nameArray.count {
            //底部点击视图
            let anyView = UIView(frame: CGRect(x: CGFloat(index) * anyWidth,y: 0,width: anyWidth,height: anyHeight))
            anyView.backgroundColor = UIColor.clear
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(SubUpView.someViewAct(_:)))
            anyView.addGestureRecognizer(tap)
            anyView.tag = index
            
            self.addSubview(anyView)
            //视图的名字
            let anyLabel = UILabel(frame: CGRect(x: 0,y: 0,width: anyView.frame.size.width,height: anyView.frame.size.height))
            anyLabel.textAlignment = .center
            anyLabel.font = UIFont.systemFont(ofSize: 16)
            anyLabel.text = self.nameArray[index]
            anyView.addSubview(anyLabel)
            
            if index == 0 {
                anyLabel.textColor = selectColor
            }else{
                anyLabel.textColor = nomarlColor
            }
            
            self.labelArray.append(anyLabel)
            
            
            
        }
        //移动的视图
        translationView = UIView(frame: CGRect(x: (anyWidth - anyWidth / 2) / 2,y: anyHeight - 1,width: anyWidth / 2,height: 1))
        self.addSubview(translationView)
        translationView.backgroundColor = selectColor
        
        
    }
 
    //记录选择的是第几个
    var upSelectInt = 0
    
    func someViewAct(_ send: UITapGestureRecognizer){
        
        
        let selecTag = send.view!.tag
        print(selecTag)
        
        if self.upSelectInt != selecTag {
            
            self.upSelectInt = selecTag
            
            for index in 0..<self.labelArray.count {
                let mylabel = self.labelArray[index]
                
                if selecTag == index {
                    mylabel.textColor = selectColor
                    
                    
                    UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
                        
                        let anyWidth = self.frame.size.width / CGFloat(self.nameArray.count)
                        self.translationView.frame.origin.x = CGFloat(index) * anyWidth + anyWidth / 4
                        
                        }, completion: nil)
                    
                    
                    
                }else{
                    mylabel.textColor = nomarlColor
                }
                
                
            }
            
            self.subUpViewValueClours?(selecTag,self.nameArray[selecTag])
            
        }else{
            print("重复选择")
        }
        
    
        
        
    }
    
    func resetUpView(_ tag: Int){
        
        if self.upSelectInt != tag {
        
            self.upSelectInt = tag
            
            for index in 0..<self.labelArray.count {
                let mylabel = self.labelArray[index]
                
                if tag == index {
                    mylabel.textColor = selectColor
                    
                    
                    UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
                        
                        let anyWidth = self.frame.size.width / CGFloat(self.nameArray.count)
                        self.translationView.frame.origin.x = CGFloat(index) * anyWidth + anyWidth / 4
                        
                        }, completion: nil)

                }else{
                    mylabel.textColor = nomarlColor
                }
                
                
            }
     
            
            
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    
    

}
