//
//  SHelpHeadView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/15.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SHelpHeadView: UIView {

    typealias SHelpHeadViewViewActClourse = (_ send: UIView)->Void
    var viewActClourse:SHelpHeadViewViewActClourse?
    
    
    var one_width: CGFloat = 0
    var one_height: CGFloat = 0
    var downView_height: CGFloat = 1
    
    
    var chooseColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
    var noChooseColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
    
    
    var downView: UIView!
    var labelArray = [UILabel]()
    
    
    var items = [String]()
    
  
   
    override func draw(_ rect: CGRect) {
        
        //计算每个item的宽度
        self.one_width = rect.width / CGFloat(items.count)
        //高度
        self.one_height = rect.height
        //底部固定线条
        let GDdownView = UIView(frame: CGRect(x: 0,y: self.one_height - self.downView_height,width: rect.width,height: self.downView_height))
        GDdownView.backgroundColor = UIColor(red: 144/255.0, green: 144/255.0, blue: 144/255.0, alpha: 0.8)
        self.addSubview(GDdownView)
        //底部移动线条
        self.downView = UIView(frame: CGRect(x: 0,y: self.one_height - self.downView_height,width: self.one_width,height: self.downView_height))
        self.downView.backgroundColor = self.chooseColor
        self.addSubview(self.downView)
        
        for index in 0..<self.items.count {

            //点击大背景视图
            let itemView = UIView(frame: CGRect(x: CGFloat(index) * self.one_width ,y: 0 ,width: self.one_width ,height: self.one_height - 1))
            
            itemView.backgroundColor = UIColor.white
            
            //点击
            let tap = UITapGestureRecognizer(target: self, action: #selector(SHelpHeadView.itemsAct(_:)))
            itemView.addGestureRecognizer(tap)
            itemView.tag = index
            
            
            self.addSubview(itemView)
            
            //标题label
            
            let itemView_size = itemView.frame.size
            
            let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: itemView_size.width,height: itemView_size.height))
            titleLabel.text = self.items[index]
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            titleLabel.textAlignment = .center
            
            if index == 0 {
                titleLabel.textColor = self.chooseColor
            }else{
                titleLabel.textColor = self.noChooseColor
            }
            itemView.addSubview(titleLabel)
            
            labelArray.append(titleLabel)
            
        }

        
        
        
    }
 
    
    func itemsAct(_ send: UITapGestureRecognizer){
        
        let tag = send.view!.tag

        self.setItemColorAndFrame(tag)
        
        self.viewActClourse?(send.view!)
    }
    
    
    func setItemColorAndFrame(_ tag: Int){
        //设置底部线条位置
        
        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationDuration(0.25)
        
        self.downView.frame = CGRect(x: CGFloat(tag) * self.one_width, y: self.one_height - 1, width: self.one_width, height: 1)

        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        UIView.commitAnimations()
        
        
        //设置文字颜色
        for index in 0..<self.labelArray.count {
            
            let titleLabel = self.labelArray[index]
            
            if tag == index {
                titleLabel.textColor = self.chooseColor
            }else{
                titleLabel.textColor = self.noChooseColor
            }
            
        }
        
        
    }
    

}
