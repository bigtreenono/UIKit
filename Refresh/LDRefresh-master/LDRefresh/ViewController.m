//
//  ViewController.m
//  LDRefresh
//
//  Created by lidi on 10/6/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "ViewController.h"
#import "WeiboRefreshDemoController.h"
#import "ZhihuRefreshDemoController.h"
#import "JingdongRefreshDemoController.h"
#import "TNRefreshDemoController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"LDRefresh";
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height - 64)];
    tableView.delegate = (id<UITableViewDelegate>)self;
    tableView.dataSource = (id<UITableViewDataSource>)self;
    [self.view addSubview:tableView];
    
    _dataArray = @[@"仿知乎回答上下拉切换",@"仿微博5.4.0上下拉加载",@"仿京东商品详情页上下拉切换",@"仿途牛旅游上下拉加载"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.row == 0) {
        ZhihuRefreshDemoController *ctr = [[ZhihuRefreshDemoController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
    else  if(indexPath.row == 1) {
        WeiboRefreshDemoController *ctr = [[WeiboRefreshDemoController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
    else if(indexPath.row == 2){
        JingdongRefreshDemoController *ctr = [[JingdongRefreshDemoController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
    else {
        TNRefreshDemoController *ctr = [[TNRefreshDemoController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
}
@end
