//
//  BaseViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/25.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.yellow
        
        self.setNav()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if ((self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer))) != nil) {
//            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
//        }
        
    }
    
    
    func backAct(send: UIButton){
        self.navigationController!.popViewController(animated: true)
    }
    
    
    func setNav(){
        //返回
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(self.backAct(send:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
