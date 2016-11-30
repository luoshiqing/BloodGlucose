//
//  TaskDetailViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/26.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class TaskDetailViewController: BaseViewController ,MyShareDelegate{
    //---初始化
    fileprivate var mid: String!
    fileprivate var myTitle: String!
    
    fileprivate var isGetFoodDetail = true
    
    
    init(title: String, mid: String) {
        super.init(nibName: nil, bundle: nil)
        self.mid = mid
        self.myTitle = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //-----
 
    fileprivate var taskDetailView: TaskDetailView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.myTitle
        self.view.backgroundColor = UIColor.white
        self.setMyNav()
        self.loadDetailView()
    }
    
    fileprivate var myDic = [String:Any]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isGetFoodDetail {
            TaskDetailNetwork().getFoodDetail(self.view, mid: self.mid) { (dic) in
                self.myDic = dic
                self.taskDetailView?.setTaskDetailValue(dic)
                self.isGetFoodDetail = false
            }
        }
        
        
 
    }
    
    
     func setMyNav(){
        //右
        let (rightBtn,rightSpacer,rightItem) = BGNetwork().creatRightBtn()
        rightBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        rightBtn.setImage(UIImage(named: "share"), for: UIControlState())
        rightBtn.tag = 1
        self.navigationItem.rightBarButtonItems = [rightSpacer,rightItem]

    }
    
    
    var shareView:  ShareView?
    var BJView: UIView?
    
    var shareText:String = ""
    var shareTitle:String = ""
    var shareUrl:String = ""
    
    func someBtnAct(_ send: UIButton){
        let menuDic = self.myDic["menu"] as! [String:Any]
        self.shareText = TaskDetailNetwork().generateShareText(menu: menuDic)
        self.shareTitle = "优医糖美食－\(self.myTitle)"
        self.shareUrl = "\(TEST_HTTP)/share/moblie/getgreeninfo.jsp?mid=\(self.mid)"
        
        let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
        
        if (self.shareView == nil){
            
            self.shareView = Bundle.main.loadNibNamed("ShareView", owner: nil, options: nil)?.first as? ShareView
            
            self.shareView?.delegate = self
            
            self.shareView?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 64 - 165 * Hsize, width: UIScreen.main.bounds.width, height: 165 * Hsize)
            
            self.view.addSubview(self.shareView!)
        }
        
        if (self.BJView == nil) {
            self.BJView = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height - self.shareView!.frame.size.height - 64))
            
            self.BJView?.backgroundColor = UIColor.black
            self.BJView?.alpha = 0.3
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.BJviewTap))
            self.BJView?.addGestureRecognizer(tap1)
            
            self.view.addSubview(self.BJView!)
   
        }
        
    }
    //MARK:分享代理
    func shareAction(_ tag: Int) {
        switch tag {
        case 0:
            //print("取消")
            self.BJviewTap()
        case 1...4:
            //tag -> 1.微信 2.朋友圈 3.QQ 4.新浪
            BGNetwork().myShare(self.shareText, url: self.shareUrl, title: self.shareTitle, tag: tag)
        default:
            break
            
        }
    }
    func BJviewTap(){
        self.shareView?.removeFromSuperview()
        self.shareView = nil
        
        self.BJView?.removeFromSuperview()
        self.BJView = nil

    }
    
    
    fileprivate func loadDetailView(){
        let rect = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height - 64)
        self.taskDetailView = TaskDetailView(frame: rect, downViewH: 44.0, mid: self.mid, target: self)
        self.taskDetailView?.backgroundColor = UIColor.white
        
        self.view.addSubview(self.taskDetailView!)
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
