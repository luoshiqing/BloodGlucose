//
//  ScrennChartViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/6.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class ScrennChartViewController: UIViewController ,ChartViewDelegate{

    
    
    var recDataArray:NSArray!
    
    var firstDay:String!
    
    var currentDay:String!
    
    var loadfinish:JGProgressHUD!
    
    var loadMore:JGProgressHUD!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.view.backgroundColor = UIColor.white
        
        
        
        
        //设置视图
        self.setView()
        self.setChartBasicAttributes() //设置基本属性
        
 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.loadfinish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.loadfinish.textLabel.text = "读取数据"
        self.loadfinish.show(in: self.myLineChartView, animated: true)
        
        
        
        
//        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
//            //加载第一天图形
//            self.initSetup()
//        })
        

//        DispatchQueue.global().async { 
//            //加载第一天图形
//            self.initSetup()
//        }
        
        DispatchQueue.global(qos: .default).async { 
            //加载第一天图形
            self.initSetup()
        }
        
        
        
        
        
        
    }
    
    
    func initSetup(){
        //获取当前日期的数据
        let (xVals,yVals,dataMax) = getCurrentDate(self.currentDay)
        print(self.recDataArray.count)
        
        DispatchQueue.main.async(execute: { () -> Void in
            //绘制图像
            self.setOneDayCharts(xVals, yVls: yVals, data: dataMax)
            
            self.loadfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.loadfinish.textLabel.text = "读取成功"
            self.loadfinish.dismiss(afterDelay: 0.5, animated: true)
            
        })
        
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
    var myLineChartView:LineChartView!
    
    var yestodayBtn:UIButton!
    var nextdayBtn:UIButton!
    var btnView:UIView!
    var dayTimeLabel:UILabel!
    //分段选择
    var mySegmentedCtl:UISegmentedControl!
    
    func setView(){
        
        
        
        //图形视图
        self.myLineChartView = LineChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width - 38))
        self.myLineChartView.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(self.myLineChartView)
        
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
    
    //设置基本属性
    func setChartBasicAttributes(){
        self.myLineChartView.delegate = self
        
//        self.myLineChartView.descriptionText = ""
        
        
        self.myLineChartView.chartDescription?.text = ""
        
//        self.myLineChartView.noDataTextDescription = ""
        
        self.myLineChartView.noDataText = ""
        
        
        //放大
        self.myLineChartView.pinchZoomEnabled = false
        self.myLineChartView.drawGridBackgroundEnabled = false
        //放大倍数
        self.myLineChartView.viewPortHandler.setMaximumScaleY(1)
        self.myLineChartView.viewPortHandler.setMaximumScaleX(20)
        
        //关闭底部图例显示
        let legend = self.myLineChartView.legend
        legend.enabled = false
        
        
        self.myLineChartView.dragEnabled = true
        self.myLineChartView.scaleXEnabled = true
        self.myLineChartView.pinchZoomEnabled = true
        self.myLineChartView.drawGridBackgroundEnabled = false
        
        
        let leftAxis:YAxis = self.myLineChartView.leftAxis
        leftAxis.removeAllLimitLines()
        
//        leftAxis.customAxisMin = 0
//        leftAxis.customAxisMax = 10
        
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 10
        
        //        leftAxis.customAxisMax = 15
        
//        leftAxis.startAtZeroEnabled = false
        
        leftAxis.drawZeroLineEnabled = false
        
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.drawGridLinesEnabled = false
        //设置坐标轴 颜色
        leftAxis.axisLineColor = UIColor.blue
        
        
        
//        let formatter = NumberFormatter()
//        formatter.numberStyle = NumberFormatter.Style.decimal
//        
// 
//        leftAxis.valueFormatter = formatter
        
        
        self.myLineChartView.rightAxis.enabled = false
        
        
        let xAxis:XAxis = self.myLineChartView.xAxis
        
//        xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.bottom
        
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        xAxis.labelFont = UIFont(name: "Helvetica", size: 10)!
        
        
        
        xAxis.drawGridLinesEnabled = false
        //设置坐标轴 颜色
        xAxis.axisLineColor = UIColor.blue
        
        
//        xAxis.spaceBetweenLabels = 0
        
        
        
        
        
        self.myLineChartView.xAxis.enabled = true
        
        
        
        self.myLineChartView.animate(xAxisDuration: 1,yAxisDuration: 1, easingOption: ChartEasingOption.easeInOutQuart)
        
        
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
        
//        let marker = BalloonMarker(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), font: UIFont(name: "Helvetica", size: 12)!, insets: UIEdgeInsets(top: 8, left: 8, bottom: 28, right: 8))
//        
//        marker.minimumSize = CGSize(width: 20, height: 10)
//        self.myLineChartView.marker = marker
        
        
        self.myLineChartView.setVisibleXRangeMaximum(60)
        
        
        
    }
    //绘制图形
    func setOneDayCharts(_ xVls:[String],yVls:[ChartDataEntry],data:[Int]){
        
        var dataSets:[ChartDataSet] = []
        let set1 = LineChartDataSet(values: yVls, label: "")
        set1.setColor(UIColor(red: 64/255.0, green: 224/255.0, blue: 208/255.0, alpha: 1))
        set1.setCircleColor(UIColor.black)
        
        //图形线条 粗细
        set1.lineWidth = 1.3
        set1.circleRadius = 3.0
        set1.drawCirclesEnabled = false
//        set1.drawCubicEnabled = true
        
        set1.drawValuesEnabled = false
        set1.drawCircleHoleEnabled = false
        set1.highlightEnabled = true
        set1.fillColor = UIColor.gray
        
        dataSets.append(set1)
        
        
        //基于获取到的血糖数值设置图示最大值最小值范围
        let numMax:Int = data.reduce(Int.min, { max($0, $1) })
        
        let lleftAxis:YAxis = self.myLineChartView.leftAxis
        if (numMax >= 8){
//            lleftAxis.customAxisMax = Double(numMax + 4)
            lleftAxis.axisMaximum = Double(numMax + 4)
        }else{
//            lleftAxis.customAxisMax = 10
            lleftAxis.axisMaximum = 10
        }
        
//        let data:LineChartData = LineChartData(xVals: xVls, dataSets: dataSets)
        
        let data: LineChartData = LineChartData(dataSets: [dataSets as! IChartDataSet])
        
        self.myLineChartView.data = data
        
        self.myLineChartView.setVisibleXRangeMaximum(480)
        self.myLineChartView.moveViewToX(Double(yVls.count))
        
    }
    
    
    func getCurrentDate(_ currentDay:String) ->([String],[ChartDataEntry],[Int]){
        
        var xVals = [String]()
        var yVals = [ChartDataEntry]()
        var dataMax = [Int]()
        //计数
        var index = 0
        
        for item in self.recDataArray {
            let tmp = item as! BloodSugarModel
            
            let glucose:Double = Double(tmp.glucose)!
            let timeStamp = tmp.timeStamp
            
            let recordDate = Date(timeIntervalSince1970: Double(timeStamp!)!)
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let timeStr = formatter.string(from: recordDate)
            
//            NSRange(location: 0, length: 10)
            
//            let tmpStri:String = (timeStr as NSString).substring(with: NSRange(5...9))
            
            let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
            
            
//            let xV:String = (timeStr as NSString).substring(with: NSRange(11...15))
            
            let xV:String = (timeStr as NSString).substring(with: NSRange(location: 11, length: 5))
            
            if currentDay == tmpStri{
                xVals.append(xV)
                yVals.append(ChartDataEntry(x: glucose, y: Double(index)))
                dataMax.append(Int(glucose))
                index += 1
            }
            
        }
        return (xVals,yVals,dataMax)
        
    }
    
    
    var moreDayLineChartView:LineChartView!
    
    //Mark:-分段选择
    func segmentDidchange(_ segmented:UISegmentedControl){

        switch segmented.selectedSegmentIndex {
        case 0:
            print("单日")
            
            self.myLineChartView.isHidden = false
            self.btnView.isHidden = false
            self.dayTimeLabel.isHidden = false
            if self.moreDayLineChartView != nil {
                self.moreDayLineChartView.isHidden = true
            }
            
            
            
            
            
        case 1:
            print("多日")
            
            
            self.myLineChartView.isHidden = true
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
                
//                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
//                    
//                    
//                })
                
                
                
                
                
                
            }else{
                self.moreDayLineChartView.isHidden = false
            }
            
            
            
        default:
            break
        }
    }
    func setBaseChartView(){
        self.moreDayLineChartView.delegate = self
        
//        self.moreDayLineChartView.descriptionText = ""
        self.moreDayLineChartView.chartDescription?.text = ""
        
//        self.moreDayLineChartView.noDataTextDescription = ""
        
        self.moreDayLineChartView.noDataText = ""
        
        //放大
        self.moreDayLineChartView.pinchZoomEnabled = false
        self.moreDayLineChartView.drawGridBackgroundEnabled = false
        //放大倍数
        self.moreDayLineChartView.viewPortHandler.setMaximumScaleY(1)
        self.moreDayLineChartView.viewPortHandler.setMaximumScaleX(10)
        
        //关闭底部图例显示
        let legend = self.moreDayLineChartView.legend
        legend.enabled = false
        
        
        self.moreDayLineChartView.dragEnabled = true
        self.moreDayLineChartView.scaleXEnabled = true
        self.moreDayLineChartView.pinchZoomEnabled = true
        self.moreDayLineChartView.drawGridBackgroundEnabled = false
        
        
        let leftAxis:YAxis = self.moreDayLineChartView.leftAxis
        leftAxis.removeAllLimitLines()
//        leftAxis.customAxisMin = 0
//        leftAxis.customAxisMax = 10
        
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 10
        
        
        //        leftAxis.customAxisMax = 15
        
//        leftAxis.startAtZeroEnabled = false
        
        leftAxis.drawZeroLineEnabled = false
        
        
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.drawGridLinesEnabled = false
        //设置坐标轴 颜色
        leftAxis.axisLineColor = UIColor.blue
        
        
        
//        let formatter = NumberFormatter()
//        formatter.numberStyle = NumberFormatter.Style.decimal
//        
//        leftAxis.valueFormatter = formatter
        
        
        self.moreDayLineChartView.rightAxis.enabled = false
        
        
        let xAxis:XAxis = self.moreDayLineChartView.xAxis
//        xAxis.labelPosition = XAxis.XAxisLabelPosition.bottom
        
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        xAxis.labelFont = UIFont(name: "Helvetica", size: 10)!
        
        
        
        xAxis.drawGridLinesEnabled = false
        //设置坐标轴 颜色
        xAxis.axisLineColor = UIColor.blue
        
        
//        xAxis.spaceBetweenLabels = 0
        
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
        
//        let marker = BalloonMarker(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), font: UIFont(name: "Helvetica", size: 12)!, insets: UIEdgeInsets(top: 8, left: 8, bottom: 28, right: 8))
//        
//        marker.minimumSize = CGSize(width: 20, height: 10)
//        self.moreDayLineChartView.marker = marker
        
        
        self.moreDayLineChartView.setVisibleXRangeMaximum(60)
    }
    
    
    
    //计算多日数据
    func getMoreDayDate(_ recDataArray:NSArray) ->([String],NSMutableArray,NSMutableArray,NSMutableArray){
        //计算出有多少天，起始时间
        //所有数据数组
        let YallDataArray = NSMutableArray()
        let dataIntArray = NSMutableArray()
        let dateArray = NSMutableArray()
        
        let (dayTime,allTiem,dayCount) = self.getFirstDayAndDayCount(recDataArray)
        
        print(dayTime,allTiem,dayCount)
        
        
        let dayCountArray = NSMutableArray()
        
        for tmp in 0..<dayCount {
            
            let dfmatter = DateFormatter()
            dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dfmatter.date(from: allTiem)
            let dateStamp:TimeInterval = date!.timeIntervalSince1970
            let nextDate = dateStamp + Double(24 * 60 * 60 * tmp)
            let recordDate = Date(timeIntervalSince1970: Double(nextDate))
            let timeStr = dfmatter.string(from: recordDate)
//            let tmpStri:String = (timeStr as NSString).substring(with: NSRange(5...9))
            
            let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
            
            
            dayCountArray.add(tmpStri)
        }
        print(dayCountArray)
        
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
                
//                let tmpStri:String = (timeStr as NSString).substring(with: NSRange(5...9))
//                let xV:String = (timeStr as NSString).substring(with: NSRange(11...15))
                
                let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
                let xV:String = (timeStr as NSString).substring(with: NSRange(location: 11, length: 5))

                var countIndex = iidex

                
                if tmpTime == tmpStri {
                    print("等于")
                    datas.append(Int(glucose))
                    
                    
                    if firstIndex == 0 {
                        let xxxx = xV.components(separatedBy: ":")
                        countIndex = (Int(xxxx[0])! * 60 * 60 + Int(xxxx[1])! * 60) / 180

                        
                    }

                    yVals.append(ChartDataEntry(x: glucose, y: Double(countIndex)))
                    
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

//            let dayTime:String = (timeStr as NSString).substring(with: NSRange(5...9))
            let dayTime:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
            
            
            if dayCountDic[dayTime] == nil{
                dayCountDic[dayTime] = 0
            }
            
        }
        print("dayCountDic.allkeys:\(dayCountDic.allKeys)")
        
        return (firstStri,timeStr,dayCountDic.allKeys.count)
        
  
    }
    
    
    
    var selectDayInt = 0
    var selectMaxInt = 6 //查看的最大天数 （+1）
    var finish:JGProgressHUD!
    var nextfinish:JGProgressHUD!
    //MARK:按钮点击事件
    func btnAction(_ send:UIButton){
        switch send.tag {
        case 406020:
            self.dismiss(animated: true, completion: nil)
        case 406051:
            print("上一天")
            
            if self.selectDayInt > 0{
                
                self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.finish.textLabel.text = "读取数据"
                self.finish.show(in: self.view, animated: true)
                
                DispatchQueue.global(qos: .default).async {
                    let (a,b,c) = self.getYestDay(self.firstDay)
                    
                    let (xVals,yVals,dataMax) = self.getCurrentDate(a)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        //绘制图像
                        self.setOneDayCharts(xVals, yVls: yVals, data: dataMax)
                        
                        self.selectDayInt -= 1
                        self.dayTimeLabel.text = b
                        self.firstDay = c
                        
                        self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.finish.textLabel.text = "读取成功"
                        self.finish.dismiss(afterDelay: 0.5, animated: true)
                    })
                }
                
//                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
//                    
//                    
//                    
//                    
//                })
                
            }else{
                print("已经是第一天了")
                let actionSheet = UIAlertController(title: "已经是第一天了", message: "", preferredStyle: UIAlertControllerStyle.alert)
 
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
            }
 
        case 406052:
            print("下一天")
            if self.selectDayInt < self.selectMaxInt{
                
                self.nextfinish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.nextfinish.textLabel.text = "读取数据"
                self.nextfinish.show(in: self.view, animated: true)
                
                
                DispatchQueue.global(qos: .default).async {
                    let (a,b,c) = self.getNextDay(self.firstDay)
                    
                    let (xVals,yVals,dataMax) = self.getCurrentDate(a)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        //绘制图像
                        self.setOneDayCharts(xVals, yVls: yVals, data: dataMax)
                        self.firstDay = c
                        self.dayTimeLabel.text = b
                        self.selectDayInt += 1
                        
                        self.nextfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.nextfinish.textLabel.text = "读取成功"
                        self.nextfinish.dismiss(afterDelay: 0.5, animated: true)
                        
                    })
                }
//                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
//                    
//                    
//                    
//                })
                
            }else{
                print("只能查看\(self.selectMaxInt + 1)天数据")
                let actionSheet = UIAlertController(title: "已经是最后一天了", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
            }

        default:
            break
        }
    }
   
    func getNextDay(_ dayTime:String) ->(String,String,String){
        
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: dayTime)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let nextDate = dateStamp + 24 * 60 * 60
        let recordDate = Date(timeIntervalSince1970: Double(nextDate))
        let timeStr = dfmatter.string(from: recordDate)
        
//        NSRange(location: 5, length: 5)
        
        
//        let tmpStri:String = (timeStr as NSString).substring(with: NSRange(5...9))
//        let labStr:String = (timeStr as NSString).substring(with: NSRange(0...9))
//        
//        let allTime:String = (timeStr as NSString).substring(with: NSRange(0...18))
        
        let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
        let labStr:String = (timeStr as NSString).substring(with: NSRange(location: 0, length: 10))
        
        let allTime:String = (timeStr as NSString).substring(with: NSRange(location: 0, length: 19))
        
        
        return (tmpStri,labStr,allTime)
    }
    
    func getYestDay(_ dayTime:String) ->(String,String,String){
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: dayTime)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let nextDate = dateStamp - 24 * 60 * 60
        let recordDate = Date(timeIntervalSince1970: Double(nextDate))
        let timeStr = dfmatter.string(from: recordDate)
//        let tmpStri:String = (timeStr as NSString).substring(with: NSRange(5...9))
//        let labStr:String = (timeStr as NSString).substring(with: NSRange(0...9))
//        
//        let allTime:String = (timeStr as NSString).substring(with: NSRange(0...18))
        
        let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
        let labStr:String = (timeStr as NSString).substring(with: NSRange(location: 0, length: 10))
        
        let allTime:String = (timeStr as NSString).substring(with: NSRange(location: 0, length: 19))
        
        return (tmpStri,labStr,allTime)
    }
    
    //绘制多日叠加图形
    func diejiaChartView(_ xVals:[String],yArray:NSMutableArray,dataIntArray:NSMutableArray,dateArray:NSMutableArray){
        
        
        //        print("xVals:\(xVals)")
        
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
//            set.drawCubicEnabled = true
            set.drawValuesEnabled = false
            set.drawCircleHoleEnabled = false
            set.highlightEnabled = true
            set.fillColor = UIColor.gray
            
            dataSets.append(set)
            
            
            let leftAxis1:YAxis = self.moreDayLineChartView.leftAxis
            
            if numMax >= 8{
//                leftAxis1.customAxisMax = Double(numMax + 4)
                leftAxis1.axisMaximum = Double(numMax + 4)
            }else{
//                leftAxis1.customAxisMax = 10
                leftAxis1.axisMaximum = 10
            }
            
        }
        
        
//        let data:LineChartData = LineChartData(xVals: xVals, dataSets: dataSets)
        
        let data: LineChartData = LineChartData(dataSets: [dataSets as! IChartDataSet])
        
        
        self.moreDayLineChartView.data = data
        self.moreDayLineChartView.setVisibleXRangeMaximum(480 * 3)
        self.moreDayLineChartView.moveViewToX(Double(yVals.count))
        
        self.moreDayLineChartView.highlightValue(x: Double(yVals.count), dataSetIndex: yVals.count, callDelegate: false)
        
        
    }

}
