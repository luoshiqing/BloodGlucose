//
//  URepViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/28.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit



//var isDidLogin = false


class URepViewController: UIViewController ,AdvieceViewDelegate{
    
    enum MyScroll {
        case segmentScr     //统计
        case analysisScr    //分析
        case planScr        //方案
    }
    

    
    let Usize = UIScreen.main.bounds
    //------>>>>>>>>>>>>>统计视图-------------------
    //分段选择
    var segmentView:SegmentView!
    //统计scr
    var segmentScr:UIScrollView!
    //评分视图
    var uEvaluationView:UevaluationView!
    //--------------------统计视图--<<<<<<<<<<<<<<--
    
    
    //-------->>>>>>>>>>>探针数据
    var uStartTimeArray = NSMutableArray()
    var uEndTimeArray = NSMutableArray()
    var uSidArray = NSMutableArray()
    //-------->>>>>>>获取的网络数据
    var uBdArray = NSArray() //图形数据（血糖）
    var uBjDictonary = NSDictionary() //其他数据
    
    
    
    //------>>>>>>>>>>>>>分析视图-------------------
    var analysisScr:UIScrollView!
    var uPillarView:PillarView!             //柱行视图
    var uSomeAnalyzeView:SomeAnalyzeView!   //其他文字说明视图
    
    
    var fenxiHud:JGProgressHUD!

    //--------------------分析视图--<<<<<<<<<<<<<<--
    
    
    //------>>>>>>>>>>>>>方案视图-------------------
    var planScr:UIScrollView!
    var uOverallEvaluationView:OverallEvaluationView!
    //--------------------方案视图--<<<<<<<<<<<<<<--
    deinit{
        print("报告页面被销毁了。。。。。")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "报告"
        self.view.backgroundColor = UIColor.white
        
        isOneCtrPush = true
        
        //自定义返回按钮
//        self.setNav()
        
        //初始化视图
        self.initSomeView()
        
    }
    
    var uFinish:JGProgressHUD!
    //选择的sid
    var selectSensorsid:String!
    
    
    //视图将要出现，加载网络
    override func viewWillAppear(_ animated: Bool) {
        BaseTabBarView.isHidden = false
//        if isDidLogin {
//            self.uSidArray.removeAllObjects()
//        }
        
        
        if self.uSidArray.count <= 0{
            //获取所有探针
            self.getProbeId()

        }
        
//        if self.isSelectFangAn == true {
//            self.getPlanJspData()
//        }
        
    }
    
    //MARK:-获取探针id
    func getProbeId(){
        
        self.uFinish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.uFinish.textLabel.text = "加载中.."
        self.uFinish.show(in: self.view, animated: true)
        
        
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/report/getsensorlist.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        var dicDPost = NSDictionary()
        dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
        ]
        
 
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
            
            if let data:NSArray = json["data"].arrayObject as NSArray? {
                
                if(data.count > 0){
                    let first:NSDictionary = data[0] as! NSDictionary
                    let sid = first.value(forKey: "sid") as! String
                    self.selectSensorsid = sid
                    //解析sid 和 日期
                    for tmp in data{
                        let tmpDic:NSDictionary = tmp as! NSDictionary
                        
                        let st = tmpDic.value(forKey: "st") as! String
                        let et = tmpDic.value(forKey: "et") as! String
                        let sensorsid = tmpDic.value(forKey: "sid") as! String
                        
                        
                        //判断日期是否为空
                        if !st.isEmpty{
                            self.uStartTimeArray.add(st)
                            self.uEndTimeArray.add(et)
                            self.uSidArray.add(sensorsid)
                        }else{
                            print("时间为空---->>>放弃保存")
                        }
                        
                        
                    }
                    
                    //获取探头id 报告
                    self.getReportHome(sid)
                    
                }else{
                    print("没有数据")
                    self.uFinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.uFinish.textLabel.text = "没有数据"
                    self.uFinish.dismiss(afterDelay: 0.5, animated: true)
                }
                
            }
            
            }, failure: { () -> Void in
                
                print("false错误")
                self.uFinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.uFinish.textLabel.text = "加载失败"
                self.uFinish.dismiss(afterDelay: 0.5, animated: true)
        })
        
    }
    
    
    //MARK:-根据探针获取报告
    func getReportHome(_ sid:String){
        print("sid:\(sid)")
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/report/getreporthome.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        var dicDPost = NSDictionary()
        dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "sensorsid":sid,
        ]
        //1511130632-41
        print(dicDPost)
        
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
            
            var bd = NSArray()
            var bj = NSDictionary()
            if let data:NSDictionary = json["data"].dictionaryObject as NSDictionary? {
                
                bd = data.value(forKey: "bd") as! NSArray
                bj = data.value(forKey: "bj") as! NSDictionary
                
                self.uBdArray = bd
                self.uBjDictonary = bj
                
//                print("uBdArray.count:\(self.uBdArray.count)")
                
                
            }
  
            self.clearSomeView()

            let (xArray,yArray,dataArray,dataCount) = StatisticService().moreChartImg(bd)
            

            self.continuChartView.loadContinuousManyDaysChartView(xArray, yArray: yArray, dataArray: dataArray, dataCount: dataCount)
            //设置评分
            self.setUevaluationViewData(bj)
            
            //设置avg 视图
            self.uSomeView.setUsomeViewData(bj)
            
            
            self.uFinish.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.uFinish.textLabel.text = "加载完成"
            self.uFinish.dismiss(afterDelay: 0.5, animated: true)
            
            }, failure: { () -> Void in
                
                let bj = ["count":"0"]
                //设置评分
                self.setUevaluationViewData(bj as NSDictionary)
                
                print("false错误")
                self.uFinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.uFinish.textLabel.text = "加载失败"
                self.uFinish.dismiss(afterDelay: 0.5, animated: true)
        })
        
        
        
    }
    
    func setUavgView(_ bj:NSDictionary){
        
    }
    
    
    var dateSelect:String!
    
    func setUevaluationViewData(_ bj:NSDictionary){
        
        let tmpcount = bj.value(forKey: "count") as! String
        let countDouble:Double = Double(tmpcount)!
        let count = NSString(format: "%.1f", countDouble)
        
        let tmpvalue:Float = Float(count as String)!
        let value = CGFloat(tmpvalue)
 
        var stri = ""
        if self.dateSelect == nil {
            
            if (self.uStartTimeArray.count > 0) {
                let startTime = self.uStartTimeArray[0] as! String
                
                if startTime.characters.count > 10 {
                    stri = (startTime as NSString).substring(to: 10)
                }else{
                    stri = "错误"
                }
                
            }

        }else{
            stri = self.dateSelect
        }
        
        
        
        self.loadUevaluationView(value, date: stri)
        
        //设置详细建议
        let summary = bj.value(forKey: "summary") as! String
        self.breakDownTV.text = summary
        
        
    }
    
    
    
    //MARK:-设置选择日期
    func setDateSelect(){
        if (self.uStartTimeArray.count > 0) {
            let startTime = self.uStartTimeArray[0] as! String
            
            var stri = ""
            if startTime.characters.count > 10 {
                stri = (startTime as NSString).substring(to: 10)
            }else{
                stri = "错误"
            }
            
            
            self.uEvaluationView.uDateLabel.text = stri
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:自定义返回
    func setNav(){
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(URepViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 1
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
    }
    //MARK:按钮点击事件
    func someBtnAct(_ send:UIButton){
        switch send.tag {
        case 1:
            //返回
            self.navigationController!.popViewController(animated: true)
        case 2:
            //查看更多
            print("查看更多")
            
            if (self.uBdArray.count > 0){
                let moreImgVC = MoreImgViewController()
                moreImgVC.dataArray = self.uBdArray
                
                
                moreImgVC.sensorsid = self.selectSensorsid
                
                self.present(moreImgVC, animated: true, completion: nil)
            }else{
                
                let alrtView = UIAlertView(title: "没有数据", message: "您可以去看看其他时间的数据", delegate: nil, cancelButtonTitle: "确定")
                alrtView.show()
            }
            
            
        default:
            break
        }
    }
    //MARK:视图点击事件
    func viewTap(_ send:UITapGestureRecognizer){
        switch send.view!.tag{
        case 20:
            print("选择日期")
//            self.uEvaluationView.uDateLabel.text = "测试一下啊"
            
            self.loadUdateView()
            
            
            
        default:
            break
        }
    }
    
    var uDateView:UdateView!
    var uDateBgView:UIView!
    
    
    func loadUdateView(){
        
        let size = UIScreen.main.bounds

        
        if self.uDateBgView == nil {
            self.uDateBgView = UIView(frame: CGRect(x: 0,y: 0,width: size.width,height: size.height))
            self.uDateBgView.backgroundColor = UIColor.black
            self.uDateBgView.alpha = 0.3

            let tap = UITapGestureRecognizer(target: self, action: #selector(URepViewController.uDateBgViewAct))
            self.uDateBgView.addGestureRecognizer(tap)
            
            
            UIApplication.shared.keyWindow?.addSubview(self.uDateBgView)
            
        }
//375,667
        
        if self.uDateView == nil {
            self.uDateView = Bundle.main.loadNibNamed("UdateView", owner: nil, options: nil)?.last as! UdateView
            
            self.uDateView.dateArray = self.uStartTimeArray
            self.uDateView.pickerDefaultIndex = self.uSecIndex
            
            
            self.uDateView.frame = CGRect(x: (size.width - 250) / 2 , y: (size.height - 236) / 2, width: 250, height: 236)
            
            self.uDateView.layer.cornerRadius = 6
            self.uDateView.clipsToBounds = true
            
            
            self.uDateView.dateClosure = self.dateClosure
            
            
            UIApplication.shared.keyWindow?.addSubview(self.uDateView)
            
        }
        
        
    }
    
    func uDateBgViewAct(){
        if(self.uDateBgView != nil){
            self.uDateBgView.removeFromSuperview()
            self.uDateBgView = nil
        }
        
        if (self.uDateView != nil){
            self.uDateView.removeFromSuperview()
            self.uDateView = nil
        }
    }
    
    
    
    //MARK:初始化视图
    func initSomeView(){
        //分段选择视图
        self.loadSegmentView()
        
        //加载统计scr
        self.loadScrollView(MyScroll.segmentScr)
        
        //加载统计全部视图
        self.loadUstatisticalView()
        
    }
    
    //加载分段视图
    func loadSegmentView(){
        if self.segmentView == nil {
            self.segmentView = SegmentView(frame: CGRect(x: 0,y: 0,width: self.Usize.width,height: 44))
            self.segmentView.btnName = ["统计","分析","方案"]
            //把回调传给视图
            self.segmentView.testClosure = myClosure
            
            self.segmentView.backgroundColor = UIColor.white
            
            self.view.addSubview(self.segmentView)
        }
    }
    
    //统计scr
    func loadScrollView(_ type:MyScroll){
        
        let scrFrame = CGRect(x: 0,y: 44,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height - 64 - 44 - 63)
        
        switch type {
        case MyScroll.segmentScr:
            print("统计scr")
            //隐藏
            if self.analysisScr != nil {
                self.analysisScr.isHidden = true
            }
            if self.planScr != nil {
                self.planScr.isHidden = true
            }
            //加载
            if self.segmentScr == nil {
                self.segmentScr = UIScrollView(frame: scrFrame)
                self.segmentScr.backgroundColor = UIColor.white
                self.segmentScr.contentSize = CGSize(width: self.Usize.width, height: 160 + 60 + 227 + 512 + 41 + 100 + 20)
                self.view.addSubview(self.segmentScr)
            }else{
                self.segmentScr.isHidden = false
            }
            
        case MyScroll.analysisScr:
            print("分析scr")
            //隐藏
            if self.segmentScr != nil {
                self.segmentScr.isHidden = true
            }
            if self.planScr != nil {
                self.planScr.isHidden = true
            }
            
            //加载
            if self.analysisScr == nil {
                self.analysisScr = UIScrollView(frame: scrFrame)
                self.analysisScr.backgroundColor = UIColor.white
                self.analysisScr.contentSize = CGSize(width: self.Usize.width, height: 272 + 434)
                self.view.addSubview(self.analysisScr)
                
                //加载其他视图
                self.loadAnalysisSomeView()
                //加载分析的数据
                self.getAnalyzeJsp()
                
            }else{
                self.analysisScr.isHidden = false
            }

        default:
            print("方案scr")
            //隐藏
            if self.analysisScr != nil {
                self.analysisScr.isHidden = true
            }
            if self.segmentScr != nil {
                self.segmentScr.isHidden = true
            }
            
            //设置为点击过方案
//            self.isSelectFangAn = true
            
            //加载
            if self.planScr == nil {
                self.planScr = UIScrollView(frame: scrFrame)
                self.planScr.backgroundColor = UIColor.white
                self.planScr.contentSize = CGSize(width: self.Usize.width, height: 800)
                self.view.addSubview(self.planScr)
                
                
                //加载动画评价视图
                self.loadUFAView()
                //加载总体评价视图
                self.loadAllScheView()
                
                
                if self.selectSensorsid != nil {
                    //获取网络数据
                    self.getPlanJspData()
                }
                
                
                
            }else{
                self.planScr.isHidden = false
            }
            
        }
    }
    
//    var isSelectFangAn:Bool = false
    
    //MARK:加载统计视图
    func loadUstatisticalView(){
        //评分视图
        self.loadUevaluationView(CGFloat(0), date: "努力加载中.")
        //加载查看更多视图
        self.loadUlookMoreView()
        //加载图形chart 视图
        self.loadChartView()
        //加载 avg min 一些视图
        self.loadUsomeView()
        //加载详解视图
        self.loadUbreakDownView()
        
    }
    
    //MARK:加载分析视图
    func loadAnalysisSomeView(){
        //加载圆柱图形
        if self.uPillarView == nil {
            self.uPillarView = Bundle.main.loadNibNamed("PillarView", owner: nil, options: nil)?.last as! PillarView
            
            self.uPillarView.frame = CGRect(x: 0, y: 0, width: self.analysisScr.frame.size.width, height: 272)
            
            self.analysisScr.addSubview(self.uPillarView)
            
        }
        
        //加载其他说明视图
        if self.uSomeAnalyzeView == nil {
            self.uSomeAnalyzeView = Bundle.main.loadNibNamed("SomeAnalyzeView", owner: nil, options: nil)?.last as! SomeAnalyzeView
            
            self.uSomeAnalyzeView.frame = CGRect(x: 0, y: 272, width: self.analysisScr.frame.size.width, height: 434)
            
            self.analysisScr.addSubview(self.uSomeAnalyzeView)
        }
        
    }
    
    let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
    
    //MARK:加载方案视图
    func loadUFAView(){
        
        let ufaView = UFAevaluationView(frame: CGRect(x: 0,y: 0,width: self.planScr.frame.size.width,height: 301 * self.Hsize))
        
  
        self.planScr.addSubview(ufaView)

        if self.uBjDictonary.count > 0 {
            ufaView.loadUFAevaluationView(self.uBjDictonary)
        }else{
            let alrt = UIAlertView(title: "暂无数据", message: "请监测后再查看", delegate: nil, cancelButtonTitle: "确定")
            alrt.show()
        }
        
        
    }
    
    func loadAllScheView(){
        //总体评价
        if(self.uOverallEvaluationView == nil){ //总体评价
            
            self.uOverallEvaluationView = Bundle.main.loadNibNamed("OverallEvaluationView", owner: nil, options: nil)?.first as! OverallEvaluationView
            self.uOverallEvaluationView.frame = CGRect(x: 0, y: 301 * self.Hsize, width: self.planScr.frame.size.width, height: 114)
            self.planScr.addSubview(self.uOverallEvaluationView)
 
        }
    }
    
    var uAdviceView:AdviceView!
    func laodDctorView(){
        
        if (self.uAdviceView == nil){
            self.uAdviceView = Bundle.main.loadNibNamed("AdviceView", owner: nil, options: nil)?.first as! AdviceView
            self.uAdviceView.frame = CGRect(x: 0, y: 301 * self.Hsize + 114, width: self.planScr.frame.size.width, height: 94)
            //设置代理
            self.uAdviceView.delegate = self
            
            self.uAdviceView.initSetup()
            
            self.planScr.addSubview(self.uAdviceView)
        }
    }
    
    
    
    
    //加载食物交换份
    func loadUtypeFoodView(_ type:String,energy:String){
        //294
        let uTypeFoodView = Bundle.main.loadNibNamed("UtypeFoodView", owner: nil, options: nil)?.last as! UtypeFoodView
        
        uTypeFoodView.frame = CGRect(x: 0, y: 301 * self.Hsize + 114 + 94, width: self.planScr.frame.size.width, height: 294)
        
        uTypeFoodView.setUtypeFoodViewDate(type, energy: energy)
        
        self.planScr.addSubview(uTypeFoodView)
    }
    //加载推荐食物清单
    func loadFoodAdviceView(_ foodArray:NSArray){
        
        
        self.planScr.contentSize = CGSize(width: UIScreen.main.bounds.width , height: 301 * self.Hsize + 114 + 94 + 294 + 110 * self.Hsize * 4)
        
        let uFoodAdviceView = UfoodAdviceView(frame: CGRect(x: 0,y: 301 * self.Hsize + 114 + 94 + 294,width: self.planScr.frame.size.width,height: 110 * self.Hsize * 4))
        
        
        
        uFoodAdviceView.setUfoodAdviceView(foodArray)
        uFoodAdviceView.URepViewCtr = self
        self.planScr.addSubview(uFoodAdviceView)
        
        
    }
    //加载注意事项
    func loadAttentionView(_ food:String){
        
        
        
        self.planScr.contentSize = CGSize(width: UIScreen.main.bounds.width , height: 301 * self.Hsize + 114 + 94 + 294 + 110 * self.Hsize * 4 + 281)
        
        let uAttentionView = Bundle.main.loadNibNamed("UattentionView", owner: nil, options: nil)?.last as! UattentionView
        
        uAttentionView.frame = CGRect(x: 0, y: 301 * self.Hsize + 114 + 94 + 294 + 110 * self.Hsize * 4, width: self.planScr.frame.size.width, height: 281)
        
        
        uAttentionView.setUattentionViewDate(food)
        
        self.planScr.addSubview(uAttentionView)
        
    }
    //方案运动视图
    var uSportTrickView:SportTrickView!
    
    func advieceAct(_ tag: Int) {
        switch tag {
        case 234:
            print("饮食")
            
            
            
            if self.foodBgView != nil {
                self.foodBgView.isHidden = true
            }
            
            
            
            self.planScr.contentSize = CGSize(width: UIScreen.main.bounds.width , height: 301 * self.Hsize + 114 + 94 + 294 + 110 * self.Hsize * 4 + 281)
            
            if self.uSportTrickView != nil {
                self.uSportTrickView.isHidden = true
            }
            
            
        case 235:
            print("运动")
            if self.foodBgView == nil {
                self.loadFoodBGViews()
            }else{
                self.foodBgView.isHidden = false
            }

            self.planScr.contentSize = CGSize(width: UIScreen.main.bounds.width , height: 301 * self.Hsize + 114 + 94 + 881 + 35)
            
            if self.uSportTrickView == nil {
                self.loadUsportTrickView(self.planAllDataDic)
            }else{
                self.uSportTrickView.isHidden = false
            }
            
            
            
            
            
        default:
            break
        }
    }
    
    var foodBgView:UIView!
    //加载一个遮罩饮食的视图
    func loadFoodBGViews(){
        if self.foodBgView == nil {
            self.foodBgView = UIView(frame: CGRect(x: 0,y: 301 * self.Hsize + 114 + 94,width: self.planScr.frame.size.width,height: 2000))
            self.foodBgView.backgroundColor = UIColor.white
            self.planScr.addSubview(self.foodBgView)
        }
    }
    
    
    //加载运动视图
    func loadUsportTrickView(_ sportDic:NSDictionary){
        if self.uSportTrickView == nil {
            
            
            self.uSportTrickView = Bundle.main.loadNibNamed("SportTrickView", owner: nil, options: nil)?.last as! SportTrickView
            
            self.uSportTrickView.frame = CGRect(x: 0, y: 301 * self.Hsize + 114 + 94, width: self.planScr.frame.size.width, height: 871)
            
            self.uSportTrickView.setSportTrickViewData(sportDic)
            self.planScr.addSubview(self.uSportTrickView)
        }
        
        
        
    }
    
    
    
    
    var planHUD:JGProgressHUD!
    
    
    //方案的所有数据
    var planAllDataDic:NSDictionary!
    
    //AMRK:获取方案->数据
    func getPlanJspData(){
        
        
        self.planHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.planHUD.textLabel.text = "加载中.."
        self.planHUD.show(in: self.view, animated: true)
        
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/report/getscheme.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "sensorsid":self.selectSensorsid,
        ]
        
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("方案：\(json)")
            
            
            
            var isHead = false
            
            if let data:NSDictionary = json["data"].dictionaryObject as NSDictionary? {
                
                
                self.planAllDataDic = data
                
                
                
                let food = data.value(forKey: "food") as! String
                isHead = data.value(forKey: "isHead") as! Bool
                
                //食物
                let Head = data.value(forKey: "Head") as! NSDictionary
                //身体状况
                let utype = Head.value(forKey: "utype") as! String
                //热量
                var headsize:Int = 0
                if let headsize1 = Head.value(forKey: "headsize") as? Int {
                    headsize = headsize1
                }
                
                //食物数组
                let detail = Head.value(forKey: "detail") as! NSArray
                
                
                let foodArray = NSMutableArray()
                let swopArray = NSMutableArray()
                for tmp in detail{
                    let tmpDic = tmp as! NSDictionary
                    
                    let swop = tmpDic.value(forKey: "swop") as! String
                    
                    let food = tmpDic.value(forKey: "food") as! NSArray
                    
                    swopArray.add(swop)
                    foodArray.add(food)
                    
                }
                
                //总体评价
                let evalua = data.value(forKey: "evalua") as! String
                
                
    
                
                self.uOverallEvaluationView.evaluationTextView.text = evalua
                
                
   
                
                //资料不完整 true
                if isHead == false { //此处应该为 false
                    print("资料不完整")
                    //重置
                    self.planScr.contentSize = CGSize(width: UIScreen.main.bounds.width , height: 301 * self.Hsize + 114)
                    
                    let yPoint:CGFloat = 301 * self.Hsize + 114.0
                    
                    self.laodIsHeadView(yPoint)
                    
                }else{

                    self.planScr.contentSize = CGSize(width: UIScreen.main.bounds.width , height: 301 * self.Hsize + 114 + 94 + 294)
                    //加载医生建议
                    self.laodDctorView()
                    
                    //加载食物交换份
                    self.loadUtypeFoodView(utype, energy: "\(headsize)千卡")
                    
                    //加载食物清单
                    self.loadFoodAdviceView(detail)
                    
                    //加载 注意事项
                    self.loadAttentionView(food)
                    
                }
                
                
            }
            
            
            
            self.planHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.planHUD.textLabel.text = "加载成功"
            self.planHUD.dismiss(afterDelay: 0.5, animated: true)
            
            
            
            }, failure: { () -> Void in
                
                print("false错误")
                
                self.planHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.planHUD.textLabel.text = "加载失败"
                self.planHUD.dismiss(afterDelay: 0.5, animated: true)
                
        })
        
    }
    
    //MARK:加载没有填写信息的视图
    var isHeadView:IsHeadView!

    func laodIsHeadView(_ yPoint:CGFloat){
        if self.isHeadView == nil {
            self.isHeadView = Bundle.main.loadNibNamed("IsHeadView", owner: nil, options: nil)?.last as! IsHeadView
            self.isHeadView.frame = CGRect(x: 0, y: yPoint, width: UIScreen.main.bounds.width, height: 329)
            
            self.isHeadView.addInforBtn.addTarget(self, action: #selector(URepViewController.btnAction(_:)), for: UIControlEvents.touchUpInside)
            
            self.isHeadView.addInforBtn.tag = 41501
            
            self.planScr.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 301 * self.Hsize + 114 + 329)
            self.planScr.addSubview(self.isHeadView)
        }
    }
    //MARK:完善资料
    func btnAction(_ btn:UIButton){
        switch btn.tag {
        case 41501:
            //去完善资料

            let myInfViewController = MyInfViewController()
            
            self.navigationController?.pushViewController(myInfViewController, animated: true)
            
        default:
            break
        }
    }
    
    
    //MARK:获取报告的分析页面数据
    func getAnalyzeJsp(){ //获取报告的分析页面数据
        
        self.fenxiHud = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.fenxiHud.textLabel.text = "加载中.."
        self.fenxiHud.show(in: self.view, animated: true)
        
        
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/report/getanalyze.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        var dicDPost = NSDictionary()
        dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
        ]
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
            
            self.fenxiHud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.fenxiHud.textLabel.text = "加载完成"
            self.fenxiHud.dismiss(afterDelay: 0.5, animated: true)
            
            if let data:NSDictionary = json["data"].dictionaryObject as NSDictionary? {
                print(data)
                let analy = data.value(forKey: "analy") as! String
                let tlong = data.value(forKey: "tlong") as! String
                let age = data.value(forKey: "age") as! String
                
                let sdbglist = data.value(forKey: "sdbglist") as! NSArray
                
                var anlyzeStartTimeArray = [String]()
                var sdbgArray = [NSNumber]()
                
                for tmp in sdbglist {
                    let tmpDic = tmp as! NSDictionary
                    
                    var st = tmpDic.value(forKey: "st") as! String
//                    var et = tmpDic.valueForKey("et") as! String
                    let sdbg = tmpDic.value(forKey: "sdbg") as! NSNumber
                    
                    if (st.characters.count > 10){
//                        st = (st as NSString).substring(with: NSRange(0...10))
                        st = (st as NSString).substring(with: NSRange(location: 0, length: 11))
                    }

                    anlyzeStartTimeArray.append(st)
                    sdbgArray.append(sdbg)
                }
                
                //刷新图表视图数据
                self.uPillarView.insertDateLoadChartView(anlyzeStartTimeArray,sdbgArray: sdbgArray)
                //刷新其他视图数据
                self.uSomeAnalyzeView.insertDateLoadSomeAnalyzeView(analy, tlong: tlong, age: age)
                
            }

            }, failure: { () -> Void in
                
                print("false错误")
                self.fenxiHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.fenxiHud.textLabel.text = "加载失败"
                self.fenxiHud.dismiss(afterDelay: 0.5, animated: true)
        })
        
        
        
    }
    
    
    //Mark:加载评分视图(统计)
    func loadUevaluationView(_ value:CGFloat,date:String){
        if self.uEvaluationView == nil {
            self.uEvaluationView = UevaluationView(frame: CGRect(x: 0,y: 0,width: self.Usize.width,height: 160))
            
//            let value:CGFloat = 100
            self.uEvaluationView.loadUevaluationAnyView(value)
            self.uEvaluationView.initUevaluationView(value)
            
            //初始化日期选择视图
//            let date = "2099-55-99"
            self.uEvaluationView.loadUevaluationDateView(date)
            
            //添加点击事件
            let tap = UITapGestureRecognizer(target: self, action: #selector(URepViewController.viewTap(_:)))
            self.uEvaluationView.uDateView.addGestureRecognizer(tap)
            self.uEvaluationView.uDateView.tag = 20
            
            
            self.uEvaluationView.backgroundColor = UIColor.white
            self.segmentScr.addSubview(self.uEvaluationView)
        }
    }
    //MARK:加载查看更多(统计)
    func loadUlookMoreView(){
        //父
        let dynamicView = UIView(frame: CGRect(x: 0,y: 160,width: self.Usize.width,height: 30))
        dynamicView.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1)
        self.segmentScr.addSubview(dynamicView)
        //子
        let dynamicLabel = UILabel(frame: CGRect(x: 14,y: 0,width: self.Usize.width,height: 30))
        dynamicLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        dynamicLabel.text = "动态血糖变化"
        dynamicLabel.font = UIFont.systemFont(ofSize: 15)
        dynamicView.addSubview(dynamicLabel)
        
        //查看跟多按钮
        let moreView = UIView(frame: CGRect(x: 0,y: 190,width: self.Usize.width,height: 30))
        moreView.backgroundColor = UIColor.white
        self.segmentScr.addSubview(moreView)
        //按钮
        let moreBtn = UIButton(frame: CGRect(x: moreView.frame.size.width - 50 - 13.5,y: 0,width: 50,height: 30))
        moreBtn.addTarget(self, action: #selector(URepViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        moreBtn.tag = 2
        
        moreBtn.setTitle("查看更多", for: UIControlState())
        moreBtn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), for: UIControlState())
        moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        moreView.addSubview(moreBtn)
        
    
    }
    
    var continuChartView:ContinuouChartView!
    //加载chart
    func loadChartView(){
        
        if self.continuChartView == nil {
            self.continuChartView = ContinuouChartView(frame: CGRect(x: 0,y: 220,width: self.Usize.width,height: 227))
            continuChartView.backgroundColor = UIColor.white
            self.segmentScr.addSubview(continuChartView)
        }
   
    }
    
    
    var uSomeView:UsomeView!
    //加载some小视图(统计)
    func loadUsomeView(){
        if self.uSomeView == nil {
            self.uSomeView = UsomeView(frame: CGRect(x: 0,y: 447,width: self.Usize.width,height: 128 * 4 + 41))
            
            self.uSomeView.uRepViewCtr = self
            
            uSomeView.backgroundColor = UIColor.white
            self.segmentScr.addSubview(uSomeView)
        }
  
    }
    //加载详解视图
    var breakDownTV = UITextView()
    func loadUbreakDownView(){
        let ubView = UIView(frame: CGRect(x: 0,y: 512 + 41 + 447,width: self.Usize.width,height: 100))
        ubView.backgroundColor = UIColor.white
        self.segmentScr.addSubview(ubView)
        
        let xiangjieLabel = UILabel(frame: CGRect(x: 14,y: 0,width: 60,height: 12))
        xiangjieLabel.font = UIFont.systemFont(ofSize: 17)
        xiangjieLabel.textColor = UIColor(red: 110/255.0, green: 110/255.0, blue: 110/255.0, alpha: 1)
        xiangjieLabel.text = "详解:"
        ubView.addSubview(xiangjieLabel)
        
        self.breakDownTV.frame = CGRect(x: 27, y: 20, width: self.Usize.width - 27 - 18, height: 70)
        self.breakDownTV.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        self.breakDownTV.text = "正在加载"
        self.breakDownTV.font = UIFont.systemFont(ofSize: 15)
        self.breakDownTV.isEditable = false
        
        ubView.addSubview(self.breakDownTV)
        
        
    }
    
    
    //MARK:统计分析方案回调
    func myClosure(_ tag:Int)->Void{
        //这句话什么时候执行？，闭包类似于oc中的block或者可以理解成c语言中函数，只有当被调用的时候里面的内容才会执行
        switch tag {
        case 0:
            //print("统计")
            //加载统计scr
            self.loadScrollView(MyScroll.segmentScr)
        case 1:
            //print("分析")
            //加载分析scr
            self.loadScrollView(MyScroll.analysisScr)
        case 2:
            //print("方案")
            //加载方案scr
            self.loadScrollView(MyScroll.planScr)
        default:
            break
        }
        
        
        
        
    }
    
    var uSecIndex = 0
    
    func dateClosure(_ tag:Int,secInt:Int,value:String)->Void{
//        print("回调\(tag)--secInt:\(secInt)-valeu\(value)")
        
        switch tag {
        case 0:
            print("关闭")
        case 1:
            print("确定")
            
            
            if self.uSecIndex != secInt {

                self.dateSelect = value

                let sid = self.uSidArray[secInt] as! String
                print("sisid:\(sid)")

                self.uFinish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.uFinish.textLabel.text = "加载中.."
                self.uFinish.show(in: self.view, animated: true)
                //获取探头id 报告
                self.getReportHome(sid)
                //设置当前选择的sid
                self.selectSensorsid = sid
                
                self.uSecIndex = secInt
                
   
                
                //清除视图
                self.agienSelectSidToClearView()
 
            }else{
                print("上次选的")
            }
 
        default:
            break
        }
        self.uDateBgViewAct()
    }
    //重新选择sid 后，
    func agienSelectSidToClearView(){
        //分析
        if self.analysisScr != nil{
            self.analysisScr.removeFromSuperview()
            self.analysisScr = nil
        }
        if self.uPillarView != nil{
            self.uPillarView.removeFromSuperview()
            self.uPillarView = nil
        }
        if self.uSomeAnalyzeView != nil {
            self.uSomeAnalyzeView.removeFromSuperview()
            self.uSomeAnalyzeView = nil
        }
        //方案
        if self.planScr != nil {
            self.planScr.removeFromSuperview()
            self.planScr = nil
        }
        if self.uOverallEvaluationView != nil {
            self.uOverallEvaluationView.removeFromSuperview()
            self.uOverallEvaluationView = nil
        }
        if self.isHeadView != nil {
            self.isHeadView.removeFromSuperview()
            self.isHeadView = nil
        }
        if self.uAdviceView != nil {
            self.uAdviceView.removeFromSuperview()
            self.uAdviceView = nil
        }
        if self.uSportTrickView != nil {
            self.uSportTrickView.removeFromSuperview()
            self.uSportTrickView = nil
        }
        if self.foodBgView != nil {
            self.foodBgView.removeFromSuperview()
            self.foodBgView = nil
        }
        
    }
    
    
    
    
    func clearSomeView(){
        if self.uEvaluationView != nil {
            self.uEvaluationView.removeFromSuperview()
            self.uEvaluationView = nil
        }
   
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
