//
// Created by 李道政 on 15/1/14.
// Copyright (c) 2015 李道政. All rights reserved.
//

#import "DetailViewController.h"
#import "FarmTransData.h"
#import "MainTitleView.h"
#import "HttpClient.h"
#import "FarmTransTableViewCell.h"
#import "LoadMoreIndicatorCell.h"
#import "AppConstants.h"
#import "CorePlotViewController.h"
#import "NSDate+Utils.h"

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
@property (nonatomic, strong) NSString *cropName;
@property (nonatomic, strong) NSString *marketName;
@property (nonatomic, strong) NSString *thisDateInRepublicEra;
@property (nonatomic, assign) int page;
@end

@implementation DetailViewController

- (instancetype) initWithCropId:(NSString *) cropName andMarketId:(NSString *) marketName {
    self = [super init];
    if (self) {
        _cropName = cropName;
        _marketName = marketName;
    }
    return self;
}

- (void) loadView {
    UIView *view = [[UIView alloc] init];
    self.view = view;

    _mainTitleView = [[MainTitleView alloc] initWithTransDate];
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
    _client = [HttpClient sharedManager];
    _requestingFlag = NO;
    _thisDateInRepublicEra = [NSDate AD2RepublicEra:[NSDate date]];
    _page = 0;
    [self setNavigationBar];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[FarmTransTableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    [self.tableView registerClass:[LoadMoreIndicatorCell class]
           forCellReuseIdentifier:loadMoreIndicatorCellReuseIdentifier];

    [self.client fetchDataWithPage:self.page withCropName:self.cropName
                    withMarketName:self.marketName withStartDateString:FIRST_DAY_IN_SITE
                 withEndDateString:self.thisDateInRepublicEra completion:^(NSArray *data) {
         [self reloadTableView:data];
     }];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return TotalSections;
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

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    if (ContentsSection == indexPath.section) {
        FarmTransTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier
                                                                       forIndexPath:indexPath];
        [cell updateCellInDetail:self.dataSourceArray[indexPath.row]];
        return cell;
    }
    else if (LoadMoreSection == indexPath.section) {
        LoadMoreIndicatorCell *cell = [tableView dequeueReusableCellWithIdentifier:loadMoreIndicatorCellReuseIdentifier
                                                                      forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return [FarmTransTableViewCell cellHeight];
}

- (void) reloadTableView:(NSArray *) array {
    [self.dataSourceArray addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (void) setNavigationBar {
    self.navigationItem.title = [NSString stringWithFormat:@"%@ - %@", self.cropName, self.marketName];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"detailViewController.navigationItem.leftBarButton_name", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(clickLeftBarButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"detailViewController.navigationItem.rightBarButton_name", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(clickRightBarButton:)];
}

- (void) clickLeftBarButton:(UIBarButtonItem *) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) clickRightBarButton:(UIBarButtonItem *) sender {
    CorePlotViewController *plotViewController = [[CorePlotViewController alloc] initWithDataArray:self.dataSourceArray];
    [self.navigationController pushViewController:plotViewController animated:NO];
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
        self.page += 1;
        [self.client fetchDataWithPage:self.page withCropName:self.cropName
                        withMarketName:self.marketName withStartDateString:FIRST_DAY_IN_SITE
                     withEndDateString:self.thisDateInRepublicEra completion:^(NSArray *data) {
             self.requestingFlag = NO;
             [self reloadTableView:data];
         }];
    }
}

@end