//
//  UfoodAdviceView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/9.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class UfoodAdviceView: UIView {

    //未加载完成显示的图片名称
    var imgString = "loadlogo.png"
    //加载失败
    var imgFaild = "loading_failed"
    
    var UWsize:CGFloat!
    var UHsize:CGFloat!
    
    var avgHsize:CGFloat! //每个视图的高度
    
    
    var URepViewCtr:UIViewController!
    
    //------记录数据-----
    var myFoodArray = NSArray()
    
    
    func setUfoodAdviceView(_ foodArray:NSArray){
        
        
        
        print(foodArray)
        
        self.myFoodArray = foodArray
        
        UWsize = self.frame.size.width
        UHsize = self.frame.size.height
        avgHsize = self.frame.size.height / 4
        
        
//        print(avgHsize)
        
        
        for item in 0...foodArray.count - 1 {
            
            
            let tmpDic = foodArray[item] as! NSDictionary
            
            let name = tmpDic.value(forKey: "type") as! String //类型
            let swop = tmpDic.value(forKey: "swop") as! String//份量
            
            let foodArray = tmpDic.value(forKey: "food") as! NSArray //食物图片数组

            
            //视图
            let uFoodView = Bundle.main.loadNibNamed("UfoodScrView", owner: nil, options: nil)?.last as! UfoodScrView
            
            uFoodView.frame = CGRect(x: 0, y: CGFloat(item) * avgHsize, width: UWsize, height: avgHsize)
            
            self.addSubview(uFoodView)
            
            uFoodView.nameLabel.text = name
            uFoodView.numberLabel.text = "(x\(swop)份)"

            
            
            for food in 0...foodArray.count - 1 {
                
                let foodDic = foodArray[food] as! NSDictionary
                
                let img = foodDic.value(forKey: "img") as! String
                let names = foodDic.value(forKey: "name") as! String
                let size = foodDic.value(forKey: "size") as! String
                //id
//                let id = foodDic.valueForKey("id") as! String
//                print("id:\(id)")
                
                
                let myFoodImgView = UIImageView(frame: CGRect(x: CGFloat(food) * (avgHsize - 30) + 20 * CGFloat(food + 1), y: 0, width: avgHsize - 30, height: avgHsize - 30))
                
                //MARK:图片点击什么的 ------------------
                myFoodImgView.isUserInteractionEnabled = true
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(UfoodAdviceView.imgAct(_:)))
                myFoodImgView.addGestureRecognizer(tap)
                myFoodImgView.tag = item * 1000 + food
                //------------------------------------
                uFoodView.myScrView.addSubview(myFoodImgView)
                
                uFoodView.myScrView.contentSize = CGSize(width: 20 * CGFloat(foodArray.count + 1) + (avgHsize - 30) * CGFloat(foodArray.count), height: avgHsize - 30)
                
                
                //透明视图
                let toumView = UIView(frame: CGRect(x: 0,y: myFoodImgView.frame.size.height - 20,width: myFoodImgView.frame.size.width,height: 20))
                toumView.backgroundColor = UIColor.black
                toumView.alpha = 0.3
                myFoodImgView.addSubview(toumView)
                
                //名字label
                let nameLabel = UILabel(frame: CGRect(x: 0,y: myFoodImgView.frame.size.height - 20,width: myFoodImgView.frame.size.width,height: 20))
                nameLabel.font = UIFont.systemFont(ofSize: 13)
                nameLabel.textColor = UIColor.darkGray
                nameLabel.textAlignment = .center
                myFoodImgView.addSubview(nameLabel)
  
                //设置图片
                let aaurl2 = img.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
                let imgurl2:URL = URL(string: aaurl2!)!
//                myFoodImgView.sd_setImage(with: imgurl2, placeholderImage: UIImage(named: self.imgString), completed: { (img:UIImage!, error:NSError!, type:SDImageCacheType, url:URL!) -> Void in
//                    
//                    if (error != nil){
//                        myFoodImgView.image = UIImage(named: self.imgFaild)
//                    }
//                    
//                })
                myFoodImgView.sd_setImage(with: imgurl2, placeholderImage: UIImage(named: self.imgString))
                
                
//                print(size,names)
                //设置名字
                nameLabel.text = "\(size)克\(names)"
    
                
            }
            
            
            
            
        }
    }
    
    func imgAct(_ send: UITapGestureRecognizer){

        
        print(URepViewCtr)
        
        let tag = send.view!.tag
        
        
        let mo = tag % 1000
        
        let sn = tag / 1000

        print("点击的是第\(sn)行，第\(mo)个")
        
        let typedic = self.myFoodArray[sn] as! NSDictionary

        let foodArr = typedic.value(forKey: "food") as! NSArray
        
        let tmpDic = foodArr[mo] as! NSDictionary
        
        
        
        if let id = tmpDic.value(forKey: "id") as? String{
            print(id)
            
            if id != "0" {
                self.toFoodCustomViewController(id)
            }else{
                print("没有食谱")
            }
            
        }else{
            print("没有id这个key")
        }
        
 
 
    }
    
    
    func toFoodCustomViewController(_ id: String) {

        let customVC = CustomFoodViewController()
        
        customVC.idString = id
        customVC.isShowDownView = false //不加载底部按钮
        
        self.URepViewCtr.navigationController?.pushViewController(customVC, animated: true)
        
        
    }
    

}
