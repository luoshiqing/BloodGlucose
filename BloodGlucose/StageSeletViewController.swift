//
//  StageSeletViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/4/18.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class StageSeletViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    
    
    @IBOutlet weak var wuTangView: UIView!
    
    @IBOutlet weak var tangQianView: UIView!
    
    @IBOutlet weak var queZhenView: UIView!
    
    @IBOutlet weak var renShenView: UIView!
    
    
    
    
    var myTabView: UITableView?
    
    let mySize = UIScreen.main.bounds.size
    
    let nameArray = ["未诊断","妊娠糖尿病","2型糖尿病","1型糖尿病","继发性","特殊类型"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "请选择您的阶段"


        //设置视图圆角与边框
        self.setViewCircle()
        
        //设置视图点击事件
        self.setViewAct()
        
        
        //设置
        self.setMyTabView()
        
        
    }
    
    func setMyTabView(){
        
        let toLeft: CGFloat = 55
        let height: CGFloat = 46 * 7
        
        myTabView = UITableView(frame: CGRect(x: toLeft, y: (mySize.height - height) / 2, width: mySize.width - toLeft * 2, height: height))
        myTabView?.delegate = self
        myTabView?.dataSource = self
        
        myTabView?.tableFooterView = UIView()
        
        myTabView?.separatorStyle = .none
        
        myTabView?.backgroundColor = UIColor.clear
        
        myTabView?.isScrollEnabled = false
        
        self.view.addSubview(myTabView!)
        
        
        let headLabel = UILabel(frame: CGRect(x: 0,y: 0,width: mySize.width - toLeft * 2,height: 46))
        
        headLabel.backgroundColor = UIColor.clear
        
        headLabel.text = "请选择您的阶段"
        
        headLabel.textAlignment = .center
        
        headLabel.textColor = UIColor.orange
        
        
        headLabel.font = UIFont.systemFont(ofSize: 18)
        
        myTabView?.tableHeaderView = headLabel
        
        
    }
    
    //Tab代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.nameArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        return 46
        
 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ddd = "StageSelectCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? StageSelectTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("StageSelectTableViewCell", owner: self, options: nil )?.last as? StageSelectTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.none
  
        //设置选中cell 时的颜色
        cell?.selectionStyle = UITableViewCellSelectionStyle.none

        
        
        cell?.nameLabel.text = self.nameArray[(indexPath as NSIndexPath).row]
        
        
   
        
        
        return cell!
    }

    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        print(self.nameArray[(indexPath as NSIndexPath).row])
        
        
        let tmp = HealthService().bloodTypeCase(self.nameArray[indexPath.row])
        
        print(tmp)
        
        
        
        let stageInfVC = StageInfViewController()

        
        stageInfVC.bloodType = Int(tmp)!
        
        self.navigationController?.pushViewController(stageInfVC, animated: true)
  
    }
    
    
    
    
    
    
    
    func setViewCircle(){
        //设置 圆角
        self.wuTangView.layer.cornerRadius = 5
        self.wuTangView.clipsToBounds = true
        //边框
        self.wuTangView.layer.borderWidth = 0.5
        self.wuTangView.layer.borderColor = UIColor.orange.cgColor
        
        self.tangQianView.layer.cornerRadius = 5
        self.tangQianView.clipsToBounds = true
        self.tangQianView.layer.borderWidth = 0.5
        self.tangQianView.layer.borderColor = UIColor.orange.cgColor
        
        self.queZhenView.layer.cornerRadius = 5
        self.queZhenView.clipsToBounds = true
        self.queZhenView.layer.borderWidth = 0.5
        self.queZhenView.layer.borderColor = UIColor.orange.cgColor
        
        self.renShenView.layer.cornerRadius = 5
        self.renShenView.clipsToBounds = true
        self.renShenView.layer.borderWidth = 0.5
        self.renShenView.layer.borderColor = UIColor.orange.cgColor
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.coustomNav()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func coustomNav(){
//        self.navigationController?.navigationBar.translucent = false
//        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()

        
        self.navigationController?.navigationBar.isHidden = true
        

    }
    
   

    func setViewAct(){
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(StageSeletViewController.viewTap(_:)))
        self.wuTangView.addGestureRecognizer(tap1)
        self.wuTangView.tag = 1
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(StageSeletViewController.viewTap(_:)))
        self.tangQianView.addGestureRecognizer(tap2)
        self.tangQianView.tag = 2
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(StageSeletViewController.viewTap(_:)))
        self.queZhenView.addGestureRecognizer(tap3)
        self.queZhenView.tag = 3
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(StageSeletViewController.viewTap(_:)))
        self.renShenView.addGestureRecognizer(tap4)
        self.renShenView.tag = 4
        
        
    }
    func viewTap(_ send:UITapGestureRecognizer){
        
        let stageInfVC = StageInfViewController()
        
        switch send.view!.tag {
        case 1:
            print("无糖")
            stageInfVC.bloodType = 0
        case 2:
            print("糖前")
            stageInfVC.bloodType = 3
        case 3:
            print("确诊")
            stageInfVC.bloodType = 5
        case 4:
            print("妊娠")
            stageInfVC.bloodType = 1
        default:
            break
        }
        
        
        self.navigationController?.pushViewController(stageInfVC, animated: true)

    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
