//
//  FoodSeasonViewController.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/2/26.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class FoodSeasonViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //主要表示图
    @IBOutlet weak var myTabView: UITableView!

    @IBOutlet weak var vegetableView: UIView! //蔬菜视图
    @IBOutlet weak var vegetableLabel: UILabel!//蔬菜label
    //肉类
    @IBOutlet weak var meatView: UIView!
    @IBOutlet weak var meatLabel: UILabel!
    //移动的视图
    @IBOutlet weak var moveView: UIView!
    
    //头部
    let header = MJRefreshNormalHeader()
    //尾部
    let footer = MJRefreshAutoNormalFooter()
    
    
    //选择的是蔬菜还是肉类(false 为蔬菜 ，true 为肉类)
    var vegetableORmeat:Bool = false
    //蔬菜数组
    var vegetableIdArray = [String]()  //id
    var vegetableUrlArray = [String]() //url
    var vegetableNameArray = [String]()//名字
    var vegetableNoteArray = [String]()//备注
    //肉类数组
    var meatIdArray = [String]()
    var meatUrlArray = [String]()
    var meatNameArray = [String]()
    var meatNoteArray = [String]()
    
    //蔬菜
    var vegetablePage:Int!      //页数
    var vegetableShownum:Int!   //个数
    //肉类
    var meatPage:Int!           //页数
    var meatShownum:Int!        //个数
    //是否还有更多的数据（false 为没有了）
    var vegetableMore:Bool = true
    var meatMore:Bool = true
    
    //未加载完成显示的图片名称
    var imgString = "loadlogo.png"
    var imgFaild = "loading_failed.png"
    
    
    
    @IBOutlet weak var MoveW: NSLayoutConstraint!
    
    @IBOutlet weak var VegetableW: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "应季食物"
        
        //设置MJRefresh
        self.setMJRefresh()
        
        //设置视图点击事件
        self.setViewAct()
        //设置导航栏
        self.setNav()
        //布局
        self.setLayOut()
        
        //tableview去掉多余线条
        self.myTabView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        //获取蔬菜
        if (self.vegetablePage == nil){
            self.vegetablePage = 1
        }
        if (self.vegetableShownum == nil){
            self.vegetableShownum = 15
        }
        if (self.vegetableNameArray.count <= 0){
            //获取蔬菜
            self.getSeasonalFood(self.vegetablePage, shownum: self.vegetableShownum, cate: 1)
        }
        
        
    }
    //设置导航栏
    func setNav(){
        //返回
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(FoodSeasonViewController.backAct), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
    }
    func backAct(){
        self.navigationController!.popViewController(animated: true)
    }

    func setLayOut(){
        let Wsize = UIScreen.main.bounds.width
        self.MoveW.constant = Wsize / 2
        self.VegetableW.constant = Wsize / 2
    }
    //设置视图点击事件
    func setViewAct(){
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(FoodSeasonViewController.tap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(FoodSeasonViewController.tap(_:)))
        
        self.vegetableView.addGestureRecognizer(tap1)
        self.meatView.addGestureRecognizer(tap2)
        
        self.vegetableView.tag = 2016022601
        self.meatView.tag = 2016022602
    }
    func tap(_ send:UITapGestureRecognizer){
        switch send.view!.tag{
        case 2016022601:
            print("蔬菜")
            self.setMoveViewFram(false)
            self.vegetableORmeat = false
            if (self.vegetableNameArray.count <= 0){
                //获取蔬菜
                self.vegetablePage = 1
                self.vegetableShownum = 15
                self.getSeasonalFood(self.vegetablePage, shownum: self.vegetableShownum, cate: 1)
            }
            
            
        case 2016022602:
            print("肉类")
            self.setMoveViewFram(true)
            self.vegetableORmeat = true
            if (self.meatNameArray.count <= 0){
                //获取蔬菜
                self.meatPage = 1
                self.meatShownum = 15
                self.getSeasonalFood(self.meatPage, shownum: self.vegetableShownum, cate: 2)
            }
  
        default:
            break
        }
        //重置？？？
        self.footer.resetNoMoreData()
        self.myTabView.reloadData()
    }
    //设置移动的视图的位置
    func setMoveViewFram(_ fram:Bool){
        let KWscreen = UIScreen.main.bounds.width
        //false为蔬菜，true为肉类
        if (fram == false){
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.25)
            
            self.moveView.frame = CGRect(x: 0, y: self.vegetableView.frame.size.height , width: KWscreen / 2 , height: 2)
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeOut) //设置动画相对速度
            UIView.commitAnimations()
            
        }else{
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.25)
            
            self.moveView.frame = CGRect(x: KWscreen / 2, y: self.vegetableView.frame.size.height , width: KWscreen / 2 , height: 2)
            
            UIView.setAnimationCurve(UIViewAnimationCurve.easeOut) //设置动画相对速度
            UIView.commitAnimations()
        }
    }
    
    
    //设置MJRefresh
    func setMJRefresh(){
        //下拉刷新
        self.header.setRefreshingTarget(self, refreshingAction: #selector(FoodSeasonViewController.headerRefresh))
        self.myTabView.mj_header = header

        //上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(FoodSeasonViewController.footerRefresh))
        self.myTabView.mj_footer = footer
    }
    func headerRefresh(){
        print("下拉刷新")
        self.myTabView.mj_header.endRefreshing()
    }
    
    //底部刷新

    func footerRefresh(){
        //上拉加载
        print("上拉加载")
        if (self.vegetableORmeat == false){
            //蔬菜
            if (self.vegetableMore == false){
                //没有更多的数据了
                self.footer.endRefreshingWithNoMoreData()
            }else{
                //还有数据
                self.vegetablePage = self.vegetablePage + 1
                self.getSeasonalFood(self.vegetablePage, shownum: self.vegetableShownum, cate: 1)
                self.myTabView.mj_footer.endRefreshing()
            }
            
        }else{
            //肉类
            if (self.meatMore == false) {
                //没有更多
                self.footer.endRefreshingWithNoMoreData()
            }else{
                
                self.meatPage = self.meatPage + 1
                self.getSeasonalFood(self.meatPage, shownum: self.vegetableShownum, cate: 2)
                self.myTabView.mj_footer.endRefreshing()
            }
            
        }
  
  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- 获取食物
    func getSeasonalFood(_ page:Int,shownum:Int,cate:Int){

        //page 页数
        //shownum 显示个数
        //cate 食材类别  1-蔬菜   2-肉了
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/getmaterialbycate.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost: [String:Any] = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "page":page,
            "shownum":shownum,
            "cate":cate]

        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print("\(json)")
            

            if let code:Int = json["code"].int{
                if (code == 1){
                    print("加载成功")
                    
                    if let dataDic = json["data"].dictionaryObject as? [String:AnyObject]{

                        let listArray = dataDic["list"] as! [[String:AnyObject]]
                        
                        if (listArray.count > 0) {
                            for tmpDic in listArray {
                                
                                //id
                                let id = String(describing: tmpDic["id"] as! NSNumber)
                                //url
                                let url1 = tmpDic["i"] as! String
                                let url = "http://\(url1)"
                                //name
                                let name = tmpDic["n"] as! String
                                //note
                                let note = tmpDic["c"] as! String
                                
                                
                                if (self.vegetableORmeat == false){
                                    //蔬菜
                                    self.vegetableIdArray.append(id)
                                    self.vegetableUrlArray.append(url)
                                    self.vegetableNameArray.append(name)
                                    self.vegetableNoteArray.append(note)
                                    
                                }else{
                                    //肉类
                                    self.meatIdArray.append(id)
                                    self.meatUrlArray.append(url)
                                    self.meatNameArray.append(name)
                                    self.meatNoteArray.append(note)
                                }
 
                            }
                        }else{
                            //没有数据
                            if (self.vegetableORmeat == false) {
                                //蔬菜
                                self.vegetableMore = false
                            }else{
                                self.meatMore = false
                            }
                        }
     
                        
                    }
                    
                    
                    
                }
                
                
                self.myTabView.reloadData()
            }
            
            }, failure: { () -> Void in
                
                print("false错误")
                
        })
        
        
        
        
        
    }
    
    
    
    //TableView代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.vegetableORmeat == false){
            //蔬菜
            return self.vegetableNameArray.count
        }else{
            //肉类
            return self.meatNameArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let ddd = "seasonalCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? SeasonalTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("SeasonalTableViewCell", owner: self, options: nil )?.last as? SeasonalTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        if (self.vegetableORmeat == false) {
            //蔬菜
            if (self.vegetableNameArray.count > 0){
                cell?.nameLabel.text = self.vegetableNameArray[indexPath.row]
                cell?.shuomingLabel.text = self.vegetableNoteArray[indexPath.row]
                
                let vegetableUrl = self.vegetableUrlArray[indexPath.row]
                
                let aaurl = vegetableUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
                let imgurl:URL = URL(string: aaurl!)!

                cell?.imgView.sd_setImage(with: imgurl, placeholderImage: UIImage(named: self.imgString))
                
            }
 
        }else{
            //肉类
            if (self.meatNameArray.count > 0){
                
                cell?.nameLabel.text = self.meatNameArray[indexPath.row]
                cell?.shuomingLabel.text = self.meatNoteArray[indexPath.row]
                
                let vegetableUrl = self.meatUrlArray[indexPath.row]
                
                let aaurl = vegetableUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
                let imgurl:URL = URL(string: aaurl!)!

                cell?.imgView.sd_setImage(with: imgurl, placeholderImage: UIImage(named: self.imgString))
                
            }
            
        }

        return cell!
    }
    
    
    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.vegetableORmeat == false) {
            //蔬菜
            let id = self.vegetableIdArray[indexPath.row]
            self.toFoodCustomViewController(id)
        }else{
            //肉类
            let id = self.meatIdArray[indexPath.row]
            self.toFoodCustomViewController(id)
        }
        
    }

    func toFoodCustomViewController(_ id:String) {
        

        let customVC = CustomFoodViewController()
        
        customVC.idString = id
        
        self.navigationController?.pushViewController(customVC, animated: true)
        
    }

    
    
}
