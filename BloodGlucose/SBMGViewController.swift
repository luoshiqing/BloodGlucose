//
//  SBMGViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/3/29.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit
import CoreBluetooth

//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l > r
//  default:
//    return rhs < lhs
//  }
//}


enum DevicePhase1{
    case deviceInit
    case deviceMonitor
    case deviceEndMonitor
}

enum DeviceStep1{
    case checkInit
    case checkRecord
    case syncTime
    case saveFirstLog
    case m7Init
    case h3Init
    case startMonitor
    case readData
    case uploadData
}

enum CommandType1{
    case connect
    case syncTime
    case getLog
    case getStatus
    case getDeviceId
    case getBloodData
    case allGetBloodData
}







class SBMGViewController: UIViewController ,FingerInputViewDelegate ,UITableViewDelegate,UITableViewDataSource ,BTStatusDelegate,SBGMBlueListViewDelegate {

    
    
    fileprivate var fullTime: Date? //----记录最后一条数据的NSDate

    fileprivate let SBMGHsize:CGFloat = (UIScreen.main.bounds.height - 64 - 49) / (568 - 64 - 49)
    fileprivate let SBMGWsize:CGFloat = UIScreen.main.bounds.width / 320

    fileprivate var mySBMainView: SBMainView? //主监测视图
    fileprivate var myCircleView: MyCircleView? //步骤视图
    fileprivate var myFingerListView: FingerListView? //指血视图
    fileprivate var myFingerBGView: UIView? //指血背景遮罩视图
    fileprivate var myFingerInputView: FingerInputView? //指血输入视图
    fileprivate var isShowBloodLow: Bool = true //是否提示输入指血不正常,单条不提醒
    fileprivate var fingerBloodDataArray = [Any]() //参比指血记录
    fileprivate var rightLogNameArray = ["","","","","",""] //查看设备日志的数组
    fileprivate var btDiscoverySharedInstance: BTDiscovery? //蓝牙协议
    fileprivate var discalimerView: DisclaimerView?         //免责
    fileprivate var myChartView: MyChartView?
    fileprivate var chartBGView: UIView?
    //--&*****************
    fileprivate var currentChartView: CurrentChartView?
    fileprivate var allTimesNSTimer:Timer? //监测时间计时器
    fileprivate var comTimeoutTimer: Timer? //超时计时器
    fileprivate var myPeripheral:CBPeripheral! //当前连接的
    fileprivate var lsqV: LsqView? //左导航菜单视图
    fileprivate var sbInputView:SBInputFingerView? //输入指血
    fileprivate var historyView: SBHistoryFingerView? //历史指血
    fileprivate var fingerBloodArraySorted = [Any]() //临时参比数据
    
    //--------
    
    fileprivate var timeSynced: Bool = false
    fileprivate var inLogTransfer: Bool = false //检测是否是主动请求日志
    //记录是否已经发送过请求血糖数据命令，防止在发送血糖数据之前刚好收到周期性发送的血糖数据，从而取消血糖数据命令成功检测定时器
    fileprivate var sendGetBloodData: Bool = false
    //    var calculateAndUploadQueue = dispatch_group_create()
    fileprivate var calculateAndUploadQueue = DispatchQueue(label: "com.nashsu.cc", attributes: [])
    fileprivate var startSevenMinInitTimeStamp:Int! //7分钟初始化开始时间
    fileprivate var initCountdownNSTimer:Timer? //三小时极化倒计时计时器
    fileprivate var logTimer:Timer? //日志接收超时计时器，如果计时器超时证明日志传输完成（默认6秒）
    fileprivate var startInitTimeStamp:Int! //极化开始时间
    fileprivate var tongbuTime:Bool = true //是否同步过
    fileprivate var currentPeripheralName:String? //蓝牙名
    fileprivate var probeId:String! //探头ID
    fileprivate var sensorId:String! //设备ID
    fileprivate var sevenInitState:Bool = false //true 为7分钟极化中
    
    
    fileprivate var stopMaxNSTimer: Timer? //计算血糖最大个数
    fileprivate var maxm: Int = 0
    fileprivate var a = 0
    fileprivate var xcoun: Int = 1
    fileprivate var bloodDataTmp: [UInt8]!
    fileprivate var startMonitorTimeStamp: Int! //开始监测时间
    fileprivate var bloodElectricDataArray = NSMutableDictionary() //原始电流数据数组
    fileprivate var setBlood: JGProgressHUD?
    fileprivate var saveBlood: JGProgressHUD?
    fileprivate var oneoneoneBloodCount = 0 //单挑数据个数
    fileprivate var myCurretnAlrtView: UIAlertController!
    
    fileprivate var notTimeNSTimer: Timer? //没有找到起始监测时间定时器
    
    fileprivate var bleDevices = NSArray() //蓝牙设备列表
    fileprivate var sbmgBlueListView :SBMGBlueListView? //设备列表视图
    fileprivate var blueListTabView: UITableView?
    fileprivate var bleConnectHud: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white


        //初始化蓝牙服务
//        if btDiscoverySharedInstance == nil {
//            btDiscoverySharedInstance = BTDiscovery()
//            btDiscoverySharedInstance?.delegate = self
//        }

        NotificationCenter.default.addObserver(self, selector: #selector(SBMGViewController.jianting(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

        //设置导航栏按钮
        self.addMenuVCBtn()
        //加载视图
        self.loadSBMainView()

        //初始化血糖转换算法模块
        BGC_Init()

        if let one:Bool = UserDefaults.standard.value(forKey: "oneNo") as? Bool{
            print("one\(one)")
            if (one == false) {
                self.oneNo = false
            }else{
                self.oneNo = true
            }
        }

        //MARK:步骤引导界面
        self.loadMyStepsView(BlueStateType.notConnected,time: nil)
        
        //免责
        self.loadLiabilityView()
        
        
        
    }
    
    //MARK:-视图出现的时候 加载蓝牙
    override func viewDidAppear(_ animated: Bool) {
        
        if ((self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer))) != nil) {
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        }

        if discalimerView == nil {
            //初始化蓝牙协议
            self.initBluetoothService()
        }
        
        if self.myCircleView == nil && self.mySBMainView != nil{
            self.getSomeValue()
        }
    }
    //MARK:初始化蓝牙协议
    func initBluetoothService(){
        if btDiscoverySharedInstance == nil {
            print("初始化蓝牙协议")
            btDiscoverySharedInstance = BTDiscovery()
            btDiscoverySharedInstance?.delegate = self
        }
        
        if btDiscoverySharedInstance?.peripheralBLE == nil{
            btDiscoverySharedInstance?.startScanning()
        }
        
        
        
    }
    
    
    //MARK:-视图将要出现的时候
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BaseTabBarView.isHidden = false
        CAGradientLayerEXT().animation(true)
        
        if self.myCircleView == nil {
            self.reloadTheMainView()
        }
     
    }
    
    
    func reloadTheMainView(){
        
        self.mySBMainView?.removeFromSuperview()
        self.mySBMainView = nil
        //加载视图
        self.loadSBMainView()
        
//        self.getSomeValue()
    }
    
    
    func getSomeValue(){
        
//        //MARK:-获取HbA1c 值
//        let (sid,_) = self.getSidTid()
//        MyNetworkRequest().getHbA1c(sid as String, clourse: { (hba1c) in
//            self.mySBMainView?.setHbA1cLabelValue(hba1c)
//        })
//        
        if let preFingerBloodDataArray:NSArray = UserDefaults.standard.object(forKey: "fingerBloodDataArray") as? NSArray{
        
            self.mySBMainView?.setNumberBloodLabelValue(preFingerBloodDataArray.count)
        }

        //获取最后一个数据
        let (blood,_,_) = self.getLastFMDBBloodData()

        //根据血糖浓度，改变笑脸，表盘
        let bloodAnyWill:Int = Int(Double(blood)! * 10)
        self.mySBMainView?.setImgCly(bloodAnyWill)
        
        self.onceAgainSetSomeValue()
    }
    

    func loadSBMainView(){
        if self.mySBMainView == nil {
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height - 64 - 49
      
            
            self.mySBMainView = SBMainView(frame: CGRect(x: 0,y: 0,width: width,height: height))
            self.mySBMainView?.backgroundColor = UIColor.white
            //回调
            self.mySBMainView?.viewActClourse = self.SBMainViewViewActClourse
            self.view.addSubview(self.mySBMainView!)
        }
   
    }
 
    //MARK:加载步骤视图
    func loadMyStepsView(_ state: BlueStateType,time: Int?){
        if self.myCircleView != nil{
            
            self.myCircleView?.removeLabelAnimationNSTimer()
            
            self.myCircleView?.removeFromSuperview()
            self.myCircleView = nil
        }
        if self.myCircleView == nil {
            
            let widt = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height - 64 - 49
            
            myCircleView = MyCircleView(frame: CGRect(x: 0,y: 0,width: widt,height: height))
            myCircleView?.backgroundColor = UIColor.white
            
            myCircleView?.SBMJCtr = self
            
            
            myCircleView!.stateType = state
            
 
            if let startTime = time {
                myCircleView?.startTimeStamp = startTime
            }
            myCircleView?.btnClourse = self.MyCircleViewBtnClourse
            myCircleView?.compPolarizationClourse = self.MyCircleViewCompPolarizationClourse
            self.view.addSubview(myCircleView!)
        }
    }
    //移除步骤视图
    func removeMyCircleView(){
        
        if self.myCircleView != nil{

            UIView.animate(withDuration: 0.45, delay: 0, options: UIViewAnimationOptions(), animations: {
                
                self.myCircleView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

                }, completion: { (cop: Bool) in
                    self.myCircleView?.removeFromSuperview()
                    self.myCircleView = nil
            })
        }
    }
    //MARK:极化完成回调
    func MyCircleViewCompPolarizationClourse()->Void{
        self.loadMyStepsView(BlueStateType.compPolarization,time: -1)
    }
    

    //MARK:步骤按钮回调
    func MyCircleViewBtnClourse(_ stateType: BlueStateType)->Void{
        switch stateType {
        case .notConnected:
            print("回调，开始连接设备")
            if btDiscoverySharedInstance?.peripheralBLE == nil{
                btDiscoverySharedInstance?.startScanning()
                self.blueState = true
            }
        case .polarization:
            print("回调，查看电流")
            let informationVC = BloodListViewController(nibName: "BloodListViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(informationVC, animated: true)
        case .compPolarization:
            print("回调，输入参比指血")
            self.fingerBloodPrintAct()
        default:
            break
        }
    }
    //MARK:加载免责声明视图
    func loadLiabilityView(){
        
        if let isLiability:Bool = UserDefaults.standard.object(forKey: "MYLiability") as? Bool{
            if isLiability {
                //-----
                self.discalimerView = DisclaimerView()
                self.discalimerView?.okClourse = self.DisclaimerViewOkClourse
                discalimerView?.initDisclaimerView()
                
                UserDefaults.standard.set(false, forKey: "MYLiability")
            }
        }else{
            
            //-----
            self.discalimerView = DisclaimerView()
            self.discalimerView?.okClourse = self.DisclaimerViewOkClourse
            discalimerView?.initDisclaimerView()

            UserDefaults.standard.setValue(false, forKey: "MYLiability")
            
        }
    }
    //MARK:免责我知道了回调
    func DisclaimerViewOkClourse()->Void{
        print("免责声明，我知道了回调")
        self.discalimerView?.removeFromSuperview()
        self.discalimerView = nil
        //初始化蓝牙协议
        self.initBluetoothService()
    }

    func setStartTimeAndFinger(){
        //获取历史指血
        if let preFingerBloodDataArray = UserDefaults.standard.object(forKey: "fingerBloodDataArray") as? [Any]{
            print("##### 有指血数据历史记录 #####")
            //设置为有输入参比
            self.firstFingerBloodDataInputed = true
            self.fingerBloodDataArray.removeAll()
//            self.fingerBloodDataArray.addObjects(from: preFingerBloodDataArray as [AnyObject])
            self.fingerBloodDataArray += preFingerBloodDataArray
            //创建一个临时参比数组，对参比数据进行排序
            fingerBloodArraySorted = [AnyObject]()
            fingerBloodArraySorted = self.fingerBloodDataArray
            //对参比数据进行排序

            self.mySBMainView?.setNumberBloodLabelValue(self.fingerBloodDataArray.count)
            print("##### 指血数据历史记录处理结束 #####")
        }
        if(self.startMonitorTimeStamp != nil){
            let today:Double = Date().timeIntervalSince1970 //当前时间
            let allJcTime:Int = Int(today) - self.startMonitorTimeStamp  //总监测时间 - 秒
            
            //设置总监测时间
            if allJcTime < 3 * 60 * 60 {
                let (_,time) = SBMGSevice().setAllTimes(self.startMonitorTimeStamp, initState: true)
//                self.mySBMainView?.allTimeLabel.text = time
                self.mySBMainView?.setAllTime(time)
            }else{
                
                self.allTimesNSTimer?.invalidate()
                self.allTimesNSTimer = nil
                
                self.allTimesNSTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SBMGViewController.setAllTimesShow), userInfo: nil, repeats: true)
            }
        }
    }
    
    
    //防止重影，重新赋值
    func onceAgainSetSomeValue(){
        
        if self.yunUpState() {
            
            let (blood,lastTime,fullTime) = self.getLastFMDBBloodData()
            print(blood,lastTime,fullTime)

            self.mySBMainView?.setBloodValue(blood, oneTime: lastTime)
            

            if(self.startMonitorTimeStamp != nil){
                let today:Double = Date().timeIntervalSince1970 //当前时间
                let allJcTime:Int = Int(today) - self.startMonitorTimeStamp  //总监测时间 - 秒
                
                //设置总监测时间
                if allJcTime < 3 * 60 * 60 {
                    let (_,time) = SBMGSevice().setAllTimes(self.startMonitorTimeStamp, initState: true)
//                    self.mySBMainView?.allTimeLabel.text = time
                    
                    self.mySBMainView?.setAllTime(time)
                    
                }else{
                    if self.allTimesNSTimer != nil{
                        self.allTimesNSTimer!.invalidate()
                        self.allTimesNSTimer = nil
                    }

                    self.allTimesNSTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SBMGViewController.setAllTimesShow), userInfo: nil, repeats: true)
                }
                
            }
            
            
        }
    }
    
    
    
    
    //MARK:- 后台进入到前台
    func jianting(_ notification: Notification){
        print("后台进入到前台")
        let state = self.yunUpState()
        if state{ //连接上了设备
            self.isShowBloodLow = false
            //重新获取历史指血数据
            if let preFingerBloodDataArray = UserDefaults.standard.object(forKey: "fingerBloodDataArray") as? [Any]{
                //设置为有输入参比
                self.firstFingerBloodDataInputed = true
                self.fingerBloodDataArray.removeAll()
//                self.fingerBloodDataArray.addObjects(from: preFingerBloodDataArray as [AnyObject])
                self.fingerBloodDataArray += preFingerBloodDataArray
                //重新计算血糖值，
                
                self.saveBlood = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.saveBlood?.textLabel.text = "计算血糖.."
                self.saveBlood?.show(in: self.view, animated: true)
                
                self.completeFingerBloodSubmit(false, count: nil)
            }else{
                print("没有指血记录，放弃计算")
            }
        }else{
            print("还没有连接设备")
        }
    }
    
    //MARK:- 设备协议
    var currentPhase:DevicePhase1!
    var currentStep:DeviceStep1!
    var currentCommand:CommandType1!
    var preCommand:CommandType1!
    
    //连接指令
    func commandConnect() {
        currentCommand = CommandType1.connect
        sendCommandToDevice([0x0f, 0xa1, 0xd2, 0x04, 0x00, 0x00])
    }
    
    //请求工作状态和报警指令
    func commandCurrentStat() {
        currentCommand = CommandType1.getStatus
        sendCommandToDevice([0x0f, 0xa8, 0x00, 0x00, 0x00, 0x00])
    }
    
    //获取血糖数据
    func commandGlucoseValue() {
        //resetGetBloodDataTimer()
        //设置时间
        let curretnTime = SBMGSevice().getCurrentTime()
        self.rightLogNameArray[3] = curretnTime
        currentCommand = CommandType1.getBloodData
        sendCommandToDevice([0x0f, 0xa7, 0x01, 0x00, 0xff, 0xff])
    }
    
    //获取设备 ID
    func commandSenderId() {
        currentCommand = CommandType1.getDeviceId
        sendCommandToDevice([0x0f, 0xad, 0x00, 0x00, 0x00, 0x00])
    }
    
    //获取固件版本
    func commandFirmwareVersion() {
        currentCommand = CommandType1.getDeviceId
        sendCommandToDevice([0x0f, 0xab, 0x00, 0x00, 0x00, 0x00])
    }
    
    
    //获取日志
    func commandGetLog() {
        print("+++++++++++++++发送获取工作日志指令++++++++++++++++")
        currentCommand = CommandType1.getLog
        sendCommandToDevice([0x0f, 0xaa, 0x00, 0x00, 0x00, 0x00])
    }
    
    //发送确认指令
    func commandSendComfirm() {
        preCommand = nil
        //println("发送确认指令")
        sendCommandToDevice([0x0f, 0xae, 0x00, 0x00, 0x00, 0x00])
    }
    
    //时间同步指令
    func commandSyncTime() {
        currentCommand = CommandType1.syncTime
        let timeArray = SBMGSevice().getCurrentUnixTime() as Array
        print("timeArray:\(timeArray)")
        let commandArray = [0x0f, 0xa0] + timeArray
        sendCommandToDevice(commandArray)
    }
    
    //设备指令发送标准方法
    var command:Data?
    func sendCommandToDevice(_ cmd:[UInt8]){

        //先检测是否连续重复发送命令，除非是发送确认指令
        if preCommand == nil || preCommand.hashValue != currentCommand.hashValue{
            preCommand = currentCommand
            
            if cmd != [0x0f, 0xae, 0x00, 0x00, 0x00, 0x00]{
//                self.resetTimer()
                delay(1.5, closure: { () -> () in
                    var cmd:[UInt8] = cmd
                    //计算校验值
                    cmd.append( SBMGSevice().getXORValue(cmd) )
                    self.command = Data(bytes: UnsafePointer<UInt8>(cmd as [UInt8]), count: cmd.count)
                    print("发送指令:\(self.command)")
                    //发送指令
                    if let bleService = self.btDiscoverySharedInstance?.bleService {
                        bleService.sendCommand(self.command!)
                    }
                })
            }else{
                delay(0.1, closure: { () -> () in
                    var cmd:[UInt8] = cmd
                    //计算校验值
                    cmd.append( SBMGSevice().getXORValue(cmd) )
                    self.command = Data(bytes: UnsafePointer<UInt8>(cmd as [UInt8]), count: cmd.count)
                    //print("发送 确认指令")
                    //发送指令
                    if let bleService = self.btDiscoverySharedInstance?.bleService {
                        bleService.sendCommand(self.command!)
                    }
                })
            }
        }
    }

    func resetTimer(){
        print("超时计时器")
        
        self.comTimeoutTimer?.invalidate()
        self.comTimeoutTimer = nil
        
        self.comTimeoutTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(SBMGViewController.communicationTimeoutAction), userInfo: nil, repeats: false)
    }
    func communicationTimeoutAction(){
        preCommand = nil
        if currentCommand != nil{
            switch self.currentCommand as CommandType1{
            case CommandType1.connect:
                self.commandConnect()
                break
            case CommandType1.getBloodData:
                self.commandGlucoseValue()
                break
            case CommandType1.getDeviceId:
                self.commandSenderId()
                break
            case CommandType1.getLog:
                self.commandGetLog()
                break
            case CommandType1.getStatus:
                self.commandCurrentStat()
                break
            case CommandType1.syncTime:
                self.commandSyncTime()
                break
            default:
                break
            }
//            self.resetTimer()
        }
  
    }
    
    
    //延迟异步执行方法
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    //MARK:start蓝牙协议代理----------------->>>>>>>>>>>>
    

    //蓝牙列表
    func discoveredDevice(_ devices:NSArray){

//        print(devices)
        
        //加载选择项
        DispatchQueue.main.async(execute: { () -> Void in
            if self.myFingerBGView == nil {
                self.myFingerBGView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height + 64))
                UIApplication.shared.keyWindow?.addSubview(self.myFingerBGView!)
                self.myFingerBGView?.backgroundColor = UIColor.black
                self.myFingerBGView?.alpha = 0.3
            }
            if(self.sbmgBlueListView == nil){

                self.sbmgBlueListView = Bundle.main.loadNibNamed("SBMGBlueListView", owner: nil, options: nil)?.last as? SBMGBlueListView
                self.sbmgBlueListView?.frame = CGRect(x: (self.view.frame.size.width - 260 * self.SBMGWsize) / 2, y: (self.view.frame.size.height - 312 * self.SBMGHsize) / 2 + 64, width: 260 * self.SBMGWsize, height: 312 * self.SBMGHsize)
                self.sbmgBlueListView?.delegate = self
                UIApplication.shared.keyWindow?.addSubview(self.sbmgBlueListView!)
   
                //设置圆角
                self.sbmgBlueListView?.layer.cornerRadius = 4
                self.sbmgBlueListView?.clipsToBounds = true
                
                //设置关闭按钮点击事件
                self.sbmgBlueListView?.closeBtn.addTarget(self, action: #selector(SBMGViewController.btnAction(_:)), for: UIControlEvents.touchUpInside)
                self.sbmgBlueListView?.closeBtn.tag = 40501
            }

            self.sbmgBlueListView?.reloadTabView(devices)
        })
    }
 
    
    //连接成功
    func btStatusChanged(_ status:BleStatus){

        DispatchQueue.main.async(execute: { () -> Void in
            switch status{
            case BleStatus.btNotSupport:
                print("不支持当前蓝牙设备")
                let alrtView = UIAlertView(title: "提示：", message: "你的设备不支持当前蓝牙设备", delegate: "nil", cancelButtonTitle: "确定")
                alrtView.show()
            case BleStatus.btClosed:
                print("蓝牙功能未开启")
                
                if self.currentPeripheralName != nil || self.probeId != nil{

                    DispatchQueue.main.async(execute: { () -> Void in
                        self.currentPeripheralName = nil
                        self.probeId = nil
                        
                        self.navigationController!.popViewController(animated: false)
                    })
                }
                self.loadMyStepsView(BlueStateType.notOpen,time: nil)
            case BleStatus.didConnectPeripheral:
                print("蓝牙连接成功")
                self.blueConnectState = true
                if self.actionSheet != nil{
                    self.actionSheet.removeFromParentViewController()
                    self.actionSheet = nil
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    if self.notFindBlueNSTimer != nil {
                        self.notFindBlueNSTimer.invalidate()
                        self.notFindBlueNSTimer = nil
                        self.iiiiiiiii = 0
                    }
                    //移除背景视图
                    
                    self.myFingerBGView?.removeFromSuperview()
                    self.myFingerBGView = nil
                    
                    //移除设备列表视图
                    
                    self.sbmgBlueListView?.removeFromSuperview()
                    self.sbmgBlueListView = nil
                    
                    //移除连接中 菊花提示
                    
                    self.bleConnectHud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.bleConnectHud?.textLabel.text =  "连接成功"
                    self.bleConnectHud?.dismiss(afterDelay: 1.5, animated: true)
                    
                    
   
                    
                })
                //发送连接指令
                self.preCommand = nil
                self.currentCommand = nil
                self.commandConnect()
                self.rightLogNameArray = ["","","","","",""]
                //设置时间
                let curretnTime = SBMGSevice().getCurrentTime()
                self.rightLogNameArray[0] = curretnTime
                print("1.发送连接指令")
                
       
                
            case BleStatus.didDisconnectPeripheral:
                print("蓝牙连接断开了啊")
                
                self.comTimeoutTimer?.invalidate()
                self.comTimeoutTimer = nil
                
                self.inLogTransfer = false
                self.rightLogNameArray = ["","","","","",""]
            case BleStatus.didDiscoverPeripheral:
                print("扫描到设备")
            case .normal:
                self.loadMyStepsView(BlueStateType.notConnected,time: nil)

            }
        })
    }
 
    //MARK:收到蓝牙数据
    func receiveBtMessage(_ msg:Data){
        var byteArray:[UInt8] = [UInt8]()
        for i in 0..<(msg.count){
            var tmp:UInt8 = 0
            
            (msg as NSData).getBytes(&tmp, range: NSRange(location: i, length: 1) )
            if tmp == 166 {
                print(tmp)
            }
            byteArray.append(tmp)
        }
        self.getMessageType(byteArray)
    }

    //自动连接
    func connectBlu(_ perp:CBPeripheral){
        
        BGNetwork().delay(0.2) { 
            self.btDiscoverySharedInstance?.connectToPeripheral(perp)//连接
        }
        var deviceName = (perp.name! as NSString).replacingOccurrences(of: " \n", with: "")
        print("bluName:\(deviceName)自动连接")
        
        
        DispatchQueue.main.async(execute: { () -> Void in
            
    
            self.loadMyStepsView(BlueStateType.autoConnect,time: nil)
            
            
            //去除空格
            let whitespace = CharacterSet.whitespacesAndNewlines
            var tempArray = deviceName.components(separatedBy: whitespace)
            tempArray = tempArray.filter{
                $0 != ""
            }
            deviceName = tempArray[0]
            
            self.title = "\(deviceName)"
            self.currentPeripheralName = deviceName
            self.myPeripheral = perp
            
        })
        
        
    }
    
    var notFindBlueNSTimer:Timer!
    
    //MARK:没有找到上次连接的设备
    func notFindBlueDevice() {
        print("没有找到上次连接的设备")
        DispatchQueue.main.async(execute: { () -> Void in
            
            if(self.sbmgBlueListView == nil){
                self.notFindBlueNSTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SBMGViewController.notFindBlueDeviceAdd), userInfo: nil, repeats: true)
            }
        })
    }
    var iiiiiiiii = 0
    
    var actionSheet:UIAlertController!
    
    func notFindBlueDeviceAdd(){
        self.iiiiiiiii += 1
        if self.iiiiiiiii == 55 {
            if(self.self.notFindBlueNSTimer != nil){
                actionSheet = UIAlertController(title: "没有扫描到上次连接的设备", message: "是否重新扫描", preferredStyle: UIAlertControllerStyle.alert)
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
                    
                    UserDefaults.standard.removeObject(forKey: "LanYaName")
                    UserDefaults.standard.setValue(true, forKey: "oneNo")
                    if self.btDiscoverySharedInstance?.peripheralBLE == nil{
                        self.btDiscoverySharedInstance?.startScanning()
                    }else{
                        //MARK:修改的没有找到设备逻辑
                        self.btDiscoverySharedInstance?.peripheralBLE = nil
                        self.btDiscoverySharedInstance?.startScanning()
                    }
                }))
                actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
            }
            
            if self.notFindBlueNSTimer != nil {
                self.notFindBlueNSTimer.invalidate()
                self.notFindBlueNSTimer = nil
                self.iiiiiiiii = 0
            }
        }
    }
    
    // 蓝牙连接状态
    var blueState:Bool = true
    //是否为主动断开
    var selfConncet:Bool = false
    //断开连接
    func disconnectToconnectBlu(){

        print("是否需要重新连接")
        self.rightLogNameArray = ["","","","","",""]
        self.inLogTransfer = false
        self.iiiiiiiii = 0
        if (self.selfConncet == false){

            self.blueState = true
            DispatchQueue.main.async(execute: { () -> Void in
                //返回上级
                //清除数据
                
                self.reservedBlueData()
                
                self.initBluetoothService()

                //加载视图
                self.loadSBMainView()
                
//                self.navigationController?.popViewControllerAnimated(false)
            })
        }else{
            print("主动断开不需要连接")
        }
    }
    func notDDDDD(){
        print("6...notDDDDD.......")
    }
    //MARK:end蓝牙协议代理-----------------<<<<<<<<<<<<<
    //SBGMBlueListViewDelegate
    func connectToPeripheral(_ peripheral: CBPeripheral) {
        //点击连接设备
        var deviceName = (peripheral.name! as NSString).replacingOccurrences(of: " \n", with: "")
        //去除空格
        let whitespace = CharacterSet.whitespacesAndNewlines
        var tempArray = deviceName.components(separatedBy: whitespace)
        tempArray = tempArray.filter{
            $0 != ""
        }
        deviceName = tempArray[0]
        self.title = deviceName
        self.currentPeripheralName = deviceName
        //连接中、。。。
        self.bleConnectHud = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.bleConnectHud?.textLabel.text = "连接中.."
        self.bleConnectHud?.show(in: UIApplication.shared.keyWindow, animated: true)
    
        self.btDiscoverySharedInstance?.clearDevices()
        self.btDiscoverySharedInstance?.connectToPeripheral(peripheral)//连接
        
        self.myPeripheral = peripheral
        UserDefaults.standard.set(peripheral.name, forKey: "LanYaName")
        UserDefaults.standard.set(false, forKey: "oneNo")
    }
    

    //MARK:设置导航栏按钮
    func addMenuVCBtn(){
        //自定菜单
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let leftBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        leftBtn.setImage(UIImage(named: "closeMore"), for: UIControlState())
        leftBtn.addTarget(self, action: #selector(SBMGViewController.btnAction(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        let item = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = item
        

        //帮助
        let (rightBtn2,Rspacer2,RbackItem2) = BGNetwork().creatRightHelpBtn()
        rightBtn2.addTarget(self, action: #selector(SBMGViewController.btnAction(_:)), for: UIControlEvents.touchUpInside)
        Rspacer2.width = 0
        rightBtn2.tag = 1
        
        self.navigationItem.rightBarButtonItems = [Rspacer2,RbackItem2]
        
        
     
    }
    

    //MARK:点击断开蓝牙，清除蓝牙数据
    func reservedBlueData(){
        
        
        self.fullTime = nil

        self.mySBMainView?.removeFromSuperview()
        self.mySBMainView = nil
        
        self.myCircleView?.removeFromSuperview()
        self.myCircleView = nil
        
        self.myFingerListView?.removeFromSuperview()
        self.myFingerListView = nil
        
        self.myFingerBGView?.removeFromSuperview()
        self.myFingerBGView = nil
        
        self.myFingerInputView?.removeFromSuperview()
        self.myFingerInputView = nil
        
        self.fingerBloodDataArray.removeAll()
        self.btDiscoverySharedInstance = nil
        
        self.discalimerView?.removeFromSuperview()
        self.discalimerView = nil
        
        self.myChartView?.removeFromSuperview()
        self.myChartView = nil
        
        self.chartBGView?.removeFromSuperview()
        self.chartBGView = nil

        self.currentChartView?.removeFromSuperview()
        self.currentChartView = nil

        self.allTimesNSTimer?.invalidate()
        self.allTimesNSTimer = nil

        self.comTimeoutTimer?.invalidate()
        self.comTimeoutTimer = nil

        self.lsqV?.removeFromSuperview()
        self.lsqV = nil

        self.sbInputView?.removeFromSuperview()
        self.sbInputView = nil

        self.historyView?.removeFromSuperview()
        self.historyView = nil


        self.initCountdownNSTimer?.invalidate()
        self.initCountdownNSTimer = nil
        self.logTimer?.invalidate()
        self.logTimer = nil


        self.stopMaxNSTimer?.invalidate()
        self.stopMaxNSTimer = nil

        self.bloodElectricDataArray.removeAllObjects()

        self.notTimeNSTimer?.invalidate()
        self.notTimeNSTimer = nil

        self.sbmgBlueListView?.removeFromSuperview()
        self.sbmgBlueListView = nil

        self.blueListTabView?.removeFromSuperview()
        self.blueListTabView = nil

        self.inLogTransfer = false
        self.blueConnectState = false

        //1.清除参比
        self.fingerBloodDataArray.removeAll()
        if !self.fingerBloodArraySorted.isEmpty{
            self.fingerBloodArraySorted.removeAll()
        }
        

        //3.清除蓝牙数据
        self.resetAllData()
        

        
        
    }
    
    func yunUpState() ->Bool{
        
        if(self.currentPeripheralName != nil && self.probeId != nil){
            return true
        }else{
            return false
            
        }
        
    }

    var yunHud: JGProgressHUD?
    
    //MARK:- 云存
    func syncAct(){
        //获取 状态
        let yunstate = self.yunUpState()
        var maxData:Int!
        var locatData:Int!
        
        
        if yunstate == true{
            
            self.yunHud = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
            self.yunHud?.textLabel.text = "云同步.."
            self.yunHud?.show(in: view, animated: true)
   
            let uid:String = String(ussssID)
            let reqUrl:String = "\(TEST_HTTP)/jsp/getsidcount.jsp"

            let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
            let codeMD5 = code.md5.uppercased()
            
            var dicDPost = NSDictionary()
            
            let (sid,_) = self.getSidTid()
            
            dicDPost = [
                "userid":uid,
                "sid":sid!,
                "clientid":CLIENTID,
                "random":RandoM,
                "code":codeMD5,
            ]

            
            RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
                
                let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
                
                
                self.yunHud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.yunHud?.textLabel.text = "同步完成"
                self.yunHud?.dismiss(afterDelay: 0.5, animated: true)
                
                if let tmpData:Int = json["data"].int{
                    maxData = tmpData
                    
                }
                print("服务器数据个数maxData-:\(maxData)")

                locatData = BloodSugarDB().selectAllDataCount()

                print("本地数据个数locatData－:\(locatData)")
                
                let locatTomaxData = locatData - maxData
                
                if (locatTomaxData > 0){

                    
                    if self.probeId != nil && self.probeId != "0" {
                        //计算完成后使用批量上传方式上传数据
                        self.uploadAllDataInBatch()
                    }

                }

                }, failure: { () -> Void in
                    
                    print("jsonYUN:-false")
                    
                    self.yunHud?.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.yunHud?.textLabel.text = "网络错误"
                    self.yunHud?.dismiss(afterDelay: 0.5, animated: true)
                    
            })
        }else{
            let alertView:UIAlertView = UIAlertView(title: "尚未连接设备", message: "请连接设备", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
        
    }
    
 
    
    func disconnectBlue(_ autoConnect: Bool){
        
        var name = ""
        var msg = ""
        if autoConnect {
            name = "是否断开连接"
            msg = "断开本次连接并重新连接"
        }else{
            name = "是否更换设备"
            msg = "将退出自动重连并重新搜索设备"
        }
        
        
        let actionSheet = UIAlertController(title: name, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
            if !autoConnect {
                //删除自动重连设备名
                UserDefaults.standard.removeObject(forKey: "LanYaName")
                UserDefaults.standard.setValue(true, forKey: "oneNo")
            }

            //置为可以不能自动重连
            self.btDiscoverySharedInstance?.connectState = false
            
            self.selfConncet = true
            //清除数据
            self.reservedBlueData()
            
            self.btDiscoverySharedInstance?.peripheralBLE = nil

            //蓝牙服务
            
            self.btDiscoverySharedInstance?.delegate = nil

            
            self.rightLogNameArray = ["","","","","",""]
 
            
            self.btDiscoverySharedInstance = nil
            
            self.navigationController!.popViewController(animated: false)
            
            
            
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    
    
    //其他事件回调
    func SBMainViewViewActClourse(_ tag: Int)->Void{
        
        switch tag {
        case 0:
            print("输入指血-->回调")

            self.fingerBloodPrintAct()
            

        case 1:
            print("添加事件-->回调")
            

            let statisticalVC = StatisticalViewController()

            self.navigationController?.pushViewController(statisticalVC, animated: true)
            
        case 2:
            print("上传数据-->回调")
            self.syncAct()
        case 3:
            print("查看趋势-->回调")
            self.getSameDayDate()
        case 4:
            
            print("查看数据-->回调")
            let informationVC = BloodListViewController(nibName: "BloodListViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(informationVC, animated: true)
        default:
            break
        }
        
        
    }
    

    
    func lsqViewTouchClourse(_ row: Int, name: String)->Void{
        print(row,name)
        
        
        switch name {
        case "更换设备":
            print("更换设备")
            
            self.disconnectBlue(false)
            
            
        case "断开连接":
            print("断开连接")
            
            let state = self.yunUpState()
            if state{ //连接上了设备
                self.disconnectBlue(true)
            }else{
                print("未连接设备")
                let alret = UIAlertView(title: "您还未连接上设备", message: "", delegate: nil, cancelButtonTitle: "确定")
                alret.show()
                
            }
            
        case "设备日志":
            print("设备日志")
            
            if !(self.rightLogNameArray[0].isEmpty){
                
                let logVC = SBMGLogViewController()
                logVC.timeArray = self.rightLogNameArray
                
                self.navigationController?.pushViewController(logVC, animated: true)
            }else{
                print("未连接设备")
                let alret = UIAlertView(title: "您还未连接上设备", message: "", delegate: nil, cancelButtonTitle: "确定")
                alret.show()
                
            }
        case "数据管理":
            print("数据管理")
            let informationVC = BloodListViewController(nibName: "BloodListViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(informationVC, animated: true)
        case "动态图谱":
            print("动态图谱")
            self.getSameDayDate()
            
            //recordsArray 血糖数据 ，dayArray 日期，deteilDayArray 详细日期
//            let (recordsArray,dayArray,deteilDayArray) =  SBMGSevice().getFMDBAllDays()
//            
//            
//            let currentScreenVC = CurrentScreenViewController()
//            
//            currentScreenVC.currentDay = dayArray.lastObject as! String  //天数
//            currentScreenVC.recDataArray = recordsArray //血糖数据
//            currentScreenVC.firstDay = deteilDayArray.lastObject as! String //详细日期
//            
//            currentScreenVC.dayArray = dayArray //日期数组
//            currentScreenVC.dayArrayCount = dayArray.count //一共有多少天
//            currentScreenVC.deteilDayArray = deteilDayArray //详细日期数组
//            
//            
//            //是否有参比，如果有，第一个参比
//            let (isFinger,firstFinger) = self.getFingerBlood()
//            
//            print(isFinger,firstFinger)
//            
//            currentScreenVC.isFinger = isFinger
//            currentScreenVC.fristFinger = firstFinger
//            
//            self.present(currentScreenVC, animated: true, completion: nil)
            
            
            
            
            
            
        case "提醒设置":
            let remindSetVC = RemindSetViewController()
            self.navigationController?.pushViewController(remindSetVC, animated: true)
        default:
            break
        }
        
        self.lsqV?.removeFromSuperview()
        self.lsqV = nil
        
    }
    
    
    //MARK:按钮点击事件
    func btnAction(_ send:UIButton){
        switch send.tag {
        case 0:
            //print("更多")


            if self.lsqV == nil{
                let list = [["更换设备","lsqExchange"],["断开连接","lsqDisConnect"],["设备日志","lsqTheLog"],["数据管理","lsqData"],["动态图谱","lsqChart"],["提醒设置","lsqRemind"]]
                lsqV = LsqView(listArray: list, frame: CGRect(x: 20, y: 20, width: 100, height: 141))
                lsqV?.backgroundColor = UIColor.clear
                
                lsqV?.touchClourse = self.lsqViewTouchClourse
                
                self.view.addSubview(lsqV!)
            }
     
        case 1:
            print("帮助")
            let sHelpVC = SHelpViewController()
            self.navigationController?.pushViewController(sHelpVC, animated: true)

        case 33001:
            print("点击输入参比")
            
            let state = self.yunUpState()
            
            if state {
                
                //重新获取历史指血数据
                if let preFingerBloodDataArray = UserDefaults.standard.object(forKey: "fingerBloodDataArray") as? [Any]{

                    //设置为有输入参比
                    self.firstFingerBloodDataInputed = true
                    self.fingerBloodDataArray.removeAll()
//                    self.fingerBloodDataArray.addObjects(from: preFingerBloodDataArray as [AnyObject])
                    self.fingerBloodDataArray += preFingerBloodDataArray
                }

                if self.startMonitorTimeStamp != nil {
                    //加载参比视图
//                    self.loadFingerView()
                    
                    
                    self.fingerBloodPrintAct()
                    
                }else{
                    print("请等待设备数据同步完成")
                }
                
                
            }else{
                print("还没有连接设备")
            }

        case 33004:
            print("取消输入参比")
            self.closeFingerView()
        case 33005:
            print("添加参比")
            //加载输入参比视图
  
            
            self.loadFingerInputView()
        case 33006:
            //print("提交参比")
            
            if self.fingerBloodDataArray.count > 0 {
                
                self.isShowBloodLow = true

                
                self.saveBlood = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.saveBlood?.textLabel.text = "计算血糖.."
                self.saveBlood?.show(in: self.view, animated: true)
                
                
                self.closeFingerView()
                
                
            }else{
                print("您还没有输入参比")
            }
  
            
        case 33007:
            print("指血输入关闭")
            //关闭指血输入视图
            self.closeFingerInputView()
        case 40501:
            print("设备列表关闭")
            
            self.myFingerBGView?.removeFromSuperview()
            self.myFingerBGView = nil
            
            
            self.sbmgBlueListView?.removeFromSuperview()
            self.sbmgBlueListView = nil
            
            
            self.resetAllData()
        case 406010:
            print("查看大图")

            self.closeCurrentChartView()
            
            //recordsArray 血糖数据 ，dayArray 日期，deteilDayArray 详细日期
            let (recordsArray,dayArray,deteilDayArray) =  SBMGSevice().getFMDBAllDays()
            
            
            let currentScreenVC = CurrentScreenViewController()
            
            currentScreenVC.currentDay = dayArray.lastObject as! String  //天数
            currentScreenVC.recDataArray = recordsArray //血糖数据
            currentScreenVC.firstDay = deteilDayArray.lastObject as! String //详细日期

            currentScreenVC.dayArray = dayArray //日期数组
            currentScreenVC.dayArrayCount = dayArray.count //一共有多少天
            currentScreenVC.deteilDayArray = deteilDayArray //详细日期数组

            
            //是否有参比，如果有，第一个参比
            let (isFinger,firstFinger) = self.getFingerBlood()
            
            print(isFinger,firstFinger)

            currentScreenVC.isFinger = isFinger
            currentScreenVC.fristFinger = firstFinger
            
            self.present(currentScreenVC, animated: true, completion: nil)
            
            
            
        default:
            break
        }
    }
    
    
    
    //MARK:输入指血接口
    func fingerBloodPrintAct(){
        
        calculateAndUploadQueue.async(execute: { () -> Void in
            
            
            var isShowPB = false
            
            //获取历史指血
            if let preFingerBloodDataArray:NSArray = UserDefaults.standard.object(forKey: "fingerBloodDataArray") as? NSArray{
                
                let current = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let curretnStr = formatter.string(from: current)
                
                var currentBloodCount = 0
                
                for item in preFingerBloodDataArray {
                    let tmpArray = item as! NSArray
                    
                    if let date = tmpArray[1] as? Date{
                        
                        let timeStr = formatter.string(from: date)
                        
                        //如果有当天的
                        if timeStr == curretnStr{
                            currentBloodCount += 1
                        }
                    }
                    
                }
                
                if currentBloodCount >= 1 {
                    isShowPB = true
                }else{
                    isShowPB = false
                }
   
            }else{
                isShowPB = false
            }
    
            if isShowPB {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    let alrtView = UIAlertController(title: "您今天输入指血次数过多，输入过多次数指血导致您的血糖曲线不准确，是否继续添加？", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alrtView.addAction(UIAlertAction(title: "继续添加", style: UIAlertActionStyle.destructive, handler: { (action:UIAlertAction) -> Void in
                        
                        //最小时间
                        let mins = Double(self.startMonitorTimeStamp)
                        let minDate = Date(timeIntervalSince1970: mins)
                        
                        var maxDate = Date()
                        if let tmpMaxDate = self.fullTime{
                            maxDate = tmpMaxDate
                        }else{
                            //最大时间
                            maxDate = SBMGSevice().getLastFMDBBloodTime() as Date
                        }

                        self.loadFingerBlood(0, animated: false, isEdit: false, index: nil, currentDate: nil, minDate: minDate, maxDate: maxDate)
   
                    }))
                    alrtView.addAction(UIAlertAction(title: "查看历史", style: UIAlertActionStyle.default, handler: { (alrte: UIAlertAction) in
                        
                        if self.historyView == nil {
                            self.historyView = SBHistoryFingerView()
                            self.historyView?.closeClourse = self.SBHistoryFingerViewCloseClourse
                            self.historyView?.deleteClourse = self.SBHistoryFingerViewDeleteClourse
                            self.historyView?.editFingerClourse = self.SBHistoryFingerViewEditFingerClourse
                            //获取历史指血
                            if let preFingerBloodDataArray = UserDefaults.standard.object(forKey: "fingerBloodDataArray") as? [Any]{
                                self.fingerBloodDataArray.removeAll()
                                self.fingerBloodDataArray += preFingerBloodDataArray
                            }
                            self.historyView?.initSBHistoryFingerView(self.fingerBloodDataArray)
                        }
                        
                    }))
                    alrtView.addAction(UIAlertAction(title: "取消添加", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alrtView, animated: true, completion: nil)
                })
                
            }else{
                
                DispatchQueue.main.async(execute: { () -> Void in
                    //最小时间
                    if self.startMonitorTimeStamp != nil{
                        let mins = Double(self.startMonitorTimeStamp)
                        let minDate = Date(timeIntervalSince1970: mins)
                        
                        var maxDate = Date()
                        if let tmpMaxDate = self.fullTime{
                            maxDate = tmpMaxDate
                        }else{
                            //最大时间
                            maxDate = SBMGSevice().getLastFMDBBloodTime() as Date
                        }
                        self.loadFingerBlood(0, animated: false, isEdit: false, index: nil, currentDate: nil, minDate: minDate, maxDate: maxDate)
                    }else{
                        let alrte = UIAlertView(title: "请先连接设备", message: "", delegate: nil, cancelButtonTitle: "确定")
                        alrte.show()
                    }
                })
            }
        })
    }
    

    func loadFingerBlood(_ scaleValue: Float,animated: Bool,isEdit: Bool,index: Int?,currentDate: Date?,minDate: Date?,maxDate: Date?){
        sbInputView = SBInputFingerView()
        sbInputView?.toCalculateClourse = self.SBInputFingerViewToCalculateClourse
 
        sbInputView?.initSBInputFingerView(scaleValue, animated: animated, isEdit: isEdit, index: index, currentDate: currentDate, minDate: minDate, maxDate: maxDate)
    }
    
    

    //添加
    func SBInputFingerViewToCalculateClourse(_ tag: Int,isEdit: Bool,fingerBloodArray: [Any]?,secIndx: Int?) -> Void{

        switch tag {
        case 0:
            print("取消")
        case 1:
            print("提交计算")
            if let data = fingerBloodArray {
                if isEdit {
                    print("编辑状态")
                    if let i = secIndx {
                        self.fingerBloodDataArray[i] = data[0]
                    }
                }else{
                    print("添加状态")
                    self.fingerBloodDataArray += data
                }
            }

            //对参比数据进行排序
            self.fingerBloodDataArray.sort(by: { (obj1, obj2) -> Bool in
                if Int(((obj1 as! NSArray)[1] as! Date).timeIntervalSince1970) > Int(((obj2 as! NSArray)[1] as! Date).timeIntervalSince1970) {
                    return false
                }else{
                    return true
                }
            })
 
            print(self.fingerBloodDataArray)
            //计算血糖
            
            //重新计算血糖值，
            
            self.saveBlood = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
            self.saveBlood?.textLabel.text = "计算血糖.."
            self.saveBlood?.show(in: self.view, animated: true)
            
            self.completeFingerBloodSubmit(false, count: nil)
            
        case 2:
            print("历史")
            
            if historyView == nil {
                historyView = SBHistoryFingerView()
                
                historyView?.closeClourse = self.SBHistoryFingerViewCloseClourse
                historyView?.deleteClourse = self.SBHistoryFingerViewDeleteClourse
                
                historyView?.editFingerClourse = self.SBHistoryFingerViewEditFingerClourse
  
                print(self.fingerBloodDataArray)
                
                //获取历史指血
                if let preFingerBloodDataArray = UserDefaults.standard.object(forKey: "fingerBloodDataArray") as? [Any]{
                    
                    self.fingerBloodDataArray.removeAll()
                    self.fingerBloodDataArray += preFingerBloodDataArray
                    print(self.fingerBloodDataArray)
                }

                self.historyView?.initSBHistoryFingerView(self.fingerBloodDataArray)
            }
            
        default:
            break
        }
        
        if self.sbInputView != nil {
            self.sbInputView = nil
        }
        
        
    }
    
    
    //历史按钮回调
    func SBHistoryFingerViewCloseClourse(_ tag: Int) -> Void{
        
        print("关闭 回调->\(tag)")
        switch tag {
        case 0:
            print("关闭")
            
        case 1:
            print("计算血糖")
            //计算血糖
            //重新计算血糖值，
            
            self.saveBlood = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
            self.saveBlood?.textLabel.text = "计算血糖.."
            self.saveBlood?.show(in: self.view, animated: true)
            
            self.completeFingerBloodSubmit(false, count: nil)
        case 2:
            print("添加指血")
            
            self.loadFingerBlood(0, animated: false, isEdit: false, index: nil, currentDate: nil, minDate: nil, maxDate: nil)
        default:
            break
        }
        if self.historyView != nil {
            self.historyView = nil
        }
        
    }
    
    
    //历史删除回调
    func SBHistoryFingerViewDeleteClourse(_ fingerBloodArray: [Any]) -> Void{
        
        self.fingerBloodDataArray.removeAll()
        self.fingerBloodDataArray += fingerBloodArray
        print(self.fingerBloodDataArray)
    }
    //历史编辑回调
    func SBHistoryFingerViewEditFingerClourse(_ index: Int,date: Date,fingerBlood: String) -> Void{
        print("编辑回调->\(index)-date->\(date)-blood->\(fingerBlood)")
        
        
        //最小时间
        let mins = Double(self.startMonitorTimeStamp)
        let minDate = Date(timeIntervalSince1970: mins)
        //最大时间
        let maxDate = SBMGSevice().getLastFMDBBloodTime()

        self.loadFingerBlood(Float(fingerBlood)!, animated: false, isEdit: true, index: index, currentDate: date, minDate: minDate, maxDate: maxDate as Date)
        
        if self.historyView != nil {
            self.historyView = nil
        }
        
    }
    
 
    //MARK:清除数据
    func resetAllData(){
        btDiscoverySharedInstance?.clearDevices()
        btDiscoverySharedInstance?.centralManager.stopScan()

        self.probeId = nil
        self.preCommand = nil
        self.currentCommand = nil

    }
    //MARK:蓝牙设备连接状态
    var blueConnectState:Bool = false
    
    //MARK:视图点击事件
    func viewTap(_ send:UITapGestureRecognizer){
        switch send.view!.tag {
        case 3300110:
            self.myFingerBGView?.removeFromSuperview()
            self.myFingerBGView = nil

        case 40502:
            print("点击蓝牙名字")
            
            self.blueNameAct(self.blueConnectState)
        case 406001:
            print("关闭图形视图")
            self.closeCurrentChartView()
            
        default:
            break
        }
    }
    
    func closeCurrentChartView(){
        
        self.chartBGView?.removeFromSuperview()
        self.chartBGView = nil
        
        self.myChartView?.removeFromSuperview()
        self.myChartView = nil
        
        self.currentChartView?.removeFromSuperview()
        self.currentChartView = nil
        
    }
    
    
    //是否为第一次连接
    var oneNo:Bool = true
    //MARK:蓝牙名点击事件
    func blueNameAct(_ state:Bool){
        if state {
            //连接中
            
            let actionSheet = UIAlertController(title: "是否断开连接", message: "将退出自动重连并重新搜索设备", preferredStyle: UIAlertControllerStyle.alert)
            actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in

                UserDefaults.standard.removeObject(forKey: "LanYaName")
                UserDefaults.standard.setValue(true, forKey: "oneNo")

                self.comTimeoutTimer?.invalidate()
                self.comTimeoutTimer = nil
                //置为可以不能自动重连
                self.btDiscoverySharedInstance?.connectState = false
                self.selfConncet = true
                //清除数据
                self.reservedBlueData()
                self.btDiscoverySharedInstance?.peripheralBLE = nil
                //初始化蓝牙服务
                self.btDiscoverySharedInstance?.delegate = nil
                self.btDiscoverySharedInstance = nil
                self.navigationController!.popViewController(animated: false)
                
            }))
            actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
            
        }else{
            //未连接
            
            if btDiscoverySharedInstance?.peripheralBLE == nil{
                btDiscoverySharedInstance?.startScanning()
                self.blueState = true
            }
            
   
        }
    }
    
   
    //MARK:创建 指血视图
    func loadFingerView(){
        if self.myFingerBGView == nil {
            self.myFingerBGView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height + 64))
            
            UIApplication.shared.keyWindow?.addSubview(self.myFingerBGView!)

            self.myFingerBGView?.backgroundColor = UIColor.black
            self.myFingerBGView?.alpha = 0.3

        }
        
        if self.myFingerListView == nil {
            self.myFingerListView = Bundle.main.loadNibNamed("FingerListView", owner: nil, options: nil)?.last as? FingerListView
            self.myFingerListView?.frame = CGRect(x: (self.view.frame.size.width - 260 * self.SBMGWsize) / 2, y: (self.view.frame.size.height - 312 * self.SBMGHsize) / 2 + 64, width: 260 * self.SBMGWsize, height: 312 * self.SBMGHsize)

            UIApplication.shared.keyWindow?.addSubview(self.myFingerListView!)
            
            
            self.myFingerListView?.saveW.constant = 120 * self.SBMGWsize
            self.myFingerListView?.canceW.constant = 121 * self.SBMGWsize
            self.myFingerListView?.BtnViewW.constant = 244 * self.SBMGWsize
            //添加点击事件
            //1.取消
            self.myFingerListView?.canceBtn.addTarget(self, action: #selector(SBMGViewController.btnAction(_:)), for: UIControlEvents.touchUpInside)
            self.myFingerListView?.canceBtn.tag = 33004
            //2.添加
            self.myFingerListView?.addBloodBtn.addTarget(self, action: #selector(SBMGViewController.btnAction(_:)), for: UIControlEvents.touchUpInside)
            self.myFingerListView?.addBloodBtn.tag = 33005
            //3.提交
            self.myFingerListView?.saveBtn.addTarget(self, action: #selector(SBMGViewController.btnAction(_:)), for: UIControlEvents.touchUpInside)
            self.myFingerListView?.saveBtn.tag = 33006
            
            //4.tabView
            self.myFingerListView?.bloodTabView.delegate = self
            self.myFingerListView?.bloodTabView.dataSource = self
            
        
            //5.圆角
            self.myFingerListView?.layer.cornerRadius = 4
            self.myFingerListView?.clipsToBounds = true
            
            
        }
    }
    
    //MARK:关闭指血视图
    func closeFingerView(){
        self.myFingerBGView?.removeFromSuperview()
        self.myFingerBGView = nil

        self.myFingerListView?.removeFromSuperview()
        self.myFingerListView = nil
    }
    //MARK:加载输入指血视图
    func loadFingerInputView(){
        if self.myFingerInputView == nil {
            self.myFingerInputView = Bundle.main.loadNibNamed("FingerInputView", owner: nil, options: nil)?.last as? FingerInputView
            self.myFingerInputView?.frame = CGRect(x: (self.view.frame.size.width - 260 * self.SBMGWsize) / 2, y: (self.view.frame.size.height - 312 * self.SBMGHsize) / 2 + 64, width: 260 * self.SBMGWsize, height: 312 * self.SBMGHsize)

            UIApplication.shared.keyWindow?.addSubview(self.myFingerInputView!)
            
            self.myFingerInputView?.delegate = self
            
            self.myFingerInputView?.closeBtn.addTarget(self, action: #selector(SBMGViewController.btnAction(_:)), for: UIControlEvents.touchUpInside)
            self.myFingerInputView?.closeBtn.tag = 33007
            
            //设置参比时间选择的min,max
            self.myFingerInputView?.setFingerInputViewDatePicker(Double(self.startMonitorTimeStamp))
            //设置圆角
            self.myFingerInputView?.layer.cornerRadius = 4
            self.myFingerInputView?.clipsToBounds = true
        }
    }
    //MARK:-关闭指血输入视图
    func closeFingerInputView(){
        self.myFingerInputView?.removeFromSuperview()
        self.myFingerInputView = nil
    }
    //MARK:指血输入视图代理 myFingerInputView.delegate
    func addNewFingerBlood(_ fingerBlood: Float, date: Date, index: Int) {

        let lastTime:Double = SBMGSevice().getLastFMDBDate()
        //print("数据库最后一条数据的时间戳：\(lastTime)")
        let today:Double = date.timeIntervalSince1970
        //print("输入的参比时间戳:\(today)")
        if today > lastTime{
            //print("输入的参比时间大于最后一条数据的时间")
            let alert = UIAlertView(title: "您输的参比时间超出范围", message: "", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }else{
            
            if index != -1 {
                //print("编辑的参比指血")
                self.fingerBloodDataArray[index] = [fingerBlood,date]
                
            }else{
                //print("新加的参比指血")
                self.fingerBloodDataArray.append([fingerBlood,date])
            }
            
            
            self.closeFingerInputView()
            
            self.myFingerListView?.bloodTabView.reloadData()
        }
  
        
    }
    //MARK:编辑参比指血
    //编辑指血参数
    var editBlood:Float!
    var editDate:Date!
    var editIndex:Int!
    
    func editFingerBlood(){

        self.loadFingerInputView()

        if self.editBlood != nil && self.editDate !=  nil && self.editIndex != nil {
            self.myFingerInputView?.record_fingerBlood = self.editBlood
            self.myFingerInputView?.record_date = self.editDate
            self.myFingerInputView?.record_index = self.editIndex
            self.myFingerInputView?.setupEditData()
        }
        
    }
    


    //MARK:TabView代理
    //Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.fingerBloodDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ddd = "BloodListCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? BloodListTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("BloodListTableViewCell", owner: self, options: nil )?.last as? BloodListTableViewCell
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        if(self.fingerBloodDataArray.count > 0){
            
            if let dataArray = self.fingerBloodDataArray[indexPath.row] as? [Any] {
                
                cell?.bloodNumLabel.text = "\(dataArray[0]) mmol/L"
                let recordDate:Date = dataArray[1] as! Date
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd/HH:mm"
                let timeStr = formatter.string(from: recordDate)
                
                cell?.dateLabel.text = "\(timeStr)"
                
            }
 
            
        }
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        return cell!
    }
    
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //编辑参比指血
        let fingerBloodRecord = self.fingerBloodDataArray[indexPath.row] as! [Any]
        self.editBlood = fingerBloodRecord[0] as! Float
        self.editDate = fingerBloodRecord[1] as! Date
        self.editIndex = indexPath.row
        
        self.editFingerBlood()
        self.myFingerListView?.bloodTabView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        //如果是指血输入列表，则允许删除
        if tableView == self.myFingerListView?.bloodTabView{
            return true
        }else{
            return false
        }
        
    }
    //MARK:- 删除历史指血
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //如果是指血输入列表，则进行删除操作
        if tableView == self.myFingerListView?.bloodTabView{
            if editingStyle == .delete {
                self.fingerBloodDataArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                print("删除指血操作")
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //解析接收到的数据
    func getMessageType(_ msg:[UInt8]){
        //验证数据长度
        
        print("msg:::------------------\(msg)")

        if msg.count >= 7{
            //确定是接收数据
            if msg[0] == 31{
                let type:UInt8 = msg[1]
                
                //指令回复
                if type >= 160{
                    switch type{
                    //时间同步指令
                    case 160:
                        print("时间同步指令")
                        self.timeSynced = true
                        cancelTimer(CommandType.syncTime)
                        //时间同步完成之后获取当前状态
                        self.commandCurrentStat()
                        break
                    //绑定命令
                    case 161:
                        print("2.绑定命令成功")

                        //重置为可以自动重连
                        btDiscoverySharedInstance?.connectState = true
                        self.selfConncet = false
                        cancelTimer(CommandType.connect)
                        //计算探针id
                        let probeId = SBMGSevice().parseSensorId(msg)
                        
                        print("探针id------->>>>>>:\(probeId)")
                        currentPhase = DevicePhase1.deviceInit
                        currentStep = DeviceStep1.checkInit
                        self.commandCurrentStat() //获取工作状态
                        print("3.发送获取工作状态")
                        
                        //设置时间
                        let curretnTime = SBMGSevice().getCurrentTime()
                        self.rightLogNameArray[1] = curretnTime
                        self.rightLogNameArray[2] = curretnTime

                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.loadMyStepsView(BlueStateType.connectionOK,time: nil)
                            if self.notFindBlueNSTimer != nil {
                                self.notFindBlueNSTimer.invalidate()
                                self.notFindBlueNSTimer = nil
                                self.iiiiiiiii = 0
                            }
                            self.blueConnectState = true
                            self.probeId = "\(probeId)"
                            
                            if self.currentPeripheralName != nil {
                                let name: String = "\(self.currentPeripheralName!)-\(probeId)"
                                print(name)
                                self.title = name
                            }
                            
                            //根据设备名跟探针id 判定是否删除历史数据跟参比数据
                            let BNMP:String = "\(self.currentPeripheralName)-\(probeId)"
                            
                            if let tmpbnmp:String = UserDefaults.standard.value(forKey: "bnmpkey") as? String{
                                print("历史探针id----------<<<<<<<<<<<:\(tmpbnmp)")
                                if tmpbnmp != BNMP {
                                    
                                    
                                    if self.probeId != nil && self.probeId != "0" {
                                        //删除数据库
                                        BloodSugarDB().deleteBloodSugar()
                                        //删除历史指血数据
                                        
                                        print("删除历史指血数据")
                                        UserDefaults.standard.removeObject(forKey: "fingerBloodDataArray")
                                        
                                        //永久保存蓝牙设备名跟探针
                                        UserDefaults.standard.set(BNMP, forKey: "bnmpkey")
                                        
                                        //删除提醒设置的时间
                                        UserDefaults.standard.removeObject(forKey: "remindUsersMaxTime")
                                        UserDefaults.standard.removeObject(forKey: "remindUsersMinTime")
                                        
                                    }else{
                                        print("探针为空或者为0")
                                        
                                        //清除数据
                                        self.reservedBlueData()
                                        self.btDiscoverySharedInstance?.peripheralBLE = nil
                                        //返回上级
                                        self.btDiscoverySharedInstance?.delegate = nil
                                        self.navigationController!.popViewController(animated: false)
                                    }
                                }
                            }else{
                                //永久保存蓝牙设备名跟探针
                                UserDefaults.standard.set(BNMP, forKey: "bnmpkey")
                            }
     
                            //获取历史指血
                            if let preFingerBloodDataArray = UserDefaults.standard.object(forKey: "fingerBloodDataArray") as? [Any]{
                                
                                print("##### 刚连接上，找到指血数据历史记录 #####")
                                //设置为有输入参比
                                self.firstFingerBloodDataInputed = true
                                self.fingerBloodDataArray.removeAll()
                                self.fingerBloodDataArray += preFingerBloodDataArray
                                self.mySBMainView?.setNumberBloodLabelValue(self.fingerBloodDataArray.count)
                                print("##### 刚连接上，指血数据历史记录处理结束 #####")
 
                                let current = Date()
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd"
                                let curretnStr = formatter.string(from: current)

                                var isShowBlood = false
                                
                                for item in preFingerBloodDataArray {
                                    let tmpArray = item as! [Any]
                                    if let date = tmpArray[1] as? Date{
                                        let timeStr = formatter.string(from: date)
                                        //如果有当天的
                                        if timeStr == curretnStr{
                                            isShowBlood = true
                                            break
                                        }
                                    }
                                }
                                
                                if !isShowBlood {
                                    //没有当天指血记录，提示输入指血视图弹出
                                    self.mySBMainView?.loadBloodPrompt()
                                }
                                
                                
                            }else{
                                //没有指血记录，提示输入指血视图弹出
                                self.mySBMainView?.loadBloodPrompt()
                            }
                            
                            
                            
                            if(self.startMonitorTimeStamp != nil){
                                
                                print("刚连接上，发现有起始时间")
                                
                                
                                let today:Double = Date().timeIntervalSince1970 //当前时间
                                let allJcTime:Int = Int(today) - self.startMonitorTimeStamp  //总监测时间 - 秒
                                
                                //设置总监测时间
                                if allJcTime < 3 * 60 * 60 {
                                    let (_,time) = SBMGSevice().setAllTimes(self.startMonitorTimeStamp, initState: true)

//                                    self.mySBMainView?.allTimeLabel.text = time
                                    
                                    self.mySBMainView?.setAllTime(time)
                                }else{
                                    
                                    
                                    self.allTimesNSTimer?.invalidate()
                                    self.allTimesNSTimer = nil
                                    
                                    
                                    self.allTimesNSTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SBMGViewController.setAllTimesShow), userInfo: nil, repeats: true)

                                }
                                
                                
                                
                            }

                            self.xcoun = 1
                        })

                        break
                    //改密命令
                    case 162:
                        print("改密命令 162")
                        
                        break
                    //结束检测
                    case 164:
                        print("结束检测 164")
                        break
                    //请求血糖数据
                    case 166:
                        print("接收到血糖数据 166")

                        if sendGetBloodData == true{
                            self.cancelTimer(CommandType.getBloodData)
                        }

                        //回复确认指令
                        self.commandSendComfirm()

                        //解析血糖
                        parseBloodData(msg)

                        break
                    //传输工作状态
                    case 169:
                        
                        let date = SBMGSevice().parseDate(msg)
                        print("消息时间：\(date)")
 
                        print("返回传输工作状态 - ")
                        
                        //发送确认指令（所有接收数据都进行确认）
                        self.commandSendComfirm()
                        
                        self.cancelTimer(CommandType.getStatus)
                        let statusType = msg[2]

                        switch statusType{
                        case 0:
                            print("刚启动")      //刚启动时候的状态
                            //MARK:-刚启动，
                            DispatchQueue.main.async(execute: { () -> Void in
                                
//                                self.sbmgNoteLabel.text = "设备启动中"
                                //－－－－－－－－－－－－－－
//                                self.topMainView.bloodNumLabel.text = "请稍后"
                            })
                            
                            break
                        case 2:
                            print("刚启动1分钟稳定之后初始化状态，7分钟")    //刚启动1分钟稳定之后初始化状态，7分钟
                            
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                

                                self.sevenInitState = true
                                
                                
                                let logTime:Date = SBMGSevice().parseDate(msg)
                                
                                //print("数据初始化时间：\(logTime)")
                                
                                if self.startSevenMinInitTimeStamp == nil{
                                    self.startSevenMinInitTimeStamp = Int(logTime.timeIntervalSince1970)
                                    
                                    self.loadMyStepsView(BlueStateType.initialize,time: self.startSevenMinInitTimeStamp)

                                    //发送工作状态
                                    self.commandCurrentStat()
                                }
    
                                
                            })

                            break
                        case 4:
                            print("检测中 4")
                            
                            readLogInfo()
                            
                            break
                        case 6:
                            //监测中 。
                            print("检测中 6")

                            readLogInfo()
                            
                            break
                        case 8:
                            print("检测结束 8")
                            
                            readLogInfo()
                            
                            break
                        case 10:
                            print("检测结束 10")
                            readLogInfo()
                            
                            break
                        case 12:
                            print("检测结束 12")
                            
                            readLogInfo()
                            
                            break
                        case 14:
                            print("检测结束 14")
                            readLogInfo()
                            
                            break
                        default:
                            
                            if inLogTransfer == false{
                                self.commandGetLog()
                                //设置主动请求日志标志
                                inLogTransfer = true
                            }
                            break
                        }
                        
                        break
                    //请求固件版本
                    case 171:
                        print("请求固件版本 171")
                        break
                    //请求发射器 ID
                    case 173:
                        print("4.收到发射器ID")

                        self.sensorId = SBMGSevice().parseDeviceId(msg)
                        
                        //MARK:- --------------
                        self.cancelTimer(CommandType.getDeviceId)

                        //获取工作日志
                        self.commandGetLog()
                        self.inLogTransfer = true
                        
                        break
                    //确认指令
                    case 174:
                        print("确认指令 174")
                        
                        break
                    default:
                        break
                    }
                    
                }else{
                    
                    print("4.返回工作日志")
                    
                    //日志返回
                    self.cancelTimer(CommandType.getLog)
                    
                    //每个日志都返回一个确认
                    self.commandSendComfirm()
                    
                    //每收到一个日志就重置一下计时器
                    //只有在主动请求日志的情况下

                    if inLogTransfer == true{
                        print("重置日志计时器")
                        
                        
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.logTimer?.invalidate()
                            self.logTimer = nil
                            
                            self.logTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(SBMGViewController.logTimerEndAction), userInfo: nil, repeats: false)
                        })
                        
                    }

                    switch type{
                    case 0:
                        print("日志-空白 0")
                        break
                    //绑定 命令
                    case 1:
                        print("日志-绑定成功 1")
                        break
                    //改密命令
                    case 2:
                        print("日志-时间同步 2")
                        
                        let data = SBMGSevice().parseDate(msg)
                        print("时间同步：\(data)")

                        break
                    //结束检测
                    case 3:
                        print("日志-更换传感器 3")
                        
                        break
                    //请求血糖数据
                    case 4:
                        print("日志-传感器初始化开始 4")
                        let logTime = SBMGSevice().parseDate(msg)
                        
                        self.startInitTimeStamp = Int(logTime.timeIntervalSince1970)
                        
                        let a = Int(logTime.timeIntervalSince1970)
                        print("传感器初始化开始时间:\(self.startInitTimeStamp)")
                        
                        
                        let dayTime = Date(timeIntervalSince1970: Double(a))
                        
                        
                        let jcT:String = String(describing: dayTime)
                        let year:String = (jcT as NSString).substring(to: 4)
                        print("year:\(year)")
                        //发送时间同步指令
                        let yearInt = Int(year)
                        if (tongbuTime == true){
                            tongbuTime = false
                            if (yearInt == 1970){
                                
                                print(">>>>>>>>>>>>>>发送时间同步")
                                self.commandSyncTime()
                                
                            }else{
                                //MARK:- 开始监测时间
                                self.startMonitorTimeStamp = Int(logTime.timeIntervalSince1970) + 10 * 60
                                
//                                self.commandSyncTime()
                            }
                        }
                        
                        
                        
                        break
                    //传输工作状态
                    case 5:
                        print("日志-传感器初始化结束\n", terminator: "")

                        break
                    //请求固件版本
                    case 6:
                        print("日志-开始监测\n", terminator: "")
                        //获取开始检测时间并记录

                        DispatchQueue.main.async(execute: { () -> Void in

                            let logTime = SBMGSevice().parseDate(msg)
                            
                            print("6.日志-开始监测 时间\(logTime)")

                            
                            let jcT:String = String(describing: logTime)
                            let year1:String = (jcT as NSString).substring(to: 4)
                            print("6.日志-开始监测 年份:\(year1)")
                            
                            
                            if year1 == "1970" {
                                
                                print(">>>>>起始时间不对>>>>>>>>>发送时间同步")
                                self.commandSyncTime()
                                
                                
                            }else{
                                
                                print(">>>>>>>起始时间正确<<<<<<<<<<保存")
                                
                                self.sevenInitState = false
                                
                                //MARK:-赋值1
                                self.startMonitorTimeStamp = Int(logTime.timeIntervalSince1970)
                                
                                self.loadMyStepsView(BlueStateType.polarization,time: self.startMonitorTimeStamp)
                                
                                //赋值给全局，为后面图像数据对比做准备
                                startUseTime = self.startMonitorTimeStamp
                                
                                //赋值
                                startTimeIn = Double(self.startMonitorTimeStamp)
                                
                                
                                print("获取到起始监测时间:\(self.startMonitorTimeStamp)")
                                
                                //永久保存开始检测时间，适配两种设备的通讯协议
                                
                                if self.currentPeripheralName != nil && self.probeId != nil{
                                    
                                    let time = Date(timeIntervalSince1970: Double(self.startMonitorTimeStamp))
                                    print("永久保存起始的时间。。。 startMonitorTimeStamp-->>>\(time)")
                                    
                                    let key:String = "\(self.currentPeripheralName)-\(self.probeId)"
                                    
                                    UserDefaults.standard.setValue(self.startMonitorTimeStamp, forKey: key)
                                    
                                }
                                
                                
                                if self.initCountdownNSTimer == nil{
                                    let (finished, remainTime) = SBMGSevice().calculateInitTime(self.startMonitorTimeStamp)
                                    
                                    
                                    if finished == false{

                                        LocalNotificationUtils().addPolarizationEndNotification(Double(remainTime))
 
                                    }
                                    
                                    if self.startMonitorTimeStamp != nil{
                                        let (finished, _) = SBMGSevice().calculateInitTime(self.startMonitorTimeStamp)
                                        
                                        if finished == false{

                                        }else{
                                            //180分钟极化完成
                                            
                                            self.loadMyStepsView(BlueStateType.compPolarization,time: 1)

                                            //显示指血输入
                                            
                                            
                                            self.initCountdownNSTimer?.invalidate()
                                            self.initCountdownNSTimer = nil
                                            
                                            
                                            
                                        }
                                        
                                    }
                                    
                                  
                                }
                                
                                
                                
                            }
                            
      
                            
                        })

                        break
                    //请求发射器 ID
                    case 7:
                        print("日志-结束检测\n", terminator: "")
                        break
                    //确认指令
                    case 8:
                        print("日志-改密\n", terminator: "")
                        
                        break
                    case 9:
                        print("日志-掉电\n", terminator: "")
                        
                        break
                    case 15:
                        print("日志-报警汇总\n", terminator: "")
                        
                        break
                    default:
                        break
                    }
                    
                }
            }else{
                //println("@@@@ 血糖后续数据 @@@@")
                //MARK:- 1682
                if bloodDataTmp != nil{
                    bloodDataTmp = bloodDataTmp + msg
                    parseBloodData(bloodDataTmp)
                }
                
            }
            
        }else{
            print("收到部分*********")
            if bloodDataTmp != nil{
                bloodDataTmp = bloodDataTmp + msg
                parseBloodData(bloodDataTmp)
            }

        }
        
    }

    
    
    
    func cancelTimer(_ commandType:CommandType){
        
        if currentCommand.hashValue == commandType.hashValue{
            self.comTimeoutTimer?.invalidate()
            self.comTimeoutTimer = nil
        }
  
    }
    

    
    func saveSomeDate1(){
        
        print("---------------->>>>>>>>>>>>>>>>开始保存数据1")
        calculateAndUploadQueue.async(execute: { () -> Void in
            
            
            //设置时间
            let curretnTime = SBMGSevice().getCurrentTime()

            self.rightLogNameArray[4] = curretnTime

            let keyArray: [Any] = self.bloodElectricDataArray.allKeys
            
            
            var bloodArray = [AnyObject]()
            
            for tmpKey in keyArray {
                let timeOffset = tmpKey as! Int
                if let dataDic = self.bloodElectricDataArray[timeOffset] as? [String:Any] {
                    
                    let bloodElectricData = dataDic["electricData"] as! Int
                    let bsm = BloodSugarModel()
                    bsm.glucose = "0"
                    bsm.current = "\(bloodElectricData)"
                    bsm.timeStamp = "\(timeOffset)"
                    bloodArray.append(bsm)
                }
            }
            BloodSugarDB().deleteBloodSugar()
            //完成后批量存储
            BloodSugarDB().batchInsertData(bloodArray, withBatchInserFinish: {
                self.bloodElectricDataArray = NSMutableDictionary()
                print("清空数据字典")
            })
 
            //判断是否有输入参比指血
            //只在第一次指血数据输入后才处理
            if self.firstFingerBloodDataInputed == true{
                
                print("有输入参比指血，批量计算")
                
                if self.yunUpState(){ //连接上了设备
                    self.isShowBloodLow = false
                    //重新获取历史指血数据
                    if let preFingerBloodDataArray = UserDefaults.standard.object(forKey: "fingerBloodDataArray") as? [Any]{
                        //设置为有输入参比
                        self.firstFingerBloodDataInputed = true
                        self.fingerBloodDataArray.removeAll()
                        self.fingerBloodDataArray += preFingerBloodDataArray
                        
                        self.completeFingerBloodSubmit(false, count: nil)
                    }else{
                        print("没有指血记录，放弃计算")
                    }
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    print("回到主线程1")
   
                    if self.setBlood != nil{
                        self.setBlood!.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.setBlood!.textLabel.text = "计算完成"
                        self.setBlood!.dismiss(afterDelay: 1.0, animated: true)
                        self.setBlood = nil
                    }
   
                    self.comTimeoutTimer?.invalidate()
                    self.comTimeoutTimer = nil
   
                    //设置时间
                    let curretnTime = SBMGSevice().getCurrentTime()
                    
                    self.rightLogNameArray[5] = curretnTime

                    //只有在第一次的时候才弹出提示框
                    if let sbmgGuide = UserDefaults.standard.value(forKey: "SBMGGuide") as? Bool{
                        
                        if !sbmgGuide{
                            
                            if self.mySBMainView != nil{
                                
                                self.mySBMainView?.loadSBMGGuidView()
                                
                                UserDefaults.standard.setValue(true, forKey: "SBMGGuide")
                                
                            }
                        }
                        
                    }else{
                        
                        if self.mySBMainView != nil{
                            
                            self.mySBMainView?.loadSBMGGuidView()
                            
                            UserDefaults.standard.setValue(true, forKey: "SBMGGuide")
                            
                        }
                        
                    }
                    
                    
                })
      
            }else{
                
                //没有参比，直接上传
                if self.probeId != nil && self.probeId != "0" {
                    //计算完成后使用批量上传方式上传数据
                    self.uploadAllDataInBatch()
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    print("回到主线程2")

                    if self.setBlood != nil{
                        self.setBlood!.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.setBlood!.textLabel.text = "操作完成"
                        self.setBlood!.dismiss(afterDelay: 1.0, animated: true)
                        self.setBlood = nil
                    }
                    
                    

                    
                    self.comTimeoutTimer?.invalidate()
                    self.comTimeoutTimer = nil
                    
                    //没有输入参比
                    
                    let (finished, _) = SBMGSevice().calculateInitTime(self.startMonitorTimeStamp)
                    
                    if finished == false{
//                        self.loadMyStepsView(BlueStateType.compPolarization,time: -1)
                    }else{
                        //180分钟极化完成
                        
                        self.loadMyStepsView(BlueStateType.compPolarization,time: -1)
                    
                    }
                    
                    //设置时间
                    let curretnTime = SBMGSevice().getCurrentTime()

                    self.rightLogNameArray[5] = curretnTime

                    let (_,_,fullTime) = self.getLastFMDBBloodData()
                    self.fullTime = fullTime
  
                    
                })
                
                
                
            }

            
        })
     
        
    }
    

  
    //MARK:-解析血糖数据
    func parseBloodData(_ msg:[UInt8]){
        
  
        if msg.count > 0 {
            //确定是血糖数据起始
            if msg[0] == 0x1f && msg[1] == 0xa6{
                
                let startNum:Int = SBMGSevice().byteArrayToStr([msg[4],msg[3]]).hexaToDecimal
                let stopNum:Int = SBMGSevice().byteArrayToStr([msg[6],msg[5]]).hexaToDecimal
                
                print("##### \(Date()) :  血糖数据： \(startNum) ~ \(stopNum) #######")
 
                
                //血糖数据每6分钟两个，三分钟一个
                
                //暂存血糖数据，以防有后续数据出现
                self.bloodDataTmp = msg

                //只有在记录可起始检测时间的情况下才处理血糖数据
                if self.startMonitorTimeStamp != nil {
       
                    if stopNum - startNum + 1 > 2 {
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            
                            self.notTimeNSTimer?.invalidate()
                            self.notTimeNSTimer = nil
                            
                            if self.stopMaxNSTimer != nil{
                                self.stopMaxNSTimer!.invalidate()
                                self.stopMaxNSTimer = nil
                            }
    
                            self.stopMaxNSTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(SBMGViewController.saveSomeDate1), userInfo: nil, repeats: false)
                            
                            if self.setBlood == nil{
                                self.setBlood = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                                self.setBlood?.textLabel.text = "同步数据"
                                self.setBlood?.show(in: self.view, animated: true)
                            }
                            
   
                        })
                    }

                    //计算并检查数据长度是否正确
                    let dataCount = stopNum - startNum + 1
                    let totalLength = 8 + dataCount * 2
 
                    
                    if bloodDataTmp.count == totalLength{

                        self.bloodDataTmp = nil
                        var dataArray = msg[7...(totalLength - 1)]
                        let dataCount = dataArray.count / 2

                        for i in (1...dataCount){
                            let str = SBMGSevice().byteArrayToStr([dataArray[i*2 - 1 + dataArray.startIndex],dataArray[i*2 - 2 + dataArray.startIndex]])
                            let bloodElectricData = str.hexaToDecimal
                            let sequenceNum = startNum + (i - 1)
                            let timeOffset = startMonitorTimeStamp + sequenceNum * 3 * 60   //开始监控时间 + 血糖序列号 * 3分钟
                            //保存原始电流数据
                            
                            if bloodElectricDataArray[timeOffset] == nil{
                                //判断数据时间是否正常？
                                let isTrue = SBMGSevice().checkTheTimeIsTrue(Double(timeOffset))
                                if isTrue { //时间不为1970
                                    //print("保存原始电流数据")
                                    bloodElectricDataArray[timeOffset] = ["time":timeOffset, "electricData":bloodElectricData]
                                }
                                
                            }else{
                                print("重复添加原始数据")
                            }
                            
                            if (dataCount == 2 || dataCount == 1){
                                //判断电流是否合法
                                let isCorrect = RemindUsers().currentIsCorrect(bloodElectricData)
                                if !isCorrect {
                                    print("&&&&&&+++++++++++----->>>>>>>电流不在范围内，报警！")
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        self.myCurretnAlrtView = UIAlertController(title: "电流值异常", message: "电流值超出正常范围，电流正常范围为8000-65530，请联系医护人员重新更换传感器，客服电话：4008-059-359", preferredStyle: UIAlertControllerStyle.alert)
                                        self.myCurretnAlrtView.addAction(UIAlertAction(title: "我知道了", style: UIAlertActionStyle.cancel, handler: nil))
                                        self.present(self.myCurretnAlrtView, animated: true, completion: nil)
 
                                    })
                                    
                                    
                                }
                            }
    
                            //只在第一次指血数据输入后才处理
                            if firstFingerBloodDataInputed{
                                
                                if (dataCount == 2 || dataCount == 1){
        
                                    //判断数据时间是否正常？
                                    let isTrue = SBMGSevice().checkTheTimeIsTrue(Double(timeOffset))
                                    
                                    if isTrue {
                                        
                                        let bsM = BloodSugarModel()
                                        
                                        bsM.glucose = "0"
                                        bsM.current = "\(bloodElectricData)"
                                        bsM.timeStamp = "\(timeOffset)"
                                        
                                        BloodSugarDB().insert(bsM, withInserFinish: {
                                            
                                        })
                                        self.oneoneoneBloodCount += 1
                                        //当数据接收完毕
                                        if self.oneoneoneBloodCount == dataCount{
                                            if self.yunUpState(){ //连接上了设备
                                                self.isShowBloodLow = false
                                                //重新获取历史指血数据
                                                if let preFingerBloodDataArray = UserDefaults.standard.object(forKey: "fingerBloodDataArray") as? [Any]{
                                                    //设置为有输入参比
                                                    self.firstFingerBloodDataInputed = true
                                                    self.fingerBloodDataArray.removeAll()
                                                    self.fingerBloodDataArray += preFingerBloodDataArray
                                                    self.completeFingerBloodSubmit(true, count: dataCount)
                                                }else{
                                                    print("没有指血记录，放弃计算")
                                                }
                                            }
                                            self.oneoneoneBloodCount = 0
                                        }
                                    }
                                }
                            }else
                            {
                                if (dataCount == 2 || dataCount == 1)
                                {
                                    //判断数据时间是否正常？
                                    let isTrue = SBMGSevice().checkTheTimeIsTrue(Double(timeOffset))
                                    
                                    if isTrue
                                    {
                                        print("保存没有参比的电流")
                                        let bsM = BloodSugarModel()
                                        
                                        bsM.glucose = "0"
                                        bsM.current = "\(bloodElectricData)"
                                        bsM.timeStamp = "\(timeOffset)"
                                        
                                        BloodSugarDB().insert(bsM, withInserFinish: {
                                            
                                        })
                                        
                                        let (_,_,fullTime) = self.getLastFMDBBloodData()
                                        self.fullTime = fullTime
                                        
                                        if self.probeId != nil
                                        {
                                            print("上传没有参比的电流")
                                            let (sid, tid) = self.getSidTid()
                                            
                                            if sid != nil && tid != nil {
                                                
                                                let code:String = "\(ussssID)_\(CLIENTID)_\(KEY)_\(RandoM)"
                                                let codeMD5 = code.md5.uppercased()
                                                
                                                BGNetwork().uploadBloodGlucoseData(String(ussssID), bloodGlucose: "0", time: Date(timeIntervalSince1970: Double(timeOffset)), sid: sid!, tid: tid!, bloodElectricData: bloodElectricData, clientid: CLIENTID, random: RandoM, code: codeMD5, onComplete: { (finished, reason) in
                                                    print("无参比单条上传成功")
                                                    }, onError: { (error) in
                                                        print("uploadBloodGlucoseData ERROR: \(error)")
                                                })
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        print("解析－－－－数据不正确")
                    }
                }else{
                    print("没有startMonitorTimeStamp")
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        self.notTimeNSTimer?.invalidate()
                        self.notTimeNSTimer = nil
                        
                        
                        self.notTimeNSTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(SBMGViewController.sendWorkLog), userInfo: nil, repeats: false)
                        
                    })
                    
                    
                    
                }
                
                
            }
        }
    }
 
    func sendWorkLog(){
       
        
        //再次校对是否有起始时间
        if self.startMonitorTimeStamp == nil {
             print("***校对设备在没有获取到起始时间***获取工作日志")
            
            self.notTimeNSTimer?.invalidate()
            self.notTimeNSTimer = nil
            
            
            //返回上级
            //清除数据
            self.reservedBlueData()
            btDiscoverySharedInstance?.peripheralBLE = nil
            btDiscoverySharedInstance?.delegate = nil
            self.navigationController!.popViewController(animated: false)
            
            
        }else{
            print("不过找到了起始时间啦")
            self.notTimeNSTimer?.invalidate()
            self.notTimeNSTimer = nil
        }
        
 
        
    }
    
    
    func getSidTid() -> (String?, String?){
        
        
        var sid: String?
        var tid: String?
        
        if let currentName = self.currentPeripheralName {
            let psid = currentName.components(separatedBy: "-")[1]
        
            sid = "\(psid)-\(self.probeId!)"
            
            tid = currentName
        }

        return (sid,tid)
    }
    
    
    func readLogInfo(){
        
        if inLogTransfer == false{

            self.commandGetLog()
            //设置主动请求日志标志
            inLogTransfer = true

        }
    }

    //MARK:-获取本地 开始监测时间
    func logTimerEndAction(){
        print("@@@@@@@@@@@日志读取完毕@@@@@@@@@@")
        //获取历史指血
        if let preFingerBloodDataArray = UserDefaults.standard.object(forKey: "fingerBloodDataArray") as? [Any]{
            
            print("##### 找到指血数据历史记录 #####")
            //设置为有输入参比
            self.firstFingerBloodDataInputed = true
            self.fingerBloodDataArray.removeAll()
            self.fingerBloodDataArray += preFingerBloodDataArray
            //创建一个临时参比数组，对参比数据进行排序
            self.fingerBloodArraySorted = [Any]()
            self.fingerBloodArraySorted += self.fingerBloodDataArray
            //对参比数据进行排序
            self.fingerBloodArraySorted.sort(by: { (obj1, obj2) -> Bool in
                
                if Int(((obj1 as! [Any])[1] as! Date).timeIntervalSince1970) > Int(((obj2 as! [Any])[1] as! Date).timeIntervalSince1970) {
                    return false
                }else{
                    return true
                }
            })
            print("##### 指血数据历史记录处理结束 #####")
   
        }
        
        if(self.startMonitorTimeStamp != nil){
            let today:Double = Date().timeIntervalSince1970 //当前时间
            let allJcTime:Int = Int(today) - self.startMonitorTimeStamp  //总监测时间 - 秒
            
             //设置总监测时间
            if allJcTime < 3 * 60 * 60 {
                let (_,time) = SBMGSevice().setAllTimes(self.startMonitorTimeStamp, initState: true)
                self.mySBMainView?.setAllTime(time)
            }else{
                
                self.allTimesNSTimer?.invalidate()
                self.allTimesNSTimer = nil
                
                self.allTimesNSTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SBMGViewController.setAllTimesShow), userInfo: nil, repeats: true)
            }
   
        }
 
        
        self.logTimer?.invalidate()
        self.logTimer = nil
        
        inLogTransfer = false
        
        
        if self.sevenInitState == true { //7分钟极化中
            self.commandCurrentStat()
        }else{
            //日志传输结束后请求血糖数据
            self.commandGlucoseValue()
            sendGetBloodData = true
        }
  
    }
    
    
    
    func setAllTimesShow(){

        let time = SBMGSevice().allTimeNsTimerAction(self.startMonitorTimeStamp, jihuaYN: false)
        
        self.mySBMainView?.setAllTime(time)
    }


    //MARK:- 计算血糖 ,参比
    func completeFingerBloodSubmit(_ isASingle: Bool,count: Int?) {
        print("提交参比，计算血糖")
        
        calculateAndUploadQueue.async(execute: { () -> Void in
            
            if self.fingerBloodDataArray.count > 0 {
                
                //永久保存fingerBloodArray
                UserDefaults.standard.set(self.fingerBloodDataArray, forKey: "fingerBloodDataArray")
                

                //获取原始电流数据并对其排序
                var recordsArray:[AnyObject] = BloodSugarDB().selectAll() as [AnyObject]
                //判断是否有数据
                if (recordsArray.count > 0){
                    
                    //初始化血糖转换算法模块
                    BGC_Init()
                    
                    //创建一个临时参比数组，对参比数据进行排序
                    self.fingerBloodArraySorted = [Any]()
                    self.fingerBloodArraySorted += self.fingerBloodDataArray
                    //对参比数据进行排序

                    self.fingerBloodArraySorted.sort(by: { (obj1, obj2) -> Bool in
                        if Int(((obj1 as! NSArray)[1] as! Date).timeIntervalSince1970) > Int(((obj2 as! NSArray)[1] as! Date).timeIntervalSince1970) {
                            return false
                        }else{
                            return true
                        }
                    })
                    
                    

                    self.updateFingerBloodArray.removeAll()
                    for tmpA in self.fingerBloodDataArray{
                        let ix = tmpA as! [Any]
                        let d:Float = Float(ix[0] as! String)!
                        let t:Date = ix[1] as! Date
                        let time:Double = t.timeIntervalSince1970
                        let timeInt:Int = Int(time)
                        var dic = NSDictionary()
                        dic = [
                            "d":d,
                            "t":timeInt
                        ]
                        
                        self.updateFingerBloodArray.append(dic)
                    }
                    
                    recordsArray = recordsArray.sorted(by: { (obj1, obj2) -> Bool in
                        let b = obj1 as! BloodSugarModel
                        let a = obj2 as! BloodSugarModel
                        
                        if Int(a.timeStamp)! > Int(b.timeStamp)! {
                            return false
                        }else{
                            return true
                        }
                    })
 
                    var bloodArray = [AnyObject]()
                    for tmp in recordsArray {
                        
                        let tmpBSM = tmp as! BloodSugarModel
                        
                        let current:Int = Int(tmpBSM.current)!
                        
                        let timeStamp:Int = Int(tmpBSM.timeStamp)!
                        
                        //计算
                        let (_, convertResult): (Bool, _sConvertResult_t) = self.processBloodElectricData(current, timeOffset: timeStamp, upload: false)
                        
                        let bsm = BloodSugarModel()
                        
                        let displayResult:Float = Float(convertResult.bg) / 1000
                        let bloodNumber = Double(displayResult)
                        let bloodNumberRounded = NSString(format: "%.1f", bloodNumber)
                        
                        bsm.glucose = "\(bloodNumberRounded)"
                        bsm.current = "\(current)"
                        bsm.timeStamp = "\(timeStamp)"
                        bloodArray.append(bsm)
                    }

                    //删除数据库
                    BloodSugarDB().deleteBloodSugar()
                    
                    //完成后批量存储
                    BloodSugarDB().batchInsertData(bloodArray, withBatchInserFinish: {
                        
                    })
                    if self.probeId != nil && self.probeId != "0" {
                        
                        if isASingle {
                            
                            
                            if let dataCount = count {
                                
                                
                                print("上传单条参比的电流血糖")
                                
                                let lastSomeDataArray = SBMGSevice().getLastSomeData(dataCount)
                                
                                
                                let (sid, tid) = self.getSidTid()
                                
                                if sid != nil && tid != nil{
                                    
                                    let code:String = "\(ussssID)_\(CLIENTID)_\(KEY)_\(RandoM)"
                                    let codeMD5 = code.md5.uppercased()
                                    
                                    for index in lastSomeDataArray {
                                        let bloodmoder = index as! BloodSugarModel
                                        let blood = bloodmoder.glucose
                                        let current:Int = Int(bloodmoder.current)!
                                        let time:Int = Int(bloodmoder.timeStamp)!
                                        //提醒设置
                                        RemindUsers().setRemindAndSendSomeInformation(Double(time), bloodSugar: Float(blood! as String)!)
                                        
                                        BGNetwork().uploadBloodGlucoseData(String(ussssID), bloodGlucose: blood!, time: Date(timeIntervalSince1970: Double(time)), sid: sid!, tid: tid!, bloodElectricData: current, clientid: CLIENTID, random: RandoM, code: codeMD5, onComplete: { (finished, reason) in
                                            print("有参比单条上传成功")
                                            }, onError: { (error) in
                                                print("uploadBloodGlucoseData ERROR: \(error)")
                                        })
                                        
                                    }
                                }
                                
                            }
                            
                        }else{
                            print("上传批量")
                            self.upFingerBlood() //计算完成后上传 参比指血
                            self.uploadAllDataInBatch()//计算完成后使用批量上传方式上传数据
                        }
                    }
                    
                    //MARK:-获取HbA1c 值
                    let (sid,_) = self.getSidTid()
                    if sid != nil{
                        MyNetworkRequest().getHbA1c(sid!, clourse: { (hba1c) in
                            self.mySBMainView?.setHbA1cLabelValue(hba1c)
                        })
                    }

                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        //清除 步骤视图
                        self.removeMyCircleView()
                        
                        //清除录入指血提示视图
                        if let preFingerBloodDataArray = UserDefaults.standard.value(forKey: "fingerBloodDataArray") as? [Any]{
                            
                            let current = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            let curretnStr = formatter.string(from: current)
                            print(curretnStr)
                            
                            var isShowBlood = false
                            
                            for item in preFingerBloodDataArray {
                                let tmpArray = item as! [Any]

                                if let date = tmpArray[1] as? Date{
                                    
                                    let timeStr = formatter.string(from: date)
 
                                    if timeStr == curretnStr{
                                        isShowBlood = true
                                        break
                                    }
                                }
                                
                            } 
                            
                            if isShowBlood {
                                //有当天指血记录，提示输入指血视图移除
                                self.mySBMainView?.dismissBloodPrompt()
                            }else{
                                //没有，继续弹出
                                self.mySBMainView?.loadBloodPrompt()
                            }
    
                        }
                        
                        self.mySBMainView?.setNumberBloodLabelValue(self.fingerBloodDataArray.count)
                        
                        self.saveBlood?.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.saveBlood?.textLabel.text = "计算完成"
                        self.saveBlood?.dismiss(afterDelay: 1.0, animated: true)
                        self.saveBlood = nil
                        
 
                        //获取最后一个数据
                        let (blood,_,fullTime) = self.getLastFMDBBloodData()
                        self.fullTime = fullTime
                        
                        //只有在提交参比的时候才提示
                        if self.isShowBloodLow == true {
                            if blood == "0.0" {
                                let alert = UIAlertView(title: "您输入的指血不在范围之内", message: "", delegate: nil, cancelButtonTitle: "确定")
                                alert.show()
                            }
                        }

                        self.onceAgainSetSomeValue()
                        
                        
                        //根据血糖浓度，改变笑脸，表盘
                        let bloodAnyWill:Int = Int(Double(blood)! * 10)
                        self.mySBMainView?.setImgCly(bloodAnyWill)
                        
                        //只有在第一次的时候才弹出提示框,引导
                        if let sbmgGuide = UserDefaults.standard.value(forKey: "SBMGGuide") as? Bool{
                            
                            if !sbmgGuide{ //此处应为 false
                                
                                
                                if self.mySBMainView != nil{
                                    
                                    self.mySBMainView?.loadSBMGGuidView()
                                    
                                    UserDefaults.standard.setValue(true, forKey: "SBMGGuide")
                                    
                                }
                            }
     
                        }else{
                            
                            if self.mySBMainView != nil{
                                
                                self.mySBMainView?.loadSBMGGuidView()
                                
                                UserDefaults.standard.setValue(true, forKey: "SBMGGuide")
                                
                            }
                            
                            
                            
                        }
   
                            
                        LocalNotificationUtils().addAtSevenClockNotification()
                        
  
                    })
                    

                }else{
                    print("还没有数据呢")
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        self.saveBlood?.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.saveBlood?.textLabel.text = "计算完成"
                        self.saveBlood?.dismiss(afterDelay: 1.0, animated: true)
                        self.saveBlood = nil
                        
                    })
                    
                }
   
   
            }else{
                
                let alret = UIAlertView(title: "您还没有输入指血", message: "请添加一个指血", delegate: nil, cancelButtonTitle: "确定")
                alret.show()
                
                
            }
  
        })
  
    }
    
    //上传参比指血
    func upFingerBlood(){
        
        let jsonStringArray:[NSString] = self.canbiUploadJson()
        
        let mutableOperations:NSMutableArray = NSMutableArray()
        
        for jsonString:NSString in jsonStringArray{
            
            let manager = AFHTTPRequestOperationManager()
            
            manager.responseSerializer.acceptableContentTypes  = nil
            
            let reqUrl:String = "\(TEST_HTTP)/jsp/updateRef.jsp"

            let urlRequest = NSMutableURLRequest(url: URL(string: reqUrl)!)
            
            urlRequest.httpMethod  = "POST"
            urlRequest.httpBody = jsonString.data(using: String.Encoding.utf8.rawValue)
            
            let getOperation = AFHTTPRequestOperation(request: urlRequest as URLRequest!)
            
            getOperation?.responseSerializer = AFHTTPResponseSerializer()
            
            mutableOperations.add(getOperation!)
            
        }
        
        
        let operations:NSArray = AFURLConnectionOperation.batch(ofRequestOperations: mutableOperations as [AnyObject], progressBlock: { (numberOfFinishedOperations, totalNumberOfOperations) -> Void in
            
        }) { (operations) -> Void in
            
            
            print("参比指血上传 操作完成")
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        } as NSArray
        
        OperationQueue.main.addOperations(operations as! [Operation], waitUntilFinished: false)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        
    }
    
    var updateFingerBloodArray = [Any]()
    
    func canbiUploadJson() -> [NSString]{
        let uida = ussssID
        let (sid,_) = self.getSidTid()
        var acd = NSDictionary()
        
        let code:String = "\(ussssID)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        acd = [
            "userid":String(uida),
            "sid":sid!,
            "ref":self.updateFingerBloodArray,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
        ]
        
        var resultArray:[NSString] = []
        let valid = JSONSerialization.isValidJSONObject(acd)
        if valid{
            let data = try? JSONSerialization.data(withJSONObject: acd, options: JSONSerialization.WritingOptions() )
            let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            resultArray.append(string!)
        }else{
            print("JSON 数据不合法")
            
        }
        return resultArray
    }
    
    //批量上传所有数据
    func uploadAllDataInBatch(){

        let jsonStringArray:[NSString] = createUploadJson()
        var mutableOperations: [Any] = [Any]()
        for jsonString:NSString in jsonStringArray{
            let manager = AFHTTPRequestOperationManager()
            manager.responseSerializer.acceptableContentTypes  = nil
            let reqUrl:String = "\(TEST_HTTP)/jsp/batchuploaddata.jsp"
            let urlRequest = NSMutableURLRequest(url: URL(string: reqUrl)!)
            urlRequest.httpMethod  = "POST"
            urlRequest.httpBody = jsonString.data(using: String.Encoding.utf8.rawValue)
            let getOperation = AFHTTPRequestOperation(request: urlRequest as URLRequest!)
            getOperation?.responseSerializer = AFHTTPResponseSerializer()
            
            mutableOperations.append(getOperation!)
        }
        
        let operations: [Operation] = AFURLConnectionOperation.batch(ofRequestOperations: mutableOperations, progressBlock: { (numberOfFinishedOperations: UInt, totalNumberOfOperations: UInt) in
            
        }) { (operations: [Any]?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        } as! [Operation]

        OperationQueue.main.addOperations(operations, waitUntilFinished: false)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
  
    }
    
    func createUploadJson() -> [NSString]{
        
        var records = [AnyObject]()
        records = BloodSugarDB().selectAll() as [AnyObject] //读取数据库所有数据

        if  records.count <= 0 {
            return [""]
        }
 
        records = records.sorted { (obj1, obj2) -> Bool in
            
            let b = obj1 as! BloodSugarModel
            let a = obj2 as! BloodSugarModel
            
            if Int(a.timeStamp)! > Int(b.timeStamp)! {
                return false
            }else{
                return true
            }
        }

        var uploadCount = 0
        //对列数
        if (records.count % 100 == 0){
            uploadCount = Int( records.count / 100 )
        }else{
            uploadCount = Int( records.count / 100 ) + 1
        }
        
        var resultArray:[NSString] = [] //返回的数组
        for i in 1...uploadCount{
            
            var bloodData:[NSObject] = []
            var tmp:ArraySlice<AnyObject>
            
            if ((i - 1) * 100 + 99) < records.count{
                tmp = (records as Array)[( (i - 1) * 100 )...( i * 100 - 1 )]
            }else{
                tmp = (records as Array)[( (i - 1) * 100 )...( records.count -  1 )]
            }
            
            for item in tmp{

                //对血糖数据进行处理，只保留一位小数
                let bloodNumber = Double( (item as! BloodSugarModel).glucose)!
                let bloodNumberRounded = NSString(format: "%.1f", bloodNumber)
                
                let bloodTime = Int( (item as! BloodSugarModel).timeStamp)!
                
                //--------------
                let electric = Int((item as! BloodSugarModel).current)!
                
                
                let data = ["d": bloodNumberRounded, "t": bloodTime,"e":electric] as [String : Any]
                
                bloodData.append(data as NSObject)
                
            }
            
            let (sid, tid) = getSidTid()
            
            let code:String = "\(ussssID)_\(CLIENTID)_\(KEY)_\(RandoM)"
            let codeMD5 = code.md5.uppercased()
            
            let jsonObject: [String: Any] = [
                "userid": String(ussssID),
                "sid": sid!,
                "tid": tid!,
                "data": bloodData,
                "random":RandoM,
                "clientid":CLIENTID,
                "code":codeMD5,
            ]
            
            let valid = JSONSerialization.isValidJSONObject(jsonObject) // true
            
            if valid{
                print("JSON 数据合法")
                
                let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions() )
                let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                resultArray.append(string!)
                
            }else{
                print("JSON 数据不合法")
            }
        }
        return resultArray
    }

   
    //MARK:计算血糖
    func processBloodElectricData(_ bloodElectricData:Int, timeOffset:Int, upload:Bool) -> (Bool, _sConvertResult_t) {
        //先检查参比，看是否又对应时间的参比数据需要插入
        var ref:Int = 0
        //插入参比
        for (index,item) in  fingerBloodArraySorted.enumerated(){
            ref = Int(((item as! [AnyObject])[1] as! Date).timeIntervalSince1970)
            
//            print("ref---------->\(ref)")
            
            if ref != 0 && ref <= timeOffset{
                self.inputRefBloodData(Double((item as! [AnyObject])[0] as! String)!, save: true)
                self.fingerBloodArraySorted.remove(at: index)
                break
            }
        }
        //使用算法模块处理血糖数据
        var convertResult:_sConvertResult_t = _sConvertResult_t()
        _ = BGC_InputCurrent(UInt32(bloodElectricData), &convertResult)
  
        if convertResult.state.hashValue == BGC_OK.hashValue{
            return (true, convertResult)
        }else{
            print("血糖转换失败")
            return (false, convertResult)
        }
    }
 
    //第一次指血数据输入
    var firstFingerBloodDataInputed:Bool = false
    
    func inputRefBloodData(_ ref:Double, save:Bool){
        
        //测试是否允许输入参比数据
        if BGC_PermitRef() == 1{
            //print("允许输入指血数据")
            //ref	 参比血糖值，单位0.1 mmol/L。如参比血糖为3.9 mmol/L，则ref=39
            //type  处理方式。0 一般处理 1 严格处理。
            //print("输入参比数据：\(UInt32(ref * 10))")
            
            BGC_InputReference(UInt32(ref * 10), 0)
            
            //设置第一次指血数据已经输入
            if firstFingerBloodDataInputed == false{
                firstFingerBloodDataInputed = true
            }
        }else{
            print("不允许输入指血数据")
        }
    }
    //MARK:获取数据库最后一条数据
    func getLastFMDBBloodData() ->(String,String,Date){
        //获取原始电流数据并对其排序
        var recordsArray:NSArray = BloodSugarDB().selectAll()
        if recordsArray.count <= 0 {
            return ("0.0","",Date())
        }
        recordsArray = recordsArray.sortedArray(comparator: { (obj1, obj2) -> ComparisonResult in
            
            let b = obj1 as! BloodSugarModel
            let a = obj2 as! BloodSugarModel
            
            if Int(a.timeStamp)! > Int(b.timeStamp)! {
                return ComparisonResult.orderedAscending
            }else{
                return ComparisonResult.orderedDescending
            }
        }) as NSArray
        
        var lastBlood = (recordsArray.lastObject as! BloodSugarModel).glucose
        
        let lastTime = (recordsArray.lastObject as! BloodSugarModel).timeStamp
        
        let recordDate = Date(timeIntervalSince1970: Double(lastTime!)!)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeStr = formatter.string(from: recordDate)
        
        let lastT:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 11))
        
        if lastBlood == "0" {
            lastBlood = "0.0"
        }
        return (lastBlood!,lastT,recordDate)
    }

    func getFingerBlood() -> (Bool,NSArray){
        
        //重新获取历史指血数据
        if let preFingerBloodDataArray = UserDefaults.standard.object(forKey: "fingerBloodDataArray") as? [Any]{
            //设置为有输入参比
            self.firstFingerBloodDataInputed = true
            self.fingerBloodDataArray.removeAll()
            self.fingerBloodDataArray += preFingerBloodDataArray
            let fingerBloodArray = NSMutableArray()
            fingerBloodArray.addObjects(from: self.fingerBloodDataArray as Array)
            
            //对参比数据进行排序

            fingerBloodArray.sort(comparator: { (obj1, obj2) -> ComparisonResult in
                
                if Int(((obj1 as! NSArray)[1] as! Date).timeIntervalSince1970) > Int(((obj2 as! NSArray)[1] as! Date).timeIntervalSince1970) {
                    return ComparisonResult.orderedDescending
                }else{
                    return ComparisonResult.orderedAscending
                }
            })
            
            
            
            return (true,fingerBloodArray[0] as! NSArray)
    
        }else{
            return (false,[0])
        }

    }

   
    
    //MARK:数据库数据分天处理
    func getSameDayDate(){
        //获取原始电流数据
        //recordsArray 血糖数据 ，dayArray 日期，deteilDayArray 详细日期
        let (recordsArray,dayArray,deteilDayArray) =  SBMGSevice().getFMDBAllDays()
        //如果没有数据，则不处理
        if recordsArray.count <= 0 {
            let alert = UIAlertView(title: "还没有数据", message: "", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }

        if self.chartBGView == nil {
            self.chartBGView = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height))
            self.chartBGView?.backgroundColor = UIColor.black
            self.chartBGView?.alpha = 0.3
            
            UIApplication.shared.keyWindow?.addSubview(self.chartBGView!)

            let tap4 = UITapGestureRecognizer(target: self, action: #selector(SBMGViewController.viewTap(_:)))
            self.chartBGView?.addGestureRecognizer(tap4)
            self.chartBGView?.tag = 406001
        }

        if self.currentChartView == nil {
            self.currentChartView = Bundle.main.loadNibNamed("CurrentChartView", owner: nil, options: nil)?.last as? CurrentChartView
            self.currentChartView?.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 290)
            
            self.currentChartView?.largerChartBtn.addTarget(self, action: #selector(SBMGViewController.btnAction(_:)), for: UIControlEvents.touchUpInside)
            self.currentChartView?.largerChartBtn.tag = 406010
            
            self.currentChartView?.currentDay = dayArray.lastObject as! String  //天数
            self.currentChartView?.recDataArray = recordsArray //血糖数据
            self.currentChartView?.firstDay = deteilDayArray.lastObject as! String //详细日期
            self.currentChartView?.dayArray = dayArray //日期数组
            self.currentChartView?.dayArrayCount = dayArray.count //一共有多少天
            self.currentChartView?.deteilDayArray = deteilDayArray //详细日期数组
            
            self.currentChartView?.SBMGViewCtr = self
            
            //是否有参比，如果有，第一个参比
            let (isFinger,firstFinger) = self.getFingerBlood()
            self.currentChartView?.isFinger = isFinger
            self.currentChartView?.fristFinger = firstFinger
            
            UIApplication.shared.keyWindow?.addSubview(self.currentChartView!)
        }
    }

    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        print("********************释放了主监测界面---------------------------------")
    }
 
}
