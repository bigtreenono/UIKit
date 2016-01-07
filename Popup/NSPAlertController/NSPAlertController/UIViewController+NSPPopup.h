//
//  UIViewController+NSPPopup.h
//  NSPAlertController
//
//  Created by Jeff on 1/3/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSPPopupController;

@interface UIViewController (NSPPopup)

@property (nonatomic, assign) IBInspectable CGSize contentSizeInPopup;
@property (nonatomic, assign) IBInspectable CGSize landscapeContentSizeInPopup;
@property (nonatomic, weak, readonly) NSPPopupController *popupController;

@end
