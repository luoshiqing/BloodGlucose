//
//  BaseTabBarViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/27.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit


var BaseTabBarView:UIView!

var LeftSlideVC:LeftSlideViewController!

var BaseTabBarCtr: UITabBarController?

class BaseTabBarViewController: UITabBarController {

    deinit{
        print("tabBar释放")
    }
    
    
    
    //接受上级的数据
//    var infoDataDic = [String:String]()
//    var isStage:Bool = true
    
    //角标
    var angleLabel: UILabel?
    
    fileprivate let angleWidth: CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        BaseTabBarCtr = self
        
        
        //隐藏系统tabBarItem
        self.tabBar.isHidden = true

        //自定义tabbar
        self.customTabBar()
        
        self.loadViewController()
        
        
        self.getActImgView()
        
        self.setFlashingBlueImgView()
        
        
    }

 
    
    var ACTIMGVIEW:UIImageView?
    
    //获取开始监测的图片
    func getActImgView(){
        
        for index in 0..<self.imgViewArray.count{
            if index == 2 {
                self.ACTIMGVIEW = self.imgViewArray[index]            }
        }
    }
    
    
    
    
    
    var tabBarBgView:UIView!
    
    //初始的img数组
    var initImgArray = ["homeL","reportA","baseAct","messageA","shopA"]
    //未选择图片数组
    var notChooseImgArray = ["homeA","reportA","baseAct","messageA","shopA"]
    //选择图片数组
    var chooseImgArray = ["homeL","reportL","baseAct","messageL","shopL"]
    
    
    //标题数据
    var nameArray = ["主页","报告","","消息","商城"]
    
    //初始的label颜色
    var initNameClolr:[UIColor] = [UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1),
                                   UIColor(red: 181/255.0, green: 68/255.0, blue: 24/255.0, alpha: 1),
                                   UIColor.clear,
                                   UIColor(red: 181/255.0, green: 68/255.0, blue: 24/255.0, alpha: 1),
                                   UIColor(red: 181/255.0, green: 68/255.0, blue: 24/255.0, alpha: 1)]
    //未选择标题颜色
    var notChooseNameColor = UIColor(red: 181/255.0, green: 68/255.0, blue: 24/255.0, alpha: 1)
    //选择标题颜色
    var chooseNameClolr = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
    
    
    //图片数组
    var imgViewArray = [UIImageView]()
    //标题数组
    var nameLabelArray = [UILabel]()
    
    
//    let Wsize = UIScreen.mainScreen().bounds.width / 375
    
    //自定义tabBar
    
    fileprivate var actView: UIView!
    
    let baseHeight: CGFloat = 60
    
    func customTabBar(){
        
        let height = UIScreen.main.bounds.size.height
        let width = UIScreen.main.bounds.size.width
        
        
        
        
        let tabW = width
        let tabH = height - baseHeight
        
        self.tabBarBgView = UIView(frame: CGRect(x: 0,y: tabH,width: tabW,height: baseHeight))
//        self.tabBarBgView.backgroundColor = UIColor(red: 255/255.0, green: 248/255.0, blue: 245/255.0, alpha: 1)
        self.tabBarBgView.backgroundColor = UIColor.clear
        self.view.addSubview(self.tabBarBgView)
        
        
        print(self.tabBarBgView.frame)
        
        BaseTabBarView = self.tabBarBgView
        
        let bgImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: tabW, height: baseHeight))
        bgImgView.image = UIImage(named: "bgbgbg")
        
        self.tabBarBgView.addSubview(bgImgView)
        
        
        
        //背景视图属性
        let bgCGSize = self.tabBarBgView.frame.size
        
        //中间开始监测frame
//        let actframe = CGRectMake((bgCGSize.width - 52 * Wsize) / 2, (bgCGSize.height - 52 * Wsize) / 2, 52 * Wsize, 52 * Wsize)
        let actframe = CGRect(x: (bgCGSize.width - 50) / 2, y: (bgCGSize.height - 50 ) / 2, width: 50, height: 50)
        //其他视图的 宽度
        let someWidth = (bgCGSize.width - actframe.width) / 4
        

        for index in 0..<self.initImgArray.count {
            
            var tmpActViewFrame:CGRect!
            
            switch index {
            case 0...1:
                tmpActViewFrame = CGRect(x: CGFloat(index) * someWidth, y: bgCGSize.height - 49, width: someWidth, height: 49)
            case 2:
                tmpActViewFrame = actframe
            default:
                tmpActViewFrame = CGRect(x: CGFloat(index - 1) * someWidth + actframe.width, y: bgCGSize.height - 49, width: someWidth, height: 49)
            }

            actView = UIView(frame: tmpActViewFrame)
            actView.backgroundColor = UIColor.clear
            actView.tag = index
            self.tabBarBgView.addSubview(actView)
            

            //添加手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(BaseTabBarViewController.actViewTapAct(_:)))
            actView.addGestureRecognizer(tap)

            
            
            //添加 图片 跟文字
            var tmpWidth:CGFloat!
            var tmpHeigth:CGFloat!
            
            var tmpTotop:CGFloat!
            

            
            switch index {
            case 0:
                tmpWidth = 38/2.0
                tmpHeigth = 37/2.0
                tmpTotop = 10
            case 1:
                tmpWidth = 32/2.0
                tmpHeigth = 39/2.0
                tmpTotop = 10
            case 2:
                tmpWidth = actframe.width
                tmpHeigth = actframe.height
                tmpTotop = 0
            case 3:
                tmpWidth = 42/2.0
                tmpHeigth = 35/2.0
                tmpTotop = 10
            case 4:
                tmpWidth = 35/2.0
                tmpHeigth = 35/2.0
                tmpTotop = 10.5
            default:
                break
            }
            
            //4.1图片
            let manyframe = CGRect(x: (tmpActViewFrame.width - tmpWidth) / 2, y: tmpTotop, width: tmpWidth, height: tmpHeigth)
            
            let manyImgView = UIImageView(frame: manyframe)
            manyImgView.image = UIImage(named: "\(initImgArray[index])")
            
            actView.addSubview(manyImgView)
            
            //添加到数组
            self.imgViewArray.append(manyImgView)
            
            //4.2标题
            let nameFrame = CGRect(x: (tmpActViewFrame.width - 42) / 2, y: tmpActViewFrame.height - 12 - 4, width: 42, height: 12)
            let nameLabel = UILabel(frame: nameFrame)
            actView.addSubview(nameLabel)
            
            nameLabel.font = UIFont(name: PF_SC, size: 11)
            nameLabel.text = "\(self.nameArray[index])"
            nameLabel.textColor = self.initNameClolr[index]
            nameLabel.textAlignment = .center
            
            if index == 3 {
                //角标
                
                angleLabel = UILabel(frame: CGRect(x: (actView.frame.size.width - angleWidth) / 2 + 12,y: 4,width: angleWidth,height: angleWidth))
                angleLabel?.backgroundColor = UIColor.red
                angleLabel?.alpha = 0.8
                angleLabel?.text = "95"
                angleLabel?.textColor = UIColor.white
                angleLabel?.font = UIFont.systemFont(ofSize: 10)
                
                angleLabel?.textAlignment = .center
                
                angleLabel?.layer.cornerRadius = angleWidth / 2
                angleLabel?.layer.masksToBounds = true
                
                actView.addSubview(angleLabel!)
                
                
                self.setMyAngleLabel(0)
            }

            
            
            //添加到数组
            self.nameLabelArray.append(nameLabel)
        }
        
        
        
    }
    //点击事件
    func actViewTapAct(_ send:UITapGestureRecognizer){
        
        let selectTag = send.view!.tag
        
//        print(selectTag)
        
        for index in 0..<self.imgViewArray.count {
            //图片
            let imgView = self.imgViewArray[index]
            //标题
            let nameLabel = self.nameLabelArray[index]
            
            
            if selectTag == index {
                
                if selectTag != 2 {
                    imgView.image = UIImage(named: "\(self.chooseImgArray[index])")
                    nameLabel.textColor = self.chooseNameClolr
                }
                
            }else{
                imgView.image = UIImage(named: "\(self.notChooseImgArray[index])")
                nameLabel.textColor = self.notChooseNameColor
            }
            
        }
        
        
        //跳转页面
        self.selectedIndex = send.view!.tag
        
        
        
        
        
    }
    
    
    //加载子视图控制器
    func loadViewController(){
        //首页

        let centVC = CentViewController()
        
//        centVC.infoDataDic = self.infoDataDic
//        centVC.isStage = self.isStage
        
        let mainNavigationController = UINavigationController(rootViewController: centVC)
        
        mainNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]

        
        mainNavigationController.navigationBar.isTranslucent = true
        mainNavigationController.navigationBar.backgroundColor = UIColor.clear
        mainNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        mainNavigationController.navigationBar.shadowImage = UIImage()
        
        
        let leftVC = LeftViewController()
        
        leftVC.WJHomeCtr = centVC
        leftVC.leftClourse = centVC.LeftClourse

        LeftSlideVC = LeftSlideViewController(leftView: leftVC, andMainView: mainNavigationController, andTabBar: BaseTabBarView)
        
        let homeItem = UITabBarItem(tabBarSystemItem: .favorites,tag:0)
        LeftSlideVC.tabBarItem = homeItem
        
        //-----
        centVC.leftCtr = leftVC
        //-----

        
        //报告
        let reportVC = URepViewController()
        let reportItem = UITabBarItem(tabBarSystemItem: .favorites,tag:1)
        reportVC.tabBarItem = reportItem
        let reportNav = UINavigationController(rootViewController:reportVC)
        reportNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        reportNav.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        
        //监测
        let tmpSbmgVC = TMPSBMGViewController()
        let sbmgItem = UITabBarItem(tabBarSystemItem: .favorites,tag:2)
        tmpSbmgVC.tabBarItem = sbmgItem
        let sbmgNav = UINavigationController(rootViewController: tmpSbmgVC)
        
        sbmgNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        sbmgNav.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        
        //消息
        let messageVC = MessageViewController()
        let messageItem = UITabBarItem(tabBarSystemItem: .favorites,tag:3)
        messageVC.tabBarItem = messageItem
        let messageNav = UINavigationController(rootViewController: messageVC)
        messageNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        messageNav.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        
        //商城
        let shopVC = ShopBaseViewController()
        let shopItem = UITabBarItem(tabBarSystemItem: .favorites,tag:4)
        shopVC.tabBarItem = shopItem
        let shopNav = UINavigationController(rootViewController: shopVC)
        shopNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        shopNav.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        //数组
        let ctrls: [UIViewController] = [LeftSlideVC,reportNav,sbmgNav,messageNav,shopNav]
//        let ctrls = [homeNav,reportNav,sbmgNav,messageNav,shopNav]
        //添加
        self.setViewControllers(ctrls,animated:true)
    }
    
    
    
    
    
    
    var isShow:Bool = true
    
    //设置闪烁的蓝牙图标
    func setFlashingBlueImgView(){
        
        UIView.animate(withDuration: 1, delay: 0.1, options: UIViewAnimationOptions(), animations: {
            
            if self.isShow == true {
                self.ACTIMGVIEW!.alpha = 0.6
                self.ACTIMGVIEW!.transform = CGAffineTransform(scaleX: 0.99,y: 0.99)
                
                self.isShow = false
            }else{
                self.ACTIMGVIEW!.alpha = 1
                self.ACTIMGVIEW!.transform = CGAffineTransform(scaleX: 1,y: 1)
                self.isShow = true
            }
            
            
        }) { (isgood:Bool) in
            self.setFlashingBlueImgView()
        }
        
        
    }
    

    
    func overloadingBaseTabBar(_ isShow:Bool){
        
        if isShow { //显示
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
                
                self.tabBarBgView.isHidden = false
                self.tabBarBgView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - self.baseHeight, width: UIScreen.main.bounds.width, height: self.baseHeight)
                
                }, completion: nil)
        }else{//隐藏
            
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
                
                self.tabBarBgView.frame = CGRect(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height - self.baseHeight, width: UIScreen.main.bounds.width, height: self.baseHeight)
  
                
                }, completion: { (isShow:Bool) in
                    self.tabBarBgView.isHidden = true
            })
            
            
        }
        
        
        
    }
    
    
    //MARK:设置角标
    
    func setMyAngleLabel(_ nub: Int){
        
        var valueStr = ""
        
        if nub == 0 {
            
            self.angleLabel?.isHidden = true
            
            
        }else{
            
            
            if nub > 99 {
                valueStr = "99+"
            }else{
                valueStr = "\(nub)"
            }
            
            
            let string:NSString = valueStr as NSString
            
            let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
            
            let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
            
            let brect = string.boundingRect(with: CGSize(width: 0, height: self.angleWidth), options: [options,a], attributes:  [NSFontAttributeName:UIFont.systemFont(ofSize: 10)], context: nil)

            var tmpWidth: CGFloat = 15
            
            
            if brect.width > 15 {
                tmpWidth = brect.width
            }else{
                tmpWidth = self.angleWidth
            }
            
            
            self.angleLabel?.frame = CGRect(x: (actView.frame.size.width - tmpWidth) / 2 + 12,y: 4,width: tmpWidth,height: angleWidth)
            
    
            self.angleLabel?.isHidden = false
            
            self.angleLabel?.text = valueStr
            
     
        }
     
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    

}
