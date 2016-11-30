//
//  CentViewController.swift
//  LeftSSS
//
//  Created by sqluo on 16/7/7.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit


var isOneCtrPush = false





class CentViewController: UIViewController ,LeftSlideViewDelegate {

 
    //左侧控制器
    var leftCtr: UIViewController!
 
    
    let Wsize = UIScreen.main.bounds.size.width
    let Hsize = UIScreen.main.bounds.size.height
    
    
    var centView: CentView!
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LeftSlideVC.delegate = self

        self.view.backgroundColor = UIColor.white

        
        self.setNav()
        
        
        self.loadCentView()
        
        
        self.topNavView()
        
    }
    
    
    var myNavView: UIView!
    
    var backColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
    
    var imgView: UIImageView! //头像
    
    var redPointView: UIView? //红点
    
    
    //MARK:顶部导航模拟视图
    func topNavView(){
        
        if self.myNavView != nil {
            self.myNavView.removeFromSuperview()
            self.myNavView = nil
        }
        
        self.myNavView = UIView(frame: CGRect(x: 0,y: 0,width: Wsize,height: 64))
        
        self.myNavView.backgroundColor = backColor.withAlphaComponent(0)
        
        self.view.addSubview(self.myNavView)
        
        self.myNavView.bringSubview(toFront: self.centView)
        
        let label = UILabel(frame: CGRect(x: (Wsize - 40) / 2,y: 20 + (44 - 17) / 2,width: 40,height: 17))
        label.text = "主 页"
        label.textAlignment = .center
        label.textColor = UIColor.white
        self.myNavView.addSubview(label)
        
        
        imgView = UIImageView(frame: CGRect(x: 15, y: 20 + (44 - 38) / 2, width: 38, height: 38))
        
        
        if iconurl != nil {
            imgView.sd_setImage(with: URL(string: iconurl), placeholderImage: UIImage(named: "homeicon"))
        }else{
            imgView.image = UIImage(named: "homeicon")
        }

        imgView.layer.cornerRadius = 38 / 2.0
        imgView.layer.masksToBounds = true
        
        imgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(CentViewController.openOrCloseLeftList))
        imgView.addGestureRecognizer(tap)
        
        
        self.myNavView.addSubview(imgView)
        
        
        
        if datamuch != nil {
            let tmpDatamuch = (datamuch as NSString).replacingOccurrences(of: "%", with: "")

            if Float(tmpDatamuch)! <= 50 {
                //红点
                let redW: CGFloat = 6
                redPointView = UIView(frame: CGRect(x: 38 - redW - 5,y: 5,width: redW,height: redW))
                redPointView?.backgroundColor = UIColor.red
                
                redPointView?.layer.cornerRadius = redW / 2
                
                redPointView?.layer.masksToBounds = true
                
                imgView.addSubview(redPointView!)
            }else{
                
                redPointView?.removeFromSuperview()
                redPointView = nil
                
            }
  
        }
  
        
    }
    
 
    
    //MARK:left代理
    func openCompeleteAnimation() {
        //加载完了，开始动画

        if iconurl != nil {
            
            (leftCtr as! LeftViewController).headerContentView.compeletSetValue(iconurl, name: nickname, progress: datamuch != nil ? datamuch : "0%",isUrl: true)
            
        }else{
            (leftCtr as! LeftViewController).headerContentView.compeletSetValue("lefticon", name: nickname, progress: datamuch != nil ? datamuch : "0%",isUrl: false)
        }
        
        (leftCtr as! LeftViewController).reloadIndexPath()
        
        self.imgView.isHidden = true
   
    }
    func closeCompeleteAnimation() {
        //关闭了，重置
        (leftCtr as! LeftViewController).headerContentView.restValue()
 
        
        self.imgView.isHidden = false
    }
    
    func CentViewScrollViewClourse(_ offset_Y: CGFloat)->Void{
        
        let alpha: CGFloat = offset_Y / 64
        
        
        self.myNavView.backgroundColor = self.backColor.withAlphaComponent(alpha)

        
    }
    
    
    
    
    func loadCentView(){
        
        if centView == nil {
            centView = CentView(frame: CGRect(x: 0,y: 0,width: Wsize,height: Hsize))
            centView.WJHomeCtr = self
            centView.backgroundColor = UIColor.white
            
            centView.scrollViewClourse = self.CentViewScrollViewClourse
            
            self.view.addSubview(centView)
        }else{
            centView.removeFromSuperview()
            centView = nil
            
            centView = CentView(frame: CGRect(x: 0,y: 0,width: Wsize,height: Hsize))
            centView.WJHomeCtr = self
            centView.backgroundColor = UIColor.white
            
            centView.scrollViewClourse = self.CentViewScrollViewClourse
            
            self.view.addSubview(centView)
        }
        
        
        
    }
    
    
    
 
    
    var isFirst = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.restNav()
        
        
        BaseTabBarView.isHidden = false
        CAGradientLayerEXT().animation(true)
        
        LeftSlideVC.setPanEnabled(true)
        
        
        
        self.loadCentView()
        
        self.topNavView()

        
        if self.MessageTimme == nil {

            self.MessageTimme = Timer.scheduledTimer(timeInterval: 10 * 60, target: self, selector: #selector(self.getMessageData), userInfo: nil, repeats: true)
            
            self.MessageTimme.fire()
        }
        
    }
    
    var MessageTimme:Timer!
    
    
    
    func getMessageData(){
        
        print("定时器调用一次,获取消息")
        
        MyNetworkRequest().getMessageData(self.view) { (size) in
            //消息数量 size
            (BaseTabBarCtr as? BaseTabBarViewController)?.setMyAngleLabel(size)
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.restNav()
        
//        if !isOneCtrPush {
//            isOneCtrPush = false
        self.loadCentView()
        self.topNavView()
//        }
        
        if ((self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer))) != nil) {
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        }
        
        
        //注册每日7点提醒通知
        
        LocalNotificationUtils().addAtSevenClockNotification()
  
    }
   
    
    override func viewWillDisappear(_ animated: Bool) {
        
        LeftSlideVC.setPanEnabled(false)

        self.navigationController?.navigationBar.isHidden = false
        
    }
    
 
    
    //设置导航栏
    var leftImg:UIImageView!
    
    func setNav(){
        
        self.restNav()

    }
    
    func openOrCloseLeftList(){
        
        if LeftSlideVC != nil {
            
            
            if LeftSlideVC.closed {
                LeftSlideVC.openLeftView()
 
            }else{
                LeftSlideVC.closeLeftView()

            }
  
            
        }
        
        
        
    }
    
    
    let kScreenWidth = UIScreen.main.bounds.size.width
    let kScreenHeight = UIScreen.main.bounds.size.height
    let kMainPageScale: CGFloat = 0.8
    let kMainPageDistance: CGFloat = 100
    
    
    
    func openTabBar(){
        
        UIView.beginAnimations(nil, context: nil)
        
        let hhhh = (kScreenHeight * 0.8 + 0.1 * kScreenHeight) + (63 * 0.2)
        
        let kMainPageCenter = CGPoint(x: kScreenWidth + kScreenWidth * kMainPageScale / 2.0 - kMainPageDistance, y: hhhh)

        
        
        BaseTabBarView.transform = CGAffineTransform.identity.scaledBy(x: kMainPageScale, y: kMainPageScale)
 
        BaseTabBarView.center = kMainPageCenter
        
        UIView.commitAnimations()
        
   
    }
    
    func closeTabBar(){
        BaseTabBarView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)

        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func restNav(){
        
        self.navigationController?.navigationBar.isHidden = true
        
 
    }

    
    func LeftClourse(_ logOut: Bool)->Void{
        
        
        let alrtView = UIAlertController(title: "真的要注销吗?", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alrtView.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: { (action:UIAlertAction) -> Void in
            
            //清楚账号密码，并返回登录界面
//            NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
//            NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
            
//            LeftSlideVC.closeLeftView()
            
            if self.MessageTimme != nil{
                self.MessageTimme.invalidate()
                self.MessageTimme = nil
            }
  
            
            isLogOutIn = true
            
            
            if iconurl != nil{
                iconurl = nil
            }
            
            
            LeftSlideVC.logOut()
   

        }))
        alrtView.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alrtView, animated: true, completion: nil)
        
 
        
    }
    
    
    
    
  

}
