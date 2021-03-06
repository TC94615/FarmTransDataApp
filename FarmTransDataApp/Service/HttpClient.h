//
// Created by 李道政 on 15/1/8.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;

extern int const FETCH_PAGE_SIZE;

@interface HttpClient : NSObject

+ (id) sharedManager;

- (void) fetchDataInNewestDateWithPage:(int) page withMarketName:(NSString *) marketName completion:(void (^)(NSArray *, NSError *)) completion;

- (void) fetchDataWithPage:(int) page withCropName:(NSString *) cropName withMarketName:(NSString *) marketName withStartDateString:(NSString *) startDate withEndDateString:(NSString *) endDate completion:(void (^)(NSArray *)) completion;

- (NSDate *) getDateOfNewestData;

- (BFTask *) fetchDataInNewestDateWithPage:(int) page withMarketName:(NSString *) marketName;

@end