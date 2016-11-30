//
//  SexView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/18.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

protocol SexViewDelegate {
    func selectValue(_ value:String)
}




class SexView: UIView ,UITableViewDataSource,UITableViewDelegate{

    var delegate:SexViewDelegate!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var typeTabView: UITableView!
    
    
    var sexDataArray = NSMutableArray()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    func initSetup(){
        
        self.typeTabView.dataSource = self
        self.typeTabView.delegate = self
        
        self.typeTabView.tableFooterView = UIView()
        
        self.typeTabView.reloadData()
        
    }
    
    func loadTypeTabView(){
        self.typeTabView.reloadData()
    }
    
    //Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sexDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ddd = "SexCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? SexTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("SexTableViewCell", owner: self, options: nil )?.last as? SexTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        if self.sexDataArray.count > 0 {
            cell?.nameLabel.text = "\(self.sexDataArray[(indexPath as NSIndexPath).row] as! String)"
        }
        
        //设置选中cell 时的颜色
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        return cell!
    }
   
    
    
    
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let name = "\(self.sexDataArray[(indexPath as NSIndexPath).row])"
 
        self.typeTabView.reloadData()
        
        if self.delegate != nil {
            self.delegate.selectValue(name)
        }
        

        
    }
    
    
    

}
