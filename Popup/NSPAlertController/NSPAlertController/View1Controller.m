//
//  View1Controller.m
//  NSPAlertController
//
//  Created by Jeff on 1/7/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "View1Controller.h"
#import "STPopup.h"

@interface View1Controller ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) NSString *text;

@end

@implementation View1Controller

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentSizeInPopup = CGSizeMake(211, 323);
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text
{
    if (self = [super init])
    {
        self.contentSizeInPopup = CGSizeMake(211, 323);
        _text = text;
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
    NSLog(@"text %@", _text);
}

- (IBAction)buttonTapped:(id)sender
{
    [self.popupController dismiss];
//    !self.popupViewControllerCallBack ?: self.popupViewControllerCallBack(self, NO);
}

- (IBAction)confirmButtonTapped:(id)sender
{
    !self.popupViewControllerCallBack ?: self.popupViewControllerCallBack(self, YES);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




























