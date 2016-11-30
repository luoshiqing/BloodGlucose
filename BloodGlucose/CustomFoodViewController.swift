//
//  CustomFoodViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/25.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class CustomFoodViewController: BaseViewController {

    
    fileprivate var customView: CustomFoodView?
    
    var idString = ""
    
    var isShowDownView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.title = "健康美食定制"
        
        self.loadCustomFoodView()
  
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        BaseTabBarView.isHidden = true
  
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CustomNetwork().getFoodMenu(self.view, ids: self.idString) { (imgUrlArray, nameArray, idArray) in
            

            self.customView?.drugRecMainView?.setRecMainViewValue(showImgArray: imgUrlArray, showNameArray: nameArray, idArray: idArray)
            
        }
        
        
    }
    
    
    fileprivate func loadCustomFoodView(){
        
        let rect = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height)
        
        var selectMax = 3
        if !self.isShowDownView {
            selectMax = 0
        }
        
        self.customView = CustomFoodView(frame: rect, selectMax: selectMax, target: self,isShowDownView: self.isShowDownView)
        self.customView?.backgroundColor = UIColor.yellow
        
        self.view.addSubview(customView!)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
