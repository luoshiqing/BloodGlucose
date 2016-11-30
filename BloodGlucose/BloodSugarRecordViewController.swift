//
//  BloodSugarRecordViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/26.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class BloodSugarRecordViewController: UIViewController {

    //上级控制器
    var tmpCtr: UIViewController?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.title = "血糖录入"
        
        self.setNav()
        
        //加载视图
        self.loadMyView()
        
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        
        BaseTabBarView.isHidden = true
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    func setNav(){
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(BloodSugarRecordViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
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
    
    
    
    var bloodRecordView: BloodRecordView!
    func loadMyView(){
        
        if bloodRecordView == nil{
            bloodRecordView = BloodRecordView(frame: self.view.bounds)
            bloodRecordView.backgroundColor = UIColor.white
            
            bloodRecordView.superCtr = self
            
            
            bloodRecordView.backCtr = self.tmpCtr
            

            self.view.addSubview(bloodRecordView)
        }
        
        
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
