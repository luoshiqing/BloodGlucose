//
//  SBLeftMeunView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/21.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SBLeftMeunView: UIView ,UITableViewDelegate ,UITableViewDataSource{

    
    typealias SBLeftMeunViewTabViewSecClourse = (_ row: Int)->Void
    var tabViewSecClourse:SBLeftMeunViewTabViewSecClourse?
    
    fileprivate var triangle_height: CGFloat = 11

    var myTabView: UITableView!
    
    
    var nameArray = ["更换设备","断开连接","设备日志"]
    var imgArray = ["exchange","disconnect","theLog"]
    
    
    
    var tab_height: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        
        
        
        self.drawTriangle()
        
        
        tab_height = rect.height - triangle_height
        
        let myView = UIView(frame: CGRect(x: 0,y: triangle_height,width: rect.width,height: tab_height))
        
        myView.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        myView.layer.cornerRadius = 2
        myView.layer.masksToBounds = true
        
        self.addSubview(myView)
        
        let size = myView.frame.size
        myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        
        myTabView.delegate = self
        myTabView.dataSource = self
        
        myTabView.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        //分割线颜色
        myTabView.separatorColor = UIColor.white
        //关闭滑动
        myTabView.isScrollEnabled = false
        
        myView.addSubview(myTabView)
        
        
    }
 

    func drawTriangle(){
        
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.beginPath()
        
        context?.move(to: CGPoint(x: 12, y: self.triangle_height))
        
        context?.addLine(to: CGPoint(x: 12 + 4, y: 1))
        context?.addLine(to: CGPoint(x: 12 + 4 * 2, y: self.triangle_height))
        
        context?.closePath()
        
        UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).setFill()
        
        UIColor.clear.setStroke()
        
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.nameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tab_height + CGFloat(self.nameArray.count)) / CGFloat(self.nameArray.count)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ddd = "SBLeftCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? SBLeftTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("SBLeftTableViewCell", owner: self, options: nil )?.last as? SBLeftTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            width = 17.4
            height = 12.1
        case 1:
            width = 17.4
            height = 8.8
        default:
            width = 16
            height = 13
        }
        
        cell?.imgWidth.constant = width
        cell?.imgHeight.constant = height
        
        
        cell?.imgView.image = UIImage(named: self.imgArray[(indexPath as NSIndexPath).row])
        cell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row]

        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        return cell!
    }
    
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tabViewSecClourse?((indexPath as NSIndexPath).row)
        
        print((indexPath as NSIndexPath).row)
        self.myTabView.reloadData()
    }
    
    
    
    
    
}
