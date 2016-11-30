//
//  NavTitleView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/11.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class NavTitleView: UIView {

    typealias NavTitleViewClourse = (_ send: UIButton)->Void
    var btnActClourse:NavTitleViewClourse?
    
    
    
    var names = ["血糖","事件"]
    
    override func draw(_ rect: CGRect) {
        
        self.creatNavTitleView(names)
        
    }
 
    
    var myBtnArray = [UIButton]()

    //自定义标题视图
    func creatNavTitleView(_ names: [String]){
        
        //每个的宽度，高度
        let width: CGFloat = 60
        let height: CGFloat = 30
        
        //总宽度
        let allWidth: CGFloat = width * CGFloat(names.count)
        
        let navView = UIView(frame: CGRect(x: 0,y: 0,width: allWidth,height: height))
        
        navView.layer.cornerRadius = 4
        navView.layer.masksToBounds = true
        navView.layer.borderWidth = 0.5
        navView.layer.borderColor = UIColor.white.cgColor
        
        
        
        self.addSubview(navView)
        
  
        for index in 0..<names.count {
            
            let btn = UIButton(frame: CGRect(x: CGFloat(index) * width,y: 0,width: width,height: height))
            
            if index == 0 {
                btn.backgroundColor = secColor
                btn.setTitleColor(noSecColor, for: UIControlState())
            }else{
                btn.backgroundColor = noSecColor
                btn.setTitleColor(secColor, for: UIControlState())
            }
            
            btn.setTitle(names[index], for: UIControlState())
            
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            btn.tag = index
            
            btn.addTarget(self, action: #selector(NavTitleView.btnAct(_:)), for: UIControlEvents.touchUpInside)
            
            
            navView.addSubview(btn)

            myBtnArray.append(btn)
        }
  
    }

    var secColor = UIColor.white
    var noSecColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
    
    func btnAct(_ send: UIButton){
        
        
        //print("点击了：\(names[send.tag])")
        
        
        for index in 0..<self.myBtnArray.count {
            let btn = self.myBtnArray[index]
            
            if index == send.tag {
                
                btn.backgroundColor = secColor
                btn.setTitleColor(noSecColor, for: UIControlState())

            }else{
                btn.backgroundColor = noSecColor
                
                btn.setTitleColor(secColor, for: UIControlState())
            }
   
        }
        
        self.setNavTitleView(send.tag)
  
        btnActClourse?(send)
        
    }
    
    func setNavTitleView(_ index: Int){
        
        print(index)
        
        for item in 0..<self.myBtnArray.count {
            let btn = self.myBtnArray[item]
            
            if item == index {
                
                btn.backgroundColor = secColor
                btn.setTitleColor(noSecColor, for: UIControlState())
                
            }else{
                btn.backgroundColor = noSecColor
                
                btn.setTitleColor(secColor, for: UIControlState())
            }
            
        }
        
        
        
    }
    
    
    
    
    
    
    
}
