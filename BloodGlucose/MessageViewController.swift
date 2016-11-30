//
//  MessageViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/27.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    
    let MRect = UIScreen.main.bounds.size
    
    var myTabView: UITableView!
    
    fileprivate var dataArray = [(intro: String,time: String,state: String,id: String,title: String,type: String)]()

    override func viewDidLoad() {
        super.viewDidLoad()

 
        self.title = "消息"
        self.view.backgroundColor = UIColor.white
 
        //设置tabView
        self.setMytabView()
        
        self.setRefresh()
     
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        BaseTabBarView.isHidden = false
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        self.page = 1
        self.footer.resetNoMoreData()
        MyNetworkRequest().getMessageTextData(self.view, showHUD: true, page: self.page, shownum: self.showNum) { (haveData, dataArray, notsize) in
            if haveData{
                
                if let data = dataArray{
                    self.dataArray = data
                    
                    (BaseTabBarCtr as? BaseTabBarViewController)?.setMyAngleLabel(notsize)

                    self.myTabView.reloadData()
                }
                
            }
            
    
        }
        
        
    }
    
    let header = MJRefreshNormalHeader()
    
    let footer = MJRefreshAutoNormalFooter()
    
    fileprivate let showNum = 10
    
    fileprivate var page = 1
    
    func setRefresh(){
        //下拉刷新
        self.header.setRefreshingTarget(self, refreshingAction: #selector(FoodHotViewController.headerRefresh))
        
        self.myTabView.mj_header = header
        
        //上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(FoodHotViewController.footerRefresh))
        self.myTabView.mj_footer = footer
    }
    func headerRefresh(){
        print("下拉刷新")
        self.page = 1
        self.footer.resetNoMoreData()
        MyNetworkRequest().getMessageTextData(self.view, showHUD: false, page: self.page, shownum: self.showNum) { (haveData, dataArray, notsize) in
            if haveData{
                
                if let data = dataArray{
                    self.dataArray = data
                    
                    (BaseTabBarCtr as? BaseTabBarViewController)?.setMyAngleLabel(notsize)
                    
                    self.myTabView.reloadData()
                }
                
            }
            self.myTabView.mj_header.endRefreshing()
        }
        
    }
    
    //底部刷新
    
    func footerRefresh(){
        
        self.page += 1

        MyNetworkRequest().getMessageTextData(self.view, showHUD: false, page: self.page, shownum: self.showNum) { (haveData, dataArray, notsize) in
            if haveData{
                if let data = dataArray{
                    self.dataArray += data
                    (BaseTabBarCtr as? BaseTabBarViewController)?.setMyAngleLabel(notsize)
                    self.myTabView.reloadData()
                }
                self.myTabView.mj_footer.endRefreshing()
            }else{
                
                
                self.footer.endRefreshingWithNoMoreData()
                
            }
        }
        
        
    }
    
    
    //
    func setMytabView(){
        
        
        self.myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: MRect.width, height: MRect.height - 64))
        
        
        
        self.myTabView.delegate = self
        self.myTabView.dataSource = self
        
        self.myTabView.tableFooterView = UIView()
        //分割线颜色
        self.myTabView.separatorColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1)
        self.view.addSubview(self.myTabView)
 
    }
 
    var MessageCell: MessageTableViewCell!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if MessageCell != nil {
            let labelText = MessageCell?.contentLabel.text
            
            let string:NSString = labelText! as NSString
            
            let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
            
            let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
            
            let brect = string.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 30, height: 0), options: [options,a], attributes:  [NSFontAttributeName:(MessageCell?.contentLabel.font)!], context: nil)
            
            return brect.height + (73 - 18)
        }else{
            return 73
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "MessageCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? MessageTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("MessageTableViewCell", owner: self, options: nil )?.last as? MessageTableViewCell
            
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        self.MessageCell = cell

        
        if !self.dataArray.isEmpty {
            let intro = self.dataArray[(indexPath as NSIndexPath).row].intro
            
            let time = self.dataArray[(indexPath as NSIndexPath).row].time
            
            let state = self.dataArray[(indexPath as NSIndexPath).row].state
            
            if state == "0" {
                cell?.pointView.isHidden = false
            }else{
                cell?.pointView.isHidden = true
            }
            
            
            
            cell?.contentLabel.text = intro
            cell?.timeLabel.text = time
            
        }
        
 
        return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((indexPath as NSIndexPath).row)
   
        if !self.dataArray.isEmpty {
            let id = self.dataArray[(indexPath as NSIndexPath).row].id
            
            let title = self.dataArray[(indexPath as NSIndexPath).row].title
            
            let url = "\(TEST_HTTP)/jsp/message/details.jsp?id=\(id)&userid=\(ussssID)"

            let webVC = HomeWebViewController()
            
            webVC.url = url
            webVC.webTitle = title
            
            self.navigationController?.pushViewController(webVC, animated: true)
  
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
