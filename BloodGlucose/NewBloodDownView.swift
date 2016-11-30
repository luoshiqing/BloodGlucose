//
//  NewBloodDownView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/17.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class NewBloodDownView: UIView {

    let Wsize = (UIScreen.main.bounds.size.width - 20) / (375 - 20)
    
    let titleArray = [["日期"],
                      ["凌晨"],
                      ["早餐","前","后"],
                      ["午餐","前","后"],
                      ["晚餐","前","后"],
                      ["睡前"],
                      ["随机"]]
    
    var oneW: CGFloat = 44
    
    let toLeftW: CGFloat = 10
    
    
    
    override func draw(_ rect: CGRect) {
        
        self.oneW = self.oneW * Wsize
        
        //计算 中间三个 宽度
        let midW = (UIScreen.main.bounds.size.width - 20 - oneW * 4) / 3
        
        
        for index in 0..<self.titleArray.count {
            
            switch index {
            case 0,1,5,6:
                let tit = self.titleArray[index][0]
                
                var x: CGFloat = 0
                if index < 2 {
                    x = CGFloat(index) * oneW + toLeftW
                }else{
                    x = midW * 3 + oneW * 2 + CGFloat(index - 5) * oneW + toLeftW
                }
                
                let borderV = BorderView(frame: CGRect(x: x,y: 0,width: oneW,height: 49))
                
                var isShowRight = false
                if index == self.titleArray.count - 1 {
                    isShowRight = true
                }
                
                borderV.initBordeView(true, showRight: isShowRight, showDown: true, showLeft: true, title: tit)
                
                borderV.backgroundColor = UIColor.white
                
                self.addSubview(borderV)
                
            default:
                
                let topTit = self.titleArray[index][0]
                let leftTit = self.titleArray[index][1]
                let rightTit = self.titleArray[index][2]
                
                
                let x = self.oneW * 2 + CGFloat(index - 2) * midW + toLeftW
                let bgView = UIView(frame: CGRect(x: x,y: 0,width: midW,height: 49))
                bgView.backgroundColor = UIColor.white
                self.addSubview(bgView)
                
                
                let bgSize = bgView.frame.size
                
                let topBorderV = BorderView(frame: CGRect(x: 0,y: 0,width: bgSize.width,height: bgSize.height / 2))
                
                print("index:\(index)")
                
                topBorderV.initBordeView(true, showRight: false, showDown: true, showLeft: true, title: topTit)
                topBorderV.backgroundColor = UIColor.white
                bgView.addSubview(topBorderV)
                
                
                
                
                let leftBorderV = BorderView(frame: CGRect(x: 0,y: bgSize.height / 2.0,width: bgSize.width / 2.0,height: bgSize.height / 2.0))
                
                leftBorderV.initBordeView(false, showRight: false, showDown: true, showLeft: true, title: leftTit)
                leftBorderV.backgroundColor = UIColor.white
                bgView.addSubview(leftBorderV)
                
                let rightBorderV = BorderView(frame: CGRect(x: bgSize.width / 2.0,y: bgSize.height / 2.0,width: bgSize.width / 2.0,height: bgSize.height / 2.0))
                
                rightBorderV.initBordeView(false, showRight: false, showDown: true, showLeft: true, title: rightTit)
                rightBorderV.backgroundColor = UIColor.white
                bgView.addSubview(rightBorderV)
                
            }
            
            
            
            
            
            
            
            
        }
        
        
        
    }
    var myHeight: CGFloat = 30
    
    fileprivate var borderArray = [BorderView]()
    
    func loadValueView(_ valueArray: [[String]]){

        self.dismissBorderView()
        
        let midW = (UIScreen.main.bounds.size.width - 20 - oneW * 4) / 6
        
        for index in 0..<valueArray.count { //行数
            
            
            let tmpArray = valueArray[index]

            let y = CGFloat(index) * myHeight + 49
            
            for item in 0..<tmpArray.count { //每行的东西
                
                //值
                let value = tmpArray[item]
                
                switch item {
                case 0,1,8,9:
                    var x: CGFloat = 0
                    
                    if item < 2 {
                        x = CGFloat(item) * oneW + toLeftW
                    }else{
                        x = midW * 6 + oneW * 2 + CGFloat(item - 8) * oneW + toLeftW
                    }
                    
                    let borderView = BorderView(frame: CGRect(x: x,y: y,width: oneW,height: myHeight))
                    
                    var isShowRight = false
                    if item == tmpArray.count - 1 {
                        isShowRight = true
                    }
                    
                    borderView.initBordeView(false, showRight: isShowRight, showDown: true, showLeft: true, title: value)
                    
                    borderView.backgroundColor = UIColor.white
                    
                    self.addSubview(borderView)

                    self.borderArray.append(borderView)
                default:
                    let x = self.oneW * 2 + CGFloat(item - 2) * midW + toLeftW
                    
                    let borderView = BorderView(frame: CGRect(x: x,y: y,width: midW,height: myHeight))
                    
                    borderView.initBordeView(false, showRight: false, showDown: true, showLeft: true, title: value)
                    borderView.backgroundColor = UIColor.white
                    self.addSubview(borderView)
                    
                    self.borderArray.append(borderView)
                }
     
                
            }
            
     
        }
    
        
    }
    
    func dismissBorderView(){
        
        for item in self.borderArray {
            item .removeFromSuperview()
        }
        
        self.borderArray.removeAll()
        
    }
    
    
    
 

}
