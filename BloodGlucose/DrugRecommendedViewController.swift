//
//  DrugRecommendedViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/24.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit




class DrugRecommendedViewController: UIViewController {

    fileprivate let ScreenSize = UIScreen.main.bounds.size
    
    fileprivate var drugRecMainView: DrugRecMainView?
    
    fileprivate let lableH: CGFloat = 33.0 //lable高度
    fileprivate let downH: CGFloat = 60 //底部视图高度
    
    fileprivate var idString = ""   //选择的id
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "为您推荐"
        self.view.backgroundColor = UIColor.yellow
        
        
        self.setNav()
        
        self.loadTopAndDownView()
        
        self.loadDrugRecMainView()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if ((self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer))) != nil) {
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
        }
   
        self.getTwelveFood()
        
    }
    
    fileprivate func loadTopAndDownView(){
        //label
        let topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.ScreenSize.width, height: self.lableH))
        topLabel.backgroundColor = UIColor().rgb(232, g: 232, b: 232, alpha: 1)
        topLabel.text = "请选择下列食品："
        
        if #available(iOS 9.0, *) {
            topLabel.font = UIFont(name: PF_SC, size: 14)
        
        }else{
            topLabel.font = UIFont.systemFont(ofSize: 14)
        }
        self.view.addSubview(topLabel)
        //底部
        let y = self.ScreenSize.height - 64 - self.downH
        let downView = UIView(frame: CGRect(x: 0, y: y, width: self.ScreenSize.width, height: self.downH))
        downView.backgroundColor = UIColor().rgb(232, g: 232, b: 232, alpha: 1)
        self.view.addSubview(downView)
        
        //换一批
        let btnW: CGFloat = 69.0 * MYWSIZE
        let btnH: CGFloat = 30.0
        let toLeft: CGFloat = 20.0 * MYWSIZE
        let btnY = (self.downH - btnH) / 2
        
        let changeBtn = UIButton(frame: CGRect(x: toLeft, y: btnY, width: btnW, height: btnH))
        changeBtn.setTitle("换一批", for: UIControlState())
        changeBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor.white), for: UIControlState())
        changeBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor().rgb(246, g: 93, b: 34, alpha: 1)), for: .highlighted)
        changeBtn.layer.cornerRadius = btnH / 2
        changeBtn.layer.masksToBounds = true
        changeBtn.setTitleColor(UIColor.black, for: UIControlState())
        changeBtn.setTitleColor(UIColor.white, for: .highlighted)
        changeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        changeBtn.tag = 1
        changeBtn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
        downView.addSubview(changeBtn)
        //随便吃
        let randomBtn = UIButton(frame: CGRect(x: self.ScreenSize.width - toLeft - btnW, y: btnY, width: btnW, height: btnH))
        randomBtn.setTitle("随便吃", for: UIControlState())
        randomBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor.white), for: UIControlState())
        randomBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor().rgb(246, g: 93, b: 34, alpha: 1)), for: .highlighted)
        randomBtn.layer.cornerRadius = btnH / 2
        randomBtn.layer.masksToBounds = true
        randomBtn.setTitleColor(UIColor.black, for: UIControlState())
        randomBtn.setTitleColor(UIColor.white, for: .highlighted)
        randomBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        randomBtn.tag = 2
        randomBtn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
        downView.addSubview(randomBtn)
        //选好了
        let secBtnW: CGFloat = 90 * MYWSIZE
        let secBtnH: CGFloat = 40
        let secBtnX = (self.ScreenSize.width - secBtnW) / 2
        let secBtnY = (self.downH - secBtnH) / 2
        
        let selectBtn = UIButton(frame: CGRect(x: secBtnX, y: secBtnY, width: secBtnW, height: secBtnH))
        selectBtn.setTitle("选好了", for: UIControlState())
        selectBtn.backgroundColor = UIColor().rgb(246, g: 93, b: 34, alpha: 1)
        selectBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor().rgb(246, g: 93, b: 34, alpha: 1)), for: UIControlState())
        selectBtn.setBackgroundImage(UIImage().createImagFromColor(UIColor.white), for: .highlighted)
        selectBtn.layer.cornerRadius = secBtnH / 2
        selectBtn.layer.masksToBounds = true
        selectBtn.setTitleColor(UIColor.white, for: UIControlState())
        selectBtn.setTitleColor(UIColor().rgb(246, g: 93, b: 34, alpha: 1), for: .highlighted)
        selectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        selectBtn.tag = 3
        selectBtn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
        downView.addSubview(selectBtn)
        
    }
    

    fileprivate func getTwelveFood(){
        RecommendNetwork().getTwelveFood(self.view) { (imgUrlArray, nameArray, idArray) in

            self.drugRecMainView?.setRecMainViewValue(showImgArray: imgUrlArray, showNameArray: nameArray, idArray: idArray)
        }
    }
    
    fileprivate func loadDrugRecMainView(){
        
 
        let rect = CGRect(x: 0, y: self.lableH, width: ScreenSize.width, height: ScreenSize.height - 64 - self.lableH - self.downH)
        self.drugRecMainView = DrugRecMainView(frame: rect, secIndexMax: 5, line: 4, column: 3, spacing: 5.0 ,target: nil)
        
        self.drugRecMainView?.backgroundColor = UIColor.white
        
        self.drugRecMainView?.drugSecClourse = self.DrugRecMainViewSecClourse
        
        self.view.addSubview(self.drugRecMainView!)
        
    }
    //MARK:选择id回调
    func DrugRecMainViewSecClourse(_ idStr: String)->Void {
        print("回调id:->\(idStr)")
        
        self.idString = idStr
    }
    
    
    
    fileprivate func setNav(){
        //返回
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
    }

    func someBtnAct(send: UIButton){
        switch send.tag {
        case 0:
            self.navigationController!.popViewController(animated: true)
        case 1:
            //print("换一批")
            self.idString = "" //重置
            self.getTwelveFood()
        case 2:
            //print("随便吃")
            let (a,b,c) = RecommendNetwork().randomABC(min: 0, max: 11)
            self.drugRecMainView?.randomSetValue(secs: a,b,c)
        case 3:
            //print("选好了")
            if self.idString.isEmpty {
                let alert = UIAlertView(title: "温馨提示", message: "您还没有选择食材，请选择食材", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }else{
                
                let customVC = CustomFoodViewController()
                
                customVC.idString = self.idString
                
                self.navigationController?.pushViewController(customVC, animated: true)
                
            }
            
            
        default:
            break
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
