//
//  BTService.swift
//  GBLE
//
//  Created by Sqluo on 1/19/15.
//  Copyright (c) 2015 Sqluo. All rights reserved.
//

//调试信息：
//
//Did Disconver Peripheral : <CBPeripheral: 0x1700e9a00, identifier = 4DB719DB-7602-4313-2A7E-B4B2E16BC87F, name = CGMS-d333e0da
//, state = disconnected>
//didConnectPeripheral
//Discoverd service : <CBService: 0x17006b400, isPrimary = YES, UUID = FFB0>
//Discoverd characteristic : <CBCharacteristic: 0x174097a20, UUID = FFB1, properties = 0x18, value = (null), notifying = NO>
//assigned command characteristic
//Discoverd characteristic : <CBCharacteristic: 0x174097b10, UUID = FFB2, properties = 0x14, value = (null), notifying = NO>
//assigned data characteristic
//Discoverd characteristic : <CBCharacteristic: 0x174094cd0, UUID = FFB5, properties = 0x2, value = (null), notifying = NO>


import Foundation
import CoreBluetooth

/* 设置 Services & Characteristics UUIDs */
let BLEServiceUUID = CBUUID(string: "FFB0")
let DataCharUUID = CBUUID(string: "FFB2")
let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"


protocol BTServiceDelegate: NSObjectProtocol{

    func receiveBtMessage(_ msg:Data)
    func notBluDevice()
}

class BTService: NSObject, CBPeripheralDelegate {
    var peripheral: CBPeripheral?
    var positionCharacteristic: CBCharacteristic?
    var dataCharacteristic: CBCharacteristic?
    weak var delegate: BTServiceDelegate!
    
    init(initWithPeripheral peripheral: CBPeripheral) {
        super.init()
        
        self.peripheral = peripheral
        self.peripheral?.delegate = self
    }
    
    deinit {
        self.reset()
    }
    
    func startDiscoveringServices() {
        self.peripheral?.discoverServices([BLEServiceUUID])
    }
    
    func reset() {
        if peripheral != nil {
            peripheral = nil
        }
        
        // Deallocating therefore send notification
        self.sendBTServiceNotificationWithIsBluetoothConnected(false)
    }
    
    // Mark: - CBPeripheralDelegate
    
    //探测到可用服务
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let uuidsForBTService: [CBUUID] = [DataCharUUID]
        
        if (peripheral != self.peripheral) {
            // 检测是否是正确的peripheral
            return
        }
        
        if (error != nil) {
            return
        }
        
        if ((peripheral.services == nil) || (peripheral.services!.count == 0)) {
            // 检测不到服务
            self.delegate.notBluDevice()
            print("检测不到服务")
            
            return
        }
        
        for service in peripheral.services! {
            //判断服务
            if service.uuid == BLEServiceUUID {
                peripheral.discoverCharacteristics(uuidsForBTService, for: service )
             }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if (peripheral != self.peripheral) {
            // 错误外设
            return
        }
        
        if (error != nil) {
            return
        }
        
        for characteristic in service.characteristics! {
            if characteristic.uuid == DataCharUUID {
                self.dataCharacteristic = (characteristic )
                peripheral.setNotifyValue(true, for: characteristic )
                
                // Send notification that Bluetooth is connected and all required characteristics are discovered
                //self.sendBTServiceNotificationWithIsBluetoothConnected(true)
            }
        }
    }
    
    // Mark: - Private
    
    func sendCommand(_ command: Data) {
        // 检测 characteristic 是否存在
        if self.dataCharacteristic == nil {
            return
        }
        
        
        //发送指令
        self.peripheral?.writeValue(command, for: self.dataCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
    }
    
    
    //从 periperal 返回的数据
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error == nil{
//            print("返回数据 : \(characteristic.value) \n", terminator: "")
            if self.delegate != nil{
                self.delegate.receiveBtMessage(characteristic.value!)
            }
        }

    }
    
    func sendBTServiceNotificationWithIsBluetoothConnected(_ isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NotificationCenter.default.post(name: Notification.Name(rawValue: BLEServiceChangedStatusNotification), object: self, userInfo: connectionDetails)
    }
    
}
