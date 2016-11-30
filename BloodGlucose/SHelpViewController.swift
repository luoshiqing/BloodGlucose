//
//  SHelpViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/13.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SHelpViewController: UIViewController ,UIScrollViewDelegate{

    
    var topView_height: CGFloat = 45.0
    
    var sHelpHeadView: SHelpHeadView!
    var myScrollView: UIScrollView!
    
    //1.使用须知
    let useInformationTitleArray = ["血糖监测说明","1、注册登录","2、完善资料","3、打开蓝牙","4、连接设备","5、初始化","6、极化","7、开始检测","8、事件记录","佩戴监测期间操作说明","1、完善用户信息及糖尿病史，便于更精准的分析病症。","2、输入参比血糖（空腹血糖），严重糖尿病患者建议每天输入一次。","3、监测期间可以随时在手机上查看血糖波动，监测完毕请将数据上传到云端，进行永久保存，以便日后查看或作为临床参考。"]
    
    let useInformationMainArray = ["","添加优医糖公众号，下载安卓或IOS版APP，注册账号。登录后即可获取到您的相关数据，更多资讯个性化定制，提供给您专属的糖尿病知识",
                                   "资料中填写的身高体重等信息将对后续报告起到重要作用",
                                   "因设备是通过蓝牙与APP进行连接，所以不要忘记打开蓝牙哦~~",
                                   "进入监测页面，扫描到要监测的监测设备，连接自己的设备编码",
                                   "初始化需要7分钟，7分钟内无需进行任何操作，只需等待设备进入极化。",
                                   "极化3分钟以后会出现第一个电流值，点击右上角观看电流值，如果电流值正常（电流值不低于10000），则无需特殊处理，极化是探针与人体反应的稳定时间，总时间为3小时，期间无需进行任何操作。",
                                   "可查看您的血糖变化曲线，可查看单日对比数据和多天数据；在报告中也可查看系统自动生成的和医生给出的专业指导建议",
                                   "根据您每天撰写的事件（饮食、运动、药物）专业医护人员可根据您的血糖变化曲线图和事件记录更精准的了解到您的日常生活习惯对血糖的影响，给出最适合您的治疗方案","","","",""]
    
    //2.注意事项
    let MattersNeedingAttentionMainrray = ["1、设备通过微针传感器植入皮下3mm处，不触及血管，不会出血，佩戴初期有轻微刺痛感和异物感，30分钟后逐渐消除，对人体无损伤",
                                           "2、探针属于一次性用品，禁止二次使用，造成感染。",
                                           "3、储存条件为0-8℃，使用前常温放置30分钟。",
                                           "4、佩戴一次事件周期为3-5天，因个体化差异，最长不超过7天。",
                                           "5、部分人群肤质对胶贴过敏，出现红痒现象，可以考虑停止佩戴，症状自行消除。",
                                           "6、佩戴期间避免剧烈运动，造成探针监测异常。",
                                           "7、佩戴期间可以洗澡，应避免水直接接触到设备，禁止游泳。",
                                           "8、佩戴完毕之后7个工作日，我们将为您出具一份详细的监测报告，以及饮食运动合理化建议。",
                                           "9、若您为体检用户，建议输入第二天早上的空腹血糖作为参比，输入一次即可。若为住院用户，则需每日输入。",
                                           "10、摘取设备前应将数据上传至云端，并等待提示数据上传完毕后即可摘取设备。",
                                           "11、如遇到血糖过低数据异常可查看电流值，若低于8000请及时联系我们客服。",
                                           "12、监测期间非人为故意损坏原因，导致设备异常或者脱落，可致电 4008-059-359 联系客服进行后续处理。",
                                           "备注：",
                                           "1、APP软件若出现连接失败等现象，请返回首页重新连接，数据储存在设备中，不必担心数据丢失。",
                                           "2、设备通过蓝牙与手机连接，为保证您手机运行速度，无需长期保持连接状态。"]
    
    
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "帮助说明"
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        self.setNav()
        
        //顶部
        self.setTopView()
        
        //设置我的scr
        self.setMyScr()
        
        
        //左边->使用须知
        self.loadLeftView()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        BaseTabBarView.isHidden = true

    }
    
    func setNav(){
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(SHelpViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
    }
    func someBtnAct(_ send: UIButton){
        switch send.tag {
        case 0:
            self.navigationController!.popViewController(animated: true)
        default:
            break
        }
    }
    
    func setMyScr(){
        
        let frame_width: CGFloat = UIScreen.main.bounds.width
        let frame_height: CGFloat = UIScreen.main.bounds.height - 64 - topView_height

        myScrollView = UIScrollView(frame: CGRect(x: 0,y: topView_height,width: frame_width,height: frame_height))
        
        myScrollView.backgroundColor = UIColor.white
        
        myScrollView.contentSize = CGSize(width: frame_width * 3, height: 0)
        
        
        myScrollView.delegate = self
        
        myScrollView.bounces = false
        
        myScrollView.isPagingEnabled = true
        
        myScrollView.showsVerticalScrollIndicator = false
        myScrollView.showsHorizontalScrollIndicator = false
        
        self.view.addSubview(myScrollView)
        
    }
    
    var letfView: SHelpLeftView!
    
    func loadLeftView(){
        let myScrollView_size = myScrollView.frame.size
        self.letfView = SHelpLeftView(frame: CGRect(x: 0,y: 0,width: myScrollView_size.width,height: myScrollView_size.height))
        self.letfView.backgroundColor = UIColor.white
        
        self.letfView.useInformationTitleArray = self.useInformationTitleArray
        self.letfView.useInformationMainArray = self.useInformationMainArray
        
        
        self.myScrollView.addSubview(self.letfView)
        
    }
    
    
    func setTopView(){
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: self.topView_height)
        self.sHelpHeadView = SHelpHeadView(frame: rect)
        
        let items = ["使用须知","注意事项","功能说明"]
        
        self.sHelpHeadView.items = items
        
        self.sHelpHeadView.viewActClourse = self.SHelpHeadViewViewActClourse
        
        self.sHelpHeadView.backgroundColor = UIColor.white
        self.view.addSubview(self.sHelpHeadView)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var rightView: SHelpRightView!

    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        
        let offset_x = scrollView.contentOffset.x
//        print(offset_x)
        
//        if offset_x > 0 {
//            self.loadRightView()
//        }
        
        switch offset_x {
        case 0..<UIScreen.main.bounds.width:
            self.loadRightView()
        case UIScreen.main.bounds.width...UIScreen.main.bounds.width * 2:
            self.loadRightView()
            self.loadFunctionalSpecificationsView()
        default:
            break
        }
        
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let offset_x = scrollView.contentOffset.x

   
        
        switch offset_x {
        case 0:
            self.sHelpHeadView.setItemColorAndFrame(0)
        case UIScreen.main.bounds.width:
            self.sHelpHeadView.setItemColorAndFrame(1)
        case UIScreen.main.bounds.width * 2:
            self.sHelpHeadView.setItemColorAndFrame(2)
        default:
            break
        }
        
        
    }
    
    func loadRightView(){
        
        if self.rightView == nil {
            
            let myScrollView_size = myScrollView.frame.size
            self.rightView = SHelpRightView(frame: CGRect(x: myScrollView_size.width,y: 0,width: myScrollView_size.width,height: myScrollView_size.height))
            self.rightView.backgroundColor = UIColor.white
            

            self.rightView.MattersNeedingAttentionMainrray = self.MattersNeedingAttentionMainrray

            self.myScrollView.addSubview(self.rightView)
        }
        
        
    }
    
    //MARK:头部回调
    func SHelpHeadViewViewActClourse(_ send: UIView)->Void{
        
        let tag = send.tag
        
        switch tag {
        case 0:
            
            UIView.beginAnimations(nil, context: nil)
            
            UIView.setAnimationDuration(0.3)
            
            self.myScrollView.contentOffset.x = 0
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            UIView.commitAnimations()
            
        case 1:
            UIView.beginAnimations(nil, context: nil)
            
            UIView.setAnimationDuration(0.3)
            
            self.myScrollView.contentOffset.x = UIScreen.main.bounds.width
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            UIView.commitAnimations()
            
        case 2:
            UIView.beginAnimations(nil, context: nil)
            
            UIView.setAnimationDuration(0.3)
            
            self.myScrollView.contentOffset.x = UIScreen.main.bounds.width * 2
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            UIView.commitAnimations()
            
        default:
            break
        }
        
        
        
    }
    
    var functionalView: FunctionalView!
    func loadFunctionalSpecificationsView(){
        
        if self.functionalView == nil {
            let myScrollView_size = myScrollView.frame.size
            
            self.functionalView = FunctionalView(frame: CGRect(x: myScrollView_size.width * 2,y: 0,width: myScrollView_size.width,height: myScrollView_size.height))
            self.functionalView.backgroundColor = UIColor.yellow
            
            
            self.myScrollView.addSubview(self.functionalView)
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
