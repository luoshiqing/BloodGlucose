//
//  StatisticalViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/11.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class StatisticalViewController: UIViewController ,JMHoledViewDelegate ,UIScrollViewDelegate ,FDCalendarDelegate{

    //字体名字 ->  ZoomlaShiShang-A022
    
    var tmpCtr: UIViewController?
    
    var myScrollView: UIScrollView!
    
    var leftScrollView: UIScrollView!
    
    var rightView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.setNav()
        self.setTitleView()
        
        
        self.setMyScr()
 

        self.loadNewBloodTopView()
        self.loadtNewBloodDownView()
    }
    
    var newBloodView : NewBloodTopView!
    func loadNewBloodTopView(){
        
        if newBloodView == nil {
            newBloodView = NewBloodTopView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: 360))
            newBloodView.backgroundColor = UIColor.white
            
            newBloodView.seeBtnActClourse = self.NewBloodTopViewSeeBtnActClourse
            
            newBloodView.superCtr = self
            
            self.leftScrollView.addSubview(newBloodView)
            
        }
        
    }
    
    
    
    
    //MARK:查看回调
    func NewBloodTopViewSeeBtnActClourse(_ time: String)->Void{
        print("查看回调->\(time)")
        
        self.seeTime = time
        
        self.getBloodsugar(time)
        
        
        
    }
    
    var newBloodDownView: NewBloodDownView?
    func loadtNewBloodDownView(){
        
        if newBloodDownView == nil
        {
            newBloodDownView = NewBloodDownView(frame: CGRect(x: 0,y: 360,width: UIScreen.main.bounds.width,height: 49 + 20))
            newBloodDownView?.backgroundColor = UIColor.white
            
            self.leftScrollView.addSubview(newBloodDownView!)
            self.leftScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 49 + 20 + 360)
        }
        
        
    }
    
  
    
    
    func getBloodsugar(_ time: String?){
        

        if let str = time {
            getUpDic["time"] = str
        }else{
            let (strTime1,_,_) = StatisticalService().getCurrentDate()
 
            getUpDic["time"] = strTime1
   
        }

        
        MyNetworkRequest().getStatisticalBloodsugar(self.view, dic: self.getUpDic) { (success,valueArray,ChartDataDic) in

            if success { //有数据
                if !valueArray.isEmpty{
                    self.newBloodDownView?.frame = CGRect(x: 0, y: 360, width: UIScreen.main.bounds.width, height: 49 + 20 + CGFloat(valueArray.count) * 30)
                    self.newBloodDownView?.loadValueView(valueArray)
                    self.leftScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 49 + 20 + 360 + CGFloat(valueArray.count) * 30)
                }
                
                if let dateArray = ChartDataDic["dateArray"] as? [String]{
                    if !dateArray.isEmpty{
                        
                        print(dateArray)
                        
                        print(ChartDataDic)
                        self.newBloodView.scatterView.setScatterChartData(ChartDataDic)
                        
                    }
                    
                }
                
            }else{//没有数据
                
                self.newBloodDownView?.frame = CGRect(x: 0, y: 360, width: UIScreen.main.bounds.width, height: 49 + 20)
                self.newBloodDownView?.dismissBorderView()
                self.leftScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 49 + 20 + 360 )

                self.newBloodView.reloadScatterView()
            }
            
            
            
        }
        
        
    }
    
    
    
    
    //引导 提示
    var holedView:JMHoledView!
    
    func loadHoledView(){
        
        self.holedView = JMHoledView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height))
        self.holedView.backgroundColor = UIColor.clear
        
        self.holedView.holeViewDelegate = self
        
        UIApplication.shared.keyWindow?.addSubview(self.holedView)
        
        
        
        //时间选择
        let frame_x = UIScreen.main.bounds.width / 2 - 17 / 2 - 110
        
        self.holedView.addHoleRoundedRect(on: CGRect(x: frame_x, y: 64 + 7.5, width: UIScreen.main.bounds.width - frame_x * 2, height: 30), withCornerRadius: 15)
        
//        let frame_x1 = UIScreen.mainScreen().bounds.width / 2 + 17 / 2
//        self.holedView.addHoleRoundedRectOnRect(CGRectMake(frame_x1, 64 + 7.5, 110, 30), withCornerRadius: 15)
        
        
        let label = StatisticalService().getCustomView("选择要查询的起始时间，\n查看七天的血糖数据",width: 220,height: 200,fontSize: 20)
        
        self.holedView.addHCustomView(label, on: CGRect(x: 50, y: 145, width: 250, height: 60))
        
        //-------箭头1
        let arrowImg1 = StatisticalService().getCustomeArrowView(30, transform: 0)
        self.holedView.addHCustomView(arrowImg1, on: CGRect(x: frame_x + 55, y: 64 + 45, width: 30, height: 30))
   
        //-------箭头2
//        let arrowImg2 = StatisticalService().getCustomeArrowView(60, transform: CGFloat(M_PI / 3.5))
//
//        let arrow2_frame_x = UIScreen.mainScreen().bounds.width / 2
//
//        self.holedView.addHCustomView(arrowImg2, onRect: CGRectMake(arrow2_frame_x, 64 + 35, 100, 140))
 
 
        //血糖记录
        
        let frame_y: CGFloat = 360 + 64 - 30
        
        self.holedView.addHoleRoundedRect(on: CGRect(x: UIScreen.main.bounds.width - 80 - 7, y: frame_y, width: 80, height: 30), withCornerRadius: 15)
        
        let bloodLabel = StatisticalService().getCustomView("查看详细血糖记录",width: 110,height: 40,fontSize: 24)
        
        let fff_x = (UIScreen.main.bounds.width - 300) / 2
        self.holedView.addHCustomView(bloodLabel, on: CGRect(x: fff_x, y: frame_y + 74, width: 300, height: 50))
        
        //-------箭头4
        let arrowImg4 = StatisticalService().getCustomeArrowView(60, transform: CGFloat(M_PI / 4))
        
        let arrow4_frame_x = UIScreen.main.bounds.width - 80 - 23 - 60
        
        self.holedView.addHCustomView(arrowImg4, on: CGRect(x: arrow4_frame_x, y: frame_y + 25, width: 100, height: 140))
        
        //ok
//        let okBtn = StatisticalService().getCustomeBtn("ok!")
//        let ok_x = (UIScreen.mainScreen().bounds.width - 150) / 2
//        
//        let Hsize = UIScreen.mainScreen().bounds.height / 667
//        print(Hsize)
//        let ok_y = UIScreen.mainScreen().bounds.height - 100 * Hsize
//        self.holedView.addHCustomView(okBtn, onRect: CGRectMake(ok_x, ok_y, 150, 37))
        
    }
    
    func holedView(_ holedView: JMHoledView!, didSelectHoleAt index: UInt) {
        
        print(index)
        
        if self.holedView != nil {
            self.holedView.removeFromSuperview()
            self.holedView = nil
        }
        
//        if index < 11000 {
//
//            
//            
//        }
        
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        BaseTabBarView.isHidden = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        
        
        //是否加载事件数据
        
//        if self.sRightView != nil && myScrOffset_x > UIScreen.mainScreen().bounds.width - 5 {
//            
//            //获取 事件列表
//            if(dateString != nil){
//                if self.dataArray.count <= 0{
//                    self.sRightView.sRTopView.timeBtn.setTitle(dateString, forState: UIControlState.Normal)
//                    self.getLogList(dateString)
//                }
//                
//            }else{
//                
//                if self.dataArray.count <= 0{
//                    self.getLogList((self.sRightView.sRTopView.timeBtn.titleLabel?.text)!)
//                }
//                
//                
//            }
//
//     
//        }
 
        
        if let blood = isSecBlood {
            
            if blood {
                self.myScrollView.contentOffset.x = 0
                self.myTitilView.setNavTitleView(0)
            }else{
                self.isFirstGetListEvent = false
                self.myScrollView.contentOffset.x = UIScreen.main.bounds.width
                self.myTitilView.setNavTitleView(1)
            }
            
        }
        
        
        
        
    }
    
    
    //记录查看的时间，便于查看血糖记录
    var seeTime:String?
    
    var getUpDic = [String:String]()
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if let isShowGuide = UserDefaults.standard.value(forKey: "isShowGuide") as? Bool{
            
            if !isShowGuide {
                self.loadHoledView()
                UserDefaults.standard.setValue(true, forKey: "isShowGuide")
            }
            
        }else{
            self.loadHoledView()
            UserDefaults.standard.setValue(true, forKey: "isShowGuide")
            
        }
        
        if isSecBlood == true{
            self.getBloodsugar(self.seeTime)
        }else{
            
            //是否加载事件数据
            
            //获取 事件列表
            if(dateString != nil){
                
                self.sRightView.sRTopView.timeBtn.setTitle(dateString, for: UIControlState())
                self.getLogList(dateString)
                
//                if self.dataArray.count <= 0{
//                    self.sRightView.sRTopView.timeBtn.setTitle(dateString, forState: UIControlState.Normal)
//                    self.getLogList(dateString)
//                }
                
            }else{
                self.getLogList((self.sRightView.sRTopView.timeBtn.titleLabel?.text)!)
//                if self.dataArray.count <= 0{
//                    self.getLogList((self.sRightView.sRTopView.timeBtn.titleLabel?.text)!)
//                }
                
                
            }
            
            
        }
        
        
    }
    
    
    

    func setMyScr(){
        

        let frame_width: CGFloat = UIScreen.main.bounds.width
        let frame_height: CGFloat = UIScreen.main.bounds.height - 64
        
        myScrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: frame_width,height: frame_height))
        
        myScrollView.backgroundColor = UIColor.white
        
        myScrollView.contentSize = CGSize(width: frame_width * 2, height: frame_height)
        
        myScrollView.bounces = false

        myScrollView.isPagingEnabled = true
        
        myScrollView.showsVerticalScrollIndicator = false
        myScrollView.showsHorizontalScrollIndicator = false
        
        myScrollView.isDirectionalLockEnabled = true

        myScrollView.delegate = self
        
        
        myScrollView.isScrollEnabled = false
        
        
        
        self.view.addSubview(myScrollView)
        
        
        //左
        leftScrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: frame_width,height: frame_height))
        leftScrollView.backgroundColor = UIColor.white
        
        leftScrollView.contentSize = CGSize.zero
//        leftScrollView.bounces = false
//        leftScrollView.showsVerticalScrollIndicator = false
//        leftScrollView.showsHorizontalScrollIndicator = false
        leftScrollView.isDirectionalLockEnabled = true
     
        myScrollView.addSubview(leftScrollView)
        
        //右
        rightView = UIScrollView(frame: CGRect(x: frame_width,y: 0,width: frame_width,height: frame_height))
        rightView.backgroundColor = UIColor.white
  
        
        //拖手势
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(StatisticalViewController.handlePanGesture(_:)))
//        rightView.addGestureRecognizer(panGesture)
        
        
        if self.sRightView == nil {
            
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height - 64
            
            self.sRightView = SRightView(frame: CGRect(x: 0,y: 0,width: width,height: height))
            sRightView.backgroundColor = UIColor.white
            
            
            sRightView.btnActClourse = self.SRightViewBtnActClourse
            
            sRightView.CleanCompelete = self.SRightViewCleanCompelete
            
            sRightView.StaticCtr = self
            
            self.rightView.addSubview(sRightView)
            
        }
        
        
        
        myScrollView.addSubview(rightView)
        
        
    }
    
    func handlePanGesture(_ send: UIPanGestureRecognizer){
        
        
        
        let translation: CGPoint = send.translation(in: send.view!)
        
        let x = UIScreen.main.bounds.width - translation.x
        
        self.myScrollView.contentOffset.x = x
        
        
        print(translation)
        
        
    }
    

    
    
    

    func setNav(){
        
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(StatisticalViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        //右
        
        
        let (rightBtn,Rspacer,RbackItem) = BGNetwork().creatRightBtn()
        rightBtn.addTarget(self, action: #selector(StatisticalViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        rightBtn.tag = 1
        
        
        let (rightBtn2,Rspacer2,RbackItem2) = BGNetwork().creatRightHelpBtn()
        rightBtn2.addTarget(self, action: #selector(StatisticalViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        rightBtn2.tag = 2

        self.navigationItem.rightBarButtonItems = [Rspacer,RbackItem,Rspacer2,RbackItem2]
    
        
    }
    
    
    var myTitilView:NavTitleView!
    func setTitleView(){
        
        let nameArray = ["血糖","事件"]
        
        myTitilView = NavTitleView(frame: CGRect(x: 0,y: 0,width: 120,height: 30))
        
        myTitilView.backgroundColor = UIColor.clear
        
        myTitilView.names = nameArray
        
        
        myTitilView.btnActClourse = self.NavTitleViewClourse
        
        self.navigationItem.titleView = myTitilView
    }
    
    
    
    func someBtnAct(_ send: UIButton){
        let tag = send.tag
        
        switch tag {
        case 0:
            dateString = nil
            
            isSecBlood = true

            if let ctr = self.tmpCtr {
                self.navigationController!.popToViewController(ctr, animated: true)
            }else{
                self.navigationController!.popViewController(animated: true)
            }
            
            
        case 1:
            print("添加")
            
            self.dataArray.removeAllObjects()
            
            
            let eventSelectVC = EventSelectViewController()

            eventSelectVC.tmpCtr = self
            
            self.navigationController?.pushViewController(eventSelectVC, animated: true)
            
        case 2:
            print("帮助")
            
            let sHelpVC = StatiisticalHelpViewController()
            self.navigationController?.pushViewController(sHelpVC, animated: true)

        default:
            break
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:Scorll代理


    var sRightView: SRightView!
    
    var myScrOffset_x: CGFloat = 0.0
    
    
    var isFirstGetListEvent = true
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        

        let offset_x = scrollView.contentOffset.x
        
        print(offset_x)
        
        myScrOffset_x = offset_x
        

        
        if self.isFirstGetListEvent && offset_x == UIScreen.main.bounds.width {
            self.isFirstGetListEvent = false
            self.getListEvent()
        }
        
        
        
    
    }
    
 
    
    var dataArray = NSMutableArray() //所有数据
    

    func getListEvent(){
        
        
        //获取 事件列表
        if(dateString != nil){
            
            
            if self.dataArray.count <= 0{

                self.sRightView.sRTopView.timeBtn.setTitle(dateString, for: UIControlState())
                
                
                self.getLogList(dateString)
            }
            
            
            
        }else{
            
            if self.dataArray.count <= 0{
                
                if let ttt = self.sRightView.sRTopView.timeBtn.titleLabel?.text{
                    self.getLogList(ttt)
                }
            }
            
            
        }
        

        
    }
    
    
    
    var finish:JGProgressHUD!
    
    //MARK:获取事件
    func getLogList(_ TIME:String){
        
        print("*******************987654")
        
        self.dataArray.removeAllObjects()

//        self.finish = JGProgressHUD(style: JGProgressHUDStyle.ExtraLight)
//        self.finish.textLabel.text = "数据加载898989"
//        self.finish.showInView(self.rightView, animated: true)
//        

        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/event/getloglist.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let logDate = TIME
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "logDate":logDate,
        ]
        
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("json:\(json)")
     
            if let message:String = json["message"].string{

                if (message == "数据为空") {

                    self.sRightView.setNotData(true)
                    
//                    self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
//                    self.finish.textLabel.text = "暂无数据"
//                    self.finish.dismissAfterDelay(1.0, animated: true)

                    //设置能量的摄入跟输出
                    self.sRightView.sRTopView.setIntakeEnergyView(isIntakeView: true, max: 11000.0, value: 0)
                    self.sRightView.sRTopView.setIntakeEnergyView(isIntakeView: false, max: 8000.0, value: 0)

                }else{
                    
                    
                    
//                    
//                    self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
//                    self.finish.textLabel.text = "加载完成"
//                    self.finish.dismissAfterDelay(1.0, animated: true)
                    
                    self.sRightView.setNotData(false)

                    self.dataArray.removeAllObjects()
                    
                    //解析数据
                    if let tmpData:NSDictionary = json["date"].dictionaryObject as NSDictionary?{
                        
                        //时间年份
                        var date = ""
                        if let date1 = tmpData.value(forKey: "date") as? String{
                            date = date1
                            print("date:\(date1)")
                        }
                        
                        
                        var income:Float = 0.0
                        var expend:Float = 0.0
                        //能量消耗与摄入
                        if let tmpIncome = tmpData.value(forKey: "income") as? String{
                            print(tmpIncome)
                            income = Float(tmpIncome)!
                        }
                        if let tmpExpend = tmpData.value(forKey: "expend") as? String{
                            print(tmpExpend)
                            expend = Float(tmpExpend)!
                        }
                        
                        //核心数据
                        if let logArray = tmpData.value(forKey: "log") as? NSArray{
                            //能量
                            var tmpEnergy:Float = 0.0
                            
                            
                            for tmp in logArray {
                                
                                
                                let anyDic = tmp as! NSDictionary
                                
                                if let type = anyDic.value(forKey: "type") as? String{
                                    //类型
                                    switch type {
                                    case "medicine":
                                        print("药物")
                                        
                                        let medicine = anyDic.value(forKey: "medicine") as? String
                                        let dose = anyDic.value(forKey: "content") as? String
                                        let time = anyDic.value(forKey: "time") as! String
                                        let imgurl = anyDic.value(forKey: "imgurllist") as! NSArray
                                        let addInformation = anyDic.value(forKey: "food") as? String
                                        
                                        let logId = anyDic.value(forKey: "logId") as! String
                                        
                                        let emotion = anyDic.value(forKey: "emotion") as! Int
                                        
                                        let mdArray = NSMutableArray()
                                        
                                        
                                        var tmpMedic = ""
                                        if ((medicine?.isEmpty) != nil){
                                            tmpMedic = medicine!
                                        }
                                        var tmpDose = ""
                                        if ((dose?.isEmpty) != nil){
                                            tmpDose = dose!
                                        }
                                        var tmpAddInformation = ""
                                        if ((addInformation?.isEmpty) != nil){
                                            tmpAddInformation = addInformation!
                                        }
                                        
                                        
                                        let medicineDic = [
                                            "medicine":tmpMedic,
                                            "dose":tmpDose,
                                            "time":time,
                                            "imgurl":imgurl,
                                            "food":tmpAddInformation,//附加信息
                                            "date":date,
                                            "logId":logId,
                                            "type":"medicine",
                                            "emotion":emotion,
                                        ] as [String : Any]
                                        
                                        mdArray.add(medicineDic)
                                        
                                        self.dataArray.addObjects(from: mdArray as [AnyObject])
                                        
                                    case "sport":
                                        print("运动")
                                        
                                        let spType = anyDic.value(forKey: "sport") as! String
                                        let spAllTime = anyDic.value(forKey: "content") as? String
                                        let spTime = anyDic.value(forKey: "time") as! String
                                        let imgurl = anyDic.value(forKey: "imgurllist") as! NSArray
                                        let emotion = anyDic.value(forKey: "emotion") as! Int
                                        let addInformation = anyDic.value(forKey: "food") as? String
                                        let logId = anyDic.value(forKey: "logId") as! String
                                        
                                        let spArray = NSMutableArray()
                                        
                                        
                                        var tmpSpAllTime = ""
                                        if ((spAllTime?.isEmpty) != nil) {
                                            tmpSpAllTime = spAllTime!
                                        }
                                        var tmpAddInformation = ""
                                        if ((addInformation?.isEmpty) != nil) {
                                            tmpAddInformation = addInformation!
                                        }
                                        
                                        let sportDic = [
                                            "sport":spType,
                                            "content":tmpSpAllTime,
                                            "time":spTime,
                                            "imgurl":imgurl,
                                            "emotion":emotion,
                                            "food":tmpAddInformation,
                                            "date":date,
                                            "logId":logId,
                                            "type":"sport",
                                        ] as [String : Any]
                                        
                                        spArray.add(sportDic)
                                        
                                        self.dataArray.addObjects(from: spArray as [AnyObject])
                                    case "food":
                                        print("食物")
                                        
                                        let addInformation = anyDic.value(forKey: "content") as! String
                                        let imgurl = anyDic.value(forKey: "imgurllist") as! NSArray
                                        let emotion = anyDic.value(forKey: "emotion") as! Int
                                        let time = anyDic.value(forKey: "time") as! String
                                        
                                        let logId = anyDic.value(forKey: "logId") as! String
                                        
                                        
                                        
                                        
                                        //标签列表
                                        var tagArray = NSArray()
                                        if let medicine = anyDic.value(forKey: "medicine") as? String{
                                            
                                            do{
                                                let jsonA = try JSONSerialization.jsonObject(with: medicine.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                                                
                                                if let tmpJson = jsonA {
                                                    tagArray = tmpJson
                                                }
                                                
                                            }catch{
                                                print(error)
                                            }
                                        }else if let medicine = anyDic.value(forKey: "medicine") as? NSArray{
                                            
                                            
                                            tagArray = medicine
                                            
                                        }else{
                                            print("数据格式错误")
                                        }
                                        

                                        
                                        //摄入的能量
                                        var sport:Float = 0
                                        
                                        if let sp = anyDic.value(forKey: "sport") as? String{
                                            
                                            if !sp.isEmpty{
                                                tmpEnergy += Float(sp)!
                                                sport = Float(sp)!
                                            }
                                            
                                        }
                                        
                                        
                                        
                                        let fdArray = NSMutableArray()
                                        let foodDic = [
                                            "food":addInformation,
                                            "imgurl":imgurl,
                                            "emotion":emotion,
                                            "time":time,
                                            "date":date,
                                            "logId":logId,
                                            "type":"food",
                                            "sport":sport,
                                            "medicine":tagArray,
                                        ] as [String : Any]
                                        fdArray.add(foodDic)
                                        self.dataArray.addObjects(from: fdArray as [AnyObject])
                                    default:
                                        break
                                        
                                    }
                                    
                                }
                                //遍历结束
                            }
                            //设置能量的摄入跟输出

                            self.sRightView.sRTopView.setIntakeEnergyView(isIntakeView: true, max: 11000.0, value: income)
                            self.sRightView.sRTopView.setIntakeEnergyView(isIntakeView: false, max: 8000.0, value: expend)
                            
                        }
                        
                    }
                    
                    //有数据
                }
                //有message
            }

            self.sRightView.dataArray = self.dataArray
            
            self.sRightView.myTabView.reloadData()
            
            }, failure: { () -> Void in
                
                print("false")
//                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
//                self.finish.textLabel.text = "网络错误"
//                self.finish.dismissAfterDelay(1.0, animated: true)
        })
        
        
    }

    
    

    //MARK:各种回调
    //1.查看全屏
//    func SFingerBloodViewMoreClourse(send: UIView)->Void{
//        
//        let sMoreVC = SMoreViewController()
//
//        self.presentViewController(sMoreVC, animated: true, completion: nil)
// 
//    }
    //2.标题
    func NavTitleViewClourse(_ send: UIButton)->Void{
        
        let tag = send.tag
        
        switch tag {
        case 0:
            print("血糖")
            isSecBlood = true
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.25)
            self.myScrollView.contentOffset.x = 0
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            UIView.commitAnimations()
            
        case 1:
            print("事件")
            isSecBlood = false
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.25)
            self.myScrollView.contentOffset.x = UIScreen.main.bounds.width
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            UIView.commitAnimations()
            
            //获取 事件列表
            if(dateString != nil){
                self.sRightView.sRTopView.timeBtn.setTitle(dateString, for: UIControlState())
                self.getLogList(dateString)
            }else{
                self.getLogList((self.sRightView.sRTopView.timeBtn.titleLabel?.text)!)
            }
            
            
            
        default:
            break
        }
        
        
        
        
    }
    //3.日期回调
    func SRightViewBtnActClourse(_ send: UIButton)->Void{
        print("日期回调->\(send.tag)")
        
        let tag = send.tag
        
        switch tag {
        case 0:
            //print("左边")
            
            let currentSec: String = (self.sRightView.sRTopView.timeBtn.titleLabel?.text)!
            
            let (_,currentSecDouble) = StatisticalService().getCurrentTime(true, currentSec: currentSec)
            
            let time = StatisticalService().lastDay(currentSecDouble)
            
            self.sRightView.sRTopView.timeBtn.setTitle(time, for: UIControlState())

            dateString = time
            
            self.getLogList(time)
            
        case 1:
            //print("右边")

            let currentSec: String = (self.sRightView.sRTopView.timeBtn.titleLabel?.text)!
            
            let (todayDouble,currentSecDouble) = StatisticalService().getCurrentTime(true, currentSec: currentSec)
            
            let (time,timeDouble) = StatisticalService().nextDay(currentSecDouble)

            if timeDouble > todayDouble {
                print("超过今天的日期")
                
                let alrt = UIAlertView(title: "超过今天的日期", message: "", delegate: nil, cancelButtonTitle: "确定")
                alrt.show()
                
                
                
            }else{
                self.sRightView.sRTopView.timeBtn.setTitle(time, for: UIControlState())
                dateString = time
                self.getLogList(time)
            }

        case 2:
            //print("中间时间")
            self.setFDCalender()
        default:
            break
        }
  
    }
    
    //4.删除回调
    func SRightViewCleanCompelete(_ date: String)->Void{
        self.getLogList(date)
    }
    
    
    
    func setFDCalender(){
        
        self.setBgView()
        
        self.setCanlenderView()
        
    }
    
    var calenderView:FDCalendar!
    
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
            
            let S_Width = UIScreen.main.bounds.width
            let H_Height = UIScreen.main.bounds.height
            
            bgView = UIView(frame: CGRect(x: 0,y: 0,width: S_Width,height: H_Height))
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 0.3
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(StatisticalViewController.closeCanlenderView))
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
    
    
    func setDateeee(_ date: Date!) {
        //转换为时间戳
        let aa:Double = date.timeIntervalSince1970 + (8 * 60 * 60)
        let dayTime = Date(timeIntervalSince1970: aa)
        //print("返回的时间->\(dayTime)")
        let time:String = (String(describing: dayTime) as NSString).substring(to: 10)
        let (todayDouble,_) = StatisticalService().getCurrentTime(false, currentSec: "2016-07-14")
        if aa > todayDouble{
            print("选择的超过今天日期")
            
            let alrt = UIAlertView(title: "超过今天的日期", message: "", delegate: nil, cancelButtonTitle: "确定")
            alrt.show()
            
        }else{
            
            self.sRightView.sRTopView.timeBtn.setTitle(time, for: UIControlState())
            dateString = time
            self.getLogList(time)
            
            
            self.closeCanlenderView()
        }
  
    }

}
