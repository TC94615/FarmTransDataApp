//
// Created by 李道政 on 15/1/8.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import <Mantle/MTLJSONAdapter.h>
#import "HttpClient.h"
#import "FarmTransData.h"
#import "DDLog.h"
#import "AppConstants.h"

static NSString *const site = @"http://m.coa.gov.tw";
static NSString *const path = @"/OpenData/FarmTransData.aspx";
int const FETCH_PAGE_SIZE = 30;

@interface HttpClient()
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
    return self;
}

- (void) fetchDataWithPage:(int) page market:(NSString *) marketName startDateString:(NSString *) startDate completion:(void (^)(NSArray *)) completion {
    NSString *escapedMarketName = [marketName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    int skip = FETCH_PAGE_SIZE * page;
    NSDictionary *params = @{@"$top" : @(FETCH_PAGE_SIZE), @"$skip" : @(skip), @"market" : escapedMarketName,
      @"StartDate" : startDate};
    [self fetchDataWithParams:params completion:^(NSArray *array) {
        completion(array);
    }];
}

- (void) fetchDataWithPage:(int) page withCropName:(NSString *) cropName withMarketName:(NSString *) marketName withStartDateString:(NSString *) startDate withEndDateString:(NSString *) endDate completion:(void (^)(NSArray *)) completion {
    NSString *escapedMarketName = [marketName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *escapedCropName = [cropName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    int skip = FETCH_PAGE_SIZE * page;
    NSDictionary *params = @{@"$top" : @(FETCH_PAGE_SIZE), @"$skip" : @(skip), @"Crop" : escapedCropName,
      @"Market" : escapedMarketName, @"EndDate" : endDate, @"StartDate" : startDate};
    [self fetchDataWithParams:params completion:^(NSArray *array) {
        NSArray *filteredArray = [self filterSimilarNameObject:array withCorrectName:cropName];
        completion(filteredArray);
    }];
}

- (NSArray *) filterSimilarNameObject:(NSArray *) array withCorrectName:(NSString *) correctName {
    NSMutableArray *filteredArray = [NSMutableArray array];
    for (FarmTransData *row in array) {
        if ([row.cropName isEqualToString:correctName]) {
            [filteredArray addObject:row];
        }
    }
    return [filteredArray copy];
}

- (void) fetchDataWithParams:(NSDictionary *) params completion:(void (^)(NSArray *)) completion {
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
                                                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:2
                                                                                                  error:nil];
                                                NSArray *MTLJson = [MTLJSONAdapter modelsOfClass:FarmTransData.class
                                                                                   fromJSONArray:json
                                                                                           error:nil];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    completion(MTLJson);
                                                });
                                            }];
    [dataTask resume];
}

@end