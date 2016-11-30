//
//  DrugRecMainView.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/24.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class DrugRecMainView: UIView ,UICollectionViewDelegate, UICollectionViewDataSource{

    typealias DrugRecMainViewSecClourse = (_ idStr: String)->Void
    var drugSecClourse: DrugRecMainViewSecClourse?
 
    fileprivate var showImgArray    = [String]() //图片
    fileprivate var showNameArray   = [String]() //名称
    fileprivate var idArray         = [String]() //id
    
    fileprivate var secArray        = [Bool]() //是否选择，默认false未选择
    
    
    fileprivate var myFrame: CGRect!
    
    fileprivate var myCollectionView: UICollectionView?
    
    fileprivate let notSecImg = "huahou-baise" //未选择图片名
    fileprivate let secImg = "huahou-juse"     //选择的图片名
    
    fileprivate var secIndexMax = 0 //最大选择数量
    
    fileprivate var line = 4    //行
    fileprivate var column = 3  //列
    fileprivate var spacing: CGFloat = 5.0 //间距
    
    fileprivate var superCtr: UIViewController?
    /*
     1. secIndexMax ->最大选择数量
     2. line -> 一屏幕显示多少行
     3. column 列
     4. spacing 间距
    */
    init(frame: CGRect ,secIndexMax: Int, line: Int, column: Int, spacing: CGFloat,target: UIViewController?) {
        super.init(frame: frame)
        self.myFrame = frame
        
        self.line = line
        self.column = column
        self.spacing = spacing
        
        self.secIndexMax = secIndexMax
        
        self.superCtr = target
        
        self.setCollecionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    //MARK:设置值接口
    func setRecMainViewValue(showImgArray: [String], showNameArray: [String],idArray: [String]){
        self.showImgArray = showImgArray
        self.showNameArray = showNameArray
        self.idArray = idArray
        
   
        self.secArray = self.initSecArray(count: self.showImgArray.count)
        
        
        self.myCollectionView?.reloadData()
        
    }
    
    fileprivate func initSecArray(count: Int) -> [Bool] {
        var tmpSecArray = [Bool]()
        for _ in 0..<count {
            tmpSecArray.append(false)
        }
        return tmpSecArray
    }
    
    //MARK:随便吃调用接口
    func randomSetValue(secs: Int...){
        
        //重置选择数组
        self.secArray = self.initSecArray(count: self.showImgArray.count)
        
        for item in secs {
            self.secArray[item] = true
        }
        self.myCollectionView?.reloadData()
        
        let idstr = self.generateIDToString() //获取选择的id集合
        self.drugSecClourse?(idstr) //回调
        
    }
    
    func restSecValue(){
        
        for index in 0..<self.secArray.count {
            self.secArray[index] = false
        }
        self.myCollectionView?.reloadData()
    }
    
    
    
    //设置ColloctionView的属性
    func setColloctionView(line: Int, column: Int, spacing: CGFloat){
        self.line = line
        self.column = column
        self.spacing = spacing
    }
    
    fileprivate func setCollecionView(){
        
        let size = self.myFrame.size
  
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.itemSize = CGSize(width: (size.width - CGFloat(column + 1) * spacing) / CGFloat(column), height: (size.height - CGFloat(line + 1) * spacing) / CGFloat(line))
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        layout.headerReferenceSize = CGSize(width: spacing, height: spacing)

        layout.footerReferenceSize = CGSize(width: spacing, height: spacing)
        
        layout.sectionInset.left = spacing
        layout.sectionInset.right = spacing
        
  
        
        self.myCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height), collectionViewLayout: layout)
        
        self.myCollectionView?.backgroundColor = UIColor.white
 
        let nib = UINib(nibName: "DrugRecMainCollectionViewCell", bundle: Bundle.main)
        self.myCollectionView?.register(nib, forCellWithReuseIdentifier: "DrugRecMainCell")
        
        self.myCollectionView?.delegate = self
        self.myCollectionView?.dataSource = self
        
        self.addSubview(self.myCollectionView!)
        
    }
    
    //未加载完成显示的图片名称
    fileprivate let imgString = "loadlogo.png"
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.showImgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let identify:String = "DrugRecMainCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identify, for: indexPath) as! DrugRecMainCollectionViewCell
        
        if self.secIndexMax == 0 { //单选模式隐藏 选中图标
            cell.isSecImgView.isHidden = true
        }else{
            cell.isSecImgView.isHidden = false
        }
        
        
        if !self.showImgArray.isEmpty {
            let tmpImgUrl = "http://\(self.showImgArray[indexPath.row])"
            let name = self.showNameArray[indexPath.row]
            
            let allowedUrl = tmpImgUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            
            let imgUrl = URL(string: allowedUrl!)
            
            cell.mainImgView.sd_setImage(with: imgUrl!, placeholderImage: UIImage(named: self.imgString))
            
            cell.nameLabel.text = name
            
            let isSec = self.secArray[indexPath.row]
            
            if isSec {
                cell.isSecImgView.image = UIImage(named: self.secImg)
            }else{
                cell.isSecImgView.image = UIImage(named: self.notSecImg)
            }
            
            
        }
 
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if self.secIndexMax == 0 { //单选模式
            
            let idstr = self.idArray[indexPath.row]
            
            let name = self.showNameArray[indexPath.row]
            
            let taskDetailVC = TaskDetailViewController(title: name, mid: idstr)
            self.superCtr?.navigationController?.pushViewController(taskDetailVC, animated: true)
            
            
            
        }else{ //多选模式
            
            if self.checkMaxSelect(index: indexPath.row) {
                
                let isSec = self.secArray[indexPath.row]
                self.secArray[indexPath.row] = !isSec
                
                let cell = collectionView.cellForItem(at: indexPath) as! DrugRecMainCollectionViewCell
                
                if !isSec == true {
                    cell.isSecImgView.image = UIImage(named: self.secImg)
                }else{
                    cell.isSecImgView.image = UIImage(named: self.notSecImg)
                }
                
                let idstr = self.generateIDToString() //获取选择的id集合
                
                self.drugSecClourse?(idstr) //回调
                
            }else{
                print("最多选择\(self.secIndexMax)个")
                
                let alert = UIAlertView(title: "温馨提示", message: "最多选择\(self.secIndexMax)种食材", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                
            }
        }
        
        
        
  
    }
    
    
    //校验选择数量是否超过上限
    fileprivate func checkMaxSelect(index: Int) -> Bool{
        
        let isSec = self.secArray[index]
        
        var secIndex = 0
        for isTrue in self.secArray {
            if isTrue {
                secIndex += 1
            }
        }
        if secIndex >= self.secIndexMax {
            
            if isSec { //如果已经是选择状态
                return true
            }else{
                return false
            }
        }else{
            return true
        }
    
    }
    
    //生成选择了的id字符串
    fileprivate func generateIDToString() -> String{
        
        
        var idString = ""
        
        for index in 0..<self.secArray.count {
            let isSec = self.secArray[index]
            if isSec {
                let str = self.idArray[index]
                
                if idString.isEmpty {
                    idString = str
                }else{
                    idString += ":\(str)"
                }
            }
        }
        return idString
    }
    
    
 
}
