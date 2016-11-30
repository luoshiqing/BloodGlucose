//
//  EventFellTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/17.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class EventFellTableViewCell: UITableViewCell {

    typealias fellViewColurse = (_ tag: Int,_ name: String)->Void
    
    var fellColurse:fellViewColurse?
    
    @IBOutlet weak var titLabel: UILabel!
    
    //高兴
    @IBOutlet weak var happyView: UIView!
    @IBOutlet weak var happImg: UIImageView!
    @IBOutlet weak var happLabel: UILabel!
    
    //正常
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var normalImg: UIImageView!
    @IBOutlet weak var normalLabel: UILabel!
    
    //不舒服
    @IBOutlet weak var uncomfortableView: UIView!
    @IBOutlet weak var uncomfortableImg: UIImageView!
    @IBOutlet weak var uncomfortableLabel: UILabel!
    
    fileprivate var viewArray = [UIView]() //视图数组
    fileprivate var imgArray = [UIImageView]() //图片数组
    fileprivate var labelArray = [UILabel]() //文字数组
    
    fileprivate let fellArray = ["高兴","正常","不舒服"]
    
    //未选择的颜色
    fileprivate var notSecColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1)
    fileprivate var notSecImgName = "eventNSD.png"
    //选择的颜色
    fileprivate var secColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
    fileprivate var secImgName = "eventSD.png"
    
    var fellIndxe = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.viewArray.append(happyView)
        self.viewArray.append(normalView)
        self.viewArray.append(uncomfortableView)
        
        self.imgArray.append(happImg)
        self.imgArray.append(normalImg)
        self.imgArray.append(uncomfortableImg)
        
        self.labelArray.append(happLabel)
        self.labelArray.append(normalLabel)
        self.labelArray.append(uncomfortableLabel)
        
        
        for index in 0..<self.viewArray.count {
            
            let tmpView = self.viewArray[index]

            let tap = UITapGestureRecognizer(target: self, action: #selector(self.someViewAct(send:)))
            tmpView.addGestureRecognizer(tap)
            tmpView.tag = index
            

        }
        
        
        
    }

    
    
    
    @objc fileprivate func someViewAct(send: UITapGestureRecognizer){

        let tag = send.view!.tag
        
        for index in 0..<self.imgArray.count{

            let imgView = self.imgArray[index]
            let label = self.labelArray[index]
  
            if tag == index {
                imgView.image = UIImage(named: self.secImgName)
                label.textColor = self.secColor
            }else{
                imgView.image = UIImage(named: self.notSecImgName)
                label.textColor = self.notSecColor
            }
    
        }
        
        self.fellColurse?(tag,self.fellArray[tag])
        
    }
    


    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
