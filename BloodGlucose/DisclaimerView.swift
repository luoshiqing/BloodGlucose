//
//  DisclaimerView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/24.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class DisclaimerView: UIView ,UITableViewDataSource ,UITableViewDelegate{

  
   
//    override func drawRect(rect: CGRect) {
//
//        self.readFillPath()
//        
//    }
 
    typealias DisclaimerViewOkClourse = ()->Void
    var okClourse: DisclaimerViewOkClourse?
    
    
    
    
    fileprivate var bgView: UIView?
    fileprivate var mainView: UIView?
    
    
    fileprivate var titLabel: UILabel?
    
    fileprivate var myTabView: UITableView?
    
    fileprivate var okBtn: UIButton?
    
    //展开
    fileprivate var openLabel: UILabel?

    //小
    //左边间距
    fileprivate let toLeftWidth: CGFloat = 40
    fileprivate var smallWidth: CGFloat!
    fileprivate let smallHeight: CGFloat = 254
    
    //大
    fileprivate let bigWidth = UIScreen.main.bounds.size.width
    fileprivate let bigHeight = UIScreen.main.bounds.size.height
    
    
    fileprivate var dataArray = [String]()
    
    fileprivate var currentWidth: CGFloat!
    
    func initDisclaimerView(){
        
        
        self.smallWidth = bigWidth - toLeftWidth * 2
        
        
        self.currentWidth = smallWidth
        
        self.readFillPath()
        
        if bgView == nil {
            bgView = UIView(frame: CGRect(x: 0,y: 0,width: bigWidth,height: bigHeight))
            bgView?.backgroundColor = UIColor.black
            bgView?.alpha = 0.3
            
            UIApplication.shared.keyWindow?.addSubview(bgView!)
   
        }
        
        if  mainView == nil {
            mainView = UIView(frame: CGRect(x: toLeftWidth,y: (bigHeight - smallHeight) / 2,width: self.smallWidth,height: smallHeight))
            mainView?.backgroundColor = UIColor.white
            
            
            
            UIApplication.shared.keyWindow?.addSubview(mainView!)
            
            
            titLabel = UILabel(frame: CGRect(x: 0,y: 0,width: smallWidth,height: 49))
            titLabel?.backgroundColor = UIColor().rgb(246, g: 93, b: 34, alpha: 1)
            titLabel?.text = "免责声明"
            titLabel?.textColor = UIColor.white
            titLabel?.font = UIFont(name: PF_SC, size: 18)
            titLabel?.textAlignment = .center
            
            mainView?.addSubview(titLabel!)
            
            
            
            
            
            okBtn = UIButton(frame: CGRect(x: (smallWidth - 143) / 2, y: smallHeight - 33 - 7,width: 143,height: 33))
            okBtn?.setTitle("我知道了", for: UIControlState())
            okBtn?.setTitleColor(UIColor().rgb(246, g: 93, b: 34, alpha: 1), for: UIControlState())
            okBtn?.titleLabel?.font = UIFont(name: PF_SC, size: 16)
            okBtn?.addTarget(self, action: #selector(DisclaimerView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            okBtn?.tag = 1
            
            okBtn?.layer.cornerRadius = 33 / 2.0
            okBtn?.layer.masksToBounds = true
            okBtn?.layer.borderWidth = 0.5
            okBtn?.layer.borderColor = UIColor().rgb(246, g: 93, b: 34, alpha: 1).cgColor
            
            mainView?.addSubview(okBtn!)
            
            
            openLabel = UILabel(frame: CGRect(x: 0,y: smallHeight - 33 - 7,width: 50,height: 30))
            openLabel?.backgroundColor = UIColor.clear
            openLabel?.textColor = UIColor().rgb(246, g: 93, b: 34, alpha: 1)
            openLabel?.font = UIFont(name: PF_SC, size: 15)
            openLabel?.text = "展开"
            openLabel?.textAlignment = .center
            
            openLabel?.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(DisclaimerView.someViewAct(_:)))
            openLabel?.addGestureRecognizer(tap)
            openLabel?.tag = 2
            
            
            mainView?.addSubview(openLabel!)
            
            
            myTabView = UITableView(frame: CGRect(x: 0, y: 49, width: smallWidth, height: smallHeight - 33 - 15 - 49))
            myTabView?.backgroundColor = UIColor.clear
            
            myTabView?.delegate = self
            myTabView?.dataSource = self
            
            myTabView?.separatorStyle = .none
            
            mainView?.addSubview(myTabView!)
            
      
        }
        
    
        
    }
    
    fileprivate func readFillPath(){
        let path: String = Bundle.main.path(forResource: "disclaimer", ofType: "txt")!
        
        do{
            let data = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            do{
                let json = try JSONSerialization.jsonObject(with: data.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String]
//                print(json)
                self.dataArray = json
            }catch{
                print(error)
            }
        }catch let erro as NSError{
            print(erro)
        }
    }
    
    
    
    
    
    
    func someBtnAct(_ send: UIButton){
        print("我知道了")
        
        self.okClourse?()
        
        self.dismiss()
    }
    
    
    fileprivate var isOpen = false
    
    func someViewAct(_ send: UITapGestureRecognizer){
        print("展开")
        
        if self.isOpen {
            
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { 
                
                self.mainView?.frame = CGRect(x: self.toLeftWidth,y: (self.bigHeight - self.smallHeight) / 2,width: self.smallWidth,height: self.smallHeight)
                
                self.titLabel?.frame = CGRect(x: 0, y: 0, width: self.smallWidth, height: 49)
                
                self.okBtn?.frame = CGRect(x: (self.smallWidth - 143) / 2, y: self.smallHeight - 33 - 7, width: 143, height: 33)
                
                self.openLabel?.frame = CGRect(x: 0, y: self.smallHeight - 33 - 7, width: 60, height: 30)
                
                self.myTabView?.frame = CGRect(x: 0, y: 49, width: self.smallWidth, height: self.smallHeight - 49 - 33 - 15)
                
                self.currentWidth = self.smallWidth
                self.myTabView?.reloadData()
     
                }, completion: { (cop: Bool) in
                    self.isOpen = false
                    self.openLabel?.text = "展开"
            })
            
     
            
        }else{
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                
                
                self.mainView?.frame = CGRect(x: 0, y: 0, width: self.bigWidth, height: self.bigHeight)
                
                self.titLabel?.frame = CGRect(x: 0, y: 0, width: self.bigWidth, height: 64)
                
                self.okBtn?.frame = CGRect(x: (self.bigWidth - 143) / 2, y: self.bigHeight - 33 - 15, width: 143, height: 33)
                
                self.openLabel?.frame = CGRect(x: 0, y: self.bigHeight - 33 - 15, width: 60, height: 30)
                
                self.myTabView?.frame = CGRect(x: 0, y: 64, width: self.bigWidth, height: self.bigHeight - 64 - 33 - 15 * 2)
                
                self.currentWidth = self.bigWidth
                self.myTabView?.reloadData()
                
            }) { (cop: Bool) in
                
                self.isOpen = true
                self.openLabel?.text = "收起"
                
                
                
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    func dismiss(){
        
        self.bgView?.removeFromSuperview()
        self.bgView = nil
        
        self.mainView?.removeFromSuperview()
        self.mainView = nil
        
        
        
    }
    
    
    
    //MARK:tableView 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
        
    }
    
    var SHelpRightCell: SHelpRightTableViewCell!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        if SHelpRightCell != nil {
            let labelText = SHelpRightCell?.mainLabel.text
            
            let string:NSString = labelText! as NSString
            
            let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
            
            let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
            
            let brect = string.boundingRect(with: CGSize(width: self.currentWidth - 30, height: 0), options: [options,a], attributes:  [NSFontAttributeName:(SHelpRightCell?.mainLabel.font)!], context: nil)
            
            return brect.height + (27 - 18)
        }else{
            return 27
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "SHelpRightCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? SHelpRightTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("SHelpRightTableViewCell", owner: self, options: nil )?.last as? SHelpRightTableViewCell
            
        }
        
        SHelpRightCell = cell
        
   
        cell?.mainLabel.text = self.dataArray[(indexPath as NSIndexPath).row]
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        
        return cell!
    }

    
    
    
    
    
    

}
