//
//  UIViewController+STPopup.h
//  STPopup
//
//  Created by Kevin Lin on 13/9/15.
//  Copyright (c) 2015 Sth4Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPopupController.h"

typedef void (^popupViewControllerCallBack)(UIViewController *viewController, BOOL isConfirmAction);

@interface UIViewController (STPopup)

@property (nonatomic, assign) IBInspectable CGSize contentSizeInPopup;
@property (nonatomic, assign) IBInspectable CGSize landscapeContentSizeInPopup;
@property (nonatomic, weak, readonly) STPopupController *popupController;

@property (nonatomic, copy) popupViewControllerCallBack popupViewControllerCallBack;

+ (instancetype)showPopupInViewController:(UIViewController *)viewController style:(STPopupStyle)style callBack:(popupViewControllerCallBack)popupViewControllerCallBack;

- (void)showPopupInViewController:(UIViewController *)viewController style:(STPopupStyle)style callBack:(popupViewControllerCallBack)popupViewControllerCallBack;

@end
