//
//  DSHabitsTableViewCell.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 16/1/28.
//  Copyright © 2016年 nash_su. All rights reserved.
//

import UIKit


protocol DSHabitsCellDelegate{
    func viewAct(_ view:UIView)
}

class DSHabitsTableViewCell: UITableViewCell {

    var DSHabitsDelegate:DSHabitsCellDelegate!
    
    @IBOutlet weak var titileLabel: UILabel!
    
    @IBOutlet weak var titileTF: UITextField!
    
    @IBOutlet weak var titileLastLb: UILabel!

    
    @IBOutlet weak var titile1Label: UILabel!
    
    @IBOutlet weak var titile1TF: UITextField!
    
    @IBOutlet weak var titile1LastLb: UILabel!
    
    

    
    @IBOutlet weak var selectView: UIView!
    

    
    @IBOutlet weak var sec1View: UIView!
    @IBOutlet weak var sec1Img: UIImageView!
    @IBOutlet weak var sec1Label: UILabel!
    
    
    
    @IBOutlet weak var sec2View: UIView!
    @IBOutlet weak var sec2Img: UIImageView!
    @IBOutlet weak var sec2Label: UILabel!
    
    
    @IBOutlet weak var sec3View: UIView!
    @IBOutlet weak var sec3Img: UIImageView!
    @IBOutlet weak var sec3Label: UILabel!
    
    
    @IBOutlet weak var sec4View: UIView!
    @IBOutlet weak var sec4Img: UIImageView!
    @IBOutlet weak var sec4Label: UILabel!
    
    @IBOutlet weak var sec5View: UIView!
    @IBOutlet weak var sec5Img: UIImageView!
    @IBOutlet weak var sec5Label: UILabel!
    
    
    var v1State:Bool = true
    var v2State:Bool = true
    var v3State:Bool = true
    var v4State:Bool = true
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DSHabitsTableViewCell.tap1(_:)))
        self.sec1View.addGestureRecognizer(tap1)

        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(DSHabitsTableViewCell.tap2(_:)))
        self.sec2View.addGestureRecognizer(tap2)

        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(DSHabitsTableViewCell.tap3(_:)))
        self.sec3View.addGestureRecognizer(tap3)

        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(DSHabitsTableViewCell.tap4(_:)))
        self.sec4View.addGestureRecognizer(tap4)

   
        
    }

    func tap1(_ send:UITapGestureRecognizer){
        self.DSHabitsDelegate.viewAct(sec1View)
        
        if (v1State == true){
            self.sec1Img.image = UIImage(named: "dian1.png")
            v1State = false
            
            self.sec2Img.image = UIImage(named: "dian2.png")
            self.sec3Img.image = UIImage(named: "dian2.png")
            self.sec4Img.image = UIImage(named: "dian2.png")
            v2State = true
            v3State = true
            v4State = true
            
        }else{
            self.sec1Img.image = UIImage(named: "dian2.png")
            v1State = true
        }
    }
    func tap2(_ send:UITapGestureRecognizer){
        self.DSHabitsDelegate.viewAct(sec2View)
        if (v2State == true){
            self.sec2Img.image = UIImage(named: "dian1.png")
            v2State = false
            
            self.sec1Img.image = UIImage(named: "dian2.png")
            self.sec3Img.image = UIImage(named: "dian2.png")
            self.sec4Img.image = UIImage(named: "dian2.png")
            
            v1State = true
            v3State = true
            v4State = true
        }else{
            self.sec2Img.image = UIImage(named: "dian2.png")
            v2State = true
        }
    }
    func tap3(_ send:UITapGestureRecognizer){
        self.DSHabitsDelegate.viewAct(sec3View)
        if (v3State == true){
            self.sec3Img.image = UIImage(named: "dian1.png")
            v3State = false
            
            
            self.sec1Img.image = UIImage(named: "dian2.png")
            self.sec2Img.image = UIImage(named: "dian2.png")
            self.sec4Img.image = UIImage(named: "dian2.png")
            
            v1State = true
            v2State = true
            v4State = true
            
        }else{
            self.sec3Img.image = UIImage(named: "dian2.png")
            v3State = true
        }
    }
    func tap4(_ send:UITapGestureRecognizer){
        self.DSHabitsDelegate.viewAct(sec4View)
        if (v4State == true){
            self.sec4Img.image = UIImage(named: "dian1.png")
            v4State = false
            
            self.sec1Img.image = UIImage(named: "dian2.png")
            self.sec2Img.image = UIImage(named: "dian2.png")
            self.sec3Img.image = UIImage(named: "dian2.png")
            
            v1State = true
            v2State = true
            v3State = true
        }else{
            self.sec4Img.image = UIImage(named: "dian2.png")
            v4State = true
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
