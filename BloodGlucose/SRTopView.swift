//
//  SRTopView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/14.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SRTopView: UIView {

    typealias SRTopViewBtnActClourse = (_ send: UIButton)->Void
    
    var btnActClourse:SRTopViewBtnActClourse?
    
    
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    @IBOutlet weak var timeBtn: UIButton!
    
    @IBOutlet weak var intakeView: UIView!
    
    @IBOutlet weak var consumptionView: UIView!
    
  
    //时间
    var altTime:Double!
    
    
    var intakeEnergyFigureView:EnergyFigureView! //摄入的视图
    var consumptionEnergyView:EnergyFigureView! //消耗的视图
    
    var intakeLab:UILabel! //摄入的数量
    var consumptionLab:UILabel! //消耗的数量
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        
        
        self.loadIntakeView()
        self.loadConsumptionView()
        
        
        self.setTimeInBtn()
        
        //设置按钮点击事件
        leftBtn.addTarget(self, action: #selector(SRTopView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        
        rightBtn.addTarget(self, action: #selector(SRTopView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        rightBtn.tag = 1
        
        timeBtn.addTarget(self, action: #selector(SRTopView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        timeBtn.tag = 2
        
    }
    
    func someBtnAct(_ send: UIButton){
        
//        let tag = send.tag
//        
//        switch tag {
//        case 0:
//            print("左边")
//        case 1:
//            print("右边")
//        case 2:
//            print("中间时间")
//        default:
//            break
//        }
        
        btnActClourse?(send)
        
        
    }
    
    
    
    
    func setTimeInBtn(){
        //获取当前时间
        let today:Double = Date().timeIntervalSince1970
        
        //当前时间戳
        let newTiem:Double = today + 8 * 60 * 60
 
        let dayTime = Date(timeIntervalSince1970: newTiem)
        let str = String(describing: dayTime)
        let stri:String = (str as NSString).substring(to: 10)

        self.timeBtn.setTitle(stri, for: UIControlState())
        
//        let texx = self.timeBtn.titleLabel?.text!

    }
    
    
    
    func loadIntakeView(){
        
        intakeEnergyFigureView = EnergyFigureView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        intakeEnergyFigureView.backgroundColor = UIColor.white
        
        let at = CGAffineTransform(rotationAngle: -CGFloat(M_PI / 2))
        intakeEnergyFigureView.transform = at
        
        intakeLab = UILabel(frame: CGRect(x: (100 - 80) / 2,y: (100 - 18) / 2 ,width: 80,height: 18))
        intakeLab.font = UIFont.systemFont(ofSize: 11)
        intakeLab.textAlignment = .center
        intakeLab.textColor = UIColor(red: 255/255.0, green: 77/255.0, blue: 9/255.0, alpha: 1)
        intakeLab.text = "0kcal"
        
        self.intakeView.addSubview(intakeEnergyFigureView)
        self.intakeView.addSubview(intakeLab)
    }
    
    func loadConsumptionView(){
        
        consumptionEnergyView = EnergyFigureView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        consumptionEnergyView.backgroundColor = UIColor.white
        
        let at = CGAffineTransform(rotationAngle: -CGFloat(M_PI / 2))
        consumptionEnergyView.transform = at
        
        consumptionLab = UILabel(frame: CGRect(x: (100 - 80) / 2,y: (100 - 18) / 2 ,width: 80,height: 18))
        consumptionLab.font = UIFont.systemFont(ofSize: 11)
        consumptionLab.textAlignment = .center
        consumptionLab.textColor = UIColor(red: 255/255.0, green: 77/255.0, blue: 9/255.0, alpha: 1)
        consumptionLab.text = "0kcal"
        
        self.consumptionView.addSubview(consumptionEnergyView)
        self.consumptionView.addSubview(consumptionLab)

        
    }
    
    func setIntakeEnergyView(isIntakeView :Bool,max: Float,value: Float){
        
        if isIntakeView {
            var tmpValue:Float = 0.0
            
            if value >= 11000.0 {
                tmpValue = 11000.0
                
                intakeLab.text = ">11000kcal"
            }else{
                tmpValue = value
                
                intakeLab.text = "\(value)kcal"
            }
            
            intakeEnergyFigureView.setSomeData(max, value: tmpValue)
        }else{
            
            var tmpValue:Float = 0.0
            
            if value >= 8000.0 {
                tmpValue = 8000.0
                
                consumptionLab.text = ">8000kcal"
            }else{
                tmpValue = value
                
                consumptionLab.text = "\(value)kcal"
            }
            
            consumptionEnergyView.setSomeData(max, value: tmpValue)
            
            
            
        }
     
    }
    
 

}
