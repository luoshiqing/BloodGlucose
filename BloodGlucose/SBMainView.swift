//
//  SBMainView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/21.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SBMainView: UIView {

    typealias SBMainViewViewActClourse = (_ tag: Int)->Void
    var viewActClourse:SBMainViewViewActClourse?
 
    fileprivate let Hsize = (UIScreen.main.bounds.height - 64 - 49) / (667 - 64 - 49)
    
    fileprivate let Wsize = UIScreen.main.bounds.width / 375
    
    fileprivate let myDefulatColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
    
    fileprivate var moveDialImgView: UIImageView?   //可移动的表盘
    
    fileprivate var staticDialImgView: UIImageView? //静止的刻度表盘
    
    fileprivate var dial_width: CGFloat = 280.0     //表盘的宽跟高
    
    fileprivate var oneTimeLabel: UILabel?          //单条数据的时间
    
    fileprivate var bloodNumLabel: UILabel?         //血糖数据
    
    fileprivate var mmolLabel: UILabel?             //mmol/L单位
    
    fileprivate var allTimeLabel: UILabel?          //监测总时长

    //-------底部--------
    fileprivate var currentStateImgView: UIImageView? //当前状态图片
    fileprivate var currentStateLabel: UILabel?      //当前状态文字
    fileprivate var hbA1cLabel: UILabel?            //HbA1c值
    
    fileprivate var numberBloodLabel: UILabel?      //指血次数
    fileprivate var refersBloodLabel: UILabel?      //指血校准次数
    
    
    
    fileprivate var printBloodView: UIView! // 输入指血
    fileprivate var addEventView: UIView! //添加事件
    fileprivate var upDataView: UIView! //上传数据
    
    fileprivate var lookChartView: UIView! //查看趋势
    fileprivate var lookDataView: UIView! //查看数据
    
    
    //底部主要背景视图
    fileprivate var bottomView: UIView!
    fileprivate var one_h: CGFloat! //每个高度
    
    fileprivate var down_widht: CGFloat! //每个宽度
    
    
    override func draw(_ rect: CGRect) {
        
        self.down_widht = rect.width / 3
        
        
        //静止的图片
        self.staticDialImgView = UIImageView(frame: CGRect(x: (rect.width - self.dial_width * self.Hsize) / 2, y: 28 * self.Hsize, width: self.dial_width * self.Hsize, height: self.dial_width * self.Hsize))
        
        print(self.Hsize)
        print(self.dial_width * self.Hsize)
        
        self.staticDialImgView?.image = UIImage(named: "pm1.png")
        self.addSubview(self.staticDialImgView!)
        
        //可移动图片
        self.moveDialImgView = UIImageView(frame: CGRect(x: (rect.width - self.dial_width * self.Hsize) / 2, y: 28 * self.Hsize, width: self.dial_width * self.Hsize, height: self.dial_width * self.Hsize))
        
        self.moveDialImgView?.image = UIImage(named: "pm6.png")
        self.addSubview(self.moveDialImgView!)
        
        let b_h: CGFloat = 65
        
        let move_size = self.moveDialImgView!.frame.size
        //单条数据时间
        oneTimeLabel = UILabel(frame: CGRect(x: (move_size.height - 100) / 2,y: move_size.height / 2 - b_h / 2 - 14 - 15,width: 100,height: 14))
        oneTimeLabel?.textColor = UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1)
        oneTimeLabel?.textAlignment = .center
        oneTimeLabel?.text = ""
        oneTimeLabel?.font = UIFont(name: PF_SC, size: 13)
        self.moveDialImgView?.addSubview(oneTimeLabel!)
        //血糖数据
        
        bloodNumLabel = UILabel(frame: CGRect(x: 0,y: (move_size.height - b_h) / 2,width: move_size.width,height: b_h))
        bloodNumLabel?.textColor = self.myDefulatColor
        bloodNumLabel?.textAlignment = .center
        bloodNumLabel?.text = ""
        
        //判断版本
        switch UIDevice.current.systemVersion.compare("9.0.0", options: NSString.CompareOptions.numeric) {
        case .orderedSame, .orderedDescending:
            bloodNumLabel?.font = UIFont(name: PF_TC, size: 63)
        default:
            bloodNumLabel?.font = UIFont.systemFont(ofSize: 63)
        }

        self.moveDialImgView?.addSubview(bloodNumLabel!)
        //单位
        let m_y: CGFloat = move_size.height / 2 + b_h / 2 + 32.5 * self.Hsize
        mmolLabel = UILabel(frame: CGRect(x: 0,y: m_y,width: move_size.width,height: 16))
        mmolLabel?.textAlignment = .center
        mmolLabel?.textColor = UIColor(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1)
//        mmolLabel.text = "mmol/L"
        mmolLabel?.text = "本次监测时长"
        mmolLabel?.font = UIFont(name: PF_SC, size: 13)
        self.moveDialImgView?.addSubview(mmolLabel!)
        //总时间
        let a_w: CGFloat = 85
        
        let a_y: CGFloat = move_size.height / 2 + b_h / 2 + 58 * self.Hsize
        
        allTimeLabel = UILabel(frame: CGRect(x: (move_size.width - a_w) / 2,y: a_y,width: a_w,height: 16 * self.Hsize))
        allTimeLabel?.text = ""
        allTimeLabel?.textColor = self.myDefulatColor
        allTimeLabel?.textAlignment = .center
        allTimeLabel?.font = UIFont(name: PF_SC, size: 15)
        self.moveDialImgView?.addSubview(allTimeLabel!)
        //时钟
//        let timeImgView = UIImageView(frame: CGRectMake((move_size.width / 2 - a_w / 2 - 13.4 * self.Hsize - 3), move_size.height - 50 * self.Hsize - 13.4 * self.Hsize + (16 - 13.4) / 2 * self.Hsize, 13.4 * self.Hsize, 13.4 * self.Hsize))
//        
//        timeImgView.image = UIImage(named: "SBtime.png")
//        self.moveDialImgView.addSubview(timeImgView)
        
        
        
        //底部视图
        let bottom_h: CGFloat = rect.height - (28 + dial_width + 10) * self.Hsize

        bottomView = UIView(frame: CGRect(x: 0,y: rect.height - bottom_h,width: rect.width,height: bottom_h))
        
        bottomView.backgroundColor = UIColor.yellow
        self.addSubview(bottomView)
        

        
        //每个高度
        let line = 3
        self.one_h = bottom_h / CGFloat(line)
        for index in 0...line - 1 {
            
            let vie = UIView(frame: CGRect(x: 0,y: CGFloat(index) * one_h,width: rect.width,height: one_h))
            
            vie.backgroundColor = UIColor.white
            
            bottomView.addSubview(vie)
    
            let tmp_width = vie.frame.size.width
            let tmp_height = vie.frame.size.height
            //横线条
            if index != line - 1{
                
                let lineView = UIView(frame: CGRect(x: 0,y: tmp_height - 0.5,width: rect.width,height: 0.5))
                lineView.backgroundColor = UIColor(red: 201/255.0, green: 201/255.0, blue: 201/255.0, alpha: 1)
                vie.addSubview(lineView)
            }
            
            

            switch index {
            case 0:
                //图片
                currentStateImgView = UIImageView(frame: CGRect(x: 51, y: tmp_height / 2 - 25 * self.Hsize - 3, width: 25 * self.Hsize, height: 25 * self.Hsize))
                currentStateImgView?.image = UIImage(named: "SBnormal")
                vie.addSubview(currentStateImgView!)
                //文字
                currentStateLabel = UILabel(frame: CGRect(x: 34,y: tmp_height / 2 + 3,width: 60,height: 14))
                currentStateLabel?.center.x = currentStateImgView!.center.x
                
                currentStateLabel?.text = "当前状态"
                currentStateLabel?.textAlignment = .center
                currentStateLabel?.textColor = UIColor(red: 114/255.0, green: 114/255.0, blue: 114/255.0, alpha: 1)
                currentStateLabel?.font = UIFont(name: PF_SC, size: 14)
                vie.addSubview(currentStateLabel!)
                
                //指血校准次数
                refersBloodLabel = UILabel(frame: CGRect(x: (tmp_width - 95) / 2 ,y: tmp_height / 2 + 3,width: 95,height: 15))

                refersBloodLabel?.text = "指血校准次数"
                refersBloodLabel?.textAlignment = .center
                refersBloodLabel?.textColor = UIColor(red: 114/255.0, green: 114/255.0, blue: 114/255.0, alpha: 1)
                refersBloodLabel?.font = UIFont(name: PF_SC, size: 14)
                vie.addSubview(refersBloodLabel!)
                
                //指血次数
                
                numberBloodLabel = UILabel(frame: CGRect(x: (tmp_width - 95) / 2 ,y: tmp_height / 2 - (21 + 3),width: 95,height: 21))
                numberBloodLabel?.center.x = refersBloodLabel!.center.x
                numberBloodLabel?.text = "0次"
                numberBloodLabel?.textAlignment = .center
                numberBloodLabel?.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
                numberBloodLabel?.font = UIFont(name: PF_SC, size: 25)
                vie.addSubview(numberBloodLabel!)
                
                
                
                //hbA1cLabel
                hbA1cLabel = UILabel(frame: CGRect(x: tmp_width - 50 - 51,y: tmp_height / 2 - 26 - 3,width: 50,height: 26))
                hbA1cLabel?.textAlignment = .center
                hbA1cLabel?.textColor = UIColor(red: 32/255.0, green: 198/255.0, blue: 55/255.0, alpha: 1)
                hbA1cLabel?.text = "0.0"
                hbA1cLabel?.font = UIFont(name: PF_SC, size: 23)
                vie.addSubview(hbA1cLabel!)
                
                let hbA1 = UILabel(frame: CGRect(x: tmp_width - 80 - 51,y: tmp_height / 2 + 3,width: 80,height: 15))
                hbA1.center.x = hbA1cLabel!.center.x
                hbA1.text = "HbA1c预测"
                hbA1.textAlignment = .center
                hbA1.textColor = UIColor(red: 114/255.0, green: 114/255.0, blue: 114/255.0, alpha: 1)
                hbA1.font = UIFont(name: PF_SC, size: 14)
                vie.addSubview(hbA1)
                
                
                
                
            case 1:
                let imgArray = ["SBprint","SBadd","SBup"]
                let nameArray = ["血糖校准","添加事件","上传数据"]
                
                for item in 0...2 {
                    
                    let i_view_w: CGFloat = tmp_width / 3
                    let i_view_h: CGFloat = tmp_height - 0.5
                    
                    let i_view = UIView(frame: CGRect(x: CGFloat(item) * i_view_w,y: 0,width: i_view_w,height: i_view_h))
                    i_view.backgroundColor = UIColor.white
                    vie.addSubview(i_view)

                    //点击
                    let tap = UITapGestureRecognizer(target: self, action: #selector(SBMainView.someViewAct(_:)))
                    i_view.addGestureRecognizer(tap)
                    i_view.tag = item
                    
                    var i_width: CGFloat = 24 * self.Hsize
                    var i_height: CGFloat = 21 * self.Hsize
                    
                    switch item {
                    case 0:
                        i_width = 23.8 * self.Hsize
                        i_height = 20.8 * self.Hsize
                    case 1:
                        i_width = 20.7 * self.Hsize
                        i_height = 19.9 * self.Hsize
                    case 2:
                        i_width = 23.5 * self.Hsize
                        i_height = 19.1 * self.Hsize
                    default:
                        break
                    }
                    
                    //父
                    let i_view_size = i_view.frame.size
                    //图片
                    let imgView = UIImageView(frame: CGRect(x: (i_view_size.width - i_width) / 2, y: i_view_size.height / 2 - i_height - 3, width: i_width, height: i_height))
                    imgView.image = UIImage(named: imgArray[item])
                    i_view.addSubview(imgView)
                    
                    //文字
                    let label = UILabel(frame: CGRect(x: 0,y: i_view_size.height / 2 + 3,width: i_view_size.width,height: 15))
                    label.text = nameArray[item]
                    label.textAlignment = .center
                    label.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
                    label.font = UIFont(name: PF_SC, size: 14)
                    i_view.addSubview(label)
                    
                    
                    //竖线
                    if item != 2 {
                        let columnView = UIView(frame: CGRect(x: i_view_size.width - 0.5,y: 0,width: 0.5,height: i_view_size.height))
                        columnView.backgroundColor = UIColor(red: 201/255.0, green: 201/255.0, blue: 201/255.0, alpha: 1)
                        i_view.addSubview(columnView)
  
                    }
                    
                    
                    
                }

                
            case 2:
                
                let imgArray = ["SBlookchart","SBlookdata"]
                let nameArray = ["动态图谱","数据管理"]
                
                
                for item in 0...1 {
                    
                    let tview_w: CGFloat = tmp_width / 2
                    let tview_h: CGFloat = tmp_height - 0.5
                    
                    let tview = UIView(frame: CGRect(x: CGFloat(item) * tview_w,y: 0,width: tview_w,height: tview_h))
                    tview.backgroundColor = UIColor.white
                    vie.addSubview(tview)
                    
                    //点击
                    let tap = UITapGestureRecognizer(target: self, action: #selector(SBMainView.someViewAct(_:)))
                    tview.addGestureRecognizer(tap)
                    tview.tag = 3 + item
                    
                    var w: CGFloat = 19 * self.Hsize
                    var h: CGFloat = 23 * self.Hsize
                    
                    switch item {
                    case 0:
                        w = 19.1 * self.Hsize
                        h = 22.6 * self.Hsize
                    case 1:
                        w = 20 * self.Hsize
                        h = 22.2 * self.Hsize
                    default:
                        break
                    }
                    //父
                    let size = tview.frame.size
                    //图
                    let imgView = UIImageView(frame: CGRect(x: size.width / 3 - w, y: (size.height - h) / 2, width: w, height: h))
                    imgView.image = UIImage(named: imgArray[item])
                    tview.addSubview(imgView)
                    //文
                    let label = UILabel(frame: CGRect(x: size.width / 3 + 13,y: (size.height - 18) / 2,width: size.width / 3 * 2 - 13,height: 18))
                    label.font = UIFont(name: PF_SC, size: 16)
                    label.text = nameArray[item]
                    label.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
                    tview.addSubview(label)
                    
                    
                    if item == 0 {
                        let columnView = UIView(frame: CGRect(x: size.width - 0.5,y: 0,width: 0.5,height: size.height))
                        columnView.backgroundColor = UIColor(red: 201/255.0, green: 201/255.0, blue: 201/255.0, alpha: 1)
                        tview.addSubview(columnView)
                    }
                    
    
                }
                
                
                
            default:
                break
            }
            
            
            
            
            
        }
   
        
//        self.loadSBMGGuidView()
        
    }
    
    var holedView: SBMGGuideView!
    func loadSBMGGuidView(){
        
        
        holedView = SBMGGuideView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height))
        holedView.backgroundColor = UIColor.clear
        
        holedView.okActClourse = self.SBMGGuideViewOkActClourse
        
        UIApplication.shared.keyWindow?.addSubview(holedView)
    }
    
    func SBMGGuideViewOkActClourse()->Void{
        if holedView != nil {
            holedView.removeFromSuperview()
            holedView = nil
        }
    }
    
 
    func someViewAct(_ send: UITapGestureRecognizer){
        
        let tag = send.view!.tag
        
        
        print(tag)
        
        self.viewActClourse?(tag)
        
        
        
        
    }
    
    
    var promptView: PromptBloodView!
    //加载提醒输入指血
    func loadBloodPrompt(){
        
        if self.promptView == nil {
            self.promptView = PromptBloodView(frame: CGRect(x: down_widht / 2 - 15,y: one_h - 20,width: 140,height: 23 + 10))
            self.promptView.backgroundColor = UIColor.clear
            self.promptView.alpha = 0
            self.bottomView.addSubview(self.promptView)
            
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.promptView.alpha = 1
                }, completion: nil)
      
        }
    
    }
    //去除指血录入视图
    func dismissBloodPrompt(){
        
        
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions(), animations: {
            if self.promptView != nil {
                self.promptView.alpha = 0
            }
        }) { (cop: Bool) in
            if self.promptView != nil {
                self.promptView.removeFromSuperview()
                self.promptView = nil
            }
        }
     
    }
    
    
    func setBloodValue(_ blood: String,oneTime: String){
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.bloodNumLabel?.text = blood
            
            self.oneTimeLabel?.text = oneTime
        })
        
    }
    
    func setAllTime(_ allTime: String){
        
//        print(allTime)
        
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.allTimeLabel?.text = allTime
        })
        
    }
    
    func setHbA1cLabelValue(_ hbA1c: String){
        DispatchQueue.main.async(execute: { () -> Void in
            self.hbA1cLabel?.text = hbA1c
        })
        
    }
    
    //MARK:根据血糖浓度，改变笑脸，表盘
    func setImgCly(_ bloodM:Int){
        
        DispatchQueue.main.async(execute: { () -> Void in
            var bloodN = bloodM
            if (bloodN >= 200){
                bloodN = 200
            }
            let blood:Float = Float(bloodN)
            var value:Float!
            value = 5.25 * blood / 200
            //MARK:- 仪表盘
            switch value
            {
            case 0..<1.02:
                //0-3.9
                //设置指针位置
                self.staticDialImgView?.image = UIImage(named: "pm1")!.imageWithTintColor(UIColor(red: 87/255.0, green: 184/255.0, blue: 205/255.0, alpha: 1))
                self.bloodNumLabel?.textColor = UIColor(red: 87/255.0, green: 184/255.0, blue: 205/255.0, alpha: 1)
                //设置 笑脸和文字
                self.currentStateImgView?.image = UIImage(named: "yb2.png")
                self.currentStateLabel?.text = "偏低"
            case 1.02..<1.60:
                //3.9-6.1
                self.staticDialImgView?.image = UIImage(named: "pm1")!.imageWithTintColor(UIColor(red: 100/255.0, green: 176/255.0, blue: 33/255.0, alpha: 1))
                self.bloodNumLabel?.textColor = UIColor(red: 100/255.0, green: 176/255.0, blue: 33/255.0, alpha: 1)
                self.currentStateImgView?.image = UIImage(named: "xl2.png")
                self.currentStateLabel?.text = "正常"
            case 1.60..<2.05:
                //6.1-7.8
                self.staticDialImgView?.image = UIImage(named: "pm1")!.imageWithTintColor(UIColor(red: 254/255.0, green: 196/255.0, blue: 10/255.0, alpha: 1))
                self.bloodNumLabel?.textColor = UIColor(red: 254/255.0, green: 196/255.0, blue: 10/255.0, alpha: 1)
                self.currentStateImgView?.image = UIImage(named: "hc2.png")
                self.currentStateLabel?.text = "注意"
            case 2.05..<2.91:
                //7.8-11.1
                self.staticDialImgView?.image = UIImage(named: "pm1")!.imageWithTintColor(UIColor(red: 252/255.0, green: 131/255.0, blue: 11/255.0, alpha: 1))
                self.bloodNumLabel?.textColor = UIColor(red: 252/255.0, green: 131/255.0, blue: 11/255.0, alpha: 1)
                self.currentStateImgView?.image = UIImage(named: "gd2.png")
                self.currentStateLabel?.text = "警报"
            case 2.91..<4.20:
                //11.1-16
                self.staticDialImgView?.image = UIImage(named: "pm1")!.imageWithTintColor(UIColor(red: 223/255.0, green: 33/255.0, blue: 14/255.0, alpha: 1))
                self.bloodNumLabel?.textColor = UIColor(red: 223/255.0, green: 33/255.0, blue: 14/255.0, alpha: 1)
                self.currentStateImgView?.image = UIImage(named: "gd2.png")
                self.currentStateLabel?.text = "警报"
                
            case 4.20..<5.25:
                //16-20
                self.staticDialImgView?.image = UIImage(named: "pm1")!.imageWithTintColor(UIColor(red: 220/255.0, green: 0/255.0, blue: 101/255.0, alpha: 1))
                self.bloodNumLabel?.textColor = UIColor(red: 220/255.0, green: 0/255.0, blue: 101/255.0, alpha: 1)
                self.currentStateImgView?.image = UIImage(named: "gd2.png")
                self.currentStateLabel?.text = "警报"
            default:
                break
            }
            
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.staticDialImgView?.transform = CGAffineTransform(rotationAngle: CGFloat(value))
                
            }) 
            
            
        })
        
        
        
    }
    
    
    func setNumberBloodLabelValue(_ count: Int){
        DispatchQueue.main.async(execute: { () -> Void in
            self.numberBloodLabel?.text = "\(count)次"
        })
        
    }
    

}
