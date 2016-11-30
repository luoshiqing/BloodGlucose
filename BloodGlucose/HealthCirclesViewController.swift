//
//  HealthCirclesViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/31.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class HealthCirclesViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    fileprivate let mySize = UIScreen.main.bounds.size
    
    var myTabView: UITableView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.white
        self.title = "健康圈子"
        
        self.setNav()
        
        
        self.setMyTabView()
        
        
        
        self.setRefresh()
        
    }
    
    let header = MJRefreshNormalHeader()
    
    let footer = MJRefreshAutoNormalFooter()
    
    func setRefresh(){
        //下拉刷新
        self.header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
        
        self.myTabView?.mj_header = header
        
        //上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh))
        self.myTabView?.mj_footer = footer
    }
    func headerRefresh(){
        //下拉刷新
        self.myTabView?.mj_header.endRefreshing()
    }
    
    //底部刷新
    
    func footerRefresh(){
        
        self.page += 1
        
        MyNetworkRequest().getHealthCircleData(self.view ,showHUD: false , page: self.page, shownum: self.showNum) { (haveData, listArray) in
            if haveData{
                if let list = listArray{
                    self.dataArray += list
                    self.myTabView?.reloadData()
                }
    
                self.myTabView?.mj_footer.endRefreshing()
                
            }else{

                self.footer.endRefreshingWithNoMoreData()
                
            }
            
            
            
            
        }

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        BaseTabBarView.isHidden = true
        CAGradientLayerEXT().animation(false)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
    }
    
    
    fileprivate var dataArray = [[String:Any]]()
    
    
    fileprivate let showNum = 10
    
    fileprivate var page = 1
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if self.dataArray.isEmpty {
            MyNetworkRequest().getHealthCircleData(self.view ,showHUD: true, page: self.page, shownum: self.showNum, clourse: { (haveData, listArray) in
                if haveData{
                    if let list = listArray {
                        self.dataArray = list
                        self.myTabView?.reloadData()
                    }
                }
            })
        }
        
    }
    
    
    
    func setMyTabView(){
        
        myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: mySize.width, height: mySize.height - 64))
        
        myTabView?.delegate = self
        myTabView?.dataSource = self
        
        
        myTabView?.separatorStyle = .none
        
        self.view.addSubview(myTabView!)
        
    }
    
    
    
    func setNav(){
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(self.btnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
    }
    
    func btnAct(_ send: UIButton){
        self.navigationController!.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
        
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let sizes = UIScreen.main.bounds.size.width / 375
        
        
        return 98 * sizes + (146 - 98)
        
        
    }

    //未加载完成显示的图片名称
    var imgString = "banLoding"
    //加载失败
    var imgFaild = "banfFailed"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "HealthCirclesCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? HealthCirclesTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("HealthCirclesTableViewCell", owner: self, options: nil )?.last as? HealthCirclesTableViewCell
            
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
  
        
        if !self.dataArray.isEmpty {
            
            let title = self.dataArray[indexPath.row]["t"] as! String
            let imgurl = self.dataArray[indexPath.row]["i"] as! String
            
            cell?.nameLabel.text = title

            
            let aaurl2 = imgurl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
            
            let imgurl2:URL = URL(string: aaurl2!)!
            

            cell?.imgView.sd_setImage(with: imgurl2, placeholderImage: UIImage(named: self.imgString))
            
            
            
        }
        
        
   
        return cell!
        
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if !self.dataArray.isEmpty {
            
            let url = dataArray[indexPath.row]["u"] as! String
            let title = dataArray[indexPath.row]["t"] as! String

            let webVC = HomeWebViewController()
            
            webVC.url = url
            webVC.webTitle = title
            
            self.navigationController?.pushViewController(webVC, animated: true)
            
   
        }
        
        
        
        
        
        
        
        
    }

}
