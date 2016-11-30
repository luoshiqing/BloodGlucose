//
//  OpenBluetoothView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/10.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class OpenBluetoothView: UIView {

    
    fileprivate let Wsize = UIScreen.main.bounds.width / 375
    fileprivate let Hsize = (UIScreen.main.bounds.height - 64) / (667 - 64)
    
    
    var myScroView: UIScrollView?
    
    var methodsTitleArray = ["方法一","方法二","方法三"]
    var methodsTextArray = ["手指从屏幕底端向上滑动,即可弹出控制中心,点击蓝牙图标,图标点亮即为打开蓝牙成功",
                            "点击手机中的设置,选择蓝牙,打开蓝牙,按钮切换至绿色状态即为蓝牙打开成功",
                            "如果您打开了Assistive Touch功能,点击Assistive Touch,弹出功能页面,点击控制中心,弹出控制中心操作,点击蓝牙图标,图标点亮即为打开蓝牙成功"]
    
    
    
    override func draw(_ rect: CGRect) {
        
        myScroView = UIScrollView(frame: CGRect(x: 0,y: 0,width: rect.width,height: rect.height))
        
        myScroView?.backgroundColor = UIColor.white
        
        myScroView?.contentSize = CGSize.zero
        
        myScroView?.isPagingEnabled = false
        
        
        myScroView?.showsHorizontalScrollIndicator = false
        myScroView?.showsVerticalScrollIndicator = false
        
        
        self.addSubview(myScroView!)
        
        
        
        self.oneMethodsView(rect, title: self.methodsTitleArray[0], text: self.methodsTextArray[0])
        
        self.towMethodsView(rect, title: self.methodsTitleArray[1], text: self.methodsTextArray[1])
        
        self.threeMethodsView(rect, title: self.methodsTitleArray[2], text: self.methodsTextArray[2])
        
        
    }
    
    fileprivate var oneViewHeight: CGFloat = 0
    
    //方法一
    func oneMethodsView(_ rect: CGRect ,title: String ,text: String){
        
 
        
        //一半宽度
        let halfWidth = rect.width / 2
        //距离顶部距离
        let toUpHeight: CGFloat = 15
        //标题的高度
        let titleHeight: CGFloat = 17
        //左右边距
        let leftWidth: CGFloat = 10
        
        let string:NSString = text as NSString

        let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
        
        let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
        
        let brect = string.boundingRect(with: CGSize(width: halfWidth - leftWidth, height: 0), options: [options,a], attributes:  [NSFontAttributeName:UIFont(name: PF_SC, size: 15)!], context: nil)
  
        
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: toUpHeight,width: halfWidth,height: titleHeight))
        titleLabel.text = title
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor().rgb(68, g: 68, b: 68, alpha: 1)
        titleLabel.font = UIFont(name: PF_SC, size: 17)

   
        //------内容
        //距离标题的距离
        let toTitleHeight: CGFloat = 10
 
        let textLabel = UILabel(frame: CGRect(x: leftWidth,y: toUpHeight + toTitleHeight + titleHeight,width: halfWidth - leftWidth,height: brect.height))

        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor().rgb(68, g: 68, b: 68, alpha: 1)
        textLabel.font = UIFont(name: PF_SC, size: 15)
        
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), range: NSMakeRange(23,4))
        textLabel.attributedText = attributedStr
        
        //图片
        
        let imgH: CGFloat = 116 * self.Hsize
        let imgW: CGFloat = 167 * self.Wsize
        
 
        
        let imgView = UIImageView(frame: CGRect(x: (halfWidth - imgW) / 2 + halfWidth,y: toUpHeight,width: imgW,height: imgH))
        imgView.image = UIImage(named: "1Bitmap")

        //左文字总高度
        let allTextHeight = toUpHeight + titleHeight + toTitleHeight + brect.height

        let oneViewHeight = allTextHeight > (imgH + toUpHeight) ? allTextHeight + 10 : (imgH + toUpHeight + 10)
 
        
        //赋值
        self.oneViewHeight = oneViewHeight
        
        let oneView = UIView(frame: CGRect(x: 0,y: 0,width: rect.width,height: oneViewHeight))
        oneView.backgroundColor = UIColor.white
        
        self.myScroView?.addSubview(oneView)
        
        oneView.addSubview(titleLabel)
        oneView.addSubview(textLabel)
        oneView.addSubview(imgView)
        

    }
    fileprivate var towViewHeight: CGFloat = 0
    //方法二
    func towMethodsView(_ rect: CGRect ,title: String ,text: String){
        
        //一半宽度
        let halfWidth = rect.width / 2
        //距离顶部距离
        let toUpHeight: CGFloat = 15
        //标题的高度
        let titleHeight: CGFloat = 17
        
        //左右距离
        let leftWidth: CGFloat = 10
        
        
        //图片1
        
        let imgW: CGFloat = 166.5 * self.Wsize
        
        let imgH1: CGFloat = 81.2 * self.Hsize
        
        let imgH2: CGFloat = 154 * self.Hsize
        
        //图片间距
        let imgToImgH: CGFloat = 12
        //图1
        let upImgView = UIImageView(frame: CGRect(x: (halfWidth - imgW) / 2, y: toUpHeight, width: imgW, height: imgH1))
        
        upImgView.image = UIImage(named: "2Bitmap")
        
        //图2
        let downImgView = UIImageView(frame: CGRect(x: (halfWidth - imgW) / 2, y: toUpHeight + imgToImgH + imgH1, width: imgW, height: imgH2))
        downImgView.image = UIImage(named: "3Bitmap")
        
        
        //标题
        let titleLabel = UILabel(frame: CGRect(x: halfWidth,y: toUpHeight,width: halfWidth,height: titleHeight))
        titleLabel.text = title
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor().rgb(68, g: 68, b: 68, alpha: 1)
        titleLabel.font = UIFont(name: PF_SC, size: 17)
        
        //------内容
        
        let string:NSString = text as NSString
        
        let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
        
        let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
        
        let brect = string.boundingRect(with: CGSize(width: halfWidth - leftWidth, height: 0), options: [options,a], attributes:  [NSFontAttributeName:UIFont(name: PF_SC, size: 15)!], context: nil)
        
        //距离标题的距离
        let toTitleHeight: CGFloat = 10
        
        let textLabel = UILabel(frame: CGRect(x: halfWidth,y: toUpHeight + toTitleHeight + titleHeight,width: halfWidth - leftWidth,height: brect.height))
        
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor().rgb(68, g: 68, b: 68, alpha: 1)
        textLabel.font = UIFont(name: PF_SC, size: 15)
        
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), range: NSMakeRange(24,4))
        textLabel.attributedText = attributedStr
        
        
        //左侧图片总高度
        let imgAllHeight = toUpHeight + imgH1 + imgToImgH + imgH2
        //右边文字总高度
        let textAllHeight = toUpHeight + titleHeight + toTitleHeight + brect.height
        
        let towViewHeight = imgAllHeight > textAllHeight ? imgAllHeight + 10 : textAllHeight + 10
        
        //赋值
        self.towViewHeight = towViewHeight
        
        let towView = UIView(frame: CGRect(x: 0,y: self.oneViewHeight,width: rect.width,height: towViewHeight))
        towView.backgroundColor = UIColor.white
        
        self.myScroView?.addSubview(towView)
        
        towView.addSubview(upImgView)
        towView.addSubview(downImgView)
        towView.addSubview(titleLabel)
        towView.addSubview(textLabel)
        
        self.myScroView?.contentSize = CGSize(width: rect.width, height: self.oneViewHeight + self.towViewHeight)
        
    }
    fileprivate var threeViewHeight: CGFloat = 0
    //方法三
    func threeMethodsView(_ rect: CGRect ,title: String ,text: String){
        
        
        //一半宽度
        let halfWidth = rect.width / 2
        //距离顶部距离
        let toUpHeight: CGFloat = 15
        //标题的高度
        let titleHeight: CGFloat = 17
        //左右边距
        let leftWidth: CGFloat = 10
        
        let string:NSString = text as NSString
        
        let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
        
        let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
        
        let brect = string.boundingRect(with: CGSize(width: halfWidth - leftWidth, height: 0), options: [options,a], attributes:  [NSFontAttributeName:UIFont(name: PF_SC, size: 15)!], context: nil)
        
        
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: toUpHeight,width: halfWidth,height: titleHeight))
        titleLabel.text = title
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor().rgb(68, g: 68, b: 68, alpha: 1)
        titleLabel.font = UIFont(name: PF_SC, size: 17)
        
        
        //------内容
        //距离标题的距离
        let toTitleHeight: CGFloat = 10
        
        let textLabel = UILabel(frame: CGRect(x: leftWidth,y: toUpHeight + toTitleHeight + titleHeight,width: halfWidth - leftWidth,height: brect.height))
        
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor().rgb(68, g: 68, b: 68, alpha: 1)
        textLabel.font = UIFont(name: PF_SC, size: 15)
        
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), range: NSMakeRange(51,4))
        textLabel.attributedText = attributedStr
        
        //图片
        
        let imgW: CGFloat = 162 * self.Wsize
        let imgH1: CGFloat = 115 * self.Hsize
        let imgH2: CGFloat = 114 * self.Hsize
        //图片间距
        let imgToimgH: CGFloat = 12
        
        
        //图1
        let imgView = UIImageView(frame: CGRect(x: (halfWidth - imgW) / 2 + halfWidth,y: toUpHeight,width: imgW,height: imgH1))
        imgView.image = UIImage(named: "4Bitmap")
        //图2
        let imgView2 = UIImageView(frame: CGRect(x: (halfWidth - imgW) / 2 + halfWidth,y: toUpHeight + imgToimgH + imgH1,width: imgW,height: imgH2))
        imgView2.image = UIImage(named: "5Bitmap")
        
 
        //左文字总高度
        let allTextHeight = toUpHeight + titleHeight + toTitleHeight + brect.height
        //右图片总度
        let allImgHeight = toUpHeight + imgH1 + imgToimgH + imgH2
        
        
        let oneViewHeight = allTextHeight > allImgHeight ? allTextHeight + 10 : allImgHeight + 10
        
        
        //赋值
        self.threeViewHeight = oneViewHeight
        
        let oneView = UIView(frame: CGRect(x: 0,y: self.oneViewHeight + self.towViewHeight,width: rect.width,height: oneViewHeight))
        oneView.backgroundColor = UIColor.white
        
        self.myScroView?.addSubview(oneView)
        
        oneView.addSubview(titleLabel)
        oneView.addSubview(textLabel)
        oneView.addSubview(imgView)
        oneView.addSubview(imgView2)
        
//        self.myScroView?.contentSize = CGSize(width: rect.width, height: self.oneViewHeight + self.towViewHeight + self.threeViewHeight)
        
        let tmpHeight: CGFloat = self.oneViewHeight + self.towViewHeight + self.threeViewHeight
        self.myScroView?.contentSize = CGSize(width: rect.width, height: tmpHeight)
        
        
        
    }
    
    
    
    

}
