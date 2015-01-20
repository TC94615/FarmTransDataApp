//
// Created by 李道政 on 15/1/8.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import "FarmTransTableViewCell.h"
#import "FarmTransData.h"

NSString *const cellReuseIdentifier = @"CellReuseIdentifier";

@interface FarmTransTableViewCell()
@property (nonatomic, strong) UILabel *cropNameOrTransDateLabel;
@property (nonatomic, strong) UILabel *topPriceLabel;
@property (nonatomic, strong) UILabel *midPriceLabel;
@property (nonatomic, strong) UILabel *botPriceLabel;
@property (nonatomic, strong) UILabel *avgPriceLabel;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) FarmTransData *data;
@end

@implementation FarmTransTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _cropNameOrTransDateLabel = [[UILabel alloc] init];
        self.cropNameOrTransDateLabel.textAlignment = NSTextAlignmentCenter;
        self.cropNameOrTransDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.cropNameOrTransDateLabel.numberOfLines = 2;
        [self.contentView addSubview:self.cropNameOrTransDateLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cropNameOrTransDateLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]];

        _topPriceLabel = [[UILabel alloc] init];
        self.topPriceLabel.textAlignment = NSTextAlignmentCenter;
        self.topPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.topPriceLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.topPriceLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]];

        _midPriceLabel = [[UILabel alloc] init];
        self.midPriceLabel.textAlignment = NSTextAlignmentCenter;
        self.midPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.midPriceLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.midPriceLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]];

        _botPriceLabel = [[UILabel alloc] init];
        self.botPriceLabel.textAlignment = NSTextAlignmentCenter;
        self.botPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.botPriceLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.botPriceLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]];

        _avgPriceLabel = [[UILabel alloc] init];
        self.avgPriceLabel.textAlignment = NSTextAlignmentCenter;
        self.avgPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.avgPriceLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.avgPriceLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]];

        _volumeLabel = [[UILabel alloc] init];
        self.volumeLabel.textAlignment = NSTextAlignmentCenter;
        self.volumeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.volumeLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.volumeLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]];


        NSDictionary *views = @{
          @"cropNameOrTransDateLabel" : self.cropNameOrTransDateLabel,
          @"topPriceLabel" : self.topPriceLabel,
          @"midPriceLabel" : self.midPriceLabel,
          @"botPriceLabel" : self.botPriceLabel,
          @"avgPriceLabel" : self.avgPriceLabel,
          @"volumeLabel" : self.volumeLabel};


        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                                               @"|[cropNameOrTransDateLabel]"
                                                                 "[topPriceLabel(==cropNameOrTransDateLabel)]"
                                                                 "[midPriceLabel(==cropNameOrTransDateLabel)]"
                                                                 "[botPriceLabel(==cropNameOrTransDateLabel)]"
                                                                 "[avgPriceLabel(==cropNameOrTransDateLabel)]"
                                                                 "[volumeLabel(==cropNameOrTransDateLabel)]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
    }
    return self;
}

- (void) updateCellInMain:(FarmTransData *) data {
    self.cropNameOrTransDateLabel.text = data.cropName;
    [self updateCellPrices:data];
}

- (void) updateCellInDetail:(FarmTransData *) data {
    self.cropNameOrTransDateLabel.text = data.transDate;
    [self updateCellPrices:data];
}

- (void) updateCellPrices:(FarmTransData *) data {
    self.topPriceLabel.text = data.topPrice;
    self.midPriceLabel.text = data.midPrice;
    self.botPriceLabel.text = data.botPrice;
    self.avgPriceLabel.text = data.avgPrice;
    self.volumeLabel.text = data.volume;
}

+ (CGFloat) cellHeight {
    return 50;
}

@end