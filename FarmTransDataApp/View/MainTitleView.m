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
        self.columnAgriculturalNameLabel.textAlignment = NSTextAlignmentCenter;
        self.columnAgriculturalNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.columnAgriculturalNameLabel.text = NSLocalizedString(@"mainTitleView.agricultural_name", @"作物");
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.columnAgriculturalNameLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:0.9
                                                                         constant:0.0]];

        _columnTopPriceLabel = [[UILabel alloc] init];
        [self addSubview:self.columnTopPriceLabel];
        self.columnTopPriceLabel.textAlignment = NSTextAlignmentCenter;
        self.columnTopPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.columnTopPriceLabel.text = NSLocalizedString(@"mainTitleView.top_price", @"上價");
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.columnTopPriceLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:0.9
                                                                         constant:0.0]];


        _columnMidPriceLabel = [[UILabel alloc] init];
        [self addSubview:self.columnMidPriceLabel];
        self.columnMidPriceLabel.textAlignment = NSTextAlignmentCenter;
        self.columnMidPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.columnMidPriceLabel.text = NSLocalizedString(@"mainTitleView.mid_price", @"中價");
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.columnMidPriceLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:0.9
                                                                         constant:0.0]];


        _columnBotPriceLabel = [[UILabel alloc] init];
        [self addSubview:self.columnBotPriceLabel];
        self.columnBotPriceLabel.textAlignment = NSTextAlignmentCenter;
        self.columnBotPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.columnBotPriceLabel.text = NSLocalizedString(@"mainTitleView.bot_price", @"下價");
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.columnBotPriceLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:0.9
                                                                         constant:0.0]];


        _columnAvgPriceLabel = [[UILabel alloc] init];
        [self addSubview:self.columnAvgPriceLabel];
        self.columnAvgPriceLabel.textAlignment = NSTextAlignmentCenter;
        self.columnAvgPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.columnAvgPriceLabel.text = NSLocalizedString(@"mainTitleView.avg_price", @"均價");
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.columnAvgPriceLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:0.9
                                                                         constant:0.0]];


        _columnVolumeLabel = [[UILabel alloc] init];
        [self addSubview:self.columnVolumeLabel];
        self.columnVolumeLabel.textAlignment = NSTextAlignmentCenter;
        self.columnVolumeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.columnVolumeLabel.text = NSLocalizedString(@"mainTitleView.volume", @"量");
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.columnVolumeLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:0.9
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