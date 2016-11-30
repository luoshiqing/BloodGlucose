//
//  BTDiscovery.swift
//  GBLE
//
//  Created by Sqluo on 1/19/15.
//  Copyright (c) 2015 Sqluo. All rights reserved.
//


import Foundation
import CoreBluetooth

//创建单实例
//var btDiscoverySharedInstance: BTDiscovery?




protocol BTStatusDelegate: NSObjectProtocol{
    func discoveredDevice(_ devices:NSArray)
    func btStatusChanged(_ status:BleStatus)
    func receiveBtMessage(_ msg:Data)
    
    func connectBlu(_ perp:CBPeripheral) //自动连接
    
    func disconnectToconnectBlu()
    
    func notDDDDD()
    
    
    func notFindBlueDevice()
}


enum BleStatus{
    case didDiscoverPeripheral
    case didConnectPeripheral
    case didDisconnectPeripheral
    case btClosed
    case btNotSupport
    case normal
}

class BTDiscovery: NSObject, CBCentralManagerDelegate, BTServiceDelegate {
    
    var centralManager: CBCentralManager! = CBCentralManager()
    var peripheralBLE: CBPeripheral?
    weak var delegate: BTStatusDelegate?
    
    var validateDevices:NSMutableArray!
    
    var connectTimeout:Timer!
    
    override init() {
        super.init()
        validateDevices = NSMutableArray()
        let centralQueue = DispatchQueue(label: "com.nashsu", attributes: [])
        self.centralManager = CBCentralManager(delegate: self, queue: centralQueue)

    }
    
    func startScanning() {
        if let central = centralManager {
            central.scanForPeripherals(withServices: [BLEServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    func startScanning1() {
        if let central = centralManager {
            central.scanForPeripherals(withServices: [BLEServiceUUID], options: nil)
        }
    }
    
    var bleService: BTService? {
        didSet {
            if let service = self.bleService {
                service.startDiscoveringServices()
                service.delegate = self
            }
        }
    }
    
    func receiveBtMessage(_ msg: Data) {
        self.delegate?.receiveBtMessage(msg)
    }
    
    func notBluDevice() {
        self.delegate?.notDDDDD()
    }
    
    //MARK:点击首页是否回调
    var connectState:Bool = true
    
    // MARK: - CBCentralManagerDelegate
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
//        print("peripheral:\(peripheral)")
        
        // 验证 peripheral 有效性
        if ( (peripheral.name == nil) || (peripheral.name == "")) {
            
            return
        }

        if let oneNo:Bool = UserDefaults.standard.value(forKey: "oneNo") as? Bool {
//            print(oneNo)
            
            if (oneNo == true) {
                if validateDevices.index(of: peripheral as AnyObject) >= validateDevices.count {
                    validateDevices.add(peripheral)
                }
                
                self.delegate?.discoveredDevice(validateDevices)
            }else{
                
                if let lanyaName:String = UserDefaults.standard.value(forKey: "LanYaName") as? String{
                    print("探针id\(lanyaName)")
                    
                    
                    if lanyaName == peripheral.name {
                        print("一样的")
                        self.centralManager.stopScan()
                        
                        self.delegate?.connectBlu(peripheral)
                       
                        
                        
                    }else{
                        print("不一样的")
                        self.delegate?.notFindBlueDevice()
                    }
                    
                }
                
                
            }
            
  
        }else{
            if validateDevices.index(of: peripheral as AnyObject) >= validateDevices.count {
                validateDevices.add(peripheral)
            }
            
            self.delegate?.discoveredDevice(validateDevices)
        }
        
        
        
        
        
    }
    

    func connectToPeripheral(_ peripheral:CBPeripheral){
        
        print("连接 ？？？")
        
        
        print("\(peripheral)")
        // 如果没有连接到 peripheral, 则进行连接
        if ((self.peripheralBLE == nil) || (self.peripheralBLE?.state == CBPeripheralState.disconnected)) {
            // 保存peripheral连接，否则会断开
            self.peripheralBLE = peripheral

            // 重置服务
            self.bleService = nil

            // 连接到 peripheral
            centralManager.connect(peripheral, options: nil)
        
            self.delegate?.btStatusChanged(BleStatus.didDiscoverPeripheral)

        }
    }
    
    func reconnectPeripheral(){
        print("reconnectPeripheral")
        self.clearDevices()
        self.startScanning()
    }
    //MARK:-蓝牙 连接断开 
    //连接成功
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("连接成功")

        // 连接成功后，创建一个新的 service
        if (peripheral == self.peripheralBLE) {
            self.bleService = BTService(initWithPeripheral: peripheral)
        }
        
        //connectTimeout.invalidate()
        self.delegate?.btStatusChanged(BleStatus.didConnectPeripheral)
        
        // 停止扫描
        central.stopScan()

        if(self.validateDevices != nil){
            self.validateDevices.removeAllObjects()
        }
        
    }
    
    //断开连接
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        print("蓝牙连接断开")
        
        if self.connectState == true{
            self.delegate?.disconnectToconnectBlu()
        }else{
            print("点击首页退出，不需要回调")
        }
        
//
//        // 开始重新扫描设备
//        self.startScanning()
    }
    
    // MARK: - Private
    
    func clearDevices() {
        if self.peripheralBLE != nil{
            centralManager.stopScan()
            centralManager.cancelPeripheralConnection(self.peripheralBLE!)
            
        }
        self.bleService = nil
        self.peripheralBLE = nil
    }
    
    //判断当前蓝牙状态
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
 
        case .poweredOff:
            self.delegate?.btStatusChanged(BleStatus.btClosed)
            self.clearDevices()
            
        case .unauthorized:
            //当前设备不支持 BLE，这里应该通知用户
            self.delegate?.btStatusChanged(BleStatus.btNotSupport)
            
            break
            
        case .unknown:
            // 未知，等待其他状态
            break
        case .poweredOn:
            //如果是开启状态，开始扫描periperal
            self.delegate?.btStatusChanged(BleStatus.normal)
            
            self.startScanning()
            
        case .resetting:
            //重置
            self.clearDevices()
            
//        case CBCentralManagerState.Unsupported:
//            break
            
        default:
            break
        }
    }
    
}
