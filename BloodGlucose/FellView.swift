//
//  FellView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/20.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class FellView: UIView {

    typealias fellViewColurse = (_ tag: Int,_ name: String)->Void
    
    var fellColurse:fellViewColurse?
    
    //标题
    @IBOutlet weak var nameLabel: UILabel!
    
    //左边
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    
    //中间
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var middleImgView: UIImageView!
    @IBOutlet weak var middleLabel: UILabel!
    
    //右边
    @IBOutlet weak var rigthView: UIView!
    @IBOutlet weak var rightImgView: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    
    //
    var fellName = "用药心情"
    var imgArray = ["eventSD.png","eventNSD.png","eventNSD.png"]
    var stateNameArray = ["高兴","正常","不舒服"]
    
    
    var viewArray = [UIView]()
    var imgViewArray = [UIImageView]()
    var labelArray = [UILabel]()
    
    
    
    //未选择的颜色
    var notSecColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1)
    var notSecImgName = "eventNSD.png"
    //选择的颜色
    var secColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
    var secImgName = "eventSD.png"
    
    //默认选择的
    var defualtSecIndex = 0
    
    
    
    override func draw(_ rect: CGRect) {
        
        self.nameLabel.text = self.fellName
        
        //
        viewArray.append(leftView)
        viewArray.append(middleView)
        viewArray.append(rigthView)
        
        //
        imgViewArray.append(leftImgView)
        imgViewArray.append(middleImgView)
        imgViewArray.append(rightImgView)
        
        //
        labelArray.append(leftLabel)
        labelArray.append(middleLabel)
        labelArray.append(rightLabel)
        
        print(self.viewArray.count)
        for index in 0..<self.viewArray.count {
            
            let tmpView = self.viewArray[index]
            let tmpImgView = self.imgViewArray[index]
            let tmpLabel = self.labelArray[index]
            
            
            //添加点击事件
            let tap = UITapGestureRecognizer(target: self, action: #selector(FellView.someViewAct(_:)))
            tmpView.addGestureRecognizer(tap)
            tmpView.tag = index
            
            //设置图片
            tmpImgView.image = UIImage(named: self.imgArray[index])
            //设置文字
            tmpLabel.text = self.stateNameArray[index]
 
            
        }
        
        self.isEditSetFellView(defualtSecIndex)
  
        
    }
    
    func setFellViewData(_ fellName: String, imgArray: [String], stateNameArray: [String]){
        
        self.fellName = fellName
        
        var tmp = imgArray
        
        switch imgArray.count {
        case 1:
            tmp.append(self.imgArray[1])
            tmp.append(self.imgArray[2])
        case 2:
            tmp.append(self.imgArray[2])
        default:
            break
        }
        
        self.imgArray = tmp

        self.stateNameArray = stateNameArray
  
    }
    
    
    func someViewAct(_ send: UITapGestureRecognizer){
        
        let tag = send.view!.tag

        for index in 0..<self.imgViewArray.count {
            
            let tmpLabel = self.labelArray[index]
            let tmpImgView = self.imgViewArray[index]
            
            if index == tag {
                tmpLabel.textColor = self.secColor
                tmpImgView.image = UIImage(named: self.secImgName)
            }else{
                tmpLabel.textColor = self.notSecColor
                tmpImgView.image = UIImage(named: self.notSecImgName)
            }
     
            
        }
        
        self.fellColurse?(tag,self.stateNameArray[tag])
        
    }
    //用于编辑的时候，设置
    func isEditSetFellView(_ index: Int){
        
        for tmp in 0..<self.imgViewArray.count {
            
            let tmpLabel = self.labelArray[tmp]
            let tmpImgView = self.imgViewArray[tmp]
            
            if index == tmp {
                tmpLabel.textColor = self.secColor
                tmpImgView.image = UIImage(named: self.secImgName)
            }else{
                tmpLabel.textColor = self.notSecColor
                tmpImgView.image = UIImage(named: self.notSecImgName)
            }
 
        }
    }

}
