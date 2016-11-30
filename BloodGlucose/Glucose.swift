//
//  Glucose.swift
//  
//
//  Created by 吾久IOS on 6/2/15.
//
//

import Foundation
import CoreData

@objc(Glucose)

class Glucose: NSManagedObject {

    @NSManaged var glucose: NSNumber
    @NSManaged var id: String
    @NSManaged var electric: NSNumber
    @NSManaged var recordDate: String
    @NSManaged var sid: String
    @NSManaged var timestamp: NSNumber
    


}
