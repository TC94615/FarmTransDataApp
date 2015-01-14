//
// Created by 李道政 on 15/1/14.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import "DetailViewController.h"
#import "FarmTransData.h"
#import "MainTitleView.h"
#import "HttpClient.h"
#import "Dao.h"
#import "FarmTransTableViewCell.h"
#import "LoadMoreIndicatorCell.h"
#import "AppConstants.h"
#import "CorePlotViewController.h"

enum {
    ContentsSection = 0,
    LoadMoreSection,
    TotalSections
};

@interface DetailViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MainTitleView *mainTitleView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) HttpClient *client;
@property (nonatomic, assign) BOOL requestingFlag;
@property (nonatomic, strong) Dao *dao;
@property (nonatomic, strong) NSString *agriculturalName;
@property (nonatomic, strong) NSString *marketName;
@property (nonatomic, strong) NSString *thisDateInRepublicEra;
@property (nonatomic, assign) int page;
@end

@implementation DetailViewController
- (instancetype) initWithAriculturalId:(NSString *) agriculturalName andMarketId:(NSString *) marketName {
    self = [super init];
    if (self) {
        _agriculturalName = agriculturalName;
        _marketName = marketName;
    }
    return self;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    if (ContentsSection == section) {
        return [self.dataSourceArray count];
    }
    else if (LoadMoreSection == section) {
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
        [cell updateCellInDetail:self.dataSourceArray[indexPath.row]];
        return cell;
    }
    else if (LoadMoreSection == indexPath.section) {
        LoadMoreIndicatorCell *cell = [tableView dequeueReusableCellWithIdentifier:bottomCellReuseIdentifier
                                                                      forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void) loadView {
    UIView *view = [[UIView alloc] init];
    self.view = view;

    _mainTitleView = [[MainTitleView alloc] init];
    [self.view addSubview:self.mainTitleView];
    self.mainTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mainTitleView.backgroundColor = [UIColor redColor];

    _tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *views = @{@"mainTitleView" : self.mainTitleView, @"tableView" : self.tableView,
      @"topLayoutGuide" : self.topLayoutGuide};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[mainTitleView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][mainTitleView(==40)][tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    _dataSourceArray = [NSMutableArray array];

    _client = [[HttpClient alloc] init];
    _requestingFlag = NO;
    _thisDateInRepublicEra = [FarmTransData AD2RepublicEra:[NSDate date]];
    _page = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"plot"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(clickRightBarButton:)];
}

- (void) clickRightBarButton:(UIBarButtonItem *) sender {
    CorePlotViewController *plotViewController = [[CorePlotViewController alloc] initWithDataArray:self.dataSourceArray];
    [self.navigationController pushViewController:plotViewController animated:NO];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[FarmTransTableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    [self.tableView registerClass:[LoadMoreIndicatorCell class] forCellReuseIdentifier:bottomCellReuseIdentifier];

    [self.client fetchDataWithPage:self.page withAgriculturalName:self.agriculturalName
                    withMarketName:self.marketName withStartDateString:FIRST_DAY_IN_SITE
                 withEndDateString:self.thisDateInRepublicEra completion:^(NSArray *data) {
         [self reloadTableView:data];
     }];
}

- (void) reloadTableView:(NSArray *) array {
    [self.dataSourceArray addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return [FarmTransTableViewCell cellHeight];
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
        LoadMoreIndicatorCell *loadMoreIndicatorCell = (LoadMoreIndicatorCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                                                                          inSection:LoadMoreSection]];
        [loadMoreIndicatorCell addActivityIndicator];
        self.requestingFlag = YES;
        //int page = ceil(self.dataSourceArray.count / (CGFloat) FETCH_PAGE_SIZE);
        self.page += 1;
        [self.client fetchDataWithPage:self.page withAgriculturalName:self.agriculturalName
                        withMarketName:self.marketName withStartDateString:FIRST_DAY_IN_SITE
                     withEndDateString:self.thisDateInRepublicEra completion:^(NSArray *data) {
             self.requestingFlag = NO;
             [self reloadTableView:data];
         }];
    }
}

@end