
//
//  FunctionalView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/12.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class FunctionalView: UIView {

    var myScroView: UIScrollView?
    
    override func draw(_ rect: CGRect) {
        
        let Wscrren = UIScreen.main.bounds.size.width
        
        
        print("Wscrren;\(Wscrren)")
        
        var imgName = ""
        
        switch Wscrren {
        case 375:
            imgName = "r375"
        case 414:
            imgName = "rplus1"
        default:
            imgName = "r320"
        }
        
        
        
        let path = Bundle.main.path(forResource: imgName, ofType: "png")
        
        let size = UIImage(contentsOfFile: path!)?.size

        
        var imgW: CGFloat = size!.width / 2
        var imgH: CGFloat = size!.height / 2
        
        if Wscrren == 414 {
            imgW = UIScreen.main.bounds.size.width - 20 * 2
            
            let Hsize1 = UIScreen.main.bounds.size.height / 667
            
            imgH = 938 * Hsize1
        }
        
    
        
        let titleLabel = UILabel(frame: CGRect(x: 15.5,y: 14,width: 200,height: 17))
        titleLabel.text = "监控页面使用说明"
        titleLabel.textColor = UIColor().rgb(246, g: 93, b: 34, alpha: 1)
        titleLabel.font = UIFont(name: PF_SC, size: 17)
        
  
        myScroView = UIScrollView(frame: rect)
        
        myScroView?.backgroundColor = UIColor.white
        
        self.addSubview(myScroView!)
        
        
        myScroView?.addSubview(titleLabel)
        
        
        myScroView?.contentSize = CGSize(width: rect.width, height: imgH + 17 + 14 + 10 + 10)
        
        let imgView = UIImageView(frame: CGRect(x: (rect.width - imgW) / 2, y: 17 + 14 + 10, width: imgW, height: imgH))
        imgView.image = UIImage(named: imgName)
        myScroView?.addSubview(imgView)
        
    }
 

}
