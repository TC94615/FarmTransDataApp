//
// Created by 李道政 on 15/1/23.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import "FarmTransData.h"
#import "NSDate+Utils.h"


static int const FIRST_YEAR_OF_REPUBLIC_IN_AD = 1911;

@implementation NSDate(Utils)

+ (NSDateFormatter *) dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return dateFormatter;
}

+ (NSString *) AD2RepublicEra:(NSDate *) date {
    NSString *dateString = [[NSDate dateFormatter] stringFromDate:date];
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    NSString *thisYearInRepublicEra = [@([dateArray[0] integerValue] - FIRST_YEAR_OF_REPUBLIC_IN_AD) stringValue];
    NSString *dateWithRepublicEra = [NSString stringWithFormat:@"%@.%@.%@", thisYearInRepublicEra, dateArray[1],
                                                               dateArray[2]];
    return dateWithRepublicEra;
}

+ (NSDate *) getDateBeforeFrom:(NSDate *) thisDay withDaysAgo:(int) daysAgo {
    double secondsOfOneDay = -86400.0;
    NSDate *theDay = [thisDay dateByAddingTimeInterval:secondsOfOneDay * daysAgo];
    return theDay;
}
@end