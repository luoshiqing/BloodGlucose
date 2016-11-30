//
//  FingerBloodListView.swift
//  BloodGlucoseHospital
//
//  Created by nash_su on 7/25/15.
//  Copyright (c) 2015 Sqluo. All rights reserved.
//

import UIKit


protocol FingerBloodListViewDelegate{
    func addFingerBloodBtnClicked()
    func completeFingerBloodSubmit()
    func closeView()
    
    
}

class FingerBloodListView: UIView {

    @IBOutlet var view: UIView!
    
    
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var addFingerBloodBtn: UIButton!
    
    
    
    @IBOutlet weak var explainBtn: UIButton!
    
    @IBOutlet weak var explainView: UIView!
    
    
    
    
    
    var delegate:FingerBloodListViewDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSetup()
    }
    
    func initSetup(){
        Bundle.main.loadNibNamed("FingerBloodListView", owner: self, options: nil)
        
        self.addSubview(self.view)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view":view]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view":view]))
        
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        
        self.submitBtn.layer.cornerRadius = 4.0
        self.submitBtn.layer.masksToBounds = true
        
        self.submitBtn.addTarget(self, action: #selector(FingerBloodListView.submitAction), for: UIControlEvents.touchUpInside)
    }
    
    
    func submitAction(){
        self.delegate.completeFingerBloodSubmit()
    }
    
    @IBAction func addFingerBloodBtnAction(_ sender: AnyObject) {
        self.delegate.addFingerBloodBtnClicked()
    }
    
    
    
    @IBAction func closeBtnAct(_ sender: AnyObject) {
        self.delegate.closeView()
        
    }
    
    @IBAction func explainAct(_ sender: AnyObject) {
        
        if (self.explainView.isHidden == false){
            self.explainView.isHidden = true
        }else{
            self.explainView.isHidden = false
        }
        
    }
    

}
