//
// Created by 李道政 on 15/1/8.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import <Mantle/MTLJSONAdapter.h>
#import "HttpClient.h"
#import "BFTask.h"
#import "DDLog.h"
#import "BFTaskCompletionSource.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPRequestOperation.h"
#import "FarmTransData.h"

static NSString *const site = @"http://m.coa.gov.tw";
static NSString *const path = @"/OpenData/FarmTransData.aspx";
int const FETCH_PAGE_SIZE = 30;

@implementation HttpClient

- (void) fetchDataWithPage:(int) page market:(NSString *) market startDateString:(NSString *) startDate completion:(void (^)(NSArray *)) completion {
    NSString *escapedMarketName = [market stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    int skip = FETCH_PAGE_SIZE * page;
    NSDictionary *params = @{@"$top" : @(FETCH_PAGE_SIZE), @"$skip" : @(skip), @"market" : escapedMarketName,
      @"StartDate" : startDate};
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [paramString appendFormat:@"%@=%@&", key, obj];
    }];

    NSString *urlString = [NSString stringWithFormat:@"%@%@", site, path];

    if ([paramString length]) {
        urlString = [urlString stringByAppendingFormat:@"?%@", paramString];
        urlString = [urlString substringWithRange:NSMakeRange(0, [urlString length] - 1)];
    }
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