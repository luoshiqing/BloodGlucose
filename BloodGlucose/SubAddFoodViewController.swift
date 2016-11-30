//
//  SubAddFoodViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/7.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SubAddFoodViewController: UIViewController {

   
    typealias addFoodClours = (_ host: Double,_ nameArray: [NSDictionary])->Void
    var subAddFoodClours:addFoodClours?
    
    var jsonArray:NSArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "添加食物"
        self.view.backgroundColor = UIColor.white
        
        self.setNav()
        
        //读取本地文件
        self.readFillPath()
        
        
        //中间collection
        self.loadCollectionView()
        //设置上边选择类型
        self.loadUpView()
 
        //设置下边计量视图
        self.loadDownView()
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readFillPath(){
        let path: String = Bundle.main.path(forResource: "eventtaglist", ofType: "txt")!
        
        do{
            let data = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            
            do{
                let json = try JSONSerialization.jsonObject(with: data.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                
                self.jsonArray = json

            }catch{
                print(error)
            }
            
            
        }catch let erro as NSError{
            print(erro)
        }
    }
    
    
    
   
    
    
    func setNav(){
        
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(SubAddFoodViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
        
        //添加
        let (rightBtn,rightSpacer,rightItem) = BGNetwork().creatRightBtnAtt(false, title: "完成")
        rightBtn.addTarget(self, action: #selector(SubAddFoodViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
        rightBtn.tag = 1
        self.navigationItem.rightBarButtonItems = [rightSpacer,rightItem]
        
    }

    func btnAct(_ send: UIButton){
        switch send.tag {
        case 0:
//            let actionSheet = UIAlertController(title: "是否退出本次编辑", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//            actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: { (act:UIAlertAction) in
//                
//                self.navigationController?.popViewControllerAnimated(true)
//                
//            }))
//            actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
//            self.presentViewController(actionSheet, animated: true, completion: nil)
            self.navigationController!.popViewController(animated: true)
        case 1:
            print("完成了，回调返回了")
            
 
            var allHost = 0.0
            for item in self.hostArray {
                allHost += item
            }


            self.subAddFoodClours?(allHost,self.nameAndSizeArray)
            
            self.navigationController!.popViewController(animated: true)
            
            
        default:
            break
        }
    }
    
    func loadUpView(){
        let upView = SubUpView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width ,height: 44))
        upView.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1)
        
        upView.subUpViewValueClours = self.collectionView.subUpViewValueClours
        
        
        self.collectionView.subUpView = upView
        
        self.view.addSubview(upView)

    }
    
    
    
    
    //中间
    var collectionView:SubCollectionView!
    func loadCollectionView(){
        collectionView = SubCollectionView(frame: CGRect(x: 0,y: 44,width: UIScreen.main.bounds.width ,height: UIScreen.main.bounds.height - 64 - 44 - 48.5))
        collectionView.analyticalData(self.jsonArray)
        collectionView.backgroundColor = UIColor.white
        //
        collectionView.subSecValueClours = self.secValueClours
        
        self.view.addSubview(collectionView)
 
    }
    
    
    var hostArray = [Double]()
    var nameAndSizeArray = [NSDictionary]()
    
    func secValueClours(_ allHostArray: [Double],allNameAndSizeArray: [NSDictionary])->Void{
        print("回调了")
        
        self.hostArray = allHostArray
        self.nameAndSizeArray = allNameAndSizeArray
        
        print(nameAndSizeArray)
        
        
    }
    
    func loadDownView(){
        
        let downView = SubDownView(frame: CGRect(x: 0 ,y: UIScreen.main.bounds.height - 48.5 - 64 ,width: UIScreen.main.bounds.width ,height: 48.5))
        downView.backgroundColor = UIColor.white
        
        downView.subTypeClours = collectionView.typeClours
        
        self.collectionView.subDownView = downView
        
        self.view.addSubview(downView)
    }
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
