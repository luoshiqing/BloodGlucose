//
//  SHelpRightView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/15.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SHelpRightView: UIView ,UITableViewDataSource ,UITableViewDelegate{

  
    var MattersNeedingAttentionMainrray = [String]()
    
    var myTabView: UITableView!
    
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
    
    var SHelpRightCell: SHelpRightTableViewCell!
    
    //MARK:tableView 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.MattersNeedingAttentionMainrray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
      
        
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
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "SHelpRightCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? SHelpRightTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("SHelpRightTableViewCell", owner: self, options: nil )?.last as? SHelpRightTableViewCell
            
        }
        
        SHelpRightCell = cell
        
//        switch indexPath.row {
//        case 12,16:
//            cell?.mainLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
//        default:
//            cell?.mainLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
//        }

        cell?.mainLabel.text = self.MattersNeedingAttentionMainrray[(indexPath as NSIndexPath).row]
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        
        return cell!
    }

    
    
    
    
    
    

}
