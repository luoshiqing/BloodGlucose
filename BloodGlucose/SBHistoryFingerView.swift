//
//  SBHistoryFingerView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/29.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SBHistoryFingerView: UIView ,UITableViewDelegate ,UITableViewDataSource{

    //按钮回调
    typealias SBHistoryFingerViewCloseClourse = (_ tag: Int) -> Void
    var closeClourse:SBHistoryFingerViewCloseClourse?
    
    //删除回调
    typealias SBHistoryFingerViewDeleteClourse = (_ fingerBloodArray: [Any]) -> Void
    var deleteClourse:SBHistoryFingerViewDeleteClourse?
    //编辑指血
    
    typealias SBHistoryFingerViewEditFingerClourse = (_ index: Int,_ date: Date,_ fingerBlood: String) -> Void
    var editFingerClourse:SBHistoryFingerViewEditFingerClourse?
    
    
    fileprivate let myWidth = UIScreen.main.bounds.size.width
    fileprivate let myHeight = UIScreen.main.bounds.size.height
    
    
    //比例
    fileprivate let WScale = UIScreen.main.bounds.size.width / 375
    fileprivate let Hscale = UIScreen.main.bounds.size.height / 667
    
    
    //左右边距
    fileprivate let leftWidth: CGFloat = 15
    //main高度
    fileprivate let mainH: CGFloat = 387
    
    var bgView: UIView!
    var mainView: UIView!
    
    var myTabView: UITableView!
    
    fileprivate let oColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
    
    
    //数据源
    fileprivate var myFigerDataArray = [Any]()
    
    func initSBHistoryFingerView(_ figerBloodArray: [Any]?){
        
        print("figerBloodArray!-->\(figerBloodArray!)")
        
        if let dataArray = figerBloodArray {
//            self.myFigerDataArray.addObjects(from: dataArray as [AnyObject])
            self.myFigerDataArray += dataArray
        }

        if bgView == nil {
            bgView = UIView(frame: CGRect(x: 0,y: 0,width: myWidth,height: myHeight))
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 0.25

            let tap = UITapGestureRecognizer(target: self, action: #selector(SBHistoryFingerView.someViewAct(_:)))
            bgView.addGestureRecognizer(tap)
            bgView.tag = 3
            
            UIApplication.shared.keyWindow?.addSubview(bgView)
      
        }
        
        if mainView == nil {
            
            let mainHi = mainH * Hscale //高度
            let mainWi = myWidth - leftWidth * 2 //宽度
            
            mainView = UIView(frame: CGRect(x: leftWidth,y: (myHeight - mainHi) / 2,width: mainWi,height: mainHi))
            mainView.backgroundColor = UIColor.white
            
            mainView.alpha = 0
            mainView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
            
            mainView.layer.cornerRadius = 3
            mainView.layer.masksToBounds = true
            
            
            UIApplication.shared.keyWindow?.addSubview(mainView)
            
            
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
                self.mainView.alpha = 1
                self.mainView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            
            //标题视图
            let th: CGFloat = 40
            
            let titleView = UIView(frame: CGRect(x: 0,y: 0,width: mainWi,height: th))
            titleView.backgroundColor = oColor
            
            mainView.addSubview(titleView)
            
            //关闭按钮
            let closeBtn = UIButton(frame: CGRect(x: 0,y: 0,width: th,height: th))
            closeBtn.setImage(UIImage(named: "SBclose"), for: UIControlState())
            closeBtn.setImage(UIImage(named: "SBclose"), for: UIControlState.highlighted)

            closeBtn.addTarget(self, action: #selector(SBHistoryFingerView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            closeBtn.tag = 0
            
            titleView.addSubview(closeBtn)
            
            //标题
            let titleLabel = UILabel(frame: CGRect(x: (mainWi - 100) / 2,y: 0,width: 100,height: th))
            titleLabel.text = "历史指血"
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont(name: PF_SC, size: 17)
            titleLabel.textAlignment = .center
            titleView.addSubview(titleLabel)
            
            //中部tabView
            
            let tabH: CGFloat = mainHi - 40 - 30 - 50 - 10
            
            
            myTabView = UITableView(frame: CGRect(x: 0,y: 40,width: mainWi,height: tabH))
            
            myTabView.delegate = self
            myTabView.dataSource = self
            
            myTabView.tableFooterView = UIView()
            
            self.mainView.addSubview(myTabView)
            
 
            
            //计算血糖按钮
            
            let toLeft: CGFloat = 25
            
            let toCalculateBtn = UIButton(frame: CGRect(x: toLeft,y: mainHi - 30 - 50,width: 95,height: 30))
            
            toCalculateBtn.layer.cornerRadius = 2
            toCalculateBtn.layer.masksToBounds = true
            toCalculateBtn.layer.borderWidth = 0.5
            toCalculateBtn.layer.borderColor = self.oColor.cgColor

            toCalculateBtn.setTitle("计算血糖", for: UIControlState())
            toCalculateBtn.setTitleColor(self.oColor, for: UIControlState())
            toCalculateBtn.titleLabel?.font = UIFont(name: PF_SC, size: 15)
            toCalculateBtn.addTarget(self, action: #selector(SBHistoryFingerView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            toCalculateBtn.tag = 1
            self.mainView.addSubview(toCalculateBtn)
            
            //添加指血
            let addBloodBtn = UIButton(frame: CGRect(x: mainWi - toLeft - 95,y: mainHi - 30 - 50,width: 95,height: 30))
            
            addBloodBtn.layer.cornerRadius = 2
            addBloodBtn.layer.masksToBounds = true
            addBloodBtn.layer.borderWidth = 0.5
            addBloodBtn.layer.borderColor = self.oColor.cgColor
            
            addBloodBtn.setTitle("添加指血", for: UIControlState())
            addBloodBtn.setTitleColor(self.oColor, for: UIControlState())
            addBloodBtn.titleLabel?.font = UIFont(name: PF_SC, size: 15)
            addBloodBtn.addTarget(self, action: #selector(SBHistoryFingerView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            addBloodBtn.tag = 2
            self.mainView.addSubview(addBloodBtn)
            
            
            
            
            //提示label
            let promptLabel = UILabel(frame: CGRect(x: 0,y: mainHi - 40 - 6,width: mainWi,height: 40))
            promptLabel.textAlignment = .center
            promptLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
            promptLabel.text = "提示：向左滑动即可删除血糖\n点击可修改血糖"
            
            promptLabel.numberOfLines = 0
            
            promptLabel.font = UIFont(name: PF_SC, size: 12)
            self.mainView.addSubview(promptLabel)
            
            
     
        }
        
    
        
        
    }
    
    
    
    func someViewAct(_ send: UITapGestureRecognizer){
        
        self.closeClourse?(send.view!.tag)
        
        self.dismiss()
    }
    func someBtnAct(_ send: UIButton){
        print(send.tag)
        
        switch send.tag {
        case 0:
            print("关闭")
        case 1:
            print("计算血糖")
        case 2:
            print("添加指血")
        default:
            break
        }
        
        self.closeClourse?(send.tag)
        self.dismiss()
    }
    
    
    
    func dismiss(){
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
            
            if self.mainView != nil{
                self.mainView.alpha = 0
                self.mainView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
            
            
        }) { (cop: Bool) in
            
            if self.bgView != nil{
                self.bgView.removeFromSuperview()
                self.bgView = nil
            }
            
            if self.mainView != nil{
                self.mainView.removeFromSuperview()
                self.mainView = nil
            }
     
        }
  
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myFigerDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "SBHFCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? SBHistoryFingerTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("SBHistoryFingerTableViewCell", owner: self, options: nil )?.last as? SBHistoryFingerTableViewCell
            
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        
        let blood = (self.myFigerDataArray[(indexPath as NSIndexPath).row] as! NSArray) [0] as? String
        
        let date = (self.myFigerDataArray[(indexPath as NSIndexPath).row] as! NSArray)[1] as? Date
        
 
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy.MM.dd/HH:mm"
        formatter.dateFormat = "MM-dd   HH:mm"
        let timeStr = formatter.string(from: date!)
    
//        let value = (timeStr as NSString).substringWithRange(NSRange(0...15))
        
        
        cell?.fingerBloodLabel.text = "\(blood!) mmol/L"
        cell?.dateLabel.text = timeStr
        
        return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((indexPath as NSIndexPath).row)
  
        print(self.myFigerDataArray[(indexPath as NSIndexPath).row])
        
        let fingerBlood = (self.myFigerDataArray[(indexPath as NSIndexPath).row] as! NSArray)[0] as! String
        let date = (self.myFigerDataArray[(indexPath as NSIndexPath).row] as! NSArray)[1] as! Date
        
        self.editFingerClourse?((indexPath as NSIndexPath).row,date,fingerBlood)
        
        self.dismiss()
        
 
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.delete
    }

    
    //MARK:- 删除
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if tableView == self.myTabView{
            
            if editingStyle == .delete {
                
                print(self.myFigerDataArray)
                
                
                if self.myFigerDataArray.count > 1{
//                    self.myFigerDataArray.removeObject(at: (indexPath as NSIndexPath).row)
                    self.myFigerDataArray.remove(at: indexPath.row)
                    
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
                    
                    print("删除")
                    
                    self.deleteClourse?(self.myFigerDataArray)
                }else{
                    let alret = UIAlertView(title: "不能删除所有指血", message: "至少保留一个指血", delegate: nil, cancelButtonTitle: "确定")
                    alret.show()
                }
                
                
                
                
                
                
            }
            
            
        }
        
        
    }
    
    

}
