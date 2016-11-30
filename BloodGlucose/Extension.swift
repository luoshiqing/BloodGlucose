//
//  Extension.swift
//  BloodSugar
//
//  Created by 虞政凯 on 15/11/16.
//  Copyright © 2015年 虞政凯. All rights reserved.
//

import UIKit


extension UIImage{
    
    func imageWithTintColor(_ myColor:UIColor)->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        myColor.setFill()
        let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: .destinationIn, alpha: 1)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

