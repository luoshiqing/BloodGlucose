//
//  RiskValueView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/28.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class RiskValueView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    weak var SLRiskCtr: UIViewController?
    
    
    var bgView: UIView!
    
    var mainView: UIView!
    
    let rWidht = UIScreen.main.bounds.size.width
    let rHeight = UIScreen.main.bounds.size.height
    
    
    
    let showViewWidth = UIScreen.main.bounds.size.width - 57 * 2
    
    
    func initRiskValueView(_ icvalue: String?,icvaluedata: String!){
        
        if bgView == nil {
            bgView = UIView(frame: CGRect(x: 0,y: 0,width: rWidht,height: rHeight))
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 0.3
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.someViewAct(_:)))
            bgView.addGestureRecognizer(tap)
            bgView.tag = 0
 
            UIApplication.shared.keyWindow?.addSubview(bgView)
        }
        
        if mainView == nil {
            
            let valueH = self.getValueShowHeight(icvaluedata)
            
            let mh = 107.5 + 79 + valueH
            
            
            mainView = UIView(frame: CGRect(x: (rWidht - showViewWidth) / 2,y: (rHeight - mh) / 2,width: showViewWidth,height: mh))
            mainView.backgroundColor = UIColor.white
            mainView.layer.cornerRadius = 3
            mainView.layer.masksToBounds = true
            
            mainView.alpha = 0
            mainView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            UIApplication.shared.keyWindow?.addSubview(mainView)
 
            
            //
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
                
                self.mainView.alpha = 1
                self.mainView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                
            }, completion: nil)
            
            
            
            
            
            let titLable = UILabel(frame: CGRect(x: 0,y: 23.5,width: showViewWidth,height: 14))
            titLable.textAlignment = .center
            titLable.textColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1)
            titLable.font = UIFont(name: PF_SC, size: 14)
            titLable.text = "您的评估结果为"
            mainView.addSubview(titLable)
            
            //val
            let valLable = UILabel(frame: CGRect(x: 0,y: 63.5,width: showViewWidth,height: 24))
            valLable.textAlignment = .center
            valLable.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            valLable.font = UIFont(name: PF_SC, size: 24)
            valLable.text = icvalue
            mainView.addSubview(valLable)
            
            //icvaluedata
            
            let icvalLable = UILabel(frame: CGRect(x: 15,y: 107.5,width: showViewWidth - 15 * 2,height: valueH))
//            icvalLable.textAlignment = .Center
            icvalLable.textColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1)
            icvalLable.font = UIFont(name: PF_SC, size: 14)
            icvalLable.text = icvaluedata
            
            icvalLable.numberOfLines = 0
            
            mainView.addSubview(icvalLable)
            
            //okbtn
            
            let okBtn = UIButton(frame: CGRect(x: (showViewWidth - 143) / 2,y: mh - 33 - 14.5,width: 143,height: 33))
            okBtn.setTitle("我知道了", for: UIControlState())
            okBtn.titleLabel?.font = UIFont(name: PF_SC, size: 18)
            
            okBtn.setTitleColor(UIColor(red: 247/255.0, green: 117/255.0, blue: 90/255.0, alpha: 1), for: UIControlState())
            
            okBtn.layer.cornerRadius = 33 / 2
            okBtn.layer.masksToBounds = true
            okBtn.layer.borderWidth = 0.5
            okBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
            
            okBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            okBtn.tag = 1
            mainView.addSubview(okBtn)
            
        }
        
        
        
        
    }
    
    
    func getValueShowHeight(_ value: String)->CGFloat{
        let string:NSString = value as NSString
        
        let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
        
        let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
        
        let brect = string.boundingRect(with: CGSize(width: showViewWidth - 15 * 2, height: 0), options: [options,a], attributes:  [NSFontAttributeName:UIFont(name: PF_SC, size: 14)!], context: nil)
        
        print(brect.height)
        
        return brect.height
    }
    
    
    
    func someViewAct(_ send: UITapGestureRecognizer){
        print("哈哈哈")
        
    }
    
    
    func someBtnAct(_ send: UIButton){
        print("我知道了")
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
            self.mainView.alpha = 0
            self.mainView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (cop: Bool) in
                self.dismiss()
                self.SLRiskCtr!.navigationController!.popViewController(animated: true)
        }
        
        
        
        
    }
    
    
    
    func dismiss(){
        
        if self.bgView != nil {
            self.bgView.removeFromSuperview()
            self.bgView = nil
        }
        
        if self.mainView != nil {
            self.mainView.removeFromSuperview()
            self.mainView = nil
        }
        
        
        
    }
    
    
    
    
    

}
