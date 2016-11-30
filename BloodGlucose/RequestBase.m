//
//  RequestBase.m
//  BlueTooth
//
//  Created by 吾久 on 15/12/2.
//  Copyright © 2015年 吾久. All rights reserved.
//

#import "RequestBase.h"

#import "AFHTTPRequestOperationManager.h"
#import "AFSecurityPolicy.h"



#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


@implementation RequestBase

-(void)doPost:(NSString *)url :(NSDictionary *)dict success:(void(^)(id data))success failure:(void(^)())failue

{
    AFHTTPRequestOperationManager * manager = [self createManager];
    
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * operation, id responseObject) {
        success(operation.responseData);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failue();
    }];
}


-(void)doFormData:(NSString *)url :(NSDictionary *)dict :(NSArray *)imgData success:(void(^)(id data))success failure:(void(^)())failue{
    
    AFHTTPRequestOperationManager * manager = [self createManager];
    
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        for(int i = 0; i < imgData.count; i++)
        {
            NSData * imageData = [imgData objectAtIndex: i];
            // 上传的参数名
            NSString * Name = [NSString stringWithFormat:@"Img%d",i+1];
            // 上传filename
            NSString * fileName = [NSString stringWithFormat:@"%@.jpg", Name];
            [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:@"image/jpeg"];
            
            
        }
   
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation.responseData);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failue();
    }];
    
    
    
}






-(void)doGet:(NSString *)url :(NSDictionary *)dict success:(void(^)(NSDictionary * dict))success failure:(void(^)())failue
{
   
    AFHTTPRequestOperationManager * manager = [self createManager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        success(dict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failue();
    }];
}

-(AFHTTPRequestOperationManager *)createManager
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20.0;
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return manager;
}






-(NSString *)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //CLog(@"%@",deviceString);
    
   
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"]||[deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"]||[deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"]||[deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])   return @"iPhone 6S Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,1"]||[deviceString isEqualToString:@"iPad4,2"]||[deviceString isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"]||[deviceString isEqualToString:@"iPad4,5"]||[deviceString isEqualToString:@"iPad4,6"])   return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    //CLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;
}



-(void)shareSDKShow:(NSString *)text :(NSString *)url :(NSString *)title{
    NSArray* imageArray = @[[UIImage imageNamed:@"yltlog.png"]];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:imageArray
                                        url:[NSURL URLWithString:url]
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
               }];
    
    
    
    
    
    
}






@end
