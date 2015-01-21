//
// Created by 李道政 on 15/1/8.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import "FarmTransData.h"

static int const FIRST_YEAR_OF_REPUBLIC_IN_AD = 1911;

@implementation FarmTransData

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
      @"transDate" : @"交易日期",
      @"cropId" : @"作物代號",
      @"cropName" : @"作物名稱",
      @"marketId" : @"市場代號",
      @"marketName" : @"市場名稱",
      @"topPrice" : @"上價",
      @"midPrice" : @"中價",
      @"botPrice" : @"下價",
      @"avgPrice" : @"平均價",
      @"volume" : @"交易量"
    };
}

+ (NSDateFormatter *) dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return dateFormatter;
}

+ (NSDateFormatter *) date2WeekdayFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return dateFormatter;
}

+ (NSString *) AD2RepublicEra:(NSDate *) date {
    NSString *dateString = [[self dateFormatter] stringFromDate:date];
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    NSString *thisYearInRepublicEra = [@([dateArray[0] integerValue] - FIRST_YEAR_OF_REPUBLIC_IN_AD) stringValue];
    NSString *dateWithRepublicEra = [NSString stringWithFormat:@"%@.%@.%@", thisYearInRepublicEra, dateArray[1],
                                                               dateArray[2]];
    return dateWithRepublicEra;
}

+ (NSDate *) yesterday {
    NSDate *yesterday = [[NSDate date] dateByAddingTimeInterval:-86400.0];
    return yesterday;
}
@end