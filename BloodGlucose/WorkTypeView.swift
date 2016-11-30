//
//  WorkTypeView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/15.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class WorkTypeView: UIView ,UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var myTabView: UITableView!
    
    var nameArray = ["轻体力(办公职员、教师)","中体力(学生、司机)","重体力(农民工、搬运工)"]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        self.initSetup()
        
    }
    
    func initSetup(){
        
        self.myTabView.delegate = self
        self.myTabView.dataSource = self
        
        
        self.myTabView.reloadData()
        
    }
    
    
    
    //Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.nameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //选择tabview
        let ddd = "inforMtCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? InforMtTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("InforMtTableViewCell", owner: self, options: nil )?.last as? InforMtTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        
        cell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row]
        
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        return cell!
    }
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.myTabView.reloadData()
        
        
        
    }
    

}
