//
//  RequestBase.h
//  BlueTooth
//
//  Created by 吾久 on 15/12/2.
//  Copyright © 2015年 吾久. All rights reserved.
//
#import "sys/utsname.h"
#import <Foundation/Foundation.h>

@interface RequestBase : NSObject


-(void)doPost:(NSString *)url :(NSDictionary *)dict success:(void(^)(id data))success failure:(void(^)())failue;
-(void)doGet:(NSString *)url :(NSDictionary *)dict success:(void(^)(NSDictionary * dict))success failure:(void(^)())failue;


-(void)doFormData:(NSString *)url :(NSDictionary *)dict :(NSArray *)imgData success:(void(^)(id data))success failure:(void(^)())failue;



-(NSString *)deviceVersion;

-(void)shareSDKShow:(NSString *)text :(NSString *)url :(NSString *)title;



@end
