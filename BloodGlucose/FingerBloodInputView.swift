//
//  FingerBloodInputView.swift
//  BloodGlucoseHospital
//
//  Created by nash_su on 7/25/15.
//  Copyright (c) 2015 Sqluo. All rights reserved.
//

import UIKit

protocol FingerBloodInputViewDelegate{
    func addNewFingerBlood(_ fingerBlood:Float, date:Date, index:Int)
    
    func closeInputBloodView()
}

class FingerBloodInputView: UIView,UIScrollViewDelegate {
    
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var contentView: UIView!
    
    
    var delegate:FingerBloodInputViewDelegate!
    
    var markShortLength:Int = 14
    var markLongLength:Int = 30
    
    @IBOutlet weak var resultLabel: UILabel!

    @IBOutlet weak var rulerBgView: UIView!
    
    var bgView:UIScrollView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var currentFingerBlood:Float!
    
    
    //编辑现有数据
    
    var record_fingerBlood:Float!
    var record_date:Date!
    var record_index:Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSetup()
    }
    
    func initSetup(){
        Bundle.main.loadNibNamed("FingerBloodInputView", owner: self, options: nil)
        
        self.addSubview(self.view)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view":view]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view":view]))
        
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        
        //初始化当前血糖值
        currentFingerBlood = 0.0
        
        //初始化标尺组件

        print("大小大小： \(self.view.frame.size)")
        
        bgView = UIScrollView()
        bgView.showsHorizontalScrollIndicator = false
        bgView.showsVerticalScrollIndicator = false
        bgView.bounces = false
        bgView.backgroundColor = UIColor(red: 0.98, green: 0.89, blue: 0.77, alpha: 1)
    
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.layer.cornerRadius = 4.0
        bgView.layer.masksToBounds = true
        bgView.delegate = self
        
        self.rulerBgView.addSubview(bgView)
        
        self.rulerBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[bgView]-|", options: [], metrics: nil, views: ["bgView":bgView ]))
        self.rulerBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[bgView]-|", options: [], metrics: nil, views: ["bgView":bgView ]))
        
        
        
        let bgViewMask = UIView()
        
        bgViewMask.translatesAutoresizingMaskIntoConstraints = false
        bgViewMask.layer.cornerRadius = 4.0
        bgViewMask.layer.masksToBounds = true
        bgViewMask.isUserInteractionEnabled = false
        
        
        self.rulerBgView.addSubview(bgViewMask)
        
        self.rulerBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bgViewMask]-0-|", options: [], metrics: nil, views: ["bgViewMask":bgViewMask ]))
        self.rulerBgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[bgViewMask]-0-|", options: [], metrics: nil, views: ["bgViewMask":bgViewMask ]))
        
        
        bgViewMask.layoutIfNeeded()
        let bgViewMaskWidth = Int(UIScreen.main.bounds.size.width - 40)
        
        let bgViewMaskPointer = UIView()
        
        bgViewMaskPointer.backgroundColor = UIColor.red
        bgViewMaskPointer.translatesAutoresizingMaskIntoConstraints = false
        
        bgViewMask.addSubview(bgViewMaskPointer)
        
        bgViewMask.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[bgViewMaskPointer]-|", options: [], metrics: nil, views: ["bgViewMaskPointer":bgViewMaskPointer]))
        bgViewMask.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(bgViewMaskWidth/2 )-[bgViewMaskPointer(==1)]", options: [], metrics: nil, views: ["bgViewMaskPointer":bgViewMaskPointer]))
        
        
        let numberLength:Int = 30
        
        let totalCount:Int = numberLength * 10
        

        
        
        
        //前部填充长度
        self.view.layoutIfNeeded()
        bgView.layoutIfNeeded()
        let markPrePadding:Int = Int((UIScreen.main.bounds.size.width - 56) / 2)

        
        print("markPrePadding : \(markPrePadding)")
        
        
        var preMarkLine:UIView!
        var preNumLabel:UILabel!
        
        
        for i in 0...totalCount{
            
            //初始化刻度线
            let markLine = UIView()
            markLine.backgroundColor = UIColor.gray
            markLine.translatesAutoresizingMaskIntoConstraints = false
            
            bgView.addSubview(markLine)
            
            
            
            //如果是第一个标示线
            if i == 0{
                bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(markPrePadding)-[markLine\(i)(==1)]", options: [], metrics: nil, views: ["markLine\(i)":markLine]))
                
            }else{
                //如果是最后一个标志线
                if i == totalCount{
                    bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[preMarkLine]-2-[markLine\(i)(==1)]-10-|", options: [], metrics: nil, views: ["markLine\(i)":markLine, "preMarkLine":preMarkLine]))
                    
                }else{
                    //如果不是最后一个标志线
                    bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[preMarkLine]-2-[markLine\(i)(==1)]", options: [], metrics: nil, views: ["markLine\(i)":markLine, "preMarkLine":preMarkLine]))
                    
                }
            }
            
            //如果是0或10则绘制长线
            if i == 0 || i % 10 == 0{
                
                //初始化刻度数字
                let numLabel = UILabel()
                numLabel.font = UIFont(name: "Helvetica-Bold", size: 14)
                numLabel.textAlignment = NSTextAlignment.left
                numLabel.textColor = UIColor.gray
                numLabel.translatesAutoresizingMaskIntoConstraints = false
                numLabel.text = "\(i / 10)"
                bgView.addSubview(numLabel)
                
                bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[markLine\(i)(==\(markLongLength))]", options: [], metrics: nil, views: ["markLine\(i)":markLine]))
                
                
                bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[numLabel\(i)(==10)]", options: [], metrics: nil, views: ["numLabel\(i)":numLabel]))
                
                
                //绘制刻度数字
                if i == 0{
                    bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(markPrePadding - 3)-[numLabel\(i)(==30)]", options: [], metrics: nil, views: ["numLabel\(i)":numLabel]))
                    
                    //向前填充刻度保证美观
                    
                    let prePaddingCount:Int = markPrePadding / 3
                    var prePrePaddingMarkLine:UIView!
                    
                    for j in 0...prePaddingCount{
                        //初始化刻度线
                        let prePaddingMarkLine = UIView()
                        prePaddingMarkLine.backgroundColor = UIColor.gray
                        prePaddingMarkLine.translatesAutoresizingMaskIntoConstraints = false
                        
                        bgView.addSubview(prePaddingMarkLine)
                        
                        
                        //如果是第一个标示线
                        if j == 0{
                            bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[prePaddingMarkLine\(j)(==1)]-2-[markLine]", options: [], metrics: nil, views: ["prePaddingMarkLine\(j)":prePaddingMarkLine, "markLine":markLine]))
                            
                        }else{
                            
                            bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[prePaddingMarkLine\(j)(==1)]-2-[prePrePaddingMarkLine]", options: [], metrics: nil, views: ["prePaddingMarkLine\(j)":prePaddingMarkLine, "prePrePaddingMarkLine":prePrePaddingMarkLine]))
                            
                            
                        }
                        
                        
                        //如果是0或10则绘制长线
                        if j != 0 && j % 10 == 0{
                            
                            
                            bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[prePaddingMarkLine\(j)(==\(markLongLength))]", options: [], metrics: nil, views: ["prePaddingMarkLine\(j)":prePaddingMarkLine]))
                            
                            
                        }else{
                            //否则绘制短线
                            bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[prePaddingMarkLine\(j)(==\(markShortLength))]", options: [], metrics: nil, views: ["prePaddingMarkLine\(j)":prePaddingMarkLine]))
                            
                        }
                        
                        
                        
                        prePrePaddingMarkLine = prePaddingMarkLine
                    }
                    
                    
                    //向前填充刻度保证美观 - 结束
                    
                    
                    
                }else{
                    
                    bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[preNumLabel]-0-[numLabel\(i)(==30)]", options: [], metrics: nil, views: ["numLabel\(i)":numLabel, "preNumLabel":preNumLabel]))
                    
                }
                
                preNumLabel = numLabel
                
            }else{
                //否则绘制短线
                bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[markLine\(i)(==\(markShortLength))]", options: [], metrics: nil, views: ["markLine\(i)":markLine]))
                
            }
            
            preMarkLine =  markLine
        }
        
        //标尺组件初始化结束
        
        submitBtn.layer.cornerRadius = 4
        submitBtn.layer.masksToBounds = true
        submitBtn.addTarget(self, action: #selector(FingerBloodInputView.submitAction), for: UIControlEvents.touchUpInside)
    
    }

    
    func setupEditData(){
        
        //如果是编辑数据则设置相关数据
        if record_fingerBlood != nil && record_date != nil && record_index != nil{
            print("检测到编辑数据")
            self.calculateAndUpdateOffset(self.record_fingerBlood)
            
            self.datePicker.setDate(self.record_date, animated: false)
        }else{
            print("没有检测到编辑数据")
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _ = calculateAndUpdateNum(Int(scrollView.contentOffset.x))
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset:Int = Int(scrollView.contentOffset.x)
        if offset < 3{
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }else{
            if offset % 3 != 0{
                scrollView.setContentOffset(CGPoint( x: CGFloat(offset + (3 - (offset % 3))), y: 0), animated: true)
            }
        }
        
        let _ = calculateAndUpdateNum(Int(scrollView.contentOffset.x))
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset:Int = Int(scrollView.contentOffset.x)
        if offset < 3{
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }else{
            if offset % 3 != 0{
                scrollView.setContentOffset(CGPoint( x: CGFloat(offset + (3 - (offset % 3))), y: 0), animated: true)
                
            }
        }
        
        let _ = calculateAndUpdateNum(Int(scrollView.contentOffset.x))
        
    }
    
    func calculateAndUpdateNum(_ x:Int) -> Float{
        let count:Int = x / 3
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.resultLabel.text = "\(Int(count / 10)).\( count % 10 ) mmol/L"
        })
        currentFingerBlood = Float(count / 10) + (Float(count % 10)/10)
        
        
        let bloodNumberRounded = NSString(format: "%.1f", currentFingerBlood)
        
        return Float(bloodNumberRounded.doubleValue)
    }
    
    
    func calculateAndUpdateOffset(_ fingerBlood:Float){
       
        for i in 0...1000{

            if calculateAndUpdateNum(i) == fingerBlood{
                DispatchQueue.main.async(execute: { () -> Void in
                    self.bgView.setContentOffset(CGPoint(x: CGFloat(i), y: 0), animated: true)
                    self.bgView.layoutIfNeeded()
                })
                break
            }
        }
        
    }
    
    func submitAction(){
        
        if record_index != nil{
            
            delegate.addNewFingerBlood(currentFingerBlood, date: datePicker.date, index:record_index)
            
            print("datePicker.date:\(datePicker.date)")
            
            
        }else{
            delegate.addNewFingerBlood(currentFingerBlood, date: datePicker.date, index:-1)
            print("datePicker.date:\(datePicker.date)")
        }
    }

    @IBAction func closeAct(_ sender: AnyObject) {
        self.delegate.closeInputBloodView()
    }

}
