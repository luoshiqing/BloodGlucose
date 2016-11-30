//
//  BloodListViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/5.
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


class BloodListViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    @IBOutlet weak var myTabView: UITableView!
    
    
    
    
    @IBOutlet weak var xuhaoToLeftW: NSLayoutConstraint!//24
    @IBOutlet weak var xuhaoToRightW: NSLayoutConstraint!//24
    @IBOutlet weak var xuhaoW: NSLayoutConstraint!//50
    @IBOutlet weak var xuetangW: NSLayoutConstraint!//50
    @IBOutlet weak var xuetangToRightW: NSLayoutConstraint!//24
    
    @IBOutlet weak var dianliuW: NSLayoutConstraint!//50
    
    
    
    
    
    
    
    
    
    var dataArray = NSArray()
    
    
    var sortArray = [String]()
    var timeArray = [String]()
    var glucoseArray = [String]()
    var electricArray = [String]()

    func setLayOut(){
        let Wsize = UIScreen.main.bounds.width / 320
        
        xuhaoToLeftW.constant = Wsize * 24
        xuhaoToRightW.constant = Wsize * 24
        xuhaoW.constant = Wsize * 50
        xuetangW.constant = Wsize * 50
        xuetangToRightW.constant = Wsize * 24
        
        dianliuW.constant = Wsize * 50
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "原始数据"
        
        //添加导航栏右边按钮
        self.setNav()
        
        //布局
        self.setLayOut()
     
        
        self.myTabView.tableFooterView = UIView()
        
    }
    
    
    
    
    
    //开启滑动返回
    override func viewDidAppear(_ animated: Bool) {

        if self.dataArray.count <= 0{
            self.daoxupaixu()
        }

        if ((self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer))) != nil) {
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
        }
    }
    
    
    var rightBtn:UIButton!
    
    func setNav(){
        //添加排序按钮
        self.rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 28))
        self.rightBtn.setTitle("正序", for: UIControlState())
        self.rightBtn.addTarget(self, action: #selector(BloodListViewController.rightBtnAct), for: UIControlEvents.touchUpInside)
        self.rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.rightBtn.tag = 329002
        let rightItem = UIBarButtonItem(customView: self.rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    

    
    
    var paixuState:Bool = true //排序，true为倒序
    
    //MARK:排序按钮
    func rightBtnAct(){
        
        
        
        
        if self.paixuState == true { //如果为true ，则进行正序排序
            self.rightBtn.setTitle("倒序", for: UIControlState())
            self.paixuState = false
//            self.zhengxu()
        }else{//如果为false ，则进行倒序排序
            self.rightBtn.setTitle("正序", for: UIControlState())
            self.paixuState = true
//            self.daoxupaixu()
        }
        self.reverseSomeArray()
        
    }
    
    func clearArray(){
        
        self.sortArray.removeAll()
        self.timeArray.removeAll()
        self.glucoseArray.removeAll()
        self.electricArray.removeAll()
    }
    
    //正序
    func zhengxu(){
        //正序 1...max
        self.bleConnectHud = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.bleConnectHud.textLabel.text = "读取中.."
        self.bleConnectHud.show(in: self.view, animated: true)
        
        self.clearArray()
        
        
        calculateAndUploadQueue.async(execute: { () -> Void in

            
            self.dataArray = self.dataArray.sortedArray(comparator: { (obj1, obj2) -> ComparisonResult in
                
                let b = obj1 as! BloodSugarModel
                let a = obj2 as! BloodSugarModel
                
                if Int(a.timeStamp) > Int(b.timeStamp) {
                    return ComparisonResult.orderedAscending
                }else{
                    return ComparisonResult.orderedDescending
                }
            }) as NSArray
            
            if self.dataArray.count > 0{
                
                var i = 1
                
                for item in self.dataArray {
                    let ttmp = item as! BloodSugarModel
                    
                    let recordDate = Date(timeIntervalSince1970: Double(ttmp.timeStamp)!)
                    
                    let formatter = DateFormatter()
                    
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let timeStr = formatter.string(from: recordDate)
                    
//                    let stri:String = (timeStr as NSString).substring(with: NSRange(5...15))
                    
                    let stri = (timeStr as NSString).substring(with: NSRange(location: 5, length: 11))
                    
                    
                    
                    let elec = ttmp.current
                    let glu = ttmp.glucose
                    
                    self.sortArray.append("\(i)")
                    self.timeArray.append("\(stri)")
                    self.glucoseArray.append("\(glu)")
                    self.electricArray.append("\(elec)")
                    
                    i += 1
                }
                
                
                
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.myTabView.reloadData()
                
                self.bleConnectHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.bleConnectHud.textLabel.text =  "读取完毕"
                self.bleConnectHud.dismiss(afterDelay: 0.8, animated: true)
            })
            
        })
    }
    
    
    func reverseSomeArray(){
        
        self.sortArray =  self.sortArray.reversed()
        self.timeArray = self.timeArray.reversed()
        self.glucoseArray = self.glucoseArray.reversed()
        self.electricArray = self.electricArray.reversed()
    
        
        self.myTabView.reloadData()
        
    }
    
    
    
    
    //倒序
    func daoxupaixu(){
        //true 为 倒序
        self.bleConnectHud = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.bleConnectHud.textLabel.text = "读取中.."
        self.bleConnectHud.show(in: self.view, animated: true)
        
        self.clearArray()
        
        
        calculateAndUploadQueue.async(execute: { () -> Void in
            
            self.dataArray = BloodSugarDB().selectAll()
            //        print(self.dataArray.count)
            
            self.dataArray = self.dataArray.sortedArray(comparator: { (obj1, obj2) -> ComparisonResult in
                
                var a = BloodSugarModel()
                var b = BloodSugarModel()
                
                
                a = obj1 as! BloodSugarModel
                b = obj2 as! BloodSugarModel
                
               
                
                if Int(a.timeStamp) > Int(b.timeStamp) {
                    return ComparisonResult.orderedAscending
                }else{
                    return ComparisonResult.orderedDescending
                }
            }) as NSArray
            
            if self.dataArray.count > 0{
                
                var i = 0
                let count = self.dataArray.count
                
                for item in self.dataArray {
                    let ttmp = item as! BloodSugarModel
                    
                    let recordDate = Date(timeIntervalSince1970: Double(ttmp.timeStamp)!)
                    
                    let formatter = DateFormatter()
                    
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let timeStr = formatter.string(from: recordDate)
                    
//                    let stri:String = (timeStr as NSString).substring(with: NSRange(5...15))
                    
                    let stri = (timeStr as NSString).substring(with: NSRange(location: 5, length: 11))
                    
                    
                    
                    let elec: String = ttmp.current
                    let glu: String = ttmp.glucose
                    
                    
                    
                    self.sortArray.append("\(count - i)")
                    self.timeArray.append(stri)
                    self.glucoseArray.append(glu)
                    self.electricArray.append(elec)
                    
                    i += 1
                }
                
                
                
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.myTabView.reloadData()
                
                self.bleConnectHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.bleConnectHud.textLabel.text =  "读取完毕"
                self.bleConnectHud.dismiss(afterDelay: 0.8, animated: true)
            })
            
        })
        
        
        
        
    }
    
    
    var calculateAndUploadQueue = DispatchQueue(label: "com.nashsu.cc", attributes: [])
    var bleConnectHud:JGProgressHUD!
    
    override func viewWillAppear(_ animated: Bool) {
        
        BaseTabBarView.isHidden = true
  
        
    }
    
 
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.glucoseArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ddd = "DayHisetoryCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? DayHisetoryTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("DayHisetoryTableViewCell", owner: self, options: nil )?.last as? DayHisetoryTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        
        if(self.dataArray.count > 0){
            cell?.sortLabel.text = self.sortArray[indexPath.row]
            cell?.bloodLabel.text = self.glucoseArray[indexPath.row]
            cell?.elecLabel.text = self.electricArray[indexPath.row]
            cell?.timeLabel.text = self.timeArray[indexPath.row]
            
            
            
            
            
        }
        
        //设置选中cell 时的颜色
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        return cell!
    }
    
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        self.myTabView.reloadData()
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
