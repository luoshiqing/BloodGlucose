//
//  ZJCyleScrollView.swift
//  Lunbo
//
//  Created by sqluo on 16/6/16.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit



let sectionNum: Int = 100
let cellIdentifier: String = "cellIdentifier"
let width = (UIScreen.main.bounds.size.width)
let height = (UIScreen.main.bounds.size.height)



// 协议
protocol ZJCycleViewDelegate {
    func didSelectIndexCollectionViewCell(_ index: Int)->Void
}




class ZJCyleScrollView: UIView ,UICollectionViewDelegate, UICollectionViewDataSource{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var delegate: ZJCycleViewDelegate?
    var cycleCollectionView: UICollectionView?
    var images = [String]()
    var pageControl = UIPageControl()
    var flowlayout = UICollectionViewFlowLayout()
    var timer = Timer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 创建collectionview
    func createSubviews(_ frame: CGRect){
        cycleCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), collectionViewLayout: flowlayout)
        flowlayout.itemSize = CGSize(width: frame.size.width, height: frame.size.height);
        flowlayout.minimumInteritemSpacing = 0;
        flowlayout.minimumLineSpacing = 0;
        flowlayout.scrollDirection = UICollectionViewScrollDirection.horizontal;
        //设置颜色
        cycleCollectionView!.backgroundColor = UIColor.lightGray
        cycleCollectionView!.isPagingEnabled = true
        cycleCollectionView!.dataSource  = self
        cycleCollectionView!.delegate = self
        cycleCollectionView!.showsHorizontalScrollIndicator = false
        cycleCollectionView!.showsVerticalScrollIndicator = false
        cycleCollectionView!.register(ZJCustomCycleCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.addSubview(cycleCollectionView!)
        
        pageControl = UIPageControl.init(frame: CGRect(x: 0, y: 0, width: frame.size.width / 2, height: 30))
        pageControl.center = CGPoint(x: frame.size.width / 2, y: frame.size.height - 6);
        
        //颜色
        pageControl.currentPageIndicatorTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor.white
        
        self.addSubview(pageControl);
        self.addTimer()
        
    }
    
    func addTimer(){
        let timer1 = Timer.init(timeInterval: 3, target: self, selector: #selector(ZJCyleScrollView.nextPageView), userInfo: nil, repeats: true)
        RunLoop.current.add(timer1, forMode: RunLoopMode.commonModes)
        timer = timer1
    }
    func removeTimer(){
        self.timer.invalidate()
    }
    
    func returnIndexPath()->IndexPath{
        var currentIndexPath = cycleCollectionView!.indexPathsForVisibleItems.last
        currentIndexPath = IndexPath.init(row: ((currentIndexPath as NSIndexPath?)?.row)!, section: sectionNum / 2)
        cycleCollectionView!.scrollToItem(at: currentIndexPath!, at: UICollectionViewScrollPosition.left, animated: false)
        return currentIndexPath!;
    }
    func nextPageView(){
        
        let indexPath = self.returnIndexPath()
        var item = (indexPath as NSIndexPath).row + 1;
        var section = (indexPath as NSIndexPath).section;
        if item == images.count {
            item = 0
            section += 1
        }
        self.pageControl.currentPage = item;
        let nextIndexPath = IndexPath.init(row: item, section: section)
        cycleCollectionView!.scrollToItem(at: nextIndexPath, at: UICollectionViewScrollPosition.left, animated: true)
    }
    
    
    //未加载完成显示的图片名称
    var imgString = "banLoding"
    //加载失败
    var imgFaild = "banfFailed"
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ZJCustomCycleCell
        cell.labelTitle.text = ""

        
        
        let url = self.images[indexPath.row]
        
        let aaurl2 = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        
        let imgurl2:URL = URL(string: aaurl2!)!
        
//        cell.imageView.sd_setImage(with: imgurl2, placeholderImage: UIImage(named: self.imgString), completed: { (img:UIImage!, error:NSError!, type:SDImageCacheType, url:URL!) -> Void in
//            
//            if (error != nil){
//                cell.imageView.image = UIImage(named: self.imgFaild)
//            }
//            
//        })
        
        cell.imageView.sd_setImage(with: imgurl2, placeholderImage: UIImage(named: self.imgString))
        
//        cell.imageView.sd_setImageWithURL(<#T##url: NSURL!##NSURL!#>, placeholderImage: <#T##UIImage!#>)
        
        
//        cell.imageView.image = UIImage(named: "\(self.images[indexPath.row] as! String)")
        
        //设置图片

        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionNum
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = images.count
        return images.count
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.addTimer()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.removeTimer()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = (Int(scrollView.contentOffset.x) / Int(width)) % images.count
        pageControl.currentPage = page
    }
    // 点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
        self.delegate?.didSelectIndexCollectionViewCell((indexPath as NSIndexPath).row)
    }
    
    
    
    
    

}
