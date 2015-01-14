//
// Created by 李道政 on 15/1/8.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int const FETCH_PAGE_SIZE;


@interface HttpClient : NSObject

- (void) fetchDataWithPage:(int) page withAgriculturalName:(NSString *) agriculturalName withMarketName:(NSString *) marketName withStartDateString:(NSString *) startDate withEndDateString:(NSString *) endDate completion:(void (^)(NSArray *)) completion;

- (void) fetchDataWithPage:(int) page market:(NSString *) marketName startDateString:(NSString *) startDate completion:(void (^)(NSArray *)) completion;
@end