//
//  StatiisticalHelpViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/7/25.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class StatiisticalHelpViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    
    
    var myTabView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.white
        self.title = "帮助说明"
        
        
        self.setNav()
        
        
        
        myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
        myTabView.delegate = self
        myTabView.dataSource = self
        myTabView.tableFooterView = UIView()
        myTabView.separatorStyle = .none
        self.view.addSubview(myTabView)
        
        
        
    }
    
    
    func setNav(){
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(StatiisticalHelpViewController.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
    }
    func someBtnAct(_ send: UIButton){
        switch send.tag {
        case 0:
            self.navigationController!.popViewController(animated: true)
        default:
            break
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    var SHelpLeftCell: SHelpLeftTableViewCell!

    //MARK:tableView 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.useInformationTitleArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if SHelpLeftCell != nil {
            let labelText = SHelpLeftCell?.myMainLabel.text
            
            let string:NSString = labelText! as NSString
            
            let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
            
            let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
            
            let brect = string.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 30, height: 0), options: [options,a], attributes:  [NSFontAttributeName:(SHelpLeftCell?.myMainLabel.font)!], context: nil)
            
            return brect.height + (53 - 18)
        }else{
            return 53
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ddd = "SHelpLeftCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? SHelpLeftTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("SHelpLeftTableViewCell", owner: self, options: nil )?.last as? SHelpLeftTableViewCell
            
        }
        
        SHelpLeftCell = cell
        
        cell?.myTitleLabel.text = self.useInformationTitleArray[(indexPath as NSIndexPath).row]
        
        cell?.myTitleLabel.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        
        cell?.myMainLabel.text = self.useInformationMainArray[(indexPath as NSIndexPath).row]
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        
        return cell!
        
  
    }
    
    var useInformationTitleArray = ["血糖：","事件：","添加："]
    var useInformationMainArray = ["您添加的血糖记录可在【统计】中查看您记录的全部血糖值，并且可以选择日期查看相关日期的血糖值变化曲线。\n\n点击【查看全屏】时可看到各个时间点的血糖变化曲线，也可以单独查看某个或多个时间点的血糖变化曲线，可让您更直观、准确的查看特殊时间点的血糖变化趋势。\n\n您记录的血糖值也会以表格的形式呈现给您，按照凌晨、早餐前后、午餐前后、晚餐前后、睡前和随机 时间点记录。\n\n也可点击【记录】查看您记录的全部时间、血糖值记录。",
                                   "在【事件】中记录了您的添加的饮食、药物、运动事件总和，您每次添加的饮食和运动事件，优医糖都会计算出您摄入和消耗的能量，可以直观的看出您一天摄入和消耗的能量值，也可以作为参考来有效调节自己的饮食和运动量哦~\n\n点击已添加完的事件，可以查看详情并且进行补充修改，让您的事件记录更完美吧~",
                                   "点击【添加】可对血糖、饮食、药物、运动事件进行添加操作哦~不需要返回到首页进行添加。"]
    
    

}
