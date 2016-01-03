//
//  ViewController.m
//  Demo
//
//  Created by Jeff on 12/20/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"
//#import "CustomView.h"
#import "CustomViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    CustomView *view = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:nil options:nil][0];
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    [self.navigationController pushViewController:[[CustomViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end































