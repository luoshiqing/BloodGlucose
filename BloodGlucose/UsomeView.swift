//
//  UsomeView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/29.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class UsomeView: UIView {

    var UsomeSize:CGSize!
    
    override func draw(_ rect: CGRect) {
        
        self.UsomeSize = self.frame.size
        
        let xiantView = UIView(frame: CGRect(x: 8,y: 21,width: self.frame.size.width - 16,height: 1))
        xiantView.backgroundColor = UIColor(red: 195/255.0, green: 195/255.0, blue: 195/255.0, alpha: 1)
        self.addSubview(xiantView)
        
        
        
        self.loadLitterView()
        
    }
    
    
    var bjDic = NSDictionary()
    
    
    //设置数值
    func setUsomeViewData(_ bj:NSDictionary){
        
        self.bjDic = bj
        
        
        if let completionArray:NSArray = bj.value(forKey: "completion") as? NSArray {

            print(completionArray)
            for item in 0...self.valueArray.count - 1 {
                print(self.valueArray.count)
                print(item)
                
                let tmpLabel = self.valueArray[item] as! UILabel
                let valueDic = completionArray[item] as! NSDictionary
                
                
                

                
                let superView = self.avgSuperViewArray[item] as! UIView
                let subView = self.avgSubViewArray[item] as! UIView
                //max 值
                let chartmax1 = valueDic.value(forKey: "chartmax") as! Int
                
                
                
                let chartmax:Float = Float(chartmax1) / 10
                
                //值
                let value = valueDic.value(forKey: "value") as! String
                
                let unid = valueDic.value(forKey: "unid") as! Int
                
                
                
                
                
//                print("chartmax:\(chartmax)")
                
                
                let superFram = superView.frame.size.width
                
                var valueDouble = Double(value)!
                let chartmaxDouble = Double(chartmax)
                
                //设置数值label
                let valueFloat = Float(value)!
                //设置颜色
                if valueFloat > chartmax / 2 {
                    tmpLabel.textColor = UIColor(red: 238/255.0, green: 35/255.0, blue: 35/255.0, alpha: 1)
                }else{
                    tmpLabel.textColor = UIColor(red: 32/255.0, green: 198/255.0, blue: 55/255.0, alpha: 1)
                }
                //赋值
                if unid == 0 {

                    tmpLabel.text = "\(value)"
                }else{
                    tmpLabel.text = "\(value)%"
                }
//                print(valueDouble,chartmaxDouble)
                
                if valueDouble > chartmaxDouble{
                    valueDouble = chartmaxDouble
                }
                
                let Wsize = CGFloat(valueDouble / chartmaxDouble) * superFram
//                print(Wsize)
                subView.frame.size.width = Wsize
                

                //底部三label
                let threeArray = self.threeLabelArray[item] as! NSMutableArray
                
                let leftLabel = threeArray[0] as! UILabel
                let miderLabel = threeArray[1] as! UILabel
                let rightLabel = threeArray[2] as! UILabel
                
                let miderValue = Float(chartmax) / 2.0
                
                //设置最大值
                if unid == 0 {
                    leftLabel.text = "(0)"
                    
                    miderLabel.text = "(\(miderValue))"
                    
//                    rightLabel.text = "\(chartmax)"
                    
                    rightLabel.text = "(\(chartmax))"
                    
                }else{
                    //百分比
                    leftLabel.text = "(0)%"
                    miderLabel.text = "(\(Int(miderValue))%)"
                    
                    rightLabel.text = "(\(Int(chartmax))%)"
                }
                
                
            }
            
            
            
        }
        
        
        
    }
    
    

    
    var uRepViewCtr:UIViewController!
    
    var bomtView:UIView!
    var pushView:PushView!
    
    //MARK:AVG小图视图点击
    func viewTap(_ send:UITapGestureRecognizer){
        print(send.view!.tag)
        print("点击小视图了")

        if let completion = self.bjDic.value(forKey: "completion") as? NSArray{
            
            let value = completion[send.view!.tag] as! NSDictionary
            
            let desc = value.value(forKey: "desc") as! String
            let doctorAdvise = value.value(forKey: "doctorAdvise") as! String
            let dieticianAdvise = value.value(forKey: "dieticianAdvise") as! String
            
            
            if self.bomtView == nil {
                self.bomtView = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height - 64))
                
                self.bomtView.backgroundColor = UIColor.black
                self.bomtView.alpha = 0.4
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(UsomeView.closeView))
                self.bomtView.addGestureRecognizer(tap)
                self.uRepViewCtr.view.addSubview(self.bomtView)
            }
            
            if (self.pushView == nil) {
                
                let Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
                
                self.pushView = Bundle.main.loadNibNamed("PushView", owner: nil, options: nil)?.first as! PushView
                
                self.pushView.frame = CGRect(x: 40,y: (UIScreen.main.bounds.height - 64 - 200 * Hsize) / 2, width: UIScreen.main.bounds.width - 80 , height: 200 * Hsize)
                //设置 圆角
                self.pushView.layer.cornerRadius = 5.0
                self.pushView.clipsToBounds = true
                self.uRepViewCtr.view.addSubview(pushView)
                
                self.pushView.titleLabel.text = self.nameArray[send.view!.tag]
                self.pushView.textLabel.text = "\(desc)\n\n医生建议:\n\(doctorAdvise)\n\n饮食建议:\n\(dieticianAdvise)"
                
            }
            
            
            
        }else{
            
            let alrte = UIAlertView(title: "暂无数据", message: "请监测后再查看", delegate: nil, cancelButtonTitle: "确定")
            alrte.show()
   
        }
    
        
    }
    
    
    func closeView(){
        
        if self.bomtView != nil {
            self.bomtView.removeFromSuperview()
            self.bomtView = nil
        }
        if self.pushView != nil {
            self.pushView.removeFromSuperview()
            self.pushView = nil
        }
        
    }
    
    
    
    
    
    
    
    
    //视图数组
    
    var avgSuperViewArray = NSMutableArray() //进度条父视图
    var avgSubViewArray = NSMutableArray()  //进度条视图
    var threeLabelArray = NSMutableArray()  //三个分段值label
    var valueArray = NSMutableArray()       //值
    
    
    
    var nameArray = ["平均血糖值","HBA1C预测","低血糖占时间比","高血糖占时间比","早餐前1h平均血糖","午餐后2h平均血糖","血糖波动系数","血糖波动幅度"]
    
    var imgArray = ["uAvg","uTest","uMin","uMax","uFood","uAff","uB1","uB2"]
    
    func loadLitterView(){
        
        self.valueArray.removeAllObjects()
        
        let width = (self.UsomeSize.width - 8 * 3) / 2
        
        for i in 0..<4 {
            
            for j in 0..<2 {
                //大视图
                let avgView = UIView(frame: CGRect(x: 8 + CGFloat(j) * (width + 8) ,y: 41 + CGFloat(i) *  (120 + 8) ,width: width,height: 120))
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(UsomeView.viewTap(_:)))
                avgView.addGestureRecognizer(tap)
                avgView.tag = i * 2 + j
                
                avgView.layer.cornerRadius = 4
                avgView.clipsToBounds = true
                
                avgView.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)

                self.addSubview(avgView)
                
                //图片
                let img = UIImageView(frame: CGRect(x: 12.5, y: 5, width: 33.5, height: 33.5))
                img.image = UIImage(named: "\(self.imgArray[i * 2 + j])")
                avgView.addSubview(img)
                
                //数字
                let numLabel = UILabel(frame: CGRect(x: avgView.frame.size.width - 110 - 5,y: 5.5,width: 110,height: 32))
                numLabel.textColor = UIColor.red
                numLabel.font = UIFont.systemFont(ofSize: 26)
                numLabel.textAlignment = .right
                numLabel.text = "0.0"
                avgView.addSubview(numLabel)

                //--------------添加到数组---------------
                self.valueArray.add(numLabel)
                //-------------------------------------
                
                
                //标题
                let titLabel = UILabel(frame: CGRect(x: 12,y: 48.5,width: 140,height: 16))
                titLabel.textColor = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1)
                titLabel.font = UIFont.systemFont(ofSize: 16)
                
                titLabel.text = self.nameArray[i * 2 + j]
                avgView.addSubview(titLabel)
                
                //视图View
                //底部父图
                let superView = UIView(frame: CGRect(x: 12,y: 72.5,width: avgView.frame.size.width - 12 * 2,height: 10))
                superView.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
                
                superView.layer.cornerRadius = 4
                superView.layer.masksToBounds = true
                
                avgView.addSubview(superView)
                
                //--------------添加到数组---------------
                self.avgSuperViewArray.add(superView)
                //-------------------------------------
                
                //上层视图
                let subView = UIView(frame: CGRect(x: 0,y: 0,width: 0,height: superView.frame.size.height))
                subView.backgroundColor = UIColor(red: 249/255.0, green: 168/255.0, blue: 19/255.0, alpha: 1)
                
                subView.layer.cornerRadius = 4
                subView.layer.masksToBounds = true
                
                superView.addSubview(subView)
                
                //--------------添加到数组---------------
                self.avgSubViewArray.add(subView)
                //-------------------------------------
                
                //三个点视图
                let leftPointView = UIView(frame: CGRect(x: 2,y: (superView.frame.height - 5) / 2,width: 5,height: 5))
                leftPointView.backgroundColor = UIColor(red: 251/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1)
                
                leftPointView.layer.cornerRadius = 2.5
                leftPointView.clipsToBounds = true
                
                superView.addSubview(leftPointView)
                
                let miderPointView = UIView(frame: CGRect(x: (superView.frame.width - 5) / 2,y: (superView.frame.height - 5) / 2,width: 5,height: 5))
                miderPointView.backgroundColor = UIColor(red: 32/255.0, green: 198/255.0, blue: 55/255.0, alpha: 1)
                miderPointView.layer.cornerRadius = 2.5
                miderPointView.clipsToBounds = true
                superView.addSubview(miderPointView)
                
                let rightPointView = UIView(frame: CGRect(x: superView.frame.width - 2 - 5,y: (superView.frame.height - 5) / 2,width: 5,height: 5))
                rightPointView.backgroundColor = UIColor(red: 251/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1)
                rightPointView.layer.cornerRadius = 2.5
                rightPointView.clipsToBounds = true
                superView.addSubview(rightPointView)
                
                
                //底部区间label
                //临时存放三个label数组
                let tmpArray = NSMutableArray()
                
                let www:CGFloat = 35
                let hhh:CGFloat = 8
                
                let leftLabel = UILabel(frame: CGRect(x: 10,y: 87.5,width: www,height: hhh))
                leftLabel.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
                leftLabel.font = UIFont.systemFont(ofSize: 10)
                leftLabel.text = "(0%)"
                avgView.addSubview(leftLabel)
                
                tmpArray.add(leftLabel)
                
                let miderLabel = UILabel(frame: CGRect(x: (avgView.frame.size.width - www) / 2,y: 87.5,width: www,height: hhh))
                miderLabel.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
                miderLabel.font = UIFont.systemFont(ofSize: 10)
                miderLabel.textAlignment = .center
                miderLabel.text = "(50%)"
                avgView.addSubview(miderLabel)
                
                tmpArray.add(miderLabel)
                
                let rightLabel = UILabel(frame: CGRect(x: avgView.frame.size.width - www - 10,y: 87.5,width: www,height: hhh))
                rightLabel.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
                rightLabel.font = UIFont.systemFont(ofSize: 10)
                rightLabel.textAlignment = .right
                rightLabel.text = "(100%)"
                avgView.addSubview(rightLabel)
                
                tmpArray.add(rightLabel)
                
                //--------------添加到数组---------------
                self.threeLabelArray.add(tmpArray)
                //-------------------------------------
                
                
                
                //底部 偏低 正常 偏高 文字
                
                let Dww:CGFloat = 28
                let Dhh:CGFloat = 8
                
                let DleftLabel = UILabel(frame: CGRect(x: 10,y: 103,width: Dww,height: Dhh))
                DleftLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
                DleftLabel.font = UIFont.systemFont(ofSize: 13)
                DleftLabel.text = "偏低"
                avgView.addSubview(DleftLabel)
                
                let DmiderLabel = UILabel(frame: CGRect(x: (avgView.frame.size.width - Dww) / 2,y: 103,width: Dww,height: Dhh))
                DmiderLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
                DmiderLabel.font = UIFont.systemFont(ofSize: 13)
                DmiderLabel.text = "正常"
                DmiderLabel.textAlignment = .center
                avgView.addSubview(DmiderLabel)
                
                let DrightLabel = UILabel(frame: CGRect(x: avgView.frame.size.width - Dww - 10,y: 103,width: Dww,height: Dhh))
                DrightLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
                DrightLabel.font = UIFont.systemFont(ofSize: 13)
                DrightLabel.text = "偏高"
                DrightLabel.textAlignment = .right
                avgView.addSubview(DrightLabel)
                
                
                
                
            }
            
            
        }
        
        
        
    }

}
