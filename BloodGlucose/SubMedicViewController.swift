//
//  SubMedicViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/20.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SubMedicViewController: UIViewController ,UITextFieldDelegate ,DateViewDelegate ,UITextViewDelegate{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //药品名称
    @IBOutlet weak var medicNameView: UIView!
    @IBOutlet weak var medicNameTF: UITextField!
    
    //剂量
    @IBOutlet weak var medicDoseView: UIView!
    @IBOutlet weak var medicDoseTF: UITextField!
    
    //时间
    @IBOutlet weak var medicTimeTF: UITextField!
    @IBOutlet weak var medicTimeView: UIView!
    //心情
    @IBOutlet weak var fellVIew: UIView!
    
    
    @IBOutlet weak var takingPictureView: UIView!
    
    @IBOutlet weak var inforTextView: UITextView! //添加描述的
    
    //上级控制器
    var tmpCtr: UIViewController?
    
    let medicNameArray = ["二甲双胍","二甲双胍缓释片","格列齐特","格列齐特缓释片","格列喹酮","罗格列酮","吡格列酮","阿卡波糖","优格列波糖","瑞格列奈","那格列奈","西格列汀","沙格列汀","利格列汀","阿格列汀","维格列汀"]
    let medicDoseArray = ["半片","一片","两片","三片"]
    
    
    var isEdit = false
    
    //是否编辑过
    var isHaveEdit = false
    
    var upDic = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        self.title = "药物事件"
        self.setNav()
        //加载心情视图
        self.loadFellView()
        //加载照片区域
        self.loadTakingPictureView()
        
        
        
        //设置可视化基本属性
        self.setSomeView()
        
        
  
        if self.isEdit {
            self.setIsEditView(self.upDic)
        }else{
            //设置时间
            self.setTime()
        }
        
    }
    
    func setTime(){
        let date = Date()
        let current:Double = Double(date.timeIntervalSince1970) + Double(8 * 60 * 60)
        
        let currentTime = Date(timeIntervalSince1970: current)
        
        print(currentTime)
        
//        let time = (String(currentTime) as NSString).substring(with: NSRange(0...9))
//        let isDateAndTime = (String(currentTime) as NSString).substring(with: NSRange(11...15))

        let time = (String(describing: currentTime) as NSString).substring(with: NSRange(location: 0, length: 10))
        let isDateAndTime = (String(describing: currentTime) as NSString).substring(with: NSRange(location: 11, length: 5))
        
        
        print(time,isDateAndTime)
        
        self.medicTimeTF.text = "\(time) \(isDateAndTime)"
        
        self.upDic.setValue(time, forKey: "date")
        self.upDic.setValue(isDateAndTime, forKey: "time")
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        BaseTabBarView.isHidden = true
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
   
        
    }
//    override func viewDidDisappear(animated: Bool) {
//        IQKeyboardManager.sharedManager().enableAutoToolbar = false
//    }
    
    func setIsEditView(_ dic: NSMutableDictionary){
        
        
        print(dic)
        let medicine = dic.value(forKey: "medicine") as! String
        
        let dose = dic.value(forKey: "dose") as! String
        
        let date = dic.value(forKey: "date") as! String
        let time = dic.value(forKey: "time") as! String
        
        let emotion = dic.value(forKey: "emotion") as! Int
        
//        let imgurlArray = dic.valueForKey("imgurl") as! NSArray
        
//        let logId = dic.valueForKey("logId") as! String

        
        let food = dic.value(forKey: "food") as! String
        
        
        self.medicNameTF.text = medicine
        
        if dose.isEmpty {
            self.medicDoseTF.placeholder = "选择剂量"
        }else{
            self.medicDoseTF.text = dose
        }

        self.medicTimeTF.text = "\(date) \(time)"
        
        var fellIndex = 0
        switch emotion {
        case 0:
            print("正常")
            fellIndex = 1
        case 1:
            print("不舒服")
            fellIndex = 2
        case 2:
            print("高兴")
            fellIndex = 0
        default:
            break
        }
        self.tmpFellView.defualtSecIndex = fellIndex
        
        
//
//        
//        
//        if let url:NSArray = self.dataArray[indexPath.row].valueForKey("imgurl") as? NSArray{
//            if url.count > 0 {
//                let adic = url[0] as! NSDictionary
//                let url = adic.valueForKey("imgurl") as! String
//                let imgurl:NSURL = NSURL(string: url)!
//                cell?.bigImgView.sd_setImageWithURL(imgurl, placeholderImage: UIImage(named: imgName))
//            }
//        }
        
        if food.isEmpty {
            self.inforTextView.text = "添加描述：比如，是否使用了胰岛素..."
        }else{
            self.inforTextView.text = food
        }
        
        
        
        
        
    }
    
    
    
    
    func setNav(){
        
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(SubMedicViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
        if self.isEdit { //为编辑
            //编辑
            let (rightBtn,rightSpacer,rightItem) = BGNetwork().creatRightBtnAtt(false, title: "修改")
            rightBtn.addTarget(self, action: #selector(SubMedicViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            rightBtn.tag = 2
            self.navigationItem.rightBarButtonItems = [rightSpacer,rightItem]
        }else{
            //添加
            let (rightBtn,rightSpacer,rightItem) = BGNetwork().creatRightBtnAtt(false, title: "完成")
            rightBtn.addTarget(self, action: #selector(SubMedicViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
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
            
            self.upDic.setValue("\(self.emotion)", forKey: "emotion")
            
            
            
            self.someEditResignFirstResponder()
  
            
            
        
            
            
            
            print(self.upDic)
            
            if self.upDic.value(forKey: "medicine") as? String == nil {
                let alrte = UIAlertView(title: "请选择药品名称", message: "", delegate: nil, cancelButtonTitle: "确定")
                alrte.show()
                return
            }
            if self.upDic.value(forKey: "date") as? String == nil {
                let alrte = UIAlertView(title: "请选择用药时间", message: "", delegate: nil, cancelButtonTitle: "确定")
                alrte.show()
                return
            }
            
            
            
            
            
            
            
            
            
            self.saveMedicData(self.upDic)
            
        case 2:
            print("完成->修改")
            self.someEditResignFirstResponder()
            self.upDic.setValue("\(self.emotion)", forKey: "emotion")
            
            self.saveMedicData(self.upDic)
            
            
            
            
            
            
        default:
            break
        }
        
        
    }

    func someEditResignFirstResponder(){
        self.medicNameTF.resignFirstResponder()
        self.medicDoseTF.resignFirstResponder()
        self.inforTextView.resignFirstResponder()
    }
    
    var savefinishHUD:JGProgressHUD!
    //MARK:提交保存
    func saveMedicData(_ dic: NSMutableDictionary){
        
        
        
        
        
        self.savefinishHUD = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.savefinishHUD.textLabel.text = "添加中..."
        self.savefinishHUD.show(in: self.view, animated: true)
        
        
        
        let uid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/event/newLog.jsp"
        let code:String = "\(uid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        dicDPost = [
            "userid":uid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "type":"medicine"
        ]
        
        var dicc = [AnyHashable: Any]()
        
//        dicc.addEntries(from: dic as [AnyHashable: Any])
//        dicc.addEntries(from: dicDPost as! [AnyHashable: Any])
        
        for (key,value) in dic {
            dicc.updateValue(value, forKey: key as! AnyHashable)
        }
        for (key,value) in dicDPost {
            dicc.updateValue(value, forKey: key as! AnyHashable)
        }
  
        print(dicc)
        

        
        RequestBase().doPost(reqUrl, dicc, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print(json)
            
            
            let code1 = json["code"].intValue
            if code1 == 1 {
                self.savefinishHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.savefinishHUD.textLabel.text = "提交成功"
                self.savefinishHUD.dismiss(afterDelay: 0.5, animated: true)
                
                
                BGNetwork().delay(0.51, closure: {
                    if let ctr = self.tmpCtr{
                        isSecBlood = false
                        self.navigationController!.popToViewController(ctr, animated: true)
                    }else{
                        self.navigationController!.popViewController(animated: true)
                    }
                    
                })
                
                
            }else{
                self.savefinishHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.savefinishHUD.textLabel.text = "提交失败"
                self.savefinishHUD.dismiss(afterDelay: 0.5, animated: true)
            }

            
            }, failure: { () -> Void in
                
                print("false")
                self.savefinishHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.savefinishHUD.textLabel.text = "网络错误"
                self.savefinishHUD.dismiss(afterDelay: 0.5, animated: true)
        })
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func setSomeView(){
        
        
        self.inforTextView.delegate = self
        
        self.medicNameTF.delegate = self
        self.medicDoseTF.delegate = self

        self.medicNameTF.isEnabled = false
        self.medicDoseTF.isEnabled = false
        self.medicTimeTF.isEnabled = false
        
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(SubMedicViewController.someViewAct(_:)))
        self.medicNameView.addGestureRecognizer(tap1)
        self.medicNameView.tag = 8
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(SubMedicViewController.someViewAct(_:)))
        self.medicDoseView.addGestureRecognizer(tap2)
        self.medicDoseView.tag = 9

        let tap3 = UITapGestureRecognizer(target: self, action: #selector(SubMedicViewController.someViewAct(_:)))
        self.medicTimeView.addGestureRecognizer(tap3)
        self.medicTimeView.tag = 10
    }
    
    enum SecType {
        case medicName
        case medicDose
    }
    
    
    var secType = SecType.medicName
    
    func someViewAct(_ send: UITapGestureRecognizer){
        let tag = send.view!.tag
        
        switch tag {
        case 8:
            print("选择药物名")
            self.secType = SecType.medicName
            self.loadSecAndPrintView(true, dataArray: self.medicNameArray)
            
        case 9:
            print("选择药物剂量")
            self.secType = SecType.medicDose
            self.loadSecAndPrintView(true, dataArray: self.medicDoseArray)
            
        case 10:
            print("选择时间")
            self.loadDateView("时间")
        case 100:
            print("关闭")
            self.closeSecAndPrintView()
        default:
            break
        }
        
        
    }
    var secAndPrintView:SecAndPrintView!
    var secAndPrintBgView:UIView!
    
    
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
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(SubMedicViewController.someViewAct(_:)))
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
        
        
        isHaveEdit = true
        
        if isMoreBtnAct {
            print("点击了更多，开始输入")
            
            switch self.secType {
            case .medicName:
                self.medicNameTF.isEnabled = true
                self.medicNameTF.becomeFirstResponder()
            case .medicDose:
                self.medicDoseTF.isEnabled = true
                self.medicDoseTF.becomeFirstResponder()
            }

        }else{
            
            if tag == 1 {
                print("点击了确定")
                switch self.secType {
                case .medicName:
                    self.medicNameTF.text = value
                    
                    self.upDic.setValue(value, forKey: "medicine")
                    
                    
                case .medicDose:
                    self.medicDoseTF.text = value
                    self.upDic.setValue(value, forKey: "content")
                }
                
 
            }else{
                print("点击了取消，不做处理")
            }
            
            
            
            
        }
        
        
        self.closeSecAndPrintView()
        
        
    }
    
    
    
    fileprivate var currentDate: Date?
    
    
    var Hsize = (UIScreen.main.bounds.height - 64) / (568 - 64)
    var Wsize = UIScreen.main.bounds.width / 320
    var size = UIScreen.main.bounds
    var dateView:DateView!
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
    //sexView背景视图
    var dateBgView:UIView!
    
    func loadSexBgView(){
        if self.dateBgView == nil {
            self.dateBgView = UIView(frame: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
            self.dateBgView.backgroundColor = UIColor.clear
            self.view.addSubview(self.dateBgView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(SupAddFoddViewController.closeSexView))
            self.dateBgView.addGestureRecognizer(tap)
            
        }
    }

    //DateViewDelegate
    func saveBtnAct(_ date: String) {
        print(date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let tmpDate = dateFormatter.date(from: date)

        
        self.currentDate = tmpDate
        
        
//        let time = (date as NSString).substring(with: NSRange(0...9))
//        let isDateAndTime = (date as NSString).substring(with: NSRange(11...15))
        
        let time = (date as NSString).substring(with: NSRange(location: 0, length: 10))
        let isDateAndTime = (date as NSString).substring(with: NSRange(location: 11, length: 5))
        
        
        print(time,isDateAndTime)
        self.upDic.setValue(time, forKey: "date")
        self.upDic.setValue(isDateAndTime, forKey: "time")
        
//        let showTime = (date as NSString).substring(with: NSRange(0...15))
        
        let showTime = (date as NSString).substring(with: NSRange(location: 0, length: 16))
        
        self.medicTimeTF.text = showTime
//        
//        self.upDic.setValue(time, forKey: "date")
//        self.upDic.setValue(isDateAndTime, forKey: "time")
        
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
    
    var tmpFellView:FellView!
    func loadFellView(){
        
        tmpFellView = Bundle.main.loadNibNamed("FellView", owner: nil, options: nil)?.last as! FellView
        tmpFellView.frame = CGRect(x: 0, y: 0, width: self.fellVIew.frame.size.width, height: self.fellVIew.frame.size.height)

        let imgArray = ["eventSD.png","eventNSD.png","eventNSD.png"]
        let stateNameArray = ["高兴","正常","不舒服"]

        tmpFellView.setFellViewData("用药心情", imgArray: imgArray, stateNameArray: stateNameArray)

        tmpFellView.fellColurse = self.fellViewColurse
        
        self.fellVIew.addSubview(tmpFellView)
        
    }
    
    //默认心情为2，高兴
    var emotion = 2
    
    //MARK:心情回调
    func fellViewColurse(_ tag: Int,name: String)->Void{
        
        isHaveEdit = true
        
        print("回调的 tag：\(tag),name:\(name)")
        
        switch name {
        case "正常":
            emotion = 0
        case "不舒服":
            emotion = 1
        case "高兴":
            emotion = 2
        default:
            break
        }
        
   
        
        
    }
    
    
    var tpictrueView:TTakingPictureView!
    
    func loadTakingPictureView() {
        
        tpictrueView = TTakingPictureView(frame: CGRect(x: 0,y: 0,width: self.takingPictureView.frame.size.width,height: self.takingPictureView.frame.size.height))
        tpictrueView.backgroundColor = UIColor.white
        
        
        
        
        tpictrueView.subMedicCtr = self
        
 
        
        if self.isEdit {
            let imgurlArray = self.upDic.value(forKey: "imgurl") as! NSArray
            
            //设置图片
            var imgUrlArray = [String]()
            
            for item in imgurlArray {
                let tmpDic = item as! NSDictionary
                
                let url = tmpDic.value(forKey: "imgurl") as! String
                imgUrlArray.append(url)
            }
            
            
            tpictrueView.initTTView(imgUrlArray)
            
            
            
        }else{
            tpictrueView.initTTView([])
           
        }
        
        
        
        tpictrueView.takingPictureClourse = self.takingPictureClourse
        
        self.takingPictureView.addSubview(tpictrueView)
    }
    //MARK:图片选择回调
    func takingPictureClourse(_ imgArray: [AnyObject])->Void{
        isHaveEdit = true
        print("回调的 图片个数->\(imgArray.count)")

        for index in 0..<imgArray.count {
            
            if index != 0 {

                
                if let img = imgArray[index] as? UIImage{
                    
                    let imgData = UIImageJPEGRepresentation(img, 0.005)
                    let base64Data:String = (imgData! as NSData).base64EncodedString()
                    
                    if index == 1 {
                        self.upDic.setValue(base64Data, forKey: "imgurl")
                        
                    }else{
                        self.upDic.setValue(base64Data, forKey: "imgurl\(index - 1)")
                    }

                }else if let img = imgArray[index] as? String {
                    
                    if index == 1 {
                        self.upDic.setValue(img, forKey: "imgurl")
                        
                    }else{
                        self.upDic.setValue(img, forKey: "imgurl\(index - 1)")
                    }
                    
                    
                    
                }
                
     
                
            }
            
            
            
        }
  
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.view.becomeFirstResponder()
 
        self.view.endEditing(true )
        return true
    }
    //点击空白，收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.medicNameTF.resignFirstResponder()
        self.medicDoseTF.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.medicNameTF:
            print("名字")
            self.medicNameTF.isEnabled = false
            
            self.upDic.setValue(textField.text!, forKey: "medicine")

        case self.medicDoseTF:
            print("剂量")
            self.medicDoseTF.isEnabled = false
            self.upDic.setValue(textField.text!, forKey: "content")
        default:
            print("其他")
        }
    }
    //MARK:是否为首次编辑，编辑模式应该要除外
    var textViewIsFirstEdit = true
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        if self.textViewIsFirstEdit {
//            textView.text = ""
            textViewIsFirstEdit = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        if textView.text.isEmpty {
//            textView.text = "添加描述：比如，是否使用胰岛素..."
            self.textViewIsFirstEdit = true
        }else{
            self.upDic.setValue(textView.text, forKey: "food")
        }
        
        
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
