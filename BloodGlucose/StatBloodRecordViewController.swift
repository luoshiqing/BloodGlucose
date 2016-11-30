//
//  StatBloodRecordViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/18.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class StatBloodRecordViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource{

    fileprivate var dateArray = [String]() //日期数组
    fileprivate var valueArray = [[[String]]]() //值数组
    
    
    
    var myTabView: UITableView?
    
    
    var gettime: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "血糖记录"
        
        self.view.backgroundColor = UIColor.yellow
   
        self.setNav()
        
        self.setTabView()
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        var getDic = [String:String]()
        if let str = self.gettime {
            getDic["time"] = str
        }else{
            let (strTime1,_,_) = StatisticalService().getCurrentDate()
            
            getDic["time"] = strTime1
            
        }
        
        MyNetworkRequest().getAllStatisticalBloodsugar(self.view, dic: getDic) { (success,dateArray, valueArray) in
            if success{
                self.dateArray = dateArray
                self.valueArray = valueArray
                
                self.myTabView?.reloadData()
            }
            
        }
        
        
    }
    
    func setNav(){
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(StatBloodRecordViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
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
        
        myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height - 64), style: UITableViewStyle.grouped)
        
        myTabView?.backgroundColor = UIColor.white
        
        myTabView?.delegate = self
        myTabView?.dataSource = self
        
        myTabView?.separatorStyle = .none
        
        self.view.addSubview(myTabView!)
   
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.valueArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if !self.valueArray.isEmpty {
            return self.valueArray[section].count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if !self.dateArray.isEmpty {
            
            if self.valueArray[section].isEmpty {
                return nil
            }else{
                let headView = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: 37))
                headView.backgroundColor = UIColor().rgb(246, g: 246, b: 246, alpha: 1)
                
                let dateLabel = UILabel(frame: CGRect(x: 18,y: 0,width: 100,height: 37))
                dateLabel.textColor = UIColor().rgb(246, g: 93, b: 34, alpha: 1)
                
                dateLabel.text = self.dateArray[section]
                
                dateLabel.font = UIFont(name: PF_SC, size: 16)
                
                headView.addSubview(dateLabel)
                
                
                
                
                return headView
            }
            
            
        }else{
            return nil
        }
    
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.valueArray[section].isEmpty {
            return 0.01
        }else{
            return 37
        }
        
//        return 37
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "SBRCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? SBRTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("SBRTableViewCell", owner: self, options: nil )?.last as? SBRTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        
        if !self.valueArray.isEmpty {
            let tmpArray = self.valueArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            
            let type = tmpArray[0]
            let time = tmpArray[1]
            let blood = tmpArray[2]

            cell?.titleTimeLabel.text = "\(type)   \(time)"
            cell?.bloodLabel.text = "\(blood)mmol/L"
      
            if (indexPath as NSIndexPath).row == self.valueArray[(indexPath as NSIndexPath).section].count - 1 {
                cell?.sepView.isHidden = true
            }else{
                cell?.sepView.isHidden = false
            }
            
            
        }
        
        
        
        
        return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }
    

    //MARK:- 删除
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if tableView == self.myTabView{
            
            if editingStyle == .delete {
                
                let logId = self.valueArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row][3]
                print(logId)
                
                let removeDic = ["removeid":logId]

                print("删除")
                
                MyNetworkRequest().removeBloodsugar(self.view, removeid: removeDic, clourse: { (success) in
                    
                    print("删除成功")
       
                    self.valueArray[(indexPath as NSIndexPath).section].remove(at: (indexPath as NSIndexPath).row)

                    self.myTabView!.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
   
                    
                    if self.valueArray[(indexPath as NSIndexPath).section].isEmpty{
                        self.myTabView?.reloadData()
                    }
                    
                    
                })
                
                
            }
            
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    

}
