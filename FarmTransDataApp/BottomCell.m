//
// Created by 李道政 on 14/11/3.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import "BottomCell.h"

NSString *const bottomCellReuseIdentifier = @"BottomCell";


@implementation BottomCell

- (void) addActivityIndicator {
    NSLog(@"In addActivityIndicator...");
    if (self) {

        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.backgroundColor = [UIColor whiteColor];
        [activityIndicator startAnimating];
        [self.contentView addSubview:activityIndicator];
        activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1
                                                                      constant:0]];
        NSLog(@"indicator triggered");
    }
}

@end