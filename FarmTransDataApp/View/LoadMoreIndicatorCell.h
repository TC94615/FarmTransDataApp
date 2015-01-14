//
// Created by 李道政 on 14/11/3.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const bottomCellReuseIdentifier;

@interface LoadMoreIndicatorCell : UITableViewCell
//@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (void) addActivityIndicator;
@end