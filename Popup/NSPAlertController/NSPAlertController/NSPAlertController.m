//
//  NSPAlertController.m
//  NSPAlertController
//
//  Created by Jeff on 12/27/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "NSPAlertController.h"
#import <objc/runtime.h>

@interface UIViewController (NSPAlertController)
@property (nonatomic, strong, nullable) NSPAlertController *nspAlertController;
@end

@implementation UIViewController (NSPAlertController)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        
        SEL originalSelector = @selector(presentViewController:animated:completion:);
        SEL swizzledSelector = @selector(nsp_presentViewController:animated:completion:);
        
        Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
        
        BOOL addMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (addMethod)
        {
            class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else
        {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)nsp_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if ([viewControllerToPresent isKindOfClass:[NSPAlertController class]])
    {
        NSPAlertController *controller = (NSPAlertController *)viewControllerToPresent;
        id adaptiveAlert = controller.adaptiveAlert;
        if ([adaptiveAlert isKindOfClass:[UIViewController class]])
        {
            [self nsp_presentViewController:adaptiveAlert animated:flag completion:completion];
        }
        else
        {
            self.nspAlertController = controller;
            controller.ownerController = self;

            if ([adaptiveAlert isKindOfClass:[UIAlertView class]])
            {
                [controller.textFieldHandlers enumerateObjectsUsingBlock:^(void (^configurationHandler)(UITextField *textField), NSUInteger idx, BOOL *stop) {
                    configurationHandler([adaptiveAlert textFieldAtIndex:idx]);
                }];
                [adaptiveAlert show];
            }
            else if ([adaptiveAlert isKindOfClass:[UIActionSheet class]])
            {
                [adaptiveAlert showInView:self.view];
            }
        }
    }
    else
    {
        [self nsp_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

- (void)setNspAlertController:(NSPAlertController *)nspAlertController
{
    objc_setAssociatedObject(self, @selector(nspAlertController), nspAlertController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSPAlertController *)nspAlertController
{
    return objc_getAssociatedObject(self, @selector(nspAlertController));
}

@end

@interface NSPAlertAction ()

@property (nullable, nonatomic) NSString *title;
@property (nonatomic) NSPAlertActionStyle style;
@property (nullable,nonatomic,strong) void (^handler)(NSPAlertAction * _Nonnull);

@end

@implementation NSPAlertAction

+ (id)actionWithTitle:(NSString *)title style:(NSPAlertActionStyle)style handler:(void (^)(NSPAlertAction * _Nonnull))handler
{
    if ([UIAlertAction class])
    {
        return [UIAlertAction actionWithTitle:title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler];
    }
    else
    {
        NSPAlertAction *action = [NSPAlertAction new];
        action.title = [title copy];
        action.style = style;
        action.handler = handler;
        action.enabled = YES;
        return action;
    }
}

@end

@interface NSPAlertController () <UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonnull,nonatomic,strong) id adaptiveAlert;
@property (nonnull,nonatomic, readwrite) NSMutableArray<NSPAlertAction *> *mutableActions;
@property (nullable, nonatomic, copy) NSArray < void (^) (UITextField *textField)> *textFieldHandlers;
@property (nonatomic, nonnull) NSArray<NSPAlertAction *> *actions;
@property (nonatomic) NSPAlertControllerStyle preferredStyle;

@end

@implementation NSPAlertController

- (void)dealloc
{
    NSLog(@"%@ dealloc dealloc dealloc dealloc dealloc", self.class);
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(NSPAlertControllerStyle)preferredStyle
{
    NSPAlertController *alertController = [[NSPAlertController alloc] init];
    alertController.mutableActions = [NSMutableArray array];
    alertController.preferredStyle = preferredStyle;
    if ([UIAlertController class])
    {
        alertController.adaptiveAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyle)preferredStyle];
    }
    else
    {
        if (preferredStyle == NSPAlertControllerStyleActionSheet)
        {
            alertController.adaptiveAlert = [[UIActionSheet alloc] initWithTitle:title delegate:alertController cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        }
        else
        {
            alertController.adaptiveAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:alertController cancelButtonTitle:nil otherButtonTitles:nil];
        }
    }
    return alertController;
}

#pragma mark - setter getter
- (NSArray<NSPAlertAction *> *)actions
{
    return [self.mutableActions copy];
}

- (NSArray<UITextField *> *)textFields
{
    if ([UIAlertController class])
    {
        return ((UIAlertController *)_adaptiveAlert).textFields;
    }
    else
    {
        if ([_adaptiveAlert isKindOfClass:[UIAlertView class]])
        {
            UIAlertView *alertView = (UIAlertView *)_adaptiveAlert;
            switch (alertView.alertViewStyle)
            {
                case UIAlertViewStyleDefault:
                    return @[];
                    break;
                    
                case UIAlertViewStyleSecureTextInput:
                case UIAlertViewStylePlainTextInput:
                    return @[ [alertView textFieldAtIndex:0] ];
                    break;
                    
                case UIAlertViewStyleLoginAndPasswordInput:
                    return @[ [alertView textFieldAtIndex:0], [alertView textFieldAtIndex:1] ];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            return nil;
        }
    }
}

- (void)setTitle:(NSString *)title
{
    [_adaptiveAlert setTitle:title];
}

- (NSString *)title
{
    return [_adaptiveAlert title];
}

- (void)setMessage:(NSString *)message
{
    [_adaptiveAlert setMessage:message];
}

- (NSString *)message
{
    return [_adaptiveAlert message];
}

- (void)setAlertViewStyle:(UIAlertViewStyle)alertViewStyle
{
    if ([_adaptiveAlert isKindOfClass:[UIAlertView class]])
    {
        [_adaptiveAlert setAlertViewStyle:alertViewStyle];
    }
}

- (UIAlertViewStyle)alertViewStyle
{
    if ([_adaptiveAlert isKindOfClass:[UIAlertView class]])
    {
        return [_adaptiveAlert alertViewStyle];
    }
    return 0;
}

- (void)setPreferredAction:(NSPAlertAction *)preferredAction
{
    if ([_adaptiveAlert respondsToSelector:@selector(setPreferredAction:)])
    {
        [_adaptiveAlert setPreferredAction:preferredAction];
    }
}

- (NSPAlertAction *)preferredAction
{
    if ([_adaptiveAlert respondsToSelector:@selector(preferredAction)])
    {
        return (NSPAlertAction *)[_adaptiveAlert preferredAction];
    }
    return nil;
}

- (void)addAction:(NSPAlertAction *)action
{
    if ([UIAlertController class])
    {
        [_adaptiveAlert addAction:action];
    }
    else
    {
        [_mutableActions addObject:action];
        NSInteger index = [_adaptiveAlert addButtonWithTitle:action.title];
        if (action.style == NSPAlertActionStyleCancel)
        {
            [_adaptiveAlert setCancelButtonIndex:index];
        }
        else if (action.style == NSPAlertActionStyleDestructive)
        {
            [_adaptiveAlert setDestructiveButtonIndex:index];
        }
    }
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler
{
    if ([UIAlertController class])
    {
        [_adaptiveAlert addTextFieldWithConfigurationHandler:configurationHandler];
    }
    else if ([_adaptiveAlert isKindOfClass:[UIAlertView class]])
    {
        _textFieldHandlers = [_textFieldHandlers arrayByAddingObject:configurationHandler ?: ^(UITextField *textfield){}];
        ((UIAlertView *)_adaptiveAlert).alertViewStyle = _textFieldHandlers.count > 1 ? UIAlertViewStyleLoginAndPasswordInput : UIAlertViewStylePlainTextInput;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_mutableActions[buttonIndex].handler)
    {
        _mutableActions[buttonIndex].handler(_adaptiveAlert);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.ownerController.nspAlertController = nil;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    self.ownerController.nspAlertController = nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_mutableActions[buttonIndex].handler)
    {
        _mutableActions[buttonIndex].handler(_adaptiveAlert);
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.ownerController.nspAlertController = nil;
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    self.ownerController.nspAlertController = nil;
}

@end



























