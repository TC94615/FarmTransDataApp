//
// Created by 李道政 on 15/1/14.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import "CorePlotViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "FarmTransData.h"
#import "DDLog.h"
#import "AppConstants.h"

#define SWITCH(s) for(NSString *__s__=(s); ;)
#define CASE(str) if([__s__ isEqual:(str)])
#define DEFAULT

struct MinMaxValue {
    float min;
    float max;
};

int const DIVISOR_FIVE = 5;
NSString *const TOP_PRICE_PLOT_IDENTIFIER = @"topPricePlotIdentifier";
NSString *const MID_PRICE_PLOT_IDENTIFIER = @"midPricePlotIdentifier";
NSString *const BOT_PRICE_PLOT_IDENTIFIER = @"botPricePlotIdentifier";
NSString *const AVG_PRICE_PLOT_IDENTIFIER = @"avgPricePlotIdentifier";

@interface CorePlotViewController()<CPTPlotDataSource, CPTAxisDelegate>
@property (nonatomic, strong) NSArray *dataForPlot;
@end

@implementation CorePlotViewController
- (instancetype) initWithDataArray:(NSArray *) dataForPlot {
    _dataForPlot = [[dataForPlot reverseObjectEnumerator] allObjects];
    return self;
}

- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *) plot {
    return self.dataForPlot.count;
}

- (NSNumber *) numberForPlot:(CPTPlot *) plot field:(NSUInteger) fieldEnum recordIndex:(NSUInteger) idx {
    NSNumber *num;
    num = [self.dataForPlot[idx] topPrice];
    SWITCH(plot.identifier) {
        CASE(TOP_PRICE_PLOT_IDENTIFIER) {
            num = [self.dataForPlot[idx] topPrice];
            break;
        }
        CASE(MID_PRICE_PLOT_IDENTIFIER) {
            num = [self.dataForPlot[idx] midPrice];
            break;
        }
        CASE(BOT_PRICE_PLOT_IDENTIFIER) {
            num = [self.dataForPlot[idx] botPrice];
            break;
        }
        CASE(AVG_PRICE_PLOT_IDENTIFIER) {
            num = [self.dataForPlot[idx] avgPrice];
            break;
        }
        DEFAULT{
            break;
        };
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

    CPTTheme *theme = [CPTTheme themeNamed:kCPTStocksTheme];

    CGPoint viewOrigin = [[UIScreen mainScreen] bounds].origin;
    CGSize viewSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 3 * self.navigationController.topLayoutGuide.length);
    CGRect frame = CGRectMake(viewOrigin.x, viewOrigin.y, viewSize.width, viewSize.height);

    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc] initWithFrame:frame];
    hostView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:hostView];

    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = graph;
    [graph applyTheme:theme];

    graph.paddingTop = 20.0;
    graph.paddingBottom = 20.0;
    graph.paddingLeft = 20.0;
    graph.paddingRight = 20.0;
    graph.plotAreaFrame.paddingTop = 20;
    graph.plotAreaFrame.paddingBottom = 70;
    graph.plotAreaFrame.paddingLeft = 30;
    graph.plotAreaFrame.paddingRight = 20;

    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    NSMutableArray *transDateArray = [NSMutableArray array];
    NSMutableArray *mixPriceArray = [NSMutableArray array];
    for (FarmTransData *row in self.dataForPlot) {
        [transDateArray addObject:row.transDate];
        [mixPriceArray addObjectsFromArray:@[row.topPrice, row.midPrice, row.botPrice, row.avgPrice]];
    }
    [self plotRangeConfigure:mixPriceArray inPlotSpace:plotSpace];

    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet;
    [self xAxisConfigure:axisSet.xAxis withTransDateArray:transDateArray];
    [self yAxisConfigure:axisSet.yAxis];

    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    CPTScatterPlot *topPricePlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    [self scatterPlotConfigure:graph withPlot:topPricePlot
                 withLineStyle:lineStyle withColor:[CPTColor redColor]
                    withPlotId:TOP_PRICE_PLOT_IDENTIFIER];
    CPTScatterPlot *midPricePlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    [self scatterPlotConfigure:graph withPlot:midPricePlot
                 withLineStyle:lineStyle withColor:[CPTColor greenColor]
                    withPlotId:MID_PRICE_PLOT_IDENTIFIER];
    CPTScatterPlot *botPricePlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    [self scatterPlotConfigure:graph withPlot:botPricePlot
                 withLineStyle:lineStyle withColor:[CPTColor blueColor]
                    withPlotId:BOT_PRICE_PLOT_IDENTIFIER];
    CPTScatterPlot *avgPricePlot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    [self scatterPlotConfigure:graph withPlot:avgPricePlot
                 withLineStyle:lineStyle withColor:[CPTColor whiteColor]
                    withPlotId:AVG_PRICE_PLOT_IDENTIFIER];
}

- (void) xAxisConfigure:(CPTXYAxis *) x withTransDateArray:(NSArray *)transDateArray{
    float quintile = self.dataForPlot.count / DIVISOR_FIVE;
    x.majorIntervalLength = CPTDecimalFromDouble(quintile);
    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(5.0);
    CPTMutableTextStyle *style = [CPTMutableTextStyle textStyle];
    style.color = [CPTColor grayColor];
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
}

- (void) yAxisConfigure:(CPTXYAxis *) y {
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    y.labelFormatter = numberFormatter;
}

- (void) plotRangeConfigure:(NSArray *) dataArray inPlotSpace:(CPTXYPlotSpace *) plotSpace {
    struct MinMaxValue minMaxValue = [self minMaxNumberInArray:dataArray];
    DDLogInfo(@"y-axis range = (%f,%f)", minMaxValue.min, minMaxValue.max);
    [plotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minMaxValue.min)
                                                      length:CPTDecimalFromFloat(minMaxValue.max)]];
    [plotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                      length:CPTDecimalFromFloat(self.dataForPlot.count)]];

}

- (void) scatterPlotConfigure:(CPTGraph *) graph withPlot:(CPTScatterPlot *) plot withLineStyle:(CPTMutableLineStyle *) lineStyle withColor:(CPTColor *) color withPlotId:(NSString *) plotId {
    lineStyle.lineColor = color;
    plot.dataLineStyle = lineStyle;
    plot.dataSource = self;
    plot.identifier = plotId;
    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:color];
    plotSymbol.size = CGSizeMake(10.0, 10.0);
    plot.plotSymbol = plotSymbol;
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