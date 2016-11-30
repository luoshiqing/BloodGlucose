//
//  EndRiskViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/23.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

enum RiskType {
    case sex        //性别
    case birth      //生日
    case height     //身高
    case weight     //体重
    case waist      //腹围
    case shrinkage  //收缩压
    case family     //家族
    case blood      //血糖
}



class EndRiskViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    fileprivate let Wsize = UIScreen.main.bounds.width / 375
    fileprivate let Hsize = (UIScreen.main.bounds.height - 64) / (667 - 64)
    //标题
    let titleArray = [["性别","出生日期"],["身高(cm)","体重(kg)"],["腰围(cm)","收缩压(高压)"],["糖尿病家族史","空腹血糖"]]
    let imgArray = [["risk_sex","risk_birth"],["risk_height","risk_weight"],["risk_waist","risk_shrinkage"],["risk_family","risk_blood"]]
    
    
    
    //值数组
    var valueArray = [Array<String>]()
    fileprivate var upDic = [String:Any]()
    
    var myTabView: UITableView?
    
    //评分等级
    fileprivate var scoreLevelLabel: UILabel?
    fileprivate var bmiValueLabel: UILabel?
    //评分
    var scoreLabel: UILabel?
    
    
    fileprivate var currentDate: Date? //记录选择的时间
    
    
    //分割线颜色
    let dividerColor = UIColor().hexStringToColor("#eaecee")
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
        
        self.title = "风险评估"
        self.view.backgroundColor = UIColor.white
        
        self.setNav()
        self.setTabView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        BaseTabBarView.isHidden = true
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        MyNetworkRequest().getRiskAssessment(self.view) { (success, value, upDic) in
            
            
            if success{
                
                let dic = value as! [String:AnyObject]
                
                let icvalue = dic["icvalue"] as! String
                
                let bmi = dic["bmi"] as! String
                
                if let range = dic["range"] as? String{
                    self.scoreLevelLabel?.text = range
                }
                
                self.bmiValueLabel?.text = bmi
                self.scoreLabel?.text = "\(icvalue)分"
                
                
                let arrayValue = dic["values"] as! [Array<String>]
                
                self.valueArray = arrayValue
                
                self.myTabView?.reloadData()
                
                self.upDic = upDic
                print(upDic)
                
            }
        }
        
    }
    
    
    
    let headH: CGFloat = 158 / 2.0
    let mySize = UIScreen.main.bounds.size
    
    func setTabView(){
        
        myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: mySize.width, height: mySize.height - 64))
        
        myTabView?.delegate = self
        myTabView?.dataSource = self
        
        
        
        myTabView?.separatorStyle = .none
        
        self.view.addSubview(myTabView!)
        
        
        
        let headView = UIView(frame: CGRect(x: 0,y: 0,width: mySize.width,height: headH * self.Hsize))
        headView.backgroundColor = UIColor.white
        
        self.myTabView?.tableHeaderView = headView
        
        //您的风险系数
        let yourLabel = UILabel(frame: CGRect(x: 18,y: 8,width: 150,height: 15))
        yourLabel.text = "您的风险系数"
        yourLabel.textColor = UIColor().hexStringToColor("#3b3b3b")
        yourLabel.font = UIFont(name: PF_SC, size: 14)
        headView.addSubview(yourLabel)
        
        //评分等级
        scoreLevelLabel = UILabel(frame: CGRect(x: (mySize.width - 50) / 2,y: headH * self.Hsize - 32 - 10,width: 50,height: 32))
        scoreLevelLabel?.text = ""
        scoreLevelLabel?.textAlignment = .center
        scoreLevelLabel?.textColor = UIColor().hexStringToColor("#f65d26")
        scoreLevelLabel?.font = UIFont(name: PF_SC, size: 31)
        headView.addSubview(scoreLevelLabel!)
        
        //评分
        scoreLabel = UILabel(frame: CGRect(x: mySize.width - 50 - 24,y: headH * self.Hsize - 17 - 10,width: 50,height: 17))
        scoreLabel?.text = ""
        scoreLabel?.textColor = UIColor().hexStringToColor("#aaaaaa")
        scoreLabel?.textAlignment = .right
        scoreLabel?.font = UIFont(name: PF_SC, size: 16)
        headView.addSubview(scoreLabel!)
        
        //
        let downH = mySize.height - 64 -  110 * self.Hsize * 4 - headH * self.Hsize
        
        let footView = UIView(frame: CGRect(x: 0,y: mySize.height - 64 - downH,width: mySize.width,height: downH))
        footView.backgroundColor = UIColor().hexStringToColor("#f8f8f8")
        
        self.myTabView?.tableFooterView = footView
        
        
        let bmiView = UIView(frame: CGRect(x: 0,y: 7,width: mySize.width,height: 32 * self.Hsize))
        bmiView.backgroundColor = UIColor.white

        footView.addSubview(bmiView)

        //线条
        let topLine = UIView(frame: CGRect(x: 0,y: 0,width: mySize.width,height: 0.5))
        topLine.backgroundColor = self.dividerColor
        bmiView.addSubview(topLine)
        
        let bottomLine = UIView(frame: CGRect(x: 0,y: 32 * self.Hsize - 0.5,width: mySize.width,height: 0.5))
        bottomLine.backgroundColor = self.dividerColor
        bmiView.addSubview(bottomLine)
        
        //BMI
        let bmiW: CGFloat = 17.0 * self.Wsize
        let bmiImgView = UIImageView(frame: CGRect(x: 24, y: (32 * self.Hsize - bmiW) / 2, width: bmiW, height: bmiW))
        bmiImgView.image = UIImage(named: "risk_BMI")
        bmiView.addSubview(bmiImgView)
        
        //计算得出BMI指数
        let bmiLabelW: CGFloat = 120.0
        let bmiLabel = UILabel(frame: CGRect(x: 24 + bmiW + 3,y: (32 * self.Hsize - bmiW) / 2,width: bmiLabelW,height: bmiW))
        bmiLabel.text = "计算得出BMI指数"
        bmiLabel.textColor = UIColor().hexStringToColor("#313131")
        bmiLabel.font = UIFont(name: PF_TC, size: 13)
        bmiView.addSubview(bmiLabel)
     
        bmiValueLabel = UILabel(frame: CGRect(x: 24 + bmiW + 3 + bmiLabelW + 20,y: (32 * self.Hsize - bmiW) / 2,width: 50,height: bmiW))
        bmiValueLabel?.textColor = UIColor().hexStringToColor("#18a4fb")
        bmiValueLabel?.text = ""
        bmiValueLabel?.font = UIFont(name: PF_SC, size: 14)
        
        bmiView.addSubview(bmiValueLabel!)
        
        
    }

    
    
    

    func setNav(){
        
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(EndRiskViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
        //添加
        let (rightBtn,rightSpacer,rightItem) = BGNetwork().creatRightBtnAtt(false, title: "完成")
        rightBtn.addTarget(self, action: #selector(EndRiskViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        rightBtn.tag = 1
        self.navigationItem.rightBarButtonItems = [rightSpacer,rightItem]
        
        
    }
    
    var riskValueView: RiskValueView!
    
    func someBtnAct(_ send: UIButton){
        switch send.tag {
        case 0:
            self.navigationController!.popViewController(animated: true)
        case 1:
            print("提交")
            print(self.upDic)
            MyNetworkRequest().saveRiskAssessment(self.upDic, view: self.view, clourse: { (value) in
                print(value)
                self.bmiValueLabel?.text = value["bmi"]
                self.scoreLabel?.text = value["icvalue"]
                
                let icvaluedata = value["icvaluedata"]!
                
                
                let range = value["range"]
                
                self.scoreLevelLabel?.text = range
                
                self.riskValueView = RiskValueView()
                self.riskValueView.SLRiskCtr = self
                self.riskValueView.initRiskValueView(range, icvaluedata: icvaluedata)
     
            })
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110 * self.Hsize
        
    }
    
    //cacheIndexpath
    var cacheIndexPath: IndexPath!
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "EndRiskCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? EndRiskTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("EndRiskTableViewCell", owner: self, options: nil )?.last as? EndRiskTableViewCell
            
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        cell?.viewActClourse = self.EndRiskTableViewCellViewActClourse
        
      
        //图
        let img0 = self.imgArray[indexPath.row][0]
        let img1 = self.imgArray[indexPath.row][1]
        
        cell?.leftImgView.image = UIImage(named: img0)
        cell?.rightImgView.image = UIImage(named: img1)
        //标题
        let title0 = self.titleArray[indexPath.row][0]
        let title1 = self.titleArray[indexPath.row][1]
        
        cell?.leftTitleLabel.text = title0
        cell?.rightTitleLabel.text = title1
        
     
        
        //赋tag值
        cell?.leftTouchView.tag = indexPath.row * 2
        cell?.rightTouchView.tag = indexPath.row * 2 + 1
        
        
        if !self.valueArray.isEmpty {
            
            let leftValue = self.valueArray[indexPath.row][0]
            let rightValue = self.valueArray[indexPath.row][1]
            
            cell?.leftValueLabel.text = leftValue
            cell?.rightValueLabel.text = rightValue
        }
    
        return cell!
        
    }
    
    var dateChooseView: MyDateChooseView! //出生日期
    var bloodChooseView: BloodChooseView! //指血选择
    
    //存放临时点击的cell
    var tmpCell: EndRiskTableViewCell?
    //记录选择的是左还是右
    var isLeft: Bool = false
    //记录选择的类型
    var secRiskType = RiskType.sex
    
    func EndRiskTableViewCellViewActClourse(_ tag: Int,type: RiskType,cell: EndRiskTableViewCell)->Void{
        
        print("回调了 。。。。")
        self.tmpCell = cell
        self.secRiskType = type
        
        let line = tag / 2
        let column = tag % 2
        
        if column == 0 {
            self.isLeft = true
        }else{
            self.isLeft = false
        }
        
        let title = self.titleArray[line][column]
        
        switch tag {
        case 1:
            //print("出生日期")
            dateChooseView = MyDateChooseView()
            dateChooseView.okBtnClourse = self.MyDateChooseViewOkBtnClourse
            dateChooseView.initMyDateChooseView(title, dataArray: nil, isDate: true, currentDate: self.currentDate, model: .date)
            
            self.view.addSubview(dateChooseView)
        case 7:
            //print("空腹血糖")
            bloodChooseView = BloodChooseView()
            bloodChooseView.touchValue = self.BloodChooseViewTouchValue
            bloodChooseView.initBloodChooseView(title ,value: 0 ,section: nil)
        default:
            //print("其他")
            dateChooseView = MyDateChooseView()
            dateChooseView.okBtnClourse = self.MyDateChooseViewOkBtnClourse
            let data = self.getDataArray(type)
            
            dateChooseView.initMyDateChooseView(title, dataArray: data, isDate: false, currentDate: nil, model: nil)
            
        }

     
        
    }
    
    func getDataArray(_ type: RiskType) ->[String]{
        
        var tmpArray = [String]()
        
        switch type {
        case .sex:
            tmpArray = ["男","女"]
        case .height:
            for index in 100...200{
                tmpArray.append("\(index)")
            }
        case .weight:
            for index in 35...180{
                tmpArray.append("\(index)")
            }
        case .waist:
            for index in 50...120 {
                
                if index % 2 == 0 {
                    let cm = "\(index)cm"
                    
                    let chi: Float = Float(index) * 0.03
                    
                    let chicun = "\(chi)尺"
                    
                    tmpArray.append(cm + "--" + chicun)
                }
                
            }
        case .shrinkage: //收缩压
            for index in 80...200{
                tmpArray.append("\(index)")
            }
        case .family:
            tmpArray = ["有","无"]
        default:
            break
        }
        
        return tmpArray
        
    }
    
    
    //出生日期-其他 选择回调
    func MyDateChooseViewOkBtnClourse(_ value: String)->Void{
        
        var tmpValue = value
        
        if self.secRiskType == .birth {
            tmpValue = (tmpValue as NSString).substring(with: NSRange(location: 0, length: 10))

            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let tmpDate = formatter.date(from: value)
            
            self.currentDate = tmpDate
    
            
        }
        
        print(tmpValue)
        
        if self.isLeft {
            tmpCell?.leftValueLabel.text = tmpValue
        }else{
            tmpCell?.rightValueLabel.text = tmpValue
        }
        
        
        switch self.secRiskType {
        case .sex:
            let sexInt = tmpValue == "女" ? "0" : "1"
            self.upDic["sex"] = sexInt
        case .birth:
            self.upDic["birth"] = tmpValue
        case .height:
            self.upDic["height"] = tmpValue
            
            if let hei = self.upDic["weight"] as? String {
                self.showBmi(Float(tmpValue)!, weight: Float(hei)!)
            }
      
        case .weight:
            self.upDic["weight"] = tmpValue
            if let hei = self.upDic["height"] as? String {
                self.showBmi(Float(hei)!, weight: Float(tmpValue)!)
            }
        case .waist:
            
            let va = tmpValue.components(separatedBy: "cm")[0]
            
            print(va)
            tmpCell?.leftValueLabel.text = va
            
            self.upDic["abdomen"] = va
        case .shrinkage:
            self.upDic["pht"] = tmpValue
        case .family:
            let familyInt = tmpValue == "有" ? "1" : "0"
            self.upDic["familydiabetes"] = familyInt
        default:
            break
        }
        
        
    }
    //显示Bmi
    func showBmi(_ height: Float,weight: Float){
        let bmi = CalculationMethod().getBmiMethod(height, weight: weight)
 
        self.bmiValueLabel?.text = bmi
        
    }
    
    
    
    //指血回调
    func BloodChooseViewTouchValue(_ tag: Int ,value: String?)->Void{
        if let va = value {
            tmpCell?.rightValueLabel.text = va
            self.upDic["fbg"] = va
        }
        
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
