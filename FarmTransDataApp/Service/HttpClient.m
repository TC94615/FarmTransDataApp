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
#import "NSDate+Utils.h"

static NSString *const site = @"http://m.coa.gov.tw";
static NSString *const path = @"/OpenData/FarmTransData.aspx";
int const FETCH_PAGE_SIZE = 30;

@interface HttpClient()
@property (nonatomic, strong) NSDate *dateOfNewestData;
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
    _dateOfNewestData = [NSDate date];
    return self;
}

- (void) fetchDataInNewestDateWithPage:(int) page withMarketName:(NSString *) marketName completion:(void (^)(NSArray *, NSError *)) completion {
    [[self fetchDataInNewestDateWithPage:page
                          withMarketName:marketName] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            DDLogInfo(@"Error when fetching data from site");
            completion(nil, task.error);
        }
        if (completion) {
            completion(task.result, nil);
        }
        return nil;
    }];
}

- (BFTask *) fetchDataInNewestDateWithPage:(int) page withMarketName:(NSString *) marketName {
    return [[self fetchDataInDate:[NSDate AD2RepublicEra:self.dateOfNewestData] withPage:page
                           market:marketName] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            return task;
        }
        if (!((NSArray *) task.result).count) {
            self.dateOfNewestData = [NSDate getDateBeforeFrom:self.dateOfNewestData withDaysAgo:1];
            return [self fetchDataInNewestDateWithPage:page withMarketName:marketName];
        }
        else {
            return task;
        }
    }];
}

- (BFTask *) fetchDataInDate:(NSString *) dateString withPage:(int) page market:(NSString *) marketName {
    NSString *escapedMarketName = [marketName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    int skip = FETCH_PAGE_SIZE * page;
    NSDictionary *params = @{@"$top" : @(FETCH_PAGE_SIZE), @"$skip" : @(skip), @"market" : escapedMarketName,
      @"StartDate" : dateString};
    return [self fetchDataWithParams:params];
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
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    if (error) {
                                                        [completionSource setError:error];
                                                    }
                                                    else {
                                                        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                        options:2
                                                                                                          error:nil];
                                                        NSArray *MTLJson = [MTLJSONAdapter modelsOfClass:FarmTransData.class
                                                                                           fromJSONArray:json
                                                                                                   error:nil];

                                                        [completionSource setResult:MTLJson];
                                                    }
                                                });
                                            }];
    [dataTask resume];
    return completionSource.task;
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

- (NSDate *) getDateOfNewestData {
    return self.dateOfNewestData;
}
@end