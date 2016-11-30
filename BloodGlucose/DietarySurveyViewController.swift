//
//  DietarySurveyViewController.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/1/28.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class DietarySurveyViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate ,UITextFieldDelegate ,DSHabitsCellDelegate{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var finish:JGProgressHUD!
    
    var getWenjuan:JGProgressHUD!
    //时间
    var timeTime:String!
    
    var xuanxArray = NSMutableArray()
    var daanArray = NSMutableArray()
    
    //标题
    var titleArray = NSMutableArray()
    //题号
    var qidArray = NSMutableArray()
    //选项
    var optionArray = NSMutableArray()
    //答案
    var answerArray = NSMutableArray()
    //备注
    var noteArray = NSMutableArray()
    
    //记录选择的选项
    var memoryDic = NSMutableDictionary()
    //记录输入框的选项
    var memoryTFDic = NSMutableDictionary()
    
    //记录输入框输入的值
    var TFtextDic = NSMutableDictionary()
    //记录选择的值
    var SECtextDic = NSMutableDictionary()
    
    //保存每个cell 的 textField 的值
    var anyOneTFvalue = NSMutableArray()
    
    //最终提交的结果字典
    var saveDic = NSMutableDictionary()
    
    @IBOutlet weak var myTabView: UITableView!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "膳食问卷"
        
        //导航栏
        self.setNav()

        
        
        //设置 当前时间
        let today:Double = Date().timeIntervalSince1970
        let newTiem:Double = today + 8 * 60 * 60
        let dayTime = Date(timeIntervalSince1970: newTiem)
        let str = String(describing: dayTime)
        self.timeTime = (str as NSString).substring(to: 16)

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BaseTabBarView.isHidden = true
        CAGradientLayerEXT().animation(false)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        var frame = self.navigationController?.navigationBar.frame
        frame?.origin.x = 0
        self.navigationController?.navigationBar.frame = frame!
        
        BGNetwork().delay(0.3) { () -> () in
            //获取问卷题目
            self.getSurvey()
        }
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        var frame = self.navigationController?.navigationBar.frame
        frame?.origin.x = 0
        self.navigationController?.navigationBar.frame = frame!
        
    }
    
    
    
    func setNav(){

        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(DietarySurveyViewController.backAct), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
        //提交
        let rightBtn = UIBarButtonItem(title:"提交", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DietarySurveyViewController.saveAct))
        rightBtn.setTitleTextAttributes(NSDictionary(object: UIColor(red: 1.00, green: 1.0, blue: 1.0, alpha: 1), forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBtn
        
    }
    func backAct(){
        self.navigationController!.popViewController(animated: true)
    }
    func saveAct(){

        for i in 0  ..< self.xuanxArray.count  {
            
            //选项
            let xuanx = self.xuanxArray[i] as! String

//            print("xuanx:\(xuanx)")
            
            //题号
            let tihao = self.qidArray[i] as! Int
//            print("tihao:\(tihao)")
            //输入的答案
            let ansA = (self.daanArray[i] as! NSArray)[0] as! String
            let ansB = (self.daanArray[i] as! NSArray)[1] as! String
//            print("ansA:\(ansA)")
//            print("ansB:\(ansB)")
            
//            print(tihao,xuanx,ansA,ansB)
            
            
            if (ansA.characters.count > 0){
                
                
                
                if (ansB.characters.count > 0){
                    
                    let text = "\(xuanx)#@\(ansA)#@\(ansB)"

                    self.saveDic["\(tihao)"] = text
                }else{
                    let text = "\(xuanx)#@\(ansA)#!"

                    self.saveDic["\(tihao)"] = text
                }
                
                
            }else{
                if (ansB.characters.count > 0){
                    
                    let text = "\(xuanx)#!#@\(ansB)"

                    self.saveDic["\(tihao)"] = text

                }else{
                    
                    let text = "\(xuanx)#!#!"

                    self.saveDic["\(tihao)"] = text

                }
            }
            
            
            
        }
 
//         print("self.saveDic:\(self.saveDic)")
        //提交
        self.saveFor(self.saveDic)
        
        self.finish = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.finish.textLabel.text = "提交中..."
        self.finish.show(in: self.view, animated: true)
        
        
    }
    
    func saveFor(_ answer:NSMutableDictionary){
        
        
        let answers = BGNetwork().toJSONString(answer)
//        print("answers:\(answers)")
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/survey/setsurvey.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        
        
        dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "answer":answers,
        ]
        
//        print("dicDPost:\(dicDPost)")
        
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            _ = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
//            print("\(json)")
    
                
            self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.finish.textLabel.text = "提交成功！"
            self.finish.dismiss(afterDelay: 1.0, animated: true)
            
            BGNetwork().delay(1.1, closure: { () -> () in
                self.navigationController!.popViewController(animated: true)
            })

            
            }, failure: { () -> Void in
                
                print("false错误")
                self.finish.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.finish.textLabel.text = "提交失败!"
                self.finish.dismiss(afterDelay: 1.0, animated: true)
        })
   
        
    }
    
    
    func getSurvey(){
        
        
        self.getWenjuan = JGProgressHUD(style: JGProgressHUDStyle.extraLight)
        self.getWenjuan.textLabel.text = "努力加载问卷..."
        self.getWenjuan.show(in: self.view, animated: true)
        
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/survey/getsurvey.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        var dicDPost = NSDictionary()
        
        
        
        dicDPost = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
        ]
        
//        print("dicDPost:\(dicDPost)")
        
        
        RequestBase().doPost(reqUrl, dicDPost as! [AnyHashable: Any], success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
//            print("\(json)")
            
            //i 题号 t 标题 o 选项 a答案 c 备注
            
            /*
            "data" : [
            {
            "a" : "A#!#!",
            "i" : 1,
            "c" : "",
            "o" : "A#三餐;B#两餐;C#三餐加夜宵;D#无规律;",
            "t" : "餐次习惯"
            }
            */
            self.getWenjuan.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.getWenjuan.textLabel.text = "加载成功！"
            self.getWenjuan.dismiss(afterDelay: 1.0, animated: true)
 
            if let dataArray:NSArray = json["data"].arrayObject as NSArray?{
//                print("dataArray个数:\(dataArray.count)")
                for tmp in dataArray{
                    let tmpDic:NSDictionary = tmp as! NSDictionary
                    
                    let answer = tmpDic.value(forKey: "a") as! String  //答案
                    let qid = tmpDic.value(forKey: "i") as! Int     //题号
                    let note = tmpDic.value(forKey: "c") as! String  //备注
                    let option = tmpDic.value(forKey: "o") as! String  //选项
                    let title = tmpDic.value(forKey: "t") as! String  //标题
                    
                    //i 题号 t 标题 o 选项 a答案 c 备注

                    //标题
                    self.titleArray.add(title)
                    //题号
                    self.qidArray.add(qid)
                    //选项
                    self.optionArray.add(option)
                    //答案
                    self.answerArray.add(answer)
                    //备注
                    self.noteArray.add(note)
                    
                    //记录选择的选项
                    self.memoryDic[qid] = 0
                    self.SECtextDic[qid] = ""
                    
                    self.anyOneTFvalue.add(["",""])
                    
                    
                }
                //每个 标题有两个 文本框
                for i in 1 ..< 2 * dataArray.count - 1 {
                    self.memoryTFDic[i] = ""
                }
                
                
                //赋值
                self.testAct()
                
                
            }

            self.myTabView.reloadData()
            
            }, failure: { () -> Void in
                
                print("false错误")
                self.getWenjuan.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.getWenjuan.textLabel.text = "加载失败！"
                self.getWenjuan.dismiss(afterDelay: 1.0, animated: true)
        })

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    
    
    //tableview代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        print("self.titleArray.count:\(self.titleArray.count)")
        return self.titleArray.count + 4
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        

        
        switch (indexPath as NSIndexPath).row{
        case 0:
            return 66
        case 1...2:
            return 51
        case 3:
            return 40
        default:
            if(self.optionArray.count > 0){
                
                var num:Int = 0

                let option = self.optionArray[(indexPath as NSIndexPath).row - 4] as! String

                let optArray = option.components(separatedBy: ";")
                num = optArray.count - 1
                
                let note = self.noteArray[(indexPath as NSIndexPath).row - 4] as! String

                if(note.characters.count > 0){
                    num = num + 1
                }
                
                var heigh:CGFloat = 360.0
                
                switch num{
                case 0:
                    
                    heigh = 360.0 - CGFloat((5 - num) * 56)
                case 1:
                   
                    heigh = 360.0 - CGFloat((5 - num) * 56)
                case 2:
                    
                    heigh = 360.0 - CGFloat((5 - num) * 56)
                case 3:
                    
                    heigh = 360.0 - CGFloat((5 - num) * 56)
                case 4:
                    
                    heigh = 360.0 - CGFloat((5 - num) * 56)
                case 5:
                    
                    heigh = 360.0 - CGFloat((5 - num) * 56)
                default:
                    break
                }
                
                return heigh
            }else{
                return 360.0
            }

        }
   

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     
        let viewTag = (indexPath as NSIndexPath).row * 4
        
        let TFTag = (indexPath as NSIndexPath).row * 2
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            let ddd = "DSHeardCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? DSHeardTableViewCell
            cell = Bundle.main.loadNibNamed("DSHeardTableViewCell", owner: self, options: nil )?.last as? DSHeardTableViewCell
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            cell?.nameLabel.isHidden = true
            cell?.logoImgView.isHidden = false
            
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            return cell!
            
        case 1...2:
            let ddd = "DSNameCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? DSNameTableViewCell
            cell = Bundle.main.loadNibNamed("DSNameTableViewCell", owner: self, options: nil )?.last as? DSNameTableViewCell
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            switch (indexPath as NSIndexPath).row{
            case 1:
                cell?.nameLabel.text = "姓名"
                cell?.inforTF.placeholder = NICKNAME
            case 2:
                cell?.nameLabel.text = "时间"
                cell?.inforTF.placeholder = self.timeTime
            default:
                break
            }
            cell?.testBtn.addTarget(self, action: #selector(DietarySurveyViewController.testAct), for: UIControlEvents.touchUpInside)
            
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            return cell!
        case 3:
            let ddd = "DSHeardCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? DSHeardTableViewCell
            cell = Bundle.main.loadNibNamed("DSHeardTableViewCell", owner: self, options: nil )?.last as? DSHeardTableViewCell
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            cell?.nameLabel.isHidden = false
            cell?.logoImgView.isHidden = true
            
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            return cell!
        default:
            
            let ddd = "HabitsCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? DSHabitsTableViewCell
            if cell == nil
            {
               cell = Bundle.main.loadNibNamed("DSHabitsTableViewCell", owner: self, options: nil )?.last as? DSHabitsTableViewCell
                
            }
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            //设置代理
            cell!.DSHabitsDelegate = self
            //设置tag
            cell?.sec1View.tag = viewTag + 1
            cell?.sec2View.tag = viewTag + 2
            cell?.sec3View.tag = viewTag + 3
            cell?.sec4View.tag = viewTag + 4
            
            
            cell?.titileTF.tag = TFTag + 1 + 590
            cell?.titile1TF.tag = TFTag + 2 + 590
            
            if (self.titleArray.count > 0){


                cell?.titileLabel.text! = self.titleArray[(indexPath as NSIndexPath).row - 4] as! String
                
                //解析标题
                let titile = self.titleArray[(indexPath as NSIndexPath).row - 4] as! String
                
                let tttt = titile.components(separatedBy: "@!")
                    
                //print("tttt:\(tttt)")
                if(tttt.count > 1){
                    //大于一个标题
                    let t1 = tttt[0] 
                    let t2 = tttt[1]
                    //是否含有 ＃！＃（如果含有则为真）
                    if (t1.range(of: "#!#") != nil){
                       // print(".....")
                        
                        //判断是否为后缀 ＃！＃
                        if(t1.hasSuffix("#!#")){
                            //在最后面
                            
//                            print("在最后面")
                            
                            //处理后边的 ＃！＃
                            let tv1 = t1.replacingOccurrences(of: "#!#", with: "", options: NSString.CompareOptions.literal, range: nil)
                            
                            cell?.titileLastLb.isHidden = true
                            cell?.titileTF.isHidden = false
                            cell?.titileLabel.text = tv1
                            
                        }else{
                            //不在最后面，说明后面还有值
//                            print("有")
                            cell?.titileLastLb.isHidden = false
                            cell?.titileTF.isHidden = false
                            
                            let finalText = t1.components(separatedBy: "#!#")
                            
                            let text1 = finalText[0]
                            let text2 = finalText[1]
                            
                            //转为小写
                            let ttttext2 = text2.lowercased()
                            
                            
                            cell?.titileLabel.text = text1
                            cell?.titileLastLb.text = ttttext2
                        }

                    }else{
                        //没有 ＃！＃
                        cell?.titileLabel.text! = t1
                        cell?.titileTF.isHidden = true
                        cell?.titileLastLb.isHidden = true
                    }
                    //是否含有 ＃！＃
                    if (t2.range(of: "#!#") != nil){
//                        print("8555555..")
                        
                        //判断是否包含后缀 ＃！＃
                        if(t2.hasSuffix("#!#")){
                            //在最后
                            
//                            print("在最后")
                            //需要处理 后边的 ＃！＃
                            
                            //处理后边的 ＃！＃
                            let tv2 = t2.replacingOccurrences(of: "#!#", with: "", options: NSString.CompareOptions.literal, range: nil)
                            
                            cell?.titile1Label.isHidden = false
                            cell?.titile1LastLb.isHidden = true
                            cell?.titile1TF.isHidden = false
                            cell?.titile1Label.text = tv2
                        }else{
                            //不在最后面，说明后面还有值
//                            print("有")
                            cell?.titile1LastLb.isHidden = false
                            cell?.titile1TF.isHidden = false
                            cell?.titile1Label.isHidden = false
                            
                            let finalText = t2.components(separatedBy: "#!#")
                            
                            let text1 = finalText[0]
                            let text2 = finalText[1]
                            
                            //转为小写
                            let ttttext2 = text2.lowercased()
                            
                            
                            cell?.titile1Label.text = text1
                            cell?.titile1LastLb.text = ttttext2
                        }
                        
                    }else{
                        cell?.titile1Label.text! = t2
                        cell?.titile1TF.isHidden = true
                        cell?.titile1LastLb.isHidden = true
                    }
                    
                }else{
                    //一个标题
                    let t0 = tttt[0]
                    
                    //隐藏第二行标题
                    cell?.titile1Label.isHidden = true
                    cell?.titile1TF.isHidden = true
                    cell?.titile1LastLb.isHidden = true
                    
                    //判断是否含有 ＃！＃
                    if(t0.range(of: "#!#") != nil){
                        //有 ＃！＃
                        
                        //判断是否为后缀 ＃！＃
                        if(t0.hasSuffix("#!#")){
                            
                            
//                            print("是后缀")
                            //需要处理后缀
                            //处理后边的 ＃！＃
                            let tv0 = t0.replacingOccurrences(of: "#!#", with: "", options: NSString.CompareOptions.literal, range: nil)

                            cell?.titileLastLb.isHidden = true
                            cell?.titileTF.isHidden = false
                            cell?.titile1Label.text = tv0
                        }else{
                            //不在最后面，说明后面还有值
//                            print("有")
                            cell?.titileLastLb.isHidden = false
                            cell?.titileTF.isHidden = false
                            
                            let finalText = t0.components(separatedBy: "#!#")
                            
                            let text1 = finalText[0]
                            let text2 = finalText[1]
                            
                            
                            //转为小写
                            let ttttext2 = text2.lowercased()
                            
                            cell?.titileLabel.text = text1
                            cell?.titileLastLb.text = ttttext2
                        }
   
                    }else{
                        //没有
                        cell?.titileLabel.text! = t0
                        cell?.titileTF.isHidden = true
                        cell?.titileLastLb.isHidden = true
                    }
                    
                    
                    
                }
                
                
                var num:Int = 0
                
                let option = self.optionArray[(indexPath as NSIndexPath).row - 4] as! String
//                print(option)
                
                let optArray = option.components(separatedBy: ";")
                
//                print("optArray\(optArray)")
                
                num = optArray.count - 1
                
                let note = self.noteArray[(indexPath as NSIndexPath).row - 4] as! String
//                print("note:\(note)")
                if(note.characters.count > 0){
                    num = num + 1
                }
//                print("num:\(num)")
                

                
                
                switch num{
                case 0:
                  
                    cell?.selectView.frame = CGRect(x: 25, y: 77, width: UIScreen.main.bounds.width - 25, height: 280 - CGFloat(56 * (5 - num)))
                    cell?.sec1View.isHidden = true
                    cell?.sec2View.isHidden = true
                    cell?.sec3View.isHidden = true
                    cell?.sec4View.isHidden = true
                    cell?.sec5View.isHidden = true
 
                case 1:
                
                    cell?.selectView.frame = CGRect(x: 25, y: 77, width: UIScreen.main.bounds.width - 25, height: 280 - CGFloat(56 * (5 - num)))
                    cell?.sec1View.isHidden = false
                    cell?.sec2View.isHidden = true
                    cell?.sec3View.isHidden = true
                    cell?.sec4View.isHidden = true
                    cell?.sec5View.isHidden = true
                    
                    let note = self.noteArray[(indexPath as NSIndexPath).row - 4] as! String
                    
                    if(note.characters.count > 0){
                        //有备注
                        
                        cell?.sec1Label.textColor = UIColor.purple
                        cell?.sec1Label.text = note
                        cell?.sec1Img.isHidden = true
                        
                        cell?.sec1View.isUserInteractionEnabled = false
                        
                        
                    }else{
                        //没有备注
                        cell?.sec1Label.textColor = UIColor.darkGray
                        //去掉选项 的 ＃
                        let text1 = optArray[0].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        
                        cell?.sec1Label.text! = text1

                        cell?.sec1View.isUserInteractionEnabled = true
                        
                        cell?.sec1Img.isHidden = false
                    }
                    
                    
                    
                case 2:
         
                    cell?.selectView.frame = CGRect(x: 25, y: 77, width: UIScreen.main.bounds.width - 25, height: 280 - CGFloat(56 * (5 - num)))
                    cell?.sec1View.isHidden = false
                    cell?.sec2View.isHidden = false
                    cell?.sec3View.isHidden = true
                    cell?.sec4View.isHidden = true
                    cell?.sec5View.isHidden = true
                    
                    
                    let note = self.noteArray[(indexPath as NSIndexPath).row - 4] as! String
                    
                    if(note.characters.count > 0){
                        //有备注
                        cell?.sec2Label.text = note
                        cell?.sec2Label.textColor = UIColor.purple
                        cell?.sec1Label.textColor = UIColor.darkGray
                        //去掉选项 的 ＃
                        let text1 = optArray[0].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        
                        cell?.sec1Label.text! = text1
                        
                        cell?.sec1Img.isHidden = false
                        cell?.sec2Img.isHidden = true
                        
                        cell?.sec1View.isUserInteractionEnabled = true
                        cell?.sec2View.isUserInteractionEnabled = false
                        
                    }else{
                        //没有备注
                        cell?.sec2Label.textColor = UIColor.darkGray
                        cell?.sec1Label.textColor = UIColor.darkGray
                        //去掉选项 的 ＃
                        let text1 = optArray[0].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        //去掉选项 的 ＃
                        let text2 = optArray[1].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        
                        
                        cell?.sec1Label.text! = text1
                        cell?.sec2Label.text! = text2
                        
                        cell?.sec1Img.isHidden = false
                        cell?.sec2Img.isHidden = false
                        
                        cell?.sec1View.isUserInteractionEnabled = true
                        cell?.sec2View.isUserInteractionEnabled = true
                    }
                    
                    
                case 3:

                    cell?.selectView.frame = CGRect(x: 25, y: 77, width: UIScreen.main.bounds.width - 25, height: 280 - CGFloat(56 * (5 - num)))
                    cell?.sec1View.isHidden = false
                    cell?.sec2View.isHidden = false
                    cell?.sec3View.isHidden = false
                    cell?.sec4View.isHidden = true
                    cell?.sec5View.isHidden = true
                    
                    
                    let note = self.noteArray[(indexPath as NSIndexPath).row - 4] as! String
                    
                    if(note.characters.count > 0){
                        //有备注
                        cell?.sec3Label.text = note
                        cell?.sec3Label.textColor = UIColor.purple
                        cell?.sec2Label.textColor = UIColor.darkGray
                        cell?.sec1Label.textColor = UIColor.darkGray
                        //去掉选项 的 ＃
                        let text1 = optArray[0].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text2 = optArray[1].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        
                        
                        cell?.sec1Label.text! = text1
                        cell?.sec2Label.text! = text2
                        
                        cell?.sec1Img.isHidden = false
                        cell?.sec2Img.isHidden = false
                        cell?.sec3Img.isHidden = true
                        
                        
                        cell?.sec1View.isUserInteractionEnabled = true
                        cell?.sec2View.isUserInteractionEnabled = true
                        cell?.sec3View.isUserInteractionEnabled = false
                        
                    }else{
                        //没有备注
                        cell?.sec3Label.textColor = UIColor.darkGray
                        cell?.sec2Label.textColor = UIColor.darkGray
                        cell?.sec1Label.textColor = UIColor.darkGray
                        //去掉选项 的 ＃
                        let text1 = optArray[0].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text2 = optArray[1].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text3 = optArray[2].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        
                        cell?.sec1Label.text! = text1
                        cell?.sec2Label.text! = text2
                        cell?.sec3Label.text! = text3
                        
                        cell?.sec1Img.isHidden = false
                        cell?.sec2Img.isHidden = false
                        cell?.sec3Img.isHidden = false
                        
                        cell?.sec1View.isUserInteractionEnabled = true
                        cell?.sec2View.isUserInteractionEnabled = true
                        cell?.sec3View.isUserInteractionEnabled = true
                    }
                    
                case 4:

                    cell?.selectView.frame = CGRect(x: 25, y: 77, width: UIScreen.main.bounds.width - 25, height: 280 - CGFloat(56 * (5 - num)))
                    cell?.sec1View.isHidden = false
                    cell?.sec2View.isHidden = false
                    cell?.sec3View.isHidden = false
                    cell?.sec4View.isHidden = false
                    cell?.sec5View.isHidden = true
                    
                    
                    let note = self.noteArray[(indexPath as NSIndexPath).row - 4] as! String
                    
                    if(note.characters.count > 0){
                        //有备注
                        cell?.sec4Label.text = note
                        cell?.sec4Label.textColor = UIColor.purple
                        cell?.sec3Label.textColor = UIColor.darkGray
                        cell?.sec2Label.textColor = UIColor.darkGray
                        cell?.sec1Label.textColor = UIColor.darkGray
                        //去掉选项 的 ＃
                        let text1 = optArray[0].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text2 = optArray[1].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text3 = optArray[2].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        
                        cell?.sec1Label.text! = text1
                        cell?.sec2Label.text! = text2
                        cell?.sec3Label.text! = text3
                        
                        cell?.sec1Img.isHidden = false
                        cell?.sec2Img.isHidden = false
                        cell?.sec3Img.isHidden = false
                        cell?.sec4Img.isHidden = true
                        
                        cell?.sec1View.isUserInteractionEnabled = true
                        cell?.sec2View.isUserInteractionEnabled = true
                        cell?.sec3View.isUserInteractionEnabled = true
                        cell?.sec4View.isUserInteractionEnabled = false
                        
                    }else{
                        //没有备注
                        cell?.sec4Label.textColor = UIColor.darkGray
                        cell?.sec3Label.textColor = UIColor.darkGray
                        cell?.sec2Label.textColor = UIColor.darkGray
                        cell?.sec1Label.textColor = UIColor.darkGray
                        //去掉选项 的 ＃
                        let text1 = optArray[0].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text2 = optArray[1].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text3 = optArray[2].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text4 = optArray[3].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        
                        cell?.sec1Label.text! = text1
                        cell?.sec2Label.text! = text2
                        cell?.sec3Label.text! = text3
                        cell?.sec4Label.text! = text4
                        
                        cell?.sec1Img.isHidden = false
                        cell?.sec2Img.isHidden = false
                        cell?.sec3Img.isHidden = false
                        cell?.sec4Img.isHidden = false
                        
                        cell?.sec1View.isUserInteractionEnabled = true
                        cell?.sec2View.isUserInteractionEnabled = true
                        cell?.sec3View.isUserInteractionEnabled = true
                        cell?.sec4View.isUserInteractionEnabled = true
                    }
                    
                    
                case 5:

                    cell?.selectView.frame = CGRect(x: 25, y: 77, width: UIScreen.main.bounds.width - 25, height: 280 - CGFloat(56 * (5 - num)))
                    cell?.sec1View.isHidden = false
                    cell?.sec2View.isHidden = false
                    cell?.sec3View.isHidden = false
                    cell?.sec4View.isHidden = false
                    cell?.sec5View.isHidden = false
                    
                    
                    let note = self.noteArray[(indexPath as NSIndexPath).row - 4] as! String
                    
                    if(note.characters.count > 0){
                        //有备注
                        cell?.sec5Label.text = note
                        cell?.sec5Label.textColor = UIColor.purple
                        cell?.sec4Label.textColor = UIColor.darkGray
                        cell?.sec3Label.textColor = UIColor.darkGray
                        cell?.sec2Label.textColor = UIColor.darkGray
                        cell?.sec1Label.textColor = UIColor.darkGray
                        //去掉选项 的 ＃
                        let text1 = optArray[0].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text2 = optArray[1].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text3 = optArray[2].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text4 = optArray[3].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        
                        cell?.sec1Label.text! = text1
                        cell?.sec2Label.text! = text2
                        cell?.sec3Label.text! = text3
                        cell?.sec4Label.text! = text4
                        
                        cell?.sec1Img.isHidden = false
                        cell?.sec2Img.isHidden = false
                        cell?.sec3Img.isHidden = false
                        cell?.sec4Img.isHidden = false
                        cell?.sec5Img.isHidden = true
                        
                        cell?.sec1View.isUserInteractionEnabled = true
                        cell?.sec2View.isUserInteractionEnabled = true
                        cell?.sec3View.isUserInteractionEnabled = true
                        cell?.sec4View.isUserInteractionEnabled = true
                        cell?.sec5View.isUserInteractionEnabled = false
                    }else{
                        //没有备注
                        cell?.sec4Label.textColor = UIColor.darkGray
                        cell?.sec3Label.textColor = UIColor.darkGray
                        cell?.sec2Label.textColor = UIColor.darkGray
                        cell?.sec1Label.textColor = UIColor.darkGray
                        //去掉选项 的 ＃
                        let text1 = optArray[0].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text2 = optArray[1].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text3 = optArray[2].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)
                        let text4 = optArray[3].replacingOccurrences(of: "#", with: ".", options: NSString.CompareOptions.literal, range: nil)

                        
                        cell?.sec1Label.text! = text1
                        cell?.sec2Label.text! = text2
                        cell?.sec3Label.text! = text3
                        cell?.sec4Label.text! = text4
                        
                        cell?.sec1Img.isHidden = false
                        cell?.sec2Img.isHidden = false
                        cell?.sec3Img.isHidden = false
                        cell?.sec4Img.isHidden = false
                        cell?.sec5Img.isHidden = false
                        
                        cell?.sec1View.isUserInteractionEnabled = true
                        cell?.sec2View.isUserInteractionEnabled = true
                        cell?.sec3View.isUserInteractionEnabled = true
                        cell?.sec4View.isUserInteractionEnabled = true
                        cell?.sec5View.isUserInteractionEnabled = true
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                default:
                    break
                }
                
                
                
                
                //取出选项对应的 值
//                print("indexPath.row\(indexPath.row - 3)")
                let value:Int = self.memoryDic[(indexPath as NSIndexPath).row - 3] as! Int
                
                
//                print("值：\(value)")
                switch value{
                case 0:
                    cell?.sec1Img.image = UIImage(named: "dian2.png")
                    cell?.sec2Img.image = UIImage(named: "dian2.png")
                    cell?.sec3Img.image = UIImage(named: "dian2.png")
                    cell?.sec4Img.image = UIImage(named: "dian2.png")
                case 1:
                    cell?.sec1Img.image = UIImage(named: "dian1.png")
                    cell?.sec2Img.image = UIImage(named: "dian2.png")
                    cell?.sec3Img.image = UIImage(named: "dian2.png")
                    cell?.sec4Img.image = UIImage(named: "dian2.png")
                case 2:
                    cell?.sec1Img.image = UIImage(named: "dian2.png")
                    cell?.sec2Img.image = UIImage(named: "dian1.png")
                    cell?.sec3Img.image = UIImage(named: "dian2.png")
                    cell?.sec4Img.image = UIImage(named: "dian2.png")
                case 3:
                    cell?.sec1Img.image = UIImage(named: "dian2.png")
                    cell?.sec2Img.image = UIImage(named: "dian2.png")
                    cell?.sec3Img.image = UIImage(named: "dian1.png")
                    cell?.sec4Img.image = UIImage(named: "dian2.png")
                case 4:
                    cell?.sec1Img.image = UIImage(named: "dian2.png")
                    cell?.sec2Img.image = UIImage(named: "dian2.png")
                    cell?.sec3Img.image = UIImage(named: "dian2.png")
                    cell?.sec4Img.image = UIImage(named: "dian1.png")
                default:
                    break
                }
                
                

//                //上面的tf
//                let oneValue:String = self.memoryTFDic[TFTag - 3 - 4] as! String
//                
//                //下面的tf
//                let towValue:String = self.memoryTFDic[TFTag - 2 - 4] as! String
//                
//                cell?.titileTF.text = oneValue
//                cell?.titile1TF.text = towValue
                
                
                
                
                
                //设置选项
                let xuanx = self.xuanxArray[(indexPath as NSIndexPath).row - 4] as! String
//                print(xuanx)
                
                switch xuanx{
                case "A":
                    cell?.sec1Img.image = UIImage(named: "dian1.png")
                    cell?.sec2Img.image = UIImage(named: "dian2.png")
                    cell?.sec3Img.image = UIImage(named: "dian2.png")
                    cell?.sec4Img.image = UIImage(named: "dian2.png")
                case "B":
                    cell?.sec1Img.image = UIImage(named: "dian2.png")
                    cell?.sec2Img.image = UIImage(named: "dian1.png")
                    cell?.sec3Img.image = UIImage(named: "dian2.png")
                    cell?.sec4Img.image = UIImage(named: "dian2.png")
                case "C":
                    cell?.sec1Img.image = UIImage(named: "dian2.png")
                    cell?.sec2Img.image = UIImage(named: "dian2.png")
                    cell?.sec3Img.image = UIImage(named: "dian1.png")
                    cell?.sec4Img.image = UIImage(named: "dian2.png")
                case "D":
                    cell?.sec1Img.image = UIImage(named: "dian2.png")
                    cell?.sec2Img.image = UIImage(named: "dian2.png")
                    cell?.sec3Img.image = UIImage(named: "dian2.png")
                    cell?.sec4Img.image = UIImage(named: "dian1.png")
                default:
                    cell?.sec1Img.image = UIImage(named: "dian2.png")
                    cell?.sec2Img.image = UIImage(named: "dian2.png")
                    cell?.sec3Img.image = UIImage(named: "dian2.png")
                    cell?.sec4Img.image = UIImage(named: "dian2.png")
                }
                //设置文本框
                let daanArray = self.daanArray[(indexPath as NSIndexPath).row - 4] as! NSArray
//                print("daanArray:\(daanArray)")
            
                let daAnOne = daanArray[0] as! String
                let daAnTow = daanArray[1] as! String
                cell?.titileTF.text = daAnOne
                cell?.titile1TF.text = daAnTow
                
                
                
            }

            
            //右边箭头
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            return cell!

 
            
        }
  
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        print("点击了：\((indexPath as NSIndexPath).row)")
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //点击 return 收起键盘

            
        self.view.becomeFirstResponder()

        self.view.endEditing(true )
        return true
    }
    
    
    //cell 代理
    func viewAct(_ view:UIView){
        print("view1Act:\(view.tag)")
        let viewTag = view.tag
        

        
        let cell = (view.superview?.superview?.superview) as! DSHabitsTableViewCell
        
        print("viewTag:\(viewTag)")
        
        
        
        
        let tagM = viewTag % 4
 
        
        var selecLabel:String!
        var SELECabc:String!
        
        switch tagM{
        case 0:
            selecLabel = cell.sec4Label.text!
            print("0选择的是：\(viewTag / 4 - 4)个cell")
            let cellCount = viewTag / 4 - 4
            
            self.memoryDic[cellCount] = 4
            self.SECtextDic[cellCount] = selecLabel
            
            SELECabc = selecLabel.components(separatedBy: ".")[0]
            self.xuanxArray[cellCount - 1] = SELECabc
        case 1:
            selecLabel = cell.sec1Label.text!
             print("1选择的是：\(viewTag / 4 + 1 - 4)个cell")
            let cellCount = viewTag / 4 + 1 - 4
            self.memoryDic[cellCount] = 1
            self.SECtextDic[cellCount] = selecLabel
            
            SELECabc = selecLabel.components(separatedBy: ".")[0]
            self.xuanxArray[cellCount - 1] = SELECabc
            
            
        case 2:
            selecLabel = cell.sec2Label.text!
             print("2选择的是：\(viewTag / 4 + 1 - 4)个cell")
            let cellCount = viewTag / 4 + 1 - 4

            self.memoryDic[cellCount] = 2
            self.SECtextDic[cellCount] = selecLabel
            
            SELECabc = selecLabel.components(separatedBy: ".")[0]
            self.xuanxArray[cellCount - 1] = SELECabc
        case 3:
            selecLabel = cell.sec3Label.text!
            print("3选择的是：\(viewTag / 4 + 1 - 4)个cell")
            let cellCount = viewTag / 4 + 1 - 4
            self.memoryDic[cellCount] = 3
            self.SECtextDic[cellCount] = selecLabel
            
            SELECabc = selecLabel.components(separatedBy: ".")[0]
            self.xuanxArray[cellCount - 1] = SELECabc
        default:
            break
        }
        
        print("选择的是：\(SELECabc)")
        
    }
    
    //MARK:- TextFieldDelegate 代理
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
       

        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        print("编辑完成")
        print("textField.tag － 590:\(textField.tag - 590)")
        print("textField.text:\(textField.text!)")
        
        
        let textFtag = textField.tag - 590
        
        //计算cell 行数
        var rowTF:Int!
        //实际的tag 值（出去前面 4个cell）
        let HTAG = textFtag - 8
        print(HTAG)
        
        let textM = HTAG % 2    //模
        let textV = HTAG / 2    //
        
        if (textM == 0){
            rowTF = textV
        }else{
            rowTF = textV + 1
        }
        
        
        print("第\(rowTF)个cell \n tag:\(HTAG)\n \(textField.text!)")
        
        self.memoryTFDic[HTAG] = textField.text!
        

        
        let cell = textField.superview?.superview?.superview as! DSHabitsTableViewCell
        let a = cell.titileTF.text!
        let b = cell.titile1TF.text!
        
        print("a:\(a),b:\(b)")
        
        self.anyOneTFvalue[rowTF - 1] = [a,b]
        
        
        //存值
        self.daanArray[rowTF - 1] = [a,b]
        
        
    }

    
    func testAct(){
//        print("测试")
        
//        print("answerArray：\(self.answerArray)")
        /*
        "A#!#!",
        "B#!#!",
        "C#!#!",
        "#@44#!",
        "A#@51#!",
        */
        for tmp in self.answerArray{
            let tmpStr = tmp as! String
            
//            print("tmpStr:\(tmpStr)")
            let A:String!
            let B:String!
            let C:String!
            
            let strArray = tmpStr.components(separatedBy: "#")
//            print("strArray:\(strArray)")
            
            
            let strCount = strArray.count
            
            switch strCount{
            case 1:
                print("1")
                
                A = strArray[0]
                B = ""
                C = ""
            case 2:
                print("2")
                A = strArray[0]
                B = strArray[1]
                C = ""
            case 3:
                A = strArray[0]
                B = strArray[1]
                C = strArray[2]
            default:
                A = ""
                B = ""
                C = ""
            }
            
//            print("AA:\(A)")
            //添加值
            self.xuanxArray.add(A)
            
            
            
            
//            print("self.xuanxArray:\(self.xuanxArray)")
            if ((B.range(of: "@")) != nil){
                
                let bb = B.components(separatedBy: "@")
                
//                print(bb[1])
                
                if ((C.range(of: "@")) != nil){
                    let cc = C.components(separatedBy: "@")
//                    print(cc[1])
                    
                    self.daanArray.add([bb[1],cc[1]])
                    
                }else{
                    self.daanArray.add([bb[1],""])
                }
                
                
            }else{
                
                if ((C.range(of: "@")) != nil){
                    let cc = C.components(separatedBy: "@")
//                    print(cc[1])
                    
                    self.daanArray.add(["",cc[1]])
                }else{
                    self.daanArray.add(["",""])
                }
            }
            
        }
        

        
    }
    
}
