//
//  LLCommentViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/29.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class LLCommentViewController: UIViewController ,UITextViewDelegate{
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    typealias LLCommentViewControllerClourse = (_ value: String)->Void
    var llcommentClourse:LLCommentViewControllerClourse?
    
    
    @IBOutlet weak var myTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "编辑评论"
        
        self.setNav()
        
        self.myTextView.delegate = self
        
        
    }

    
    fileprivate func setNav(){
        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]
        
        //右
        let (rightBtn,rightSpacer,rightItem) = BGNetwork().creatRightBtnAtt(false, title: "发表")
        rightBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
        rightBtn.tag = 1
        self.navigationItem.rightBarButtonItems = [rightSpacer,rightItem]
 
        
    }
    
    func someBtnAct(_ send: UIButton){
        let tag = send.tag
        print(tag)
        
        switch tag {
        case 0:
            if !self.textViewIsFirstEdit {
                let actionSheet = UIAlertController(title: "是否退出本次编辑", message: "", preferredStyle: UIAlertControllerStyle.alert)
                actionSheet.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
                    self.myTextView.resignFirstResponder()
                    self.navigationController!.popViewController(animated: true)
                    
                }))
                actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
            }else{
                self.navigationController!.popViewController(animated: true)
            }
 
        case 1:

            self.myTextView.resignFirstResponder()
            
            if self.textViewIsFirstEdit {
                print("没有输入文字")
                
                let alrte = UIAlertView(title: "还没有输入文字", message: "", delegate: nil, cancelButtonTitle: "确定")
                alrte.show()

            }else{
                
                llcommentClourse?(self.myTextView.text)
                self.navigationController!.popViewController(animated: true)
            }
  
            
        default:
            break
        }
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //MARK:是否为首次编辑，编辑模式应该要除外
    var textViewIsFirstEdit = true
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        if self.textViewIsFirstEdit {
            textView.text = ""
            textViewIsFirstEdit = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        if textView.text.isEmpty {
            textView.text = "快来发表你的评论吧~"
            self.textViewIsFirstEdit = true
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
