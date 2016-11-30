//
//  SBMGBlueListView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/1.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol SBGMBlueListViewDelegate : NSObjectProtocol{
    func connectToPeripheral(_ peripheral:CBPeripheral)
}


class SBMGBlueListView: UIView ,UITableViewDataSource,UITableViewDelegate{

    weak var delegate:SBGMBlueListViewDelegate!
    
    var devices = NSArray()
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var blueListTabView: UITableView!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {

        self.blueListTabView.delegate = self
        self.blueListTabView.dataSource = self
        
        self.initSetup()
  
    }
    
    
    func reloadTabView(_ devices: NSArray){
        self.devices = devices
        self.blueListTabView.reloadData()
    }
    
    
    
    func initSetup(){
        //设置 关闭按钮 旋转
        self.closeBtn.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI / 4.0))
    }
    
    
    //MARK:TabView代理
    //Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.devices.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ddd = "SBMGBlueCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? SBMGBlueListTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("SBMGBlueListTableViewCell", owner: self, options: nil )?.last as? SBMGBlueListTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        if self.devices.count > 0 {
            if let peripheral:CBPeripheral = self.devices[(indexPath as NSIndexPath).row] as? CBPeripheral{
                cell?.nameLabel.text = peripheral.name
            }
        }
        
        
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        return cell!
    }
    
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let peripheral:CBPeripheral = self.devices[(indexPath as NSIndexPath).row] as? CBPeripheral{
            
            print("peripheral.name:\(peripheral.name)")
            
            
            var deviceName = (peripheral.name! as NSString).replacingOccurrences(of: " \n", with: "")
            //去除空格
            let whitespace = CharacterSet.whitespacesAndNewlines
            
            var tempArray = deviceName.components(separatedBy: whitespace)
            
            tempArray = tempArray.filter{
                $0 != ""
            }
            
            deviceName = tempArray[0]

            print("tempArray:\(deviceName)....")
            
            
            self.theQueryIsAvailable(deviceName,peripheral: peripheral)
            
            
            
//            self.delegate.connectToPeripheral(peripheral)
        }

    }
    
    
    
    var finish:JGProgressHUD!
    
    //MARK:修改
    func theQueryIsAvailable(_ transmitterid: String,peripheral: CBPeripheral){
        
        print(transmitterid)
        
        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = "查询中.."
        self.finish.show(in: self, animated: true)
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/device/query.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "transmitterid":transmitterid,
        ]
        
     
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            print("\(json)")
            /*
            {
                "message" : "成功",
                "code" : 0,
                "data" : {
                    "use" : true
                }
            }
            */
            
            if let ttmpData = json["data"].dictionaryObject{
                
                if let use = (ttmpData as NSDictionary).value(forKey: "use") as? Bool {
                    print(use)
                    
                    if use == true{
                        self.finishHud("设备可用", showTime: 0.1)
                        //连接
                        self.delegate.connectToPeripheral(peripheral)
                    }else{
                        
                        self.finishHud("设备未认证", showTime: 0.1)
                        
                        let alrte = UIAlertView(title: "设备未认证", message: "请联系客服", delegate: nil, cancelButtonTitle: "确定")
                        
                        alrte.show()

                    }
                    
                    
                }else{
                    self.finishHud("网络错误", showTime: 0.5)
                }
 
            }else{
                
                
                if let codes = json["code"].int{
                    
                    if codes == 10002 {
                        self.finishHud("10002", showTime: 0.1)
                        
                        let alrte = UIAlertView(title: "设备编号为空", message: "请联系客服", delegate: nil, cancelButtonTitle: "确定")
                        
                        alrte.show()
                    }else{
                        self.finishHud("设备未编号", showTime: 0.5)
                    }
                    
                    
                    
                }else{
                    self.finishHud("网络错误", showTime: 0.5)
                }
                
                
            }

            
            }, failure: { () -> Void in
                
                self.finishHud("网络错误", showTime: 0.5)
        })
        
        
        
        
        
    }
    
    func finishHud(_ showName: String,showTime: TimeInterval){
        self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.finish.textLabel.text = showName
        self.finish.dismiss(afterDelay: showTime, animated: true)
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
