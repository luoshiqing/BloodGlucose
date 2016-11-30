//
//  SMoreViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/12.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SMoreViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        self.setBackBtn()
    }
    
    func setBackBtn(){
        
        let backBtn = UIButton(frame: CGRect(x: 5,y: 5,width: 35,height: 35))
        backBtn.backgroundColor = UIColor.clear
        backBtn.setImage(UIImage(named: "xicon.png"), for: UIControlState())
        
        backBtn.addTarget(self, action: #selector(SMoreViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        backBtn.tag = 0
        
        self.view.addSubview(backBtn)
        
        
    }
    func someBtnAct(_ send: UIButton){
        switch send.tag {
        case 0:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override var prefersStatusBarHidden : Bool {
        return true
    }
 
    //设置为 横屏

    override var shouldAutorotate : Bool
    {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return  UIInterfaceOrientationMask.landscape
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        
        return UIInterfaceOrientation.landscapeRight
        
    }
    
    

}
