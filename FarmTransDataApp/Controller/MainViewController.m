//
// Created by 李道政 on 14/12/30.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import <CocoaLumberjack/DDLog.h>
#import "MainViewController.h"
#import "FarmTransData.h"
#import "HttpClient.h"
#import "FarmTransTableViewCell.h"
#import "LoadMoreIndicatorCell.h"
#import "MainTitleView.h"
#import "DetailViewController.h"
#import "NSDate+Utils.h"

//market list
//台北ㄧ 台北二 三重 宜蘭 桃園 台中 永靖 溪湖 南投 ?西螺 高雄 鳳山 屏東 台東 ?花蓮

enum {
    ContentsSection = 0,
    LoadMoreSection,
    TotalSections
};

//TODO
NSString *market = @"台北一";

@interface MainViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MainTitleView *mainTitleView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) HttpClient *client;
@property (nonatomic, assign) BOOL requestingFlag;
@end

@implementation MainViewController

- (void) loadView {
    [super loadView];
    self.navigationController.view.backgroundColor = [UIColor redColor];
    self.navigationController.title = @"TITLE";
    UIView *view = [[UIView alloc] init];
    self.view = view;

    _mainTitleView = [[MainTitleView alloc] initWithCropName];
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
    self.navigationItem.title = [NSDate AD2RepublicEra:[self.client getDateOfNewestData]];

}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[FarmTransTableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    [self.tableView registerClass:[LoadMoreIndicatorCell class]
           forCellReuseIdentifier:loadMoreIndicatorCellReuseIdentifier];

    [self.client fetchDataWithPage:0 market:market completion:^(NSArray *data) {
        [self reloadTableView:data];
        self.navigationItem.title = [NSDate AD2RepublicEra:[self.client getDateOfNewestData]];
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
        FarmTransData *farmTransData = self.dataSourceArray[indexPath.row];
        [cell updateCellInMain:farmTransData];
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

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    if (ContentsSection == indexPath.section) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithCropId:[self.dataSourceArray[indexPath.row] cropName]
                                                                                      andMarketId:[self.dataSourceArray[indexPath.row] marketName]];
        [self.navigationController pushViewController:detailViewController
                                             animated:YES];
    }
}

- (void) reloadTableView:(NSArray *) array {
    [self.dataSourceArray addObjectsFromArray:array];
    [self.tableView reloadData];
};

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
        int page = (int) ceil(self.dataSourceArray.count / (CGFloat) FETCH_PAGE_SIZE);
        [self.client fetchDataWithPage:page market:market completion:^(NSArray *completion) {
            self.requestingFlag = NO;
            [self reloadTableView:completion];
        }];
    }
}

@end