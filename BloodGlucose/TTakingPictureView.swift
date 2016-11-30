//
//  TTakingPictureView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/21.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class TTakingPictureView: UIView ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    typealias TakingPictureClourse = (_ imgArray: [AnyObject])->Void
    var takingPictureClourse:TakingPictureClourse?
    
    
    
    var calculateAndUploadQueue = DispatchQueue(label: "com.nashsu.cc", attributes: [])
    
    
    
    //显示的最多张图
    var showImgArray = [AnyObject]()
    
    //记录历史视图
    var lishiImgViewArray = [UIImageView]() //历史现实的图片，用于释放
    var lishiBtnArray = [UIButton]()
    
    
    var subMedicCtr:UIViewController?
    
    override func draw(_ rect: CGRect) {
        
        if !self.lishiImgViewArray.isEmpty {
            
            for item in self.lishiImgViewArray {
                item.removeFromSuperview()
            }
            
            self.lishiImgViewArray.removeAll()
            
        }
        if !self.lishiBtnArray.isEmpty {
            for item in self.lishiBtnArray {
                item.removeFromSuperview()
            }
        }

        for index in 0..<showImgArray.count {
            
            
            if index == 0 {
                if showImgArray.count < 4 {
                    let imgView = UIImageView(frame: CGRect(x: 20 + (10 + 70) * CGFloat(showImgArray.count - 1), y: 10, width: 70, height: 70))
                    imgView.image = UIImage(named: "eventPhto")
                    
                    imgView.isUserInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: self, action: #selector(TakingPictureView.takingPictureAct(_:)))
                    imgView.addGestureRecognizer(tap)
                    self.addSubview(imgView)
                    
                    lishiImgViewArray.append(imgView)
                }

            }else{
                
                let imgView = UIImageView(frame: CGRect(x: 20 + (10 + 70) * CGFloat(index - 1), y: 10, width: 70, height: 70))
                
                if let tmpImg = self.showImgArray[index] as? String{
                    
                    
                    let imgurl:URL = URL(string: tmpImg)!
                    imgView.sd_setImage(with: imgurl, placeholderImage: UIImage(named: "loadlogo.png"))
                    
                    calculateAndUploadQueue.async(execute: { () -> Void in
                        
                        let data = try? Data(contentsOf: imgurl)
                        
                        let tmpImg:UIImage = UIImage(data: data!)!
                        self.showImgArray[index] = tmpImg
                        
                    })
                    

                    
                }else if let tmpImg = self.showImgArray[index] as? UIImage{
                    
                    imgView.image = tmpImg

                }else{
                    print("格式错误")
                    imgView.image = UIImage(named: "eventPhto")
                }

                imgView.layer.cornerRadius = 3
                imgView.clipsToBounds = true
                self.addSubview(imgView)

                
                let x: CGFloat = 20 + (70 - 10) + CGFloat(index - 1) * (70 + 10)
                let clearBtn = UIButton(frame: CGRect(x: x, y: 4, width: 16, height: 16))
                
                
                clearBtn.setBackgroundImage(UIImage(named: "eventDelet"), for: UIControlState())
                
                clearBtn.addTarget(self, action: #selector(TakingPictureView.clearBtnAct(_:)), for: UIControlEvents.touchUpInside)
                clearBtn.tag = index
                
                self.addSubview(clearBtn)
                
                lishiImgViewArray.append(imgView)
                lishiBtnArray.append(clearBtn)
            }
            
     
            
        }
   
    }
    func initTTView(_ imgDataArray: [String]){
        
        let img = UIImage(named: "eventPhto")!
        self.showImgArray.append(img)
        
        for index in 0..<imgDataArray.count {

            self.showImgArray.append("\(imgDataArray[index])" as AnyObject)
        }
    }
    
    func clearBtnAct(_ send: UIButton){
        
        let tag = send.tag
        print(tag)
        
        self.showImgArray.remove(at: tag)

        self.setNeedsDisplay()
  


        takingPictureClourse?(self.showImgArray)
        
    }
    
    func takingPictureAct(_ send: UITapGestureRecognizer){
        print("++++点击加")
        
        
        
        let actionSheet = UIAlertController(title: "选择照片", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "拍照", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
            self.phtoAct()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "相册", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
            self.selecetPhto()
            
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        if self.subMedicCtr != nil{
            self.subMedicCtr!.present(actionSheet, animated: true, completion: nil)
        }
        
        
  
        
//        self.showImgArray.append("5")
//        self.setNeedsDisplay()
        
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
        self.subMedicCtr!.present(pickerC, animated: false) { () -> Void in
            
        }
    }
    //拍照的照片
    var phtoImage:UIImage!
    var image = UIImagePickerController()
    
    //相册选取
    func selecetPhto(){
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        image.allowsEditing = true
        
        self.subMedicCtr!.present(image, animated: false, completion: nil)
    }
    
    //MARK:保存选择的照片数组
    var mySelectImgArray = [UIImage]()
    
    //相册代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        

        picker.dismiss(animated: false, completion: nil)
        
        
        var image: UIImage!
        
        if picker.allowsEditing {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        
        
        self.phtoImage = image
        
        
        self.showImgArray.append(image)
        

        
//        var clourseImgArray = [AnyObject]()
//        for index in 0..<self.showImgArray.count {
//            
//            if index != 0 {
//                clourseImgArray.append(self.showImgArray[index])
//            }
// 
//        }
        
        
        
        takingPictureClourse?(self.showImgArray)
        
        self.setNeedsDisplay()
        
    }
    
    
    
    
    
    
    
}
