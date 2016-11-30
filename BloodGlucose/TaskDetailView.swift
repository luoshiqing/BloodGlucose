//
//  TaskDetailView.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/26.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class TaskDetailView: UIView , UITableViewDelegate , UITableViewDataSource{

    
    fileprivate var downViewH: CGFloat!
    
    fileprivate var myFrame: CGRect!
    
    fileprivate var myTabView: UITableView?
    
    fileprivate var mid: String!
    
    fileprivate var superCtr: UIViewController?
    
    fileprivate let header = MJRefreshNormalHeader()
    fileprivate let footer = MJRefreshAutoNormalFooter()
    
    fileprivate var commentArray = [[String:String]]()
    fileprivate let topCount = 3
    fileprivate var myDic = [String:Any]()
    
    init(frame: CGRect, downViewH: CGFloat, mid: String, target: UIViewController?) {
        super.init(frame: frame)
        self.myFrame = frame
        self.downViewH = downViewH
        self.mid = mid
        self.superCtr = target
        
        self.loadMyTabView()
        
        self.loadDownView()
        
        self.setRefresh()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate var DetailDownView: LLDownView?
    
    fileprivate func loadDownView(){
        
        self.DetailDownView = Bundle.main.loadNibNamed("LLDownView", owner: nil, options: nil)?.last as? LLDownView
        self.DetailDownView?.frame = CGRect(x: 0, y: self.myFrame.size.height - self.downViewH, width: self.myFrame.size.width, height: self.downViewH)
        
        self.DetailDownView?.llDownClourse = self.detailDownViewClourse
        
        self.addSubview(self.DetailDownView!)
 
    }
    
    func detailDownViewClourse(_ send: UIView)->Void{
        let tag = send.tag
        print("回调的tag:\(tag)")
        
        switch tag {
        case 0:
            print("点赞")
            TaskDetailNetwork().thumbUp(self.mid, clourse: { (good) in
                self.DetailDownView?.setGoodView(good)
            })
            
        case 1:
            print("评论")
            
            let llComVC = LLCommentViewController(nibName: "LLCommentViewController", bundle: Bundle.main)
            llComVC.llcommentClourse = self.LLCommentViewControllerClourse
            self.superCtr?.navigationController?.pushViewController(llComVC, animated: true)
            
        case 2:
            print("提交任务")
            switch self.status {
            case 0,1:
                print("提交任务")
                TaskDetailNetwork().submitTask(self, self.mid, clourse: {
                    BGNetwork().delay(0.51, closure: {
                        if self.superCtr != nil {
                            self.superCtr!.navigationController!.popViewController(animated: true)
                        }
                    })
                })
            case 2:
                print("任务已经完成")
                
            case 3:
                print("添加到任务")
                TaskDetailNetwork().addToTask(self, self.mid, clourse: {
                    self.status = 1
                    self.DetailDownView?.saveLabel.text = "提交任务"
                })
                
            default:
                break
            }
            
        default:
            break
        }
        
        
    }
    //MARK:评论回调
    func LLCommentViewControllerClourse(_ value: String)->Void{
        print("评论回调->:\(value)")
        
        TaskDetailNetwork().submitComments(self, self.mid, content: value) { (success) in
            
            if success { //加载评论
                self.page = 1
                self.commentArray.removeAll()
                self.getSomeDetailComments()
            }
 
        }
  
    }
    
    
    fileprivate func loadMyTabView(){
        let rect = CGRect(x: 0, y: 0, width: self.myFrame.size.width, height: self.myFrame.size.height - self.downViewH)
        self.myTabView = UITableView(frame: rect, style: .plain)
        
        self.myTabView?.delegate = self
        
        self.myTabView?.dataSource = self
        
        self.myTabView?.backgroundColor = UIColor.white

        
        self.addSubview(self.myTabView!)
  
    }
    
    
    fileprivate var status = 2 //任务状态
    
    //MARK:设置值接口
    func setTaskDetailValue(_ dic:[String:Any]){
        self.myDic = dic
        self.commentArray = dic["commentArray"] as! [[String:String]]
        self.status = dic["status"] as! Int
        self.DetailDownView?.setLLDownView(dic)
        
        self.myTabView?.reloadData()
    }
    
    
   
    
    
    
    
    
    
    fileprivate func setRefresh(){
        
        //下拉刷新
        self.header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
        
        self.myTabView?.mj_header = header
        
        
        //上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerRefresh))
        
        self.myTabView?.mj_footer = footer
        
    }
    @objc fileprivate func headerRefresh(){
        
        self.myTabView?.mj_header.endRefreshing()
    }
    //底部刷新

    
    fileprivate var page = 0     //加载的页数
    fileprivate let shownum = 10 //加载的个数
    
    
    @objc fileprivate func footerRefresh(){
        //上拉加载

        if self.page == 0{
            self.commentArray.removeAll()
        }
        
        self.page += 1
        
        self.getSomeDetailComments()
 
    }
    
    fileprivate func getSomeDetailComments(){
        
        TaskDetailNetwork().getSomeDetailCommentsFor(page: self.page, shownum: self.shownum, mid: self.mid) { (success,isHaveData, commentArray) in
            
            if success {
                if isHaveData {
                    self.myTabView?.mj_footer.endRefreshing()
                }else{
                    self.footer.endRefreshingWithNoMoreData()
                }
                if let comm = commentArray {
                    self.commentArray += comm
                }
                
                self.myTabView?.reloadData()
            }else{
                print("网络错误")
                self.footer.endRefreshingWithNoMoreData()
            }
            
        }
        
    }
    
    
    
    fileprivate var fdtCell:FDTUpTableViewCell? //顶部cell
    fileprivate var practiceCell:PracticeTableViewCell? //做法
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topCount + self.commentArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            if fdtCell != nil {
                let labelText = fdtCell?.reviewLabel.text
                
                let string:NSString = labelText! as NSString
                
                let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
                
                let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
                
                let brect = string.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 28, height: 0), options: [options,a], attributes:  [NSFontAttributeName:(fdtCell?.reviewLabel.font)!], context: nil)
                
                return brect.height + (339 - 48)
            }else{
                return 339
            }
        case 1:
            if practiceCell != nil {
                let labelText = practiceCell?.practiceLabel.text
                
                let string:NSString = labelText! as NSString
                
                let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
                
                let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
                
                
                let brect = string.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 28, height: 0), options: [options,a], attributes:  [NSFontAttributeName:(practiceCell?.practiceLabel.font)!], context: nil)
                
                return brect.height + (67 - 23)
            }else{
                return 67
            }
        case 2:
            return 44
        default:
            return 80
        }
        
    }
    
    //未加载完成显示的图片名称
    var imgString = "loadlogo.png"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        switch indexPath.row {
        case 0:
            let ddd = "FDTUpCell" //顶部
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? FDTUpTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("FDTUpTableViewCell", owner: self, options: nil )?.last as? FDTUpTableViewCell
                
            }
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            self.fdtCell = cell
            
            if !self.myDic.isEmpty {
                
                let menu = self.myDic["menu"] as! [String:Any]
                
                //专家点评
                let nutrition = menu["nutrition"] as! String
                    
                if nutrition.isEmpty {
                    cell?.reviewLabel.text = "暂无专家评论"
                }else{
                    cell?.reviewLabel.text = nutrition
                }
                //图片
                let imgUrl = "http://" + (menu["img"] as! String)
                
                let url = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
                
                let tmpImgUrl: URL = URL(string: url!)!
                
                cell?.imgView.sd_setImage(with: tmpImgUrl, placeholderImage: UIImage(named: self.imgString))
                
                //标签
                let tagArray = TaskDetailNetwork().getTagText(menu: menu)
                
                for index in 0..<tagArray.count {
                    if index < 4 {
                        let value = tagArray[index]
                        let lable = cell?.tagArray[index]
                        lable?.isHidden = false
                        lable?.text = value
                    }
                    
                }
                
            }
            return cell!
            
        case 1:
            let ddd = "PracticeCell" //做法
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? PracticeTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("PracticeTableViewCell", owner: self, options: nil )?.last as? PracticeTableViewCell
                
            }
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            self.practiceCell = cell
            
            if !self.myDic.isEmpty {
                let menu = self.myDic["menu"] as! [String:Any]
                let methodsText = TaskDetailNetwork().getMethodsText(menu: menu)
                cell?.practiceLabel.text = methodsText
            }
            
            return cell!
            
        case 2:
            let ddd = "ComtsCell" //评论标题
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? ComtsTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("ComtsTableViewCell", owner: self, options: nil )?.last as? ComtsTableViewCell
                
            }
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            return cell!
            
        default:
            let ddd = "CommentsCell" //评论
            var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? CommentsTableViewCell
            if cell == nil
            {
                cell = Bundle.main.loadNibNamed("CommentsTableViewCell", owner: self, options: nil )?.last as? CommentsTableViewCell
                
            }
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            if !self.commentArray.isEmpty{
                
                let oneDic = self.commentArray[indexPath.row - 3]
                
                let cuname: String = oneDic["cuname"]! //昵称
                let cuicon = oneDic["cuicon"]! //头像
                let cvalue = oneDic["cvalue"]! //评论
                let ctime = oneDic["ctime"]!   //时间
                
                
                cell?.nameLabel.text = cuname
                cell?.commentLabel.text = cvalue
                cell?.timeLabel.text = ctime
                
                
                let aaurl1 = cuicon.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
                
                if !(aaurl1!.isEmpty){
                    let imgurl1:URL = URL(string: aaurl1!)!
                    cell?.imgView.sd_setImage(with: imgurl1, placeholderImage: UIImage(named: "yonghu2.png"))
                }else{
                    cell?.imgView.image = UIImage(named: "yonghu2.png")
                }
  
            }
            
            return cell!
        }
        
        
    
    }
    
    
    
    
    
    

}
