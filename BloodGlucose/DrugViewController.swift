//
//  DrugViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/17.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class DrugViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource ,DateViewDelegate{

    //上级控制器
    var tmpCtr: UIViewController?
    
    
    enum SecType {
        case medicName
        case medicDose
        case medicTime
    }
    fileprivate var secType = SecType.medicName
    
    fileprivate let medicNameArray = ["二甲双胍","二甲双胍缓释片","格列齐特","格列齐特缓释片","格列喹酮","罗格列酮","吡格列酮","阿卡波糖","优格列波糖","瑞格列奈","那格列奈","西格列汀","沙格列汀","利格列汀","阿格列汀","维格列汀"]
    fileprivate let medicDoseArray = ["半片","一片","两片","三片"]
    
    var isEdit = false //是否为编辑状态
    
    fileprivate var isHaveEdit = false //是否编辑过
    
    fileprivate var myTabView: UITableView?
    
    fileprivate let nameArray = ["药品名称","药品剂量","用药时间","用药时间"] //标题
    fileprivate let placeholderArray = ["选择药名","选择剂量","选择时间"] //占位符
    
    fileprivate let numberOfSections = 4 //table组数
    fileprivate let heightForRowHeight: CGFloat = 54.0 //table每个cell 高度
    fileprivate let heightForFooterInSectionHeight: CGFloat = 5.0 //table 每个分组的头 脚视图高度
    
    fileprivate var dateView:DateView!
    fileprivate var Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
    fileprivate var Wsize = UIScreen.main.bounds.width / 320
    
    fileprivate var currentDate: Date?
    
    
    fileprivate var secAndPrintView:SecAndPrintView!
    fileprivate var secAndPrintBgView:UIView!
    fileprivate var size = UIScreen.main.bounds
    
    fileprivate var eventTypeCell: EventTypeTableViewCell?
    
    fileprivate var upDic = [String:String]() //上传字典
    
    var isEditDic = [String:Any]() //编辑字典
    
    fileprivate var upImgDic = [String:String]()
    
    
    //图片数组url
    fileprivate var imgArray = [String]()
    
    //sexView背景视图
    fileprivate var dateBgView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "饮食事件"
        self.setNav()
        
        self.editMyTabView()
        
        self.setMyTabView()
        
        
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BaseTabBarView.isHidden = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        
//        self.editMyTabView()
        
    }
    
    
    fileprivate var showValueArray:[String] = ["","","","0"]
    
    func editMyTabView(){
        if self.isEdit { //为编辑
            print(self.isEditDic)
            if let medicine = self.isEditDic["medicine"] as? String{
                self.upDic["medicine"] = medicine
                self.showValueArray[0] = medicine
            }
            if let dose = self.isEditDic["dose"] as? String{
                self.upDic["dose"] = dose
                self.showValueArray[1] = dose
            }
            
            var medDte = ""
            if let date = self.isEditDic["date"] as? String{
                self.upDic["date"] = date
                medDte = date
            }
            var medTime = ""
            if let time = self.isEditDic["time"] as? String{
                self.upDic["time"] = time
                medTime = time
            }
            let haveTime = medDte + " " + medTime
            self.showValueArray[2] = haveTime
            
            
            if let emotion = self.isEditDic["emotion"] as? Int{
                self.upDic["emotion"] = "\(emotion)"
                self.showValueArray[3] = "\(emotion)"
            }
            
            if let imgurl = self.isEditDic["imgurl"] as? NSArray{
                print(imgurl)
                
                //设置图片
                var imgUrlArray = [String]()
                
                for item in 0..<imgurl.count {
                    
                    let tmpDic = imgurl[item] as! [String:String]
                    
                    if let url = tmpDic["imgurl"] {
                        imgUrlArray.append(url)
                        
                        if item == 0 {
                            self.upImgDic["imgurl"] = url
                        }else{
                            self.upImgDic["imgurl\(item)"] = url
                        }
                    }
   
                }
                print(imgUrlArray)
                self.imgArray = imgUrlArray
 
            }

            if let food = self.isEditDic["food"] as? String{
                self.upDic["food"] = food
                self.footView?.setTextView(value: food)
            }
 
        }else{
            self.upDic["emotion"] = "\(0)"
        }
    }
    

    
    
    func setMyTabView(){
        let w = UIScreen.main.bounds.size.width
        let h = UIScreen.main.bounds.size.height - 64
        
        self.myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: w, height: h), style: UITableViewStyle.grouped)
        
        self.myTabView?.backgroundColor = UIColor.white
        
        self.myTabView?.delegate = self
        
        self.myTabView?.dataSource = self
        
        self.myTabView?.separatorStyle = .none
        
        
        self.myTabView?.tableFooterView = self.setTabFootView()
        
        self.view.addSubview(self.myTabView!)
   
    }
    
    fileprivate var footView: DrugFootView?
    
    func setTabFootView() -> UIView?{
        let w = UIScreen.main.bounds.size.width
        let h = UIScreen.main.bounds.size.height - 64
        
        let inH = CGFloat(self.numberOfSections) * self.heightForRowHeight + CGFloat(self.numberOfSections + 1) * self.heightForFooterInSectionHeight
        //脚视图高度
        let height = h - inH
        
        footView = DrugFootView(frame: CGRect(x: 0, y: 0, width: w, height: height))
        footView?.backgroundColor = UIColor.white
        
        footView?.drugTextViewClourse = self.DrugFootViewTextViewClourse
        footView?.drugImgDicClourse = self.DrugFootViewImgDicClourse
        
        if let food = self.upDic["food"]{
            footView?.textValue = food
        }
        
        footView?.imgArray = self.imgArray
        
        footView?.drugCrt = self
        
        return footView
    }
    
    func DrugFootViewTextViewClourse(_ textValue : String)->Void {
        
        self.upDic["food"] = textValue
    }

    
    func DrugFootViewImgDicClourse(_ imgDic: [String:String])->Void{
        
        self.upImgDic = imgDic
        
//        for (key,value) in imgDic {
//            self.upDic[key] = value
//        }
    }
    
    
    
    
    func setNav(){
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        //右
        if self.isEdit { //为编辑
            //编辑
            let (rightBtn,rightSpacer,rightItem) = BGNetwork().creatRightBtnAtt(false, title: "修改")
            rightBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            rightBtn.tag = 2
            self.navigationItem.rightBarButtonItems = [rightSpacer,rightItem]
        }else{
            //添加
            let (rightBtn,rightSpacer,rightItem) = BGNetwork().creatRightBtnAtt(false, title: "完成")
            rightBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            rightBtn.tag = 1
            self.navigationItem.rightBarButtonItems = [rightSpacer,rightItem]
        }
  
    }
    
    
    func someBtnAct(_ send: UIButton){
        
        switch send.tag {
        case 0:
            
            if self.isHaveEdit {
                let actionSheet = UIAlertController(title: "是否退出本次编辑", message: "", preferredStyle: UIAlertControllerStyle.alert)
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
                    
                    self.navigationController!.popViewController(animated: true)
                    
                }))
                actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
            }else{
                self.navigationController!.popViewController(animated: true)
            }
            
        case 1:
            print("完成->提交")
            
            self.setImgKeyAndValue()
            
            print(self.upDic)
            
            if self.upDic["medicine"] == nil {
                let alrte = UIAlertView(title: "请选择药品名称", message: "", delegate: nil, cancelButtonTitle: "确定")
                alrte.show()
                return
            }
            if self.upDic["date"] == nil {
                let alrte = UIAlertView(title: "请选择用药时间", message: "", delegate: nil, cancelButtonTitle: "确定")
                alrte.show()
                return
            }
            
            EventNetwork().saveMedicData(self.view, dataDic: self.upDic, clourse: { (success) in

                if success {
                    BGNetwork().delay(0.51, closure: {
                        if let ctr = self.tmpCtr{
                            isSecBlood = false
                            self.navigationController!.popToViewController(ctr, animated: true)
                        }else{
                            self.navigationController!.popViewController(animated: true)
                        }
                        
                    })
                }
                
            })
            
            
        case 2:
            print("完成->修改")
            self.setImgKeyAndValue()
            print(self.upDic)
            EventNetwork().saveMedicData(self.view, dataDic: self.upDic, clourse: { (success) in
                
                if success {
                    BGNetwork().delay(0.51, closure: {
                        if let ctr = self.tmpCtr{
                            isSecBlood = false
                            self.navigationController!.popToViewController(ctr, animated: true)
                        }else{
                            self.navigationController!.popViewController(animated: true)
                        }
                        
                    })
                }
                
            })
            
            
            
        default:
            break
        }
        
        
    }
    
    func setImgKeyAndValue(){
        for (key,value) in self.upImgDic {
            self.upDic[key] = value
        }
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.numberOfSections - 1 {
            return self.heightForFooterInSectionHeight
        }else{
            return 0.01
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let w = UIScreen.main.bounds.size.width
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: w , height: 5))
        headView.backgroundColor = UIColor().rgb(245, g: 245, b: 245, alpha: 1)
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForFooterInSectionHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let w = UIScreen.main.bounds.size.width
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: w , height: 5))
        headView.backgroundColor = UIColor().rgb(245, g: 245, b: 245, alpha: 1)
        return headView
    }
    
    
    fileprivate var fellSecIndex = 1 //心情记录选择
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0,1,2:
            let ddd = "EventTypeCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? EventTypeTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("EventTypeTableViewCell", owner: self, options: nil )?.last as? EventTypeTableViewCell
            }
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            cell?.titLabel.text = self.nameArray[indexPath.section]
            
            if self.isEdit {
                let value = self.showValueArray[indexPath.section]
                if !value.isEmpty {
                    cell?.valueTF.text = value
                }else{
                    cell?.valueTF.placeholder = self.placeholderArray[indexPath.section]
                }
            }else{
                cell?.valueTF.placeholder = self.placeholderArray[indexPath.section]
            }
            
     
            return cell!

        default:
            let ddd = "EventFellCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? EventFellTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("EventFellTableViewCell", owner: self, options: nil )?.last as? EventFellTableViewCell
                
            }
            
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            cell?.fellColurse = self.fellViewColurse
            
            
            print(self.showValueArray[indexPath.section])
            
            if let value = Int(self.showValueArray[indexPath.section]){
                self.setSecColorIn(cell, index: value)
            }

            return cell!
        }
  
        
    }
    func setSecColorIn(_ cell: EventFellTableViewCell? ,index: Int){
        
        
        //未选择的颜色
        let notSecColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1)
        let notSecImgName = "eventNSD.png"
        //选择的颜色
        let secColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        let secImgName = "eventSD.png"
        
        switch index {
        case 0:  //高兴
            cell?.happImg.image = UIImage(named: secImgName)
            cell?.happLabel.textColor = secColor
            
            cell?.normalImg.image = UIImage(named: notSecImgName)
            cell?.normalLabel.textColor = notSecColor
            
            cell?.uncomfortableImg.image = UIImage(named: notSecImgName)
            cell?.uncomfortableLabel.textColor = notSecColor
            
        case 1: //正常
            cell?.happImg.image = UIImage(named: notSecImgName)
            cell?.happLabel.textColor = notSecColor
            
            cell?.normalImg.image = UIImage(named: secImgName)
            cell?.normalLabel.textColor = secColor
            
            cell?.uncomfortableImg.image = UIImage(named: notSecImgName)
            cell?.uncomfortableLabel.textColor = notSecColor
        case 2: //不舒服
            cell?.happImg.image = UIImage(named: notSecImgName)
            cell?.happLabel.textColor = notSecColor
            
            cell?.normalImg.image = UIImage(named: notSecImgName)
            cell?.normalLabel.textColor = notSecColor
            
            cell?.uncomfortableImg.image = UIImage(named: secImgName)
            cell?.uncomfortableLabel.textColor = secColor
        default:
            break
        }
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        switch indexPath.section {
        case 0:
            //print("选择药物名")
            self.secType = SecType.medicName
            self.eventTypeCell = tableView.cellForRow(at: indexPath) as? EventTypeTableViewCell
            self.loadSecAndPrintView(true, dataArray: self.medicNameArray)
        case 1:
            //print("选择药物剂量")
            self.secType = SecType.medicDose
            self.eventTypeCell = tableView.cellForRow(at: indexPath) as? EventTypeTableViewCell
            self.loadSecAndPrintView(true, dataArray: self.medicDoseArray)
        case 2:
            //print("选择时间")
            self.secType = SecType.medicTime
            self.eventTypeCell = tableView.cellForRow(at: indexPath) as? EventTypeTableViewCell
            self.loadDateView("时间")
        default:
            break
        }
        
        
        
    }
    //心情回调
    func fellViewColurse(_ tag: Int,_ name: String)->Void{
        print(tag,name)
        
        self.isHaveEdit = true
        
//        self.upDic["emotion"] = self.getFellIndex(name: name)

        self.upDic["emotion"] = "\(tag)"
        showValueArray[3] = "\(tag)"
        self.fellSecIndex = tag
        
    }
    
//    func getFellIndex(name: String) -> String{
//        
//        var index = "0"
//        
//        switch name {
//        case "正常":
//            index = "0"
//        case "不舒服":
//            index = "1"
//        case "高兴":
//            index = "2"
//        default:
//            break
//        }
//        
//        return index
//        
//    }
    
    
    
    func loadDateView(_ name:String){
        
        self.loadSexBgView()
        
        self.dateView = Bundle.main.loadNibNamed("DateView", owner: nil, options: nil)?.first as! DateView
        self.dateView.frame = CGRect(x: 0, y: size.height - 220 * self.Hsize - 64, width: self.size.width, height: 220 * self.Hsize)
        self.dateView.nameLabel.text = name
        
        self.dateView.currentDate = self.currentDate
        
        self.dateView.delegate = self
        
        self.dateView.isDateAndTime = true
        self.dateView.datePick.datePickerMode = UIDatePickerMode.dateAndTime
        
        
        self.view.addSubview(self.dateView)
        
        
    }
    
    
    func loadSexBgView(){
        if self.dateBgView == nil {
            self.dateBgView = UIView(frame: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
            self.dateBgView.backgroundColor = UIColor.clear
            self.view.addSubview(self.dateBgView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(SupAddFoddViewController.closeSexView))
            self.dateBgView.addGestureRecognizer(tap)
            
        }
    }
    
    
    
    
    func loadSecAndPrintView(_ isShowHeadView: Bool ,dataArray: [String]){
        self.loadSecAndPrintBgView()
        
        if secAndPrintView == nil {
            secAndPrintView = SecAndPrintView(frame: CGRect(x: 0,y: size.height - 64 - 280,width: size.width,height: 280))
            secAndPrintView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
            
            secAndPrintView.isShowHeadView = isShowHeadView
            
            
            secAndPrintView.dataArray = dataArray
            
            secAndPrintView.pickerDefaultIndex = dataArray.count / 2
            
            
            secAndPrintView.secAndPrintViewValueClosur = self.secAndPrintViewValueClosur
            
            self.view.addSubview(secAndPrintView)
        }
        
    }
    
    
    func loadSecAndPrintBgView(){
        if self.secAndPrintBgView == nil {
            secAndPrintBgView = UIView(frame: CGRect(x: 0,y: 0,width: size.width,height: size.height))
            secAndPrintBgView.backgroundColor = UIColor.clear
            //MARK:------!
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.someBtnAct(_:)))
            secAndPrintBgView.addGestureRecognizer(tap)
            secAndPrintBgView.tag = 100
            
            self.view.addSubview(secAndPrintBgView)
        }
        
        
    }
    
    func closeSecAndPrintView(){
        if self.secAndPrintView != nil {
            self.secAndPrintView.removeFromSuperview()
            self.secAndPrintView = nil
        }
        if self.secAndPrintBgView != nil {
            self.secAndPrintBgView.removeFromSuperview()
            self.secAndPrintBgView = nil
        }
    }
    
    func secAndPrintViewValueClosur(_ isMoreBtnAct:Bool,tag: Int,secInt:Int,value:String)->Void{
        print("回调-> isMoreBtnAct:\(isMoreBtnAct) -> tag:\(tag) -> secInt:\(secInt) -> value:\(value)")
        
        self.isHaveEdit = true
        
        if isMoreBtnAct {
            print("点击了更多，开始输入")
            
            self.eventTypeCell?.valueTF.isEnabled = true
            self.eventTypeCell?.valueTF.becomeFirstResponder()
    
        }else{
            
            if tag == 1 {
                
                self.eventTypeCell?.valueTF.text = value
                
                switch self.secType {
                case .medicName:
                    self.upDic["medicine"] = value
                case .medicDose:
                    self.upDic["content"] = value
                default:
                    break
                }
     
            }else{
                print("点击了取消，不做处理")
            }
   
        }

        self.closeSecAndPrintView()
    }
    
    
    
    //DateViewDelegate
    func saveBtnAct(_ date: String) {
        print(date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let tmpDate = dateFormatter.date(from: date)
        
        
        self.currentDate = tmpDate

        let time = (date as NSString).substring(with: NSRange(location: 0, length: 10))
        let isDateAndTime = (date as NSString).substring(with: NSRange(location: 11, length: 5))
        
        
        print(time,isDateAndTime)
        self.upDic["date"] = time
        self.upDic["time"] = isDateAndTime
        
        let showTime = (date as NSString).substring(with: NSRange(location: 0, length: 16))
        
        if self.secType == .medicTime {
            self.eventTypeCell?.valueTF.text = showTime
        }
        
        
        self.closeSexView()
    }

    func closeDateView() {
        self.closeSexView()
    }
    func closeSexView(){
        
        isHaveEdit = true
        
        if self.dateView != nil {
            self.dateView.removeFromSuperview()
            self.dateView = nil
        }
        if self.dateBgView != nil {
            self.dateBgView.removeFromSuperview()
            self.dateBgView = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
