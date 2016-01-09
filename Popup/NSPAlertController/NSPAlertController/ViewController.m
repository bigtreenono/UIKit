//
//  ViewController.m
//  NSPAlertController
//
//  Created by Jeff on 12/27/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"
#import "PopupViewController1.h"
#import "STPopup.h"
#import "View1Controller.h"
#import "View2Controller.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)buttonAction:(id)sender
{
//    [View2Controller showSheetInViewController:self callBack:^(UIViewController *viewController, BOOL isConfirmAction) {
//        
//    }];
    
    [[[View1Controller alloc] initWithText:@"hello"] showPopupInViewController:self style:STPopupStyleFormSheet callBack:^(UIViewController *viewController, BOOL isConfirmAction) {
        
    }];
    
//    [View1Controller showAlertInViewController:self callBack:^(UIViewController *vc, BOOL isConfirmAction) {
//        if (isConfirmAction)
//        {
//            NSLog(@"22222222222222222222222222222222222222222222222222222222222222");
//        }
//        else
//        {
//            NSLog(@"3333333333333333333333333333333333333333333333333333333333333333333333333333333333");
//        }
//    }];
    
    
//    NSPAlertController *alertController = [NSPAlertController alertControllerWithTitle:@"title" message:@"message" preferredStyle:NSPAlertControllerStyleAlert];
//    
//    NSPAlertAction *alertAction = [NSPAlertAction actionWithTitle:@"title1" style:NSPAlertActionStyleDefault handler:^(NSPAlertAction * _Nonnull action) {
//        NSLog(@"22222222222222222222222222222222222222222222222222222222222222");
//    }];
//    
//    NSPAlertAction *alertAction2 = [NSPAlertAction actionWithTitle:@"title2" style:NSPAlertActionStyleCancel handler:^(NSPAlertAction * _Nonnull action) {
//        NSLog(@"3333333333333333333333333333333333333333333333333333333333333333333333333333333333");
//    }];
//    
//    [alertController addAction:alertAction];
//    [alertController addAction:alertAction2];
//    
//    [self presentViewController:alertController animated:YES completion:^{
//       NSLog(@"1111111111111111111111111111111111111111111111111111111111111111");
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

























