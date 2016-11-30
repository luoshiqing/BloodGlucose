//
//  SFormView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/12.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SFormView: UIView {

    let Wsize: CGFloat = (UIScreen.main.bounds.width - 40) / (375 - 40)
    
    var namesArray = [["日期"],["凌晨"],["早餐","前","后"],["午餐","前","后"],["晚餐","前","后"],["睡前"],["随机"]]
    
    
    //模拟数据
    var moniArray = [AnyObject]()
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1).cgColor
        

        //每个的高度
        let one_height: CGFloat = 50


        
        //中间三个每个的宽度
        let mid_width: CGFloat = 170 * Wsize / 3
        
        //左右两边的宽度
        let some_width: CGFloat = (rect.width - mid_width * 3) / 4
        
        
        //第二行的高度
        let two_height: CGFloat = 40
        
        
        for i in 0...self.moniArray.count {
            
            if i == 0 {
                for index in 0...6 {
                    
                    
                    switch index { //左边
                    case 0,1:
                        
                        
                        let names = namesArray[index]
                        
                        
                        let sOneView = SOneView(frame: CGRect(x: CGFloat(index) * some_width,y: 0,width: some_width,height: one_height))
                        sOneView.backgroundColor = UIColor.white
                        
                        sOneView.names = names
                        
                        self.addSubview(sOneView)
                    case 2...4:
                        
                        
                        let names = namesArray[index]
                        
                        let sTowView = STowView(frame: CGRect(x: CGFloat(2) * some_width + CGFloat(index - 2) * mid_width,y: 0,width: mid_width,height: one_height))
                        sTowView.backgroundColor = UIColor.white
                        
                        sTowView.names = names
                        
                        self.addSubview(sTowView)
                        
                        
                    case 5,6:
                        let names = namesArray[index]
                        
                        let sOneView = SOneView(frame: CGRect(x: CGFloat(index - 3) * some_width + CGFloat(3) * mid_width,y: 0,width: some_width,height: one_height))
                        sOneView.backgroundColor = UIColor.white
                        
                        sOneView.names = names
                        
                        self.addSubview(sOneView)
                    default:
                        break
                        
                    }
                    
                }
                
            }else{
                
                let abc = self.moniArray[i - 1] as! [[String]]
                
//                print("再弄一行")
                
                for index in 0...6 {
                    
                    let names = abc[index]
                
                    switch index { //左边
                    case 0,1:
                        

                        let sOneView = SOneView(frame: CGRect(x: CGFloat(index) * some_width,y: one_height + CGFloat(i - 1) * two_height,width: some_width,height: two_height))
                        sOneView.backgroundColor = UIColor.white
                        
                        sOneView.names = names
                        
                        self.addSubview(sOneView)
                    case 2...4:

                        let sOneView = SThreeView(frame: CGRect(x: CGFloat(2) * some_width + CGFloat(index - 2) * mid_width,y: one_height + CGFloat(i - 1) * two_height,width: mid_width,height: two_height))
                        sOneView.backgroundColor = UIColor.white
                        
                        sOneView.names = names
                        
                        self.addSubview(sOneView)
                        
                        
                        
                    case 5,6:
//                        let names = namesArray[index]
                        
                        let sOneView = SOneView(frame: CGRect(x: CGFloat(index - 3) * some_width + CGFloat(3) * mid_width,y: one_height + CGFloat(i - 1) * two_height,width: some_width,height: two_height))
                        sOneView.backgroundColor = UIColor.white
                        
                        sOneView.names = names
                        
                        self.addSubview(sOneView)
                    default:
                        break
                        
                    }
                    
                }
                
                
                
                
                
            }
            
            
        }
        
    
        
    }
 

}
