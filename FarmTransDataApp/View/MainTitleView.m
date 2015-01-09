//
// Created by 李道政 on 15/1/9.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import "MainTitleView.h"


@interface MainTitleView()
@property (nonatomic, strong) UILabel *columnAgriculturalNameLabel;
@property (nonatomic, strong) UILabel *columnTopPriceLabel;
@property (nonatomic, strong) UILabel *columnMidPriceLabel;
@property (nonatomic, strong) UILabel *columnBotPriceLabel;
@property (nonatomic, strong) UILabel *columnAvgPriceLabel;
@property (nonatomic, strong) UILabel *columnVolumeLabel;
@end

@implementation MainTitleView
- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {


        _columnAgriculturalNameLabel = [[UILabel alloc] init];
        [self addSubview:self.columnAgriculturalNameLabel];
        self.columnAgriculturalNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.columnAgriculturalNameLabel.text = NSLocalizedString(@"mainTitleView.agricultural_name", @"作物");
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.columnAgriculturalNameLabel
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:0.0]];

        _columnTopPriceLabel = [[UILabel alloc] init];
        [self addSubview:self.columnTopPriceLabel];
        self.columnTopPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.columnTopPriceLabel.text = NSLocalizedString(@"mainTitleView.top_price", @"上價");
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.columnTopPriceLabel
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:0.0]];


        _columnMidPriceLabel = [[UILabel alloc] init];
        [self addSubview:self.columnMidPriceLabel];
        self.columnMidPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.columnMidPriceLabel.text = NSLocalizedString(@"mainTitleView.mid_price", @"中價");
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.columnMidPriceLabel
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:0.0]];


        _columnBotPriceLabel = [[UILabel alloc] init];
        [self addSubview:self.columnBotPriceLabel];
        self.columnBotPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.columnBotPriceLabel.text = NSLocalizedString(@"mainTitleView.bot_price", @"下價");
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.columnBotPriceLabel
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:0.0]];


        _columnAvgPriceLabel = [[UILabel alloc] init];
        [self addSubview:self.columnAvgPriceLabel];
        self.columnAvgPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.columnAvgPriceLabel.text = NSLocalizedString(@"mainTitleView.avg_price", @"均價");
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.columnAvgPriceLabel
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:0.0]];


        _columnVolumeLabel = [[UILabel alloc] init];
        [self addSubview:self.columnVolumeLabel];
        self.columnVolumeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.columnVolumeLabel.text = NSLocalizedString(@"mainTitleView.volume", @"量");
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.columnVolumeLabel
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:0.0]];


        NSDictionary *viewsInColumnView = @{@"columnAgriculturalNameLabel" : self.columnAgriculturalNameLabel,
          @"columnTopPriceLabel" : self.columnTopPriceLabel,
          @"columnMidPriceLabel" : self.columnMidPriceLabel,
          @"columnBotPriceLabel" : self.columnBotPriceLabel,
          @"columnAvgPriceLabel" : self.columnAvgPriceLabel,
          @"columnVolumeLabel" : self.columnVolumeLabel};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[columnAgriculturalNameLabel]"
                                               "[columnTopPriceLabel(==columnAgriculturalNameLabel)]"
                                               "[columnMidPriceLabel(==columnAgriculturalNameLabel)]"
                                               "[columnBotPriceLabel(==columnAgriculturalNameLabel)]"
                                               "[columnAvgPriceLabel(==columnAgriculturalNameLabel)]"
                                               "[columnVolumeLabel(==columnAgriculturalNameLabel)]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:viewsInColumnView]];

    }

    return self;
}


@end