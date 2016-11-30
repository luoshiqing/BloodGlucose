//
//  CustomFoodView.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/25.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class CustomFoodView: UIView {


    fileprivate var selectMax = 3 //选择的最大个数
    
    var drugRecMainView:        DrugRecMainView?
    
    fileprivate var myFrame:    CGRect!
    
    fileprivate let topViewH:   CGFloat  = 110 * MYHSIZE
    fileprivate var downViewH:  CGFloat  = 49
    
    fileprivate var idString = ""  //记录选择的id串
    
    fileprivate var superCtr: UIViewController?
    
    fileprivate var isShowDownView = true
    
    init(frame: CGRect,selectMax: Int ,target: UIViewController ,isShowDownView: Bool) {
        super.init(frame: frame)
        
        self.selectMax = selectMax
        self.myFrame = frame

        self.superCtr = target
        
        self.isShowDownView = isShowDownView
        
        if !isShowDownView {
            self.downViewH = 0
        }
        
        self.loadTopAndDownView()
        
        self.loadDrugRecMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func loadTopAndDownView(){
        
        let color = UIColor().rgb(239, g: 239, b: 244, alpha: 1)
        
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: Screen_Width, height: self.topViewH))
        topView.backgroundColor = color
        self.addSubview(topView)
        
        let toLeftW: CGFloat = 18 * MYWSIZE //左右边距
        //1.左边
        let leftH: CGFloat = 59 * MYHSIZE
        let leftW: CGFloat = 79 * MYWSIZE
        let leftY = (self.topViewH - leftH) / 2
        let leftImgView = UIImageView(frame: CGRect(x: toLeftW, y: leftY, width: leftW, height: leftH))
        leftImgView.image = UIImage(named: "shucai1.png")
        topView.addSubview(leftImgView)
        //2.右边
        let rightX = Screen_Width - toLeftW - leftW
        let rightImgView = UIImageView(frame: CGRect(x: rightX, y: leftY, width: leftW, height: leftH))
        rightImgView.image = UIImage(named: "shucai2.png")
        topView.addSubview(rightImgView)
        //3.中间
        let middleW: CGFloat = 90 * MYHSIZE
        let middleX = (Screen_Width - middleW) / 2
        let middleY = (self.topViewH - middleW) / 2
        let middleImgView = UIImageView(frame: CGRect(x: middleX, y: middleY, width: middleW, height: middleW))
        middleImgView.image = UIImage(named: "canying-logo.png")
        topView.addSubview(middleImgView)
        
        if self.isShowDownView {
            //4.底部视图
            let downY: CGFloat = Screen_Height - 64 - self.downViewH
            let downView = UIView(frame: CGRect(x: 0, y: downY, width: Screen_Width, height: self.downViewH))
            downView.backgroundColor = color
            self.addSubview(downView)
            
            let btnToLeftW: CGFloat = 18
            let btnW = Screen_Width / 2 - btnToLeftW * 2
            let btnToTopH: CGFloat = 3
            let btnH = self.downViewH - btnToTopH * 2
            
            let leftBtn = UIButton(frame: CGRect(x: btnToLeftW, y: btnToTopH, width: btnW, height: btnH))
            leftBtn.setTitle("重新选择", for: UIControlState())
            
            leftBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor.white), for: UIControlState())
            leftBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor().rgb(246, g: 93, b: 34, alpha: 1)), for: .highlighted)
            
            leftBtn.setTitleColor(UIColor.black, for: UIControlState())
            leftBtn.setTitleColor(UIColor.white, for: .highlighted)
            
            leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            leftBtn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
            leftBtn.tag = 0
            
            leftBtn.layer.cornerRadius = btnH / 2
            leftBtn.layer.masksToBounds = true
            
            downView.addSubview(leftBtn)
            
            let rightBtnX = Screen_Width - btnW - btnToLeftW
            let rightBtn = UIButton(frame: CGRect(x: rightBtnX, y: btnToTopH, width: btnW, height: btnH))
            
            rightBtn.setTitle("准备好了", for: UIControlState())
            
            rightBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor().rgb(246, g: 93, b: 34, alpha: 1)), for: UIControlState())
            rightBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor.white), for: .highlighted)
            
            rightBtn.setTitleColor(UIColor.white, for: UIControlState())
            rightBtn.setTitleColor(UIColor().rgb(246, g: 93, b: 34, alpha: 1), for: .highlighted)
            
            rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            rightBtn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
            rightBtn.tag = 1
            
            rightBtn.layer.cornerRadius = btnH / 2
            rightBtn.layer.masksToBounds = true
            
            downView.addSubview(rightBtn)
        }
        
        
    }
    
    
    
    fileprivate func loadDrugRecMainView(){
        
        let rect = CGRect(x: 0, y: self.topViewH, width: myFrame.width, height: myFrame.height - 64 - self.topViewH - self.downViewH)
        self.drugRecMainView = DrugRecMainView(frame: rect, secIndexMax: self.selectMax, line: 3, column: 3, spacing: 5.0,target: self.superCtr)
  
        self.drugRecMainView?.backgroundColor = UIColor.white
 
        self.drugRecMainView?.drugSecClourse = self.DrugRecMainViewSecClourse
        
        self.drugRecMainView?.setColloctionView(line: 3, column: 3, spacing: 5.0)
        
        self.addSubview(self.drugRecMainView!)
        
    }
    //MARK:选择id回调
    func DrugRecMainViewSecClourse(_ idStr: String)->Void {
        
        print(idStr)
        
        self.idString = idStr
   
    }
    
    func someBtnAct(send: UIButton){
        switch send.tag {
        case 0:
            print("重新选择")
            self.idString = ""
            
            self.drugRecMainView?.restSecValue()
            
        case 1:
            //准备好了
            print("self.idString->\(self.idString)")
            if self.idString.isEmpty {
                
                let alert = UIAlertView(title: "温馨提示", message: "您还没选择食谱，请选择食谱", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                
            }else{
                
                CustomNetwork().submitTheRecipes(self, ids: self.idString, clourse: { (isSuccess, message) in
                    
                    if isSuccess {
                        BGNetwork().delay(0.35, closure: { 
                            //清单
                            let tasklVC = TaskViewController(nibName: "TaskViewController", bundle: Bundle.main)
                            self.superCtr?.navigationController?.pushViewController(tasklVC, animated: true)
                        })

                    }else{
                        
                        if let msg = message {
                            let alert = UIAlertView(title: "提交失败", message: msg, delegate: nil, cancelButtonTitle: "确定")
                            alert.show()
                        }
                    }
 
                })
            }
            
            
        default:
            break
        }
  
    }
    
    
    
    
    

}
