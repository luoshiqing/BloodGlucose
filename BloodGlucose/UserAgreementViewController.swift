//
//  UserAgreementViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/8.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class UserAgreementViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    
    
    let titleArray = ["使用条款","一、使用须知","二、免责声明","三、我已知晓接受此次服务可能面临的风险和获益，并愿意接受动态血糖监测服务。"]
    
    let oneSectionArray = ["   北京吾久智慧医疗科技有限公司(www.udoct.com)是一个以动态血糖管理为服务的公司。  当使用我们的app产品和服务时，您将受到所有不时发布的、适用于此等服务的准则或规则的制约。我们可能不时推出新的服务，所有此等服务都将受此服务条款的制约。"]
    
    
    let towSectionArray = ["1.动态血糖监测(CGM)服务的适用患者或情况,包括:",
                           "    (1)1型糖尿病",
                           "    (2)需要胰岛素强化治疗(例如每日3次以上皮下胰岛素治疗或胰岛素泵强化治疗)的2型糖尿病患者",
                           "    (3)在自我血糖管理的指导下使用降糖治疗的2型糖尿病患者，仍出现下列情况之一：",
                           "         a.无法解释的严重低血糖或反复低血糖、无症状性低血糖、夜间低血糖",
                           "         b.无法解释的高血糖，特别是空腹高血糖",
                           "         c.血糖波动大",
                           "         d.出于对低血糖的恐惧，刻意保持高血糖状态的患者",
                           "    (4)妊娠期糖尿病或糖尿病合并妊娠",
                           "    (5)患者教育",
                           "    (6)其他情况，如合并胃轻瘫的糖尿病患者、爆发性1型糖尿病患者以及特殊类型糖尿病患者等如病情需要也可进行CGM。",
                           "2.对于使用动态血糖监测服务的患者，本监测服务为收费项目",
                           "3.动态血糖监测可以完整记录患者佩戴期间的血糖变化趋势，但其测量血糖原理与采指血不同，所以，请及时输入指血值对仪器进行校正(推荐佩戴后第一个空腹血糖值)，便于动态血糖监测正常系统工作",
                           "4.本服务可用于患者的健康教育和生活方式指导，不能作为患者自行调整用药的依据！如需调整用药，必须在咨询医生后方可进行。",
                           "5.良好的糖尿病控制取决于医患双方的共同努力，请患者在佩戴期间，及时详细记录自己的饮食、运动、用药等情况。",
                           "6.动态血糖监测过程中，请注意保持探头的稳定，勿使探头脱出，否则可造成检查失败；如出现仪器报警，不能自行处理时，请联系检查医生/致电本公司(服务热线：4008-059-359)。佩戴结束后，如果数据不符合要求，可在与工作人员沟通后，决定是否再次佩戴以获取准确数据。",
                           "7.由于本监测系统价格昂贵，检查顺利结束后设备需返还。如有仪器丢失，需照价赔偿；如有损坏，请按维修费用赔偿。"]
    
    
    let threeSecionArray = ["1.一切移动客户端用户在下载并浏览APP手机APP软件时均被视为已经仔细阅读本条款并完全同意。凡以任何方式登陆本APP，或直接、间接使用本APP资料者，均被视为自愿接受本网站相关声明和用户服务协议的约束。",
                            "2、APP手机APP转载的内容并不代表APP手机APP之意见及观点，也不意味着本网赞同其观点或证实其内容的真实性。",
                            "3、APP手机APP转载的文字、图片、音视频等资料均由本APP用户提供，其真实性、准确性和合法性由信息发布人负责。APP手机APP不提供任何保证，并不承担任何法律责任。",
                            "4、APP手机APP所转载的文字、图片、音视频等资料，如果侵犯了第三方的知识产权或其他权利，责任由作者或转载者本人承担，本APP对此不承担责任。",
                            "5、APP手机APP不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该外部链接指向的不由APP手机APP实际控制的任何网页上的内容，APP手机APP不承担任何责任。",
                            "6、用户明确并同意其使用APP手机APP网络服务所存在的风险将完全由其本人承担；因其使用APP手机APP网络服务而产生的一切后果也由其本人承担，APP手机APP对此不承担任何责任。",
                            "7、除APP手机APP注明之服务条款外，其它因不当使用本APP而导致的任何意外、疏忽、合约毁坏、诽谤、版权或其他知识产权侵犯及其所造成的任何损失，APP手机APP概不负责，亦不承担任何法律责任。",
                            "8、对于因不可抗力或因黑客攻击、通讯线路中断等APP手机APP不能控制的原因造成的网络服务中断或其他缺陷，导致用户不能正常使用APP手机APP，APP手机APP不承担任何责任，但将尽力减少因此给用户造成的损失或影响。",
                            "9、本声明未涉及的问题请参见国家有关法律法规，当本声明与国家有关法律法规冲突时，以国家法律法规为准。",
                            "10、本网站相关声明版权及其修改权、更新权和最终解释权均属APP手机APP所有。"]
    
    
    
    
    
    
    
    
    
    
    
    
    
    var myTabView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.title = "用户协议"
        
        
        self.setNav()
        
        
        self.setMyTabView()
        
        
        
    }
    
    func setNav(){

        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(UserAgreementViewController.backAct), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
   
    }
    func backAct(){
        self.navigationController!.popViewController(animated: true)
    }
    
    func setMyTabView(){
        
        myTabView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width ,  height: UIScreen.main.bounds.height - 64), style: UITableViewStyle.grouped)
        
        myTabView?.backgroundColor = UIColor.white
        
        myTabView?.delegate = self
        myTabView?.dataSource = self
        
        myTabView?.separatorStyle = .none
        
        
        self.view.addSubview(myTabView!)
 
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titleArray.count
    }
    
    
    //tableview代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.oneSectionArray.count
        case 1:
            return self.towSectionArray.count
        case 2:
            return self.threeSecionArray.count
        default:
            return 0
        }

        
    }
    
    var uTitleCell: UTitleTableViewCell?
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if uTitleCell != nil {
            let labelText = uTitleCell?.uTextLabel.text
            
            let string:NSString = labelText! as NSString
            
            let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
            
            let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
            
            let brect = string.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 30, height: 0), options: [options,a], attributes:  [NSFontAttributeName:(uTitleCell?.uTextLabel.font)!], context: nil)
            
            return brect.height + (27 - 20)
        }else{
            return 27
        }
   
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
 
        let hei = self.getHeightForHeaderView(section)
 
        let headerView = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width ,height: hei))
        

        headerView.backgroundColor = UIColor().rgb(249, g: 249, b: 249, alpha: 1)
        
        let lab = UILabel(frame: CGRect(x: 10,y: 0,width: UIScreen.main.bounds.size.width - 10 * 2,height: hei))
        
        lab.text = self.titleArray[section]
        
        lab.numberOfLines = 0
        
        lab.textColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        lab.font = UIFont(name: PF_TC, size: 17)
        
        headerView.addSubview(lab)
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return self.getHeightForHeaderView(section)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let ddd = "UTitleCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ddd) as? UTitleTableViewCell
        if cell == nil
        {
            cell = Bundle.main.loadNibNamed("UTitleTableViewCell", owner: self, options: nil )?.last as? UTitleTableViewCell
            
        }
        //右边箭头
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        self.uTitleCell = cell
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            cell?.uTextLabel.text = self.oneSectionArray[(indexPath as NSIndexPath).row]
        case 1:
            cell?.uTextLabel.text = self.towSectionArray[(indexPath as NSIndexPath).row]
        case 2:
            cell?.uTextLabel.text = self.threeSecionArray[(indexPath as NSIndexPath).row]
        default:
            break
        }

        return cell!
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    func getHeightForHeaderView(_ section: Int) -> CGFloat{
        
        
        let labelText = self.titleArray[section]
        
        let string:NSString = labelText as NSString
        
        let options : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
        
        let a:NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading
        
        let brect = string.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 30, height: 0), options: [options,a], attributes:  [NSFontAttributeName:UIFont(name: PF_SC, size: 17)! ], context: nil)

        
        
        
        let hei = brect.height > 37.0 ? brect.height : 37

        return hei
    }
    

 

}





