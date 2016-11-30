//
//  PicturesView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/8/19.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class PicturesView: UIView ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    
    typealias PicturesViewImgSecClourse = (_ imgArray: [AnyObject])->Void
    var imgSecClourse: PicturesViewImgSecClourse?
    
    var superCtr: UIViewController?

    let SRect = UIScreen.main.bounds.size
    
    
    let Wsize = (UIScreen.main.bounds.width - 30 - 30) / (375 - 60)
    
    //每张图片的尺寸
    var oneImgW: CGFloat = 70
    //图片之间的间距
    var imgToimgW: CGFloat = 10
    
    //左边距
    var toLeftW: CGFloat = 15
    
    //图片数量
    let pictNum = 4
    
    var imgViewArray = [UIImageView]()
    var clearnBtnArray = [UIButton]()
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        oneImgW = rect.height - 4
        
        let imgView = UIImageView(frame: CGRect(x: toLeftW , y: 4, width: oneImgW, height: oneImgW))
        
        imgView.image = UIImage(named: "eventPhto")
        
        imgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(PicturesView.someViewAct(_:)))
        imgView.addGestureRecognizer(tap)
        imgView.tag = 0
        
        self.addSubview(imgView)
        
 
        self.imgViewArray.append(imgView)
        
        self.reloadPicturesView(self.showImgArray)
    }
 
    
    
    func someViewAct(_ send: UITapGestureRecognizer){
        
        let actionSheet = UIAlertController(title: "选择照片", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "拍照", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
            self.phtoAct()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "相册", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
            self.selecetPhto()
            
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        self.superCtr?.present(actionSheet, animated: true, completion: nil)
        
        
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
        self.superCtr?.present(pickerC, animated: false) { () -> Void in
            
        }
    }

    var image = UIImagePickerController()
    
    //相册选取
    func selecetPhto(){
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        image.allowsEditing = true
        
        self.superCtr?.present(image, animated: false, completion: nil)
    }
    //相册代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: false, completion: nil)
        
        
        var image: UIImage!
        
        if picker.allowsEditing {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }

        
        self.showImgArray.append(image)
        
        
        self.imgSecClourse?(self.showImgArray)
        
        self.reloadPicturesView(self.showImgArray)
    }
    
    //未加载完成显示的图片名称
    var imgString = "loadlogo.png"
    //加载失败
    var imgFaild = "loading_failed"
    
    
    
    var showImgArray = [AnyObject]()
    
    func reloadPicturesView(_ imgArray: [AnyObject]){
       
        self.showImgArray = imgArray

        self.clearnHisView()

        for item in 0..<imgArray.count {
   
            let tmpImg = imgArray[item]
            
            let imgView = UIImageView(frame: CGRect(x: toLeftW + (imgToimgW + oneImgW) * CGFloat(item), y: 4, width: oneImgW, height: oneImgW))
            
            imgView.layer.cornerRadius = 4
            imgView.layer.masksToBounds = true
            
            if let img = tmpImg as? UIImage  {
                
                
                imgView.image = img
                
                
            }else if let imgStr = tmpImg as? String {
                

                let aaurl2 = imgStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
                
                let imgurl2:URL = URL(string: aaurl2!)!
                
                imgView.sd_setImage(with: imgurl2, placeholderImage: UIImage(named: self.imgString))
                
            }

            self.addSubview(imgView)

            self.imgViewArray.append(imgView)

            
            let x: CGFloat = toLeftW + oneImgW  * CGFloat(item + 1) + imgToimgW * CGFloat(item) - 8
            let clearBtn = UIButton(frame: CGRect(x: x, y: 0, width: 16, height: 16))
            
            
            clearBtn.setBackgroundImage(UIImage(named: "eventDelet"), for: UIControlState())
            
            clearBtn.addTarget(self, action: #selector(PicturesView.someBtnAct(_:)), for: UIControlEvents.touchUpInside)
            clearBtn.tag = item
            
            self.addSubview(clearBtn)
            
            self.clearnBtnArray.append(clearBtn)
    
        }
        
        if imgArray.count < self.pictNum {
            
            let imgView = UIImageView(frame: CGRect(x: toLeftW + (imgToimgW + oneImgW) * CGFloat(imgArray.count), y: 4, width: oneImgW, height: oneImgW))
            
            imgView.image = UIImage(named: "eventPhto")
            
            imgView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(PicturesView.someViewAct(_:)))
            imgView.addGestureRecognizer(tap)
            imgView.tag = 0
            
            self.addSubview(imgView)
            
            self.imgViewArray.append(imgView)
        }
        
  
    }
    
    
    
    
    func someBtnAct(_ send: UIButton){
 
        self.showImgArray.remove(at: send.tag)

        
        self.imgSecClourse?(self.showImgArray)
        
        self.reloadPicturesView(self.showImgArray)
    }
    
    
    //清除历史视图
    func clearnHisView(){
        
        for imgView in self.imgViewArray {
            imgView.removeFromSuperview()
        }
        self.imgViewArray.removeAll()
        
        for item in self.clearnBtnArray {
            item.removeFromSuperview()
        }
        self.clearnBtnArray.removeAll()
        
        
    }
    
    
    

}
