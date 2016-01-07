//
//  NSPPopupController.h
//  NSPAlertController
//
//  Created by Jeff on 1/3/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NSPPopupStyle) {
    NSPPopupStyleFormSheet,
    NSPPopupStyleBottomSheet
};

typedef NS_ENUM(NSUInteger, NSPPopupTransitionStyle) {
    NSPPopupTransitionStyleSlideVertical,
    NSPPopupTransitionStyleFade
};

@interface NSPPopupController : NSObject

@property (nonatomic, assign) NSPPopupStyle style;
@property (nonatomic, assign) NSPPopupTransitionStyle transitionStyle;
@property (nonatomic, assign) BOOL navigationBarHidden;

- (nonnull instancetype)initWithRootViewController:(nonnull UIViewController *)rootViewController;

- (void)presentInViewController:(nonnull UIViewController *)viewController;
- (void)presentInViewController:(nonnull UIViewController *)viewController completion:(void (^__nullable)(void))completion;
- (void)dismiss;
- (void)dismissWithCompletion:(void (^__nullable)(void))completion;

- (void)pushViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated;

@end
























