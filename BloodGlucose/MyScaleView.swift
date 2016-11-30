//
//  MyScaleView.swift
//  ccc
//
//  Created by sqluo on 16/7/25.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class MyScaleView: UIView ,UIScrollViewDelegate{

    typealias ScaleViewrealtimeValue = (_ value: String)->Void
    
    var realtimeValue:ScaleViewrealtimeValue?
    
    
    
    fileprivate var scrView: UIScrollView!

    fileprivate var rulerBgView: UIView!
    
    fileprivate var showLabel: UILabel!
    
    
    //每小段的间距
    var one_width = 12
    
    
    //长刻度
    var longScale: CGFloat = 20
    var shortScale: CGFloat = 10
    
    
    
    override func draw(_ rect: CGRect) {
       
        
        
        self.setScale(rect)
        
        
        
        
        
        
    }
 
    
    func setScale(_ rect: CGRect){
        
        //max
        let numberLength:Int = 40
        
        let totalCount:Int = numberLength * 10
        
        
        rulerBgView = UIView(frame: CGRect(x: 0,y: 10 * 2 + 20,width: rect.width,height: rect.height - 40))
        rulerBgView.backgroundColor = UIColor.white
        
        
        self.addSubview(rulerBgView)
        
        scrView = UIScrollView()
        scrView.frame = rulerBgView.bounds
        scrView.showsHorizontalScrollIndicator = false
        scrView.showsVerticalScrollIndicator = false
        scrView.bounces = false
        
        scrView.backgroundColor = UIColor.groupTableViewBackground
        
        scrView.layer.cornerRadius = 4
        scrView.layer.masksToBounds = true
        
        scrView.delegate = self
        
        self.rulerBgView.addSubview(scrView)
        
        
        let bgViewMask = UIView()
        bgViewMask.frame = self.rulerBgView.bounds
        bgViewMask.layer.cornerRadius = 4
        bgViewMask.layer.masksToBounds = true
        bgViewMask.isUserInteractionEnabled = false
        
        
        self.rulerBgView.addSubview(bgViewMask)
        
        
        
        //点
        
        let markPrePadding = Int(bgViewMask.frame.size.width - 1) / 2
        
        let bgViewMaskPointer = UIView(frame: CGRect(x: CGFloat(markPrePadding),y: 0,width: 1,height: bgViewMask.frame.size.height))
        
        bgViewMaskPointer.backgroundColor = UIColor.red
        
        bgViewMask.addSubview(bgViewMaskPointer)
        
        
        
        scrView.contentSize = CGSize(width: CGFloat(totalCount * one_width) + CGFloat(markPrePadding), height: scrView.frame.size.height)
        
        var height: CGFloat = 10
        
        for index in 0...totalCount {
            
            //刻度线
            
            if index == 0 || index % 10 == 0 {
                height = longScale
            }else{
                height = shortScale
            }
            
            let frames = CGRect(x: CGFloat(index * one_width) + CGFloat(markPrePadding), y: 0, width: 1, height: height)
            
            
            let markLine = UIView(frame: frames)
            markLine.backgroundColor = UIColor.gray
            
            scrView.addSubview(markLine)
            
            
            if index == 0 || index % 10 == 0 {
                
                
                let numLabel = UILabel(frame: CGRect(x: 0,y: scrView.frame.size.height - 14 - 2,width: 25,height: 14))
                
                numLabel.center.x = markLine.center.x
                
                
                numLabel.text = "\(index / 10)"
                
                numLabel.textColor = UIColor.gray
                
                numLabel.font = UIFont(name: "Helvetica-Bold", size: 14)
                numLabel.textAlignment = .center
                
                scrView.addSubview(numLabel)
                
            }
            
            
            
            
            
        }
        
        //填充前部
        for index in 0...markPrePadding / one_width {
            
            
            
            
            if index == 0 || index % 10 == 0 {
                height = longScale
            }else{
                height = shortScale
            }
            let frames = CGRect(x: CGFloat(markPrePadding - index * one_width), y: 0, width: 1, height: height)
            
            
            let markLine = UIView(frame: frames)
            markLine.backgroundColor = UIColor.gray
            scrView.addSubview(markLine)
            
            
            
            
        }
        
        
        
        showLabel = UILabel(frame: CGRect(x: (rect.width - 120) / 2,y: 10,width: 120,height: 20))
        showLabel.textAlignment = .center
        showLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        showLabel.font = UIFont.systemFont(ofSize: 16)
        
        showLabel.text = "0.0 mmol/L"
        
        self.addSubview(showLabel)
        
        
        //设置值
//        self.calculateAndUpdateOffset(15.8)
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset_x = Int(scrView.contentOffset.x)
        
        let _ = self.calculateAndUpdateNum(offset_x)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset:Int = Int(scrollView.contentOffset.x)
        if offset < one_width{
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }else{
            if offset % one_width != 0{
                scrollView.setContentOffset(CGPoint( x: CGFloat(offset + (one_width - (offset % one_width))), y: 0), animated: true)
            }
        }
        
        let _ = self.calculateAndUpdateNum(Int(scrollView.contentOffset.x))
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset:Int = Int(scrollView.contentOffset.x)
        if offset < one_width{
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }else{
            if offset % one_width != 0{
                scrollView.setContentOffset(CGPoint( x: CGFloat(offset + (one_width - (offset % one_width))), y: 0), animated: true)
                
            }
        }
        
        let _ = self.calculateAndUpdateNum(Int(scrollView.contentOffset.x))
        
    }
    
 
    
    //初始化当前血糖值
    var currentFingerBlood:Float = 0.0
    
    func calculateAndUpdateNum(_ x:Int) -> Float{
        let count:Int = x / one_width
        
        DispatchQueue.main.async(execute: { () -> Void in
            if self.showLabel != nil{
                self.showLabel.text = "\(Int(count / 10)).\( count % 10 ) mmol/L"
            }
            
        })
        currentFingerBlood = Float(count / 10) + (Float(count % 10)/10)
        
        
        let bloodNumberRounded = NSString(format: "%.1f", currentFingerBlood)
        //实时回调
        self.realtimeValue?(bloodNumberRounded as String)
        
        return Float(bloodNumberRounded.doubleValue)
    }
    
    
    
    
    
    
    func calculateAndUpdateOffset(_ fingerBlood:Float ,animated: Bool){
        
        self.realtimeValue?(String(fingerBlood))
 
        for i in 0...1000{
            
            if calculateAndUpdateNum(i) == fingerBlood{
                DispatchQueue.main.async(execute: { () -> Void in
                    if self.scrView != nil{
                        self.scrView.setContentOffset(CGPoint(x: CGFloat(i), y: 0), animated: animated)
                    }
  
                })
                break
            }
        }
        
    }

    
    
    
    

}
