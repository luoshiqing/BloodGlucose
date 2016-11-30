//
//  CurrentScreenViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/26.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class CurrentScreenViewController: UIViewController ,ChartViewDelegate ,IAxisValueFormatter{

    //接收上级的数据
    var recDataArray:NSArray!
    var firstDay:String!
    var currentDay:String!
    //----是否有参比
    var isFinger:Bool = true
    var fristFinger:NSArray!

    var dayArray:NSMutableArray! //日期天数数组
    var deteilDayArray:NSMutableArray! //详细日期数组
    //记录日期天数数组的个数
    var dayArrayCount:Int!
    
    //记录选择日期数组的index
    var selectDayArrayCount:Int = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.selectDayArrayCount = self.dayArrayCount
        //设置视图
        self.setView()
        //初始化chart基本属性
        self.setChartBasicAttributes()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showChartView()
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    //设置为 横屏
    override var shouldAutorotate : Bool
    {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return  UIInterfaceOrientationMask.all
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        
        return UIInterfaceOrientation.landscapeRight
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var closeBtn = UIButton()
    var lineView:LineChartView!
    
    var yestodayBtn:UIButton!
    var nextdayBtn:UIButton!
    var btnView:UIView!
    var dayTimeLabel:UILabel!
    //分段选择
    var mySegmentedCtl:UISegmentedControl!
    
    func setView(){

        //图形视图
        self.lineView = LineChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width - 38))
        self.lineView.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(self.lineView)
        
        //按钮
        self.closeBtn.frame = CGRect(x: 28, y: 3, width: 35, height: 35)
        self.view.addSubview(self.closeBtn)
        self.closeBtn.setImage(UIImage(named: "xicon.png"), for: UIControlState())
        self.closeBtn.addTarget(self, action: #selector(ScrennChartViewController.btnAction(_:)), for: UIControlEvents.touchUpInside)
        self.closeBtn.tag = 406020
        
        
        //分段选择
        let items = ["单日" as AnyObject,"多日" as AnyObject] as [AnyObject]
        self.mySegmentedCtl = UISegmentedControl(items: items)
        
        
        self.mySegmentedCtl.frame = CGRect(x: UIScreen.main.bounds.height - 100, y: UIScreen.main.bounds.width - 35 ,width: 90, height: 32)
        self.mySegmentedCtl.selectedSegmentIndex = 0
        
        self.mySegmentedCtl.tintColor = UIColor.orange
        self.mySegmentedCtl.addTarget(self, action: #selector(ScrennChartViewController.segmentDidchange(_:)), for: UIControlEvents.valueChanged)
        self.view.addSubview(self.mySegmentedCtl)
        
        //单日上下一天按钮
        self.btnView = UIView(frame: CGRect(x: UIScreen.main.bounds.height - 100 - 140,y: UIScreen.main.bounds.width - 35,width: 123,height: 32))
        self.btnView.backgroundColor = UIColor.orange
        self.view.addSubview(self.btnView)
        //设置圆角
        self.btnView.layer.cornerRadius = 5
        self.btnView.clipsToBounds = true
        //上一天
        self.yestodayBtn = UIButton(frame: CGRect(x: 1,y: 1,width: 60,height: 30))
        self.yestodayBtn.backgroundColor = UIColor.white
        self.yestodayBtn.setTitle("上一天", for: UIControlState())
        self.yestodayBtn.setTitleColor(UIColor.orange, for: UIControlState())
        self.yestodayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.yestodayBtn.addTarget(self, action: #selector(ScrennChartViewController.btnAction(_:)), for: UIControlEvents.touchUpInside)
        self.yestodayBtn.tag = 406051
        //设置半边圆角
        let maskPath = UIBezierPath(roundedRect: self.yestodayBtn.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.topLeft], cornerRadii: CGSize(width: 4.5, height: 4.5))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.yestodayBtn.bounds
        maskLayer.path = maskPath.cgPath
        self.yestodayBtn.layer.mask = maskLayer
        
        self.btnView.addSubview(self.yestodayBtn)
        //下一天
        self.nextdayBtn = UIButton(frame: CGRect(x: 62,y: 1,width: 60,height: 30))
        self.nextdayBtn.backgroundColor = UIColor.white
        self.nextdayBtn.setTitle("下一天", for: UIControlState())
        self.nextdayBtn.setTitleColor(UIColor.orange, for: UIControlState())
        self.nextdayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.nextdayBtn.addTarget(self, action: #selector(ScrennChartViewController.btnAction(_:)), for: UIControlEvents.touchUpInside)
        self.nextdayBtn.tag = 406052
        //设置半边圆角
        let maskPath1 = UIBezierPath(roundedRect: self.nextdayBtn.bounds, byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 4.5, height: 4.5))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.nextdayBtn.bounds
        maskLayer1.path = maskPath1.cgPath
        self.nextdayBtn.layer.mask = maskLayer1
        
        self.btnView.addSubview(self.nextdayBtn)
        //单日日期label
        self.dayTimeLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.height - 100 - 140 - 140,y: UIScreen.main.bounds.width - 35,width: 120,height: 32))
        
//        let firstStri:String = (firstDay as NSString).substring(with: NSRange(0...9))
        let firstStri:String = (firstDay as NSString).substring(with: NSRange(location: 0, length: 10))
        
        
        self.dayTimeLabel.text = firstStri
        
        self.dayTimeLabel.textColor = UIColor.orange
        self.dayTimeLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(self.dayTimeLabel)
        
    }

    //当前查看的图形
    var chartIndex = 0
    //最大能看多少天数据
    var chartMaxIndex = 6
    
    var lastfinish:JGProgressHUD!
    var nextfinish:JGProgressHUD!
    //MARK:按钮点击事件
    func btnAction(_ send:UIButton){
        switch send.tag {
        case 406020:
            self.dismiss(animated: true, completion: nil)
        case 406051:
            print("上一天")
            
            if self.selectDayArrayCount > 1{
                
                self.lastfinish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.lastfinish.textLabel.text = "读取数据"
                self.lastfinish.show(in: self.lineView, animated: true)
                
                DispatchQueue.global(qos: .default).async {
                    //有参比的情况
                    if self.isFinger == true {
                        
                        //                        let (a,b,c) = self.getYestDay(self.firstDay)
                        
                        let a:String = self.dayArray[self.selectDayArrayCount - 2] as! String
                        
                        let tmp = self.deteilDayArray[self.selectDayArrayCount - 2] as! String
                        
                        //                        let b:String = (tmp as NSString).substring(with: NSRange(0...9))
                        //
                        //                        let c:String = (tmp as NSString).substring(with: NSRange(0...18))
                        
                        let b:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 10))
                        
                        let c:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 19))
                        
                        let (xArray,yArray,dataArray,dataCount) = StatisticService().getFirstData(a, firstFinger: self.fristFinger, recDataArray: self.recDataArray,KkValue: self.Kvalue)
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            //绘制图像
                            self.loadChartView(xArray, yArray: yArray, dataArray: dataArray, dataCount: dataCount)
                            
                            self.firstDay = c
                            self.dayTimeLabel.text = b
                            self.chartIndex -= 1
                            
                            self.selectDayArrayCount -= 1
                            
                            self.lastfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                            self.lastfinish.textLabel.text = "读取成功"
                            self.lastfinish.dismiss(afterDelay: 0.5, animated: true)
                            
                        })
                        
                        //没有参比的情况
                    }else{
                        
                        //加载电流图形
                        //                        let (a,b,c) = self.getYestDay(self.firstDay)
                        
                        let a:String = self.dayArray[self.selectDayArrayCount - 2] as! String
                        
                        let tmp = self.deteilDayArray[self.selectDayArrayCount - 2] as! String
                        
                        //                        let b:String = (tmp as NSString).substring(with: NSRange(0...9))
                        //
                        //                        let c:String = (tmp as NSString).substring(with: NSRange(0...18))
                        
                        let b:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 10))
                        
                        let c:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 19))
                        
                        let (xArray,yArray,dataArray) = StatisticService().getFirstDataAndNotFinger(a, recDataArray: self.recDataArray)
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            
                            self.setOneDayCharts(xArray, yVls: yArray, data: dataArray)
                            
                            self.chartIndex -= 1
                            self.dayTimeLabel.text = b
                            self.firstDay = c
                            
                            self.selectDayArrayCount -= 1
                            
                            self.lastfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                            self.lastfinish.textLabel.text = "电流数据"
                            self.lastfinish.dismiss(afterDelay: 0.5, animated: true)
                            
                        })
                        
                    }
                }
                
//                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
//                    
//                    
// 
//                })
            }else{
                print("已经是第一天了")
                let actionSheet = UIAlertController(title: "已经是第一天了", message: "", preferredStyle: UIAlertControllerStyle.alert)
                //取消
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
                //因为这个是控制器，需要添加到视图
                self.present(actionSheet, animated: true, completion: nil)
            }
        case 406052:
            print("下一天")
 
            if self.selectDayArrayCount < self.dayArrayCount{
                
                self.nextfinish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.nextfinish.textLabel.text = "读取数据"
                self.nextfinish.show(in: self.lineView, animated: true)
                
                DispatchQueue.global(qos: .default).async {
                    //有参比的情况
                    if self.isFinger == true {
                        
                        //                        let (a,b,c) = self.getNextDay(self.firstDay)
                        
                        let a:String = self.dayArray[self.selectDayArrayCount] as! String
                        
                        let tmp = self.deteilDayArray[self.selectDayArrayCount] as! String
                        
                        //                        let b:String = (tmp as NSString).substring(with: NSRange(0...9))
                        //
                        //                        let c:String = (tmp as NSString).substring(with: NSRange(0...18))
                        
                        
                        
                        let b:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 10))
                        
                        let c:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 19))
                        
                        let (xArray,yArray,dataArray,dataCount) = StatisticService().getFirstData(a, firstFinger: self.fristFinger, recDataArray: self.recDataArray,KkValue: self.Kvalue)
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            //绘制图像
                            self.loadChartView(xArray, yArray: yArray, dataArray: dataArray, dataCount: dataCount)
                            
                            self.firstDay = c
                            self.dayTimeLabel.text = b
                            self.chartIndex += 1
                            
                            self.selectDayArrayCount += 1
                            
                            self.nextfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                            self.nextfinish.textLabel.text = "读取成功"
                            self.nextfinish.dismiss(afterDelay: 0.5, animated: true)
                            
                        })
                        
                        //没有参比的情况
                    }else{
                        
                        //加载电流图形
                        
                        let a:String = self.dayArray[self.selectDayArrayCount] as! String
                        
                        let tmp = self.deteilDayArray[self.selectDayArrayCount] as! String
  
                        
                        let b:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 10))
                        
                        let c:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 19))
                        
                        let (xArray,yArray,dataArray) = StatisticService().getFirstDataAndNotFinger(a, recDataArray: self.recDataArray)
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            
                            self.setOneDayCharts(xArray, yVls: yArray, data: dataArray)
                            
                            self.chartIndex += 1
                            self.dayTimeLabel.text = b
                            self.firstDay = c
                            
                            self.selectDayArrayCount += 1
                            
                            self.nextfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                            self.nextfinish.textLabel.text = "电流数据"
                            self.nextfinish.dismiss(afterDelay: 0.5, animated: true)
                            
                        })
                        
                        
                        
                    }
                }

                
            }else{

                //初始化 preferredStyle （.Alert 为类型）
                let actionSheet = UIAlertController(title: "已经是最后一天了", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                //取消
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
                //因为这个是控制器，需要添加到视图
                self.present(actionSheet, animated: true, completion: nil)
                
                
            }
            
            
            
        default:
            break
        }
    }
    
    func getYestDay(_ dayTime:String) ->(String,String,String){
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: dayTime)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let nextDate = dateStamp - 24 * 60 * 60
        let recordDate = Date(timeIntervalSince1970: Double(nextDate))
        let timeStr = dfmatter.string(from: recordDate)

        let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
        let labStr:String = (timeStr as NSString).substring(with: NSRange(location: 0, length: 10))
        
        let allTime:String = (timeStr as NSString).substring(with: NSRange(location: 0, length: 19))
        
        
        return (tmpStri,labStr,allTime)
    }
    func getNextDay(_ dayTime:String) ->(String,String,String){
        
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: dayTime)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let nextDate = dateStamp + 24 * 60 * 60
        let recordDate = Date(timeIntervalSince1970: Double(nextDate))
        let timeStr = dfmatter.string(from: recordDate)

        
        let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
        let labStr:String = (timeStr as NSString).substring(with: NSRange(location: 0, length: 10))
        
        let allTime:String = (timeStr as NSString).substring(with: NSRange(location: 0, length: 19))
        
        return (tmpStri,labStr,allTime)
    }
    
    var moreDayLineChartView:LineChartView!
    var loadMore:JGProgressHUD!
    //Mark:-分段选择
    func segmentDidchange(_ segmented:UISegmentedControl){
        
        switch segmented.selectedSegmentIndex {
        case 0:
            print("单日")
 
            self.lineView.isHidden = false
            self.btnView.isHidden = false
            self.dayTimeLabel.isHidden = false
            if self.moreDayLineChartView != nil {
                self.moreDayLineChartView.isHidden = true
            }
            
        case 1:
            print("多日")
            
            self.lineView.isHidden = true
            self.btnView.isHidden = true
            self.dayTimeLabel.isHidden = true
            
            if self.moreDayLineChartView == nil {
                self.moreDayLineChartView = LineChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height - 38))
                self.view.addSubview(self.moreDayLineChartView)
                
                self.moreDayLineChartView.backgroundColor = UIColor.groupTableViewBackground
                
                self.view.bringSubview(toFront: self.closeBtn)
                
                
                //设置基本属性
                self.setBaseChartView()
                
                
                self.loadMore = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.loadMore.textLabel.text = "读取数据"
                self.loadMore.show(in: self.moreDayLineChartView, animated: true)
                
                DispatchQueue.global(qos: .default).async {
                    //MARK:计算数据，
                    let (xVals,yArry,dataIntArray,dateArray) = self.getMoreDayDate(self.recDataArray)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        self.diejiaChartView(xVals, yArray: yArry, dataIntArray: dataIntArray, dateArray: dateArray)
                        
                        self.loadMore.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.loadMore.textLabel.text = "读取成功"
                        self.loadMore.dismiss(afterDelay: 0.5, animated: true)
                    })
                }

                
            }else{
                self.moreDayLineChartView.isHidden = false
            }
            
            
        default:
            break
        }
    }
    func setBaseChartView(){
        self.moreDayLineChartView.delegate = self

        
        self.moreDayLineChartView.chartDescription?.text = ""
        self.moreDayLineChartView.noDataText = ""
        
        
        //放大
        self.moreDayLineChartView.pinchZoomEnabled = false
        self.moreDayLineChartView.drawGridBackgroundEnabled = false
        //放大倍数
        self.moreDayLineChartView.viewPortHandler.setMaximumScaleY(1)
        self.moreDayLineChartView.viewPortHandler.setMaximumScaleX(20)
        
        //关闭底部图例显示
        let legend = self.moreDayLineChartView.legend
        legend.enabled = false
        
        
        self.moreDayLineChartView.dragEnabled = true
        self.moreDayLineChartView.scaleXEnabled = true
        self.moreDayLineChartView.pinchZoomEnabled = true
        self.moreDayLineChartView.drawGridBackgroundEnabled = false
        
        
        let leftAxis:YAxis = self.moreDayLineChartView.leftAxis
        leftAxis.removeAllLimitLines()


        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 10
        
        
        leftAxis.drawZeroLineEnabled = false
        
        
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.drawGridLinesEnabled = false
        //设置x坐标轴 颜色
        leftAxis.axisLineColor = UIColor.black
        

        self.moreDayLineChartView.rightAxis.enabled = false
        
        
        let xAxis:XAxis = self.moreDayLineChartView.xAxis
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        xAxis.labelFont = UIFont(name: "Helvetica", size: 10)!
        
        
        
        xAxis.drawGridLinesEnabled = false
        //设置y坐标轴 颜色
        xAxis.axisLineColor = UIColor.black
        
        xAxis.valueFormatter = self
        xAxis.granularity = 1.0
        
        self.moreDayLineChartView.xAxis.enabled = true
        
        
        
        self.moreDayLineChartView.animate(xAxisDuration: 1,yAxisDuration: 1, easingOption: ChartEasingOption.easeInOutQuart)
        
        
        //添加血糖高位警示线
        
        let upperLimit:ChartLimitLine = ChartLimitLine(limit: 7.8)
        upperLimit.lineColor = UIColor.green
        upperLimit.lineWidth = 0.5
        upperLimit.lineDashLengths = [4,4]
        
        //添加血糖低位警示线
        let lowerLimit:ChartLimitLine = ChartLimitLine(limit: 3.9)
        lowerLimit.lineColor = UIColor.gray
        lowerLimit.lineWidth = 0.5
        lowerLimit.lineDashLengths = [4,4]
        
        //添加11.1血糖警示线
        let lowerLimit11:ChartLimitLine = ChartLimitLine(limit: 11.1)
        lowerLimit11.lineColor = UIColor.red
        lowerLimit11.lineWidth = 0.5
        lowerLimit11.lineDashLengths = [4,4]
        
        
        leftAxis.addLimitLine(lowerLimit11)
        leftAxis.addLimitLine(upperLimit)
        leftAxis.addLimitLine(lowerLimit)
        

        
        let marker = BalloonMarker(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), font: UIFont(name: "Helvetica", size: 12)!, textColor: UIColor.black, insets: UIEdgeInsets(top: 8, left: 8, bottom: 28, right: 8))
        marker.minimumSize = CGSize(width: 10, height: 5)
        self.moreDayLineChartView.marker = marker
        
        
        self.moreDayLineChartView.setVisibleXRangeMaximum(60)
    }
    
    //设置基本属性
    func setChartBasicAttributes(){
        self.lineView.delegate = self

        self.lineView.chartDescription?.text = ""
        self.lineView.noDataText = ""
 
        //放大
        self.lineView.pinchZoomEnabled = false
        self.lineView.drawGridBackgroundEnabled = false
        //放大倍数
        self.lineView.viewPortHandler.setMaximumScaleY(1)
        self.lineView.viewPortHandler.setMaximumScaleX(20)
        
        //打开底部图例显示
        let legend = self.lineView.legend
        legend.enabled = true
        
        
        self.lineView.dragEnabled = true
        self.lineView.scaleXEnabled = true
        self.lineView.pinchZoomEnabled = true
        self.lineView.drawGridBackgroundEnabled = false
        
        
        let leftAxis:YAxis = self.lineView.leftAxis
        leftAxis.removeAllLimitLines()


        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 10
        
        
        leftAxis.drawZeroLineEnabled = false
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.drawGridLinesEnabled = false
        //设置坐y标轴 颜色
        leftAxis.axisLineColor = UIColor.black
        

        
        self.lineView.rightAxis.enabled = false
        
        
        let xAxis:XAxis = self.lineView.xAxis
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        xAxis.labelFont = UIFont(name: "Helvetica", size: 10)!
        
        
        
        xAxis.drawGridLinesEnabled = false
        //设置坐x标轴 颜色
        xAxis.axisLineColor = UIColor.black
        
        xAxis.valueFormatter = self
        xAxis.granularity = 1.0
        
        self.lineView.xAxis.enabled = true
        
        
        
        self.lineView.animate(xAxisDuration: 1,yAxisDuration: 1, easingOption: ChartEasingOption.easeInOutQuart)
        
        
        
        if self.isFinger == true {
            //添加血糖高位警示线
            let upperLimit:ChartLimitLine = ChartLimitLine(limit: 7.8)
            upperLimit.lineColor = UIColor.green
            upperLimit.lineWidth = 0.5
            upperLimit.lineDashLengths = [4,4]
            
            //添加血糖低位警示线
            let lowerLimit:ChartLimitLine = ChartLimitLine(limit: 3.9)
            lowerLimit.lineColor = UIColor.gray
            lowerLimit.lineWidth = 0.5
            lowerLimit.lineDashLengths = [4,4]
            
            //添加11.1警报血糖警示线
            let warnLimit:ChartLimitLine = ChartLimitLine(limit: 11.1)
            warnLimit.lineColor = UIColor.red
            warnLimit.lineWidth = 0.5
            warnLimit.lineDashLengths = [4,4]
            
            
            leftAxis.addLimitLine(upperLimit)
            leftAxis.addLimitLine(lowerLimit)
            leftAxis.addLimitLine(warnLimit)
        }
        

        
        let marker = BalloonMarker(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), font: UIFont(name: "Helvetica", size: 12)!, textColor: UIColor.black, insets: UIEdgeInsets(top: 5, left: 5, bottom: 15, right: 15))
        marker.minimumSize = CGSize(width: 10, height: 5)
        self.lineView.marker = marker
        
        self.lineView.setVisibleXRangeMaximum(60)
        
        
        
    }

    
    var Kvalue:Double = 1.0
    
    func showChartView(){
        
        self.lastfinish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.lastfinish.textLabel.text = "读取数据"
        self.lastfinish.show(in: self.lineView, animated: true)
        
        DispatchQueue.global(qos: .default).async {
            //加载chart视图
            if (self.isFinger == true) { //有参比的情况
                
                //获取 K 值
                self.Kvalue = StatisticService().getKvalue(firstFinger: self.fristFinger, recDataArray: self.recDataArray)
                print("Kvalue:\(self.Kvalue)")
                
                let (xArray,yArray,dataArray,dataCount) = StatisticService().getFirstData(self.currentDay, firstFinger: self.fristFinger, recDataArray: self.recDataArray,KkValue: self.Kvalue)
                DispatchQueue.main.async(execute: { () -> Void in
                    //绘制图像
                    self.loadChartView(xArray, yArray: yArray, dataArray: dataArray, dataCount: dataCount)
                    
                    self.lastfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.lastfinish.textLabel.text = "读取成功"
                    self.lastfinish.dismiss(afterDelay: 0.5, animated: true)
                    
                })
                
                
            }else{
                //加载电流图形
                let (xArray,yArray,dataArray) = StatisticService().getFirstDataAndNotFinger(self.currentDay, recDataArray: self.recDataArray)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    
                    self.setOneDayCharts(xArray, yVls: yArray, data: dataArray)
                    
                    
                    self.lastfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.lastfinish.textLabel.text = "电流数据"
                    self.lastfinish.dismiss(afterDelay: 0.5, animated: true)
                })
            }

        }
        

        
    }
    
    var namesArray = ["电流图形","血糖图形"]
    //MARK:－多日->绘制图形
    func loadChartView(_ xArray:NSMutableArray,yArray:NSMutableArray,dataArray:NSMutableArray,dataCount:Int){
        
        //        print("yArray:\(yArray)")
        
        var colorArray = [UIColor]()
        colorArray = [UIColor.gray,
                      UIColor.red]
        //解析数据
        
        var dataSets:[ChartDataSet] = []
        var xVals = [String]()
        
        var numMax = 0
        
        for xxx in xArray {
            let xVals1 = xxx as! [String]
            xVals = xVals + xVals1
        }
        self.myxVals = xVals
        
        for maxmax in dataArray {
            let maxArray = maxmax as! [Int]
            
            //基于获取到的血糖数值设置图示最大值最小值范围
            numMax = maxArray.reduce(Int.min, { max($0, $1) })
            
            
        }
        
        for max1 in 0  ..< dataArray.count {
            
            let aaaarray1:[Int] = dataArray[max1] as! [Int]
            
            if max1 == 0 {
                
                numMax = aaaarray1.reduce(Int.min, { max($0, $1) })
            }else{
                let  bbbb = aaaarray1.reduce(Int.min, { max($0, $1) })
                if(bbbb > numMax){
                    numMax = bbbb
                }
            }
            
        }
        //设置天数分割线
        
        let leftAxis:XAxis = self.lineView.xAxis
        
        
        leftAxis.removeAllLimitLines()
        
        
        let lowerLimit:ChartLimitLine = ChartLimitLine(limit: Double(dataCount))
        lowerLimit.lineColor = UIColor.gray
        lowerLimit.lineWidth = 1
        lowerLimit.lineDashLengths = [2,4]
        
        leftAxis.addLimitLine(lowerLimit)
        
        
        
        for index in 0 ..< yArray.count {
            
            let yVals1 = yArray[index]
            
            let yVals:[ChartDataEntry] = yVals1 as! [ChartDataEntry]
            
            
            let set = LineChartDataSet(values: yVals, label: self.namesArray[index])
            let color:UIColor = colorArray[index]
            
            set.setColor(color)
            set.setCircleColor(UIColor.black)
            set.lineWidth = 1
            set.circleRadius = 3.0
            set.drawCirclesEnabled = false
            set.drawValuesEnabled = false
            set.drawCircleHoleEnabled = false
            set.highlightEnabled = true
            set.fillColor = UIColor.gray
            
            
            dataSets.append(set)
            
            
            
            let leftAxis1:YAxis = self.lineView.leftAxis
            
            
            print("numMax:\(numMax)")
            if numMax >= 8{
                leftAxis1.axisMaximum = Double(numMax + 4)
            }else{
                leftAxis1.axisMaximum = 10
            }
            
            
            
            
            let data: LineChartData = LineChartData(dataSets: dataSets)
            
            
            self.lineView.data = data
//            self.lineView.setVisibleXRangeMaximum(480)
//            self.lineView.moveViewToX(Double(yVals.count))
//            
//            self.lineView.highlightValue(x: Double(yVals.count), dataSetIndex: yVals.count, callDelegate: false)
            
        }
        
        
    }
    
    //绘制图形
    func setOneDayCharts(_ xVls:[String],yVls:[ChartDataEntry],data:[Int]){
        
        self.myxVals = xVls
        
        var dataSets:[ChartDataSet] = []
        
        let set1 = LineChartDataSet(values: yVls, label: "电流图形")
        //设置图形线条颜色
        //        set1.setColor(UIColor(red: 64/255.0, green: 224/255.0, blue: 208/255.0, alpha: 1))
        set1.setColor(UIColor.gray)
        
        set1.setCircleColor(UIColor.black)
        
        //图形线条 粗细
        set1.lineWidth = 1.3
        set1.circleRadius = 3.0
        set1.drawCirclesEnabled = false
        set1.drawValuesEnabled = false
        set1.drawCircleHoleEnabled = false
        set1.highlightEnabled = true
        set1.fillColor = UIColor.gray
        
        dataSets.append(set1)
        
        
        //基于获取到的血糖数值设置图示最大值最小值范围
        let numMax:Int = data.reduce(Int.min, { max($0, $1) })
        
        let lleftAxis:YAxis = self.lineView.leftAxis
        
        
        lleftAxis.axisMaximum = Double(numMax) + Double(numMax) * 0.55
        
        let data: LineChartData = LineChartData(dataSets: [dataSets as! IChartDataSet])
        
        self.lineView.data = data
        
        self.lineView.setVisibleXRangeMaximum(480)
        self.lineView.moveViewToX(Double(yVls.count))
        
        self.lineView.highlightValue(x: Double(yVls.count), dataSetIndex: yVls.count, callDelegate: false)
    }
    
    
    
    //计算多日数据
    func getMoreDayDate(_ recDataArray:NSArray) ->([String],NSMutableArray,NSMutableArray,NSMutableArray){
        //计算出有多少天，起始时间
        //所有数据数组
        let YallDataArray = NSMutableArray()
        let dataIntArray = NSMutableArray()
        let dateArray = NSMutableArray()
        
        let (_,allTiem,dayCount) = self.getFirstDayAndDayCount(recDataArray)
        
        
        
        let dayCountArray = NSMutableArray()
        
        for tmp in 0..<dayCount {
            
            let dfmatter = DateFormatter()
            dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dfmatter.date(from: allTiem)
            let dateStamp:TimeInterval = date!.timeIntervalSince1970
            let nextDate = dateStamp + Double(24 * 60 * 60 * tmp)
            let recordDate = Date(timeIntervalSince1970: Double(nextDate))
            let timeStr = dfmatter.string(from: recordDate)
            
            let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
            
            
            dayCountArray.add(tmpStri)
        }
        
        var xVals = [String]() //x值
        
        for index in 0 ..< 480 {
            if (index % 60 == 0){
                
                let time = index / 20
                
                xVals.append("\(time):00")
            }else{
                xVals.append("")
            }
        }
        
        
        var firstIndex = 0
        for index in 0 ..< dayCount {
            
            let tmpTime = dayCountArray[index] as! String
            
            dateArray.add(tmpTime) //时间值
            
            var yVals = [ChartDataEntry]()
            
            var datas = [Int]()
            
            
            var breakState:Bool = false
            
            var iidex = 0
            
            for item in recDataArray {
                let tmp = item as! BloodSugarModel
                
                let timeStamp = tmp.timeStamp
                let glucose:Double = Double(tmp.glucose)!
                
                let recordDate = Date(timeIntervalSince1970: Double(timeStamp!)!)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let timeStr = formatter.string(from: recordDate)

                let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
                let xV:String = (timeStr as NSString).substring(with: NSRange(location: 11, length: 5))
                
                
                var countIndex = iidex
                
                
                if tmpTime == tmpStri {
//                    print("等于")
                    datas.append(Int(glucose))
                    
                    
                    if firstIndex == 0 {
                        let xxxx = xV.components(separatedBy: ":")
                        countIndex = (Int(xxxx[0])! * 60 * 60 + Int(xxxx[1])! * 60) / 180
                        
                        
                    }
                    
//                    yVals.append(ChartDataEntry(x: glucose, y: Double(countIndex)))
                    yVals.append(ChartDataEntry(x: Double(countIndex), y: glucose))
                    
                    iidex += 1
                    breakState = true
                    
                }else{
                    
                    if breakState == true {
                        break
                    }
                    
                }
                
            }
            
            firstIndex += 1
            
            
            
            YallDataArray.add(yVals) //y的值
            dataIntArray.add(datas) //最大值
        }
        
        
        
        return (xVals,YallDataArray,dataIntArray,dateArray)
        
        
    }
    
    
    
    func getFirstDayAndDayCount(_ recDataArray:NSArray) ->(String,String,Int){
        
        let dayCountDic = NSMutableDictionary()
        
        
        let firstDay = (recDataArray[0] as! BloodSugarModel).timeStamp
        
        let recordDate = Date(timeIntervalSince1970: Double(firstDay!)!)
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let timeStr = formatter.string(from: recordDate)
        
        
        let firstStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
        
        for item in recDataArray {
            let tmp = item as! BloodSugarModel
            
            let timeStamp = tmp.timeStamp
            
            let recordDate = Date(timeIntervalSince1970: Double(timeStamp!)!)
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let timeStr = formatter.string(from: recordDate)
            
            
            let dayTime:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
            
            if dayCountDic[dayTime] == nil{
                dayCountDic[dayTime] = 0
            }
            
        }
        print("dayCountDic.allkeys:\(dayCountDic.allKeys)")
        
        return (firstStri,timeStr,dayCountDic.allKeys.count)
        
        
    }
    
    fileprivate var myxVals = [String]()
    
    //绘制多日叠加图形
    func diejiaChartView(_ xVals:[String],yArray:NSMutableArray,dataIntArray:NSMutableArray,dateArray:NSMutableArray){
        
        
        //        print("xVals:\(xVals)")
        self.myxVals = xVals
        
        var colorArray = [UIColor]()
        colorArray = [UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1),
                      UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1),
                      UIColor(red: 85/255.0, green: 212/255.0, blue: 255/255.0, alpha: 1),
                      UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1),
                      UIColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1),
                      UIColor(red: 253/255.0, green: 145/255.0, blue: 46/255.0, alpha: 1),
                      UIColor(red: 219/255.0, green: 112/255.0, blue: 147/255.0, alpha: 1),
                      UIColor(red: 255/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1),
                      UIColor(red: 64/255.0, green: 224/255.0, blue: 208/255.0, alpha: 1)]
        
        //解析数据
        
        var dataSets:[ChartDataSet] = []
        
        var yVals = [ChartDataEntry]()
        
        
        //计算最大血糖值
        var numMax = 0
        
        for maxmax in dataIntArray {
            let maxArray = maxmax as! [Int]
            
            //基于获取到的血糖数值设置图示最大值最小值范围
            numMax = maxArray.reduce(Int.min, { max($0, $1) })
            
            
        }
        for max1 in 0  ..< dataIntArray.count {
            
            let aaaarray1:[Int] = dataIntArray[max1] as! [Int]
            
            if max1 == 0 {
                
                numMax = aaaarray1.reduce(Int.min, { max($0, $1) })
            }else{
                let  bbbb = aaaarray1.reduce(Int.min, { max($0, $1) })
                if(bbbb > numMax){
                    numMax = bbbb
                }
            }
            
        }
        //打开底部图例显示
        let legend = self.moreDayLineChartView.legend
        legend.enabled = true
        
        
        self.moreDayLineChartView.setViewPortOffsets(left: 20, top: 0, right: 0, bottom: 38)
        
        
        for index in 0 ..< yArray.count {
            
            let yVals1 = yArray[index]
            
            yVals = yVals1 as! [ChartDataEntry]
            
            //设置日期标示
            let timeS = dateArray[index] as! String
            
            let set = LineChartDataSet(values: yVals, label: timeS)
            let color:UIColor = colorArray[index]
            
            set.setColor(color)
            set.setCircleColor(UIColor.black)
            set.lineWidth = 1
            set.circleRadius = 3.0
            set.drawCirclesEnabled = false
            set.drawValuesEnabled = false
            set.drawCircleHoleEnabled = false
            set.highlightEnabled = true
            set.fillColor = UIColor.gray
            
            dataSets.append(set)
            
            
            let leftAxis1:YAxis = self.moreDayLineChartView.leftAxis
            
            if numMax >= 8{
                leftAxis1.axisMaximum = Double(numMax + 4)
            }else{
                leftAxis1.axisMaximum = 10
            }
            
        }
        
        
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        
        self.moreDayLineChartView.data = data
        self.moreDayLineChartView.setVisibleXRangeMaximum(480)
        self.moreDayLineChartView.moveViewToX(Double(yVals.count))
        
        self.moreDayLineChartView.highlightValue(x: Double(yVals.count), dataSetIndex: yVals.count, callDelegate: false)
        
        
    }
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let str = self.myxVals[Int(value)]
        return str
    }

}
