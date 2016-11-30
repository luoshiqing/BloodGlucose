//
//  HealthPhtoTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/19.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class HealthPhtoTableViewCell: UITableViewCell ,UITextViewDelegate{

    typealias HealthPhtoTableViewCellTextClourse = (_ value: String)->Void
    
    var textClourse: HealthPhtoTableViewCellTextClourse?
    
    let Wsize = (UIScreen.main.bounds.width - 30 - 30) / (375 - 60)
    
    let SRect = UIScreen.main.bounds.size
    
    //左边距
    let toLeftW: CGFloat = 15
    
    //上边距
    let toTopH: CGFloat = 12
    //标题高度
    let titH: CGFloat = 17
    //标题到图片间距
    let titToImgH: CGFloat = 18
    
    var tpictrueView:TTakingPictureView!
    
    
    
    
    
    var titLabel: UILabel!
    
    var pictruesView: PicturesView!
    
    var ttextView : UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        titLabel = UILabel(frame: CGRect(x: toLeftW,y: toTopH,width: 150,height: titH))
        titLabel.textColor = UIColor().rgb(85, g: 85, b: 85, alpha: 1)
        titLabel.font = UIFont(name: PF_SC, size: 16)
        
        self.addSubview(titLabel)
        
       
        pictruesView = PicturesView(frame: CGRect(x: 0,y: toTopH + titH + titToImgH,width: SRect.width,height: Wsize * 70))
        pictruesView.backgroundColor = UIColor.clear
 
        self.addSubview(pictruesView)
        
        ttextView = UITextView(frame: CGRect(x: 13, y: toTopH + titH + titToImgH + Wsize * 70 + titToImgH, width: SRect.width - 13 * 2, height: 100))
        ttextView.backgroundColor = UIColor.white
        
        ttextView.delegate = self
        
//        ttextView.text = "可以文字描述化验结果..."
        
        self.ttextView.isUserInteractionEnabled = false
        
        ttextView.textColor = UIColor().rgb(159, g: 159, b: 159, alpha: 1)
        
        ttextView.font = UIFont(name: PF_SC, size: 14)
        
        self.addSubview(ttextView)
        
    }
    
    func reloadPicturesView(_ imgArray: [AnyObject]){
        pictruesView.reloadPicturesView(imgArray)
    }
    
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        textView.resignFirstResponder()
        textView.isUserInteractionEnabled = false
        
        
        self.textClourse?(textView.text)
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
