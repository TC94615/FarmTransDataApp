//
// Created by 李道政 on 14/12/30.
// Copyright (c) 2014 李道政. All rights reserved.
//

#import "MainViewController.h"
#import "FarmTransData.h"
#import "HttpClient.h"
#import "FarmTransTableViewCell.h"
#import "BottomCell.h"
#import "MainTitleView.h"
#import "Dao.h"
#import "DetailViewController.h"


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
@property (nonatomic, strong) NSString *thisDateInRepublicEra;
@property (nonatomic, strong) Dao *dao;
@end

@implementation MainViewController

- (void) loadView {
    self.navigationController.view.backgroundColor= [UIColor redColor];
    self.navigationController.title = @"TITLE";
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

    NSDictionary *views = @{@"mainTitleView" : self.mainTitleView, @"tableView" : self.tableView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[mainTitleView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mainTitleView(==100)][tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    _dataSourceArray = [NSMutableArray array];

    _client = [[HttpClient alloc] init];
    _requestingFlag = NO;
    _thisDateInRepublicEra = [FarmTransData AD2RepublicEra:[NSDate date]];
    _dao = [Dao sharedDao];
    [self.dao createTable];


}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return [FarmTransTableViewCell cellHeight];
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
                   startDateString:self.thisDateInRepublicEra completion:^(NSArray *data) {
         [self reloadTableView:data];
     }];

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

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    if (ContentsSection == indexPath.section) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithAriculturalId:[self.dataSourceArray[indexPath.row] agriculturalName]
                                                                                             andMarketId:[self.dataSourceArray[indexPath.row] marketName]];
        [self.navigationController pushViewController:detailViewController
                                             animated:YES];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return TotalSections;
}


- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    if (ContentsSection == indexPath.section) {
        FarmTransTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier
                                                                       forIndexPath:indexPath];
        FarmTransData *farmTransData = self.dataSourceArray[indexPath.row];
        [cell updateCell:farmTransData];
        return cell;
    }
    else if (LoadMoreSection == indexPath.section) {
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
                                                                                                         inSection:LoadMoreSection]];
        [bottomCell addActivityIndicator];
        self.requestingFlag = YES;
        int page = ceil(self.dataSourceArray.count / (CGFloat) FETCH_PAGE_SIZE);
        [self.client fetchDataWithPage:page market:market
                       startDateString:self.thisDateInRepublicEra completion:^(NSArray *completion) {
             self.requestingFlag = NO;
             [self reloadTableView:completion];
         }];
    }
}


@end