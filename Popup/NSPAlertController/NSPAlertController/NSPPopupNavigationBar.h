//
//  NSPPopupNavigationBar.h
//  NSPAlertController
//
//  Created by Jeff on 1/3/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSPPopupNavigationBar;

@protocol NSPPopupNavigationBarDragEventDelegate <NSObject>

- (void)popupNavigationBar:(NSPPopupNavigationBar *)navigationBar isMovingWithOffset:(CGFloat)offset;
- (void)popupNavigationBar:(NSPPopupNavigationBar *)navigationBar endMovingWithOffset:(CGFloat)offset;

@end

@interface NSPPopupNavigationBar : UINavigationBar

@property (nonatomic, weak) id <NSPPopupNavigationBarDragEventDelegate> dragDelegate;
@property (nonatomic, assign) BOOL draggable;

@end
