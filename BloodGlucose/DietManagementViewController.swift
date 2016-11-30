//
//  DietManagementViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/21.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class DietManagementViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    
    fileprivate let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64) //高度比例
    fileprivate let ScreenSize = UIScreen.main.bounds.size
    
    
    fileprivate let titleArray: [String] = ["","为您推荐","应季食物","热门食物","我的任务"]
    fileprivate let nameArray: [String] = ["","自然 | 实惠","气节 | 养生","糖友 | 喜爱","控糖 | 专家"]
    fileprivate let imgArray: [String] = ["","yinshi1.png","yinshi2.png","yinshi3.png","yinshi4.png"]
    fileprivate let backColorArray: [UIColor] = [UIColor().rgb(241, g: 255, b: 205, alpha: 1),
                                                 UIColor().rgb(241, g: 255, b: 205, alpha: 1),
                                                 UIColor().rgb(212, g: 242, b: 255, alpha: 1),
                                                 UIColor().rgb(255, g: 241, b: 209, alpha: 1),
                                                 UIColor().rgb(254, g: 236, b: 255, alpha: 1)]
    
    
    fileprivate var myTabView: UITableView?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "饮食管理"
        self.view.backgroundColor = UIColor.gray
        
        self.setNav()
        
        self.setMyTabView()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if ((self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer))) != nil) {
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        }
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BaseTabBarView.isHidden = true
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    
    func setNav(){
        
        //返回

        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(self.backAct), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
    }
    
    func backAct(){
        self.navigationController!.popViewController(animated: true)
    }
    
    func setMyTabView(){
        
        self.myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: self.ScreenSize.width, height: self.ScreenSize.height), style: UITableViewStyle.plain)
        
        self.myTabView?.backgroundColor = UIColor.red
        
        self.myTabView?.delegate = self
        self.myTabView?.dataSource = self
        
        self.myTabView?.separatorColor = UIColor().rgb(204, g: 204, b: 204, alpha: 1)
        
        self.myTabView?.tableFooterView = UIView()
        
        self.myTabView?.isScrollEnabled = false
        
        
        self.view.addSubview(self.myTabView!)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 169 * self.Hsize
        default:
            let h = (self.ScreenSize.height - 169 * self.Hsize) / CGFloat(self.titleArray.count - 1)
            return h
        }
    }
 
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            let ddd = "DietHeadCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? DietHeadTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("DietHeadTableViewCell", owner: self, options: nil )?.last as? DietHeadTableViewCell
            }
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            
            return cell!
            
        default:
            let ddd = "DietBodyCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? DietBodyTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("DietBodyTableViewCell", owner: self, options: nil )?.last as? DietBodyTableViewCell
                
            }
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            cell?.titleLabel.text = self.titleArray[indexPath.row]
            cell?.nameLabel.text = self.nameArray[indexPath.row]
            cell?.imgView.image = UIImage(named: self.imgArray[indexPath.row])
            cell?.contentView.backgroundColor = self.backColorArray[indexPath.row]

            
            let size = self.getCellIndexSize(form: indexPath.row)
            
            cell?.imgH.constant = size.x
            cell?.imgW.constant = size.y
     
            return cell!
        }
  
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

        switch indexPath.row {
        case 1: //为您推荐

            let recomVC = DrugRecommendedViewController()
            self.navigationController?.pushViewController(recomVC, animated: true)
        case 2: //应季食物
            let seasonalVC = FoodSeasonViewController(nibName: "FoodSeasonViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(seasonalVC, animated: true)
        case 3: //热门食物
            let hotlVC = FoodHotViewController(nibName: "FoodHotViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(hotlVC, animated: true)
        case 4: //我的任务
            let tasklVC = TaskViewController(nibName: "TaskViewController", bundle: Bundle.main)
            self.navigationController?.pushViewController(tasklVC, animated: true)
        default:
            break
        }
   
    }
    
    func getCellIndexSize(form: Int)->(x:CGFloat,y:CGFloat){
        
        var h: CGFloat = 0
        var w: CGFloat = 0
        
        switch form {
        case 1:
            h = 82.0
            w = 69.0
        case 2:
            h = 89.0
            w = 73.0
        case 3:
            h = 82.0
            w = 69.0
        case 4:
            h = 101.0
            w = 56.0
        default:
            break
        }

        return (x:w,y:h)
        
        
    }

}
