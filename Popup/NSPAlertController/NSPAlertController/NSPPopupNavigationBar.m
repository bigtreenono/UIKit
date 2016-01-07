//
//  NSPPopupNavigationBar.m
//  NSPAlertController
//
//  Created by Jeff on 1/3/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "NSPPopupNavigationBar.h"

@implementation NSPPopupNavigationBar
{
    BOOL _isMoving;
    CGFloat _movingStartY;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc dealloc dealloc dealloc dealloc", self.class);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_draggable)
    {
        UITouch *touch = [touches anyObject];
        if ((touch.view == self || touch.view.superview == self) && !_isMoving)
        {
            _isMoving = YES;
            _movingStartY = [touch locationInView:self.window].y;
        }
    }
    else
    {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_draggable)
    {
        if ([_dragDelegate respondsToSelector:@selector(popupNavigationBar:isMovingWithOffset:)])
        {
            [_dragDelegate popupNavigationBar:self isMovingWithOffset:[self offsetWithTouches:touches]];
        }
    }
    else
    {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_draggable)
    {
        [self handleTouches:touches];
    }
    else
    {
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_draggable)
    {
        [self handleTouches:touches];
    }
    else
    {
        [super touchesEnded:touches withEvent:event];
    }
}

- (CGFloat)offsetWithTouches:(NSSet<UITouch *> *)touches
{
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self.window].y - _movingStartY;
}

- (void)handleTouches:(NSSet<UITouch *> *)touches
{
    _isMoving = NO;
    if ([_dragDelegate respondsToSelector:@selector(popupNavigationBar:endMovingWithOffset:)])
    {
        [_dragDelegate popupNavigationBar:self endMovingWithOffset:[self offsetWithTouches:touches]];
    }
}

@end































