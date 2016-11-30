//
//  CentTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/13.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class CentTableViewCell: UITableViewCell {

    
    //返回控制器
    var backCtr: UIViewController?

    //父类控制器
    var WJHomeCtr:UIViewController!
    
    let Wsize = UIScreen.main.bounds.width
    
    let imgArray = ["MJblood","MJmedic","MJfood","MJsport","MJdata"]
    let nameArray = ["血糖","药物","饮食","运动","统计"]
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let color = UIColor.white
        self.selectedBackgroundView = UIView(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = color
        
        
        
        //左右间距
        let def: CGFloat = 10
        //每个视图的宽度
        let one_width = (Wsize - def * 2) / CGFloat(imgArray.count)
        //每个视图的高度

        let one_height = (96 - 37 + (Wsize / 375) * 37)

        
        for index in 0..<imgArray.count {
            
            let tmpView = UIView(frame: CGRect(x: def + CGFloat(index) * one_width ,y: 0 ,width: one_width, height: one_height))
            tmpView.backgroundColor = UIColor.white
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(CentTableViewCell.someViewAct(_:)))
            tmpView.addGestureRecognizer(tap)
            tmpView.tag = index
            
            self.addSubview(tmpView)
            
            
            let tmpView_size = tmpView.frame.size
            
            //按钮
            let btn = UIButton(frame: CGRect(x: 0,y: 0,width: tmpView_size.width,height: tmpView_size.height - 15 - 15))
            btn.setImage(UIImage(named: imgArray[index]), for: UIControlState())
            btn.isUserInteractionEnabled = false
            tmpView.addSubview(btn)
            
            //文字
            let label = UILabel(frame: CGRect(x: 0,y: tmpView_size.height - 15 - 15,width: tmpView_size.width,height: 15))
            label.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = nameArray[index]
            tmpView.addSubview(label)
        }
        
     
    }

    
    func someViewAct(_ send: UITapGestureRecognizer){
        
        let tag = send.view!.tag
        
        switch tag {
        case 0:
            //血糖
            let bloodSugarVC = BloodSugarRecordViewController()
            
            bloodSugarVC.tmpCtr = self.backCtr

            self.WJHomeCtr.navigationController?.pushViewController(bloodSugarVC, animated: true)
        case 1:
            //药物
            

            let drugCtr = DrugViewController()
            drugCtr.isEdit = false
            self.WJHomeCtr.navigationController?.pushViewController(drugCtr, animated: true)
            
        case 2:
            //饮食
            let foodVC = SupAddFoddViewController(nibName: "SupAddFoddViewController", bundle: Bundle.main)
            self.WJHomeCtr.navigationController?.pushViewController(foodVC, animated: true)
        case 3:
            //运动
            let sportVC = SubSportViewController(nibName: "SubSportViewController", bundle: Bundle.main)
            self.WJHomeCtr.navigationController?.pushViewController(sportVC, animated: true)
        case 4:
            //统计

            let statisticalVC = StatisticalViewController()
            self.WJHomeCtr.navigationController?.pushViewController(statisticalVC, animated: true)
            
        default:
            break
        }
        
   
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
