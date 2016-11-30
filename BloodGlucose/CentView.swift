//
//  CentView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/8.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class CentView: UIView ,UITableViewDelegate ,UITableViewDataSource ,UIScrollViewDelegate{

    
    typealias CentViewScrollViewClourse = (_ offset_Y: CGFloat)->Void
    var scrollViewClourse:CentViewScrollViewClourse?
    
    
    var WJHomeCtr:UIViewController?
    
    var myTabView:UITableView!
    
    
    var imgArray = ["rightFood","rightHealth","rightBook"]
    var nameArray = ["饮食管理","健康圈子","知识库"]
    var instructionsArray = ["健康美食烹出来，美丽心情调出来",
                             "多一点健康关注，少一分疾病担忧",
                             "多看健康小贴士，做个健康小卫士"]
    
    
    var frame_o:CGRect!
    
    override func draw(_ rect: CGRect) {
        
        frame_o = rect
        
        

        self.setTabView(rect)
    
        self.setMyHeaderContentView(rect)
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset_Y = scrollView.contentOffset.y

        
        if offset_Y == -64 {
            offset_Y = 0
        }
        

        scrollViewClourse?(offset_Y)

    }
    

    
    func setTabView(_ rect: CGRect){
        
        
        myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height - 64))
        
        
        
        myTabView.backgroundColor = UIColor.clear
        
        myTabView.separatorStyle = .none
        
        myTabView.delegate = self
        myTabView.dataSource = self
        
        myTabView.bounces = false
        myTabView.showsVerticalScrollIndicator = false
        myTabView.showsHorizontalScrollIndicator = false
        
        
        self.addSubview(myTabView)
        
        
    }
    
    var mjHeadView:MJHeadView!
    var headerHeight: CGFloat = 240
    
    func setMyHeaderContentView(_ rect: CGRect){
        
        mjHeadView = Bundle.main.loadNibNamed("MJHeadView", owner: nil, options: nil)?.last as! MJHeadView
        
        mjHeadView.frame = CGRect(x: 0, y: 0, width: rect.width, height: headerHeight)
        
        let topColor = UIColor(red: (246/255.0), green: (93/255.0), blue: (34/255.0), alpha: 1)
        let buttomColor = UIColor(red: (255/255.0), green: (178/255.0), blue: (121/255.0), alpha: 1)
        
        let gradientLayer = CAGradientLayer().GradientLayer(topColor, buttomColor: buttomColor)
        gradientLayer.frame = mjHeadView.frame
        
        mjHeadView.layer.insertSublayer(gradientLayer, at: 0)
        
        
        mjHeadView.WJHomeCtr = self.WJHomeCtr
        
        
        self.myTabView.tableHeaderView = mjHeadView
        
        

        
    }
    
    

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).row {
        case 0:
            let Wsize = UIScreen.main.bounds.width

            
            return 96 - 37 + (Wsize / 375) * 37
        case 1:
            let Wsize = UIScreen.main.bounds.width / 375
            return 110 * Wsize
        default:
            return 81
        }
        
    }
    
    let Wsize = UIScreen.main.bounds.width / 375
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            
            let ddd = "CentCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? CentTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("CentTableViewCell", owner: self, options: nil )?.last as? CentTableViewCell
                
            }
            
            cell?.WJHomeCtr = self.WJHomeCtr
            
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            return cell!
        case 1:
            
            let ddd = "MJLunboCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? MJLunboTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("MJLunboTableViewCell", owner: self, options: nil )?.last as? MJLunboTableViewCell
                
            }
            
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            cell?.superCtr = self.WJHomeCtr
            
            
            return cell!
        default:
            let ddd = "HomeMideCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? HomeMideTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("HomeMideTableViewCell", owner: self, options: nil )?.last as? HomeMideTableViewCell
                
            }
            
            switch (indexPath as NSIndexPath).row {
            case 2:
                cell?.imgW.constant = 28 * Wsize
                cell?.imgH.constant = 23.5 * Wsize
            case 3:
                cell?.imgW.constant = 28 * Wsize
                cell?.imgH.constant = 21 * Wsize
            case 4:
                cell?.imgW.constant = 27.5 * Wsize
                cell?.imgH.constant = 23 * Wsize
            default:
                break
            }
            
            
            cell?.imgView.image = UIImage(named: "\(self.imgArray[(indexPath as NSIndexPath).row - 2])")
            cell?.biaotiLabel.text = self.nameArray[(indexPath as NSIndexPath).row - 2]
            cell?.instructionLabel.text = self.instructionsArray[(indexPath as NSIndexPath).row - 2]
            
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

        
        switch indexPath.row {
        case 2:
            //饮食管理
            let dietManagementVC = DietManagementViewController()
//            dietManagementVC.hidesBottomBarWhenPushed = true
            self.WJHomeCtr?.navigationController?.pushViewController(dietManagementVC, animated: true)
            
        case 3:
            //健康圈子

            let healthCirclesVC = HealthCirclesViewController()
            
            self.WJHomeCtr?.navigationController?.pushViewController(healthCirclesVC, animated: true)

        case 4:
            //知识库
            let webVC = HomeWebViewController()
            
            webVC.url = "\(TEST_HTTP)/knowledge/index.html"
            webVC.webTitle = "知识库"
            
            self.WJHomeCtr?.navigationController?.pushViewController(webVC, animated: true)
        default:
            break
        }
        
        self.myTabView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        
    }
    
    
    
 

}
