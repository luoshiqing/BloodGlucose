//
//  SupAddFoddViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/3.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class SupAddFoddViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UITextViewDelegate ,DateViewDelegate{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @IBOutlet weak var timeView: UIView! //时间选择视图
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    //高兴
    @IBOutlet weak var happyView: UIView!
    @IBOutlet weak var happyImgView: UIImageView!
    @IBOutlet weak var happyLabel: UILabel!
    //正常
    @IBOutlet weak var normlView: UIView!
    @IBOutlet weak var normlImgView: UIImageView!
    @IBOutlet weak var normlLabel: UILabel!
    //不舒服
    @IBOutlet weak var sorryView: UIView!
    @IBOutlet weak var sorryImgView: UIImageView!
    @IBOutlet weak var sorryLabel: UILabel!
    //图片选择视图
    @IBOutlet weak var pictureView: UIView!
    //标签选择视图
    @IBOutlet weak var tagView: UIView!
    
    
    @IBOutlet weak var takingPictureView: UIView!
    
    
    
    
    @IBOutlet weak var picTextView: UITextView!
    
    
    
    
    @IBOutlet weak var pictureH: NSLayoutConstraint! //220
    
    
    fileprivate var currentDate: Date?
    
    
    //上级控制器
    var tmpCtr: UIViewController?
    
    
    
    //默认心情 高兴
    var emotion = 2
    
    
    //----心情列表---------
    var feelViewArray = [UIView]()
    var feelImgViewArray = [UIImageView]()
    var feelLabelArray = [UILabel]()
    //--------------
    
    
    
    //编辑时接受数据
    var isEdit = false //是否为编辑
    
    var isEditAndFirst = true
    
    var logid = ""
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(self.upDic)
        
        
        self.title = "饮食事件"
        
      
        self.setNav()
        
        //添加到数组
        self.feelSomeViewAddToArray()
        
        //视图点击事件
        self.setViewAct()
        
        //加载图片选择区域
//        self.loadPictureView()
        self.loadTakingPictureView()
        
        self.picTextView.delegate = self
        
        
        let Hsize = (UIScreen.main.bounds.height - 64 - 20 - 54 * 2) / (667 - 64 - 20 - 54 * 2)
        pictureH.constant = 220 * Hsize
        
        
        //加载标签区域
        self.loadTagView()
        
        
        
        
        
        if self.isEdit && self.isEditAndFirst{
            //设置 值
            self.setSomeValueToView(self.upDic)
            self.isEditAndFirst = false
        }else{
            //设置时间
            self.setTime()
        }
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        BaseTabBarView.isHidden = true

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
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
        
        self.timeLabel.text = "\(time) \(isDateAndTime)"
        
        self.upDic.setValue(time, forKey: "date")
        self.upDic.setValue(isDateAndTime, forKey: "time")
    }
    
    
    
    
    
    var tpictrueView:TTakingPictureView!
    
    func loadTakingPictureView() {
        
//        tpictrueView = TTakingPictureView(frame: CGRect(x: 0,y: 0,width: self.takingPictureView.frame.size.width,height: self.takingPictureView.frame.size.height))
        tpictrueView = TTakingPictureView(frame: CGRect(x: 0,y: 0,width: self.takingPictureView.frame.size.width,height: 90))
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
        self.isHaveEdit = true
        print("回调的 图片个数->\(imgArray.count)")
        
        print(imgArray)
        
        
        
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
    
    
    
    func setNav(){
        
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(SupAddFoddViewController.leftBtnAct(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
        if self.isEdit { //为编辑
            //编辑
            let (rightBtn,rightSpacer,rightItem) = BGNetwork().creatRightBtnAtt(false, title: "修改")
            rightBtn.addTarget(self, action: #selector(SupAddFoddViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
            rightBtn.tag = 2
            self.navigationItem.rightBarButtonItems = [rightSpacer,rightItem]
        }else{
            //添加
            let (rightBtn,rightSpacer,rightItem) = BGNetwork().creatRightBtnAtt(false, title: "完成")
            rightBtn.addTarget(self, action: #selector(SupAddFoddViewController.btnAct(_:)), for: UIControlEvents.touchUpInside)
            rightBtn.tag = 1
            self.navigationItem.rightBarButtonItems = [rightSpacer,rightItem]
        }
        
        
    }
    
    //是否编辑过
    var isHaveEdit = false

    
    func leftBtnAct(_ send:UIButton){
        
        if isHaveEdit {
            let actionSheet = UIAlertController(title: "是否退出本次编辑", message: "", preferredStyle: UIAlertControllerStyle.alert)
            actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
                
                self.navigationController!.popViewController(animated: true)
                
            }))
            actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        }else{
            self.navigationController!.popViewController(animated: true)
        }
        
        
  
    }
    
    
    var upDic = NSMutableDictionary()

    var did = NSMutableDictionary()
    
    var host:Double = 0.0
    //MARK:提交到服务器
    func btnAct(_ send: UIButton){
        
        
        
        
        
        
        self.upDic.setValue("\(self.emotion)", forKey: "emotion")
        
        self.picTextView.resignFirstResponder()
        
        var food = ""
        if let food1 = self.upDic.value(forKey: "food") as? String
        {
            food = food1
        }
        
        
        if !isFirstEdit {
            food = self.picTextView.text
        }
        
        
        
        if food.isEmpty {
            let alrteView = UIAlertView(title: "请添加描述", message: "", delegate: nil, cancelButtonTitle: "确定")
            alrteView.show()
            return
        }
        
        
        
        self.upDic.setValue(food, forKey: "content")
        self.upDic.setValue("food", forKey: "type")
        self.upDic.setValue("\(self.host)", forKey: "sport")
        
        print(self.upDic)
        
        print(self.mySelectImgArray.count)
        for item in 0..<self.mySelectImgArray.count {
            
            let img = self.mySelectImgArray[item]
            
            let imgData = UIImageJPEGRepresentation(img, 0.2)
            let phtoBase64data:String = (imgData! as NSData).base64EncodedString()
            if item == 0 {
                self.upDic.setValue(phtoBase64data, forKey: "imgurl")
            }else{
                self.upDic.setValue(phtoBase64data, forKey: "imgurl\(item)")
            }

        }
        
        if (self.upDic.value(forKey: "date") as? String) == nil {
            let alrteView = UIAlertView(title: "请选择时间", message: "", delegate: nil, cancelButtonTitle: "确定")
            alrteView.show()
            
            return
        }
        

        if let medicine = self.upDic.value(forKey: "medicine") as? NSArray{
            
            if medicine.count > 0 {
                let medicineStr = BGNetwork().AnyObjectToJSONString(medicine)
                
                self.upDic.setValue(medicineStr, forKey: "medicine")
            }
//            else{
//                let alrteView = UIAlertView(title: "请选择食物标签", message: "", delegate: nil, cancelButtonTitle: "确定")
//                alrteView.show()
//                return
//            }
            
            

        }else if let medicine = self.upDic.value(forKey: "medicine") as? String {
            
            print("OK->>>>>>> \(medicine)")
           
        }
//        else{
//            let alrteView = UIAlertView(title: "请选择食物标签", message: "", delegate: nil, cancelButtonTitle: "确定")
//            alrteView.show()
//            return
//        }

        
        
        if self.isEdit {
            
            let logId = self.upDic.value(forKey: "logId") as! String
            //修改
            self.xiugaiBtn(self.upDic, logId: logId)
        }else{
            self.saveAct(self.upDic)
        }
        
        
        
    }

    var finish:JGProgressHUD!
    //MARK:新增
    func saveAct(_ dic: NSMutableDictionary){
        
   
        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = "数据提交"
        self.finish.show(in: self.view, animated: true)
        
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
        ]

        var dicc = [AnyHashable: Any]()
        
        for (key,value) in dic {
            dicc.updateValue(value, forKey: key as! AnyHashable)
        }
        for (key,value) in dicDPost {
            dicc.updateValue(value, forKey: key as! AnyHashable)
        }
        
        
        
//        dicc.addEntries(from: dic as [AnyHashable: Any])
//        dicc.addEntries(from: dicDPost as! [AnyHashable: Any])
        
        
        print(dicc)
        
        RequestBase().doPost(reqUrl, dicc, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            print("\(json)")
            
            

            if let message = json["message"].string{
                
                if message == "添加成功"{
                    
                    
                    print("添加成功")
                    
                    BGNetwork().delay(0.51, closure: { () -> () in

                        //暂存全局
//                        let date = dicc.value(forKey: "date") as! String
                        
                        var date = ""
                        if let tmpdate = dicc["date"] as? String {
                            date = tmpdate
                            dateString = date
                        }
  
                        var timeH = ""
                        if let tmptimeH = dicc["time"] as? String {
                            timeH = tmptimeH
                        }
                        
                        //转换为时间戳
                        let CCaa:String = "\(date) \(timeH):00"
                        print(CCaa) //2016-01-01 15:50:00
                        let dateFmt = DateFormatter()
                        dateFmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date1:Date = dateFmt.date(from: CCaa)!
                        print(date1) //2016-01-01 07:50:00 +0000
                        let shijianc:Double = date1.timeIntervalSince1970
                        print(shijianc)
                        dateDouble = shijianc
                        
                        if let ctr = self.tmpCtr{
                            isSecBlood = false
                            self.navigationController!.popToViewController(ctr, animated: true)
                        }else{
                            self.navigationController!.popViewController(animated: true)
                        }

                    })
    
                    
                }else{
                    self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.finish.textLabel.text = "提交失败"
                    self.finish.dismiss(afterDelay: 0.5, animated: true)
                }
   
            }else{
                
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "提交失败"
                self.finish.dismiss(afterDelay: 0.5, animated: true)
    
                
            }
            
            
            
            }, failure: { () -> Void in
                
                print("false")
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "网络错误"
                self.finish.dismiss(afterDelay: 0.5, animated: true)
        })
        
        
    }
    
    //MARK:修改
    func xiugaiBtn(_ dic: NSMutableDictionary,logId: String){
        
        print(dic)
        
        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = "修改中.."
        self.finish.show(in: self.view, animated: true)
        
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
            "logId":logId,
        ]
        
        var dicc = [AnyHashable: Any]()
        
        for (key,value) in dic {
            dicc.updateValue(value, forKey: key as! AnyHashable)
            
        }
        for (key,value) in dicDPost {
            dicc.updateValue(value, forKey: key as! AnyHashable)
        }

 
        print(dicc)
        
        RequestBase().doPost(reqUrl, dicc, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            print("\(json)")
            
            self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.finish.textLabel.text = "修改成功"
            self.finish.dismiss(afterDelay: 0.5, animated: true)
            
            if let message = json["message"].string{
                
                if message == "修改成功"{
                    
                    
                    print("修改成功")
                    
                    BGNetwork().delay(0.51, closure: { () -> () in
                        
                        //暂存全局
                        
                        var date = ""
                        
                        if let tmpdate = dicc["date"] as? String{
                            date = tmpdate
                            dateString = tmpdate
                        }
                        
                        var timeH = ""
                        
                        if let tmptimeH = dicc["time"] as? String{
                            timeH = tmptimeH
                        }
                        
                        //转换为时间戳
                        let CCaa:String = "\(date) \(timeH):00"
                        print(CCaa) //2016-01-01 15:50:00
                        let dateFmt = DateFormatter()
                        dateFmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date1:Date = dateFmt.date(from: CCaa)!
                        print(date1) //2016-01-01 07:50:00 +0000
                        let shijianc:Double = date1.timeIntervalSince1970
                        print(shijianc)
                        dateDouble = shijianc

                        if let ctr = self.tmpCtr{
                            
                            isSecBlood = false
                            self.navigationController!.popToViewController(ctr, animated: true)
                        }else{
                            self.navigationController!.popViewController(animated: true)
                        }
                        
                        
                    })
                    
                    
                    
                    
                    
                    
                }
                
            }
            
            
            
            }, failure: { () -> Void in
                
                print("false")
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "网络错误"
                self.finish.dismiss(afterDelay: 0.5, animated: true)
        })
        
        
        
        
        
    }
    
    //第一次编辑
    var isFirstEdit = true

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.isHaveEdit = true
        //开始编辑
        if isFirstEdit {
//            textView.text = nil
            isFirstEdit = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !(textView.text.characters.count > 0) {
//            self.picTextView.text = "添加描述:比如，我今天吃了米饭、蔬菜"
            isFirstEdit = true
        }
    }
    
    //MARK:设置编辑的
    override func viewDidAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        
        
    }
    

    
    func setSomeValueToView(_ dic: NSDictionary){
        
        let date = dic.value(forKey: "date") as! String //时间
        let time = dic.value(forKey: "time") as! String
        
        let emotion = dic.value(forKey: "emotion") as! Int //心情
        
//        let imgurl = dic.valueForKey("imgurl") as! NSArray //图片数组
        
        let food = dic.value(forKey: "food") as! String //描述
        
        let medicine = dic.value(forKey: "medicine") as! [NSDictionary] //标签
        
        let sport = dic.value(forKey: "sport") as! Float

        
        self.host = Double(sport)
        
        self.timeLabel.text = "\(date) \(time)"
        
        self.upDic.setValue(date, forKey: "date")
        self.upDic.setValue(time, forKey: "time")
        
        
        if food.isEmpty {
            self.picTextView.text = "添加描述:比如我今天吃了米饭、蔬菜"
        }else{
            self.picTextView.text = food
        }

        //情绪（0正常.1不舒服.2高兴）
        for index in 0..<self.feelImgViewArray.count {
            let feelImg:UIImageView = self.feelImgViewArray[index]
            let feelLabel:UILabel = self.feelLabelArray[index]
            
            if emotion == index {
                feelImg.image = UIImage(named: "eventSD")
                feelLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
            }else{
                feelImg.image = UIImage(named: "eventNSD")
                feelLabel.textColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1)
            }
            
        }
        
        
        
        
        
        
        
        //标签
        self.upDic.setValue(medicine, forKey: "medicine")

        self.loadTagBaseView(medicine)
        
        
        
    }

    
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func feelSomeViewAddToArray(){
        
        self.feelViewArray.append(happyView)
        self.feelViewArray.append(normlView)
        self.feelViewArray.append(sorryView)
        
        self.feelImgViewArray.append(happyImgView)
        self.feelImgViewArray.append(normlImgView)
        self.feelImgViewArray.append(sorryImgView)
        
        self.feelLabelArray.append(happyLabel)
        self.feelLabelArray.append(normlLabel)
        self.feelLabelArray.append(sorryLabel)
        
  
    }
    
    func setViewAct(){
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(SupAddFoddViewController.someViewAct(_:)))
        self.timeView.addGestureRecognizer(tap1)
        self.timeView.tag = 10
        
        for index in 0..<self.feelViewArray.count {
            let feelView:UIView = self.feelViewArray[index]
            let tap = UITapGestureRecognizer(target: self, action: #selector(SupAddFoddViewController.someViewAct(_:)))
            feelView.addGestureRecognizer(tap)
            feelView.tag = index

        }
    
    }
    
    //记录当前是第几张图片
    var selecIndexImg = 0
    
    //MARK:视图点击事件
    //1.心情
    func someViewAct(_ send:UITapGestureRecognizer){
        print(send.view!.tag)
        
        self.isHaveEdit = true
        
        switch send.view!.tag {
        case 0...2:
            for index in 0..<self.feelImgViewArray.count {
                let feelImg:UIImageView = self.feelImgViewArray[index]
                let feelLabel:UILabel = self.feelLabelArray[index]
                
                if send.view!.tag == index {
                    feelImg.image = UIImage(named: "eventSD")
                    feelLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
                }else{
                    feelImg.image = UIImage(named: "eventNSD")
                    feelLabel.textColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 1)
                }

            }
            
            self.emotion = send.view!.tag
        case 20...22:
            
            self.selecIndexImg = send.view!.tag - 20
            
            let actionSheet = UIAlertController(title: "选择照片", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            actionSheet.addAction(UIAlertAction(title: "拍照", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
                self.phtoAct()
            }))
            
            actionSheet.addAction(UIAlertAction(title: "相册", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
                self.selecetPhto()

            }))
            
            
            actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        case 10:
            print("选择时间")
            self.loadDateView("时间")
        case 40:
            print("添加标签")
            //MARK:添加标签
            
            
            let subFoodVC = SubAddFoodViewController()
            
            subFoodVC.subAddFoodClours = self.addFoodClours
            
            self.navigationController?.pushViewController(subFoodVC, animated: true)

        default:
            break
        }
   
        
    }
  
    
    //MARK:按钮点击事件
    func someBtnAct(_ send:UIButton){

        let sendTag = send.tag - 30
        print("sendTag:\(sendTag)")
        
        switch sendTag {
        case 0:
            self.mySelectImgArray.remove(at: 0)
            
        case 1:
            
            self.mySelectImgArray.remove(at: 1)
  
        case 2:
            self.mySelectImgArray.removeLast()

        default:
            break
        }
        
        self.setImgShowAndFrame(self.mySelectImgArray)
        
        
    }
 
    
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
        
        self.isHaveEdit = true
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let tmpDate = dateFormatter.date(from: date)
        
        
        self.currentDate = tmpDate
        
        
//        let time = (date as NSString).substring(with: NSRange(0...9))
//        let isDateAndTime = (date as NSString).substring(with: NSRange(11...15))

        let time = (date as NSString).substring(with: NSRange(location: 0, length: 10))
        let isDateAndTime = (date as NSString).substring(with: NSRange(location: 11, length: 5))
        
        print(time,isDateAndTime)
        
        self.timeLabel.text = "\(time) \(isDateAndTime)"
        
        self.upDic.setValue(time, forKey: "date")
        self.upDic.setValue(isDateAndTime, forKey: "time")
        
        self.closeSexView()
    }
    func closeDateView() {
        self.closeSexView()
    }
    func closeSexView(){
        if self.dateView != nil {
            self.dateView.removeFromSuperview()
            self.dateView = nil
        }
        if self.dateBgView != nil {
            self.dateBgView.removeFromSuperview()
            self.dateBgView = nil
        }
    }
    
    //拍照
    func phtoAct(){
        var sourceTyte = UIImagePickerControllerSourceType.camera
        if !UIImagePickerController .isSourceTypeAvailable(.camera)
        {
            sourceTyte = UIImagePickerControllerSourceType.photoLibrary
        }
        let pickerC = UIImagePickerController()
        pickerC.delegate = self
        pickerC.allowsEditing = true
        pickerC.sourceType = sourceTyte
        pickerC.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self .present(pickerC, animated: false) { () -> Void in
            
        }
    }
    
    //拍照的照片
    var phtoImage:UIImage!
    var image = UIImagePickerController()
    
    //相册选取
    func selecetPhto(){
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        image.allowsEditing = true
        
        self.present(image, animated: false, completion: nil)
    }
    
    //MARK:保存选择的照片数组
    var mySelectImgArray = [UIImage]()
    
    //相册代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
//        self.dismissViewControllerAnimated(false, completion: nil)
//        
//        let gotImg:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        picker.dismiss(animated: false, completion: nil)
        
        
        var image: UIImage!
        
        if picker.allowsEditing {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        
        
        
        self.phtoImage = image
        

        if self.mySelectImgArray.isEmpty {
            self.mySelectImgArray.append(image)
        }else{
            
            if self.mySelectImgArray.count > self.selecIndexImg {
                self.mySelectImgArray[self.selecIndexImg] = image
            }else{
                self.mySelectImgArray.append(image)
            }
   
        }

   
        
        self.setImgShowAndFrame(self.mySelectImgArray)
        
    }
    
    
    
    var pictureImgArray = [UIImageView]()
    var pictureBtnArray = [UIButton]()
    
    
    func loadPictureView(){
        
  
        for index in 0...2 {
            let imgView = UIImageView(frame: CGRect(x: 20 + CGFloat(index) * (70 + 10), y: 10, width: 70, height: 70))
            
            imgView.image = UIImage(named: "eventPhto")
            self.pictureView.addSubview(imgView)
            
            imgView.isUserInteractionEnabled = true
            //。。。。。。。。。。。。
            imgView.contentMode = UIViewContentMode.scaleToFill
            
            
            //设置label 圆角
            imgView.layer.cornerRadius = 4
            imgView.clipsToBounds = true
            
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(SupAddFoddViewController.someViewAct(_:)))
            imgView.addGestureRecognizer(tap)
            imgView.tag = 20 + index
            
            if index == 0 {
                imgView.isHidden = false
            }else{
                imgView.isHidden = true
            }
            
            
            self.pictureImgArray.append(imgView)
            
            
            
//            let clearBtn = UIButton(frame: CGRect(x: 20 + (70 - 10) + CGFloat(index) * (70 + 10) ,y: 4,width: 16,height: 16))
            
            
            let x: CGFloat = 20 + (70 - 10) + CGFloat(index) * (70 + 10)
            let clearBtn = UIButton(frame: CGRect(x: x, y: 4, width: 16, height: 16))
            
            
//            clearBtn.backgroundColor = UIColor.redColor()
            clearBtn.setBackgroundImage(UIImage(named: "eventDelet"), for: UIControlState())
            self.pictureView.addSubview(clearBtn)
            
            clearBtn.addTarget(self, action: #selector(SupAddFoddViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            clearBtn.tag = 30 + index
            
            
            clearBtn.isHidden = true
            
            self.pictureBtnArray.append(clearBtn)
            
    
            
        }
 

        
    }
    
    
    func setImgShowAndFrame(_ imgArray: [UIImage]){
 
        for item in 0..<self.pictureImgArray.count {
            
            let pictureImgView = self.pictureImgArray[item]
            let pictureBtn = self.pictureBtnArray[item]
            
            
            switch imgArray.count {
            case 0:
                
                if item == 0 {
                    pictureImgView.isHidden = false
                    pictureImgView.image = UIImage(named: "eventPhto")
                    pictureBtn.isHidden = true
                }else{
                    pictureImgView.isHidden = true
                    pictureBtn.isHidden = true
                }

            case 1:
                switch item {
                case 0:
                    pictureImgView.isHidden = false
                    pictureImgView.image = imgArray[item]
                    
                    pictureBtn.isHidden = false
                    
                case 1:
                    pictureImgView.isHidden = false
                    pictureImgView.image = UIImage(named: "eventPhto")
                    
                    pictureBtn.isHidden = true
                default:
                    pictureImgView.isHidden = true
                    pictureBtn.isHidden = true
                }

            case 2:
                switch item {
                case 0,1:
                    pictureImgView.isHidden = false
                    pictureImgView.image = imgArray[item]
                    
                    pictureBtn.isHidden = false
                default:
                    pictureImgView.isHidden = false
                    pictureImgView.image = UIImage(named: "eventPhto")
                    pictureBtn.isHidden = true
                }
            case 3:
                pictureImgView.isHidden = false
                pictureImgView.image = imgArray[item]
                pictureBtn.isHidden = false
            default:
                break
            }
  
        }
        
        
    }
    
    
    //标签数组
    var tagViewArray = [UIView]()
    
    var myTagView:UIView!
    //标签区域
    func loadTagView(){
       
        
        let size = UIScreen.main.bounds.size
        
        let Hsize = (UIScreen.main.bounds.height - 64 - 20 - 54 * 2) / (667 - 64 - 20 - 54 * 2)
        
        
        
        if self.myTagView == nil {
            self.myTagView = UIView(frame: CGRect(x: 20,y: 40,width: size.width - 40,height: 180 * Hsize))
            
//            self.myTagView.backgroundColor = UIColor.orangeColor()
            
            self.tagView.addSubview(self.myTagView)
            
            
            let Wsize = (UIScreen.main.bounds.width - 40) / (320 - 40)
            
            let addView = UIView(frame: CGRect(x: 0,y: 8,width: 62 * Wsize,height: 27))

            self.myTagView.addSubview(addView)
            
            //用户名视图
            addView.layer.cornerRadius = 3
            addView.layer.masksToBounds = true
            addView.layer.borderWidth = 0.5
            addView.layer.borderColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1).cgColor
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(SupAddFoddViewController.someViewAct(_:)))
            addView.addGestureRecognizer(tap)
            addView.tag = 40
            //+
            let addLabel = UILabel(frame: CGRect(x: 0,y: 0,width: addView.frame.size.width,height: addView.frame.size.height - 5))
            addLabel.textAlignment = .center
            addLabel.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
            addLabel.text = "+"
            addLabel.font = UIFont.systemFont(ofSize: 30)
            addView.addSubview(addLabel)
            
            if !self.tagViewArray.isEmpty {
                self.tagViewArray.remove(at: 0)
            }
            
            self.tagViewArray.insert(addView, at: 0)
        }
        
        
        
        
    }
    
   
    
    func loadTagBaseView(_ nameArry: [NSDictionary]){
        
        for index in 0..<nameArry.count {
            
            
            let tagBaseView = Bundle.main.loadNibNamed("TagBaseView", owner: nil, options: nil)?.last as! TagBaseView
            
            tagBaseView.deleteBtn.tag = self.tagViewArray.count
            tagBaseView.tagBaseViewClosur = self.tagBaseViewValueClosur
            
            self.tagViewArray.append(tagBaseView)
            
            
            let dic = nameArry[index]
            
            let name = dic.value(forKey: "name") as! String
            let size = dic.value(forKey: "size") as! String
            
            tagBaseView.typeName = name
            
            let sizeInt = Int(size)!
            
            var doseStr = ""
            
            switch sizeInt {
            case 5:
                doseStr = "半斤"
            case 10:
                doseStr = "一斤"
            case 20:
                doseStr = "更多"
            default:
                doseStr = "\(size)两"
            }
            
            
            
            tagBaseView.doseName = doseStr
            
        }
        self.setTagSizeAndFrame(self.tagViewArray)
        

        
    }
    func setTagSizeAndFrame(_ viewArray: [UIView]){

        
        var baseViewArray = [UIView]()
        
        for item in 0..<viewArray.count {
            if item != 0 {
                
                let tmpView = viewArray[item] as! TagBaseView
                
                baseViewArray.append(tmpView)
            }
        }
        
        
        let mo = baseViewArray.count % 4
        
        
        var hang = 1 //行数
        
        if mo == 0 { //刚好
            hang = baseViewArray.count / 4
        }else{//+1
            hang = baseViewArray.count / 4 + 1
        }

        //记录item跟index
        var tmpItem = 0
        var tmpIndex = 0
        
        
        //
        let Wsize = (UIScreen.main.bounds.width - 40) / (320 - 40)
        
        
        if hang != 0 {
            for item in 0...hang - 1 {
                
                for index in 0...3 {
                    
                    let add = item * 4 + index
                    
                    //                print(add)
                    
                    if add < baseViewArray.count{
                        
                        
                        let baseView = baseViewArray[add] as! TagBaseView
                        baseView.frame = CGRect(x: CGFloat(index) * 70 * Wsize, y: CGFloat(item) * (35 + 5), width: 70 * Wsize, height: 35)
                        
                        self.myTagView.addSubview(baseView)
                        
                        if index == 3 {
                            tmpItem = item + 1
                            tmpIndex = 0
                        }else{
                            tmpItem = item
                            tmpIndex = index + 1
                        }
                        
                    }
                    
                    
                }
                
            }
  
        }
        
        
        
        let addView = viewArray[0] 
        
        addView.frame = CGRect(x: CGFloat(tmpIndex) * 70 * Wsize, y: 8 + CGFloat(tmpItem) * (35 + 5), width: 62 * Wsize, height: 27)
  
        
    }
    //MARK:删除回调
    func tagBaseViewValueClosur(_ tag: Int,send: UIButton)->Void{
        print("回调的tag:\(tag)")
        let supView = send.superview as! TagBaseView
  
        print(self.upDic)
        
        var tmpMedicine = [NSDictionary]()
        
        if var medicine = self.upDic.value(forKey: "medicine") as? [NSDictionary] {
            
            let oneHost:Double = Double(medicine[tag - 1].value(forKey: "host") as! String)!
            let size:Double = Double(medicine[tag - 1].value(forKey: "size") as! String)!
            
            let tmpHost = oneHost * size
            print(tmpHost)

            self.host -= tmpHost
            
            medicine.remove(at: tag - 1)
            
            tmpMedicine = medicine
            
            self.upDic.setValue(medicine, forKey: "medicine")
            print(self.upDic)
        }
        
        
        
        
//        let supView = send.superview as! TagBaseView

        for item in 0..<self.tagViewArray.count {
            
            if item != 0 {
                let baseView = self.tagViewArray[item] as! TagBaseView
                
                if supView == baseView {

                    self.tagViewArray.remove(at: item)
                    break
                }
                
            }
  
        }
        
        
        
        

        
        if self.myTagView != nil {
            self.myTagView.removeFromSuperview()
            self.myTagView = nil
        }
        
        
        self.tagViewArray.removeAll()
        
        self.loadTagView()
        
        
        self.loadTagBaseView(tmpMedicine)
        
//        self.setTagSizeAndFrame(self.tagViewArray)
    }
    
 
    
    //食物选择回调
    func addFoodClours(_ host: Double,nameArray: [NSDictionary])->Void{
        print(host,nameArray)
        self.isHaveEdit = true
        print("饮食标签回调 -> 饮食事件")
        
        
        self.host += host
        
        for item in nameArray {
            let name = item.value(forKey: "name") as! String
            print(name)
        }
        
        var dic:[NSDictionary] = nameArray
        
        if let aa = self.upDic.value(forKey: "medicine") as? [NSDictionary]{
            print(aa)
            
            dic += aa
            
        }

        self.upDic.setValue(dic, forKey: "medicine")
        
        print(self.upDic)
        
        self.loadTagBaseView(nameArray)
        
    }
    
    
    

}
