//
//  MyChartView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/6.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MyChartView: UIView ,ChartViewDelegate{

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    @IBOutlet weak var lineView: LineChartView!
    
    
    @IBOutlet weak var dayTimeLabel: UILabel!
    
    @IBOutlet weak var yesterdayBtn: UIButton!
    
    @IBOutlet weak var nextdayBtn: UIButton!
    
    @IBOutlet weak var bigChartBtn: UIButton!
    
    
    
    
    
    
    var recDataArray:NSArray!
    
    var firstDay:String!
    
    var currentDay:String!
    
    var oneDayXvals = [String]()
    var oneDayYvals = [ChartDataEntry]()
    
    
    var selectDayInt = 0
    var selectMaxInt = 6 //查看的最大天数 （+1）
    
    var loadfinish:JGProgressHUD!
    
    
    
    @IBOutlet weak var yesBtnToleftW: NSLayoutConstraint!//8
    @IBOutlet weak var yesBtnW: NSLayoutConstraint!//72
    @IBOutlet weak var lookBigBtnW: NSLayoutConstraint!//72
    
    @IBOutlet weak var nextBtnW: NSLayoutConstraint!//72
    @IBOutlet weak var nextBtnToRightW: NSLayoutConstraint!//8
    
    func setLayOut(){
        let Wsize = UIScreen.main.bounds.width / 320
        
        
        yesBtnToleftW.constant = Wsize * 8
        yesBtnW.constant = Wsize * 72
        lookBigBtnW.constant = Wsize * 72
        
        nextBtnW.constant = Wsize * 72
        nextBtnToRightW.constant = Wsize * 8
        
    }
    
    
    
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        
        //布局
        self.setLayOut()
        
        self.loadfinish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.loadfinish.textLabel.text = "读取数据"
        self.loadfinish.show(in: self, animated: true)
        
        //设置视图
        self.setView()
        self.setChartBasicAttributes() //设置基本属性
        
        DispatchQueue.global(qos: .default).async {
            //加载数据
            if self.firstDay.characters.count > 9{
                self.initSetup()
                
                self.yesterdayBtn.isEnabled = true
                self.nextdayBtn.isEnabled = true
                self.bigChartBtn.isEnabled = true
                
            }else{
                self.loadfinish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.loadfinish.textLabel.text = "暂无数据"
                self.loadfinish.dismiss(afterDelay: 0.5, animated: true)
                
                self.yesterdayBtn.isEnabled = false
                self.nextdayBtn.isEnabled = false
                self.bigChartBtn.isEnabled = false
            }
        }
        
//        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
//            
//            
//            
//        })
        
        

        
    }
    
    func setView(){
        //设置圆角
        self.yesterdayBtn.layer.cornerRadius = 10
        self.nextdayBtn.layer.cornerRadius = 10
        self.bigChartBtn.layer.cornerRadius = 10
        
        self.yesterdayBtn.addTarget(self, action: #selector(MyChartView.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.nextdayBtn.addTarget(self, action: #selector(MyChartView.btnAct(_:)), for: UIControlEvents.touchUpInside)
        
        self.yesterdayBtn.tag = 1
        self.nextdayBtn.tag = 2

        var firstStri:String!
        if self.firstDay.characters.count > 9 {
//            firstStri = (firstDay as NSString).substring(with: NSRange(0...9))
            
            firstStri = (firstDay as NSString).substring(with: NSRange(location: 0, length: 10))
        }else{
            firstStri = "暂无数据"
        }
        
        self.dayTimeLabel.text = firstStri
        
    }
    
    var finish:JGProgressHUD!
    var nextfinish:JGProgressHUD!
    //MARK:按钮点击事件
    func btnAct(_ send:UIButton){
        switch send.tag {
        case 1:
            print("上一天")
            
            if self.selectDayInt > 0{
                
                self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.finish.textLabel.text = "读取数据"
                self.finish.show(in: self, animated: true)
                
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
                let alrtView = UIAlertView(title: "已经是第一天了", message: "", delegate: nil, cancelButtonTitle: "确定")
                alrtView.show()
            }

        case 2:
            print("下一天")
            if self.selectDayInt < self.selectMaxInt{
                
                self.nextfinish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.nextfinish.textLabel.text = "读取数据"
                self.nextfinish.show(in: self, animated: true)
                
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
                let alrtView = UIAlertView(title: "只能查看\(self.selectMaxInt + 1)天数据", message: "", delegate: nil, cancelButtonTitle: "确定")
                alrtView.show()
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
            self.loadfinish = nil
        })
       
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
            
//            let tmpStri:String = (timeStr as NSString).substring(with: NSRange(5...9))
//
//            let xV:String = (timeStr as NSString).substring(with: NSRange(11...15))
            
            let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
            
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
        
        let lleftAxis:YAxis = self.lineView.leftAxis
        if (numMax >= 8){
//            lleftAxis.customAxisMax = Double(numMax + 4)
            lleftAxis.axisMaximum = Double(numMax + 4)
        }else{
//            lleftAxis.customAxisMax = 10
            lleftAxis.axisMaximum = 10
        }
        
//        let data:LineChartData = LineChartData(xVals: xVls, dataSets: dataSets)
        
        let data: LineChartData = LineChartData(dataSets: [dataSets as! IChartDataSet])
        
        self.lineView.data = data
        
        self.lineView.setVisibleXRangeMaximum(480)
        self.lineView.moveViewToX(Double(yVls.count))
        
    }
    //设置基本属性
    func setChartBasicAttributes(){
        self.lineView.delegate = self
        
//        self.lineView.descriptionText = ""
//        self.lineView.noDataTextDescription = ""

        self.lineView.chartDescription?.text = ""
        self.lineView.noDataText = ""
        //放大
        self.lineView.pinchZoomEnabled = false
        self.lineView.drawGridBackgroundEnabled = false
        //放大倍数
        self.lineView.viewPortHandler.setMaximumScaleY(1)
        self.lineView.viewPortHandler.setMaximumScaleX(10)
        
        //关闭底部图例显示
        let legend = self.lineView.legend
        legend.enabled = false
        
        
        self.lineView.dragEnabled = true
        self.lineView.scaleXEnabled = true
        self.lineView.pinchZoomEnabled = true
        self.lineView.drawGridBackgroundEnabled = false
        
        
        let leftAxis:YAxis = self.lineView.leftAxis
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
        
        
        self.lineView.rightAxis.enabled = false
        
        
        let xAxis:XAxis = self.lineView.xAxis
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        xAxis.labelFont = UIFont(name: "Helvetica", size: 10)!
        
        
        
        xAxis.drawGridLinesEnabled = false
        //设置坐标轴 颜色
        xAxis.axisLineColor = UIColor.blue
        
        
//        xAxis.spaceBetweenLabels = 0
        self.lineView.xAxis.enabled = true
        
        
        
        self.lineView.animate(xAxisDuration: 1,yAxisDuration: 1, easingOption: ChartEasingOption.easeInOutQuart)
        
        
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
//        self.lineView.marker = marker
        
        
        self.lineView.setVisibleXRangeMaximum(60)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
