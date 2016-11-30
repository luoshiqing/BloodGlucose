//
//  NewBloodTopView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/17.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class NewBloodTopView: UIView {

    typealias NewBloodTopViewSeeBtnActClourse = (_ time: String)->Void
    var seeBtnActClourse: NewBloodTopViewSeeBtnActClourse?
    
    
    var superCtr: UIViewController?
    
    //最多查看七天数据
    
    
    let timeSecH: CGFloat = 45
    let chartsH: CGFloat = 255
    let downH: CGFloat = 30
    
    fileprivate let toLeft_width: CGFloat = 18.5 //距离左边的宽度
    
    var leftLabel: UILabel?
    var rightLabel: UILabel?
   
    let mmwidth = UIScreen.main.bounds.size.width
    
    override func draw(_ rect: CGRect) {

        //底部时间选择
        self.timeSecView(rect)

        self.setChartsView(mmwidth)

        self.setDownView(rect)
     
    }

    
    var scatterView: ScatterView!
    
    func setChartsView(_ width: CGFloat){
        //2.0 图形视图
        if scatterView == nil {
            scatterView = ScatterView(frame: CGRect(x: 0,y: timeSecH,width: width,height: chartsH))
            scatterView.backgroundColor = UIColor.clear
            self.addSubview(scatterView)
        }
   
    }
    
    
    //重新加载
    func reloadScatterView(){
        if scatterView != nil {
            scatterView.removeFromSuperview()
            scatterView = nil
        }
        
        self.setChartsView(mmwidth)
        
    }
    
    
    //底部文字
    func setDownView(_ rect: CGRect){
        
        let downView = UIView(frame: CGRect(x: 0,y: timeSecH + chartsH,width: rect.width,height: downH))
        downView.backgroundColor = UIColor(red: 255/255.0, green: 235/255.0, blue: 227/255.0, alpha: 1)
        self.addSubview(downView)
        
        let downLabel = UILabel(frame: CGRect(x: toLeft_width,y: 0,width: 150,height: downH))
        downLabel.text = "血糖数据"
        downLabel.textColor = UIColor(red: 116/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1)
        downLabel.font = UIFont.systemFont(ofSize: 16)
        
        downView.addSubview(downLabel)
        
        
        //血糖记录
        let bloodRecordView = UIView(frame: CGRect(x: 0,y: timeSecH + chartsH + downH,width: rect.width,height: downH))
        bloodRecordView.backgroundColor = UIColor.white
        
        let tapB = UITapGestureRecognizer(target: self, action: #selector(NewBloodTopView.someViewAct(_:)))
        bloodRecordView.addGestureRecognizer(tapB)
        bloodRecordView.tag = 2
        
        
        self.addSubview(bloodRecordView)
        
        
        //图标
        let img_width: CGFloat = 4.2
        let img_height: CGFloat = 8.3
        
        let imgToRightW: CGFloat = 15
        
        let blood_size = bloodRecordView.frame.size
        
        let imgView = UIImageView(frame: CGRect(x: blood_size.width - img_width - imgToRightW, y: (blood_size.height - img_height) / 2, width: img_width, height: img_height))
        imgView.image = UIImage(named: "SRight")
        
        bloodRecordView.addSubview(imgView)
        
        //血糖记录label
        let bloodLabel = UILabel(frame: CGRect(x: 0,y: 0,width: blood_size.width - img_width - 3 - imgToRightW,height: blood_size.height))
        bloodLabel.textAlignment = .right
        bloodLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        bloodLabel.font = UIFont.systemFont(ofSize: 16)
        
        bloodLabel.text = "血糖记录"
        
        bloodRecordView.addSubview(bloodLabel)
    }
    
    //记录时间的 选择
    var currentDate = Date()
    
    func timeSecView(_ rect: CGRect){
        
        //0.1时间选择背景视图
        let topDateView = UIView(frame: CGRect(x: 0,y: 0,width: rect.width,height: timeSecH))
        topDateView.backgroundColor = UIColor.white
        

        let tapL = UITapGestureRecognizer(target: self, action: #selector(NewBloodTopView.someViewAct(_:)))
        topDateView.addGestureRecognizer(tapL)
        topDateView.tag = 0
        
        self.addSubview(topDateView)
        
        let midW: CGFloat = 17
        
        let midLabel = UILabel(frame: CGRect(x: (rect.width - midW) / 2,y: 0,width: midW,height: timeSecH))
        midLabel.textAlignment = .center
        midLabel.textColor = UIColor().rgb(99, g: 99, b: 99, alpha: 1)
        midLabel.text = "至"
        midLabel.font = UIFont(name: PF_SC, size: 15)
        topDateView.addSubview(midLabel)
        
        //left
        let labelW: CGFloat = 100
        leftLabel = UILabel(frame: CGRect(x: (rect.width  - midW) / 2 - labelW - 10,y: (timeSecH - 28) / 2,width: labelW,height: 28))
        
        leftLabel?.textAlignment = .center
        leftLabel?.textColor = UIColor(red: 99/255.0, green: 99/255.0, blue: 99/255.0, alpha: 1)
//        leftLabel?.textColor = UIColor().rgb(246, g: 93, b: 34, alpha: 1)
        leftLabel?.font = UIFont(name: PF_SC, size: 15)
        
        let (Ltime,_,date) = StatisticalService().getCurrentDate()
        
        self.currentDate = date as Date
        
//        leftLabel?.layer.cornerRadius = 4
//        leftLabel?.layer.masksToBounds = true
//        leftLabel?.layer.borderWidth = 0.5
//        leftLabel?.layer.borderColor = UIColor().rgb(246, g: 93, b: 34, alpha: 1).CGColor
        
        
        leftLabel?.text = Ltime
        
//        leftLabel?.userInteractionEnabled = true
//        let tapL = UITapGestureRecognizer(target: self, action: #selector(NewBloodTopView.someViewAct(_:)))
//        leftLabel?.addGestureRecognizer(tapL)
//        leftLabel?.tag = 0
        
        topDateView.addSubview(leftLabel!)
        
    
        
        rightLabel = UILabel(frame: CGRect(x: (rect.width + midW) / 2 + 10,y: (timeSecH - 28) / 2,width: labelW,height: 28))
        
//        rightLabel?.backgroundColor = UIColor().rgb(100, g: 100, b: 100, alpha: 0.5)
        
        rightLabel?.layer.cornerRadius = 4
        rightLabel?.layer.masksToBounds = true
        
        rightLabel?.textAlignment = .center
        rightLabel?.textColor = UIColor(red: 99/255.0, green: 99/255.0, blue: 99/255.0, alpha: 1)
        rightLabel?.font = UIFont(name: PF_SC, size: 15)
        
        let (Rtime,_,_) = StatisticalService().getCurrentDate()
        rightLabel?.text = Rtime
 
        topDateView.addSubview(rightLabel!)
        
        
        
        //查看 按钮
//        
//        let seeBtn = UIButton(frame: CGRectMake(rect.width - 45 - 10,(timeSecH - 30) / 2,45,30))
//        seeBtn.setTitle("查看", forState: UIControlState.Normal)
//        seeBtn.backgroundColor = UIColor.whiteColor()
//        
//        seeBtn.setTitleColor(UIColor().rgb(246, g: 93, b: 34, alpha: 1), forState: UIControlState.Normal)
//        
//        seeBtn.titleLabel?.font = UIFont(name: PF_SC, size: 15)
//        
//        seeBtn.layer.cornerRadius = 5
//        seeBtn.layer.masksToBounds = true
//        
//        seeBtn.layer.borderWidth = 0.5
//        seeBtn.layer.borderColor = UIColor().rgb(246, g: 93, b: 34, alpha: 1).CGColor
//        
//        seeBtn.addTarget(self, action: #selector(NewBloodTopView.someBtnAct(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        seeBtn.tag = 3
//        
//        topDateView.addSubview(seeBtn)
        
        
    }
    

    
    func someViewAct(_ send: UITapGestureRecognizer){
        switch send.view!.tag {
        case 0:
            print("左边时间")

            self.loadDateMaxChooseView("起始时间", model: UIDatePickerMode.date, currentDate: self.currentDate,minDate: nil, maxDate: nil)
        case 2:
            print("血糖记录")
            
            let statBloodVC = StatBloodRecordViewController()
     
            
            statBloodVC.gettime = self.seeTime
            
            self.superCtr?.navigationController?.pushViewController(statBloodVC, animated: true)
            
            
        default:
            break
        }
    }
    
//    func someBtnAct(send: UIButton){
//        switch send.tag {
//        case 3:
//            print("查看")
//
//            self.seeBtnActClourse?(time: (self.leftLabel?.text)!)
//            
//            
//        default:
//            break
//        }
//    }
    
    var dateMaxView: DateMaxChooseView!
    func loadDateMaxChooseView(_ title: String?,model: UIDatePickerMode? , currentDate: Date?,minDate: Date? ,maxDate: Date?){
        
        dateMaxView = DateMaxChooseView()
        
        dateMaxView.okBtnClourse = self.DateMaxChooseViewOkBtnClourse
        dateMaxView.initDateMaxChooseView(title, model: model, currentDate: currentDate,minDate: minDate, maxDate: maxDate)

    }
 
    //记录查看的时间，便于查看血糖记录
    var seeTime:String?
    //日期回调
    func DateMaxChooseViewOkBtnClourse(_ value: String)->Void{
        print("回调时间:\(value)")
        
//        let val = (value as NSString).substring(with: NSRange(0...9))
        let val = (value as NSString).substring(with: NSRange(location: 0, length: 10))
        self.leftLabel?.text = val
        
        
        let (rightText,currentDate) =  self.getRightLabelText(value,days: 7)
        self.rightLabel?.text = rightText
        
        self.currentDate = currentDate
        
        
        self.seeTime = val
        
        self.seeBtnActClourse?(val)
        
    }
    
    
    func getRightLabelText(_ str: String,days: Int) -> (String,Date){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let date = formatter.date(from: str)
        
        //参数时间戳
        let timeInterval = date!.timeIntervalSince1970
        //当前时间戳
        let nowInterval = Date().timeIntervalSince1970
        //7天时间戳
        let sevenInterval: TimeInterval = Double(days) * 24 * 60 * 60
        let tmpTime = (timeInterval + sevenInterval) > nowInterval ? nowInterval : (timeInterval + sevenInterval)
        let tmpDate = Date(timeIntervalSince1970: tmpTime)
        let newDateStr = formatter.string(from: tmpDate)
        
//        let endStr = (newDateStr as NSString).substring(with: NSRange(0...9))
        let endStr = (newDateStr as NSString).substring(with: NSRange(location: 0, length: 10))
        
        return (endStr,date!)
        
    }
    
    
    
    
    

}
