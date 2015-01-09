//
// Created by 李道政 on 15/1/8.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import "FarmTransData.h"
static int const FIRST_YEAR_OF_REPUBLIC = 1911;

@implementation FarmTransData

+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
      @"transDate" : @"交易日期",
      @"agriculturalId" : @"作物代號",
      @"agriculturalName" : @"作物名稱",
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

+ (NSString *) AD2RepublicEra : (NSDate *) date {
    NSString *dateString = [[self dateFormatter] stringFromDate:date];
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    NSString *year = [@([dateArray[0] integerValue] - FIRST_YEAR_OF_REPUBLIC) stringValue];
    NSString *dateWithRepublicEra = [NSString stringWithFormat:@"%@.%@.%@", year, dateArray[1], dateArray[2]];
    return dateWithRepublicEra;
}
@end