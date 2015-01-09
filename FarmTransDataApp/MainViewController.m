//
// Created by 李道政 on 14/12/30.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import "MainViewController.h"
#import "FarmTransData.h"
#import "HttpClient.h"
#import "FarmTransTableViewCell.h"
#import "BottomCell.h"


//market list
//台北ㄧ 台北二 三重 宜蘭 桃園 台中 永靖 溪湖 南投 ?西螺 高雄 鳳山 屏東 台東 ?花蓮


enum {
    ContentsSection = 0,
    BottomSection,
    TotalSections
};

NSString *market = @"台北一";
NSString *startDate = @"103.01.01";

@interface MainViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *columnNameView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) UILabel *columnAgriculturalNameLabel;
@property (nonatomic, strong) UILabel *columnTopPriceLabel;
@property (nonatomic, strong) UILabel *columnMidPriceLabel;
@property (nonatomic, strong) UILabel *columnBotPriceLabel;
@property (nonatomic, strong) UILabel *columnAvgPriceLabel;
@property (nonatomic, strong) UILabel *columnVolumeLabel;

@property (nonatomic, strong) HttpClient *client;
@property (nonatomic, assign) BOOL requestingFlag;
@end

@implementation MainViewController

- (void) loadView {
    UIView *view = [[UIView alloc] init];
    self.view = view;

    _columnNameView = [[UIView alloc] init];
    [self.view addSubview:self.columnNameView];
    self.columnNameView.translatesAutoresizingMaskIntoConstraints = NO;
    self.columnNameView.backgroundColor = [UIColor redColor];

    _columnAgriculturalNameLabel = [[UILabel alloc] init];
    [self.columnNameView addSubview:self.columnAgriculturalNameLabel];
    self.columnAgriculturalNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.columnAgriculturalNameLabel.text = @"作物";
    [self.columnNameView addConstraint:[NSLayoutConstraint constraintWithItem:self.columnAgriculturalNameLabel
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.columnNameView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0.0]];

    _columnTopPriceLabel = [[UILabel alloc] init];
    [self.columnNameView addSubview:self.columnTopPriceLabel];
    self.columnTopPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.columnTopPriceLabel.text = @"上價";
    [self.columnNameView addConstraint:[NSLayoutConstraint constraintWithItem:self.columnTopPriceLabel
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.columnNameView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0.0]];


    _columnMidPriceLabel = [[UILabel alloc] init];
    [self.columnNameView addSubview:self.columnMidPriceLabel];
    self.columnMidPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.columnMidPriceLabel.text = @"中價";
    [self.columnNameView addConstraint:[NSLayoutConstraint constraintWithItem:self.columnMidPriceLabel
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.columnNameView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0.0]];


    _columnBotPriceLabel = [[UILabel alloc] init];
    [self.columnNameView addSubview:self.columnBotPriceLabel];
    self.columnBotPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.columnBotPriceLabel.text = @"下價";
    [self.columnNameView addConstraint:[NSLayoutConstraint constraintWithItem:self.columnBotPriceLabel
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.columnNameView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0.0]];


    _columnAvgPriceLabel = [[UILabel alloc] init];
    [self.columnNameView addSubview:self.columnAvgPriceLabel];
    self.columnAvgPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.columnAvgPriceLabel.text = @"均價";
    [self.columnNameView addConstraint:[NSLayoutConstraint constraintWithItem:self.columnAvgPriceLabel
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.columnNameView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0.0]];


    _columnVolumeLabel = [[UILabel alloc] init];
    [self.columnNameView addSubview:self.columnVolumeLabel];
    self.columnVolumeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.columnVolumeLabel.text = @"量";
    [self.columnNameView addConstraint:[NSLayoutConstraint constraintWithItem:self.columnVolumeLabel
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.columnNameView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0.0]];


    NSDictionary *viewsInColumnView = @{@"columnAgriculturalNameLabel" : self.columnAgriculturalNameLabel,
      @"columnTopPriceLabel" : self.columnTopPriceLabel,
      @"columnMidPriceLabel" : self.columnMidPriceLabel,
      @"columnBotPriceLabel" : self.columnBotPriceLabel,
      @"columnAvgPriceLabel" : self.columnAvgPriceLabel,
      @"columnVolumeLabel" : self.columnVolumeLabel};
    [self.columnNameView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[columnAgriculturalNameLabel]"
                                           "[columnTopPriceLabel(==columnAgriculturalNameLabel)]"
                                           "[columnMidPriceLabel(==columnAgriculturalNameLabel)]"
                                           "[columnBotPriceLabel(==columnAgriculturalNameLabel)]"
                                           "[columnAvgPriceLabel(==columnAgriculturalNameLabel)]"
                                           "[columnVolumeLabel(==columnAgriculturalNameLabel)]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsInColumnView]];


    _tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *views = @{@"columnNameView" : self.columnNameView, @"tableView" : self.tableView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[columnNameView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[columnNameView(==50)][tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    _dataSourceArray = [NSMutableArray array];

    _client = [[HttpClient alloc] init];
    _requestingFlag = NO;


}

- (void) reloadTableView:(NSArray *) array {
    [self.dataSourceArray addObjectsFromArray:array];
    [self.tableView reloadData];
};

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[FarmTransTableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    [self.tableView registerClass:[BottomCell class] forCellReuseIdentifier:bottomCellReuseIdentifier];


    [self.client fetchDataWithPage:0 market:market
                   startDateString:startDate completion:^(NSArray *data) {
         [self reloadTableView:data];
     }];

}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    if (ContentsSection == section) {
        return [self.dataSourceArray count];
    }
    else if (BottomSection == section) {
        return 1;
    }
    return 0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return TotalSections;
}


- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    if (ContentsSection == indexPath.section) {
        FarmTransTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier
                                                                       forIndexPath:indexPath];
        FarmTransData *farmTransData = self.dataSourceArray[indexPath.row];
        NSLog(@">>>>>>>>>>>> indexPath = %i,farmTransData.agriculturalName = %@", indexPath.row, farmTransData.agriculturalName);
        [cell updateCell:farmTransData];
        return cell;
    }
    else if (BottomSection == indexPath.section) {
        BottomCell *cell = [tableView dequeueReusableCellWithIdentifier:bottomCellReuseIdentifier
                                                           forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void) scrollViewDidScroll:(UIScrollView *) scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if (y > h + reload_distance) {
        if (self.requestingFlag) {
            return;
        }
        BottomCell *bottomCell = (BottomCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                                         inSection:BottomSection]];
        [bottomCell addActivityIndicator];
        self.requestingFlag = YES;
        int page = ceil(self.dataSourceArray.count / (CGFloat) FETCH_PAGE_SIZE);
        NSLog(@">>>>>>>>>>>> page = %i", page + 1);
        [self.client fetchDataWithPage:page market:market
                       startDateString:startDate completion:^(NSArray *completion) {
             self.requestingFlag = NO;
             [self reloadTableView:completion];
         }];
    }
}


@end