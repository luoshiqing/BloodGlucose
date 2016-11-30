//
//  SBMGSevice.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class SBMGSevice: NSObject {


    //计算命令亦或校验
    func getXORValue(_ command:[UInt8]) -> UInt8{
        var result = 0x00
        
        result = Int(command[0])
        
        for (index,_) in command.enumerated() {
            if (index != 0){
                result  = result ^ Int((command[index]))
            }
        }
        return UInt8(result)
    }
    
    func getCurrentUnixTime() -> [UInt8]{
        
        let date = Date()

        let currentTime:Int = Int(date.timeIntervalSince1970)
        
//        if (self.initDate != nil){
//            currentTime = currentTime - self.initDate
//        }
        
        
        let timeString = NSString(format:"%2X", currentTime)
        let timeArray =  Array(String(timeString).characters)
        
        var count = 0
        var tmpString:String = String()
        var result:[UInt8] = Array()
        
        for item in timeArray{
            if count < 2{
                tmpString = tmpString + String(item)
                count += 1
            }
            
            if count == 2{
                result.append( UInt8(strtol(tmpString,nil,16)) )
                tmpString = ""
                count = 0
            }
        }
        
        result = Array(result.reversed())
        
        return result
        
    }
    
    
    //MARK:-解析传感器ID
    func parseSensorId(_ msg:[UInt8]) -> Int{
        var probeId = 0
        if msg.count == 7 {
            //确定是血糖数据起始
            if msg[0] == 0x1f && msg[1] == 0xa1{
                
                let probe = self.byteArrayToStr([msg[5],msg[4],msg[3]]).hexaToDecimal
                probeId = probe
            }
        }
        return probeId
    }
    
    func byteArrayToStr(_ msg:[UInt8]) -> String{
        var str = ""
        for (index,item) in msg.enumerated(){
            let convertedHex = (NSString(format:"%2X", item) as String).condenseWhitespace()
            if index == 1{
                if item != 0{
                    //在数据小于16的时候在前面手工补0
                    if Int(item) < 16{
                        str = "\(str)0\(convertedHex)"
                    }else{
                        str = "\(str)\(convertedHex)"
                    }
                }else{
                    str = "\(str)00"
                }
            }else{
                str = "\(str)\(convertedHex)"
            }
            
        }
        
        return str
    }

    //MARK:-解析设备ID
    func parseDeviceId(_ msg:[UInt8]) ->String{
        var sensoridSTR = ""
        if msg.count == 7 {
            //确定是血糖数据起始
            if msg[0] == 0x1f && msg[1] == 0xad{

                let sensorId = self.byteArrayToStr([msg[5],msg[4],msg[3],msg[2]]).hexaToInt64
                sensoridSTR = "\(sensorId)"
                print("--------------------------------设备id解析完毕----------------------------------------------------------")
                print("设备 ID：\(sensorId)")
  
            }
        }
        return sensoridSTR
    }
    
    //从消息中提取时间
    func parseDate(_ msg:[UInt8]) -> Date{
        
        
        
        if msg.count == 9{
            var parsedArray = msg.map { (item) -> String in
                let tmp = String(item).decimalToHexa
                if NSString(string: tmp).length == 1{
                    return "0\(tmp)"
                }else{
                    return "\(tmp)"
                }
            }
            let tsString = "\(parsedArray[7])\(parsedArray[6])\(parsedArray[5])\(parsedArray[4])"
            
            
            let ts = Double(tsString.hexaToDecimal)
            
            let date = Date(timeIntervalSince1970: ts)
            
            return date
        }else{
            return Date()
        }
    }
    
    //计算设备初始化时间与当前时间差值及初始化是否结束（7分钟初始化）
    func calculateSevenMinInitTime(_ initStartTime:Int) -> (finished:Bool, remainTime:Int){
        
        let date = Date()
        
        let tz = TimeZone.autoupdatingCurrent
        
        let seconds = Double(tz.secondsFromGMT(for: date))
        
        let currentTimestamp:Int = Int(Date(timeInterval: seconds, since: date).timeIntervalSince1970)
        
        //本地时间+8小时
        let initStartTimeLocal = initStartTime + 28800
        
        if currentTimestamp > initStartTimeLocal {
            
            let timeGap:Int = currentTimestamp - initStartTimeLocal
            
            if timeGap < 420{
                return (false, 420 - timeGap)
            }else{
                return (true, 0)
            }
            //            if timeGap < 10{
            //                return (false, 10 - timeGap)
            //            }else{
            //                return (true, 0)
            //            }
            
        }
        
        return (false, -1)
        
    }
    
    //计算极化时间与当前时间差值及极化是否结束（3小时极化）
    func calculateInitTime(_ initStartTime:Int) -> (finished:Bool, remainTime:Int){
        
        let date = Date()
        
        let tz = TimeZone.autoupdatingCurrent
        
        let seconds = Double(tz.secondsFromGMT(for: date))
        
        let currentTimestamp:Int = Int(Date(timeInterval: seconds, since: date).timeIntervalSince1970)
        
        
        //本地时间+8小时
        let initStartTimeLocal = initStartTime + 28800
        
        if currentTimestamp > initStartTimeLocal{
            
            let timeGap = currentTimestamp - initStartTimeLocal
            
            if Double(timeGap)/60/60 < 3{
                return (false, 3*60*60 - timeGap)
            }else{
                return (true, 0)
            }
            
        }
        
        return (false, -1)
        
    }
    
    
    //7分钟时间计算
    func setSevenTime(_ min:Int,sec:Int) ->(String,String){

        var Fmin:String = ""
        if (min < 10){
            Fmin = "0\(min)"
        }else{
            Fmin = "\(min)"
        }
        var Fsec:String = ""
        if (sec < 10){
            Fsec = "0\(sec)"
        }else{
            Fsec = "\(sec)"
        }

        
        return (Fmin,Fsec)
    }
    //设置总监测时长
    func setAllTimes(_ startTime:Int,initState:Bool) ->(Bool,String){
    
        let today:Double = Date().timeIntervalSince1970 //当前时间
        let allJcTime:Int = Int(today) - startTime  //总监测时间 - 秒
        
        if initState == true { //180分钟极化中
            
            let initAllTime = 180 * 60 - allJcTime //极化剩余总秒数
  
            let jhMin:Int = initAllTime / 60 //分
            let jhSec:Int = initAllTime % 60 //秒
            //返回的秒
            var FjhSec:String?
            
            if jhSec < 10 {
                FjhSec = "0\(jhSec)"
            }else{
                FjhSec = "\(jhSec)"
            }
            
            //返回分钟
            var FjhMin:String?
            var Fhour:String?
            switch jhMin {
            case 0..<10:
                FjhMin = "0\(jhMin)"
                Fhour = "00"
            case 10..<60:
                FjhMin = "\(jhMin)"
                Fhour = "00"
            default:
                let hour = jhMin / 60 //小时
                let min = jhMin % 60 //分钟
                
                if (hour < 10){
                    Fhour = "0\(hour)"
                }else{
                    Fhour = "\(hour)"
                }
                
                if min < 10 {
                    FjhMin = "0\(min)"
                }else{
                    FjhMin = "\(min)"
                }
 
            }
            
            let bol = initAllTime > 0 ? false : true
            
            return (bol,"\(Fhour!):\(FjhMin!):\(FjhSec!)")
            
        }else{ //180分钟极化完成
            
            let min:Int = allJcTime / 60 //分
            let sec:Int = allJcTime % 60 //秒
            
            var Xday:String?
            var Xhour:String?
            var Xmin:String?
            var Xsec:String?
            
            //计算秒
            if sec < 10 {
                Xsec = "0\(sec)"
            }else{
                Xsec = "\(sec)"
            }
            
            switch min {
            case 0..<10:
                Xmin = "0\(min)"
                Xhour = "00"
                return (true,"\(Xhour!):\(Xmin!):\(Xsec!)")
            case 10..<60:
                Xmin = "\(min)"
                Xhour = "00"
                return (true,"\(Xhour!):\(Xmin!):\(Xsec!)")
            case 60..<60*24:
                
 
                let h = min / 60 //时
                let m = min % 60 //分
                
                if m < 10 {
                    Xmin = "0\(m)"
                }else{
                    Xmin = "\(m)"
                }
                switch h {
                case 0..<10:
                    Xhour = "0\(h)"
                    return (true,"\(Xhour!):\(Xmin!):\(Xsec!)")

                default:
                    Xhour = "\(h)"
                    return (true,"\(Xhour!):\(Xmin!):\(Xsec!)")
                
                }
                
            default:
                //大于一天
                
                let tmphh = min / 60 //
                let mm = min % 60 //分
                let dd = tmphh / 24 //天
                let hh = dd % 24 //时
                
                if dd < 10 {
                    Xday = "0\(dd)"
                }else{
                    Xday = "\(dd)"
                }
                
                if hh < 10 {
                    Xhour = "0\(hh)"
                }else{
                    Xhour = "\(hh)"
                }
                
                if mm < 10 {
                    Xmin = "0\(mm)"
                }else{
                    Xmin = "\(mm)"
                }
                
                return (true,"\(Xday!)-\(Xhour!):\(Xmin!):\(Xmin!)")
                    
                }
            }

        }
    

    //MARK:- 设置监测时间
    func allTimeNsTimerAction(_ startTime:Int,jihuaYN:Bool) ->String{
        let today:Double = Date().timeIntervalSince1970
        
        
        let jcTimeS:Int = Int(today) - startTime
        
        
        //        self.allJcTime = jcTimeS  //总监测秒数

        
        //判断是否为极化中
        if (jihuaYN == true){
            //极化中
            //极化剩余总秒数
            let jihuaTime:Int = 180 * 60 - jcTimeS
            
            let jhMin:Int = jihuaTime/60 //分
            let jhSec:Int = jihuaTime%60 //秒
            
            var FjhSec:String = ""
            if (jhSec < 10){
                FjhSec = "0\(jhSec)"
            }else{
                FjhSec = "\(jhSec)"
            }
            
            if (jhMin >= 60){
                let hour = jhMin/60
                let min = jhMin%60
                
                var Fmin:String = ""
                if (min < 10){
                    Fmin = "0\(min)"
                }else{
                    Fmin = "\(min)"
                }
                var Fhour:String = ""
                if (hour < 10){
                    Fhour = "0\(hour)"
                }else{
                    Fhour = "\(hour)"
                }
                
                let timeAll = "\(Fhour):\(Fmin):\(FjhSec)"
                return timeAll

            }else{
                
                
                
                var Fmin:String = ""
                if (jhMin < 10){
                    Fmin = "0\(jhMin)"
                }else{
                    Fmin = "\(jhMin)"
                }
                
                let timeAll = "00:\(Fmin):\(FjhSec)"
                return timeAll

            }

        }else{
            //极化完成
            
            let minFen:Int = jcTimeS/60 //分
            let secMmm:Int = jcTimeS%60 //秒
            var hourShi:Int = 0            //时
            
            
            
            
            var FsecMmm:String = ""
            if (secMmm < 10){
                FsecMmm = "0\(secMmm)"
            }else{
                FsecMmm = "\(secMmm)"
            }
            
            var FminFen:String = ""
            if (minFen < 10){
                FminFen = "0\(minFen)"
            }else{
                FminFen = "\(minFen)"
            }
            
            
            
            
            if (minFen < 60){
                //小于一个小时
                
                
                let timeAll = "0-00:\(FminFen):\(FsecMmm)"
                return timeAll

            }else if (minFen < 1440){
                //小于一天
                hourShi = minFen/60 //时
                let minnnFen:Int = minFen%60 //分
                
                var FminnnFen:String = ""
                if (minnnFen < 10){
                    FminnnFen = "0\(minnnFen)"
                }else{
                    FminnnFen = "\(minnnFen)"
                }
                
                var FhourShi:String = ""
                if (hourShi < 10){
                    FhourShi = "0\(hourShi)"
                }else{
                    FhourShi = "\(hourShi)"
                }
                
                let timeAll = "0-\(FhourShi):\(FminnnFen):\(FsecMmm)"
                return timeAll

            }else{
                //大于一天
                let day:Int = jcTimeS/(60 * 60 * 24) //天
                let remainJctimes:Int = jcTimeS%(60 * 60 * 24) //剩余的秒数<天>
                
                let dminF:Int = remainJctimes/60 //分<天>
                let dsecM:Int = remainJctimes%60 //秒<天>
                
                var FdsecM:String = ""
                if (dsecM < 10){
                    FdsecM = "0\(dsecM)"
                }else{
                    FdsecM = "\(dsecM)"
                }
                var FdminF:String = ""
                if (dminF < 10){
                    FdminF = "0\(dminF)"
                }else{
                    FdminF = "\(dminF)"
                }
                
                
                
                if (dminF < 60){
                    //剩余时间小于一小时
                    
                    let timeAll = "\(day)-00:\(FdminF):\(FdsecM)"
                    return timeAll

                }else{
                    hourShi = dminF/60 //时
                    let ddminf = dminF%60//分
                    
                    var FhourShi:String = ""
                    if (hourShi < 10){
                        FhourShi = "0\(hourShi)"
                    }else{
                        FhourShi = "\(hourShi)"
                    }
                    var Fddminf:String = ""
                    if (ddminf < 10){
                        Fddminf = "0\(ddminf)"
                    }else{
                        Fddminf = "\(ddminf)"
                    }
                    
                    let timeAll = "\(day)-\(FhourShi):\(Fddminf):\(FdsecM)"
                    return timeAll

                }
                
            }
        }

    }
    
    //判断数据时间是否正确 ，不为1970 为正确
    func checkTheTimeIsTrue(_ time:Double) ->Bool{
        
        let recordDate = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeStr = formatter.string(from: recordDate)

        let year:String = (timeStr as NSString).substring(to: 4)
        //print("年份：\(year)")
        
        if year != "1970" {
            return true
        }else{
            print("数据时间出错")
            return false
        }

    }
    
    //获取数据中数据一共有多少天
    func getFMDBAllDays()->(NSArray,NSMutableArray,NSMutableArray){
        //获取原始电流数据
        var recordsArray:NSArray = BloodSugarDB().selectAll()
        
        //天数数组
        let tmpDayArray = NSMutableArray()
        //详细日期数组
        let moreDayArray = NSMutableArray()
        
        if recordsArray.count > 0 {
            recordsArray = recordsArray.sortedArray(comparator: { (obj1, obj2) -> ComparisonResult in
                
                let b = obj1 as! BloodSugarModel
                let a = obj2 as! BloodSugarModel
                
                if Int(a.timeStamp) > Int(b.timeStamp) {
                    return ComparisonResult.orderedAscending
                }else{
                    return ComparisonResult.orderedDescending
                }
            }) as NSArray
            
            let tmpDic = NSMutableDictionary()

            for item in recordsArray {
                
                let tmp = item as! BloodSugarModel
                
                //数据库时间戳
                let timeStamp:Int = Int(tmp.timeStamp)!
                
                let recordDate = Date(timeIntervalSince1970: Double(timeStamp))
                
                let formatter = DateFormatter()
                
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let timeStr = formatter.string(from: recordDate)
                

                let tmpStri:String = (timeStr as NSString).substring(with: NSRange(location: 5, length: 5))
                //保存原始电流数据
                if tmpDic[tmpStri] == nil{
                    

                    print("保存时间数据数据")
                    tmpDic[tmpStri] = timeStr
                    
                    tmpDayArray.add(tmpStri)
                    moreDayArray.add("\(timeStr)")
                }
   
            }

        }
        
            
        return (recordsArray,tmpDayArray,moreDayArray)
            
    }
    
        
        
        
     //获取数据库最后一条数据的时间戳
    //MARK:获取数据库最后一条数据
    func getLastFMDBDate() ->Double{
        
        //获取原始电流数据并对其排序
        var recordsArray:NSArray = BloodSugarDB().selectAll()
        
        if recordsArray.count <= 0 {
            return 0.0
        }
        
        recordsArray = recordsArray.sortedArray(comparator: { (obj1, obj2) -> ComparisonResult in
            
            let b = obj1 as! BloodSugarModel
            let a = obj2 as! BloodSugarModel
            
            if Int(a.timeStamp) > Int(b.timeStamp) {
                return ComparisonResult.orderedAscending
            }else{
                return ComparisonResult.orderedDescending
            }
        }) as NSArray

        
        let lastTime = (recordsArray.lastObject as! BloodSugarModel).timeStamp
        
        
        
        return Double(lastTime!)!
        
    }
        
        
        
        
    
    func getFMDBSequenceAllData(_ fingerBloodDataArray:NSMutableArray)->(recordsArray:NSArray,tmpFindgerArray:NSArray){
        //获取原始电流数据并对其排序
        var recordsArray:NSArray = BloodSugarDB().selectAll()
        
        recordsArray = recordsArray.sortedArray(comparator: { (obj1, obj2) -> ComparisonResult in
            
            let b = obj1 as! BloodSugarModel
            let a = obj2 as! BloodSugarModel
            
            if Int(a.timeStamp) > Int(b.timeStamp) {
                return ComparisonResult.orderedAscending
            }else{
                return ComparisonResult.orderedDescending
            }
        }) as NSArray
        
        
        var fingerBloodArraySorted: NSArray = fingerBloodDataArray
        
        print(fingerBloodArraySorted)
        
        //对参比数据进行排序
        fingerBloodArraySorted = fingerBloodArraySorted.sortedArray(comparator: { (obj1, obj2) -> ComparisonResult in
            
            if Int(((obj1 as! NSArray)[1] as! Date).timeIntervalSince1970) > Int(((obj2 as! NSArray)[1] as! Date).timeIntervalSince1970) {
                return ComparisonResult.orderedDescending
            }else{
                return ComparisonResult.orderedAscending
            }
        }) as NSArray
        
//        //对参比数据进行排序
//        fingerBloodArraySorted.sorted() (comparator: {
//            (obj1 , obj2) -> ComparisonResult in
//            
//            if Int(((obj1 as! NSArray)[1] as! Date).timeIntervalSince1970) > Int(((obj2 as! NSArray)[1] as! Date).timeIntervalSince1970) {
//                return ComparisonResult.orderedDescending
//            }else{
//                return ComparisonResult.orderedAscending
//            }
//            
//        })
        
        return (recordsArray,fingerBloodArraySorted)
        
    }
    
    func getLastSomeData(_ count:Int) ->NSMutableArray{
        
        //需要返回的数据数组
        let dataArray = NSMutableArray()
        
        
        //获取原始电流数据并对其排序
        var recordsArray:NSArray = BloodSugarDB().selectAll()
        recordsArray = recordsArray.sortedArray(comparator: { (obj1, obj2) -> ComparisonResult in
            
            let b = obj1 as! BloodSugarModel
            let a = obj2 as! BloodSugarModel
            
            if Int(a.timeStamp) > Int(b.timeStamp) {
                return ComparisonResult.orderedAscending
            }else{
                return ComparisonResult.orderedDescending
            }
        }) as NSArray
        
        if count > 0 {
            
            for index in 0..<count {
                
                let bloodmoder = recordsArray[recordsArray.count - 1 - index] as! BloodSugarModel

                dataArray.add(bloodmoder)
   
            }
        }

        
        return dataArray
 
    }
    
    
    
    //获取当前时间
    func getCurrentTime()->String{
        
        //当前时间
        let today = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let abc = dateFormatter.string(from: today)
        
        let shijian:String = (abc as NSString).substring(to: 19)
        
        return shijian
        
    }
    
    
    
    //MARK:获取数据库最后一条数据
    func getLastFMDBBloodTime() ->Date{
        
        //获取原始电流数据并对其排序
        var recordsArray:NSArray = BloodSugarDB().selectAll()
        
        if recordsArray.count > 0 {
            
            recordsArray = recordsArray.sortedArray(comparator: { (obj1, obj2) -> ComparisonResult in
                
                let b = obj1 as! BloodSugarModel
                let a = obj2 as! BloodSugarModel
                
                if Int(a.timeStamp) > Int(b.timeStamp) {
                    return ComparisonResult.orderedAscending
                }else{
                    return ComparisonResult.orderedDescending
                }
            }) as NSArray

            let lastTime = (recordsArray.lastObject as! BloodSugarModel).timeStamp
            
            let recordDate = Date(timeIntervalSince1970: Double(lastTime!)!)

            return recordDate
            
        }else{
            return Date()
        }
        
      
        
    }
    
    
    
    
  
    
}



    
    



extension String {
    subscript (index:Int) -> String { return String(Array(self.characters)[index]) }
    
    // Hexadecimal to Decimal
    var hexaToDecimal: Int {
        
        var decimal:Int = 0
        if self == "" { return 0 }
        for index in 0..<self.characters.count {
            
            for char in 0..<16
            {
                if self[index] == "0123456789abcdef"[char] || self[index] == "0123456789ABCDEF"[char] {
                    decimal = decimal * 16 + char
                    
                }
            }
        }
        
        return self[0] == "-" ? decimal * -1 : decimal
    }
    //-------------------
    var hexaToInt64: Int64 {
        
        
        var decimal:Int64 = 0
        if self == "" { return 0 }
        for index in 0..<self.characters.count {
            
            for char in 0..<16
            {
                if self[index] == "0123456789abcdef"[char] || self[index] == "0123456789ABCDEF"[char] {
                    decimal = decimal * 16 + char
                    
                    
                }
            }
        }
        return self[0] == "-" ? decimal * -1 : decimal
    }
    //-------------------
    
    // Hexadecimal to Binary
    var hexaToBinary: String {
        var decimal = 0
        if self == "" { return "" }
        for index in 0..<self.characters.count{
            for char in 0..<16 {
                if self[index] == "0123456789abcdef"[char] {
                    decimal = decimal * 16 + char
                }
            }
        }
        return String(decimal, radix: 2)
    }
    
    // Decimal to Hexadecimal
    var decimalToHexa: String {
        return String(Int(self)!, radix: 16)
    }
    // Decimal to Binary
    var decimalToBinary: String {
        return String(Int(self)!, radix: 2)
    }
    
    // Binary to Decimal
    var binaryToDecimal: Int {
        var result = 0
        for index in 0...self.characters.count-1 {
            if self[index] == "1" { result = result * 2 + 1 }
            if self[index] == "0" { result = result * 2 + 0 }
        }
        return result
    }
    // Binary to Hexadecimal
    var binaryToHexa: String {
        return String(binaryToDecimal, radix: 16)
    }
    
    //删除起始结束空白字符
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter({!$0.characters.isEmpty})
        return components.joined(separator: " ")
    }
    
    
    
    
}

