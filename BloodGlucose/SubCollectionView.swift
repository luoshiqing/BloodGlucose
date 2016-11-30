//
//  SubCollectionView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/7.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SubCollectionView: UIView ,UICollectionViewDelegate, UICollectionViewDataSource{

    typealias secValueClours = (_ allHostArray: [Double],_ allNameAndSizeArray: [NSDictionary])->Void
    
    var subSecValueClours:secValueClours?
    
    
    
    
    var myCollectionView:UICollectionView!
    
    //MARK:上部跟底部视图
    var subUpView:SubUpView!
    var subDownView:SubDownView!
    
    
    
    
    //显示的
    var showNameArray = [String]()
    var showUrlArray = [String]()
    var showHostArray = [String]()
    
    //选择的数量
    var showTypeArray = [String]()
    //是否选择的
    var showIsHiddenArray = [Bool]()
    
    
    
    
    var secViewInt = 0
    
    func tapAct(_ send: UISwipeGestureRecognizer){

        let direction = send.direction
        switch direction {
        case UISwipeGestureRecognizerDirection.left:
            print("右 -> 左边")
            if self.secViewInt < 4 {
                self.secViewInt += 1
                self.subUpViewValueClours(self.secViewInt, nameStr: "滑动的")
                self.subUpView.resetUpView(self.secViewInt)
                
            }
            
            
            
        case UISwipeGestureRecognizerDirection.right:
            print("左 -> 右边")
            
            if self.secViewInt > 0 {
                self.secViewInt -= 1
                self.subUpViewValueClours(self.secViewInt, nameStr: "滑动的")
                self.subUpView.resetUpView(self.secViewInt)
            }
            
            
        default:
            break
        }
        
        
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let size = self.frame.size

        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(SubCollectionView.tapAct(_:)))
        self.addGestureRecognizer(swipeGesture)
        //左划
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(SubCollectionView.tapAct(_:)))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.left //不设置是右
        self.addGestureRecognizer(swipeLeftGesture)
        
        
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        layout.itemSize = CGSize(width: (size.width - 50) / 4, height: (size.width - 50) / 4 + 36)
        
        layout.minimumLineSpacing = 10.0  //上下间隔
        layout.minimumInteritemSpacing = 5.0 //左右间隔
        layout.headerReferenceSize = CGSize(width: 10, height: 10)
        layout.footerReferenceSize = CGSize(width: 10, height: 10)
        
//        layout.sectionInset.top = 10
//        layout.sectionInset.bottom = 10
        layout.sectionInset.left = 10
        layout.sectionInset.right = 10
        
        
        
        myCollectionView = UICollectionView(frame: CGRect(x: 0,y: 0,width: size.width,height: size.height), collectionViewLayout: layout)
        
        myCollectionView.backgroundColor = UIColor.white
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        self.addSubview(myCollectionView)
        
        let nib = UINib(nibName: "SubCollectionViewCell", bundle: Bundle.main)
        myCollectionView.register(nib, forCellWithReuseIdentifier: "SubCollectionCell")
        
        
    }
    //需要回传的数值
    var allHostArray = [Double]()
    
    var allNameAndSizeArray = [NSDictionary]()
    
    //回调
    func typeClours(_ tag: Int,value: String,tagValue: Int)->Void{
        print("回调的值？？？？:\(tag),,,,value:\(value),,,tagValue:\(tagValue)")
        
        
        if self.AtIndexSelected != nil {
            self.showTypeArray[self.AtIndexSelected] = value
            self.AtINDEXSelectedCell.contLabel.text = value
            
            
            let name:String = self.showNameArray[self.AtIndexSelected]
            let host:String = self.showHostArray[self.AtIndexSelected]
            
            //选中的热量
            let secHost = Double(tagValue) * Double(host)!
            print("选择的名称:\(name)-单个热量：\(host)-两数:\(tagValue)-选择的总热量：\(secHost)")
            
            self.allHostArray[AtIndexSelected] = secHost
            
            let dic:NSDictionary = ["name":name,
                                    "size":"\(tagValue)",
                                    "host":host]
            
            self.allNameAndSizeArray[AtIndexSelected] = dic
            
            let (tmpAddArray,tmpAllNameAndSizeArray) = self.addSomeType()
            
            self.subSecValueClours?(tmpAddArray,tmpAllNameAndSizeArray)
            
            
            
            
            
        }
        
        
        
    }
    
    func addSomeType() ->([Double],[NSDictionary]){
        
        //保存之前选择的其他类
        switch self.upSecUpType {
        case .midou:
            self.midou_isHiddenRcordArray = self.showIsHiddenArray
            self.midou_showTypeRcordArray = self.showTypeArray
            
            self.midou_hostRcordArray = self.allHostArray
            self.midou_Name_SizeRcordArray = self.allNameAndSizeArray
            
        case .rouqin:
            self.rouqin_isHiddenRcordArray = self.showIsHiddenArray
            self.rouqin_showTypeRcordArray = self.showTypeArray
            
            self.rouqin_hostRcordArray = self.allHostArray
            self.rouqin_Name_SizeRcordArray = self.allNameAndSizeArray
        case .shucai:
            self.shucai_isHiddenRcordArray = self.showIsHiddenArray
            self.shucai_showTypeRcordArray = self.showTypeArray
            
            self.shucai_hostRcordArray = self.allHostArray
            self.shucai_Name_SizeRcordArray = self.allNameAndSizeArray
        case .guopin:
            self.guopin_isHiddenRcordArray = self.showIsHiddenArray
            self.guopin_showTypeRcordArray = self.showTypeArray
            
            self.guopin_hostRcordArray = self.allHostArray
            self.guopin_Name_SizeRcordArray = self.allNameAndSizeArray
        case .shuiCP:
            self.shuicp_isHiddenRcordArray = self.showIsHiddenArray
            self.shuicp_showTypeRcordArray = self.showTypeArray
            self.shuicp_hostRcordArray = self.allHostArray
            self.shuicp_Name_SizeRcordArray = self.allNameAndSizeArray
            
        }
        
        
  
        //需要回传的数值
        var tmpAllHostArray = [Double]()
        

        for item in self.midou_hostRcordArray {
            if item != 0 {
                tmpAllHostArray.append(item)
            }
        }
        for item in self.rouqin_hostRcordArray {
            if item != 0 {
                tmpAllHostArray.append(item)
            }
        }
        for item in self.shucai_hostRcordArray {
            if item != 0 {
                tmpAllHostArray.append(item)
            }
        }
        for item in self.guopin_hostRcordArray {
            if item != 0 {
                tmpAllHostArray.append(item)
            }
        }
        for item in self.shuicp_hostRcordArray {
            if item != 0 {
                tmpAllHostArray.append(item)
            }
        }
        //名字
        var tmpAllNameAndSizeArray = [NSDictionary]()
        
        for item in self.midou_Name_SizeRcordArray {
            for (key,_) in item {
                
                let tmpkey = key as! String
                
                if tmpkey != "no" {
                    tmpAllNameAndSizeArray.append(item)
                    break
                }
            }
 
        }
        for item in self.rouqin_Name_SizeRcordArray {
            for (key,_) in item {
                
                let tmpkey = key as! String
                
                if tmpkey != "no" {
                    tmpAllNameAndSizeArray.append(item)
                    break
                }
            }
            
        }
        for item in self.shucai_Name_SizeRcordArray {
            for (key,_) in item {
                
                let tmpkey = key as! String
                
                if tmpkey != "no" {
                    tmpAllNameAndSizeArray.append(item)
                    break
                }
            }
            
        }
        for item in self.guopin_Name_SizeRcordArray {
            for (key,_) in item {
                
                let tmpkey = key as! String
                
                if tmpkey != "no" {
                    tmpAllNameAndSizeArray.append(item)
                    break
                }
            }
            
        }
        for item in self.shuicp_Name_SizeRcordArray {
            for (key,_) in item {
                
                let tmpkey = key as! String
                
                if tmpkey != "no" {
                    tmpAllNameAndSizeArray.append(item)
                    break
                }
            }
            
        }

        return (tmpAllHostArray,tmpAllNameAndSizeArray)
        
    }
    
    
    
    
    
    
    //MARK：记录历史选择
    //米豆类
    var midou_hostRcordArray = [Double]() //记录选择的热量
    var midou_Name_SizeRcordArray = [NSDictionary]() //记录选择的值
    var midou_isHiddenRcordArray = [Bool]() //记录选择位置
    var midou_showTypeRcordArray = [String]() //选择的数量
    
    //肉禽类
    var rouqin_hostRcordArray = [Double]() //记录选择的热量
    var rouqin_Name_SizeRcordArray = [NSDictionary]() //记录选择的值
    var rouqin_isHiddenRcordArray = [Bool]() //记录选择位置
    var rouqin_showTypeRcordArray = [String]() //选择的数量
    //蔬菜类
    var shucai_hostRcordArray = [Double]() //记录选择的热量
    var shucai_Name_SizeRcordArray = [NSDictionary]() //记录选择的值
    var shucai_isHiddenRcordArray = [Bool]() //记录选择位置
    var shucai_showTypeRcordArray = [String]() //选择的数量
    //果品类
    var guopin_hostRcordArray = [Double]() //记录选择的热量
    var guopin_Name_SizeRcordArray = [NSDictionary]() //记录选择的值
    var guopin_isHiddenRcordArray = [Bool]() //记录选择位置
    var guopin_showTypeRcordArray = [String]() //选择的数量
    //水产类
    var shuicp_hostRcordArray = [Double]() //记录选择的热量
    var shuicp_Name_SizeRcordArray = [NSDictionary]() //记录选择的值
    var shuicp_isHiddenRcordArray = [Bool]() //记录选择位置
    var shuicp_showTypeRcordArray = [String]() //选择的数量
    
    enum UpType {
        case midou,rouqin,shucai,guopin,shuiCP
    }
    
    var upSecUpType = UpType.midou
    
    //上面选择回调
    func subUpViewValueClours(_ tag: Int,nameStr: String)->Void{
        print("上面视图回调")
        
        //保存之前选择的其他类
        switch self.upSecUpType {
        case .midou:
            self.midou_isHiddenRcordArray = self.showIsHiddenArray
            self.midou_showTypeRcordArray = self.showTypeArray
            
            self.midou_hostRcordArray = self.allHostArray
            self.midou_Name_SizeRcordArray = self.allNameAndSizeArray
            
        case .rouqin:
            self.rouqin_isHiddenRcordArray = self.showIsHiddenArray
            self.rouqin_showTypeRcordArray = self.showTypeArray
            
            self.rouqin_hostRcordArray = self.allHostArray
            self.rouqin_Name_SizeRcordArray = self.allNameAndSizeArray
        case .shucai:
            self.shucai_isHiddenRcordArray = self.showIsHiddenArray
            self.shucai_showTypeRcordArray = self.showTypeArray
            
            self.shucai_hostRcordArray = self.allHostArray
            self.shucai_Name_SizeRcordArray = self.allNameAndSizeArray
        case .guopin:
            self.guopin_isHiddenRcordArray = self.showIsHiddenArray
            self.guopin_showTypeRcordArray = self.showTypeArray
            
            self.guopin_hostRcordArray = self.allHostArray
            self.guopin_Name_SizeRcordArray = self.allNameAndSizeArray
        case .shuiCP:
            self.shuicp_isHiddenRcordArray = self.showIsHiddenArray
            self.shuicp_showTypeRcordArray = self.showTypeArray
            self.shuicp_hostRcordArray = self.allHostArray
            self.shuicp_Name_SizeRcordArray = self.allNameAndSizeArray

        }
        
        

        switch tag {
        case 0:
            self.showNameArray = midouNameArray
            self.showUrlArray = midouUrlArray
            self.showHostArray = midouHostArray
            
            upSecUpType = UpType.midou
            
        case 1:
            self.showNameArray = rouqinNameArray
            self.showUrlArray = rouqinUrlArray
            self.showHostArray = rouqinHostArray
            
            upSecUpType = UpType.rouqin
        case 2:
            self.showNameArray = shucaiNameArray
            self.showUrlArray = shucaiUrlArray
            self.showHostArray = shucaiHostArray
            
            upSecUpType = UpType.shucai
        case 3:
            self.showNameArray = guopinNameArray
            self.showUrlArray = guopinUrlArray
            self.showHostArray = guopinHostArray
            
            upSecUpType = UpType.guopin
        case 4:
            self.showNameArray = shuicpNameArray
            self.showUrlArray = shuicpUrlArray
            self.showHostArray = shuicpHostArray
            
            upSecUpType = UpType.shuiCP
        default:
            break
        }
        
        self.showTypeArray.removeAll()
        self.showIsHiddenArray.removeAll()
        self.allNameAndSizeArray.removeAll()
        self.allHostArray.removeAll()
        
        switch self.upSecUpType {
        case .midou:
            
            self.showTypeArray = self.midou_showTypeRcordArray
            self.showIsHiddenArray = self.midou_isHiddenRcordArray
            self.allNameAndSizeArray = self.midou_Name_SizeRcordArray
            self.allHostArray = self.midou_hostRcordArray
            

        case .rouqin:
            
            if self.rouqin_isHiddenRcordArray.isEmpty{
                self.creatSomeArray()
            }else{
                self.showTypeArray = self.rouqin_showTypeRcordArray
                self.showIsHiddenArray = self.rouqin_isHiddenRcordArray
                self.allNameAndSizeArray = self.rouqin_Name_SizeRcordArray
                self.allHostArray = self.rouqin_hostRcordArray
            }
            
            
        case .shucai:
            if self.shucai_isHiddenRcordArray.isEmpty{
                self.creatSomeArray()
            }else{
                self.showTypeArray = self.shucai_showTypeRcordArray
                self.showIsHiddenArray = self.shucai_isHiddenRcordArray
                self.allNameAndSizeArray = self.shucai_Name_SizeRcordArray
                self.allHostArray = self.shucai_hostRcordArray
            }
        case .guopin:
            if self.guopin_isHiddenRcordArray.isEmpty{
                self.creatSomeArray()
            }else{
                self.showTypeArray = self.guopin_showTypeRcordArray
                self.showIsHiddenArray = self.guopin_isHiddenRcordArray
                self.allNameAndSizeArray = self.guopin_Name_SizeRcordArray
                self.allHostArray = self.guopin_hostRcordArray
            }
        case .shuiCP:
            if self.shuicp_isHiddenRcordArray.isEmpty{
                self.creatSomeArray()
            }else{
                self.showTypeArray = self.shuicp_showTypeRcordArray
                self.showIsHiddenArray = self.shuicp_isHiddenRcordArray
                self.allNameAndSizeArray = self.shuicp_Name_SizeRcordArray
                self.allHostArray = self.shuicp_hostRcordArray
            }
            
        }
        
   
        
        self.myCollectionView.reloadData()
        
        self.myCollectionView.contentOffset.y = 0.0
        
        self.subDownView.reloadDownView()
    }
    
    func creatSomeArray(){
        for _ in 0..<showNameArray.count {
            
            self.showTypeArray.append("")
            self.showIsHiddenArray.append(true)
            
            let dic:NSDictionary = ["no":"","no":""]
            self.allNameAndSizeArray.append(dic)
            
            self.allHostArray.append(0.0)
        }
    }
    
    
    
    
    //米豆
    var midouNameArray = [String]()
    var midouUrlArray = [String]()
    var midouHostArray = [String]()
    //蔬菜类
    var shucaiNameArray = [String]()
    var shucaiUrlArray = [String]()
    var shucaiHostArray = [String]()
    //肉禽
    var rouqinNameArray = [String]()
    var rouqinUrlArray = [String]()
    var rouqinHostArray = [String]()
    //水产品
    var shuicpNameArray = [String]()
    var shuicpUrlArray = [String]()
    var shuicpHostArray = [String]()
    //果品类
    var guopinNameArray = [String]()
    var guopinUrlArray = [String]()
    var guopinHostArray = [String]()
    
    
    
    func analyticalData(_ array: NSArray){
        
        for item in array {
            let tmpDic = item as! NSDictionary
  
            let typeName = tmpDic.value(forKey: "name") as! String

//            米面豆乳类,蔬菜类,肉禽类,水产品,果品类

            let taginfo = tmpDic.value(forKey: "taginfo") as! NSArray
            
            for index in taginfo {
                let ttmdic = index as! NSDictionary
                
                //热量
                let host = ttmdic.value(forKey: "host") as! String
                //图片
                let imgurl = ttmdic.value(forKey: "imgurl") as! String
                //名称
                let name = ttmdic.value(forKey: "name") as! String
                
                switch typeName {
                case "米面豆乳类":
                    midouNameArray.append(name)
                    midouUrlArray.append(imgurl)
                    midouHostArray.append(host)
                case "蔬菜类":
                    shucaiNameArray.append(name)
                    shucaiUrlArray.append(imgurl)
                    shucaiHostArray.append(host)
                case "肉禽类":
                    rouqinNameArray.append(name)
                    rouqinUrlArray.append(imgurl)
                    rouqinHostArray.append(host)
                case "水产品":
                    shuicpNameArray.append(name)
                    shuicpUrlArray.append(imgurl)
                    shuicpHostArray.append(host)
                case "果品类":
                    guopinNameArray.append(name)
                    guopinUrlArray.append(imgurl)
                    guopinHostArray.append(host)
                default:
                    break
                }
                
                
            }
     
        }
        self.showNameArray = self.midouNameArray
        self.showUrlArray = self.midouUrlArray
        self.showHostArray = self.midouHostArray
        
        for _ in 0..<self.showNameArray.count {
            self.showTypeArray.append("")
            self.showIsHiddenArray.append(true)
            
            let dic:NSDictionary = ["no":"","no":""]
            self.allNameAndSizeArray.append(dic)
            
            self.allHostArray.append(0.0)
            
        }
        
        
        
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showNameArray.count
    }
    
    
    //未加载完成显示的图片名称
    var imgString = "loadlogo.png"
    //加载失败
    var imgFaild = "loading_failed"
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identify:String = "SubCollectionCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identify, for: indexPath) as! SubCollectionViewCell
        
        
        let imgUrl:String = self.showUrlArray[(indexPath as NSIndexPath).row]

        let aaurl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        let imgurl:URL = URL(string: aaurl!)!
        

        
        cell.imgView.sd_setImage(with: imgurl, placeholderImage: UIImage(named: self.imgString))
        
        //名字
        cell.nameLabel.text = self.showNameArray[(indexPath as NSIndexPath).row]
        
        let typeValue = self.showTypeArray[(indexPath as NSIndexPath).row]
        if typeValue.isEmpty {
            cell.contLabel.text = ""
        }else{
            cell.contLabel.text = typeValue
        }
        //是否显示选择
        let isHidden = self.showIsHiddenArray[(indexPath as NSIndexPath).row]
        
        if isHidden == true {
            cell.trueImgView.isHidden = true
            cell.bgView.isHidden = true
        }else{
            cell.trueImgView.isHidden = false
            cell.bgView.isHidden = false
        }

        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
//        
//        
//        let frame = self.frame;
//        var width = frame.width
//        width = CGFloat(Int(width/4) - 15)
//        return CGSize(width: width, height: width)
//        
//        
//    }
    
    
    var AtIndexSelected:Int!
    var AtINDEXSelectedCell:SubCollectionViewCell!
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print((indexPath as NSIndexPath).row)

        if self.AtIndexSelected != nil {
            if self.showTypeArray[AtIndexSelected].isEmpty{
                AtINDEXSelectedCell.trueImgView.isHidden = true
                AtINDEXSelectedCell.bgView.isHidden = true

                self.showIsHiddenArray[AtIndexSelected] = true
            }
        }
        
        
        self.AtIndexSelected = (indexPath as NSIndexPath).row
        
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! SubCollectionViewCell
        self.AtINDEXSelectedCell = cell
        
        let isHidden = self.showIsHiddenArray[(indexPath as NSIndexPath).row]
        
        if isHidden == false { //取消选择
            cell.trueImgView.isHidden = true
            cell.bgView.isHidden = true
            self.showIsHiddenArray[(indexPath as NSIndexPath).row] = true
            cell.contLabel.text = ""
            
            let dic: NSDictionary = ["no":"","no":""]
            self.allNameAndSizeArray[(indexPath as NSIndexPath).row] = dic
            
            self.allHostArray[(indexPath as NSIndexPath).row] = 0.0
            
            
            let (tmpAddArray,tmpAllNameAndSizeArray) = self.addSomeType()
            
            print(tmpAllNameAndSizeArray)
            
            self.subSecValueClours?(tmpAddArray,tmpAllNameAndSizeArray)
            
            
        }else{
            cell.trueImgView.isHidden = false
            cell.bgView.isHidden = false
            self.showIsHiddenArray[(indexPath as NSIndexPath).row] = false
            
            self.showTypeArray[(indexPath as NSIndexPath).row] = ""
            cell.contLabel.text = ""
        }

        
        
        self.subDownView.reloadDownView()
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
