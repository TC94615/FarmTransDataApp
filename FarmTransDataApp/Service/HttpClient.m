//
// Created by 李道政 on 15/1/8.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import <Mantle/MTLJSONAdapter.h>
#import "HttpClient.h"
#import "FarmTransData.h"
#import "DDLog.h"
#import "AppConstants.h"
#import "BFTask.h"
#import "BFTaskCompletionSource.h"

static NSString *const site = @"http://m.coa.gov.tw";
static NSString *const path = @"/OpenData/FarmTransData.aspx";
int const FETCH_PAGE_SIZE = 30;

@interface HttpClient()
@property (nonatomic, strong) NSDate *defaultDate;
@end

@implementation HttpClient

+ (id) sharedManager {
    static HttpClient *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype) init {
    self = [super init];
    [self setThisDateInRepublicEra];
    //TODO
    _defaultDate = [FarmTransData day:self.defaultDate withDaysAgo:-2];
    NSLog(@">>>>>>>>>>>> [FarmTransData AD2RepublicEra:self.defaultDate] = %@", [FarmTransData AD2RepublicEra:self.defaultDate]);
    //
    return self;

}

- (void) fetchDataWithPage:(int) page market:(NSString *) marketName completion:(void (^)(NSArray *)) completion {
    [[[[self fetchDataWithDate:[FarmTransData AD2RepublicEra:self.defaultDate] withPage:page
                        market:marketName] continueWithSuccessBlock:^id(BFTask *task) {
        if (!((NSArray *) task.result).count) {
            DDLogInfo(@"Fetch no data at %@", [FarmTransData AD2RepublicEra:self.defaultDate]);
            self.defaultDate = [FarmTransData day:self.defaultDate withDaysAgo:1];
            return [[self fetchDataWithDate:[FarmTransData AD2RepublicEra:self.defaultDate] withPage:page
                                     market:marketName] continueWithSuccessBlock:^id(BFTask *_task) {
                return _task.result;
            }];
        }
        return task.result;
    }] continueWithSuccessBlock:^id(BFTask *task) {
        if (!((NSArray *) task.result).count) {
            DDLogInfo(@"Fetch no data at %@", [FarmTransData AD2RepublicEra:self.defaultDate]);
            self.defaultDate = [FarmTransData day:self.defaultDate withDaysAgo:1];
            return [[self fetchDataWithDate:[FarmTransData AD2RepublicEra:self.defaultDate] withPage:page
                                     market:marketName] continueWithSuccessBlock:^id(BFTask *_task) {
                return _task.result;
            }];
        }
        return task.result;
    }] continueWithBlock:^id(BFTask *task) {
        if (completion) {
            completion(task.result);
        }
        return nil;
    }];
}

- (BFTask *) fetchDataWithDate:(NSString *) dateString withPage:(int) page market:(NSString *) marketName {
    NSString *escapedMarketName = [marketName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    int skip = FETCH_PAGE_SIZE * page;
    NSDictionary *params = @{@"$top" : @(FETCH_PAGE_SIZE), @"$skip" : @(skip), @"market" : escapedMarketName,
      @"StartDate" : dateString};
    return [[self fetchDataWithParams:params] continueWithSuccessBlock:^id(BFTask *task) {
        NSLog(@">>>>>>>>>>>> task.result = %@", task.result);
        return task.result;
    }];
}

- (void) fetchDataWithPage:(int) page withCropName:(NSString *) cropName withMarketName:(NSString *) marketName withStartDateString:(NSString *) startDate withEndDateString:(NSString *) endDate completion:(void (^)(NSArray *)) completion {
    NSString *escapedMarketName = [marketName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *escapedCropName = [cropName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    int skip = FETCH_PAGE_SIZE * page;
    NSDictionary *params = @{@"$top" : @(FETCH_PAGE_SIZE), @"$skip" : @(skip), @"Crop" : escapedCropName,
      @"Market" : escapedMarketName, @"EndDate" : endDate, @"StartDate" : startDate};
    [[self fetchDataWithParams:params] continueWithSuccessBlock:^id(BFTask *task) {
        if (completion) {
            NSArray *dataArray = task.result;
            completion([self filterSimilarNameObject:dataArray withCorrectName:cropName]);
        }
        return nil;
    }];
}

- (NSArray *) filterSimilarNameObject:(NSArray *) array
                      withCorrectName:
                        (NSString *) correctName {
    NSMutableArray *filteredArray = [NSMutableArray array];
    for (FarmTransData *row in array) {
        if ([row.cropName isEqualToString:correctName]) {
            [filteredArray addObject:row];
        }
    }
    return [filteredArray copy];
}

- (BFTask *) fetchDataWithParams:(NSDictionary *) params {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];

    NSMutableString *paramString = [[NSMutableString alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [paramString appendFormat:@"%@=%@&", key, obj];
    }];

    NSString *urlString = [NSString stringWithFormat:@"%@%@", site, path];
    if ([paramString length]) {
        urlString = [urlString stringByAppendingFormat:@"?%@", paramString];
        urlString = [urlString substringWithRange:NSMakeRange(0, [urlString length] - 1)];
    }
    DDLogInfo(@"fetch url: %@", urlString);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString]
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                options:2
                                                                                                  error:nil];
                                                NSArray *MTLJson = [MTLJSONAdapter modelsOfClass:FarmTransData.class
                                                                                   fromJSONArray:json
                                                                                           error:nil];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [completionSource setResult:MTLJson];
                                                });
                                            }];
    [dataTask resume];
    return completionSource.task;
}

- (void) setThisDateInRepublicEra {
    NSDate *now = [NSDate date];
    NSString *weekdayString = [[FarmTransData date2WeekdayFormatter] stringFromDate:now];
    if ([weekdayString isEqualToString:@"Monday"]) {
        _defaultDate = [FarmTransData day:now withDaysAgo:1];
    }
    else {
        _defaultDate = now;
    }
}
@end