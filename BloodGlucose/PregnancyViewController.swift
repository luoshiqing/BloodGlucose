//
//  PregnancyViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/18.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class PregnancyViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,DateViewDelegate{
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBOutlet weak var preTabView: UITableView!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var skipBtn: UIButton!
    
    
    @IBOutlet weak var lineH: NSLayoutConstraint!
    
    
    
    
    
    
    
    //接受上级的数据
    var infoDataDic = [String:String]()
    
    var weightArray = NSMutableArray()
    var mothArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "妊娠糖尿病人群"
        //设置导航栏
        self.setNav()
        
        //加载数据
        self.loadData()
        
        //设置按钮
        self.setBtn()
        
        
        self.lineH.constant = 0.5
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isLogOutIn {
            self.navigationController!.popToRootViewController(animated: false)
        }
    }
    
    
    func setBtn(){
        self.nextBtn.addTarget(self, action: #selector(PregnancyViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.nextBtn.tag = 100
        
        self.skipBtn.addTarget(self, action: #selector(PregnancyViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.skipBtn.tag = 101
        
        //设置 圆角
        self.skipBtn.layer.cornerRadius = 4
        self.skipBtn.clipsToBounds = true
        //边框
        self.skipBtn.layer.borderWidth = 1
        self.skipBtn.layer.borderColor = UIColor.orange.cgColor
        
    }
    func btnAct(_ send:UIButton){
        switch send.tag {
        case 100:
            print("下一步")
            var nextState:Bool = true
            //如果有一项没有填写 就提示
            for item in self.valueArray {
                if !(item.characters.count > 0) {
                    nextState = false
                    break
                }
            }
            
            if nextState == false { //信息填写不完整
                
                let actionSheet = UIAlertController(title: "是否跳过填写个人信息", message: "完善您的个人信息有助于我们更好的为您服务", preferredStyle: UIAlertControllerStyle.alert)
                
                actionSheet.addAction(UIAlertAction(title: "跳过", style: UIAlertActionStyle.destructive, handler: { (skip:UIAlertAction) in
                    
                    
                    self.goToNextVC()
                    
                }))
                
                actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
                
            }else{ //信息填写完整
                self.goToNextVC()
            }

        case 101:
            print("忘记，跳过")
            self.goToNextVC()
        default:
            break
        }
    }
    
    func goToNextVC(){

        MyNetworkRequest().addUserInfoJsp(self.view,dataDic: self.infoDataDic, clourse: { (success) in
            if success {
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let BaseTabBarCtr = storyBoard.instantiateViewController(withIdentifier: "BaseTabBarCtr")
                
                
                self.present(BaseTabBarCtr, animated: false, completion: nil)
            }
        })
 
        
    }
    
    
    
    func loadData(){
        for item in 35...150 {
            self.weightArray.add("\(item)")
        }
        for moth in 1...10 {
            self.mothArray.add("\(moth)")
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNav(){
        
        
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(PregnancyViewController.backAct), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        

    }
    func backAct(){
        self.navigationController!.popViewController(animated: true)
    }
    
    
    var nameArray = ["末次月经日期","孕前体重","孕几月出现血糖异常"]
    var valueArray = ["","",""]
    
    //Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.nameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ddd = "PregCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? PregnancyTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("PregnancyTableViewCell", owner: self, options: nil )?.last as? PregnancyTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        cell?.nameLabel.text = "\(self.nameArray[(indexPath as NSIndexPath).row]):"
        cell?.valueLabel.text = self.valueArray[(indexPath as NSIndexPath).row]
        //设置选中cell 时的颜色
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        return cell!
    }
    
    var selectType = 0
    //cell
    var PregnancyCell:PregnancyTableViewCell!
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name = self.nameArray[(indexPath as NSIndexPath).row]
        print(name)
        switch (indexPath as NSIndexPath).row {
        case 0:
            //print("日期")
            self.loadDateView(name)
        case 1:
            //print("体重")
            self.loadStagePickerView("\(name)kg", dataArray: self.weightArray, uSecIndex: self.weightSecInt)
        case 2:
            //print("孕几月出现血糖异常")
            self.loadStagePickerView(name, dataArray: self.mothArray, uSecIndex: self.mothSecInt)
        default:
            break
        }
        self.selectType = (indexPath as NSIndexPath).row
        self.PregnancyCell = tableView.cellForRow(at: indexPath) as! PregnancyTableViewCell
        
    }
    
    
    
    
    
    //picker记录选择项
    var mothSecInt = 0       //性别
    var weightSecInt = 20    //身高
    
    
    var stagePickeView:StagePickerView!
    //加载 性别 体重 选择视图
    func loadStagePickerView(_ title:String,dataArray:NSMutableArray,uSecIndex:Int){
        
        self.loadSexGgView()
        
        
        if self.stagePickeView == nil {
            
            let tmpRect = UIScreen.main.bounds
            
            self.stagePickeView = Bundle.main.loadNibNamed("StagePickerView", owner: nil, options: nil)?.last as! StagePickerView
            self.stagePickeView.frame = CGRect(x: 0, y: tmpRect.height - 240 - 64, width: tmpRect.width, height: 240)
            //传值
            self.stagePickeView.titStr = title
            self.stagePickeView.dataArray = dataArray
            
            self.stagePickeView.pickerDefaultIndex = uSecIndex
            
            self.stagePickeView.dateClosure = self.dateClosure
            
            
            self.view.addSubview(self.stagePickeView)
        }
        
        
    }
    
    //回调
    func dateClosure(_ tag:Int,secInt:Int,value:String)->Void{
        print("回调结果，\(tag),\(secInt),\(value)")
        
        self.selectValue(value)
        
        switch self.selectType {
        case 1:
            //print("身高")
            self.weightSecInt = secInt
        case 2:
            //print("孕几月")
            self.mothSecInt = secInt
        default:
            break
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    var size = UIScreen.main.bounds
    var Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)

    
    var sexGgView:UIView!
    
    
    func loadSexGgView(){
        self.sexGgView = UIView(frame: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        self.sexGgView.backgroundColor = UIColor.clear
        
        self.view.addSubview(self.sexGgView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PregnancyViewController.clearView))
        self.sexGgView.addGestureRecognizer(tap)
    }
    
  
    
    var dateView:DateView!
    //加载日期选择视图
    func loadDateView(_ name:String){
        
        self.clearView()
        self.loadSexGgView()
        
        self.dateView = Bundle.main.loadNibNamed("DateView", owner: nil, options: nil)?.first as! DateView
        self.dateView.frame = CGRect(x: 0, y: size.height - 220 * self.Hsize - 64, width: self.size.width, height: 220 * self.Hsize)
        self.dateView.nameLabel.text = name
        
        self.dateView.delegate = self
        
        self.view.addSubview(self.dateView)
    }
 
    //------------------代理--------------------->>>>>>>>
    func selectValue(_ value: String) {
        print(value)
        switch self.selectType {
        case 0:
            self.valueArray[0] = value
            
            self.infoDataDic["lastmentrua"] = value
            
        case 1:
            self.valueArray[1] = value
            
            self.infoDataDic["fetationweight"] = value
            
        case 2:
            self.valueArray[2] = value
            
            self.infoDataDic["happenexce"] = value
            
        default:
            break
        }
        
        self.PregnancyCell.valueLabel.text = value
        
        self.clearView()
    }
    
    func saveBtnAct(_ date:String){
        
        self.selectValue(date)
    }
    func closeDateView() {
        self.clearView()
    }
    //------------------代理---------------------<<<<<<<<
    func clearView(){

        if self.sexGgView != nil {
            self.sexGgView.removeFromSuperview()
            self.sexGgView = nil
        }
        
        if self.dateView != nil {
            self.dateView.removeFromSuperview()
            self.dateView = nil
        }
        
        if self.stagePickeView != nil {
            self.stagePickeView.removeFromSuperview()
            self.stagePickeView = nil
        }
        
        
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
