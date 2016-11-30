//
//  SegmentView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/28.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SegmentView: UIView {

    
    var testClosure:sendValueClosure?
    

    
    //创建的按钮个数数组
    var btnName:NSArray!
    //创建的按钮数组
    var myBtnArray = NSMutableArray()
    
    
    override func draw(_ rect: CGRect) {
        

        //加载按钮
        self.loadBtn()
        //加载底部分割线
        self.loadDownView()
    }
    
    var xiantiaoH:CGFloat = 1.5
    
    func loadBtn(){
        
        //按钮的 宽度
        let btnWidth = self.frame.size.width / CGFloat(self.btnName.count)
        //按钮的高度
        let btnHight = self.frame.size.height - 1.5
        
        for item in 0...self.btnName.count - 1 {
            
            let btn = UIButton(frame: CGRect(x: CGFloat(item) * btnWidth,y: 0,width: btnWidth,height: btnHight))
            
            let name = self.btnName[item] as! String
            btn.setTitle(name, for: UIControlState())
            if item == 0 {
                btn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1) , for: UIControlState())
            }else{
                btn.setTitleColor(UIColor(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1) , for: UIControlState())
            }
            //设置字体大小
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)

            btn.addTarget(self, action: #selector(SegmentView.btnAct(_:)), for: UIControlEvents.touchUpInside)
            btn.tag = item
            

            self.myBtnArray.add(btn)
            
            self.addSubview(btn)

        }
   
    }
    var subView:UIView!
    
    func loadDownView(){
        
        let superView = UIView(frame: CGRect(x: 0,y: self.frame.size.height - self.xiantiaoH,width: self.frame.size.width,height: self.xiantiaoH))
        superView.backgroundColor = UIColor(red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1)
        self.addSubview(superView)
        
        let wsize = self.frame.size.width / CGFloat(self.btnName.count)
        
        self.subView = UIView(frame: CGRect( x: (wsize - wsize / 2) / 2,y: 0,width: wsize / 2,height: self.xiantiaoH))
        self.subView.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        superView.addSubview(self.subView)
        
    }
    
    var selectBtn = 0
    
    func btnAct(_ send:UIButton){
        
        
        let count = send.tag
        
        if count != self.selectBtn {
            
            //重新赋值
            self.selectBtn = count
            
            let wsize = self.frame.size.width / CGFloat(self.btnName.count)
            
            self.subView.frame = CGRect( x: wsize * CGFloat(count) + wsize / 4,y: 0,width: wsize / 2,height: self.xiantiaoH)
            
            
            for item in self.myBtnArray {
                let btn = item as! UIButton
                
                if btn.tag == count {
                    btn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), for: UIControlState())
                }else{
                    btn.setTitleColor(UIColor(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1) , for: UIControlState())
                }
                
            }
            //回调传值
            if testClosure != nil {
                testClosure!(count)
            }
        }else{
            print("一样的")
        }
        
        
//        let value = self.btnName[count] as! String
        
//        print(value,count)
        
        
        
    }
    

}
