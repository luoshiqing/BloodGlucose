//
//  LeftViewController.swift
//  LeftSSS
//
//  Created by sqluo on 16/7/7.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    
    var WJHomeCtr:UIViewController!
    
    
    let Wsize = UIScreen.main.bounds.width
    let Hsize = UIScreen.main.bounds.height

    
    let leftWsize:CGFloat = 80
    var leftDons:CGFloat!   //左边的空隙
 
 
    
    var myTabView: UITableView!
    
    var headerH: CGFloat = 112 //头部高度
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftDons = Wsize - leftWsize

        self.view.backgroundColor = UIColor.white
        

        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: Wsize, height: Hsize))
        
        
        let topColor = UIColor(red: 255/255.0, green: 123/255.0, blue: 72/255.0, alpha: 0.3)
        let buttomColor = UIColor(red: 255/255.0, green: 231/255.0, blue: 208/255.0, alpha: 0.3)
        
        let gradientLayer = CAGradientLayer().GradientLayer(topColor, buttomColor: buttomColor)
        gradientLayer.frame = bgView.frame
        bgView.layer.insertSublayer(gradientLayer, at: 0)

        self.view.addSubview(bgView)
        
    
        let frame = CGRect(x: 0, y: 0, width: leftDons, height: Hsize)
        //
        
        myTabView = UITableView(frame: frame, style: UITableViewStyle.grouped)
        myTabView.separatorStyle = .none
        myTabView.delegate = self
        myTabView.dataSource = self
        
        myTabView.bounces = false
        self.view.addSubview(myTabView)

        myTabView.backgroundColor = UIColor.clear
        
        //去掉分割线
        myTabView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.setMyHeaderContentView()
        
    }

    var headerContentView: LeftHeadView!
    
    func setMyHeaderContentView(){
        
        let frame = CGRect(x: 0, y: 0, width: Wsize, height: headerH)
        headerContentView = Bundle.main.loadNibNamed("LeftHeadView", owner: nil, options: nil)?.last as! LeftHeadView
        
        headerContentView.frame = frame
        
        headerContentView.backgroundColor = UIColor.clear
        
        self.myTabView.tableHeaderView = headerContentView
        
  
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 49
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView = UIView(frame: CGRect(x: 0,y: 0,width: myTabView.frame.size.width,height: 7))
//        headView.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
//        headView.alpha = 0.3
        headView.backgroundColor = UIColor.clear
        
        return headView
    }

    var nameArray = ["完善资料","健康档案","膳食问卷","收货地址","提醒设置","清除缓存","意见反馈","退出登录"]
    var imgArray = ["leftInfor","leftHealth","leftDTS","leftAddres","leftbell_F","leftClear","leftMessage","leftLogOut"]
    
    let SWsize = UIScreen.main.bounds.width / 375
    
    
    
    //cacheIndexpath
    var cacheIndexPath: IndexPath!
    //完善资料
    var inforIndexPath: IndexPath!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "MenuCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? MenuTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("MenuTableViewCell", owner: self, options: nil )?.last as? MenuTableViewCell
            
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        
        cell?.imgView.image = UIImage(named: "\(self.imgArray[(indexPath as NSIndexPath).section])")
        
        cell?.hongdianImg.isHidden = true
        cell?.cachLabel.isHidden = true
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            
            self.inforIndexPath = indexPath
            
            if datamuch != nil {
                let tmpDatamuch = (datamuch as NSString).replacingOccurrences(of: "%", with: "")
                if Float(tmpDatamuch)! <= 50 {
                    cell?.hongdianImg.isHidden = false
                }else{
                    cell?.hongdianImg.isHidden = true
                }
                
            }

            cell?.cachLabel.isHidden = true
            
            cell?.imgW.constant = 22 * SWsize
            cell?.imgH.constant = 22 * SWsize
            
        case 1:
            cell?.imgW.constant = 18 * SWsize
            cell?.imgH.constant = 20.5 * SWsize
        case 2:
            cell?.imgW.constant = 20 * SWsize
            cell?.imgH.constant = 23.5 * SWsize
        case 3:
            cell?.imgW.constant = 18 * SWsize
            cell?.imgH.constant = 19 * SWsize
        case 4:
            cell?.imgW.constant = 18 * SWsize
            cell?.imgH.constant = 20.5 * SWsize
        case 5:
            
            
            self.cacheIndexPath = indexPath
            
            let cache = SDImageCache.shared().getSize()
            
            let caches = BGNetwork().cacheALG(cache)
            
            cell?.cachLabel.isHidden = false
            cell?.cachLabel.text = caches
            
            cell?.imgW.constant = 18 * SWsize
            cell?.imgH.constant = 22 * SWsize
        case 6:
            cell?.imgW.constant = 19.5 * SWsize
            cell?.imgH.constant = 20 * SWsize
        case 7:
            cell?.imgW.constant = 17.5 * SWsize
            cell?.imgH.constant = 20.5 * SWsize
        default:
            break
        }
        
        cell?.nameLabel.text! = self.nameArray[indexPath.section]
        
        
        return cell!
        
    }
    
    var finish:JGProgressHUD!
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
   
        switch (indexPath as NSIndexPath).section {
        case 5,7:
            break
        default:
            LeftSlideVC.closeLeftView()
        }
        
        
        
        
        switch (indexPath as NSIndexPath).section{
        case 0:
            //完善资料
            let classInfVC = MyInfViewController()
            self.WJHomeCtr.navigationController?.pushViewController(classInfVC, animated: true)
        case 1:
            //健康文档
            let healthVC = HealthDocumentViewController()
            self.WJHomeCtr.navigationController?.pushViewController(healthVC, animated: true)
            
        case 2:
            let dietarySurveyVC = DietarySurveyViewController(nibName: "DietarySurveyViewController", bundle: Bundle.main)
            self.WJHomeCtr.navigationController?.pushViewController(dietarySurveyVC, animated: true)
            
        case 3:
            let myAddVC = MyAddViewController()
            self.WJHomeCtr.navigationController?.pushViewController(myAddVC, animated: true)
            
        case 4:
            //提醒设置
            
            let remindSetVC = RemindSetViewController()
            self.WJHomeCtr.navigationController?.pushViewController(remindSetVC, animated: true)
            
        case 5:
            let alrtView = UIAlertController(title: "确定清除缓存吗", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            alrtView.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: { (action:UIAlertAction) -> Void in
                //清除缓存
                
                self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
                self.finish.textLabel.text = "正在清除"
                self.finish.show(in: self.myTabView, animated: true)
                
                SDImageCache.shared().clearDisk()
                
                SDImageCache.shared().cleanDisk(completionBlock: { () -> Void in
                    self.myTabView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    
                    self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.finish.textLabel.text = "清除成功"
                    self.finish.dismiss(afterDelay: 0.5, animated: true)
                })
                
            }))
            alrtView.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.WJHomeCtr.present(alrtView, animated: true, completion: nil)
            
        case 6:
            let commentVC = MyCommentViewController(nibName: "MyCommentViewController", bundle: Bundle.main)
            self.WJHomeCtr.navigationController?.pushViewController(commentVC, animated: true)
            
        case 7:
            
            
            self.leftClourse?(true)
            
            
        default:
            break
        }

        self.myTabView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        
        
        
    }
    
    typealias LeftClourse = (_ logOut: Bool)->Void
    var leftClourse:LeftClourse?
    

    func reloadIndexPath(){
        if self.cacheIndexPath != nil {
            self.myTabView.reloadRows(at: [self.cacheIndexPath], with: UITableViewRowAnimation.none)
        }
        
        if self.inforIndexPath != nil {
            self.myTabView.reloadRows(at: [self.inforIndexPath], with: .none)
        }
        
        
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
