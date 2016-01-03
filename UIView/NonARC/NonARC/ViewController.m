//
//  ViewController.m
//  NonARC
//
//  Created by Jeff on 12/25/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (retain, nonatomic) IBOutlet UIView *customView;
@property (nonatomic, assign) UIView *customView2;
@property (nonatomic, assign) NSInteger a;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _customView2 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    _customView2.backgroundColor = [UIColor blueColor];
    NSLog(@"customView %zd", _customView2.retainCount);

    [self.view addSubview:_customView2];
    NSLog(@"customView2 %zd", _customView2.retainCount);
    
    
    NSLog(@"111customView3 %zd", _customView.retainCount);

//    [_customView removeFromSuperview];
    NSLog(@"customView3 %zd", _customView.retainCount);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"customView5 %zd, %@", _customView.retainCount, _customView);

    });
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"customView4 %zd, %@", _customView.retainCount, _customView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_customView release];
    [super dealloc];
}
@end
