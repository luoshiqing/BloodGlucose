//
//  EventSelectViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/2.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

///-------
var TOFOODVC = false
var TOSPORTVC = false
var TOMEDICVC = false

//全局暂存 日历选择的时间
var dateString:String!
//全局暂存 日历选择的时间戳
var dateDouble:Double!


var eeeventVC:UIViewController!
//-----





var isSecBlood: Bool? = true //是否选择的是 血糖 true 为血糖


class EventSelectViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    
    var tmpCtr: UIViewController? //存放上级控制器，跳转用

    
    var myTabView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "添加事件"
        self.view.backgroundColor = UIColor.white
        
        //导航栏
        self.setNav()
        
        //tabView
        self.setTabView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BaseTabBarView.isHidden = true
 
    }
    
    

    func setNav(){
        
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(EventSelectViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
  
    }
    func someBtnAct(_ send:UIButton){
        self.navigationController!.popViewController(animated: true)
    }
    
    func setTabView(){
        
        myTabView = UITableView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height - 64), style: UITableViewStyle.grouped)

        myTabView.delegate = self
        myTabView.dataSource = self
        
        myTabView.separatorStyle = UITableViewCellSeparatorStyle.none

        
        
        self.view.addSubview(myTabView)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //图片数组
    var imgArray = ["eventFood","eventMedic","eventSport","MJblood"]
    //名字数组
    var nameArray = ["饮食","药物","运动","血糖"]
    
    //MARK:###tabView代理
    //有多少分组
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.nameArray.count
    }
    
    
    //每个分组有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return 1

    }
    //每个分组的头高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 10
        }else{
            return 5
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    
    //每行高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

       return 54
   
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "EventSelectCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? EventSelectTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("EventSelectTableViewCell", owner: self, options: nil )?.last as? EventSelectTableViewCell
            
        }
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        
        cell?.imgView.image = UIImage(named: self.imgArray[(indexPath as NSIndexPath).section])
        cell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).section]
        

        return cell!
    }
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(self.nameArray[(indexPath as NSIndexPath).section])
  
        switch (indexPath as NSIndexPath).section {
        case 0:

            //xib 饮食
            let foodVC = SupAddFoddViewController(nibName: "SupAddFoddViewController", bundle: Bundle.main)
            
            foodVC.tmpCtr = self.tmpCtr
            
            
            self.navigationController?.pushViewController(foodVC, animated: true)
            
            
        case 2:
            
 
            //运动
            let sportVC = SubSportViewController(nibName: "SubSportViewController", bundle: Bundle.main)
            
            sportVC.tmpCtr = self.tmpCtr
            
            self.navigationController?.pushViewController(sportVC, animated: true)
            
            
        case 1:

            //药物
            
            let drugCtr = DrugViewController()
            drugCtr.tmpCtr = self.tmpCtr
            drugCtr.isEdit = false
            self.navigationController?.pushViewController(drugCtr, animated: true)

            
        case 3:
            
            //血糖
            
            let bloodSugarVC = BloodSugarRecordViewController()
            
            bloodSugarVC.tmpCtr = self.tmpCtr
            
            self.navigationController?.pushViewController(bloodSugarVC, animated: true)
        default:
            break
        }
        tableView.reloadData()
        
    }

}
