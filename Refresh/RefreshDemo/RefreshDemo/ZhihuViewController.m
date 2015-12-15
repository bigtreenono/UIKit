//
//  ZhihuViewController.m
//  RefreshDemo
//
//  Created by Jeff on 12/13/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "ZhihuViewController.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define FirstTableColor [UIColor whiteColor]
#define SecondTableColor [UIColor whiteColor]


@interface ZhihuViewController ()

@property (nonatomic, strong)   UITableView *firstTableView;
@property (nonatomic, strong)   UITableView *secondTableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ZhihuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"zhihu";
    
    _firstTableView = ({
        UITableView *tableView                 = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.backgroundColor              = [UIColor groupTableViewBackgroundColor];
        tableView.delegate                     = (id<UITableViewDelegate>)self;
        tableView.dataSource                   = (id<UITableViewDataSource>)self;
        tableView.separatorStyle               = UITableViewCellSelectionStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView;
    });
    
    _secondTableView = ({
        UITableView *tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        tableView.backgroundColor              = [UIColor groupTableViewBackgroundColor];
        tableView.delegate                     = (id<UITableViewDelegate>)self;
        tableView.dataSource                   = (id<UITableViewDataSource>)self;
        tableView.separatorStyle               = UITableViewCellSelectionStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView;
    });
    
    //_footerView
//    __weak __typeof(self)weakSelf = self;
//    self.firstTableView.refreshFooter = [self.firstTableView addRefreshFooter:[[LDZhihuRefreshFooterView alloc] init] handler:^{
//        [weakSelf loadMoreData];
//    }];
//    self.firstTableView.refreshFooter.autoLoadMore = NO;
//    
//    //_headerView
//    self.secondTableView.refreshHeader = [self.secondTableView addRefreshHeader:[[LDZhihuRefreshHeaderView alloc] init] handler:^{
//        [weakSelf refreshData];
//    }];
    
    _dataArray = @[@"江湖传言：“江左梅郎，麒麟之才，得之可得天下。”作为天下第一大帮“江左盟”的首领，梅长苏“梅郎”之名响誉江湖。然而，有着江湖至尊地位的梅长苏，却是一个病弱青年、弱不禁风，背负着十多年前巨大的冤案与血海深仇，就连身世背后也隐藏着巨大的秘密...", @"原来，十二年前，南梁大通年间，北魏兴兵南下，赤焰军少帅林殊随父出征、率七万将士抗击敌军，不料七万将士因奸佞陷害含冤埋骨梅岭。林殊从地狱之门拾回残命，历经至亲尽失、削骨易容之痛，化身天下第一大帮江左盟盟主梅长苏。\r\n十二年后,梅长苏假借养病之机、凭一介白衣之身重返帝都，从此踏上复仇、雪冤与夺嫡之路。面对曾有婚约的霓凰郡主（刘涛饰）、旧时的挚友靖王（王凯饰）以及过去熟悉的所有，他只能默默隐忍着一切，于看似不经意间，以病弱之躯只手掀起波波血影惊涛，辅佐明君靖王登上皇位，为七万赤焰忠魂洗雪了污名..."];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.numberOfLines = 0;
    }
    
    if (tableView == _firstTableView)
    {
        cell.backgroundColor = FirstTableColor;
        cell.textLabel.text = _dataArray[0];
    }
    else
    {
        cell.backgroundColor = SecondTableColor;
        cell.textLabel.text = _dataArray[1];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (tableView == _firstTableView)
    {
        height = _firstTableView.frame.size.height;
    }
    else
    {
        height = _secondTableView.frame.size.height;
    }
    return height;
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
