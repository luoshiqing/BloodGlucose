//
//  TakingPictureView.swift
//  BloodGlucose
//
//  Created by sqluo on 16/6/20.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit

class TakingPictureView: UIView ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    typealias TakingPictureClourse = (_ imgArray: [AnyObject])->Void
    var takingPictureClourse:TakingPictureClourse?
    
    var showImg = [AnyObject]()
    //是否是编辑状态
    var isEdit = false
    
    var subMedicCtr:UIViewController?
    
    var lishiImgViewArray = [UIImageView]() //历史现实的图片，用于释放
    
    var lishiBtnArray = [UIButton]()
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
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

        for index in 0..<self.showImg.count {

            if index == 0 {
                
                if self.showImg.count < 4 {
                    let imgView = UIImageView(frame: CGRect(x: 20 + (10 + 70) * CGFloat(self.showImg.count - 1), y: 10, width: 70, height: 70))
                    imgView.image = self.showImg[0] as? UIImage
                    
                    imgView.isUserInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: self, action: #selector(TakingPictureView.takingPictureAct(_:)))
                    imgView.addGestureRecognizer(tap)
                    self.addSubview(imgView)
                    
                    
                    lishiImgViewArray.append(imgView)
                }
                
                
            }else{
                let imgView = UIImageView(frame: CGRect(x: 20 + (10 + 70) * CGFloat(index - 1), y: 10, width: 70, height: 70))
                
                
                
                imgView.image = self.showImg[index] as? UIImage
          
                
                imgView.layer.cornerRadius = 3
                imgView.clipsToBounds = true
                
                self.addSubview(imgView)
                lishiImgViewArray.append(imgView)
                
                
//                let clearBtn = UIButton(frame: CGRect(x: 20 + (70 - 10) + CGFloat(index - 1) * (70 + 10) ,y: 4,width: 16,height: 16))
                
                
                let x: CGFloat = 20 + (70 - 10) + CGFloat(index - 1) * (70 + 10)

                
                let clearBtn = UIButton(frame: CGRect(x: x, y: 4, width: 16, height: 16))
                
                
                
                
                
                clearBtn.setBackgroundImage(UIImage(named: "eventDelet"), for: UIControlState())
                
                clearBtn.addTarget(self, action: #selector(TakingPictureView.clearBtnAct(_:)), for: UIControlEvents.touchUpInside)
                clearBtn.tag = index
                
                self.addSubview(clearBtn)
                lishiBtnArray.append(clearBtn)
            }
  
            
        }

        
    }
    func clearBtnAct(_ send: UIButton){
        
        let send = send.tag
        
        print(send)

        self.showImg.remove(at: tag)

        
        takingPictureClourse?(self.showImg)
        
        
        self.setNeedsDisplay()
        
    }
    
    var havaIsEdit = [Bool]()
    
    //MARK:初始化必须调用一次
    func initShowImg(_ index: Int){
        
        var tmpIndex = index
        
        if index < 4 {
            tmpIndex = index
        }else{
            tmpIndex = 3
        }
        
        for _ in 0...tmpIndex {
            let img:UIImage = UIImage(named: "eventPhto")!
            
            self.showImg.append(img)


        }

    }
    
    
    func takingPictureAct(_ send: UITapGestureRecognizer){
        
        let tag = send.view!.tag
        
        
        
        print("tag:\(tag)")
        
        let actionSheet = UIAlertController(title: "选择照片", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "拍照", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
            self.phtoAct()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "相册", style: UIAlertActionStyle.destructive, handler: { (act:UIAlertAction) in
            self.selecetPhto()
            
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        self.subMedicCtr!.present(actionSheet, animated: true, completion: nil)
        
        
        
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
        
        self.subMedicCtr!.dismiss(animated: false, completion: nil)
        
        let gotImg:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.phtoImage = gotImg
        
        
        self.showImg.append(gotImg)
        
        takingPictureClourse?(self.showImg)
        
        self.setNeedsDisplay()
        
    }
    
    
    //MARK:用于编辑时处理加载图片问题
    
    
    var isEditImgArray = [String]()
    
    func isEditSetTakingPictureView(_ urlArray: [String]){
        print(urlArray)
        isEditImgArray = urlArray
 
        
        
        
    }
    
    
    
    
    
    
    

}
