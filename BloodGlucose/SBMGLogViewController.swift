//
//  SBMGLogViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/4.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SBMGLogViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate{

    
    
    
    
    
    
    
    let titleArray = ["连接设备","连接设备完成","获取数据","获取数据完成","同步数据","同步完成"]
    
    var timeArray = ["","","","","",""]
    
    
    
    var myTabView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "设备日志"
        
        self.view.backgroundColor = UIColor.white
        
        
        
        
        self.setNav()
        //设置
        self.setTabView()
        
        
        
        
    }

    func setNav(){
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(SBMGLogViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
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
    
    func setTabView(){
        
        myTabView = UITableView(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height - 64))
        
        myTabView.delegate = self
        myTabView.dataSource = self
        
        
        myTabView.tableFooterView = UIView()
        
        myTabView.separatorStyle = .none
        
        self.view.addSubview(myTabView)
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    //MARK:Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 61
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let ddd = "SBMGLogCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? SBMGLogTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("SBMGLogTableViewCell", owner: self, options: nil )?.last as? SBMGLogTableViewCell
            
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        
        if (indexPath as NSIndexPath).row == 0{
            cell?.upLineVeiw.isHidden = true
        }else{
            cell?.upLineVeiw.isHidden = false
        }
        if (indexPath as NSIndexPath).row == self.titleArray.count - 1{
            cell?.downLineView.isHidden = true
        }else{
            cell?.downLineView.isHidden = false
        }
        
        
        
        cell?.titleLabel.text = self.titleArray[(indexPath as NSIndexPath).row]
        cell?.timeLabel.text = self.timeArray[(indexPath as NSIndexPath).row]
        
        
        if self.timeArray[(indexPath as NSIndexPath).row].isEmpty{
            
            cell?.titleLabel.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            
            cell?.upLineVeiw.backgroundColor = UIColor(red: 212/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)
            cell?.downLineView.backgroundColor = UIColor(red: 212/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)
            cell?.pointView.backgroundColor = UIColor(red: 212/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)
            
        }else{
            
            
            cell?.titleLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            
            cell?.upLineVeiw.backgroundColor = UIColor(red: 255/255.0, green: 188/255.0, blue: 163/255.0, alpha: 1)
            cell?.downLineView.backgroundColor = UIColor(red: 255/255.0, green: 188/255.0, blue: 163/255.0, alpha: 1)
            cell?.pointView.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            
        }
        
  
        
        return cell!
        
        
    }


}
