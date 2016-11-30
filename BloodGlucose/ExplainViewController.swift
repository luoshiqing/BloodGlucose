//
//  ExplainViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/9.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class ExplainViewController: UIViewController {

    
    
    
    var myTitle: String? //标题
    var typeInt: Int?    //类型
    
    
    enum ExplainTyep {
        case openBluetooth      //打开蓝牙
        case seeSerialNumber    //查看编号
        case getFastingBlood    //获得空腹血糖
    }
    
    
    var loadType = ExplainTyep.openBluetooth
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.white
        
        if let tmpTitle = self.myTitle {
            self.title = tmpTitle
        }

        
        
        self.setNav()
  
     
        //加载三类视图
        self.loadSomeView()
        
    }
    
    
    func setNav(){
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(ExplainViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
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
    
    
    func loadSomeView(){
        
        let rects = UIScreen.main.bounds
        
        print(self.loadType)
        
        switch self.loadType {
        case .openBluetooth:
            //print("打开蓝牙")
            let openBlueView = OpenBluetoothView(frame: CGRect(x: 0,y: 0,width: rects.width,height: rects.height - 64))
            openBlueView.backgroundColor = UIColor.white
            self.view.addSubview(openBlueView)
        case .seeSerialNumber:
            //print("查看设备编号")
            let seeSerialView = SeeSerialNumberView(frame: CGRect(x: 0,y: 0,width: rects.width,height: rects.height - 64))
            seeSerialView.backgroundColor = UIColor.white
            self.view.addSubview(seeSerialView)
        case .getFastingBlood:
            print("如何获得空腹血糖")
            let getFastinView = GetFastingBloodView(frame: CGRect(x: 0,y: 0,width: rects.width,height: rects.height - 64))
            getFastinView.backgroundColor = UIColor.white
            self.view.addSubview(getFastinView)
            
            
        }
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BaseTabBarView.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
