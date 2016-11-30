//
//  SFingerBloodView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/12.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SFingerBloodView: UIView ,FDCalendarDelegate{

    var StaCtr:UIViewController!
    
    
    
    
    
//    typealias SFingerBloodViewMoreClourse = (send: UIView)->Void
//    var moreClourse:SFingerBloodViewMoreClourse?
 
    
    var leftLabel: UILabel!
    var rightLabel: UILabel!
    
    
    fileprivate let topDateView_width: CGFloat = 45
    
    let Hsize = (UIScreen.main.bounds.height - 64) / (667 - 64)
    
    override func draw(_ rect: CGRect) {
        
        self.setTopDateView(rect)
        
        self.setChartsView(rect)
        
        
        
    }
    
    //----图形
    func setChartsView(_ rect: CGRect){
        //0.1背景视图
        let downView = UIView(frame: CGRect(x: 0,y: topDateView_width,width: rect.width,height: rect.height - topDateView_width))
        downView.backgroundColor = UIColor(red: 255/255.0, green: 248/255.0, blue: 246/255.0, alpha: 1)
        self.addSubview(downView)
        
        //*******
        let downView_size = downView.frame.size
        
        
        //2.0 图形视图
        self.continuChartView = ContinuouChartView(frame: CGRect(x: 0,y: 0,width: downView_size.width,height: downView_size.height))
        continuChartView.backgroundColor = UIColor.clear
        downView.addSubview(continuChartView)
 
    }
    
    var continuChartView:ContinuouChartView!
   
    
    
    
    //-----顶部
    func setTopDateView(_ rect: CGRect){
        //0.1时间选择背景视图
        let topDateView = UIView(frame: CGRect(x: 0,y: 0,width: rect.width,height: topDateView_width))
        topDateView.backgroundColor = UIColor.white
        self.addSubview(topDateView)
        
        //0.2时间选择背景视图的frame
        let top_frame_size = topDateView.frame.size
        
        let toLabel_width: CGFloat = 17
        let toLabel = UILabel(frame: CGRect(x: (top_frame_size.width - toLabel_width) / 2,y: 0,width: toLabel_width,height: top_frame_size.height))
        toLabel.text = "至"
        toLabel.textAlignment = .center
        toLabel.textColor = UIColor(red: 99/255.0, green: 99/255.0, blue: 99/255.0, alpha: 1)
        toLabel.font = UIFont.systemFont(ofSize: 17)
        
        topDateView.addSubview(toLabel)
        
        //1.1左边时间选择视图
        let left_width: CGFloat = 110
        let leftView = UIView(frame: CGRect(x: (top_frame_size.width / 2 - left_width - toLabel_width / 2),y: 0,width: left_width,height: top_frame_size.height))
        leftView.backgroundColor = UIColor.white
        
        //添加点击事件
        let tapL = UITapGestureRecognizer(target: self, action: #selector(SFingerBloodView.someViewAct(_:)))
        leftView.addGestureRecognizer(tapL)
        leftView.tag = 0
        
        topDateView.addSubview(leftView)
        
        
        //******
        let leftView_size = leftView.frame.size
        //1.2左边图标
        let frame_width: CGFloat = 8.3
        let frame_height: CGFloat = 4.2
        let imgView = UIImageView(frame: CGRect(x: leftView_size.width - frame_width, y: (leftView_size.height - frame_height) / 2, width: frame_width, height: frame_height))
        
        imgView.image = UIImage(named: "uDown")
        leftView.addSubview(imgView)
        
        //1.3左边label
        leftLabel = UILabel(frame: CGRect(x: 0,y: 0,width: leftView_size.width - frame_width,height: leftView_size.height))
        leftLabel.textAlignment = .center
        leftLabel.textColor = UIColor(red: 99/255.0, green: 99/255.0, blue: 99/255.0, alpha: 1)
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        
        //
        let (time,date,_) = StatisticalService().getCurrentDate()
        self.leftDate = date
        leftLabel.text = time

    
        
        
        
        
        leftView.addSubview(leftLabel)
        
        //2.1右边时间选择视图
        let rightView = UIView(frame: CGRect(x: (top_frame_size.width / 2) + toLabel_width / 2,y: 0,width: left_width,height: top_frame_size.height))
        rightView.backgroundColor = UIColor.white
        
        //添加点击事件
        let tapR = UITapGestureRecognizer(target: self, action: #selector(SFingerBloodView.someViewAct(_:)))
        rightView.addGestureRecognizer(tapR)
        rightView.tag = 1
        
        topDateView.addSubview(rightView)
        
        //*******
        let rightView_size = rightView.frame.size
        //2.2 右边图标
        let right_imgView = UIImageView(frame: CGRect(x: rightView_size.width - frame_width, y: (rightView_size.height - frame_height) / 2, width: frame_width, height: frame_height))
        right_imgView.image = UIImage(named: "uDown")
        
        rightView.addSubview(right_imgView)
        
        //2.3右边lable
        
        rightLabel = UILabel(frame: CGRect(x: 0,y: 0,width: rightView_size.width - frame_width,height: rightView_size.height))
        rightLabel.textAlignment = .center
        rightLabel.textColor = UIColor(red: 99/255.0, green: 99/255.0, blue: 99/255.0, alpha: 1)
        rightLabel.font = UIFont.systemFont(ofSize: 16)
        
        let (Rtime,Rdate,_) = StatisticalService().getCurrentDate()
        self.rightDate = Rdate
        rightLabel.text = Rtime

        
        rightView.addSubview(rightLabel)
    }
    
   
    
    //点击的左边日期
    var isCalenderLeft = true
    
    var leftDate:Double = 0
    var rightDate:Double = 0
    
    func someViewAct(_ send : UITapGestureRecognizer){
        
        let tag = send.view!.tag
        
        switch tag {
        case 0:
            print("点击了->左边时间")
            
            isCalenderLeft = true
            
            self.setFDCalender()
            
        case 1:
            print("点击了->右边时间")
            
            isCalenderLeft = false
            
            self.setFDCalender()
//        case 2:
//            print("点击了->查看全屏")
//            moreClourse?(send: send.view!)
        default:
            break
        }
        
        
        
    }
    
    var calenderView:FDCalendar!
    
    let S_Width = UIScreen.main.bounds.width
    let H_Height = UIScreen.main.bounds.height
    
    func setFDCalender(){
        
        self.setBgView()
        
        self.setCanlenderView()

    }
    func setCanlenderView(){
        if self.calenderView == nil {
            
            let today:Double = Date().timeIntervalSince1970
            calenderView = FDCalendar(currentDate: Date(timeIntervalSince1970: today))
            calenderView.delegate = self
            calenderView.frame.origin.y = 45 + 64
            UIApplication.shared.keyWindow?.addSubview(self.calenderView)
        }
        
    }
  
    var bgView: UIView!
    
    func setBgView(){
        
        if bgView == nil {
            bgView = UIView(frame: CGRect(x: 0,y: 0,width: S_Width,height: H_Height))
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 0.3
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(SFingerBloodView.closeCanlenderView))
            bgView.addGestureRecognizer(tap)
            
            UIApplication.shared.keyWindow?.addSubview(self.bgView)
        }
        
    }
    func closeCanlenderView(){
        if self.bgView != nil {
            self.bgView.removeFromSuperview()
            self.bgView = nil
        }
        
        if self.calenderView != nil {
            self.calenderView.removeFromSuperview()
            self.calenderView = nil
        }
    }
    
    //MARK:时间选择回调
    func setDateeee(_ date: Date!) {

        //转换为时间戳
        let aa:Double = date.timeIntervalSince1970 + (8 * 60 * 60)

        let dayTime = Date(timeIntervalSince1970: aa)
        
        //print("返回的时间->\(dayTime)")
        
        //当前时间
        let today:Double = Date().timeIntervalSince1970 + (8 * 60 * 60)
  
        if (aa > today){
            let alertView:UIAlertView = UIAlertView(title: "温馨提示", message: "选择的时间超过当前时间", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }else{
            
            if isCalenderLeft { //左边回调
                
                if aa > self.rightDate { //选择的时间大于 右边时间
                    let alertView:UIAlertView = UIAlertView(title: "温馨提示", message: "选择的时间大于结束时间", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }else{
                    
                    self.leftDate = aa
                    
                    let str = String(describing: dayTime)
                    let shijian:String = (str as NSString).substring(to: 10)
                    self.leftLabel.text = shijian
                    
                }
     
            }else{

                if aa < self.leftDate { //选择的时间少于 左边时间
                    let alertView:UIAlertView = UIAlertView(title: "温馨提示", message: "选择的时间小于起始时间", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }else{
                    self.rightDate = aa
                    
                    let str = String(describing: dayTime)

                    let shijian:String = (str as NSString).substring(to: 10)

                    self.rightLabel.text = shijian
 
                }
    
            }

            self.closeCanlenderView()
        }
  
        
    }
    
    
    
    
    
    
    
    
    

}
