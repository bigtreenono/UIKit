//
//  ViewController.m
//  NSPAlertController
//
//  Created by Jeff on 12/27/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"
#import "NSPAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonAction:(id)sender
{
    NSPAlertController *alertController = [NSPAlertController alertControllerWithTitle:@"title" message:@"message" preferredStyle:NSPAlertControllerStyleAlert];
    
    NSPAlertAction *alertAction = [NSPAlertAction actionWithTitle:@"title1" style:NSPAlertActionStyleDefault handler:^(NSPAlertAction * _Nonnull action) {
        NSLog(@"22222222222222222222222222222222222222222222222222222222222222");
    }];
    
    NSPAlertAction *alertAction2 = [NSPAlertAction actionWithTitle:@"title2" style:NSPAlertActionStyleCancel handler:^(NSPAlertAction * _Nonnull action) {
        NSLog(@"3333333333333333333333333333333333333333333333333333333333333333333333333333333333");
    }];
    
    [alertController addAction:alertAction];
    [alertController addAction:alertAction2];
    
    [self presentViewController:alertController animated:YES completion:^{
       NSLog(@"1111111111111111111111111111111111111111111111111111111111111111");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

























