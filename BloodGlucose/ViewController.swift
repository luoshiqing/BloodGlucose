    /// Swift Migrator:
///
/// This file contains one or more places using either an index
/// or a range with ArraySlice. While in Swift 1.2 ArraySlice
/// indices were 0-based, in Swift 2.0 they changed to match the
/// the indices of the original array.
///
/// The Migrator wrapped the places it found in a call to the
/// following function, please review all call sites and fix
/// incides if necessary.
@available(*, deprecated: 2.0, message: "Swift 2.0 migration: Review possible 0-based index")
private func __reviewIndex__<T>(_ value: T) -> T {
    return value
}

//
//  ViewController.swift
//  BloodGlucose
//
//  Created by nash_su on 1/28/15.
//  Copyright (c) 2015 nash_su. All rights reserved.
//

import UIKit
import CoreBluetooth
    
    //记录是几天前
    var dayTimeLast:Int = 0
    
    //记录起始监测时间
    var startUseTime:Int!
    //id
    var senSSId:String!
    
    
var HbA1cINT:Int = 0
    
//是否为主动断开蓝牙设备
var isMyBack:Bool = false
    
    

var blueImag:Bool = false
var bluescAt:Bool = false


var bleDeviceNameIn:String!  //设备名称
var probeNameIn:String!      //探针次数
var startTimeIn:Double!     //起始监测时间

var ahistroydate:Bool = true
var countI:Int = 0

enum DevicePhase{
    case deviceInit
    case deviceMonitor
    case deviceEndMonitor
}

enum DeviceStep{
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

enum CommandType{
    case connect
    case syncTime
    case getLog
    case getStatus
    case getDeviceId
    case getBloodData
    case allGetBloodData
}

class ViewController: UIViewController{
    
    

    
  
    override func viewDidLoad() {
        super.viewDidLoad()
     

    }
    
    
}

