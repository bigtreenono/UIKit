//
//  ViewController.m
//  TransparentLabel
//
//  Created by Jeff on 12/20/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"
#import "TransparentLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    parentView.backgroundColor = [UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:0.5];
    [self.view addSubview:parentView];
    
    TransparentLabel *label = [[TransparentLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text = @"hehe";
//    label.backgroundColor = [UIColor lightGrayColor];
    [parentView addSubview:label];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
