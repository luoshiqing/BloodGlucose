//
//  StageInfViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/18.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit



class StageInfViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate ,SexViewDelegate,DateViewDelegate{

    
    var myTabView:UITableView!
    
    var Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
    var Wsize = UIScreen.main.bounds.width / 320
    var size = UIScreen.main.bounds
    
    //糖尿病类型
    var bloodType:Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "填写个人信息"
        self.view.backgroundColor = UIColor.white
        
        
        
        self.setNav()
        
        //加载视图
        self.loadmyView()
        
        //加载数据
        self.setData()
        
        
        
        self.myTabView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isLogOutIn {
            self.navigationController!.popToRootViewController(animated: false)
        }
    }
    
    
    
    
    var sexArray = NSMutableArray()
    var heightArray = NSMutableArray()
    var weightArray = NSMutableArray()
    var activityArray = NSMutableArray()
    
    func setData(){
        

        self.sexArray = ["男","女"]
        self.activityArray = ["轻体力(办公室文员、司机等)","中体力(服务员、业务员等)","重体力(快递员、建筑工人等)"]
        
        for item in 120...250 {
            self.heightArray.add("\(item)")
        }
        for wei in 30...200 {
            self.weightArray.add("\(wei)")
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func setNav(){
        
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(StageInfViewController.backAct), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
        //下一步
        let rightBtn = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.nextBtnAct))
        rightBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1, green: 1, blue: 1, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBtn
        
        
    }
    func backAct(){
        self.navigationController!.popViewController(animated: true)
    }
    
    func loadmyView(){
        
        
        
        self.myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height - 64), style: UITableViewStyle.plain)
        self.view.addSubview(self.myTabView)
        self.myTabView.delegate = self
        self.myTabView.dataSource = self
        

    
    }
    
    
    
    
    
  
    var infoDic = [String:String]()
    
    func goToNextVC(){
        
        self.infoDic["stype"] = "\(self.bloodType)"

        
        switch self.bloodType {
        case 0:
            print("无糖")

            MyNetworkRequest().addUserInfoJsp(self.view,dataDic: self.infoDic, clourse: { (success) in
                if success {
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let BaseTabBarCtr = storyBoard.instantiateViewController(withIdentifier: "BaseTabBarCtr")

                    self.present(BaseTabBarCtr, animated: false, completion: nil)
                }
            })
        case 1:
            print("妊娠")
            let PregnancyVC = PregnancyViewController(nibName: "PregnancyViewController", bundle: Bundle.main)
            PregnancyVC.infoDataDic = self.infoDic
            self.navigationController?.pushViewController(PregnancyVC, animated: true)
        
        case 2...7:
            print("高危")

            print("确诊")
            let ConfirmedVC = ConfirmedViewController(nibName: "ConfirmedViewController", bundle: Bundle.main)
            //给下级的数据
            ConfirmedVC.infoDataDic = self.infoDic
            self.navigationController?.pushViewController(ConfirmedVC, animated: true)

        default:
            break
        }
    }
    
    
    
    func nextBtnAct(){
        print("下一步")
        
        var nextState:Bool = true
        
        for item in self.valueArray {
            
            if !(item.characters.count > 0) {
                nextState = false
                break
            }
        }
  
        
        if nextState == false {
            
            //初始化 preferredStyle （.Alert 为类型）
            let actionSheet = UIAlertController(title: "是否跳过填写个人信息", message: "完善您的个人信息有助于我们更好的为您服务", preferredStyle: UIAlertControllerStyle.alert)
            
            //确定
            actionSheet.addAction(UIAlertAction(title: "跳过", style: UIAlertActionStyle.destructive, handler: { (skip:UIAlertAction) in
                //回调
                
                self.goToNextVC()
                
            }))
            
          
            //取消
            actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            //因为这个是控制器，需要添加到视图
            self.present(actionSheet, animated: true, completion: nil)
            
        }else{ //填写完整
            
            self.goToNextVC()
        }
        
 
   
        
    }
    
    
    
    var nameArray = ["性别","生日","身高","体重","日常活动强度"]
    var valueArray = ["","","","",""]
    
    var placeholderArray = ["选择性别","选择出生日期","选择身高","选择体重","选择日常活动强度"]
    
    
    
    //Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.nameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ddd = "StageInfCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? StageInfTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("StageInfTableViewCell", owner: self, options: nil )?.last as? StageInfTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        cell?.nameLabel.text = "\(self.nameArray[(indexPath as NSIndexPath).row]):"
        
        let tmpValue = self.valueArray[(indexPath as NSIndexPath).row] 
        
        if tmpValue.characters.count > 0 {
            cell?.valueLabel.text = tmpValue
        }else{
            cell?.valueLabel.placeholder = self.placeholderArray[(indexPath as NSIndexPath).row]
        }

        //设置选中cell 时的颜色
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        return cell!
    }
    
    var sexView:SexView!
    var dateView:DateView!
    
    
    
    //MARK:选择的row
    var selectRow = 0
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name = self.nameArray[(indexPath as NSIndexPath).row]
        self.selectRow = (indexPath as NSIndexPath).row //记录选择的 cell
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            //print("性别")
            self.loadStagePickerView(name, dataArray: self.sexArray,uSecIndex: self.sexSecInt)
            
        case 1:
            //print("年龄")
            self.loadDateView(name)

        case 2:
            //print("身高")
            self.loadStagePickerView("\(name)cm", dataArray: self.heightArray,uSecIndex: self.heightSecInt)

        case 3:
            //print("体重")
            self.loadStagePickerView("\(name)kg", dataArray: self.weightArray,uSecIndex: self.weighSecInt)
        case 4:
            //print("日常活动强度")
            self.loadStagePickerView(name, dataArray: self.activityArray,uSecIndex: self.daySecInt)
        default:
            break
        }
        
        self.myTabView.reloadData()
    }

    
    var stagePickeView:StagePickerView!
    //加载 性别 体重 选择视图
    func loadStagePickerView(_ title:String,dataArray:NSMutableArray,uSecIndex:Int){

        self.loadSexBgView()
        
    
        if self.stagePickeView == nil {
            
            let tmpRect = UIScreen.main.bounds
            
            self.stagePickeView = Bundle.main.loadNibNamed("StagePickerView", owner: nil, options: nil)?.last as! StagePickerView
            self.stagePickeView.frame = CGRect(x: 0, y: tmpRect.height - 240 - 64, width: tmpRect.width, height: 240)
            //传值
            self.stagePickeView.titStr = title //标题
            
            self.stagePickeView.dataArray = dataArray //数据源
            
            self.stagePickeView.pickerDefaultIndex = uSecIndex //默认选择的第几个
            
            self.stagePickeView.dateClosure = self.dateClosure //回调方法
            
            
            self.view.addSubview(self.stagePickeView)
        }
        
        
    }
    
    
 
    
    
    //sexView背景视图
    var sexBgView:UIView!
    
    func loadSexBgView(){
        if self.sexBgView == nil {
            self.sexBgView = UIView(frame: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
            self.sexBgView.backgroundColor = UIColor.clear
            self.view.addSubview(self.sexBgView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(StageInfViewController.sexBgViewAct))
            self.sexBgView.addGestureRecognizer(tap)
  
        }
    }
    //关闭视图
    func sexBgViewAct(){
        
        if self.sexView != nil {
            self.sexView.removeFromSuperview()
            self.sexView = nil
        }
        if self.dateView != nil {
            self.dateView.removeFromSuperview()
            self.dateView = nil
        }
        if self.sexBgView != nil {
            self.sexBgView.removeFromSuperview()
            self.sexBgView = nil
        }
        
        if self.stagePickeView != nil {
            self.stagePickeView.removeFromSuperview()
            self.stagePickeView = nil
        }
        
    }
    
    
  
    func loadDateView(_ name:String){
        
        self.sexBgViewAct()
        
        self.loadSexBgView()

        self.dateView = Bundle.main.loadNibNamed("DateView", owner: nil, options: nil)?.first as! DateView
        self.dateView.frame = CGRect(x: 0, y: size.height - 220 * self.Hsize - 64, width: self.size.width, height: 220 * self.Hsize)
        self.dateView.nameLabel.text = name
        
        self.dateView.delegate = self
        
        self.view.addSubview(self.dateView)
        
        
    }
    //SexViewDelegate
    func selectValue(_ value: String) {
        print(value)
        
        switch self.selectRow {
        case 0:
            self.valueArray[0] = value
            
            if value == "男" {
                self.infoDic["sex"] = "1"
            }else{
                self.infoDic["sex"] = "0"
            }
  
        case 1:
            self.valueArray[1] = value
            self.infoDic["birth"] = value
        case 2:
            self.valueArray[2] = value
            self.infoDic["heigh"] = value
        case 3:
            self.valueArray[3] = value
            self.infoDic["weight"] = value
        case 4:
            self.valueArray[4] = value
            
            switch value {
            case "轻体力(办公室文员、司机等)":
                self.infoDic["worktype"] = "0"
            case "中体力(服务员、业务员等)":
                self.infoDic["worktype"] = "1"
            case "重体力(快递员、建筑工人等)":
                self.infoDic["worktype"] = "2"
            default:
                break
            }
            
            
            
            
        default:
            break
        }
        
        self.myTabView.reloadData()
        
        self.sexBgViewAct()
        
    }
    //DateViewDelegate
    func saveBtnAct(_ date: String) {
        self.selectValue(date)
        
        self.sexBgViewAct()
    }
    func closeDateView() {
        self.sexBgViewAct()
    }
    
    
    //picker记录选择项
    var sexSecInt = 0       //性别
    var heightSecInt = 50    //身高
    var weighSecInt = 35     //体重
    var daySecInt = 0       //日常活动强度
    
    //回调
    func dateClosure(_ tag:Int,secInt:Int,value:String)->Void{
        
        self.selectValue(value)
        switch self.selectRow {
        case 0:
            //性别
            self.sexSecInt = secInt
        case 2:
            //身高
            self.heightSecInt = secInt
        case 3:
            //体重
            self.weighSecInt = secInt
        case 4:
            //日常活动强度
            self.daySecInt = secInt
        default:
            break
        }
   
    }
    
    
    

}
