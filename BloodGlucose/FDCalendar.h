//
//  FDCalendar.h
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDCalendarDelegate;


@interface FDCalendar : UIView


- (instancetype)initWithCurrentDate:(NSDate *)date;


@property (nonatomic,retain) id<FDCalendarDelegate> delegate;

@end

@protocol FDCalendarDelegate <NSObject>

@optional
-(void)setDateeee:(NSDate *)date;

@end