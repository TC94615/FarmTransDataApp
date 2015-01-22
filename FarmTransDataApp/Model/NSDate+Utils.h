//
// Created by 李道政 on 15/1/23.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"

@interface NSDate(Utils)

+ (NSDateFormatter *) dateFormatter;

+ (NSString *) AD2RepublicEra:(NSDate *) date;

+ (NSDate *) getDateBeforeFrom:(NSDate *) thisDay withDaysAgo:(int) daysAgo;
@end