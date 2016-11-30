//
//  BloodPromptView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/9/5.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class BloodPromptView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    //返回控制器
    fileprivate var backCtr: UIViewController?
    
    //父控制器
    fileprivate var superCtr: UIViewController?
    
    //高低
    fileprivate let heightNum: Float = 6.1
    fileprivate let lowNum: Float = 3.9
    
    
    fileprivate var bgView: UIView?
    
    fileprivate var mainView: UIView?
    
    fileprivate let mySize = UIScreen.main.bounds.size
    
    fileprivate let Wsize = UIScreen.main.bounds.size.width / 375
    
    func initBloodPromptView(_ blood: Float,superCtr: UIViewController?,backCtr: UIViewController?){
        
        self.backCtr = backCtr
        self.superCtr = superCtr
        
        self.initBgView()
  
        self.initMainView(blood)
        
   
    }
    
    
    
    func initBgView(){
        if self.bgView == nil {
            bgView = UIView(frame: CGRect(x: 0,y: 0,width: mySize.width,height: mySize.height))
            
            bgView?.backgroundColor = UIColor.black
            
            bgView?.alpha = 0.3
            
            
            UIApplication.shared.keyWindow?.addSubview(bgView!)
        }

    }
    
 
    func initMainView(_ blood: Float){
        
        
        if self.mainView == nil {
            let toLeft: CGFloat = 57 * Wsize
            let height: CGFloat = 228
            
            let mainW = mySize.width - toLeft * 2
            
            mainView = UIView(frame: CGRect(x: toLeft,y: (mySize.height - height) / 2,width: mainW,height: height))
            
            mainView?.backgroundColor = UIColor.white
            

            self.mainView?.alpha = 0
            self.mainView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
                self.mainView?.alpha = 1
                self.mainView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
 
            UIApplication.shared.keyWindow?.addSubview(mainView!)
            
            //图片
            let warnW: CGFloat = 70 * Wsize
            let warnH: CGFloat = 62 * Wsize
            
            
            
            let warningImgV = UIImageView(frame: CGRect(x: (mainW - warnW) / 2, y: 17, width: warnW, height: warnH))
            warningImgV.image = UIImage(named: "warning")
            
            mainView?.addSubview(warningImgV)
            
            
            //3.9-6.1
            
            var tmpValue = "正常"
            
            if blood <= self.lowNum {
                tmpValue = "过低"
            }else if blood >= self.heightNum{
                tmpValue = "过高"
            }
            
            let labelToLeft: CGFloat = 22.5 * Wsize
            let labelH: CGFloat = 65
            let label = UILabel(frame: CGRect(x: labelToLeft,y: (height - labelH) / 2 + 10,width: mainW - labelToLeft * 2,height: labelH))
            
            label.textAlignment = .center
            label.textColor = UIColor().rgb(68, g: 68, b: 68, alpha: 1)
            
            label.font = UIFont(name: PF_SC, size: 17)
            
            label.text = "您的血糖偏\(tmpValue)，请注意饮食按时服药"
            
            //        label.backgroundColor = UIColor.redColor()
            
            label.numberOfLines = 0
            
            mainView?.addSubview(label)
            
            
            //我知道了
            
            
            let okBtn = UIButton(frame: CGRect(x: (mainW - 143) / 2,y: height - 33 - 14,width: 143,height: 33))
            
            okBtn.setTitle("我知道了", for: UIControlState())
            
            okBtn.setTitleColor(UIColor().rgb(246, g: 93, b: 34, alpha: 1), for: UIControlState())
            
            okBtn.layer.cornerRadius = 33 / 2
            
            okBtn.layer.masksToBounds = true
            
            okBtn.layer.borderWidth = 0.5
            okBtn.layer.borderColor = UIColor().rgb(246, g: 93, b: 34, alpha: 1).cgColor
            
            
            okBtn.titleLabel?.font = UIFont(name: PF_SC, size: 17)
            
            okBtn.addTarget(self, action: #selector(BloodPromptView.okBtnAct(_:)), for: UIControlEvents.touchUpInside)
            okBtn.tag = 1
            
            
            mainView?.addSubview(okBtn)
        }

    }
    
    
    
    
    func okBtnAct(_ send: UIButton){
        print("我知道了")
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.mainView?.alpha = 1
            self.mainView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
            self.mainView?.alpha = 0
            self.mainView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (cop: Bool) in
                self.dismiss()
            
                self.popToCtr()
   
        }
     
    }
    
    
    func popToCtr(){
        if let ctr = self.backCtr{
            
            if self.superCtr != nil{
                self.superCtr!.navigationController!.popToViewController(ctr, animated: true)
            }
            
        }else{
            if self.superCtr != nil{
                self.superCtr!.navigationController!.popViewController(animated: true)
            }
                    }
    }
    
    
    func dismiss(){
        
        
        self.bgView?.removeFromSuperview()
        self.bgView = nil
        
        
        self.mainView?.removeFromSuperview()
        self.mainView = nil
      
    }
    
    
    
    
    
    

}
