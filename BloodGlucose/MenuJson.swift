//
//  MenuJson.swift
//  BloodGlucose
//
//  Created by 吾久IOS on 15/12/3.
//  Copyright © 2015年 nash_su. All rights reserved.
//

import UIKit

let aaa:String = "http://192.168.1.4:8089"


let MENU_HTTP:String = "http://192.168.1.4:8089"


let KEY:String = "32154lkjdfidfaifjjAJDFKJKFOIPPQ13oiu45poipiadlkjflkajfd13434980DFQPQPZDaqNL0986fdqqpc"
let RandoM:String = "wujiu9595955"




class MenuJson: NSObject {
    

}








extension String  {
    
    //MD5加密（小写32位）
    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate(capacity: digestLen)
        return String(format: hash as String)
    }
}
