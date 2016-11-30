//
//  SRightView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/14.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SRightView: UIView , UITableViewDataSource, UITableViewDelegate {

    typealias SRightViewBtnActClourse = (_ send: UIButton)->Void
    var btnActClourse:SRightViewBtnActClourse?
    
    
    typealias SRightViewCleanCompelete = (_ date: String)->Void
    var CleanCompelete:SRightViewCleanCompelete?
    
    
    
    var StaticCtr: UIViewController!
    
    
    var sRTopView: SRTopView!
    var topView_height: CGFloat = 225
    
    
    
    var myTabView: UITableView!
    
    var notDataView: UIView!

    
    override func draw(_ rect: CGRect) {
        

        //顶部日期选择
        
        sRTopView = Bundle.main.loadNibNamed("SRTopView", owner: nil, options: nil)?.last as! SRTopView
        
        sRTopView.frame = CGRect(x: 0, y: 0, width: rect.width, height: topView_height)

        sRTopView.btnActClourse = self.SRTopViewBtnActClourse
        
        self.addSubview(sRTopView)
        
        //底部tabview
        
        myTabView = UITableView(frame: CGRect(x: 0, y: topView_height, width: rect.width, height: rect.height - topView_height))
        
        
        if self.myTabView.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            self.myTabView.separatorInset = UIEdgeInsets.zero
        }
        if self.myTabView.responds(to: #selector(setter: UIView.layoutMargins)) {
            self.myTabView.layoutMargins = UIEdgeInsets.zero
        }
        
        myTabView.delegate = self
        myTabView.dataSource = self
        
        self.myTabView.tableFooterView = UIView()

        self.addSubview(myTabView)
        
        
        //
        notDataView = UIView(frame: CGRect(x: 0, y: topView_height, width: rect.width, height: rect.height - topView_height))
        notDataView.backgroundColor = UIColor.white
        self.addSubview(notDataView)
        
        notDataView.isHidden = true
        
        let not_framsize = notDataView.frame.size
        let bbView = UIView(frame: CGRect(x: 0,y: (not_framsize.height - 100) / 2,width: rect.width,height: 100))
        bbView.backgroundColor = UIColor.white
        notDataView.addSubview(bbView)
        
        let bb_framesize = bbView.frame.size
        let imgView = UIImageView(frame: CGRect(x: (bb_framesize.width - 58) / 2, y: 0, width: 58, height: 58))
        imgView.image = UIImage(named: "notEvent.png")
        bbView.addSubview(imgView)
        
        let label = UILabel(frame: CGRect(x: 0,y: 20 + 58,width: rect.width,height: 22))
        label.text = "您还没有添加任何事件"
        label.textColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        bbView.addSubview(label)
        
        
    }
    
    func setNotData(_ isNotData: Bool){
        
        if isNotData {
            self.myTabView.isHidden = true
            self.notDataView.isHidden = false
        }else{
            self.myTabView.isHidden = false
            self.notDataView.isHidden = true
        }
        
        
    }
    
    
    
    
    
    //时间选择回调
    func SRTopViewBtnActClourse(_ send: UIButton)->Void{
        btnActClourse?(send)
    }
    
    
  
    
 
    
    var dataArray = NSMutableArray() //所有数据
    
    
    
    
    //tableView 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let ddd = "NewEventCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? NewEventTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("NewEventTableViewCell", owner: self, options: nil )?.last as? NewEventTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        cell?.separatorInset.left = 0
        
        
        if let type:String = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "type") as? String{
            //说明
            //图片
            
            var imgName = ""
            switch type {
            case "medicine":
                imgName = "yao11.png"
                
                cell?.typeImgView.image = UIImage(named: "newmedic")
                cell?.typeLabel.text = "药物"
                cell?.infLabel.text = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "medicine") as? String
                cell?.timeLabel.text = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "time") as? String
                
            case "sport":
                imgName = "dong11.png"
                
                cell?.typeImgView.image = UIImage(named: "rzBasketballF")
                cell?.typeLabel.text = "运动"
                cell?.infLabel.text = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "sport") as? String
                cell?.timeLabel.text = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "time") as? String
            default:
                imgName = "shi11.png"
                
                cell?.typeImgView.image = UIImage(named: "rzSpoonForkL")
                cell?.typeLabel.text = "饮食"
                cell?.infLabel.text = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "food") as? String
                cell?.timeLabel.text = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "time") as? String
            }
            
            if let url:NSArray = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "imgurl") as? NSArray{
                if url.count > 0 {
                    let adic = url[0] as! NSDictionary
                    let url = adic.value(forKey: "imgurl") as! String
                    let imgurl:URL = URL(string: url)!
                    cell?.bigImgView.sd_setImage(with: imgurl, placeholderImage: UIImage(named: imgName))
                }else{
                    cell?.bigImgView.image = UIImage(named: imgName)
                }
            }else{
                cell?.bigImgView.image = UIImage(named: imgName)
            }
            //心情
            if let emotion:Int = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "emotion") as? Int{
                switch emotion{
                case 0:
                    cell?.feelLabel.text = "高兴"
                    cell?.feelImgView.image = UIImage(named: "eventHappy")
                case 1:
                    cell?.feelLabel.text = "正常"
                    cell?.feelImgView.image = UIImage(named: "eventNormal")
                case 2:
                    cell?.feelLabel.text = "不舒服"
                    cell?.feelImgView.image = UIImage(named: "eventNotHappy")
                default:
                    break
                }
            }
            
            
        }
        
        return cell!
        
    }
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let type:String = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "type") as? String{
            switch type{
            case "food":
                print("食物")

                let supAddFoodVC = SupAddFoddViewController(nibName: "SupAddFoddViewController", bundle: Bundle.main)
                
                let tmpDataDic = self.dataArray[(indexPath as NSIndexPath).row] as! NSDictionary
                supAddFoodVC.logid = tmpDataDic.value(forKey: "logId") as! String
                
                supAddFoodVC.upDic.addEntries(from: tmpDataDic as! [AnyHashable: Any])
                supAddFoodVC.isEdit = true
                
                self.StaticCtr.navigationController?.pushViewController(supAddFoodVC, animated: true)
                
    
                self.dataArray.removeAllObjects()
                
            case "sport":
                print("sport")
                
                TOSPORTVC = true

                
                let sportVC = SubSportViewController(nibName: "SubSportViewController", bundle: Bundle.main)
                
                sportVC.isEdit = true
                
                let tmpUpDic = self.dataArray[(indexPath as NSIndexPath).row] as! NSDictionary
                
                sportVC.upDic.addEntries(from: tmpUpDic as! [AnyHashable: Any])
                
                self.StaticCtr.navigationController?.pushViewController(sportVC, animated: true)
                
                self.dataArray.removeAllObjects()
                
                
            case "medicine":
                print("medicine")
                
                TOMEDICVC = true


                
                let drugCtr = DrugViewController()
                drugCtr.isEdit = true
                
                let tmpDic = self.dataArray[indexPath.row] as! [String:Any]
                drugCtr.isEditDic = tmpDic
                
                self.StaticCtr.navigationController?.pushViewController(drugCtr, animated: true)
                
                
                
                self.dataArray.removeAllObjects()
                
            default:
                break
            }
        }
        
    }
    

    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }
    
//    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
//        print("将要编辑")
//        let cell = tableView.cellForRow(at: indexPath) as! NewEventTableViewCell
//        cell.rightArrowImgView.isHidden = true
//    }
//    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
//        print("编辑结束？")
//        
//        if let cell = tableView.cellForRow(at: indexPath!) as? NewEventTableViewCell{
//            cell.rightArrowImgView.isHidden = false
//        }
//        
//        
//    }
    
    
    
    //MARK:- 删除
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 
        if tableView == self.myTabView{
            
            if editingStyle == .delete {
                
                let logId = (self.dataArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "logId") as! String
                
                print(logId)
                
                self.deleteAct(logId,indexPath: indexPath,tabView: tableView)
                
                
                
                print("删除")
                
            }
            
            
        }
        
        
    }
    
    var finish:JGProgressHUD!
    
    func deleteAct(_ logId:String,indexPath:IndexPath,tabView:UITableView){
        //删除
        //删除
        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = "删除中"
        self.finish.show(in: self, animated: true)
        
        print("删除")
        
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/event/newLog.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "removeid":logId,
        ]
        
        print(dicDPost)
        
      
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
            
            var codes = 0
            if let tmpData:Int = json["code"].int{
                codes = tmpData
            }
            
            if (codes == 1){
                //成功
                
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "删除成功"
                self.finish.dismiss(afterDelay: 1.0, animated: true)
                
                
                self.dataArray.removeObject(at: (indexPath as NSIndexPath).row)
                
                tabView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)

                self.CleanCompelete?((self.sRTopView.timeBtn.titleLabel?.text)!)
                
                
            }else{
                //失败
                
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "删除失败"
                self.finish.dismiss(afterDelay: 0.5, animated: true)
                
                let alertView:UIAlertView = UIAlertView(title: "温馨提示", message: "删除失败了", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
            }
            
            
            }, failure: { () -> Void in
                
                print("false")
                
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "网络错误"
                self.finish.dismiss(afterDelay: 0.5, animated: true)
                
        })
        
    }
    
    //分割线
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        
        
    }
    
    
    
    

}
