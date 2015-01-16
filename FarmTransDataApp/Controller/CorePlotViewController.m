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

enum {
    TopPlot = 0,
    MidPlot,
    BotPlot,
    AvgPlot
};

int const FIVE = 5;
NSString *const TOP_PRICE_PLOT_IDENTIFIER = @"topPricePlotIdentifier";
NSString *const MID_PRICE_PLOT_IDENTIFIER = @"midPricePlotIdentifier";
NSString *const BOT_PRICE_PLOT_IDENTIFIER = @"botPricePlotIdentifier";
NSString *const AVG_PRICE_PLOT_IDENTIFIER = @"avgPricePlotIdentifier";

@interface CorePlotViewController()<CPTPlotDataSource, CPTAxisDelegate>
@property (nonatomic, strong) NSArray *dataForPlot;
@end

@implementation CorePlotViewController
- (instancetype) initWithDataArray:(NSArray *) dataForPlot {
    _dataForPlot = dataForPlot;
    return self;
}

- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *) plot {
    return self.dataForPlot.count;
}

- (NSNumber *) numberForPlot:(CPTPlot *) plot field:(NSUInteger) fieldEnum recordIndex:(NSUInteger) idx {
    NSNumber *num;
    num = [self.dataForPlot[idx] topPrice];
    if ([plot.identifier isEqual:TOP_PRICE_PLOT_IDENTIFIER]) {
        num = [self.dataForPlot[idx] topPrice];
    }
    else if ([plot.identifier isEqual:MID_PRICE_PLOT_IDENTIFIER]) {
        num = [self.dataForPlot[idx] midPrice];
    }
    else if ([plot.identifier isEqual:BOT_PRICE_PLOT_IDENTIFIER]) {
        num = [self.dataForPlot[idx] botPrice];
    }
    else if ([plot.identifier isEqual:AVG_PRICE_PLOT_IDENTIFIER]) {
        num = [self.dataForPlot[idx] avgPrice];
    }

    if (fieldEnum == CPTScatterPlotFieldY) {
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

    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];

    CGPoint viewOrigin = [[UIScreen mainScreen] bounds].origin;
    CGSize viewSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 3 * self.navigationController.topLayoutGuide.length);
    CGRect frame = CGRectMake(viewOrigin.x, viewOrigin.y, viewSize.width, viewSize.height);

    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc] initWithFrame:frame];
    hostView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:hostView];

    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = graph;
    [graph applyTheme:theme];

    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;

    graph.paddingTop = 20.0;
    graph.paddingBottom = 20.0;
    graph.paddingLeft = 20.0;
    graph.paddingRight = 20.0;

    graph.plotAreaFrame.paddingTop = 20;
    graph.plotAreaFrame.paddingBottom = 70;
    graph.plotAreaFrame.paddingLeft = 30;
    graph.plotAreaFrame.paddingRight = 20;

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

    struct MinMaxValue minMaxValue = [self minMaxNumberInArray:mixPriceArray];
    NSLog(@">>>>>>>>>>>> min,max = %f,%f", minMaxValue.min, minMaxValue.max);
    [plotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minMaxValue.min)
                                                      length:CPTDecimalFromFloat(minMaxValue.max)]];
    [plotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                      length:CPTDecimalFromFloat(self.dataForPlot.count)]];

#pragma axis setting
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet;
    float quintile = self.dataForPlot.count / FIVE;
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPTDecimalFromDouble(quintile);
    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(5.0);
    CPTMutableTextStyle *style = [CPTMutableTextStyle textStyle];
    style.color = [CPTColor blackColor];
    style.fontName = @"Arial";
    style.fontSize = 12.0f;
    NSMutableArray *labels = [NSMutableArray array];
    NSInteger idx = 0;
    for (NSString *dateString in transDateArray) {
        if (idx % (int) quintile == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:dateString
                                                           textStyle:style];
            label.rotation = CPTFloat(M_PI_4);
            label.offset = 0;
            label.tickLocation = CPTDecimalFromInteger(idx);
            [labels addObject:label];
        }
        idx += 1;
    }
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.axisLabels = [NSSet setWithArray:labels];


    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    y.labelFormatter = numberFormatter;

#pragma plot setting
    CPTScatterPlot *topPricePlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor redColor];
    topPricePlot.dataLineStyle = lineStyle;
    topPricePlot.dataSource = self;
    topPricePlot.identifier = TOP_PRICE_PLOT_IDENTIFIER;
    [graph addPlot:topPricePlot toPlotSpace:graph.defaultPlotSpace];

    CPTScatterPlot *midPricePlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor greenColor];
    midPricePlot.dataLineStyle = lineStyle;
    midPricePlot.dataSource = self;
    midPricePlot.identifier = MID_PRICE_PLOT_IDENTIFIER;
    [graph addPlot:midPricePlot toPlotSpace:graph.defaultPlotSpace];

    CPTScatterPlot *botPricePlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blueColor];
    botPricePlot.dataLineStyle = lineStyle;
    botPricePlot.dataSource = self;
    botPricePlot.identifier = BOT_PRICE_PLOT_IDENTIFIER;
    [graph addPlot:botPricePlot toPlotSpace:graph.defaultPlotSpace];

    CPTScatterPlot *avgPricePlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor whiteColor];
    avgPricePlot.dataLineStyle = lineStyle;
    avgPricePlot.dataSource = self;
    avgPricePlot.identifier = AVG_PRICE_PLOT_IDENTIFIER;
    [graph addPlot:avgPricePlot toPlotSpace:graph.defaultPlotSpace];
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