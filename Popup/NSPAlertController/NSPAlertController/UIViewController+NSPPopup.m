//
//  UIViewController+NSPPopup.m
//  NSPAlertController
//
//  Created by Jeff on 1/3/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "UIViewController+NSPPopup.h"
#import "NSPPopupController.h"
#import <objc/runtime.h>

@implementation UIViewController (NSPPopup)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(viewDidLoad) toSelector:@selector(nsp_viewDidLoad)];
        [self swizzleSelector:@selector(presentViewController:animated:completion:) toSelector:@selector(fn_presentViewController:animated:completion:)];
        [self swizzleSelector:@selector(dismissViewControllerAnimated:completion:) toSelector:@selector(nsp_dismissViewControllerAnimated:completion:)];
        [self swizzleSelector:@selector(presentedViewController) toSelector:@selector(nsp_presentedViewController)];
        [self swizzleSelector:@selector(presentingViewController) toSelector:@selector(nsp_presentingViewController)];
    });
}

+ (void)swizzleSelector:(SEL)originalSelector toSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod)
    {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - swizzled selector
- (void)nsp_viewDidLoad
{
    CGSize contentSize = CGSizeZero;
    switch ([UIApplication sharedApplication].statusBarOrientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            contentSize = self.landscapeContentSizeInPopup;
            if (CGSizeEqualToSize(contentSize, CGSizeZero))
            {
                contentSize = self.contentSizeInPopup;
            }
            break;
            
        default:
            contentSize = self.contentSizeInPopup;
            break;
    }
    if (!CGSizeEqualToSize(contentSize, CGSizeZero))
    {
        self.view.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    }
    [self nsp_viewDidLoad];
}

- (void)fn_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if (self.popupController)
    {
        [[self.popupController valueForKey:@"containerVC"] presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
    else
    {
        [self fn_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

- (void)nsp_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (self.popupController)
    {
        [[self.popupController valueForKey:@"containerVC"] dismissViewControllerAnimated:flag completion:completion];
    }
    else
    {
        [self nsp_dismissViewControllerAnimated:flag completion:completion];
    }
}

- (UIViewController *)nsp_presentedViewController
{
    if (self.popupController)
    {
        return [[self.popupController valueForKey:@"containerVC"] presentedViewController];
    }
    else
    {
        return [self nsp_presentedViewController];
    }
}

- (UIViewController *)nsp_presentingViewController
{
    if (self.popupController)
    {
        return [[self.popupController valueForKey:@"containerVC"] presentingViewController];
    }
    else
    {
        return [self nsp_presentingViewController];
    }
}

- (void)setContentSizeInPopup:(CGSize)contentSizeInPopup
{
    if (!CGSizeEqualToSize(CGSizeZero, contentSizeInPopup) && contentSizeInPopup.width == 0)
    {
        switch ([UIApplication sharedApplication].statusBarOrientation)
        {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                contentSizeInPopup.width = [UIScreen mainScreen].bounds.size.height;
                break;
                
            default:
                contentSizeInPopup.width = [UIScreen mainScreen].bounds.size.width;
                break;
        }
    }
    objc_setAssociatedObject(self, @selector(contentSizeInPopup), [NSValue valueWithCGSize:contentSizeInPopup], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)contentSizeInPopup
{
    return [objc_getAssociatedObject(self, @selector(contentSizeInPopup)) CGSizeValue];
}

- (void)setLandscapeContentSizeInPopup:(CGSize)landscapeContentSizeInPopup
{
    if (!CGSizeEqualToSize(CGSizeZero, landscapeContentSizeInPopup) && landscapeContentSizeInPopup.width == 0)
    {
        switch ([UIApplication sharedApplication].statusBarOrientation)
        {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                landscapeContentSizeInPopup.width = [UIScreen mainScreen].bounds.size.width;
                break;
                
            default:
                landscapeContentSizeInPopup.width = [UIScreen mainScreen].bounds.size.height;
                break;
        }
    }
    objc_setAssociatedObject(self, @selector(landscapeContentSizeInPopup), [NSValue valueWithCGSize:landscapeContentSizeInPopup], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)landscapeContentSizeInPopup
{
    return [objc_getAssociatedObject(self, @selector(landscapeContentSizeInPopup)) CGSizeValue];
}

- (void)setPopupController:(NSPPopupController * _Nullable)popupController
{
    objc_setAssociatedObject(self, @selector(popupController), popupController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSPPopupController *)popupController
{
    return objc_getAssociatedObject(self, @selector(popupController));
}

@end






























