//
//  HomeWebViewController.swift
//  BloodGlucose
//
//  Created by sqluo on 16/5/20.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class HomeWebViewController: UIViewController ,UIWebViewDelegate {

    
    var webView: UIWebView!
    var url:String!
    var webTitle:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.white
        
        
        if self.webTitle != nil {
            self.title = self.webTitle
        }

        //左
        let (leftBtn,spacer,backItem) = BGNetwork().creatBackBtn()
        leftBtn.addTarget(self, action: #selector(HomeWebViewController.naviBackAction), for: UIControlEvents.touchUpInside)
        leftBtn.tag = 0
        self.navigationItem.leftBarButtonItems = [spacer,backItem]

        
        let webFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)

        self.webView = UIWebView(frame: webFrame)
        
        self.webView.backgroundColor = UIColor.white
        
        self.webView.delegate = self
        
        self.view.addSubview(self.webView)
        
        if url != nil{
            //转译
            let aaurl2 = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)

            self.webView.loadRequest(URLRequest(url: URL(string: aaurl2!)!))
            
        }
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        BaseTabBarView.isHidden = true
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
    }

    
    func naviBackAction(){

        if self.webView.canGoBack {
            self.webView.goBack()
        }else{
            self.navigationController!.popViewController(animated: true)
        }
        
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let textName = webView.stringByEvaluatingJavaScript(from: "document.title")
        print("标题：\(textName)")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
