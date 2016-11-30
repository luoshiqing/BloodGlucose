//
//  SBloodDataView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/12.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SBloodDataView: UIView {

    
    
    fileprivate let topView_height: CGFloat = 30 //血糖数据高度
    
    fileprivate let bloodRecordView_hegit: CGFloat = 40 //血糖记录高度
    
    fileprivate let toLeft_width: CGFloat = 18.5 //距离左边的宽度

    fileprivate let toRight_width: CGFloat = 23 //距离右边的宽度
    
    
    var MONIARRAY = [AnyObject]()
    
    
    override func draw(_ rect: CGRect) {
        
        //血糖数据
        self.loadTopView(rect)
        
        //血糖记录
        self.loadBloodRecordView(rect)
       
        //表格视图
        self.loadFormView(rect)
        
        
    }
    
    //表格视图
    var sFormView: SFormView!
    func loadFormView(_ rect: CGRect){
        
        let frame_x: CGFloat = 15
        let frame_y: CGFloat = topView_height + bloodRecordView_hegit
        let frame_width: CGFloat = rect.width - 2 * frame_x
        let frame_height: CGFloat = rect.height - frame_y - 20
        
        sFormView = SFormView(frame: CGRect(x: frame_x, y: frame_y, width: frame_width, height: frame_height))
        sFormView.backgroundColor = UIColor.white
        
        
        
        
        sFormView.moniArray = MONIARRAY
        
        self.addSubview(sFormView)
    }
    
    
    
    
    //血糖记录
    func loadBloodRecordView(_ rect: CGRect){
        
        let blood_width: CGFloat = 150
        
        
        let bloodRecordView = UIView(frame: CGRect(x: rect.width - blood_width - toRight_width,y: topView_height,width: blood_width,height: bloodRecordView_hegit))
        bloodRecordView.backgroundColor = UIColor.white
        
        //添加点击事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(SBloodDataView.someViewAct(_:)))
        bloodRecordView.addGestureRecognizer(tap)
        bloodRecordView.tag = 0
        
        
        self.addSubview(bloodRecordView)
        
        //图标
        let img_width: CGFloat = 4.2
        let img_height: CGFloat = 8.3
        
        let blood_size = bloodRecordView.frame.size
        
        let imgView = UIImageView(frame: CGRect(x: blood_size.width - img_width, y: (blood_size.height - img_height) / 2, width: img_width, height: img_height))
        imgView.image = UIImage(named: "SRight")
        
        bloodRecordView.addSubview(imgView)
        
        //血糖记录label
        let bloodLabel = UILabel(frame: CGRect(x: 0,y: 0,width: blood_size.width - img_width - 3,height: blood_size.height))
        bloodLabel.textAlignment = .right
        bloodLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        bloodLabel.font = UIFont.systemFont(ofSize: 16)
        
        bloodLabel.text = "血糖记录"
        
        bloodRecordView.addSubview(bloodLabel)
        
        
    }
    
    
 
    //血糖数据
    func loadTopView(_ rect: CGRect){
        
        let topView = UIView(frame: CGRect(x: 0,y: 0,width: rect.width,height: topView_height))
        topView.backgroundColor = UIColor(red: 255/255.0, green: 235/255.0, blue: 227/255.0, alpha: 1)
        self.addSubview(topView)
        
        
        let topView_size = topView.frame.size
        
        let downLabel = UILabel(frame: CGRect(x: toLeft_width,y: 0,width: 150,height: topView_size.height))
        downLabel.text = "血糖数据"
        downLabel.textColor = UIColor(red: 116/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1)
        downLabel.font = UIFont.systemFont(ofSize: 16)
        
        topView.addSubview(downLabel)
        
    }
    
    
    func someViewAct(_ send: UITapGestureRecognizer){
        
        let tag = send.view!.tag
        
        switch tag {
        case 0:
            print("点击了->血糖记录")
        default:
            break
        }
        
        
        
        
        
    }
    
}
