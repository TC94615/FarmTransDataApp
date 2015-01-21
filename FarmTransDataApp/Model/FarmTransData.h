//
// Created by 李道政 on 15/1/8.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface FarmTransData : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *transDate;
@property (nonatomic, strong) NSString *cropId;
@property (nonatomic, strong) NSString *cropName;
@property (nonatomic, strong) NSNumber *marketId;
@property (nonatomic, strong) NSString *marketName;
@property (nonatomic, strong) NSNumber *topPrice;
@property (nonatomic, strong) NSNumber *midPrice;
@property (nonatomic, strong) NSNumber *botPrice;
@property (nonatomic, strong) NSNumber *avgPrice;
@property (nonatomic, strong) NSNumber *volume;

+ (NSDateFormatter *) dateFormatter;

+ (NSDateFormatter *) date2WeekdayFormatter;

+ (NSString *) AD2RepublicEra:(NSDate *) date;

+ (NSDate *) day:(NSDate *) thisDay withDaysAgo:(int) daysAgo;
@end
