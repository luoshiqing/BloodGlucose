//
//  FoodHotViewController.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/2/29.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit



class FoodHotViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //是否还有更多的数据（false 为没有了）
    var dataMore:Bool = true
    
    let Wsize = UIScreen.main.bounds.width / 320
    //未加载完成显示的图片名称
    var imgString = "loadlogo.png"
    var imgFaild = "loading_failed.png"
    
    
    let header = MJRefreshNormalHeader()
    
    let footer = MJRefreshAutoNormalFooter()
    
    
    //记录数据的个数
    var pageInt:Int = 0
    var numInt:Int = 0
    //数据
    var nameArray = [String]() //名字
    var idArray = [String]()  //id
    var urlArray = [String]()//url
    var noteArray = [String]()//备注
    var loveArray = [String]()//喜欢的个数
    
    
    
    //属性－－－－－－－－－－
    @IBOutlet weak var firstImgView: UIImageView!
    @IBOutlet weak var secondImgView: UIImageView!
    @IBOutlet weak var thirdImgView: UIImageView!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!

    @IBOutlet weak var myTabView: UITableView!
    
    
    
    
    
    
    
    //布局－－－－－－－－
    @IBOutlet weak var LeftW: NSLayoutConstraint!//100
    
    @IBOutlet weak var MideW: NSLayoutConstraint!//101
    
    @IBOutlet weak var MideToL: NSLayoutConstraint!//110
    
    
    @IBOutlet weak var RighW: NSLayoutConstraint!//100
    
    
    @IBOutlet weak var MideLToL: NSLayoutConstraint!//110
    
    @IBOutlet weak var MideRToR: NSLayoutConstraint!//109
    
    
    @IBOutlet weak var LeftToL: NSLayoutConstraint!//10
    
    
    @IBOutlet weak var LeftLToL: NSLayoutConstraint!
    
    
    @IBOutlet weak var RighRToR: NSLayoutConstraint!
    
    @IBOutlet weak var RighToR: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //恢复导航栏
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        self.title = "热门食物"

        
        //布局
        self.setLayOut()
        
        //设置图片
        self.setImg()
        
        //设置上下拉刷新加载
        self.setRefresh()
        
        //设置导航栏
        self.setNav()
    }

    override func viewWillAppear(_ animated: Bool) {
        //获取热门食物
        //获取热门食物
        if (self.nameArray.count < 1){
            self.pageInt = 1
            self.numInt = 10
            self.getHotFood(self.pageInt, shownum: self.numInt)
        }
        
    }
    //设置导航栏
    func setNav(){
        //返回
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(FoodHotViewController.backAct), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
        
    }
    func backAct(){
        self.navigationController!.popViewController(animated: true)
    }
    func setLayOut(){
        
        
        LeftW.constant = Wsize * 100
        MideW.constant = Wsize * 101
        MideToL.constant = Wsize * 110
        RighW.constant = Wsize * 100
        MideLToL.constant = Wsize * 110
        MideRToR.constant = Wsize * 109
        
        LeftToL.constant = Wsize * 10
        LeftLToL.constant = Wsize * 10
        RighToR.constant = Wsize * 10
        RighRToR.constant = Wsize * 10
        
    }
    
    func setRefresh(){
        //下拉刷新
        self.header.setRefreshingTarget(self, refreshingAction: #selector(FoodHotViewController.headerRefresh))
        
        self.myTabView.mj_header = header
        
        //上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(FoodHotViewController.footerRefresh))
        self.myTabView.mj_footer = footer
    }
    func headerRefresh(){
        print("下拉刷新")
        self.myTabView.mj_header.endRefreshing()
    }
    
    //底部刷新
    
    func footerRefresh(){
        
        
        
        if (self.dataMore == false){
            //没有更多的数据了
            self.footer.endRefreshingWithNoMoreData()
        }else{
            //还有数据
            self.pageInt = self.pageInt + 1
            self.getHotFood(self.pageInt, shownum: self.numInt)
            self.myTabView.mj_footer.endRefreshing()
        }
 
    }
    
    
    func setImg(){
        //设置图片 圆角
        self.firstImgView.layer.cornerRadius = 90 / 2.0
        self.firstImgView.clipsToBounds = true
        
        self.secondImgView.layer.cornerRadius = 75 / 2.0
        self.secondImgView.clipsToBounds = true
        
        self.thirdImgView.layer.cornerRadius = 75 / 2.0
        self.thirdImgView.clipsToBounds = true
        
        
    }
    
    func getHotFood(_ page:Int,shownum:Int){
        
        
        let userid:String = String(ussssID)
        let reqUrl:String = "\(TEST_HTTP)/jsp/dietmanager/getgoodmenulist.jsp"
        let code:String = "\(userid)_\(CLIENTID)_\(KEY)_\(RandoM)"
        let codeMD5 = code.md5.uppercased()
        
        let dicDPost: [String:Any] = [
            "userid":userid,
            "clientid":CLIENTID,
            "random":RandoM,
            "code":codeMD5,
            "page":page,
            "shownum":shownum]
  
        
        RequestBase().doPost(reqUrl, dicDPost, success: { (res: Any?) in
            
            let json = JSON(data: res as! Data, options: JSONSerialization.ReadingOptions(), error: nil)
            
            //print("\(json)")
  
            if let code:Int = json["code"].int
            {
                if (code == 1)
                {
                    //print("加载成功")
                    if let dataDic = json["data"].dictionaryObject as? [String:AnyObject]{
                        let listArray = dataDic["list"] as! [[String:AnyObject]]
                        
                        //判断是否有更多的数据
                        if (listArray.count < 1) {
                            self.dataMore = false
                        }else{
                            self.dataMore = true
                        }
                        
                        for tmpDic in listArray{
     

                            let url = "http://\(tmpDic["i"] as! String)"
                            let name:String = tmpDic["n"] as! String
                            let note:String = tmpDic["m"] as! String
                            let id = String(describing: tmpDic["id"] as! NSNumber)
                            let love = String(tmpDic["g"] as! Int)
                            
                            self.nameArray.append(name)
                            self.idArray.append(id)
                            self.urlArray.append(url)
                            self.noteArray.append(note)
                            self.loveArray.append(love)
   
                        }
                    }
                    
                }
                
            }
            //设置前三图片
            self.setFirstImg()
            
            //刷新表示图
            self.myTabView.reloadData()
            

            }, failure: { () -> Void in
                
                print("false错误")
                
        })
        
        
    }
    func setFirstImg(){
        
        let firstUrl = self.urlArray[0]
        let secondUrl = self.urlArray[1]
        let thridUrl = self.urlArray[2]
        
        let firstName = self.nameArray[0]
        let secondName = self.nameArray[1]
        let thridName = self.nameArray[2]
        
        self.firstLabel.text = firstName
        self.secondLabel.text = secondName
        self.thirdLabel.text = thridName
        
        let Furl = firstUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        let imgurl:URL = URL(string: Furl!)!
        
        
        self.firstImgView.sd_setImage(with: imgurl, placeholderImage: UIImage(named: self.imgString))
        
        let Surl = secondUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        let imgurlS:URL = URL(string: Surl!)!
 
        self.secondImgView.sd_setImage(with: imgurlS, placeholderImage: UIImage(named: self.imgString))
        
        let Turl = thridUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        let imgurlT:URL = URL(string: Turl!)!

        self.thirdImgView.sd_setImage(with: imgurlT, placeholderImage: UIImage(named: self.imgString))
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //tabView代理
    // 行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArray.count
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ddd = "hotCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? HotTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("HotTableViewCell", owner: self, options: nil )?.last as? HotTableViewCell
            
        }
        
        if self.nameArray.count > 0 {
            cell?.nameLabel.text! = self.nameArray[indexPath.row]
            cell?.shuomLabel.text! = self.noteArray[indexPath.row]
            cell?.gggLabel.text! = self.loveArray[indexPath .row]
            
            let url:String = self.urlArray[indexPath.row]
            let aaurl3 = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
            let imgurl3:URL = URL(string: aaurl3!)!

            cell?.imgView.sd_setImage(with: imgurl3, placeholderImage: UIImage(named: self.imgString))
     
        }
        
        
        
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        return cell!
    }
    //cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    //选择
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
        let name:String = self.nameArray[indexPath.row]
        let id:String = self.idArray[indexPath.row]
        
 
        let taskDetailVC = TaskDetailViewController(title: name, mid: id)
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
        
    }
    
    
    
}
