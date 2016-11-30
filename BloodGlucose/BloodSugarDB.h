//
//  BloodSugarDB.h
//  BloodSugar
//
//  Created by 虞政凯 on 15/11/17.
//  Copyright © 2015年 虞政凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "BloodSugarModel.h"


#define BLOODSUGARDB    @"bloodSugarDB.db"
#define BLOODSUGARTABLE @"bloodSugarTable"
#define CURRENT         @"current"
#define GLUCOSE         @"glucose"
#define RECORDDATE      @"recordDate"
#define SESSIONID       @"sessionID"
#define TIMESTAMP       @"timeStamp"
#define IDENTIFIER      @"identifier"


@interface BloodSugarDB : NSObject

//创建表
-(void)createBloodSugarTable;

//增加
-(void)insertBloodSugarModel:(BloodSugarModel *)bloodSugarModel withInserFinishBlock:(void(^)())finish;

//批量插入
-(void)batchInsertData:(NSArray *)datas withBatchInserFinishBlock:(void(^)())finish;

//删除
-(void)deleteBloodSugar;

//查找
-(NSMutableArray *)selectBloodSugarModel:(BloodSugarModel *)bloodSugarModel;

//查询所有
-(NSMutableArray *)selectAll;

//查询数据库中有多少条数据
-(NSInteger) selectAllDataCount;

//更新血糖数据根据时间
-(void)updateGlucose:(NSString *)glucose withTimesp:(NSString *)timer;


@end
