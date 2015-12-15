//
//  WeiboViewController.m
//  RefreshDemo
//
//  Created by Jeff on 12/13/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "WeiboViewController.h"
#import "UIScrollView+Refresh.h"
#import "RefreshHeaderView.h"

@interface WeiboViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger   data;

@end

@implementation WeiboViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"微博5.4.0";
    self.view.backgroundColor = [UIColor whiteColor];

    _data = 20;
    
    __weak __typeof(self) weakSelf = self;
    _tableView.refreshHeader = [_tableView addRefreshHeaderWithHandler:^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.data = 20;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.refreshHeader endRefresh];
//            weakSelf.tableView.refreshFooter.loadMoreEnabled = YES;
        });
    }];
    
//    _tableView.refreshFooter = [_tableView addRefreshFooterWithHandler:^ {
//        [weakSelf loadMoreData];
//    }];
//   _tableView.refreshFooter.autoLoadMore = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [_tableView.refreshHeader startRefresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

















