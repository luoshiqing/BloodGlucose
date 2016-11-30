//
//  TimeChooseView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/26.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class TimeChooseView: UIView{

    typealias TimeChooseViewValueClourse = (_ tag: Int,_ secInt: Int?,_ value: String?)->Void
    
    var valueClourse:TimeChooseViewValueClourse?

    
    
    fileprivate var bgView: UIView!
    
    fileprivate var stagePickeView:StagePickerView!
    
    fileprivate let titleH: CGFloat = 40
    

    func dismiss(){
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
            self.stagePickeView.alpha = 0
            self.stagePickeView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (cop: Bool) in
            if self.bgView != nil {
                self.bgView.removeFromSuperview()
                self.bgView = nil
            }
            if self.stagePickeView != nil {
                self.stagePickeView.removeFromSuperview()
                self.stagePickeView = nil
            }
        }
   
    }
    
    
    func initTimeChooseView(_ title: String ,dataArray: NSMutableArray ,secIndex: Int){
        

        print(dataArray)
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        if bgView == nil {
            bgView = UIView(frame: CGRect(x: 0,y: 0,width: width,height: height))
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 0.3
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(TimeChooseView.someViewAct(_:)))
            bgView.addGestureRecognizer(tap)
            bgView.tag = 3
            
            UIApplication.shared.keyWindow?.addSubview(bgView)
   
        }
        
        
        
        
        if stagePickeView == nil {
            

            let mainWidth = width - 33 * 2

            let Hsize = (height - 40) / (667 - 40)
            
            let mainHeight = 286 * Hsize
            
            stagePickeView = Bundle.main.loadNibNamed("StagePickerView", owner: nil, options: nil)?.last as! StagePickerView
            stagePickeView.frame = CGRect(x: 33,y: (height - 286 * Hsize) / 2,width: mainWidth,height: mainHeight)
            

            stagePickeView.backgroundColor = UIColor.white
            
            stagePickeView.layer.cornerRadius = 3
            stagePickeView.layer.masksToBounds = true
            
            
            //传值
            stagePickeView.titStr = title //标题
            
            stagePickeView.dataArray = dataArray //数据源
            
            stagePickeView.pickerDefaultIndex = secIndex //默认选择的第几个
            
            stagePickeView.dateClosure = self.dateClosure //回调方法
  
            
            stagePickeView.alpha = 0
            stagePickeView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
            
            UIApplication.shared.keyWindow?.addSubview(stagePickeView)
     
            
            
            //动画
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.stagePickeView.alpha = 1
                self.stagePickeView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            
            
            
            
            
        }
        
     
        
    }
    
    
    
    
    //回调
    func dateClosure(_ tag:Int,secInt:Int,value:String)->Void{
        print(tag,secInt,value)
        
        self.valueClourse?(tag,secInt,value)
    
    }
    
    func someViewAct(_ send: UITapGestureRecognizer){
        self.valueClourse?(send.view!.tag,nil,nil)
    }
    
    

}
