//
//  CAGradientLayerEXT.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/5.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class CAGradientLayerEXT: NSObject {

    func animation(_ isShow: Bool){

   
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        if isShow {
            BaseTabBarView.frame.origin.x = 0
        }else{
            BaseTabBarView.frame.origin.x = -UIScreen.main.bounds.width
        }
        UIView.setAnimationCurve(UIViewAnimationCurve.easeOut) //设置动画相对速度
        UIView.commitAnimations()
    }
    
    
}


extension CAGradientLayer {
    
    func GradientLayer(_ topColor: UIColor, buttomColor: UIColor) -> CAGradientLayer {
        let gradientColors: [CGColor] = [topColor.cgColor, buttomColor.cgColor]
        let gradientLocations: [CGFloat] = [0.0, 1.0]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        return gradientLayer
    }
}




extension UIImage {
    //颜色转图片
    func createImagFromColor(_ color: UIColor)->UIImage{
        
        let size = CGSize(width: 1, height: 1)
        
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        context?.fill(rect)
        
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return theImage!
        
    }
}


extension UIColor{
    
    func rgb(_ r: CGFloat ,g: CGFloat ,b: CGFloat ,alpha: CGFloat) -> UIColor{
        
        let colors = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
        return colors
    }
    

    func hexStringToColor(_ hexString: String) -> UIColor{
        var cString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if cString.characters.count < 6 {return UIColor.black}
        if cString.hasPrefix("0X") {cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 2))}
        if cString.hasPrefix("#") {cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))}
        if cString.characters.count != 6 {return UIColor.black}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        
    }
  
}









