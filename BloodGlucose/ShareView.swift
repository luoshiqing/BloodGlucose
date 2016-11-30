//
//  ShareView.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/3/2.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit


protocol MyShareDelegate{
    func shareAction(_ tag:Int)
}


class ShareView: UIView {
    
    var delegate: MyShareDelegate!
    
    @IBOutlet weak var bjView: UIView!
    
    @IBOutlet weak var canceBtn: UIButton!
    
    @IBOutlet weak var weixinBtn: UIButton!
    
    @IBOutlet weak var pengyouquanBtn: UIButton!
    
    @IBOutlet weak var qqBtn: UIButton!
    
    @IBOutlet weak var xinlangBtn: UIButton!
    
    
    
    
    @IBOutlet weak var weixinW: NSLayoutConstraint!//54
    @IBOutlet weak var weixinH: NSLayoutConstraint!
    
    @IBOutlet weak var pengyqW: NSLayoutConstraint!
    @IBOutlet weak var pengyqH: NSLayoutConstraint!
    
    @IBOutlet weak var qqW: NSLayoutConstraint!
    @IBOutlet weak var qqH: NSLayoutConstraint!
    
    @IBOutlet weak var xinlangW: NSLayoutConstraint!
    @IBOutlet weak var xinlangH: NSLayoutConstraint!
    

    @IBOutlet weak var WXToLeft: NSLayoutConstraint!//21
    @IBOutlet weak var PYQToLeft: NSLayoutConstraint!
    @IBOutlet weak var QQToLeft: NSLayoutConstraint!
    @IBOutlet weak var XLToLeft: NSLayoutConstraint!
    
    
    @IBOutlet weak var WXToDown: NSLayoutConstraint!//4
    
    
    @IBOutlet weak var WXLabelH: NSLayoutConstraint!//18
    @IBOutlet weak var WXLabelW: NSLayoutConstraint!//42
    
    @IBOutlet weak var PYQLabelW: NSLayoutConstraint!//42
    @IBOutlet weak var PYQLabelH: NSLayoutConstraint!//18
    
    @IBOutlet weak var QQLabelW: NSLayoutConstraint!
    @IBOutlet weak var QQLabelH: NSLayoutConstraint!
    
    @IBOutlet weak var XLLabelW: NSLayoutConstraint!
    @IBOutlet weak var XLLabelH: NSLayoutConstraint!
    
    
    @IBOutlet weak var WXLabelToDown: NSLayoutConstraint!//13
    
    
    
    @IBOutlet weak var btnH: NSLayoutConstraint!//44
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        initSetup()
        
    }
    
    func initSetup(){
        
        self.canceBtn.addTarget(self, action: #selector(self.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.canceBtn.tag = 0
        
        self.weixinBtn.addTarget(self, action: #selector(self.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.weixinBtn.tag = 1
        
        self.pengyouquanBtn.addTarget(self, action: #selector(self.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.pengyouquanBtn.tag = 2
        
        self.qqBtn.addTarget(self, action: #selector(self.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.qqBtn.tag = 3
        
        self.xinlangBtn.addTarget(self, action: #selector(self.btnAct(_:)), for: UIControlEvents.touchUpInside)
        self.xinlangBtn.tag = 4
        
        let Hsize = self.frame.size.height / 169
        let Wsize = self.frame.size.width / 320
        
        weixinW.constant = Wsize * 54
        weixinH.constant = Wsize * 54
        pengyqW.constant = Wsize * 54
        pengyqH.constant = Wsize * 54
        qqW.constant = Wsize * 54
        qqH.constant = Wsize * 54
        xinlangW.constant = Wsize * 54
        xinlangH.constant = Wsize * 54
        
        WXToLeft.constant = Wsize * 21
        PYQToLeft.constant = Wsize * 21
        QQToLeft.constant = Wsize * 21
        XLToLeft.constant = Wsize * 21
        
        WXToDown.constant = Hsize * 4
        
        WXLabelH.constant = Wsize * 18
        WXLabelW.constant = Wsize * 42
        PYQLabelW.constant = Wsize * 42
        PYQLabelH.constant = Wsize * 18
        QQLabelW.constant = Wsize * 42
        QQLabelH.constant = Wsize * 18
        XLLabelW.constant = Wsize * 42
        XLLabelH.constant = Wsize * 18
        
        WXLabelToDown.constant = Hsize * 13
        btnH.constant = Hsize * 44
    }

    func btnAct(_ btn:UIButton){
        self.delegate.shareAction(btn.tag)
    }
    
    
    
    
}
