//
//  DrugFootView.swift
//  BloodGlucose
//
//  Created by sqluo on 2016/10/17.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class DrugFootView: UIView ,UITextViewDelegate{

    typealias DrugFootViewTextViewClourse = (_ textValue : String)->Void
    var drugTextViewClourse: DrugFootViewTextViewClourse?
    
    typealias DrugFootViewImgDicClourse = (_ imgDic: [String:String])->Void
    var drugImgDicClourse: DrugFootViewImgDicClourse?
    
    
    fileprivate var tpictrueView:TTakingPictureView?
    
    var drugCrt: UIViewController?
    
    fileprivate var myHeight: CGFloat = 90
    
    fileprivate var myTextView: UITextView?
    
    
    var imgArray = [String]() //图片数组url
    
    var textValue = ""
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.loadTpictrueView(rect)
    
        self.loadTextView()
    }
 
    
    fileprivate func loadTpictrueView(_ rect: CGRect){
        
        tpictrueView = TTakingPictureView(frame: CGRect(x: 0,y: 0,width: rect.width ,height: self.myHeight))
        tpictrueView?.backgroundColor = UIColor.white
        
        
        tpictrueView?.initTTView(self.imgArray)
        
        tpictrueView?.subMedicCtr = self.drugCrt
        
        tpictrueView?.takingPictureClourse = self.takingPictureClourse
        
//        if !self.imgArray.isEmpty {
//            tpictrueView?.initTTView(self.imgArray)
//        }

        
        self.addSubview(tpictrueView!)
    }
    
    
    //MARK:图片选择回调
    func takingPictureClourse(_ imgArray: [AnyObject])->Void{
        
        print(imgArray)

        var upImgDic = [String:String]()
        
        for index in 0..<imgArray.count {
            if index != 0 {
                if let img = imgArray[index] as? UIImage{
                    
                    let imgData = UIImageJPEGRepresentation(img, 0.005)
                    let base64Data:String = (imgData! as NSData).base64EncodedString()
                    
                    if index == 1 {
                        upImgDic["imgurl"] = base64Data
                        
                    }else{
                        upImgDic["imgurl\(index - 1)"] = base64Data
                    }
                    
                }else if let img = imgArray[index] as? String {
                    
                    if index == 1 {
                        upImgDic["imgurl"] = img
                        
                    }else{
                        upImgDic["imgurl\(index - 1)"] = img
                    }
                }
            }
            
        }
        
        self.drugImgDicClourse?(upImgDic)

    }
    
    fileprivate func loadTextView(){
        
        let x: CGFloat = 20.0
        let y: CGFloat = self.myHeight + 5.0
        let w: CGFloat = UIScreen.main.bounds.width - 2 * x
        let h: CGFloat = 80.0
        myTextView = UITextView(frame: CGRect(x: x, y: y, width: w, height: h))
        
        myTextView?.delegate = self
        
        myTextView?.backgroundColor = UIColor.white
        
        if !self.textValue.isEmpty {
            self.myTextView?.text = self.textValue
        }else{
            self.myTextView?.text = "添加描述，比如：是否使用了胰岛素..."
        }
        
        myTextView?.font = UIFont.systemFont(ofSize: 15)
        
        myTextView?.textColor = UIColor().rgb(177, g: 177, b: 177, alpha: 1)
        
        self.addSubview(myTextView!)
 
    }
    

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        if textView.text.characters.count == 0 {
            textView.text = "添加描述，比如：是否使用了胰岛素..."
            self.drugTextViewClourse?("")
        }else{
            
            self.drugTextViewClourse?(textView.text)
        }
   
    }
    
    
    
    func setTextView(value: String){
        self.myTextView?.text = value
    }
    
    

}
