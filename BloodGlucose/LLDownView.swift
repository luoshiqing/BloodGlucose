//
//  LLDownView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/29.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class LLDownView: UIView {

    typealias LLDownViewClourse = (_ send: UIView)->Void
    var llDownClourse:LLDownViewClourse?
    
    @IBOutlet weak var zanView: UIView!
    
    @IBOutlet weak var zanBtn: UIButton!
    
    @IBOutlet weak var zanLabel: UILabel!
    
  
    
    @IBOutlet weak var pinglunView: UIView!
    @IBOutlet weak var pinglunBtn: UIButton!
    
    @IBOutlet weak var saveView: UIView!
    
    @IBOutlet weak var saveLabel: UILabel!
 
   
    @IBOutlet weak var leftW: NSLayoutConstraint!//106
    @IBOutlet weak var midW: NSLayoutConstraint!
    @IBOutlet weak var rightW: NSLayoutConstraint!
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }

 
    
    fileprivate var someViewArray = [UIView]()
    
    
    override func draw(_ rect: CGRect) {
        
        
        
        someViewArray.append(zanView)
        someViewArray.append(pinglunView)
        someViewArray.append(saveView)
        
        self.zanBtn.isUserInteractionEnabled = false
        self.pinglunBtn.isUserInteractionEnabled = false
        
        self.setLayOut()
        
        self.setSomeView()
        
   
        
    }
 
    func setLayOut(){
        let Wsize = UIScreen.main.bounds.width / 320
        
        leftW.constant = 106 * Wsize
        midW.constant = 106 * Wsize
        rightW.constant = 106 * Wsize
    }
    func setSomeView(){
        
        for index in 0..<self.someViewArray.count {
            let view = self.someViewArray[index]
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.someViewAct(_:)))
            view.addGestureRecognizer(tap)
            view.tag = index
            
        }
 
    }
    
    
    func someViewAct(_ send: UITapGestureRecognizer){
        
        llDownClourse?(send.view!)
        
    }
    
    func setLLDownView(_ dic: [String:Any]){

        
        let isgood = dic["isgood"] as! Int
        let good = dic["good"] as! Int
        let status = dic["status"] as! Int
        
        if isgood == 0 { //点过赞了
            self.zanBtn.setImage(UIImage(named: "foodSecX"), for: UIControlState())
            self.zanView.isUserInteractionEnabled = false
        }else{
            self.zanView.isUserInteractionEnabled = true
            self.zanBtn.setImage(UIImage(named: "foodNotX"), for: UIControlState())
        }
        
        self.zanLabel.text = "\(good)"
        
        var tmpTitle = ""
        switch status {
        case 0,1:
            tmpTitle = "提交任务"
        case 2:
            tmpTitle = "已完成"
        case 3:
            tmpTitle = "添加任务"
        default:
            break
        }
        self.saveLabel.text = tmpTitle
   
    }
    

    
    func setGoodView(_ good: Int){

        self.zanBtn.setImage(UIImage(named: "foodSecX"), for: UIControlState())
        self.zanView.isUserInteractionEnabled = false
        
        self.zanLabel.text = "\(good)"
  
    }
    
    
    
    
    
    
    
    
    

}
