//
//  SHelpLeftView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/15.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SHelpLeftView: UIView ,UITableViewDataSource ,UITableViewDelegate{

 
    
    var myTabView: UITableView!
    
    var useInformationTitleArray = [String]()
    var useInformationMainArray = [String]()
    
    override func draw(_ rect: CGRect) {
        
        self.myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        
        self.myTabView.backgroundColor = UIColor.white
        
        self.myTabView.delegate = self
        self.myTabView.dataSource = self
        
 

        
        self.myTabView.showsVerticalScrollIndicator = false
        self.myTabView.showsHorizontalScrollIndicator = false
        
        
        self.myTabView.tableFooterView = UIView()
        
        
        self.myTabView.separatorStyle = .none
        
        self.addSubview(myTabView)
   
    }
    
    
    var SHelpLeftCell: SHelpLeftTableViewCell!
    
    var SHelpRightCell: SHelpRightTableViewCell!
    //MARK:tableView 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.useInformationTitleArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath as NSIndexPath).row {
        case 0,9,10,11,12:
            if SHelpRightCell != nil {
                let labelText = SHelpRightCell?.mainLabel.text
                
                let string:NSString = labelText! as NSString
                
                let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
                
                let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
                
                let brect = string.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 30, height: 0), options: [options,a], attributes:  [NSFontAttributeName:(SHelpRightCell?.mainLabel.font)!], context: nil)
                
                return brect.height + (27 - 18)
            }else{
                return 27
            }
        default:
            if SHelpLeftCell != nil {
                let labelText = SHelpLeftCell?.myMainLabel.text
                
                let string:NSString = labelText! as NSString
                
                let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
                
                let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
                
                let brect = string.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 30, height: 0), options: [options,a], attributes:  [NSFontAttributeName:(SHelpLeftCell?.myMainLabel.font)!], context: nil)
                
                return brect.height + (53 - 18)
            }else{
                return 53
            }
        }


    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch (indexPath as NSIndexPath).row {
        case 0,9,10,11,12:
            let ddd = "SHelpRightCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? SHelpRightTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("SHelpRightTableViewCell", owner: self, options: nil )?.last as? SHelpRightTableViewCell
                
            }
            
            SHelpRightCell = cell
            
            switch (indexPath as NSIndexPath).row {
            case 0,9:
                cell?.mainLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            default:
                cell?.mainLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
            }
            
            cell?.mainLabel.text = self.useInformationTitleArray[(indexPath as NSIndexPath).row]
            
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            
            return cell!
        default:
            let ddd = "SHelpLeftCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? SHelpLeftTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("SHelpLeftTableViewCell", owner: self, options: nil )?.last as? SHelpLeftTableViewCell
                
            }
            
            SHelpLeftCell = cell
            
            cell?.myTitleLabel.text = self.useInformationTitleArray[(indexPath as NSIndexPath).row]
            
            
            
            cell?.myMainLabel.text = self.useInformationMainArray[(indexPath as NSIndexPath).row]
            
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            
            return cell!
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
 

}
