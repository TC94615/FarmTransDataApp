//
// Created by 李道政 on 15/1/14.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import "CorePlotViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "FarmTransData.h"


@interface CorePlotViewController()<CPTPlotDataSource>
@property (nonatomic, strong) NSArray *dataSourceArray;
@end

@implementation CorePlotViewController
- (instancetype) initWithDataArray:(NSArray *) dataArray {
    _dataSourceArray = dataArray;
    return self;
}

- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *) plot {
    return 9;
}

- (NSNumber *) numberForPlot:(CPTPlot *) plot field:(NSUInteger) fieldEnum recordIndex:(NSUInteger) idx {
    int x = idx - 4;

    if (fieldEnum == CPTScatterPlotFieldX) {
        return @(x);
    } else {
        return @(x * x);
    }
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

    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc] initWithFrame:frame250];
    [self.view addSubview:hostView];

    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = graph;

    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;

    NSMutableArray *transDateArray = [NSMutableArray array];
    NSMutableArray *topPriceArray = [NSMutableArray array];
    NSMutableArray *midPriceArray = [NSMutableArray array];
    NSMutableArray *botPriceArray = [NSMutableArray array];
    NSMutableArray *avgPriceArray = [NSMutableArray array];
    NSMutableArray *volumeArray = [NSMutableArray array];

    for (FarmTransData *row in self.dataSourceArray) {
        [transDateArray addObject:row.transDate];
        [topPriceArray addObject:row.topPrice];
        [midPriceArray addObject:row.midPrice];
        [botPriceArray addObject:row.botPrice];
        [avgPriceArray addObject:row.avgPrice];
        [volumeArray addObject:row.volume];
    }
    [plotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(16)]];
    [plotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-4) length:CPTDecimalFromFloat(8)]];

    CPTScatterPlot *plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    plot.dataSource = self;

    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
}

- (CGSize) minMaxNumberInArray:(NSArray *) array {
    float max = -MAXFLOAT;
    float min = MAXFLOAT;
    for(NSNumber *number in array){
        float x = number.floatValue;

    }
    return CGSizeMake(min, max);

}
@end