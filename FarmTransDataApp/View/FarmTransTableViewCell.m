//
// Created by 李道政 on 15/1/8.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import "FarmTransTableViewCell.h"
#import "FarmTransData.h"

NSString *const cellReuseIdentifier = @"CellReuseIdentifier";

@interface FarmTransTableViewCell()
@property (nonatomic, strong) UILabel *transDateLabel;
@property (nonatomic, strong) UILabel *agriculturalIdLabel;
@property (nonatomic, strong) UILabel *agriculturalNameLabel;
@property (nonatomic, strong) UILabel *marketIdLabel;
@property (nonatomic, strong) UILabel *marketNameLabel;
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
//        _transDateLabel = [[UILabel alloc] init];
//        self.transDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.contentView addSubview:self.transDateLabel];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.transDateLabel
//                                                                     attribute:NSLayoutAttributeCenterY
//                                                                     relatedBy:NSLayoutRelationEqual
//                                                                        toItem:self.contentView
//                                                                     attribute:NSLayoutAttributeCenterY
//                                                                    multiplier:1.0
//                                                                      constant:0]];
//
//        _agriculturalIdLabel = [[UILabel alloc] init];
//        self.agriculturalIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.contentView addSubview:self.agriculturalIdLabel];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.agriculturalIdLabel
//                                                                     attribute:NSLayoutAttributeCenterY
//                                                                     relatedBy:NSLayoutRelationEqual
//                                                                        toItem:self.contentView
//                                                                     attribute:NSLayoutAttributeCenterY
//                                                                    multiplier:1.0
//                                                                      constant:0]];

        _agriculturalNameLabel = [[UILabel alloc] init];
        self.agriculturalNameLabel.textAlignment = NSTextAlignmentCenter;
        self.agriculturalNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.agriculturalNameLabel.numberOfLines = 2;
//        self.agriculturalNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.agriculturalNameLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.agriculturalNameLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]];
//
//        _marketIdLabel = [[UILabel alloc] init];
//        self.marketIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.contentView addSubview:self.marketIdLabel];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.marketIdLabel
//                                                                     attribute:NSLayoutAttributeCenterY
//                                                                     relatedBy:NSLayoutRelationEqual
//                                                                        toItem:self.contentView
//                                                                     attribute:NSLayoutAttributeCenterY
//                                                                    multiplier:1.0
//                                                                      constant:0]];
//
//        _marketNameLabel = [[UILabel alloc] init];
//        self.marketNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.contentView addSubview:self.marketNameLabel];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.marketNameLabel
//                                                                     attribute:NSLayoutAttributeCenterY
//                                                                     relatedBy:NSLayoutRelationEqual
//                                                                        toItem:self.contentView
//                                                                     attribute:NSLayoutAttributeCenterY
//                                                                    multiplier:1.0
//                                                                      constant:0]];

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

//        NSDictionary *views = @{@"transDateLabel" : self.transDateLabel,
//          @"agriculturalIdLabel" : self.agriculturalIdLabel,
//          @"agriculturalNameLabel" : self.agriculturalNameLabel,
//          @"marketIdLabel" : self.marketIdLabel,
//          @"marketNameLabel" : self.marketNameLabel,
//          @"topPriceLabel" : self.topPriceLabel,
//          @"midPriceLabel" : self.midPriceLabel,
//          @"botPriceLabel" : self.botPriceLabel,
//          @"avgPriceLabel" : self.avgPriceLabel,
//          @"volumeLabel" : self.volumeLabel};
        NSDictionary *views = @{
          @"agriculturalNameLabel" : self.agriculturalNameLabel,
          @"topPriceLabel" : self.topPriceLabel,
          @"midPriceLabel" : self.midPriceLabel,
          @"botPriceLabel" : self.botPriceLabel,
          @"avgPriceLabel" : self.avgPriceLabel,
          @"volumeLabel" : self.volumeLabel};


        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                                               @"|[agriculturalNameLabel]"
                                                                 "[topPriceLabel(==agriculturalNameLabel)]"
                                                                 "[midPriceLabel(==agriculturalNameLabel)]"
                                                                 "[botPriceLabel(==agriculturalNameLabel)]"
                                                                 "[avgPriceLabel(==agriculturalNameLabel)]"
                                                                 "[volumeLabel(==agriculturalNameLabel)]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
    }
    return self;
}

- (void) updateCell:(FarmTransData *) data {
//    self.transDateLabel.text = data.transDate;
//    self.agriculturalIdLabel.text = data.agriculturalId;
    self.agriculturalNameLabel.text = data.agriculturalName;
//    self.marketIdLabel.text = data.marketId;
//    self.marketNameLabel.text = data.marketName;
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