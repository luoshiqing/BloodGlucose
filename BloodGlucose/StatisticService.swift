//
//  StatisticService.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/17.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class StatisticService: NSObject {


    //获取探针id
    func getReporthome(){
        
        let dataArray = NSMutableArray()
        
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
//                print(data)
                dataArray.addObjects(from: data as [AnyObject])
            }

            
            
            }, failure: { () -> Void in
                
                print("false错误")
                
        })

    }
    
    //多日连续
    func moreChartImg(_ dataArray:NSArray) ->(NSMutableArray,NSMutableArray,NSMutableArray,NSMutableArray) {
        
//        print("dataArray:\(dataArray)")
        var aaaaa = 0

        let yArry = NSMutableArray()
        let dataIntArray = NSMutableArray()
        let xArry = NSMutableArray()
        
        let dataCount = NSMutableArray()
        
        
        for index in 0 ..< dataArray.count {
            
            let tmp = dataArray[index] as! NSDictionary

            let day = tmp.value(forKey: "day") as! String
            
            let newTiem:Double = Double(day)! / 1000 + 8 * 60 * 60
            let dayTime = Date(timeIntervalSince1970: newTiem)
            let str = String(describing: dayTime)
//            let stTime:String = (str as NSString).substring(with: NSRange(5...10))
            
            let stTime:String = (str as NSString).substring(with: NSRange(location: 5, length: 6))
            
            
            print("stTime:\(stTime)")
            
            let data = tmp.value(forKey: "data") as! NSArray

            dataCount.add(data.count)

            var yVals = [ChartDataEntry]()
            var datas = [Int]()
            var xVals = [String]()
            //遍历 data
            for jj in 0 ..< data.count {

                let ttttDic = data[jj] as! NSDictionary

                let d = ttttDic.value(forKey: "d") as! NSNumber
                
                let dd = Double(d) / 10.0
                
                
                if (jj == 0){
                    xVals.append(stTime)
                }else{
                    xVals.append("")
                }

                
                
                datas.append(Int(dd))
                yVals.append(ChartDataEntry(x: Double(aaaaa), y: dd))

                aaaaa += 1
            }

            yArry.add(yVals)
            dataIntArray.add(datas)
            xArry.add(xVals)
        }
        
        return (xArry,yArry,dataIntArray,dataCount)
        
        
        
    }
    
    //多日叠加
    func manyDaysSuperposition(_ dataArray:NSArray) ->([String],NSMutableArray,NSMutableArray,NSMutableArray){
        

        let dateArray = NSMutableArray()
        
        let yArry = NSMutableArray()
        let dataIntArray = NSMutableArray()


        var xVals = [String]()

        for index in 0 ..< 480 {
            if (index % 60 == 0){
                
                let time = index / 20
                
                xVals.append("\(time):00")
            }else{
                xVals.append("")
            }
        }
        
        
        
        for index in 0 ..< dataArray.count { //天数循环
            
            let tmp = dataArray[index] as! NSDictionary
            //日期
            let day = tmp.value(forKey: "day") as! String
            let newTiem:Double = Double(day)! / 1000 + 8 * 60 * 60
            let dayTime = Date(timeIntervalSince1970: newTiem)
            let str = String(describing: dayTime)
//            let stTime:String = (str as NSString).substring(with: NSRange(5...10))
            
            let stTime:String = (str as NSString).substring(with: NSRange(location: 5, length: 6))
            
            dateArray.add(stTime)
            
            
            
            var yVals = [ChartDataEntry]()
            var datas = [Int]()
            
            
            //数据
            let data = tmp.value(forKey: "data") as! NSArray
            
            
            
            for jj in 0 ..< data.count {

                var fristCount = jj
                if (index == 0){
                    fristCount = 480 - data.count + jj
                }

                let ttttDic = data[jj] as! NSDictionary
                
                //血糖值
                let d = ttttDic.value(forKey: "d") as! NSNumber
                let dd = Double(d) / 10.0
//                let t = ttttDic.valueForKey("t") as! Double
//                
//                //单条数据的时间
//                let newTiem:Double = t / 1000
//                let dayTime = NSDate(timeIntervalSince1970: newTiem)
//                let str = String(dayTime)
//                let stTime:String = (str as NSString).substringWithRange(NSRange(11...15))

                yVals.append(ChartDataEntry(x: Double(fristCount), y: dd))
                datas.append(Int(dd))
            }

            yArry.add(yVals)
            dataIntArray.add(datas)
            
        }

        return (xVals,yArry,dataIntArray,dateArray)
    }
    //单日图形
    func oneDayDataSet(_ dataDic:NSDictionary) ->([String],[ChartDataEntry],[Int],String){
        
        let day = dataDic.value(forKey: "day") as! String
        
        
        let newTiem:Double = Double(day)! / 1000 + 8 * 60 * 60
        let dayTime = Date(timeIntervalSince1970: newTiem)
        let str = String(describing: dayTime)
//        let stTime:String = (str as NSString).substring(with: NSRange(0...10))
        
        let stTime:String = (str as NSString).substring(with: NSRange(location: 0, length: 11))
        
        let dataArray = dataDic.value(forKey: "data") as! NSArray
        
        var xVals = [String]()
        var yVals = [ChartDataEntry]()
        var dataMax = [Int]()
        
        for tmp in 0 ..< dataArray.count {
            
            let tmpDic = dataArray[tmp] as! NSDictionary
            
            //血糖值
            let d = tmpDic.value(forKey: "d") as! NSNumber
            let dd = Double(d) / 10.0
            
            let t = tmpDic.value(forKey: "t") as! Double
            //单条数据的时间
            let newTiem:Double = t / 1000 + 8 * 60 * 60
            let dayTime = Date(timeIntervalSince1970: newTiem)
            let str = String(describing: dayTime)
//            let stTime:String = (str as NSString).substring(with: NSRange(11...15))
            let stTime:String = (str as NSString).substring(with: NSRange(location: 11, length: 5))
            
            xVals.append(stTime)
            yVals.append(ChartDataEntry(x: Double(tmp), y: dd))
            dataMax.append(Int(dd))
        }
        
        return (xVals,yVals,dataMax,stTime)
    }
    
    //饼图
    func getPieDataService(_ pieDataDic:NSDictionary) ->([String],[ChartDataEntry]){
        
        
        var pieyVals = [ChartDataEntry]()
        var piexVals = [String]()
        
        let aValue = pieDataDic.value(forKey: "a") as! Double
        let bValue = pieDataDic.value(forKey: "b") as! Double
        let cValue = pieDataDic.value(forKey: "c") as! Double
 
        piexVals.append("")
        piexVals.append("")
        piexVals.append("")
        
//        pieyVals.append(ChartDataEntry(x: aValue, y: 1))
//        pieyVals.append(ChartDataEntry(x: bValue, y: 2))
//        pieyVals.append(ChartDataEntry(x: cValue, y: 3))
        
        pieyVals.append(ChartDataEntry(x: 1, y: aValue))
        pieyVals.append(ChartDataEntry(x: 2, y: bValue))
        pieyVals.append(ChartDataEntry(x: 3, y: cValue))
        
        return (piexVals,pieyVals)
        
    }
    
    
    
    //MARK:第一天有参比数据特殊处理  CurrentChartView
    func getFirstData(_ currentDay:String,firstFinger:NSArray,recDataArray:NSArray,KkValue:Double) ->(NSMutableArray,NSMutableArray,NSMutableArray,Int){
        //指血值
//        let fingerNum = firstFinger[0] as! String
        //指血时间
        let fingerDate = firstFinger[1] as! Date

        //转换成时间戳
        let time:Int = Int(fingerDate.timeIntervalSince1970)
        
        //需要返回的数据
        let dataXvalsArray = NSMutableArray()   //x
        let dataYvalsArray = NSMutableArray()   //y
        let dataMaxArray = NSMutableArray()     //最大值
        
        
        var dataCount = 0
        
        //有参比的数据
        var xVals = [String]()
        var yVals = [ChartDataEntry]()
        var dataMax = [Int]()
        //无参比的数据
        let NxVals = [String]()
        var NyVals = [ChartDataEntry]()
        var NdataMax = [Int]()
        
        
        var index = 0
        var notFidx = 0
        
        //没有参比的背景差值
//        var KK:Double = 0.0
        //遍历数据源
        for item in recDataArray {
            
            let tmp = item as! BloodSugarModel
            //数据库时血糖
            let blood:Double = Double(tmp.glucose)!
            //数据库时电流
            let current:Double = Double(tmp.current)!
            
            //根据第一个电流值，获得 K值
//            if notFidx == 0 {
//                KK = current / Double(fingerNum)
//            }
            
            //数据库时间戳
            let timeStamp:Int = Int(tmp.timeStamp)!

            let recordDate = Date(timeIntervalSince1970: Double(timeStamp))
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let timeStr = formatter.string(from: recordDate)
            

          
            let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
            
            let xV:String = (timeStr as NSString).substring(with: NSRange(location: 11, length: 5))
            
            //如果时间等于传进来的参数，则是想要的数据
            if currentDay == tmpStri{
                //如果数据库时间小于参比指血的时间，则为电流数据
                if timeStamp < time {

                    let CRT = current / KkValue
                    
                    let currentNumberRounded = NSString(format: "%.1f", CRT)
                    
//                    NxVals.append(xV)
                    
                    xVals.append(xV)
                    
//                    NyVals.append(ChartDataEntry(x: Double(currentNumberRounded as String)!, y: Double(notFidx)))

                    
                    NyVals.append(ChartDataEntry(x: Double(notFidx), y:Double(currentNumberRounded as String)!))
                    
                    NdataMax.append(Int(Double(currentNumberRounded as String)!))
                    
                    notFidx += 1
                    
                }else{ //则为血糖数据
                    
                    xVals.append(xV)
//                    yVals.append(ChartDataEntry(x: blood, y: Double(notFidx + index)))
                    
                    yVals.append(ChartDataEntry(x: Double(notFidx + index), y: blood))
                    
                    
                    
                    
                    dataMax.append(Int(blood))
                    
                    index += 1
                }
                
                
            }
            
        }
        
        
        
        
//        dataXvalsArray.add(NxVals)
        dataXvalsArray.add(xVals)
        
        dataYvalsArray.add(NyVals)
        dataYvalsArray.add(yVals)
        
        dataMaxArray.add(NdataMax)
        dataMaxArray.add(dataMax)
        
        

        
        dataCount = NxVals.count

        //x,y，最大值，分割线位置
        return (dataXvalsArray,dataYvalsArray,dataMaxArray,dataCount)
        
    }
    
    //MARK:第一天没有参比特殊处理
    func getFirstDataAndNotFinger(_ currentDay:String,recDataArray:NSArray) ->([String],[ChartDataEntry],[Int]){
        
        var xVals = [String]()
        var yVals = [ChartDataEntry]()
        var dataMax = [Int]()
        
        var index = 0
        
        for item in recDataArray {
            
            let tmp = item as! BloodSugarModel
            
            
            //电流
            let current:Double = Double(tmp.current)!
            //日期
            let timeStamp:Int = Int(tmp.timeStamp)!

            let recordDate = Date(timeIntervalSince1970: Double(timeStamp))
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let timeStr = formatter.string(from: recordDate)
            

            
            let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
            //时间
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
    
    //获取 K值
    func getKvalue(firstFinger:NSArray,recDataArray:NSArray) ->Double{
        
        
        var KVALUE:Double = 0.0
        
        //指血值
        let fingerNum = firstFinger[0] as! String
        //指血时间
        let fingerDate = firstFinger[1] as! Date
        
        print(fingerNum,fingerDate)
        
        //转换成时间戳
        let time:Int = Int(fingerDate.timeIntervalSince1970)
//        print("time:\(time)")
        
        
        
        
        //遍历数据源
        for item in recDataArray{
            
            let tmp = item as! BloodSugarModel

            //数据库时电流
            let current:Double = Double(tmp.current)!
            
            //根据第一个电流值，获得 K值
           
            
            //数据库时间戳
            let timeStamp:Int = Int(tmp.timeStamp)!
            
//            print("timeStamp:\(timeStamp) current:\(current)")
            
            if timeStamp >= time{
                
                KVALUE = current / Double(fingerNum)!
                return KVALUE
            }
            
            
        }
        
        return KVALUE
    }
    
    
}
