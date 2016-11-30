//
//  BloodSugarModel.h
//  BloodSugar
//
//  Created by 虞政凯 on 15/11/17.
//  Copyright © 2015年 虞政凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodSugarModel : NSObject

@property(nonatomic,copy)NSString * current; //电流
@property(nonatomic,copy)NSString * glucose; //血糖
@property(nonatomic,copy)NSString * recordDate; //记录时间
@property(nonatomic,copy)NSString * sessionID;//设备id
@property(nonatomic,copy)NSString * timeStamp;//时间戳
@property(nonatomic,copy)NSString * identifier;//...
@end
