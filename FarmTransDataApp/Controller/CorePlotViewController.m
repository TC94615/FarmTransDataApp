//
// Created by 李道政 on 15/1/14.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import "CorePlotViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "FarmTransData.h"

struct MinMaxValue {
    float min;
    float max;
};

@interface CorePlotViewController()<CPTPlotDataSource>
@property (nonatomic, strong) NSArray *dataForPlot;
@end

@implementation CorePlotViewController
- (instancetype) initWithDataArray:(NSArray *) dataForPlot {
    _dataForPlot = dataForPlot;
    return self;
}

- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *) plot {
    return [self.dataForPlot count];
}

- (NSNumber *) numberForPlot:(CPTPlot *) plot field:(NSUInteger) fieldEnum recordIndex:(NSUInteger) idx {
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber *num = [self.dataForPlot[idx] topPrice];

    if (fieldEnum == CPTScatterPlotFieldY) {
        NSLog(@">>>>>>>>>>>> x,y = (%u,%@)", idx, num);
        return num;
    }
    return @(idx);
}


- (void) loadView {
    [super loadView];
    UIView *view = [[UIView alloc] init];
    self.view = view;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    CGRect frame250 = CGRectMake(0, 0, 250, 450);
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    hostView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:hostView];

    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = graph;
    [graph applyTheme:theme];

    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;

    NSMutableArray *transDateArray = [NSMutableArray array];
    NSMutableArray *topPriceArray = [NSMutableArray array];
    NSMutableArray *midPriceArray = [NSMutableArray array];
    NSMutableArray *botPriceArray = [NSMutableArray array];
    NSMutableArray *avgPriceArray = [NSMutableArray array];
    NSMutableArray *volumeArray = [NSMutableArray array];

    for (FarmTransData *row in self.dataForPlot) {
        [transDateArray addObject:row.transDate];
        [topPriceArray addObject:row.topPrice];
        [midPriceArray addObject:row.midPrice];
        [botPriceArray addObject:row.botPrice];
        [avgPriceArray addObject:row.avgPrice];
        [volumeArray addObject:row.volume];
    }
    NSMutableArray *mixPriceArray = [NSMutableArray array];
    [mixPriceArray addObjectsFromArray:topPriceArray];
    [mixPriceArray addObjectsFromArray:midPriceArray];
    [mixPriceArray addObjectsFromArray:botPriceArray];
    [mixPriceArray addObjectsFromArray:avgPriceArray];
//    [mixPriceArray addObjectsFromArray:volumeArray];
    struct MinMaxValue minMaxValue = [self minMaxNumberInArray:mixPriceArray];
    NSLog(@">>>>>>>>>>>> min,max = %f,%f", minMaxValue.min,minMaxValue.max);
    [plotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minMaxValue.min) length:CPTDecimalFromFloat(minMaxValue.max-minMaxValue.min)]];
    [plotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-4) length:CPTDecimalFromFloat(8)]];

    CPTScatterPlot *plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    plot.dataSource = self;

    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
}


- (struct MinMaxValue) minMaxNumberInArray:(NSArray *) array {
    struct MinMaxValue minMaxValue;
    minMaxValue.max = -MAXFLOAT;
    minMaxValue.min = MAXFLOAT;
    for (NSNumber *number in array) {
        float x = number.floatValue;
        if (x < minMaxValue.min) minMaxValue.min = x;
        if (x > minMaxValue.max) minMaxValue.max = x;
    }
    return minMaxValue;
}
@end