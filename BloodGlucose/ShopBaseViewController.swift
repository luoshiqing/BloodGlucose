//
//  ShopBaseViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/27.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class ShopBaseViewController: UIViewController {

    
    var myShopView:MyShopView!
    
    let SBMGHsize = (UIScreen.main.bounds.height - 64 - 49) / (568 - 64 - 49)
    let SBMGWsize = UIScreen.main.bounds.width / 320
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商城"
        
        isOneCtrPush = true
        
        
        self.view.backgroundColor = UIColor(red: 255/255.0, green: 247/255.0, blue: 244/255.0, alpha: 1)

        
        self.myShopView = Bundle.main.loadNibNamed("MyShopView", owner: nil, options: nil)?.last as! MyShopView

        self.myShopView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height - 64)
        
        self.view.addSubview(self.myShopView)
        
        
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        BaseTabBarView.isHidden = false
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
