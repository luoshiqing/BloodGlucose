//
//  GuidePageViewController.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 15/10/23.
//  Copyright © 2015年 Sqluo. All rights reserved.
//

import UIKit

class GuidePageViewController: UIViewController,UIScrollViewDelegate {
    
    
    
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    
    
    var scrView = UIScrollView()
    
    var numofPages = 3
    
    var oneView:OneView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置按钮
        self.nextBtn.layer.cornerRadius = 4
        self.nextBtn.layer.masksToBounds = true
        self.nextBtn.layer.borderWidth = 1
        self.nextBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
        
        //
        self.pageControl.pageIndicatorTintColor = UIColor.groupTableViewBackground
        self.pageControl.currentPageIndicatorTintColor = UIColor.orange
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.yellow
        
        let frame = self.view.bounds
        
        self.scrView.frame = frame
        
        self.scrView.delegate = self
        
        //设置三个视图
        
        self.scrView.contentSize = CGSize(width: frame.size.width * CGFloat(self.numofPages), height: frame.size.height)
        
        self.scrView.isPagingEnabled = true
        self.scrView.showsVerticalScrollIndicator = false
        self.scrView.showsHorizontalScrollIndicator = false
        self.scrView.backgroundColor = UIColor.white
        self.scrView.scrollsToTop = false
        self.scrView.bounces = false
        self.view.addSubview(self.scrView)
        
        
        self.loadOneView()
        
        self.nextBtn.alpha = 0
        
        self.scrView.contentOffset = CGPoint(x: 0, y: 0)
        
        // 将这两个控件拿到视图的最上面
        self.view.bringSubview(toFront: self.pageControl)
        self.view.bringSubview(toFront: self.nextBtn)
        
        
        
        
    }
    
    
    
    //加载第一视图
    func loadOneView(){
        if self.oneView == nil {
            self.oneView = OneView(frame: CGRect(x: self.view.bounds.size.width * CGFloat(0),y: 0,width: self.view.bounds.size.width,height: self.view.bounds.size.height))
            self.oneView.backgroundColor = UIColor.white
            self.scrView.addSubview(self.oneView)
        }
    }
    //加载第二视图
    var towView:TowView!
    func loadTowView(){
        if self.towView == nil {
            self.towView = TowView(frame: CGRect(x: self.view.bounds.size.width * CGFloat(1),y: 0,width: self.view.bounds.size.width,height: self.view.bounds.size.height))
            self.towView.backgroundColor = UIColor.white
            self.scrView.addSubview(self.towView)
        }
    }
    
    
    //加载第三视图
    var threeView:ThreeView!
    func loadThreeView(){
        if self.threeView == nil {
            self.threeView = ThreeView(frame: CGRect(x: self.view.bounds.size.width * CGFloat(2),y: 0,width: self.view.bounds.size.width,height: self.view.bounds.size.height))
            self.threeView.backgroundColor = UIColor.white
            self.scrView.addSubview(self.threeView)
        }
    }
    
    
    
    
    var selectInt = 0
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        
        
        
        self.pageControl.currentPage = Int(offset.x / self.view.bounds.width)
        
        //        print("Int:\(self.pageControl.currentPage)")
        
        
        if self.pageControl.currentPage == self.numofPages - 1 {
            
            
            
            
            UIView.animate(withDuration: 0.5, animations: {
                self.nextBtn.alpha = 1.0
                
            }) 
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.nextBtn.alpha = 0.0
                
            }) 
        }
        
        
        if self.selectInt != self.pageControl.currentPage {
            
            
            self.selectInt = self.pageControl.currentPage
            
            switch self.pageControl.currentPage {
            case 0:
                print("ONE")
                
                self.cleranView()
                
                self.loadOneView()
                
            case 1:
                print("TOW")
                self.cleranView()
                
                self.loadTowView()
            case 2:
                print("THREE")
                
                self.cleranView()
                
                self.loadThreeView()
                
            default:
                break
            }
            
            
            
            
        }
        
        
        
    }
    
    
    func cleranView(){
        if self.oneView != nil {
            self.oneView.removeFromSuperview()
            self.oneView = nil
        }
        if self.towView != nil {
            self.towView.removeFromSuperview()
            self.towView = nil
        }
        if self.threeView != nil {
            self.threeView.removeFromSuperview()
            self.threeView = nil
        }
    }
    
    
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
