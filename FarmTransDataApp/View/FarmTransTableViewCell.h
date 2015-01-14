//
// Created by 李道政 on 15/1/8.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const cellReuseIdentifier;

@class FarmTransData;

@interface FarmTransTableViewCell : UITableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier;


- (void) updateCellInMain:(FarmTransData *) data;

- (void) updateCellInDetail:(FarmTransData *) data;

+ (CGFloat) cellHeight;

@end