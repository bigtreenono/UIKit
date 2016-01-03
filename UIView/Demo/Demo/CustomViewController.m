//
//  CustomViewController.m
//  Demo
//
//  Created by Jeff on 12/20/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomView.h"

@interface CustomViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CustomView *customView;
@property (nonatomic, assign) NSInteger sections;
@property (nonatomic, strong) UIView *view2;

@end

@implementation CustomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_customView removeFromSuperview];
    NSLog(@"_customView %@", _customView);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"_customView3 %@", _customView);
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"_customView2 %@", _customView);
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
    cell.textLabel.text = [NSString stringWithFormat:@"section %zd, row %zd", indexPath.section, indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    return 100;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
























