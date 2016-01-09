//
//  View2Controller.m
//  NSPAlertController
//
//  Created by Jeff on 1/7/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "View2Controller.h"
#import "STPopup.h"

@interface View2Controller ()

@end

@implementation View2Controller

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 179);
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc dealloc dealloc dealloc dealloc", self.class);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 50, 100, 100)];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)buttonTapped:(id)sender
{
    [self.popupController dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



















