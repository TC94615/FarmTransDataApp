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
#import "BottomCell.h"

enum {
    ContentsSection = 0,
    BottomSection,
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
    return [self.dataSourceArray count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return TotalSections;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    if (ContentsSection == indexPath.section) {
        FarmTransTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier
                                                                       forIndexPath:indexPath];
        [cell updateCell:self.dataSourceArray[indexPath.row]];
        return cell;
    }
    else if (BottomSection == indexPath.section) {
        BottomCell *cell = [tableView dequeueReusableCellWithIdentifier:bottomCellReuseIdentifier
                                                           forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void) loadView {
    NSLog(@">>>>>>>>>>>>> load dvc");
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

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mainTitleView(==50)][tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    _dataSourceArray = [NSMutableArray array];

    _client = [[HttpClient alloc] init];
    _requestingFlag = NO;
    _thisDateInRepublicEra = [FarmTransData AD2RepublicEra:[NSDate date]];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[FarmTransTableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    [self.tableView registerClass:[BottomCell class] forCellReuseIdentifier:bottomCellReuseIdentifier];

    NSString *lastYearInRepublicEra = [FarmTransData AD2RepublicEra:[self DateFromOneYearAgo]];
    [self.client fetchDataWithPage:0 withAgriculturalName:self.agriculturalName
                    withMarketName:self.marketName withStartDateString:lastYearInRepublicEra
                 withEndDateString:self.thisDateInRepublicEra completion:^(NSArray *data) {
         [self reloadTableView:data];
     }];
}

- (void) reloadTableView:(NSArray *) array {
    [self.dataSourceArray addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (NSDate *) DateFromOneYearAgo {
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    /*
      Create a date components to represent the number of years to add to the current date.
      In this case, we add -1 to subtract one year.
    */

    NSDateComponents *addComponents = [[NSDateComponents alloc] init];
    addComponents.year = -1;

    return [calendar dateByAddingComponents:addComponents toDate:today options:0];
}

@end