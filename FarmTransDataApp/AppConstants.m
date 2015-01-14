//
// Created by 李道政 on 15/1/9.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import "AppConstants.h"
#import "DDLog.h"

@implementation AppConstants
NSString *const FIRST_DAY_IN_SITE = @"100.01.01";
#if APP_STORE
NSInteger const ddLogLevel = LOG_LEVEL_OFF;
#else
NSInteger const ddLogLevel = LOG_LEVEL_VERBOSE;
#endif
@end