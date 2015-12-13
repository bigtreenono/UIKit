//
//  ViewController.m
//  多tableView加载3page
//
//  Created by xinguo010 on 15/6/23.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height

@interface ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *LeftTableView;
    UITableView *middleTableView;
    UITableView *rightTableView;
    
    NSMutableArray *leftArray;//左。
    NSMutableArray *middleArray;//中。
    NSMutableArray *rightArray;//右。
    
    NSMutableArray *arrays;
    NSMutableDictionary *datasource;
    NSInteger currentIndex;
    NSString *direction;
    
    UIScrollView *_scrollView;
    UIScrollView *_bannerScrollView;
    
    
}
@end

@implementation ViewController

-(id)init
{
    self = [super init];
    if (self) {
        arrays= [NSMutableArray array];
        datasource = [[NSMutableDictionary alloc]initWithCapacity:10];;
        leftArray =[NSMutableArray array];
        middleArray = [NSMutableArray array];
        rightArray =[NSMutableArray array];
        
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"nibBundleOrNil");
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initDataArray];
    
    [self initScrollView];
    [self initBannerView];
    [self changeTableView];
    
}
-(void)initData
{
    arrays= [NSMutableArray array];
    datasource = [NSMutableDictionary dictionary];;
    leftArray =[NSMutableArray array];
    middleArray = [NSMutableArray array];
    rightArray =[NSMutableArray array];
}
-(void)initDataArray
{
    for (int i = 0; i< 10; i++) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j<12; j++) {
            NSString *string = [NSString stringWithFormat:@"Data :%d__%d",i,j];
            [array addObject:string];
        }
        [arrays addObject:array];
        
        [datasource setValue:array forKey: [NSString stringWithFormat:@"%d", i]];
        
        
        
    }
    
    
}

-(void)initBannerView
{
    
    CGFloat buttonWidth = 50;
    _bannerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    [self.view addSubview:_bannerScrollView];
    [self.view bringSubviewToFront:_bannerScrollView];
    _bannerScrollView .contentSize = CGSizeMake(buttonWidth*arrays.count, 0);
    for (int i = 0; i<arrays.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, 60);
        button.backgroundColor = [UIColor blueColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 10+i;
        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [_bannerScrollView addSubview:button];
        [button addTarget:self action:@selector(LoadTableView:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}
-(void)LoadTableView:(UIButton *)button
{
    NSInteger i = button.tag -10;
    currentIndex = i;
    
    
    [self changeTableView];
}

-(void)initScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth,kScreenHeight-60)];
    _scrollView .delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*3, 0);
    _scrollView.pagingEnabled = YES;
   
    LeftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-60) style:UITableViewStylePlain];
    LeftTableView.dataSource = self;
    LeftTableView.delegate = self;
    [_scrollView addSubview:LeftTableView];
    
    middleTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-60) style:UITableViewStylePlain];
    middleTableView.dataSource = self;
    middleTableView.delegate = self;
    [_scrollView addSubview:middleTableView];
    
    rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight-60) style:UITableViewStylePlain];
    rightTableView.dataSource = self;
    rightTableView.delegate = self;
    [_scrollView addSubview:rightTableView];
    
    _scrollView.contentOffset = CGPointMake(0, 0);//起始位置。
    
    
}
-(void)changeTableView
{
//    if ([direction isEqual:@"L"]) {
//        
//    }
    
    
    if (currentIndex == 0) {
        //最左边。。。
        leftArray = arrays[currentIndex];
        middleArray = arrays[currentIndex+1];
        //        _scrollView .contentOffset = CGPointMake(0, 0);
        
    }else if(currentIndex == arrays.count-1)
    {
        //最右边。
        rightArray = arrays[currentIndex];
        middleArray = arrays[currentIndex-1];
    }else
    {
        //除了最左最右。。
        //中间。
        leftArray = arrays[currentIndex-1];
        middleArray = arrays[currentIndex];
        rightArray = arrays[currentIndex+1];
        
    }
    
    if (currentIndex == 0) {//最左
        _scrollView .contentOffset = CGPointMake(0, 0);
        
        [LeftTableView reloadData];
        [middleTableView reloadData];

    }else if(currentIndex == arrays.count-1)//最右
    {
        
         _scrollView .contentOffset = CGPointMake(_scrollView.frame.size.width*2, 0);
        
        [middleTableView reloadData];
        [rightTableView reloadData];
        
        
        
    }
    else
    {//中间
        _scrollView .contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
        
        [LeftTableView reloadData];
        [middleTableView reloadData];
        [rightTableView reloadData];
    }
    
}



#pragma mark  ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    
//    if ([scrollView isEqual:_scrollView]) {
//        CGPoint point = scrollView .contentOffset;
//        if (point.x>_scrollView.frame.size.width) {
//            currentIndex+=1;
//            NSLog(@"%ld",currentIndex);
//                [self changeTableView];
//            
//        }
//        else
//            if (point.x==0) {
//                currentIndex-=1;
//                [self changeTableView];
//            }
//        
//    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        CGPoint point = scrollView .contentOffset;
        if (point.x>_scrollView.frame.size.width) {
            currentIndex+=1;
            NSLog(@"%ld",currentIndex);
            if (currentIndex>arrays.count-1) {
                currentIndex= arrays.count-1;
            }
            [self changeTableView];
            
        }
        else
            if (point.x==0) {
                currentIndex-=1;
                if (currentIndex<0) {
                    currentIndex=0;
                }
                [self changeTableView];
            }
        
    }
}

#pragma mark TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([tableView isEqual:LeftTableView]) {
        return leftArray.count;
    }
    if ([tableView isEqual:middleTableView]) {
        return middleArray.count;
    }
    if ([tableView isEqual:rightTableView]) {
        return rightArray.count;
    }
    
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if ([tableView isEqual:LeftTableView]) {
        
        cell.textLabel.text = leftArray[indexPath.row];
    }
    else if([tableView isEqual:middleTableView]){
        cell.textLabel.text = middleArray[indexPath.row];
    }else if([tableView isEqual:rightTableView]){
        cell.textLabel.text = rightArray[indexPath.row];
    }
    
   
    
    return cell;
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
