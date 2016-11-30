//
//  TMPSBMGViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/8.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class TMPSBMGViewController: UIViewController {

    
    var sbmgVC: SBMGViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        
//        let sbmgVC = SBMGViewController()
//        self.navigationController?.pushViewController(sbmgVC, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("测试是否断开了连接来过")
        
        if self.sbmgVC == nil {
            sbmgVC = SBMGViewController()
            self.navigationController?.pushViewController(sbmgVC!, animated: false)
        }else{
            print("有了啊啊啊啊")
            
            sbmgVC = nil
            
            sbmgVC = SBMGViewController()
            self.navigationController?.pushViewController(sbmgVC!, animated: false)
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
