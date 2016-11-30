//
//  CurrentChartView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/25.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class CurrentChartView: UIView ,ChartViewDelegate ,IAxisValueFormatter{

    
    
    
    @IBOutlet weak var lineView: LineChartView!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    
    @IBOutlet weak var lastDayBtn: UIButton!
    
    @IBOutlet weak var largerChartBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    
    //接收上级的数据
    var recDataArray:NSArray!
    var firstDay:String! //2016-03-22 12:12:12
    var currentDay:String! //03-25
    
    var dayArray:NSMutableArray! //日期天数数组
    var deteilDayArray:NSMutableArray! //详细日期数组
    //记录日期天数数组的个数
    var dayArrayCount:Int!
    
    //记录选择日期数组的index
    var selectDayArrayCount:Int = 0
    
    
    
    //----是否有参比
    var isFinger:Bool = true
    var fristFinger:NSArray!
    
 
    
    
    
    
    //获得控制器
    var SBMGViewCtr:UIViewController!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    //当前查看的图形
    var chartIndex = 0
    //最大能看多少天数据
    var chartMaxIndex = 6

    override func draw(_ rect: CGRect) {
        
        self.selectDayArrayCount = self.dayArrayCount
        
        print("selectDayArrayCount:\(selectDayArrayCount)")
        
        
        //设置视图
        self.initSetup()
        //初始化chart基本属性
        self.setChartBasicAttributes()
        
        self.lastfinish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.lastfinish.textLabel.text = "读取数据"
        self.lastfinish.show(in: self, animated: true)
        
        DispatchQueue.global(qos: .default).async {
            if self.recDataArray.count > 0{
                //加载chart视图
                self.showChartView()
            }else{
                print("not data")
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    
                    self.lastDayBtn.isEnabled = false
                    self.largerChartBtn.isEnabled = false
                    self.nextBtn.isEnabled = false
                    
                    self.lastfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.lastfinish.textLabel.text = "没有数据"
                    self.lastfinish.dismiss(afterDelay: 0.5, animated: true)
                    
                })
                
            }
        
        }
 
        
    }
    
    func initSetup(){
    
        var firstStri:String!
        if self.firstDay.characters.count > 9 {
            firstStri = (firstDay as NSString).substring(with: NSRange(location: 0, length: 10))
            
            
        }else{
            firstStri = "暂无数据"
        }
        self.dayLabel.text = firstStri
        
        //按钮
        self.lastDayBtn.layer.cornerRadius = 10
        self.largerChartBtn.layer.cornerRadius = 10
        self.nextBtn.layer.cornerRadius = 10
        
        self.lastDayBtn.addTarget(self, action: #selector(CurrentChartView.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.lastDayBtn.tag = 1
        

        
        self.nextBtn.addTarget(self, action: #selector(CurrentChartView.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.nextBtn.tag = 3
        
    }
    var lastfinish:JGProgressHUD!
    var nextfinish:JGProgressHUD!
    //MARK:按钮点击事件
    func btnAct(_ send:UIButton){
        switch send.tag {
        case 1:
            print("上一天")
            
            if self.selectDayArrayCount > 1{

                self.lastfinish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.lastfinish.textLabel.text = "读取数据"
                self.lastfinish.show(in: self, animated: true)

                DispatchQueue.global(qos: .default).async {
                    //有参比的情况
                    if self.isFinger == true {
  
                        let a:String = self.dayArray[self.selectDayArrayCount - 2] as! String
                        
                        let tmp = self.deteilDayArray[self.selectDayArrayCount - 2] as! String
  
                        let b:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 10))
                        
                        let c:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 19))
                        
                        
                        let (xArray,yArray,dataArray,dataCount) = StatisticService().getFirstData(a, firstFinger: self.fristFinger, recDataArray: self.recDataArray,KkValue: self.Kvalue)
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            //绘制图像
                            self.loadChartView(xArray, yArray: yArray, dataArray: dataArray, dataCount: dataCount)
                            
                            
                            
                            self.firstDay = c
                            self.dayLabel.text = b
                            self.chartIndex -= 1
                            
                            self.selectDayArrayCount -= 1
                            
                            
                            self.lastfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                            self.lastfinish.textLabel.text = "读取成功"
                            self.lastfinish.dismiss(afterDelay: 0.5, animated: true)
                            
                        })
                        
                        //没有参比的情况
                    }else{
                        
                        //加载电流图形
                        
                        let a:String = self.dayArray[self.selectDayArrayCount - 2] as! String
                        
                        let tmp = self.deteilDayArray[self.selectDayArrayCount - 2] as! String
  
                        let b:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 10))
                        
                        let c:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 19))
                        
                        let (xArray,yArray,dataArray) = StatisticService().getFirstDataAndNotFinger(a, recDataArray: self.recDataArray)
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            
                            self.setOneDayCharts(xArray, yVls: yArray, data: dataArray)
                            
                            self.chartIndex -= 1
                            self.dayLabel.text = b
                            self.firstDay = c
                            
                            self.selectDayArrayCount -= 1
                            
                            self.lastfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                            self.lastfinish.textLabel.text = "电流数据"
                            self.lastfinish.dismiss(afterDelay: 0.5, animated: true)
                            
                        })
                        
                        
                        
                    }
                
                }
   
            }else{
                print("已经是第一天了")

                let actionSheet = UIAlertController(title: "已经是第一天了", message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                //取消
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
                //因为这个是控制器，需要添加到视图
                self.SBMGViewCtr.present(actionSheet, animated: true, completion: nil)
            }

        case 3:
            print("下一天")

            if self.selectDayArrayCount < self.dayArrayCount{
                
                self.nextfinish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.nextfinish.textLabel.text = "读取数据"
                self.nextfinish.show(in: self, animated: true)

                DispatchQueue.global(qos: .default).async {
                    //有参比的情况
                    if self.isFinger == true {

                        let a:String = self.dayArray[self.selectDayArrayCount] as! String
                        
                        let tmp = self.deteilDayArray[self.selectDayArrayCount] as! String

                        let b:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 10))
                        
                        let c:String = (tmp as NSString).substring(with: NSRange(location: 0, length: 19))
                        
                        let (xArray,yArray,dataArray,dataCount) = StatisticService().getFirstData(a, firstFinger: self.fristFinger, recDataArray: self.recDataArray,KkValue: self.Kvalue)
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            //绘制图像
                            self.loadChartView(xArray, yArray: yArray, dataArray: dataArray, dataCount: dataCount)
                            
                            self.firstDay = c
                            self.dayLabel.text = b
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
                            self.dayLabel.text = b
                            self.firstDay = c
                            
                            self.selectDayArrayCount += 1
                            
                            self.nextfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                            self.nextfinish.textLabel.text = "电流数据"
                            self.nextfinish.dismiss(afterDelay: 0.5, animated: true)
                            
                        })
   
                    }
                
                }


            }else{

                let actionSheet = UIAlertController(title: "已经是最后一天数据了", message: "", preferredStyle: UIAlertControllerStyle.alert)

                //取消
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
                //因为这个是控制器，需要添加到视图
                self.SBMGViewCtr.present(actionSheet, animated: true, completion: nil)
                
                
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
    
    
    var Kvalue:Double = 1.0
    
    func showChartView(){
        
        if (self.isFinger == true) { //有参比的情况

            //获取 K 值
            self.Kvalue = StatisticService().getKvalue(firstFinger: self.fristFinger, recDataArray: self.recDataArray)
            print("Kvalue:\(Kvalue)")

            
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
    
    var namesArray = ["电流图形","血糖图形"]
    
    //MARK:－多日->绘制图形
    func loadChartView(_ xArray:NSMutableArray,yArray:NSMutableArray,dataArray:NSMutableArray,dataCount:Int){
        
        
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
        
        self.myxVls = xVals
        
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
//            set.drawCubicEnabled = true
            set.drawValuesEnabled = false
            set.drawCircleHoleEnabled = false
            set.highlightEnabled = true
            set.fillColor = UIColor.gray
            
            
            dataSets.append(set)
            
            
            
            let leftAxis1:YAxis = self.lineView.leftAxis
            
            
            if numMax >= 8{
                leftAxis1.axisMaximum = Double(numMax + 4)
            }else{
                leftAxis1.axisMaximum = 10
            }
            
            
            
            
            let data: LineChartData = LineChartData(dataSets: dataSets)
            
            self.lineView.data = data
            self.lineView.setVisibleXRangeMaximum(480)
            self.lineView.moveViewToX(Double(yVals.count))
            
            self.lineView.highlightValue(x: Double(yVals.count), dataSetIndex: yVals.count, callDelegate: false)
            
        }
        
        
    }
    

    
    //不是第一天数据
    func getCurrentDate(_ currentDay:String) ->([String],[ChartDataEntry],[Int]){
        
        var xVals = [String]()
        var yVals = [ChartDataEntry]()
        var dataMax = [Int]()
        //计数
        var index = 0
        
        for item in self.recDataArray {
            let tmp = item as! BloodSugarModel
            
            let current:Double = Double(tmp.glucose)!
            let timeStamp = tmp.timeStamp
            
            let recordDate = Date(timeIntervalSince1970: Double(timeStamp!)!)
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let timeStr = formatter.string(from: recordDate)
            

            let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
            
            let xV:String = (timeStr as NSString).substring(with: NSRange(location: 11, length: 5))
            
            if currentDay == tmpStri{
                xVals.append(xV)
//                yVals.append(ChartDataEntry(x: current, y: Double(index)))
                
                yVals.append(ChartDataEntry(x: Double(index), y: current))
                
                dataMax.append(Int(current))
                index += 1
            }
            
        }
        return (xVals,yVals,dataMax)
        
    }
    
    fileprivate var myxVls = [String]()
    
    //绘制图形
    func setOneDayCharts(_ xVls:[String],yVls:[ChartDataEntry],data:[Int]){
        
        self.myxVls = xVls
        
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
//        set1.drawCubicEnabled = true
        set1.drawValuesEnabled = false
        set1.drawCircleHoleEnabled = false
        set1.highlightEnabled = true
        set1.fillColor = UIColor.gray
        
        dataSets.append(set1)
        
        
        //基于获取到的血糖数值设置图示最大值最小值范围
        let numMax:Int = data.reduce(Int.min, { max($0, $1) })
        
        let lleftAxis:YAxis = self.lineView.leftAxis
        
        lleftAxis.axisMaximum = Double(numMax) + Double(numMax) * 0.55
        
        
//        let data: LineChartData = LineChartData(dataSets: [dataSets as! IChartDataSet])
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        
        self.lineView.data = data
        
        self.lineView.setVisibleXRangeMaximum(480)
        self.lineView.moveViewToX(Double(yVls.count))
        
        self.lineView.highlightValue(x: Double(yVls.count), dataSetIndex: yVls.count, callDelegate: false)
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
        self.lineView.viewPortHandler.setMaximumScaleX(10)
        
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
        
        xAxis.valueFormatter = self
        xAxis.granularity = 1.0
        
        
        xAxis.drawGridLinesEnabled = false
        //设置坐x标轴 颜色
        xAxis.axisLineColor = UIColor.black
        
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
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let str = self.myxVls[Int(value)]
        return str
    }
    

    

}
