//
//  ViewController.m
//  RefreshDemo
//
//  Created by Jeff on 12/13/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"
#import "TuniuViewController.h"
#import "ZhihuViewController.h"
#import "JDViewController.h"
#import "WeiboViewController.h"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = @[@"知乎",@"微博5.4.0",@"商情",@"途牛"];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.row == 0)
    {
        ZhihuViewController *ctr = [[ZhihuViewController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
    else  if(indexPath.row == 1)
    {
        WeiboViewController *ctr = [[WeiboViewController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
    else if(indexPath.row == 2)
    {
        JDViewController *ctr = [[JDViewController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
    else
    {
        TuniuViewController *ctr = [[TuniuViewController alloc] init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"titleForHeaderInSection == 0";
    }
    else if (section == 1)
    {
        return @"titleForHeaderInSection == 1";
    }
    else
    {
        return @"titleForHeaderInSection == 2";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"titleForFooterInSection == 0";
    }
    else if (section == 1)
    {
        return @"titleForFooterInSection == 1";
    }
    else
    {
        return @"titleForFooterInSection == 2";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
