//
//  ConfirmedViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/18.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class ConfirmedViewController: UIViewController{
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBOutlet weak var fristYesBtn: UIButton!
    @IBOutlet weak var fristNoBtn: UIButton!
    
    
    @IBOutlet weak var secView: UIView!
    @IBOutlet weak var secLabel: UILabel!
    
    @IBOutlet weak var threeYesBtn: UIButton!
    @IBOutlet weak var threeNoBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    
    
    @IBOutlet weak var line1H: NSLayoutConstraint!
    
    
    @IBOutlet weak var line2H: NSLayoutConstraint!
    
    
    @IBOutlet weak var line3H: NSLayoutConstraint!
    
    
    @IBOutlet weak var line4H: NSLayoutConstraint!
    
    
    
    
    
    //接受上级的数据
    var infoDataDic = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "确诊人群"
        
        //设置导航返回
        self.setNav()
        
        //设置按钮点击
        self.setBtn()
        //设置视图点击
        self.setView()
  
        line1H.constant = 0.5
        line2H.constant = 0.5
        line3H.constant = 0.5
        line4H.constant = 0.5
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if isLogOutIn {
            self.navigationController!.popToRootViewController(animated: false)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setNav(){
        
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(ConfirmedViewController.backAct), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
 
    }
    func backAct(){
        self.navigationController!.popViewController(animated: true)
    }
    
    func setView(){
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(ConfirmedViewController.tapAct))
        self.secView.addGestureRecognizer(tap1)

        
    }
    
    
    var complicatGgView:UIView!
    
    func tapAct(){
        //print("并发症")
    
        self.loadComplicationsView("选择您的状态", dataArray: self.stateArray, uSecIndex: self.staSecInt)
        
    }
    
    //加载并发症背景视图
    func loadComplicatGgView(){
        
        let size = UIScreen.main.bounds
        
        if self.complicatGgView == nil{
            self.complicatGgView = UIView(frame: CGRect(x: 0,y: 0,width: size.width,height: size.height))
            self.complicatGgView.backgroundColor = UIColor.clear
            self.view.addSubview(self.complicatGgView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ConfirmedViewController.complicatGgViewAct))
            self.complicatGgView.addGestureRecognizer(tap)
            
        }
    }
    
    var staSecInt = 0
    var stagePickeView:StagePickerView!
    var stateArray:NSMutableArray = ["无并发症","心脑血管病变(脑卒中、冠心病)","肾病","眼底病变","糖尿病足"]
    
    //并发症视图
    func loadComplicationsView(_ title:String,dataArray:NSMutableArray,uSecIndex:Int){
        
        self.loadComplicatGgView()
        
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
        print("回调：\(tag),\(secInt),\(value)")
        
        if tag != 0 {
            self.valueArray[1] = value
            
            self.infoDataDic["complica"] = "\(secInt)"
            
            self.staSecInt = secInt
            
            self.secLabel.text = value
        }
        
        
        self.complicatGgViewAct()
        
        
    }
    
    
    func complicatGgViewAct(){
        
        if self.complicatGgView != nil {
            self.complicatGgView.removeFromSuperview()
            self.complicatGgView = nil
        }
        if self.stagePickeView != nil {
            self.stagePickeView.removeFromSuperview()
            self.stagePickeView = nil
        }
        
        
    }
    
    
    func setBtn(){
        //1.
        self.fristYesBtn.addTarget(self, action: #selector(ConfirmedViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.fristYesBtn.tag = 10
        self.fristNoBtn.addTarget(self, action: #selector(ConfirmedViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.fristNoBtn.tag = 11
        //3.
        self.threeYesBtn.addTarget(self, action: #selector(ConfirmedViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.threeYesBtn.tag = 20
        self.threeNoBtn.addTarget(self, action: #selector(ConfirmedViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.threeNoBtn.tag = 21
        //4.next
        self.nextBtn.addTarget(self, action: #selector(ConfirmedViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.nextBtn.tag = 30
        //5.跳过
        self.skipBtn.addTarget(self, action: #selector(ConfirmedViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.skipBtn.tag = 31
        
        //设置 圆角
        self.skipBtn.layer.cornerRadius = 4
        self.skipBtn.clipsToBounds = true
        //边框
        self.skipBtn.layer.borderWidth = 1
        self.skipBtn.layer.borderColor = UIColor.orange.cgColor
        
    }
    //            Rectangle41.png
    //            group3.png
    var valueArray = ["","",""]
    
    func btnAct(_ send:UIButton){
        switch send.tag {
        case 10:
            print("高血压")
            self.valueArray[0] = "1"
            
            self.infoDataDic["ehhc"] = "1"
            
            self.fristYesBtn.setImage(UIImage(named: "group3.png"), for: UIControlState())
            self.fristNoBtn.setImage(UIImage(named: "Rectangle41.png"), for: UIControlState())
        case 11:
            print("高血压")
            self.valueArray[0] = "0"
            
            self.infoDataDic["ehhc"] = "0"
            
            self.fristYesBtn.setImage(UIImage(named: "Rectangle41.png"), for: UIControlState())
            self.fristNoBtn.setImage(UIImage(named: "group3.png"), for: UIControlState())
        case 20:
            print("吸烟")
            self.valueArray[2] = "1"
            
            self.infoDataDic["smoke"] = "1"
            
            self.threeYesBtn.setImage(UIImage(named: "group3.png"), for: UIControlState())
            self.threeNoBtn.setImage(UIImage(named: "Rectangle41.png"), for: UIControlState())
        case 21:
            print("不吸烟")
            self.valueArray[2] = "0"
            
            self.infoDataDic["smoke"] = "0"
            
            self.threeYesBtn.setImage(UIImage(named: "Rectangle41.png"), for: UIControlState())
            self.threeNoBtn.setImage(UIImage(named: "group3.png"), for: UIControlState())
        case 30:
            print("下一步")
            var nextState:Bool = true
            //如果有一项没有填写 就提示
            for item in self.valueArray {
                
                print(item)
                
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

        case 31:
            print("跳过")
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
    
    
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
