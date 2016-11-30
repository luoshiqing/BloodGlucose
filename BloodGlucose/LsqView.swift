//
//  LsqView.swift
//  CeLa
//
//  Created by sqluo on 16/9/8.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class LsqView: UIView ,UITableViewDelegate ,UITableViewDataSource{

    typealias lsqViewTouchClourse = (_ row: Int, _ name: String)->Void
    
    var touchClourse: lsqViewTouchClourse?
    
    
    fileprivate var bgView: UIView?
    fileprivate var mainView: UIView?
    
    
    fileprivate let MyScreen = UIScreen.main.bounds.size
    
    fileprivate var myTabView: UITableView?
    
    fileprivate var listArray: [[String]]!
    
    
    
    init(listArray: [[String]],frame: CGRect){
        
        super.init(frame: frame)
        
        
        self.listArray = listArray
        
        self.backgroundColor = UIColor.clear

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
    override func draw(_ rect: CGRect) {

        if self.bgView == nil {
            self.bgView = UIView(frame: CGRect(x: 0,y: 0,width: MyScreen.width,height: MyScreen.height))
            self.bgView?.backgroundColor = UIColor.clear

            let tap = UITapGestureRecognizer(target: self, action: #selector(LsqView.someViewAct(_:)))
            self.bgView?.addGestureRecognizer(tap)
            self.bgView?.tag = 0
            
            UIApplication.shared.keyWindow?.addSubview(self.bgView!)

        }
        
        if self.mainView == nil {

            self.mainView = UIView(frame: CGRect(x: 10,y: 70,width: rect.size.width,height: rect.size.height))
            
            self.mainView?.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            
            self.mainView?.layer.cornerRadius = 4
            self.mainView?.layer.masksToBounds = true
            
            UIApplication.shared.keyWindow?.addSubview(self.mainView!)
  
            self.setMyTabView(frame)
            
            
            self.myTabView?.frame.size.width = 0
            
            self.myTabView?.frame.size.height = 0
            
            
            
            self.mainView?.frame.size.width = 0
            self.mainView?.frame.size.height = 0
            
            
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: { 
                
                self.mainView?.frame.size.width = rect.size.width
                self.mainView?.frame.size.height = rect.size.height
      
   
                self.myTabView?.frame.size.width = rect.size.width
                
                self.myTabView?.frame.size.height = rect.size.height
                
                
                }, completion: nil)
    
        }
 
        
    }
 
    
    func setMyTabView(_ frame: CGRect){
        
        myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        myTabView?.delegate = self
        myTabView?.dataSource = self
        
        myTabView?.tableFooterView = UIView()
        
        myTabView?.backgroundColor = UIColor.clear
        
        myTabView?.showsVerticalScrollIndicator = false
        myTabView?.showsHorizontalScrollIndicator = false
        
        
        myTabView?.separatorColor = UIColor.white
        
        
        self.mainView?.addSubview(myTabView!)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.listArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "LsqCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? LsqTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("LsqTableViewCell", owner: self, options: nil )?.last as? LsqTableViewCell
            
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        if self.listArray != nil {
            let img = self.listArray[(indexPath as NSIndexPath).row][1]
            
            let name = self.listArray[(indexPath as NSIndexPath).row][0]
            
            cell?.imgView.image = UIImage(named: img)
            
            cell?.nameLabel.text = name
   
        }
        
        
        return cell!
        
    }

    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        self.touchClourse?((indexPath as NSIndexPath).row, self.listArray[(indexPath as NSIndexPath).row][0])
        
        self.dismiss()
    }
    
    
    func someViewAct(_ send: UITapGestureRecognizer){
        
        self.touchClourse?(99999, "取消")
 
        self.dismiss()
    }
    
    
    func dismiss(){
        
        
       UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
        

        
            self.mainView?.alpha = 0
            self.mainView?.alpha = 0
        
        
       }) { (cop: Bool) in
        
            self.bgView?.removeFromSuperview()
            self.bgView = nil
        
            self.mainView?.removeFromSuperview()
            self.mainView = nil
        
        
        }
        
        
    }
    
    
    
    
    

}
