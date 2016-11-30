//
//  MyCircleView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/19.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

//MARK:设备状态
enum BlueStateType {
    case notOpen //未打开蓝牙
    case isOpen//蓝牙打开了
    case notConnected//未连接设备
    case autoConnect //自动重连
    case connectionOK //连接成功
    case initialize //初始化 7 分钟
    case polarization //极化 3 小时
//    case synchronousData //同步数据
    case compPolarization //极化完成
}


class MyCircleView: UIView {

    typealias MyCircleViewBtnClourse = (_ stateType: BlueStateType)->Void
    var btnClourse: MyCircleViewBtnClourse?
    
    typealias MyCircleViewCompPolarizationClourse = ()->Void
    var compPolarizationClourse: MyCircleViewCompPolarizationClourse?
    

    //控制器
    var SBMJCtr: UIViewController?
    
    
    
    var dialView:CKCircleView!
    
    //控制整个显示的
    var stateType = BlueStateType.notOpen
    
    
    let stepNmaeArray = ["第一步 “打开蓝牙”",
                         "第二步 “设备连接”",
                         "第三步 “初始化”",
                         "第四步 “极化”",
                         "第五步 “开始监测”",
                         "第六步 “同步数据”"]
    
    let detailedArray = ["因设备是通过蓝牙与APP进行连接，所以不要忘记打开蓝牙哦~~",
                         "请选择与您佩戴的设备名称相同的设备号进行连接\n注：设备首次连接可能需要1分钟的启动时间，请耐心等待…",
                         "初始化是开启监测前的正常流程，需要7分钟，期间无需进行任何操作，只需耐心等待即可。",
                         "极化是传感器的稳定工作过程，总时长为3小时。极化3分钟后会出现第一个电流值，正常范围为8000-65530，点击按钮【查看电流】，如果不在正常范围内，需及时与佩戴人员联系。",
                         "已经开始监测，建议您在第二天早上输入空腹指血后即可查看之后的血糖曲线。",
                         "读取设备的数据，监测时间越长，读取的时间越长。"]
    
    
    let explainArray = ["如何打开蓝牙","如何查看我的设备号","","","如何获得空腹血糖"]
    
    
    var stepsInt = 1
    
    
    
    var stepNameLabel: UILabel!
    var detailLabel: UILabel!
    
    
    var myStepsView: UIView!
    
    
    
    
    fileprivate let Hsize = (UIScreen.main.bounds.height - 64 - 63) / (667 - 64 - 63)
    fileprivate let Wsize = UIScreen.main.bounds.width / 375
    
    //圆半径
    var arcRadius: CGFloat = 120
    //圆的高度
    var circleHeight: CGFloat!
    
    //动画起始时间
    var startTimeStamp: Int?
    
    
    override func draw(_ rect: CGRect) {
        
        circleHeight = 330 * self.Hsize
        
        arcRadius = 120 * self.Wsize
        
        self.loadOutRing(rect)
        
        self.loadInnerRing(rect)
  
        
        self.loadSomeStateView(stateType,rect: rect)
        
    }
    
    //外圈
    func loadOutRing(_ rect: CGRect){
        
        let width = rect.size.width

        let stepView = StepsView(frame: CGRect(x: 0, y: 0, width: width, height: circleHeight))
        
        stepView.arcRadius = self.arcRadius + 8
        
        stepView.backgroundColor = UIColor.white
        
        self.addSubview(stepView)
        
    }
    //内圈
    func loadInnerRing(_ rect: CGRect){
        let width = rect.size.width
 
        //内部
        self.dialView = CKCircleView(frame: CGRect(x: 0, y: 0, width: width, height: circleHeight))
        
        dialView.backColor = UIColor.white
        
        self.dialView.initCircleView(CGRect(x: 0, y: 0, width: width, height: circleHeight))
        
        dialView.arcColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        dialView.backColor = UIColor.clear
        dialView.dialColor = UIColor.red
        
        dialView.arcRadius = self.arcRadius
        dialView.dialRadius = 5
        dialView.units = ""
        dialView.arcThickness = 3
        
        dialView.labelColor = UIColor.red
        dialView.labelFont = UIFont.systemFont(ofSize: 30)
        
        self.addSubview(dialView)
        
        
        
    }
    
    
    //----------
    fileprivate var isBlueShow = true  //是否显示蓝牙图标  NO，是隐藏
    fileprivate var isNotBlue = true    //显示蓝牙图标什么状态，NO 是灰色
    fileprivate var isTimeShow = true  //是否显示时间
    fileprivate var isBtnShow = true //是否显示按钮
    
    
    
    //
    
    
    var myAngle: Double = 0
    
    
    func loadSomeStateView(_ state: BlueStateType,rect: CGRect){

        switch state {
        case .notOpen:
            print("未打开蓝牙")
            
            self.isBlueShow = true
            self.isNotBlue = false
            self.isTimeShow = false
            self.isBtnShow = true
            
            self.blueStateText = "未打开蓝牙"
            self.blueBtnTitle = "打开蓝牙"
        case .isOpen:
            print("蓝牙打开了")

            self.isBlueShow = true
            self.isNotBlue = true
            self.isTimeShow = false
            self.isBtnShow = false
  
            self.blueStateText = "蓝牙已经打开"
            self.blueBtnTitle = "打开蓝牙"
        case .notConnected:
            print("未连接设备")
            
            self.isBlueShow = true
            self.isNotBlue = true
            self.isTimeShow = false
            self.isBtnShow = true
            self.blueStateText = "请链接设备"
            
            self.blueBtnTitle = "连接设备"
            
            
            
            self.myAngle = M_PI * 2 / 5 * (180 / M_PI)
            self.dialView.moveCircleToAngle(self.myAngle)

        case .autoConnect:
            print("自动重连")
            
            self.isBlueShow = true
            self.isNotBlue = true
            self.isTimeShow = false
            self.isBtnShow = false
            self.blueStateText = "自动重连中"
            
            self.blueBtnTitle = "连接设备"

            self.myAngle = M_PI * 2 / 5 * (180 / M_PI)
            self.dialView.moveCircleToAngle(self.myAngle)
            
        case .connectionOK:
            print("连接成功")
            
            self.isBlueShow = true
            self.isNotBlue = true
            self.isTimeShow = false
            self.isBtnShow = false
            self.blueStateText = "设备连接成功"
            
            self.blueBtnTitle = "连接设备"
   
            self.myAngle = M_PI * 2 / 5 * (180 / M_PI) * 2
            self.dialView.moveCircleToAngle(self.myAngle)
            
            
        case .initialize:
            print("初始化 7 分钟")
            
            self.isBlueShow = true
            self.isNotBlue = true
            self.isTimeShow = true
            self.isBtnShow = false
            self.blueStateText = "初始化时间"
            self.blueBtnTitle = ""
            
            //起始弧度
            self.myAngle = M_PI * 2 / 5 * (180 / M_PI) * 2
            self.dialView.moveCircleToAngle(self.myAngle)
            //一共需要移动的弧度
            self.one_four = M_PI * 2 / 5  * 3 * (180 / M_PI)
            //时间
            self.timeD = 7.0 * 60
            //单步增加的弧度
            self.oneAdd = (one_four - self.myAngle) / timeD
            //如果有起始时间
            if self.startTimeStamp != nil {

                if self.labelAnimationNSTimer != nil {
                    self.labelAnimationNSTimer.invalidate()
                    self.labelAnimationNSTimer = nil
                }
                //开始时间计时
                self.labelAnimationNSTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MyCircleView.LabelTimeAnimation), userInfo: nil, repeats: true)
                
            }
            //开始动画
            self.NSTIMEANIMATION()
            
        case .polarization:
            print("极化 3 小时")
            
            self.isBlueShow = true
            self.isNotBlue = true
            self.isTimeShow = true
            self.isBtnShow = true
            self.blueStateText = "极化时间"
            self.blueBtnTitle = "查看电流"
            //起始弧度
            self.myAngle = M_PI * 2 / 5 * 3 * (180 / M_PI)
            //偏移
            self.dialView.moveCircleToAngle(self.myAngle)
            
            //总弧度
            self.one_four = M_PI * 2 / 5  * 4 * (180 / M_PI)
            //总时间
            self.timeD = 180.0 * 60
            //单步弧度
            self.oneAdd = (one_four - self.myAngle) / timeD
            //如果有起始时间
            if self.startTimeStamp != nil {
                
                let today:Double = Date().timeIntervalSince1970 //当前时间
                let allJcTime:Int = Int(today) - self.startTimeStamp!  //总监测时间 - 秒
                //走过的时间的弧度
                let tmpAngle = Double(allJcTime) * self.oneAdd
                //重新设置起始弧度
                self.myAngle += tmpAngle

                if self.labelAnimationNSTimer != nil {
                    self.labelAnimationNSTimer.invalidate()
                    self.labelAnimationNSTimer = nil
                }
                //开始时间计时
                self.labelAnimationNSTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MyCircleView.LabelTimeAnimation), userInfo: nil, repeats: true)
                
            }
            //开始动画
            self.NSTIMEANIMATION()
            
        case .compPolarization:
            print("极化完成")
            
            self.isBlueShow = true
            self.isNotBlue = true
            self.isTimeShow = false
            
            self.blueStateText = "极化完成"
            
            
            if self.startTimeStamp == -1 { //没输入过参比
                self.isBtnShow = true
            }else{
                self.isBtnShow = false
            }
            
            
            self.blueBtnTitle = "输入参比"
            
            
            //起始弧度
            self.myAngle = M_PI * 2 / 5 * 4 * (180 / M_PI)
            //偏移
            self.dialView.moveCircleToAngle(self.myAngle)
//        case .synchronousData:
//            print("同步数据")
        }
        
        self.loadStatePrompt()
        //底部文字
        let y = self.circleHeight
        let width = rect.width
        let height = rect.height - y!
        let frame = CGRect(x: 0, y: y!, width: width, height: height)
        self.stepsInt = self.BlueStateTypeToInt(self.stateType)
        self.loadDownStepsView(frame)
        
    }
    //计时动画
    var labelAnimationNSTimer:Timer!
    
    func LabelTimeAnimation(){
        
        
        switch self.stateType {
        case .initialize: //初始化
            let (_, remainTime) = SBMGSevice().calculateSevenMinInitTime(self.startTimeStamp!)
            
            let remainMin = remainTime / 60
            let remainSec = remainTime % 60
            
            let (Fmin,Fsec) = SBMGSevice().setSevenTime(remainMin,sec: remainSec)
            
//            print("初始化->\(Fmin):\(Fsec)")
            
            self.timeLabel.text! = "\(Fmin):\(Fsec)"
        case .polarization: //极化
            let (ispolarization,time) = SBMGSevice().setAllTimes(self.startTimeStamp!, initState: true)
            
//            print("极化->\(time)")
            self.timeLabel.text! = time
            
            //ispolarization true 为极化三小时完成
            if ispolarization {
                print("极化完成")
                
                self.compPolarizationClourse?()
                
            }
            
            
        default:
            break
        }
        
        
        

    }
    
    
    
    
    //动画时间
    var timeD = 1.0 * 60 //动画时间
    
    var oneAdd: Double = 0 //单步递增多少
    var one_four: Double = 0 //终点
    
    var animationNSTimer:Timer!
    
    func NSTIMEANIMATION(){
        
        //根据时间计算出单步的 值
        // 1 / 4

        if self.animationNSTimer == nil {
            self.animationNSTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MyCircleView.moveCircle), userInfo: nil, repeats: true)
        }
        
    }
    func moveCircle(){
        
        if self.myAngle < one_four {
            
            if self.myAngle + oneAdd > one_four{
                self.myAngle = one_four
            }else{
                self.myAngle += oneAdd
            }
            
            self.dialView.moveCircleToAngle(self.myAngle)
            
        }else{
            
            if self.animationNSTimer != nil {
                self.animationNSTimer.invalidate()
                self.animationNSTimer = nil
                
                print("定时器 释放")
            }
            
            
        }
        
        
        
        self.dialView.moveCircleToAngle(self.myAngle)
    }

    
    
    var myStateView: UIView!
    
    
    //图标
    var blueImg: UIImageView!
    //文字说明
    var blueStateLabel: UILabel!
    
    var blueStateText = "请链接设备"
    
    var blueBtnTitle = "打开蓝牙"
    
    //时间文字
    var timeLabel: UILabel!
    //按钮
    var blueStateBtn: UIButton!
    
    func loadStatePrompt(){
        
        if self.myStateView != nil {
            self.myStateView.removeFromSuperview()
            self.myStateView = nil
        }
        
        let size = self.dialView.frame.size
        
        self.myStateView = UIView(frame: CGRect(x: (size.width - self.arcRadius) / 2,y: (size.height - self.arcRadius) / 2,width: self.arcRadius,height: self.arcRadius))
        self.myStateView.backgroundColor = UIColor.clear
        self.dialView.addSubview(self.myStateView)
        //图标
        let toUp: CGFloat = 4.0
        
        self.blueImg = UIImageView(frame: CGRect(x: (arcRadius -  15 * self.Hsize) / 2, y: 4 * self.Hsize, width: 15 * self.Hsize, height: 20 * self.Hsize))
        
        var imgName = ""
        if self.isNotBlue {
            imgName = "openBlue"
        }else{
            imgName = "notopenBlue"
        }

        self.blueImg.image = UIImage(named: imgName)
        
        self.myStateView.addSubview(self.blueImg)
        
        if self.isBlueShow {
            self.blueImg.isHidden = false
        }else{
            self.blueImg.isHidden = true
        }
        
        
        
        //文字
        let y: CGFloat = (toUp + 20 + 12.5) * self.Hsize
        let h: CGFloat = 16
        
        self.blueStateLabel = UILabel(frame: CGRect(x: (self.arcRadius -  90) / 2,y: y,width: 90,height: h * self.Hsize))
        self.blueStateLabel.textAlignment = .center
        self.blueStateLabel.textColor = UIColor(red: 133/255.0, green: 133/255.0, blue: 133/255.0, alpha: 1)
        self.blueStateLabel.font = UIFont(name: PF_SC, size: 14)
        self.blueStateLabel.text = self.blueStateText
        self.myStateView.addSubview(self.blueStateLabel)
        
        //时间
        let t_y: CGFloat = y + (h + 10) * self.Hsize
        let t_h: CGFloat = 22
        self.timeLabel = UILabel(frame: CGRect(x: (self.arcRadius -  100) / 2,y: t_y,width: 100,height: t_h * self.Hsize))
//        self.timeLabel.backgroundColor = UIColor.blueColor()
        
        self.timeLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.timeLabel.textAlignment = .center
        self.timeLabel.text = ""
        self.timeLabel.font = UIFont(name: PF_TC, size: 20)
        
        self.myStateView.addSubview(self.timeLabel)
        
        if self.isTimeShow {
            self.timeLabel.isHidden = false
        }else{
            self.timeLabel.isHidden = true
        }
        
        
        //按钮
        let b_h: CGFloat = 30
        
        self.blueStateBtn = UIButton(frame: CGRect(x: (self.arcRadius -  84) / 2,y: self.arcRadius - b_h * self.Hsize - 4,width: 84,height: b_h * self.Hsize))
        self.blueStateBtn.setTitle(self.blueBtnTitle, for: UIControlState())
        self.blueStateBtn.titleLabel?.font = UIFont(name: PF_SC, size: 14)
        self.blueStateBtn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), for: UIControlState())
        
        self.blueStateBtn.layer.cornerRadius = 4
        self.blueStateBtn.layer.masksToBounds = true
        self.blueStateBtn.layer.borderWidth = 0.5
        self.blueStateBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
        
        self.blueStateBtn.addTarget(self, action: #selector(MyCircleView.blueStateBtnAct(_:)), for: UIControlEvents.touchUpInside)
        
        self.myStateView.addSubview(self.blueStateBtn)
        
        if self.isBtnShow {
            self.blueStateBtn.isHidden = false
        }else{
            self.blueStateBtn.isHidden = true
        }
        
        
    }
    
    func blueStateBtnAct(_ send: UIButton){

        switch self.stateType {
        case .notOpen:
            print("点击了按钮->打开蓝牙")
            
            
     
            
            if #available(iOS 10.0, *) {

                let alrte = UIAlertView(title: "请您打开蓝牙", message: "需要打开蓝牙服务", delegate: nil, cancelButtonTitle: "确定")
                alrte.show()

            } else {
                let url = URL(string: "Prefs:root=Bluetooth")
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }
            }
    
            
        case .notConnected:
            print("点击了按钮->连接设备")
            
            self.btnClourse?(.notConnected)
        case .polarization:
            print("点击了按钮->查看电流")
            self.btnClourse?(.polarization)
        case .compPolarization:
            print("点击了按钮->输入参比")
            self.btnClourse?(.compPolarization)
        default:
            break
        }
        
        
        
    }
    

    
    
    func loadDownStepsView(_ rect: CGRect){
        
        myStepsView = UIView(frame: rect)
        myStepsView.backgroundColor = UIColor.white
        self.addSubview(myStepsView)
        
        
        //线条
        let y: CGFloat = 15
        let x: CGFloat = 19
        
        let xtView = UIView(frame: CGRect(x: x,y: y,width: rect.width - x * 2,height: 1))
        xtView.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        myStepsView.addSubview(xtView)
        
        
        //步骤标题
        let b_y = y + 14
        let b_h: CGFloat = 16
        
        self.stepNameLabel = UILabel(frame: CGRect(x: x,y: b_y,width: rect.width - x * 2,height: b_h))
        
        let tmpText = self.stepNmaeArray[self.stepsInt - 1]
        
        let str = tmpText
        
        let typeNameCount = 5
        
        let attributedStr = NSMutableAttributedString(string: str)
        attributedStr.addAttribute(NSFontAttributeName, value: UIFont(name: PF_SC, size: 16)! , range: NSMakeRange(0, typeNameCount))
        
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1), range: NSMakeRange(0, typeNameCount))
        
        let doseNameCount = str.characters.count - typeNameCount
        
        attributedStr.addAttribute(NSFontAttributeName, value: UIFont(name: PF_SC, size: 16)! , range: NSMakeRange(typeNameCount, doseNameCount))
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), range: NSMakeRange(typeNameCount, doseNameCount - 1))
        
        self.stepNameLabel.attributedText = attributedStr
        
        myStepsView.addSubview(self.stepNameLabel)
        
        
        
        //详细
        let d_y = b_y + b_h + 12
        
        let d_h = rect.height - d_y
        
        self.detailLabel = UILabel(frame: CGRect(x: x,y: d_y,width: rect.width - x * 2,height: d_h))
        
        let detailText = self.detailedArray[self.stepsInt - 1]
        
        
        
        self.detailLabel.text = detailText
        
        self.detailLabel.numberOfLines = 0
        
        self.detailLabel.textColor = UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1)
        
        self.detailLabel.font = UIFont(name: PF_SC, size: 15)
        
        //        self.detailLabel.backgroundColor = UIColor.yellowColor()
        
        let string:NSString = detailText as NSString
        
        let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
        
        let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
        
        let brect = string.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 28, height: 0), options: [options,a], attributes:  [NSFontAttributeName:(self.detailLabel.font)!], context: nil)
        
        self.detailLabel.frame = CGRect(x: x,y: d_y,width: rect.width - x * 2,height: brect.height)

        myStepsView.addSubview(self.detailLabel)
        
        //解释，详细按钮
        
        let expTitle = self.explainArray[self.stepsInt - 1]
        
        if !expTitle.isEmpty {
            let expBtn = UIButton(frame: CGRect(x: x,y: d_y + brect.height,width: 150,height: 35))
            
            expBtn.tag = self.stepsInt - 1
            
            expBtn.setTitleColor(UIColor.blue , for: UIControlState())

            
            expBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            
            myStepsView.addSubview(expBtn)
    
            
            
            let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: 14.0),
                         NSForegroundColorAttributeName:UIColor().rgb(241, g: 153, b: 66, alpha: 1),
                         NSUnderlineStyleAttributeName : 1] as [String : Any]
            let attributedString = NSMutableAttributedString(string:"")
            
            
            //按钮
            let buttonTitleStr = NSMutableAttributedString(string: "\(expTitle)?", attributes:attrs)
            attributedString.append(buttonTitleStr)
            expBtn.setAttributedTitle(attributedString, for: UIControlState())
            
            expBtn.addTarget(self, action: #selector(MyCircleView.expBtnAct(_:)), for: UIControlEvents.touchUpInside)
            
            
            
        }
    
    }
    
    func expBtnAct(_ send: UIButton){

        
        print(send.tag)
        
        let tmpTitle = self.explainArray[send.tag]
        let explianVC = ExplainViewController()
        
        explianVC.myTitle = tmpTitle

        switch send.tag {
        case 0:
            explianVC.loadType = ExplainViewController.ExplainTyep.openBluetooth
        case 1:
            explianVC.loadType = ExplainViewController.ExplainTyep.seeSerialNumber
        case 4:
            explianVC.loadType = ExplainViewController.ExplainTyep.getFastingBlood
        default:
            break
        }
        
        
        
        
        self.SBMJCtr?.navigationController?.pushViewController(explianVC, animated: true)
      
    }
    
    
    
    
    
    
    
    func BlueStateTypeToInt(_ state: BlueStateType) -> Int{
        
        var typeInt = 1
        
        switch state {
        case .notOpen:
            //print("未打开蓝牙")
            typeInt = 1
        case .isOpen:
            //print("蓝牙打开了")
            typeInt = 2
        case .notConnected:
            //print("未连接设备")
            typeInt = 2
        case .autoConnect:
            //print("自动重连")
            typeInt = 2
        case .connectionOK:
            //print("连接设备ok")
            typeInt = 2
        case .initialize:
            //print("初始化 7 分钟")
            typeInt = 3
        case .polarization:
            //print("极化 3 小时")
            typeInt = 4
        case .compPolarization:
           //print("极化完成")
            typeInt = 5
//        case .synchronousData:
//            print("同步数据")
//            typeInt = 6
        }

        return typeInt
    }
    
    
    
    func removeLabelAnimationNSTimer(){
        
        if self.labelAnimationNSTimer != nil{
            self.labelAnimationNSTimer.invalidate()
            self.labelAnimationNSTimer = nil
        }
   
    }
    
    
    
}
