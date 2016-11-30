//
//  MoreImgViewController.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/8.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MoreImgViewController: UIViewController {

    //分段选择
    var quxianSegmentedCtl:UISegmentedControl!
    var duoriSegmentedCtl:UISegmentedControl!
    //前一天后一天

    var nextDayView:UIView!
    var pieLenge:UIView!
    var leftDayBtn:UIButton!
    var rightDayBtn:UIButton!
    //饼图百分比label数组
    var perPieLabelArray = [UILabel]()
    
    //单日的上下一天按钮
    var onedayUpBtn:UIButton!
    var onedayNextBtn:UIButton!
    var onedayLabel:UILabel! //显示为第几几天
    //是否为常显
    var onedayBtnState:Bool = false
    
    
    //图形视图
    var imgViews:MyLineChartView!
    var bingtuViews:UIView!
    var closeBtn:UIButton!
    
    //接收上级传来的数据
    var dataArray:NSArray!
    //接收sid
    var sensorsid:String!
    var oneDayCount = 1 //记录单日选择的日期
    
    
    var colors = [UIColor]()
    
    var pieNameArray = ["偏低","正常","偏高"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 更多图形
        //设置为 横屏
//        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeRight.rawValue, forKey: "orientation")

        
//        self.view.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI / 4.0))
        
        colors.append(UIColor(red: 89/255.0, green: 216/255.0, blue: 230/255.0, alpha: 1))
        colors.append(UIColor(red: 172/255.0, green: 209/255.0, blue: 52/255.0, alpha: 1))
        colors.append(UIColor(red: 243/255.0, green: 83/255.0, blue: 23/255.0, alpha: 1))
        
        
        
        if(self.dataArray.count > 1){
            self.oneDayCount = 1
        }else{
            print("没数据")
        }
        
        
        self.view.backgroundColor = UIColor.white
        //初始化主要视图
        self.setViews(true)
//        //数据
        self.setDatas()
        
        //设置按钮
        self.setBtn()
        
        //设置 UISegmentedControl
        self.setSegmentedCtl()
        
        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
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
    
    
   
    func closeAct(){
        self.dismiss(animated: true, completion: nil)
        
    }
 
    
 
    //解析数据
    func setDatas(){
        
        //加载多日连续
        self.initMoreLianxu()
        
        //加载多日叠加
        self.initmanyDays()
   
    }
    
    
    var lianxuXarray = NSMutableArray()
    var lianxuYarray = NSMutableArray()
    var lianxuDataArray = NSMutableArray()
    var lianxuDataCountArray = NSMutableArray()
    //加载多日连续
    func initMoreLianxu(){
        //加载连续图形数据
        let (xArray,yArray,dataArray,dataCount) = StatisticService().moreChartImg(self.dataArray)
        self.lianxuXarray = xArray
        self.lianxuYarray = yArray
        self.lianxuDataArray = dataArray
        self.lianxuDataCountArray = dataCount
        
        self.loadChartView(xArray, yArray: yArray, dataArray: dataArray,dataCount: dataCount)
    }

    //绘制图形
    func loadChartView(_ xArray:NSMutableArray,yArray:NSMutableArray,dataArray:NSMutableArray,dataCount:NSMutableArray){
        
    
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
        var xVals = [String]()
        
        var numMax = 0
        
        for xxx in xArray {
            let xVals1 = xxx as! [String]
            xVals = xVals + xVals1
        }
        
        self.imgViews.myXvals = xVals
        
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
        var tmpDataCount:Double = 0.0
        let leftAxis:XAxis = self.imgViews.xAxis
        for ddd in 0 ..< dataCount.count {
            let limitCount:Double = Double(dataCount[ddd] as! Int)
            
            tmpDataCount += limitCount
            
            let lowerLimit:ChartLimitLine = ChartLimitLine(limit: tmpDataCount)
            lowerLimit.lineColor = UIColor.gray
            lowerLimit.lineWidth = 0.5
            lowerLimit.lineDashLengths = [3,3]
            
            leftAxis.addLimitLine(lowerLimit)
        }
        
        
        
        for index in 0 ..< yArray.count {
            
            
            
            
            let yVals1 = yArray[index]
            
            let yVals:[ChartDataEntry] = yVals1 as! [ChartDataEntry]
            
            
            let set = LineChartDataSet(values: yVals, label: "")
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
            
            
            
            let leftAxis1:YAxis = self.imgViews.leftAxis
            
            
            print("numMax:\(numMax)")
            if numMax >= 8{
//                leftAxis1.resetCustomAxisMax = Double(numMax + 4)
                leftAxis1.axisMaximum = Double(numMax + 4)
            }else{
//                leftAxis1.resetCustomAxisMax = 10
                leftAxis1.axisMaximum = 10
            }
            
            
            
//            let data:LineChartData = LineChartData(xVals: xVals, dataSets: dataSets)
            let data: LineChartData = LineChartData(dataSets: dataSets)
            
            
            self.imgViews.data = data
            self.imgViews.setVisibleXRangeMaximum(480 * 3)
            self.imgViews.moveViewToX(Double(yVals.count))
            
            self.imgViews.highlightValue(x: Double(yVals.count), dataSetIndex: yVals.count, callDelegate: false)
            
        }
        
        
    }

    var diejiaXvals = [String]() //x 时间
    var diejiaYarray = NSMutableArray()//y 血糖
    var diejiaDataMaxArray = NSMutableArray()//最大血糖
    var diejiaDateArray = NSMutableArray() //叠加日期
    //加载多日叠加
    func initmanyDays(){
        let (xVals,yArry,dataIntArray,dateArray) = StatisticService().manyDaysSuperposition(self.dataArray)
        self.diejiaXvals = xVals
        self.diejiaYarray = yArry
        self.diejiaDataMaxArray = dataIntArray
        self.diejiaDateArray = dateArray
        
    }
    //绘制多日叠加图形
    func diejiaChartView(_ xVals:[String],yArray:NSMutableArray,dataIntArray:NSMutableArray,dateArray:NSMutableArray){
        
        
//        print("xVals:\(xVals)")
        
        self.imgViews.myXvals = xVals
        
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
        let legend = self.imgViews.legend
        legend.enabled = true
    
        
        self.imgViews.setViewPortOffsets(left: 20, top: 0, right: 0, bottom: 38)
        
        
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
            
            
            let leftAxis1:YAxis = self.imgViews.leftAxis

            if numMax >= 8{
                leftAxis1.axisMaximum = Double(numMax + 4)
            }else{
//                leftAxis1.customAxisMax = 10
                leftAxis1.axisMaximum = 10
                
            }
    
        }

        
//        let data:LineChartData = LineChartData(xVals: xVals, dataSets: dataSets)
        let data: LineChartData = LineChartData(dataSets: dataSets)
        
        
        self.imgViews.data = data
        self.imgViews.setVisibleXRangeMaximum(480 * 3)
        self.imgViews.moveViewToX(Double(yVals.count))
        
        self.imgViews.highlightValue(x: Double(yVals.count), dataSetIndex: yVals.count, callDelegate: false)
    
        
    }
    
    //--------->>>>>>>>>>>>>>>>>>>
    
    
    
    
    
    //设置 分段选择器
    func setSegmentedCtl(){
        let items = ["曲线" as AnyObject,"饼图" as AnyObject] as [AnyObject]
        self.quxianSegmentedCtl = UISegmentedControl(items: items)
        self.quxianSegmentedCtl.frame = CGRect(x: self.view.frame.size.height - 90 - 10, y: 2.5,width: 90, height: 35)
        self.quxianSegmentedCtl.selectedSegmentIndex = 0

        self.quxianSegmentedCtl.tintColor = UIColor.orange
        self.quxianSegmentedCtl.tag = 11
        self.quxianSegmentedCtl.addTarget(self, action: #selector(MoreImgViewController.segmentDidchange(_:)), for: UIControlEvents.valueChanged)
        self.view.addSubview(self.quxianSegmentedCtl)
        
        
        let items1 = ["多日" as AnyObject,"单日" as AnyObject,"连续" as AnyObject] as [AnyObject]
        self.duoriSegmentedCtl = UISegmentedControl(items: items1)
        self.duoriSegmentedCtl.frame = CGRect(x: self.view.frame.size.height - 45 * 3 - 10, y: self.view.frame.size.width - 2.5 - 35,width: 45 * 3, height: 35)
        self.duoriSegmentedCtl.selectedSegmentIndex = 2
        
        self.duoriSegmentedCtl.tintColor = UIColor.orange
        self.duoriSegmentedCtl.tag = 22
        self.duoriSegmentedCtl.addTarget(self, action: #selector(MoreImgViewController.segmentDidchange(_:)), for: UIControlEvents.valueChanged)
        self.view.addSubview(self.duoriSegmentedCtl)

        
        //MARK:饼图的leng 和 next
        self.nextDayView = UIView(frame: CGRect(x: (self.view.frame.size.height - 20) / 3 * 2 - 110 + 10, y: self.view.frame.size.width - 2.5 - 35 ,width: 110, height: 35))

        self.nextDayView.backgroundColor = UIColor.orange

        //设置self.nextDayView 圆角
        self.nextDayView.layer.cornerRadius = 4
        self.nextDayView.clipsToBounds = true
        
        self.view.addSubview(self.nextDayView)
        
        self.nextDayView.isHidden = true
        
        //上一天按钮
        self.leftDayBtn = UIButton(frame: CGRect(x: 1,y: 1,width: (self.nextDayView.frame.size.width - 2) / 2 ,height: self.nextDayView.frame.size.height - 2))
        self.leftDayBtn.backgroundColor = UIColor.white
        self.leftDayBtn.setTitle("上一天", for: UIControlState())
        
        
        self.leftDayBtn.setTitleColor(UIColor.orange, for: UIControlState())
        self.leftDayBtn.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        self.leftDayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.leftDayBtn.addTarget(self, action: #selector(MoreImgViewController.pieAnyDayAct(_:)), for: UIControlEvents.touchUpInside)
        self.leftDayBtn.tag = 2016032801
        self.nextDayView.addSubview(self.leftDayBtn)
        //下一天
        self.rightDayBtn = UIButton(frame: CGRect(x: (self.nextDayView.frame.size.width - 2) / 2 + 1,y: 1,width: (self.nextDayView.frame.size.width - 2) / 2,height: self.nextDayView.frame.size.height - 2))
        self.rightDayBtn.backgroundColor = UIColor.white
        self.rightDayBtn.setTitle("下一天", for: UIControlState())
        self.rightDayBtn.setTitleColor(UIColor.orange, for: UIControlState())
        self.rightDayBtn.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        self.rightDayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.rightDayBtn.addTarget(self, action: #selector(MoreImgViewController.pieAnyDayAct(_:)), for: UIControlEvents.touchUpInside)
        self.rightDayBtn.tag = 2016032802
        self.nextDayView.addSubview(self.rightDayBtn)
        
        //设置半边圆角
        let maskPath = UIBezierPath(roundedRect: leftDayBtn.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.topLeft], cornerRadii: CGSize(width: 4, height: 4))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = leftDayBtn.bounds
        
        maskLayer.path = maskPath.cgPath
        
        leftDayBtn.layer.mask = maskLayer
        
        let maskPath1 = UIBezierPath(roundedRect: rightDayBtn.bounds, byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 4, height: 4))
        
        let maskLayer1 = CAShapeLayer()
        
        maskLayer1.frame = rightDayBtn.bounds
        
        maskLayer1.path = maskPath1.cgPath
        
        rightDayBtn.layer.mask = maskLayer1
        
        //MARK:设置饼图标示

        self.pieLenge = UIView(frame: CGRect(x: 10 , y: self.view.frame.size.width - 2.5 - 35,width: (self.view.frame.size.height - 20) / 3 * 2 - 110 , height: 35))
        self.pieLenge.backgroundColor = UIColor.white
  
        self.view.addSubview(self.pieLenge)
        
        self.pieLenge.isHidden = true
        
        let pieSize = self.pieLenge.frame.size.width / 3
        
        for index in 0 ..< 3 {
            let imgView = UIView(frame: CGRect(x: CGFloat(index) * pieSize,y: 1,width: 16,height: 16))
            let imgColor = self.colors[index]
            imgView.backgroundColor = imgColor
            
            //设置 圆角
            imgView.layer.cornerRadius = 8
            imgView.clipsToBounds = true
            
            self.pieLenge.addSubview(imgView)
            
            let typeLabel = UILabel(frame: CGRect(x: CGFloat(index) * pieSize,y: 19,width: 22,height: 11))
            typeLabel.text = self.pieNameArray[index] 
            typeLabel.font = UIFont.systemFont(ofSize: 10)
            self.pieLenge.addSubview(typeLabel)
            
            //百分比
            let numLabel = UILabel(frame: CGRect(x: CGFloat(index) * pieSize + 24,y: 7.5,width: 50,height: 20))
            numLabel.textColor = UIColor.orange
            numLabel.font = UIFont.systemFont(ofSize: 13)
            numLabel.text = ""
            self.pieLenge.addSubview(numLabel)
            
            self.perPieLabelArray.append(numLabel)
        }
        
        
        
        
        //设置单日 的上一天下一天-------------->>>>>>>>>>>>>>>
        //－－－－－－－－上一天
        self.onedayUpBtn = UIButton(frame: CGRect(x: 15,y: self.view.frame.size.width - 2.5 - 35,width: 70,height: 35))
        self.onedayUpBtn.setTitle("上一天", for: UIControlState())
        self.view.addSubview(self.onedayUpBtn)
        self.onedayUpBtn.tag = 5901
        //设置label 圆角
        self.onedayUpBtn.layer.cornerRadius = 17.5
        self.onedayUpBtn.clipsToBounds = true
        self.onedayUpBtn.addTarget(self, action: #selector(MoreImgViewController.onedayBtnAct(_:)), for: UIControlEvents.touchUpInside)
        self.onedayUpBtn.backgroundColor = UIColor.orange
        //-------------下一天
        self.onedayNextBtn = UIButton(frame: CGRect(x: 15 + 70 + 10,y: self.view.frame.size.width - 2.5 - 35,width: 70,height: 35))
        self.onedayNextBtn.setTitle("下一天", for: UIControlState())
        self.view.addSubview(self.onedayNextBtn)
        self.onedayNextBtn.tag = 5902
        //设置label 圆角
        self.onedayNextBtn.layer.cornerRadius = 17.5
        self.onedayNextBtn.clipsToBounds = true
        self.onedayNextBtn.addTarget(self, action: #selector(MoreImgViewController.onedayBtnAct(_:)), for: UIControlEvents.touchUpInside)
        self.onedayNextBtn.backgroundColor = UIColor.orange
        
        self.onedayUpBtn.isHidden = true
        self.onedayNextBtn.isHidden = true
        //－－－－－－－－－－－－－－
        //第几天label
        self.onedayLabel = UILabel(frame: CGRect(x: 15 + 70 + 10 + 70 + 10,y: self.view.frame.size.width - 5 - 35,width: 100,height: 35))
        self.onedayLabel.text = ""
        self.view.addSubview(self.onedayLabel)
        self.onedayLabel.isHidden = true
        //设置单日 的上一天下一天--------------<<<<<<<<<<<<<
        
    }
    
    
    
    //单日上下一天点击
    func onedayBtnAct(_ btn:UIButton){
        switch btn.tag{
        case 5901:
            print("上一天")
            
            if (self.oneDayCount == 1) { // 是第一天
                
                let actionSheet = UIAlertController(title: "已经是第一天了", message: "", preferredStyle: UIAlertControllerStyle.alert)
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
                
            }else{
                
                if (self.imgViews != nil){
                    self.imgViews.removeFromSuperview()
                    self.imgViews = nil
                }
                
                self.imgViews = MyLineChartView()
                
                self.imgViews.frame = CGRect(x: 10,y: 40,width: self.view.frame.size.width - 20 , height: self.view.frame.size.height - 80)
                
                self.imgViews.backgroundColor = UIColor.white
                //初始化视图数据
                self.imgViews.initView()
                self.view.addSubview(self.imgViews)
                
                self.oneDayCount -= 1
                self.initOneDayData(self.oneDayCount - 1)
            }
 
            
            
        case 5902:
            print("下一天")
 
            if (self.oneDayCount != self.dataArray.count){
                
                if (self.imgViews != nil){
                    self.imgViews.removeFromSuperview()
                    self.imgViews = nil
                }
                
                self.imgViews = MyLineChartView()
                
                self.imgViews.frame = CGRect(x: 10,y: 40,width: self.view.frame.size.width - 20 , height: self.view.frame.size.height - 80)
                
                self.imgViews.backgroundColor = UIColor.white
                //初始化视图数据
                self.imgViews.initView()
                self.view.addSubview(self.imgViews)
                
                self.oneDayCount += 1

                self.initOneDayData(self.oneDayCount - 1)

            }else{
                let actionSheet = UIAlertController(title: "已经是最后一天了", message: "", preferredStyle: UIAlertControllerStyle.alert)
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
            }
            
            
            
            
            
            
        default:
            break
        }
    }
    
    
    
    
    //分段选择
    func segmentDidchange(_ segmented:UISegmentedControl){
        
        //        print(segmented.tag)
        //        print(segmented.selectedSegmentIndex)
        //
        //        print(segmented.titleForSegmentAtIndex(segmented.selectedSegmentIndex))
        
        switch segmented.tag {
        case 11:
            //print("曲线，饼图")
            switch segmented.selectedSegmentIndex {
            case 0:
                print("曲线")
                //隐藏饼图
                self.nextDayView.isHidden = true
                self.pieLenge.isHidden = true
                
                if (self.onedayBtnState == true) {
                    //为常显
                    //显示单日上下天
                    self.onedayUpBtn.isHidden = false
                    self.onedayNextBtn.isHidden = false
                    self.onedayLabel.isHidden = false
                }else{
                    //为不常显
                    //隐藏单日上下天
                    self.onedayUpBtn.isHidden = true
                    self.onedayNextBtn.isHidden = true
                    self.onedayLabel.isHidden = true
                }

                
                //饼图
                if (self.bingtuViews != nil) {
                    self.bingtuViews.isHidden = true
                }
                //曲线
                if (self.imgViews != nil) {
                    self.imgViews.isHidden = false
                }
                //显示多日
                if (self.duoriSegmentedCtl != nil) {
                    self.duoriSegmentedCtl.isHidden = false
                }
               
                
            case 1:
                print("饼图")
                //隐藏单日上下天
                self.onedayUpBtn.isHidden = true
                self.onedayNextBtn.isHidden = true
                self.onedayLabel.isHidden = true
                //隐藏曲线图
                if (self.imgViews != nil) {
                    self.imgViews.isHidden = true
                }
                //隐藏多日
                if (self.duoriSegmentedCtl != nil) {
                    self.duoriSegmentedCtl.isHidden = true
                }
                
                self.nextDayView.isHidden = false
                self.pieLenge.isHidden = false
                
                //饼图
                if (self.bingtuViews != nil) {
                    self.bingtuViews.isHidden = false
                }else{
                    //加载视图
                    self.setBingtuView()
                    self.nextDayView.isHidden = false
                    self.pieLenge.isHidden = false

                    //MARK:-饼图
                    //获取针头 的 day
                    self.setPieDay()
                    self.binView.dateLabel.text = self.pieDayArray[0] as? String
                    let day = self.pieDayArray[0] as! String
                    //获取饼图数据
                    
                    self.setPieDataAndChart(day, sensorsid: self.sensorsid)
     
                    
                }
                
            default:
                break
            }
            
        case 22:
            //print("多日，单日")
            switch segmented.selectedSegmentIndex {
            case 0:
                print("多日")
                
                //隐藏单日上下天
                self.onedayUpBtn.isHidden = true
                self.onedayNextBtn.isHidden = true
                self.onedayLabel.isHidden = true
                //设置为常不显示
                self.onedayBtnState = false
                
                
                if (self.imgViews != nil){
                    self.imgViews.removeFromSuperview()
                    self.imgViews = nil
                }
                
                self.imgViews = MyLineChartView()
                
                self.imgViews.frame = CGRect(x: 10,y: 40,width: self.view.frame.size.width - 20 , height: self.view.frame.size.height - 80)
                
                self.imgViews.backgroundColor = UIColor.white
                //初始化视图数据
                self.imgViews.initView()
                self.view.addSubview(self.imgViews)
                
                

               //填充数据

                self.diejiaChartView(diejiaXvals, yArray: diejiaYarray, dataIntArray: diejiaDataMaxArray, dateArray: diejiaDateArray)
                
            case 1:
                print("单日")
                
                //显示单日上下天
                self.onedayUpBtn.isHidden = false
                self.onedayNextBtn.isHidden = false
                self.onedayLabel.isHidden = false
                //设置为常显示
                self.onedayBtnState = true
                
                if (self.imgViews != nil){
                    self.imgViews.removeFromSuperview()
                    self.imgViews = nil
                }
                
                self.imgViews = MyLineChartView()
                
                self.imgViews.frame = CGRect(x: 10,y: 40,width: self.view.frame.size.width - 20 , height: self.view.frame.size.height - 80)
                
                self.imgViews.backgroundColor = UIColor.white
                //初始化视图数据
                self.imgViews.initView()
                self.view.addSubview(self.imgViews)
                
                
                self.initOneDayData(self.oneDayCount - 1)
                

                
                
            case 2:
                print("连续")
                
                //设置为常不显示
                self.onedayBtnState = false
                //隐藏单日上下天
                self.onedayUpBtn.isHidden = true
                self.onedayNextBtn.isHidden = true
                self.onedayLabel.isHidden = true
                
                if (self.imgViews != nil){
                    self.imgViews.removeFromSuperview()
                    self.imgViews = nil
                }
                
                self.setViews(false)
                self.loadChartView(self.lianxuXarray, yArray: self.lianxuYarray, dataArray: self.lianxuDataArray, dataCount: self.lianxuDataCountArray)
                
            default:
                break
            }
        case 33:
//            print("前一天")
            switch segmented.selectedSegmentIndex {
            case 0:
                print("前一天")
            case 1:
                print("后一天")
            default:
                break
            }
        default:
            break
        }
        

    }
    var pieDayArray = NSMutableArray()
    func setPieDay(){
        for tmp in self.dataArray{
            
            let tmpDic = tmp as! NSDictionary
            
            let day = tmpDic.value(forKey: "day") as! String
            
            let newTiem:Double = Double(day)! / 1000 + 8 * 60 * 60
            let dayTime = Date(timeIntervalSince1970: newTiem)
            let str = String(describing: dayTime)
            
//            let stTime:String = (str as NSString).substring(with: NSRange(0...10))
            
            let stTime:String = (str as NSString).substring(with: NSRange(location: 0, length: 11))
            
//            print(stTime)
            
            self.pieDayArray.add(stTime)
        }
    }
    

  
    
    //初始化单日图形数据
    func initOneDayData(_ count:Int){
        
        
        let tmpDic = self.dataArray[count] as! NSDictionary
        
        //设置参数
        
        let (xVals,yVals,dataMax,stTime) = StatisticService().oneDayDataSet(tmpDic)
        
 
        self.onedayLabel.text = stTime
        
        self.setOneDayDate(self.imgViews, xVls: xVals, yVls: yVals, data: dataMax)
    }
    //绘制单日图形
    func setOneDayDate(_ views:LineChartView,xVls:[String],yVls:[ChartDataEntry],data:[Int]){
        
        
        self.imgViews.myXvals = xVls
        
        var dataSets:[ChartDataSet] = []
        
        let set1 = LineChartDataSet(values: yVls, label: "")
        set1.setColor(UIColor(red: 53/255.0, green: 208/255.0, blue: 192/255.0, alpha: 1))
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
        
        let lleftAxis:YAxis = views.leftAxis
        if (numMax >= 8){
            lleftAxis.axisMaximum = Double(numMax + 4)
        }else{
            lleftAxis.axisMaximum = 10
        }
    
        let data: LineChartData = LineChartData(dataSets: dataSets)
    
        self.imgViews.data = data
        
  
        self.imgViews.setVisibleXRangeMaximum(480)
        self.imgViews.moveViewToX(Double(yVls.count))
        
    }
    
    
    
    func setViews(_ state1:Bool){
        
        if (self.imgViews == nil){
            self.imgViews = MyLineChartView()
            
            if state1{
                self.imgViews.frame = CGRect(x: 10,y: 40,width: self.view.frame.size.height - 20 , height: self.view.frame.size.width - 80)
            }else{
                self.imgViews.frame = CGRect(x: 10,y: 40,width: self.view.frame.size.width - 20 , height: self.view.frame.size.height - 80)
            }
            
            
            self.imgViews.backgroundColor = UIColor.white
            //初始化视图数据
            self.imgViews.initView()
            self.view.addSubview(self.imgViews)
  
            
            
            
            
            
        }
        
    }
    
    
    var binView:MyPieView!
    
    var binXJLabel:UITextView!
    
    func setBingtuView(){
        if (self.bingtuViews == nil) {

            self.bingtuViews = UIView(frame: CGRect(x: 10,y: 40,width: self.view.frame.size.width - 20 , height: self.view.frame.size.height - 80))
            self.bingtuViews.backgroundColor = UIColor.white
            
            self.view.addSubview(self.bingtuViews)
            
            //饼图
//            let binView = UIView(frame: CGRectMake(0,0,self.bingtuViews.frame.size.width / 3 * 2,self.bingtuViews.frame.size.height))
//            binView.backgroundColor = UIColor.whiteColor()
//            self.bingtuViews.addSubview(binView)
            
            binView = MyPieView(frame: CGRect(x: 0,y: 0,width: self.bingtuViews.frame.size.width / 3 * 2,height: self.bingtuViews.frame.size.height))
            binView.backgroundColor = UIColor.white
            
            binView.initView()
            
            //详解
            
            let xx = self.bingtuViews.frame.size.width / 3 * 2 + 5

            let xiangjieView = UIView(frame: CGRect(x: xx,y: (self.bingtuViews.frame.size.height - self.bingtuViews.frame.size.height / 3 * 2) / 2,width: self.bingtuViews.frame.size.width / 3 - 5,height: self.bingtuViews.frame.size.height / 3 * 2))
            xiangjieView.backgroundColor = UIColor.white
            self.bingtuViews.addSubview(xiangjieView)
            
            self.binXJLabel = UITextView(frame: CGRect(x: 0,y: 0,width: xiangjieView.frame.size.width,height: xiangjieView.frame.size.height))

            xiangjieView.addSubview(self.binXJLabel)
            self.binXJLabel.font = UIFont.systemFont(ofSize: 14)
            self.binXJLabel.isEditable = false
            self.binXJLabel.isSelectable = false
        }
    }

    var pieDayIndex = 0
    
    //MARK:饼图上下一天点击事件
    func pieAnyDayAct(_ send:UIButton){
        print(send.tag)
        
        switch send.tag {
            
        case 2016032801:
            print("pie上一天")
            

            if (self.pieDayIndex > 0){
                let day = self.pieDayArray[pieDayIndex - 1] as! String
                
                print("pie上一天:\(day)")
                //获取饼图数据
                
                self.setPieDataAndChart(day, sensorsid: self.sensorsid)
                
                
                self.pieDayIndex -= 1
                
                
            }else{
                let actionSheet = UIAlertController(title: "已经是第一天了", message: "", preferredStyle: UIAlertControllerStyle.alert)
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
            }
            
            
            
        case 2016032802:
            print("pie下一天")
  
            let dayAllCount = self.pieDayArray.count
            
            if (self.pieDayIndex < dayAllCount - 1){
                //有数据的
                let day = self.pieDayArray[pieDayIndex + 1] as! String
                
                print("pie下一天:\(day)")
                
                //获取饼图数据
                
                self.setPieDataAndChart(day, sensorsid: self.sensorsid)
                
                self.pieDayIndex += 1
            }else{
                //没有数据
                print("没有了啊啊啊 ")
                
                let actionSheet = UIAlertController(title: "已经是最后一天了", message: "", preferredStyle: UIAlertControllerStyle.alert)
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
                
            }
            
            
            
            
            
        default:
            break
        }
        
        
        
    }
    
    
    
    func loadPieImgView(_ xVals:[String],yVals:[ChartDataEntry],day:String){
        
        let mymypieView:PieChartView = binView.pppView as PieChartView
        //设置日期
        binView.dateLabel.text = day
        
        self.bingtuViews.addSubview(binView)
        
        for index in 0 ..< self.perPieLabelArray.count {
            let pieLabel = self.perPieLabelArray[index] 
            
            print(yVals)
            

            
            pieLabel.text = "\(yVals[index].y)%"
            
            
            
        }
        
        
        
        //填充数据
        let dataSet:PieChartDataSet = PieChartDataSet(values: yVals, label: "血糖数据分析图")
        
        
        dataSet.sliceSpace = 2.0
        
        

        
        dataSet.colors = colors
        
        
        
        let data: PieChartData = PieChartData(dataSets: [dataSet as IChartDataSet])
        
        
        let pFormatter:NumberFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = " %"
        
//        data.setValueFormatter(pFormatter)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 11.0))
        data.setValueTextColor(UIColor.white)
        
        mymypieView.data = data
        
        mymypieView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: ChartEasingOption.easeInBack)
    }
    
    
    
    func setBtn(){
        
        self.closeBtn = UIButton(frame: CGRect(x: 5,y: 2.5,width: 35,height: 35))
//        self.closeBtn.setTitle("关闭", forState: UIControlState.Normal)
        
        self.closeBtn.backgroundColor = UIColor.white
        
        self.closeBtn.setImage(UIImage(named: "xicon.png"), for: UIControlState())
        
        self.closeBtn.addTarget(self, action: #selector(MoreImgViewController.closeAct), for: UIControlEvents.touchUpInside)
        self.view.addSubview(self.closeBtn)
    }
    
    //MARK:加载饼图数据并刷新
    func setPieDataAndChart(_ day: String, sensorsid: String){
        MyNetworkRequest().getPieData(self.view, day: day, sensorsid: sensorsid, clourse: { (pieDataDic, binXJText) in
            
            
            self.binXJLabel.text = binXJText
            
            //加载饼图
            let (xVals,yVals) = StatisticService().getPieDataService(pieDataDic)
            self.loadPieImgView(xVals, yVals: yVals,day: day)
            
        })
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
