//
//  NSPAlertController.h
//  NSPAlertController
//
//  Created by Jeff on 12/27/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NSPAlertActionStyle) {
    NSPAlertActionStyleDefault = 0,
    NSPAlertActionStyleCancel,
    NSPAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, NSPAlertControllerStyle) {
    NSPAlertControllerStyleActionSheet = 0,
    NSPAlertControllerStyleAlert
};

@interface NSPAlertAction : NSObject

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSPAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nullable,nonatomic,strong,readonly) void (^handler)(NSPAlertAction * _Nonnull);

+ (nonnull id)actionWithTitle:(nullable NSString *)title style:(NSPAlertActionStyle)style handler:(void (^ __nullable)( NSPAlertAction * _Nonnull action))handler;

@end

@interface NSPAlertController : UIViewController

@property (nonnull,nonatomic,strong,readonly) id adaptiveAlert;
@property (nullable,nonatomic,weak) UIViewController *ownerController;
@property (nullable,nonatomic,strong) UIColor *tintColor;
@property (nonatomic, assign) UIAlertViewStyle alertViewStyle;
@property (nullable, nonatomic, copy, readonly) NSArray<void (^)(UITextField *_Nonnull textField)> *textFieldHandlers;

+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(NSPAlertControllerStyle)preferredStyle;

- (void)addAction:(nonnull NSPAlertAction *)action;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField * _Nonnull textField))configurationHandler;

@property (nonnull,nonatomic, readonly) NSArray<NSPAlertAction *> *actions;

@property (nonatomic, strong, nullable) NSPAlertAction *preferredAction NS_AVAILABLE_IOS(9_0);

@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nullable, nonatomic, copy) NSString *title;

@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) NSPAlertControllerStyle preferredStyle;

@end

























