//
//  BloodSugarDB.m
//  BloodSugar
//
//  Created by 虞政凯 on 15/11/17.
//  Copyright © 2015年 虞政凯. All rights reserved.
//

#import "BloodSugarDB.h"

@implementation BloodSugarDB
{
    FMDatabase * database;
    NSString   * path;
}

-(BOOL)openDB
{
    path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:BLOODSUGARDB];
    database = [FMDatabase databaseWithPath:path];
    if (!database.open)
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    else
    {
        NSLog(@"数据库打开成功");
        return YES;
    }
}
//创建表
-(void)createBloodSugarTable{

    NSString * sqlString = [NSString stringWithFormat:@"create table if not exists %@ (%@ text,%@ text,%@ text)",BLOODSUGARTABLE,CURRENT,TIMESTAMP,GLUCOSE];
    if (![database executeUpdate:sqlString]){

        NSLog(@"创建失败");
    }else{
        NSLog(@"创建成功");
    }
}

//对比时间如果没有才需要插入数据库
-(BOOL)contrastTime:(NSString *)timesp
{

    NSString * sqlString = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'",BLOODSUGARTABLE,TIMESTAMP,timesp];
    
    FMResultSet * resultSet = [database executeQueryWithFormat:sqlString,nil];
    int i = 0;
    while (resultSet.next)
    {
        i++;
    }
    if(i)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//插入
-(void)insertBloodSugarModel:(BloodSugarModel *)bloodSugarModel withInserFinishBlock:(void(^)())finish
{
    if(![self openDB])
    {
        return;
    }
    [self createBloodSugarTable];
    
    if(![self contrastTime:bloodSugarModel.timeStamp])
    {
        NSString * sqlString = [NSString stringWithFormat:@"insert into %@ values (?,?,?)",BLOODSUGARTABLE];
        NSString * glucose;
        
        if (bloodSugarModel.glucose == nil)
        {
            glucose = @"0";
        }
        else
        {
            glucose = bloodSugarModel.glucose;
        }
        BOOL result = [database executeUpdate:sqlString,
                       bloodSugarModel.current,
                       bloodSugarModel.timeStamp,
                       glucose
                       ];
        
        
        if(!result)
        {
            NSLog(@"插入失败");
        }
        else
        {
            NSLog(@"插入成功");
            finish();
        }
    }
    else
    {
        //时间已经存在
        NSLog(@"时间已经存在不需要插入");
        return;
    }
    [database close];

}
//批量插入数据

-(void)batchInsertData:(NSArray *)datas withBatchInserFinishBlock:(void(^)())finish
{
    if(![self openDB])
    {
        return;
    }
    [self createBloodSugarTable];
    
    NSMutableArray * temps = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < datas.count; i++)
    {
        BloodSugarModel * model = datas[i];
        
        if (![self contrastTime:model.timeStamp])
        {
            [temps addObject:model];
        }
    }
    
    [database beginTransaction];
    
    BOOL isRollBack = NO;
    @try
    {
        for (int i = 0; i < temps.count; i++)
        {
            BloodSugarModel * model = temps[i];
            
            NSString * sqlString = [NSString stringWithFormat:@"insert into %@ values (?,?,?)",BLOODSUGARTABLE];
            NSString * glucose;
            
            if (model.glucose == nil)
            {
                glucose = @"0";
            }
            else
            {
                glucose = model.glucose;
            }
            
            BOOL result = [database executeUpdate:sqlString,
                           model.current,
                           model.timeStamp,
                           glucose
                           ];
            if(!result)
            {
                NSLog(@"批量插入失败");
            }
            else
            {
//                NSLog(@"批量插入成功");
                if (i == temps.count-1)
                {
                    finish();
                }
            }
        }

    }
    @catch (NSException *exception)
    {
        isRollBack = YES;
    }
    @finally
    {
        if (!isRollBack)
        {
            [database commit];
        }
    }
    [database close];
    
}


/*
-(void)batchInsertData:(NSArray *)datas withBatchInserFinishBlock:(void(^)())finish
{
    if(![self openDB])
    {
        return;
    }
    [self createBloodSugarTable];
    
    NSMutableArray * temps = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < datas.count; i++)
    {
        BloodSugarModel * model = datas[i];
        
        if (![self contrastTime:model.timeStamp])
        {
            [temps addObject:model];
        }
    }
    
    for (int i = 0; i < temps.count; i++)
    {
        BloodSugarModel * model = temps[i];
        
        NSString * sqlString = [NSString stringWithFormat:@"insert into %@ values (?,?,?)",BLOODSUGARTABLE];
        NSString * glucose;
        
        if (model.glucose == nil)
        {
            glucose = @"0";
        }
        else
        {
            glucose = model.glucose;
        }
        
        BOOL result = [database executeUpdate:sqlString,
                       model.current,
                       model.timeStamp,
                       glucose
                       ];
        if(!result)
        {
            NSLog(@"批量插入失败");
        }
        else
        {
            NSLog(@"批量插入成功");
           if (i == temps.count-1)
           {
               finish();
           }
        }
    }
    [database close];
}
*/

//删除
-(void)deleteBloodSugar
{
    if (![self openDB])
    {
        return;
    }
    
    NSString * sqlString = [NSString stringWithFormat:@"delete from %@",BLOODSUGARTABLE];
    BOOL result = [database executeUpdate:sqlString];
    if(!result)
    {
        NSLog(@"删除失败");
    }
    else
    {
        NSLog(@"删除成功");
    }
    [database close];
}

//查询
-(NSMutableArray *)selectBloodSugarModel:(BloodSugarModel *)bloodSugarModel
{
    if(![self openDB])
    {
        return nil;
    }
    NSString * sqlString = [NSString stringWithFormat:@"select * from %@",BLOODSUGARTABLE];

    FMResultSet * resultSet = [database executeQueryWithFormat:sqlString,nil];
    NSMutableArray * results = [NSMutableArray arrayWithCapacity:0];
    while (resultSet.next)
    {
        BloodSugarModel * bloodModel = [[BloodSugarModel alloc]init];
        bloodModel.current = [resultSet stringForColumn:CURRENT];
        bloodModel.timeStamp = [resultSet stringForColumn:TIMESTAMP];
        [results addObject:bloodModel];
    }
    return results;
}

//查询数据库中有多少条数据
-(NSInteger) selectAllDataCount
{
    if (![self openDB])
    {
        return 0;
    }
    NSString * sqlString = [NSString stringWithFormat:@"select count(*) from %@",BLOODSUGARTABLE];
    NSInteger count = [database intForQuery:sqlString,nil];
    [database close];
    return count;
}

//查询所有
-(NSMutableArray *)selectAll
{
    if(![self openDB])
    {
        return nil;
    }
    NSString * sqlString = [NSString stringWithFormat:@"select * from %@ order by %@ asc",BLOODSUGARTABLE,TIMESTAMP];
    
    FMResultSet * resultSet = [database executeQueryWithFormat:sqlString,nil];
    NSMutableArray * results = [NSMutableArray arrayWithCapacity:0];
    while (resultSet.next)
    {
        BloodSugarModel * bloodModel = [[BloodSugarModel alloc]init];
        bloodModel.current = [resultSet stringForColumn:CURRENT];
        bloodModel.timeStamp = [resultSet stringForColumn:TIMESTAMP];
        bloodModel.glucose = [resultSet stringForColumn:GLUCOSE];
        [results addObject:bloodModel];
    }
    return results;
}

//更新血糖数据根据时间
-(void)updateGlucose:(NSString *)glucose withTimesp:(NSString *)timer
{
    if (![self openDB])
    {
        return;
    }
    
    NSString * sqlString = [NSString stringWithFormat:@"update %@ set %@ = '%@' where %@ = '%@'",BLOODSUGARTABLE,GLUCOSE,glucose,TIMESTAMP,timer];
    
    BOOL result = [database executeUpdate:sqlString];
    
    if(!result)
    {
        NSLog(@"update failed");
    }
    else
    {
        NSLog(@"update success");
    }
    [database close];
}


@end
