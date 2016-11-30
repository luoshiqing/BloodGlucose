//
//  MJLunboTableViewCell.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/6.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class MJLunboTableViewCell: UITableViewCell ,ZJCycleViewDelegate{

    
    var superCtr: UIViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let Wsize = UIScreen.main.bounds.width / 375
        
        let cycle = ZJCyleScrollView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 110 * Wsize))
        cycle.delegate = self
        
        
        var imgs = [String]()
        
        if bannerArray != nil {
            
            for item in bannerArray {
                let dic = item as! [String:String]

                if let img = dic["img"] {
                    imgs.append(img)
                }
 
            }
        }
        
        var images = [String]()
        if imgs.count > 0 {
            images = imgs
        }else{
            images = ["qixing","pashan","TAIJI","166273801"]
        }
 
        cycle.images = images
        
        
        self.contentView.addSubview(cycle)
  
        
    }

    
    func didSelectIndexCollectionViewCell(_ index: Int) {
        print("\(index)")
        
        if bannerArray != nil {
            let url: String = (bannerArray[index] as! [String:String])["url"]!
            let name: String = (bannerArray[index] as! [String:String])["name"]!

            let webVC = HomeWebViewController()
            
            webVC.url = url
            webVC.webTitle = name
            
            self.superCtr?.navigationController?.pushViewController(webVC, animated: true)
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
