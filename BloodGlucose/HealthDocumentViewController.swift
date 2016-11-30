//
//  HealthDocumentViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/15.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class HealthDocumentViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    
    var myTabView: UITableView?
    
    var titleArray = [["姓名","性别","出生日期"],
                      ["身高cm","体重kg","BMI(经计算所得,无需输入)"],
                      ["糖尿病类型","确诊时间","并发症情况"],
                      ["既往病史"],
                      ["目前用药"],
                      ["父母是否患有糖尿病"],
                      ["药物过敏情况"],
                      ["最近空腹血糖mmol/L","糖化血红蛋白","血压(mmHg)"],
                      ["近期化验结果"]]
    
    
    var a: Int?
    
    var valueArray: [Array<Any>] = [["","",""],
                                    ["","","",],
                                    ["","","",],
                                    [""],
                                    [""],
                                    [""],
                                    [""],
                                    ["","","",],
                                    [[""],""]]
    
    
    
    fileprivate var currentDate: Date? //记录选择的出生日期
    fileprivate var diagnosistimeDate: Date? //记录确诊时间日期

    fileprivate var isBrith: Bool? //是否选择的是出生日期
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.title = "健康档案"
        
        self.setNav()
        
        self.setTabView()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        BaseTabBarView.isHidden = true
        CAGradientLayerEXT().animation(false)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if self.upDic.count < 1 {
            HealthNetWork().getHealthDocument(self.view) { (showArray, upDic) in
                
                self.valueArray = showArray

                self.upDic = upDic

                self.myTabView?.reloadData()
            }
        }
        
    }
    
    
    
    func setNav(){
        
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(self.btnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
        //添加
        let (rightBtn,rightSpacer,rightItem) = BGNetwork().creatRightBtnAtt(false, title: "保存")
        rightBtn.addTarget(self, action: #selector(self.btnAct(_:)), for: UIControlEvents.touchUpInside)
        rightBtn.tag = 1
        self.navigationItem.rightBarButtonItems = [rightSpacer,rightItem]
        
    }
    
    var calculateAndUploadQueue = DispatchQueue(label: "com.nashsu.cc", attributes: [])
    
    var userIcvalueHUD:JGProgressHUD!
    
    func btnAct(_ send: UIButton){
        switch send.tag {
        case 0:
            self.navigationController!.popViewController(animated: true)
        case 1:
            //保存
            self.userIcvalueHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
            self.userIcvalueHUD.textLabel.text = "提交中.."
            self.userIcvalueHUD.show(in: self.view, animated: true)
            
            calculateAndUploadQueue.async(execute: { () -> Void in
                
                var tmpParameterA = [Data]()
                
                for tmpImg in self.parametersArray {
                    
                    if let img = tmpImg as? UIImage {
                        let data = UIImagePNGRepresentation(img)
                        tmpParameterA.append(data!)
                        
                    }else if let imgStr = tmpImg as? String{
                        let URL = Foundation.URL(string: imgStr)
                        
                        let data = try? Data(contentsOf: URL!)
                        
                        if let tmpData = data {
                            tmpParameterA.append(tmpData)
                            
                        }
       
                    }
                    
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.userIcvalueHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.userIcvalueHUD.textLabel.text = ""
                    self.userIcvalueHUD.dismiss(afterDelay: 0.01, animated: true)
                    
                    
                    HealthNetWork().subitHealtDocument(self.view, upDic: self.upDic, parameters: tmpParameterA, clourse: { (success) in
                        if success{
                            BGNetwork().delay(0.51, closure: {
                                self.navigationController!.popViewController(animated: true)
                            })
                        }
                    })
                    
                    
                })
    
            })
   
        default:
            break
        }
    
    }
    
    
    
    
    
    func setTabView(){
        myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height - 64), style: UITableViewStyle.grouped)
        
        myTabView?.backgroundColor = UIColor.white
        
        myTabView?.delegate = self
        myTabView?.dataSource = self

        myTabView?.separatorStyle = .none
        
        
        self.view.addSubview(myTabView!)
     
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0,1,2,7:
            return 3
        default:
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0,1,2,5,7:
            return 49
        case titleArray.count - 1:
            return 240
        default:
            return 142
        }
        
        
    }
    
 
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vie = UIView(frame: CGRect(x: 0,y: 0, width: UIScreen.main.bounds.size.width ,height: 7))
        vie.backgroundColor = UIColor().rgb(244, g: 244, b: 244, alpha: 1)
        
        return vie
    }
    //bmicell
    var bmiCell: HealthDTableViewCell?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch (indexPath as NSIndexPath).section {
        case 0,1,2,7:
            let ddd = "HealthDCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? HealthDTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("HealthDTableViewCell", owner: self, options: nil )?.last as? HealthDTableViewCell
                
            }
            
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell?.textClourse = self.HealthDTableViewCellTextClourse
            
            
            if (indexPath as NSIndexPath).row == 2 {
                cell?.sepView.isHidden = true
            }else{
                cell?.sepView.isHidden = false
            }
            
            cell?.titLabel.text = self.titleArray[indexPath.section][indexPath.row]
            
            let value = self.valueArray[indexPath.section][indexPath.row] as! String

            cell?.valueTextF.text = value
            
            
            if indexPath.section == 1 && indexPath.row == 2 {
                bmiCell = cell
            }
            
            
            return cell!
            
        case 5:
            let ddd = "HealthDCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? HealthDTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("HealthDTableViewCell", owner: self, options: nil )?.last as? HealthDTableViewCell
                
            }
            
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
 
            cell?.sepView.isHidden = true

            cell?.titLabel.text = self.titleArray[indexPath.section][indexPath.row]
            
            let value = self.valueArray[indexPath.section][indexPath.row] as! String
            if !value.isEmpty {
                cell?.valueTextF.text = value
            }
            
            return cell!
            
        default:
            
            
            if (indexPath as NSIndexPath).section !=  self.titleArray.count - 1{
                
                let ddd = "HealthTextCell"
                var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? HealthTextTableViewCell
                if cell == nil
                {
                    cell = Bundle.main.loadNibNamed("HealthTextTableViewCell", owner: self, options: nil )?.last as? HealthTextTableViewCell
                    
                }
                
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                
                cell?.textClourse = self.HealthTextTableViewCellTextClourse
                
                
                cell?.titLabel.text = self.titleArray[indexPath.section][indexPath.row]
                
                let value = self.valueArray[indexPath.section][indexPath.row] as! String
                
                switch indexPath.section {
                case 3:

                    if value.isEmpty {
                        cell?.myTextView.text = "例如：心脏病、高血压、高血脂..."
                    }else{
                        cell?.myTextView.text = value
                    }
                    
                case 4:
                    
                    if value.isEmpty {
                        cell?.myTextView.text = "例如：二甲双胍、诺和灵..."
                    }else{
                        cell?.myTextView.text = value
                    }
                    
                case 6:
                    if value.isEmpty {
                        cell?.myTextView.text = "例如：对什么药物过敏..."
                    }else{
                        cell?.myTextView.text = value
                    }
                    
                default:
                    break
                }
 
                return cell!
                
            }else{//最后一行
                
                let ddd = "HealthPhtoCell"
                var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? HealthPhtoTableViewCell
                if cell == nil
                {
                    cell = Bundle.main.loadNibNamed("HealthPhtoTableViewCell", owner: self, options: nil )?.last as? HealthPhtoTableViewCell
                    
                }
                
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                
                cell?.textClourse = self.HealthTextTableViewCellTextClourse
                
                cell?.pictruesView.imgSecClourse = self.PicturesViewImgSecClourse
                
                cell?.pictruesView.superCtr = self
                
                cell?.titLabel.text = self.titleArray[indexPath.section][indexPath.row]
                
                
                let value = self.valueArray[indexPath.section][1] as! String
                
                if value.isEmpty {
                    cell?.ttextView.text = "可以文字描述化验结果..."
                }else{
                    cell?.ttextView.text = value
                }
                
                
                if let img = self.valueArray[indexPath.section][0] as? [String]{

                    cell?.reloadPicturesView(img as [AnyObject])

                }


                return cell!
                
                
            }
            
            
            
        }
        
        
        
        
    }
    
    var dateChooseView: MyDateChooseView! //出生日期
    var bloodChooseView: BloodChooseView! //指血选择
    
    var currentSecCell: UITableViewCell?
    
    enum CellType {
        case healthDCell
        case healthTextCell
        case healthPhtoCell
    }
    //选择的cell
    var cellType = CellType.healthDCell
    //选择的indexPath
    var secIndexPath: IndexPath?
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.secIndexPath = indexPath

        currentSecCell = tableView.cellForRow(at: indexPath)
        
        let tmpTitle = self.titleArray[indexPath.section][indexPath.row]
        
        
        
        
        switch indexPath.section {
        case 0:
            
            self.cellType = .healthDCell
            
            switch indexPath.row {
            case 0: //姓名
                let cell = currentSecCell as? HealthDTableViewCell
                cell?.valueTextF.isEnabled = true
                cell?.valueTextF.becomeFirstResponder()
            case 1://性别
                self.isBrith = nil
                self.loadTypeView(false, title: tmpTitle, section: indexPath.section, row: indexPath.row)
            case 2://出生日期
                self.isBrith = true
                self.loadTypeView(true, title: tmpTitle, section: indexPath.section, row: indexPath.row)
                
            default:
                break
            }
        case 1:
            
            self.cellType = .healthDCell

            if indexPath.row != 2 { //身高，体重
                self.isBrith = nil
                self.loadTypeView(false, title: tmpTitle, section: indexPath.section, row: indexPath.row)
            }
        case 2:
            self.cellType = .healthDCell
            
            switch indexPath.row {
            case 1: //确诊时间
                self.isBrith = false
                self.loadTypeView(true, title: tmpTitle, section: indexPath.section, row: indexPath.row)
            default:
                self.isBrith = nil
                self.loadTypeView(false, title: tmpTitle, section: indexPath.section, row: indexPath.row)
            }
        case 5:
            self.cellType = .healthDCell
            self.isBrith = nil
            self.loadTypeView(false, title: tmpTitle, section: indexPath.section, row: indexPath.row)
        case 7:
            
            self.cellType = .healthDCell
            
            switch indexPath.row {
            case 0:
                bloodChooseView = BloodChooseView()
                bloodChooseView.touchValue = self.BloodChooseViewTouchValue
                bloodChooseView.initBloodChooseView(tmpTitle ,value: 3.9 ,section: nil)
            case 1:
                self.isBrith = nil
                self.loadTypeView(false, title: tmpTitle, section: indexPath.section, row: indexPath.row)
            case 2:
                self.loadPHTBloodSecView()
            default:
                break
            }
        case titleArray.count - 1:
            //最后一行
            self.cellType = .healthPhtoCell
            let cell = currentSecCell as? HealthPhtoTableViewCell
            cell?.ttextView.isUserInteractionEnabled = true
            cell?.ttextView.becomeFirstResponder()
            
        default:

            self.cellType = .healthTextCell
            
            let cell = currentSecCell as? HealthTextTableViewCell
            cell?.myTextView.isUserInteractionEnabled = true
            cell?.myTextView.becomeFirstResponder()
            
            break
        }
     
        
    }
    
    var phtBloodView = PHTBloodSecView()
    func loadPHTBloodSecView(){
        
        var leftData = [String]()
        var rightData = [String]()
        
        for i in 70...250 {
            leftData.append("\(i)")
        }
        for j in 40...150 {
            rightData.append("\(j)")
        }
        
        
        phtBloodView = PHTBloodSecView()
        phtBloodView.okClourse = self.PHTBloodSecViewOkClourse
        phtBloodView.initBloodSecView("高压", rightTitle: "低压", leftDataArray: leftData, rightDataArray: rightData)
        
        
    }
    
    
    
    func loadTypeView(_ isDate: Bool,title: String,section: Int ,row: Int){
        
        if isDate {
            dateChooseView = MyDateChooseView()
            dateChooseView.okBtnClourse = self.MyDateChooseViewOkBtnClourse
//            dateChooseView.initMyDateChooseView(title, dataArray: nil, isDate: true, model: UIDatePickerMode.date)
            
            var tmpDate: Date?
            if self.isBrith != nil {
                
                if self.isBrith == true {
                    tmpDate = self.currentDate
                }else{
                    tmpDate = self.diagnosistimeDate
                }
   
            }
            
            dateChooseView.initMyDateChooseView(title, dataArray: nil, isDate: true, currentDate: tmpDate, model: UIDatePickerMode.date)
            self.view.addSubview(dateChooseView)
        }else{
            dateChooseView = MyDateChooseView()
            dateChooseView.okBtnClourse = self.MyDateChooseViewOkBtnClourse
            let data = HealthService().getDataArray(section, row: row)
//            dateChooseView.initMyDateChooseView(title, dataArray: data,isDate: false,model: nil)
            
            dateChooseView.initMyDateChooseView(title, dataArray: data, isDate: false, currentDate: nil, model: nil)
        }
        
        
        
    }
    
    
    
    let allKeysArray = [["realname","sex","birth"],
                        ["heigh","weight"],
                        ["bloodtype","diagnosistime","comolica"],
                        ["history"],
                        ["pharmacy"],
                        ["familydiabetes"],
                        ["drugallergy"],
                        ["fbg","ghbaic","pht"],
                        ["reportresaltsvalue"]]
    
    var upDic = [String:String]()
    //姓名回调
    func HealthDTableViewCellTextClourse(_ text: String)->Void{
        //姓名
        
        let key = self.allKeysArray[(self.secIndexPath! as NSIndexPath).section][(self.secIndexPath! as NSIndexPath).row]
        self.upDic[key] = text
        self.valueArray[(self.secIndexPath! as NSIndexPath).section][(self.secIndexPath! as NSIndexPath).row] = text as AnyObject
    }
    
    func bloodTypeCase(_ key: String) -> String{

        var value = "0"
        switch key {
        case "未诊断":
            value = "0"
        case "妊娠糖尿病":
            value = "1"
        case "2型糖尿病":
            value = "2"
        case "糖前高危":
            value = "3"
        case "1型糖尿病":
            value = "4"
        case "确诊人群":
            value = "5"
        case "继发性":
            value = "6"
        case "特殊类型":
            value = "7"
        default:
            value = "0"
        }
        
        return value
        
    }
    
    func comolicaCase(_ comolica: String) -> String{
//        ["无并发症","糖尿病心血管并发症","糖尿病肾病","糖尿病眼部并发症","糖尿病足","糖尿病性脑血管病","糖尿病神经病变"]
        
        var value = "0"
        switch comolica {
        case "无并发症":
            value = "0"
        case "糖尿病心血管并发症":
            value = "1"
        case "糖尿病肾病":
            value = "2"
        case "糖尿病眼部并发症":
            value = "3"
        case "糖尿病足":
            value = "4"
        case "糖尿病性脑血管病":
            value = "5"
        case "糖尿病神经病变":
            value = "6"
        default:
            value = "0"
        }
        
        return value
        
        
    }
    
    
    //出生日期-其他 选择回调
    func MyDateChooseViewOkBtnClourse(_ value: String)->Void{

        let key = self.allKeysArray[(self.secIndexPath! as NSIndexPath).section][(self.secIndexPath! as NSIndexPath).row]
        
        if key == "birth" || key == "diagnosistime"{
            
            if self.isBrith != nil{
                
                if self.isBrith == true{
                    
                    let formatter = DateFormatter()
                    
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    
                    let tmpDate = formatter.date(from: value)

                    self.currentDate = tmpDate
                }else{
                    let formatter = DateFormatter()
                    
                    formatter.dateFormat = "yyyy-MM-dd"
                    
                    let tmpDate = formatter.date(from: value)

                    self.diagnosistimeDate = tmpDate
                }
                
                
                
            }
            
            let tmpV = (value as NSString).substring(with: NSRange(location: 0, length: 10))
            
            self.upDic[key] = tmpV
            self.valueArray[(self.secIndexPath! as NSIndexPath).section][(self.secIndexPath! as NSIndexPath).row] = tmpV
        }else{

            if key == "bloodtype" {
                
                let val = HealthService().bloodTypeCase(value)
                self.upDic[key] = val
            }else if key == "comolica"{
                
                let val = HealthService().comolicaCase(value)
                self.upDic[key] = val
     
            }else if key == "sex"{
                
                var sexValue = "0"
                if value == "女" {
                    sexValue = "0"
                }else{
                    sexValue = "1"
                }
                self.upDic[key] = sexValue
                
            }else{
                self.upDic[key] = value
            }
 
            self.valueArray[(self.secIndexPath! as NSIndexPath).section][(self.secIndexPath! as NSIndexPath).row] = value as AnyObject
        }
 
        switch self.cellType {
        case .healthDCell:
            let cell = self.currentSecCell as? HealthDTableViewCell
            if (self.secIndexPath != nil && (self.secIndexPath as NSIndexPath?)?.section == 0 && (self.secIndexPath as NSIndexPath?)?.row == 2) || ((self.secIndexPath as NSIndexPath?)?.section == 2 && (self.secIndexPath as NSIndexPath?)?.row == 1){ //出生日期和 确诊时间
                
                let tmpValue = (value as NSString).substring(with: NSRange(location: 0, length: 10))
                cell?.valueTextF.text = tmpValue
                self.secIndexPath = nil
            }else{//其他
                
                cell?.valueTextF.text = value
                //身高
                if (self.secIndexPath != nil && (self.secIndexPath as NSIndexPath?)?.section == 1 && (self.secIndexPath as NSIndexPath?)?.row == 0) {
                    //"heigh","weight"
                    if let wei = self.upDic["weight"] {
                        let bmi = CalculationMethod().getBmiMethod(Float(value)!, weight: Float(wei)!)
                        self.bmiCell?.valueTextF.text = bmi
                        self.valueArray[1][2] = bmi
                    }
                }
                //体重
                if (self.secIndexPath != nil && (self.secIndexPath as NSIndexPath?)?.section == 1 && (self.secIndexPath as NSIndexPath?)?.row == 1) {
                    if let hei = self.upDic["heigh"] {
                        let bmi = CalculationMethod().getBmiMethod(Float(hei)!, weight: Float(value)!)
                        self.bmiCell?.valueTextF.text = bmi
                        self.valueArray[1][2] = bmi
                    }
                }
    
            }
     
        default:
            break
        }
   
    
    }
    //指血回调
    func BloodChooseViewTouchValue(_ tag: Int ,value: String?)->Void{

        if let tmpValue = value {
            let key = self.allKeysArray[(self.secIndexPath! as NSIndexPath).section][(self.secIndexPath! as NSIndexPath).row]
            self.upDic[key] = tmpValue
            self.valueArray[(self.secIndexPath! as NSIndexPath).section][(self.secIndexPath! as NSIndexPath).row] = tmpValue as AnyObject
        }
        
        
        
        let cell = self.currentSecCell as? HealthDTableViewCell
        cell?.valueTextF.text = value
        
        
        
        
    }
    
    
    //textView回调
    func HealthTextTableViewCellTextClourse(_ value: String)->Void{
        let key = self.allKeysArray[(self.secIndexPath! as NSIndexPath).section][(self.secIndexPath! as NSIndexPath).row]
        self.upDic[key] = value
        self.valueArray[(self.secIndexPath! as NSIndexPath).section][(self.secIndexPath! as NSIndexPath).row] = value as AnyObject
    }
    
    //血压回调
    func PHTBloodSecViewOkClourse(_ leftValue: String ,rightValue: String)->Void{
        
        self.upDic["pht"] = leftValue
        self.upDic["lp"] = rightValue
        
        self.valueArray[(self.secIndexPath! as NSIndexPath).section][(self.secIndexPath! as NSIndexPath).row] = "\(leftValue)/\(rightValue)" as AnyObject
        
        let cell = self.currentSecCell as? HealthDTableViewCell
        cell?.valueTextF.text = "\(leftValue)/\(rightValue)"
    }
    
    var parametersArray = NSMutableArray()
    
    func PicturesViewImgSecClourse(_ imgArray: [AnyObject])->Void{

        self.parametersArray.removeAllObjects()
        
        for tmpImg in imgArray {
            
            if let img = tmpImg as? UIImage {

                parametersArray.add(img)
                
            }else if let imgStr = tmpImg as? String{

                parametersArray.add(imgStr)
                
            }
            
            
     
        }
        
        
        
        
        
        
    }
    
    

}
