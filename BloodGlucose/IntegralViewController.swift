//
//  IntegralViewController.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/1/20.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class IntegralViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBOutlet weak var upViewH: NSLayoutConstraint!//166
    
    @IBOutlet weak var downViewH: NSLayoutConstraint!//320
    
    
    @IBOutlet weak var v1H: NSLayoutConstraint!//77
    
    @IBOutlet weak var v2H: NSLayoutConstraint!//45
    
    @IBOutlet weak var v3H: NSLayoutConstraint!
    
    @IBOutlet weak var v4H: NSLayoutConstraint!
    
    @IBOutlet weak var jifenLabelToH: NSLayoutConstraint!//19
    
    @IBOutlet weak var jifenH: NSLayoutConstraint!//21
    
    @IBOutlet weak var jinpaiH: NSLayoutConstraint!//70
    
    @IBOutlet weak var jinpaiW: NSLayoutConstraint!//65
    
    //背景白色
    @IBOutlet weak var diqiuToUpH: NSLayoutConstraint!//71
    
    @IBOutlet weak var diqiuH: NSLayoutConstraint!//113
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "了解积分"
        
        //布局
        self.setLayOut()
        //设置导航栏
        self.setNav()
    }
    
    func setLayOut(){
        let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
        
        upViewH.constant = Hsize * 166
        downViewH.constant = Hsize * 320
        v1H.constant = Hsize * 77
        v2H.constant = Hsize * 45
        v3H.constant = Hsize * 45
        v4H.constant = Hsize * 45
        
        jifenLabelToH.constant = Hsize * 19
        jifenH.constant = Hsize * 21
        jinpaiH.constant = Hsize * 70
        jinpaiW.constant = Hsize * 65
        
        diqiuToUpH.constant = Hsize * 71
        diqiuH.constant = Hsize * 113
    }
    
    func setNav(){
        //返回
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(IntegralViewController.backAct), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
    }
    func backAct(){
        self.navigationController!.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
