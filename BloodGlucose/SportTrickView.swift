//
//  SportTrickView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/13.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SportTrickView: UIView {

    //最低强度运动
    @IBOutlet weak var minHeadLabel: UILabel!
    @IBOutlet weak var minBodyLabel: UILabel!
    @IBOutlet weak var minMainLabel: UILabel!
    //低强度运动
    @IBOutlet weak var smartHeadLabel: UILabel!
    @IBOutlet weak var smartBodyLabel: UILabel!
    @IBOutlet weak var smartMainLabel: UILabel!
    
    //中强度运动
    @IBOutlet weak var middleHeadLabel: UILabel!
    @IBOutlet weak var middleBodyLabel: UILabel!
    @IBOutlet weak var middleMainLabel: UILabel!
     
    //高强度运动
    @IBOutlet weak var highHeadLabel: UILabel!
    @IBOutlet weak var highBodyLabel: UILabel!
    @IBOutlet weak var highMainLabel: UILabel!
    
    
    //图片的高度
    @IBOutlet weak var minImgH: NSLayoutConstraint!//65
    @IBOutlet weak var smartImgH: NSLayoutConstraint!
    @IBOutlet weak var middleImgH: NSLayoutConstraint!
    @IBOutlet weak var highImgH: NSLayoutConstraint!
    
    //健康运动建议
    @IBOutlet weak var healthTextView: UITextView!
    @IBOutlet weak var healthBodyLabel: UILabel!
    
    
    func addSomeObjToArray() ->(NSMutableArray,NSMutableArray,NSMutableArray){
        
        let headArray = NSMutableArray() //标题
        let bodyArray = NSMutableArray()//主体
        let mainArray = NSMutableArray()//主要
        
        //标题
        headArray.add(minHeadLabel)
        headArray.add(smartHeadLabel)
        headArray.add(middleHeadLabel)
        headArray.add(highHeadLabel)
        //主体
        bodyArray.add(minBodyLabel)
        bodyArray.add(smartBodyLabel)
        bodyArray.add(middleBodyLabel)
        bodyArray.add(highBodyLabel)
        //主要
        mainArray.add(minMainLabel)
        mainArray.add(smartMainLabel)
        mainArray.add(middleMainLabel)
        mainArray.add(highMainLabel)
        
        
        return (headArray,bodyArray,mainArray)
        
    }
    
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        
        
        
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        healthTextView.font = UIFont.systemFont(ofSize: 16)
        healthTextView.textColor = UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
    }
    
    func initSetup(){
        //布局
        let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
        
        self.minImgH.constant = Hsize * 65
        self.smartImgH.constant = Hsize * 65
        self.middleImgH.constant = Hsize * 65
        self.highImgH.constant = Hsize * 65
        
    }
    
    func setSportTrickViewData(_ dataDic:NSDictionary){
        
        let (headArray,bodyArray,mainArray) = self.addSomeObjToArray()
        

        //运动建议
        let sprot = dataDic.value(forKey: "sport") as! String
        let comolica = dataDic.value(forKey: "comolica") as! String //后面的症状
        
        //赋值
        self.healthTextView.text = sprot
        self.healthBodyLabel.text = comolica
        
        //运动数据列表
        let sportlist = dataDic.value(forKey: "sportlist") as! NSArray
        
        for item in 0...sportlist.count - 1 {
            let headLabel = headArray[item] as! UILabel
            let bodyLabel = bodyArray[item] as! UILabel
            let mainLabel = mainArray[item] as! UILabel
            
            let tmpDic = sportlist[item] as! NSDictionary
            //head
            let head = tmpDic.value(forKey: "name") as! String
            //body
            let time = tmpDic.value(forKey: "time") as! String
            let heat = tmpDic.value(forKey: "heat") as! String
            //main
            let exa = tmpDic.value(forKey: "exa") as! String
            
            
            //赋值
            headLabel.text  = head
            bodyLabel.text = "(持续时间\(time)分钟，消耗\(heat)千卡)"
            mainLabel.text = exa

        }
        
        
    }

    
    
    
    
}
