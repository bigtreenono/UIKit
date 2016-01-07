//
//  NSPPopupLeftBarButtonItem.h
//  NSPAlertController
//
//  Created by Jeff on 1/3/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NSPPopupLeftBarButtonItemType)
{
    NSPPopupLeftBarButtonItemTypeCross,
    NSPPopupLeftBarButtonItemTypeArrow
};

@interface NSPPopupLeftBarButtonItem : UIBarButtonItem

@property (nonatomic, assign) NSPPopupLeftBarButtonItemType type;

- (instancetype)initWithTarget:(id)target action:(SEL)action;
- (void)setType:(NSPPopupLeftBarButtonItemType)type animated:(BOOL)animated;

@end
