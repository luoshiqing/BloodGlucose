//
//  ZJCustomCycleCell.swift
//  Lunbo
//
//  Created by sqluo on 16/6/16.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class ZJCustomCycleCell: UICollectionViewCell {
    
    
    var urlImage: String = ""
    var imageView = UIImageView()
    var labelTitle = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubviews(_ frame: CGRect){
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
//        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.contentView.addSubview(imageView)
        
        
        labelTitle = UILabel.init(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imageView.addSubview(labelTitle)
    }
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        // do you something
        
    }
    
    
    
    
  
    
    
}
