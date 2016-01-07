//
//  NSPPopupLeftBarButtonItem.m
//  NSPAlertController
//
//  Created by Jeff on 1/3/16.
//  Copyright © 2016 FNNishipu. All rights reserved.
//

#import "NSPPopupLeftBarButtonItem.h"

@implementation NSPPopupLeftBarButtonItem
{
    UIControl *_customView;
    UIView *_bar1;
    UIView *_bar2;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc dealloc dealloc dealloc dealloc", self.class);
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    _customView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 18, 44)];
    if (self = [super initWithCustomView:_customView])
    {
        [_customView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [_customView addSubview:({
            _bar1 = [UIView new];
            _bar1.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
            _bar1.userInteractionEnabled = NO;
            _bar1.layer.allowsEdgeAntialiasing = YES;
            _bar1;
        })];
        
        [_customView addSubview:({
            _bar2 = [UIView new];
            _bar2.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
            _bar2.userInteractionEnabled = NO;
            _bar2.layer.allowsEdgeAntialiasing = YES;
            _bar2;
        })];
    }
    return self;
}

- (void)setType:(NSPPopupLeftBarButtonItemType)type
{
    [self setType:type animated:NO];
}

- (void)setType:(NSPPopupLeftBarButtonItemType)type animated:(BOOL)animated
{
    _type = type;
    if (animated)
    {
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self updateLayout];
        } completion:nil];
    }
    else
    {
        [self updateLayout];
    }
}

- (void)updateLayout
{
    CGFloat barWidth, barHeight = 1.5, barX, bar1Y, bar2Y;
    if (_type == NSPPopupLeftBarButtonItemTypeCross)
    {
        barWidth = _customView.frame.size.height * 2 / 5;
        barX = (_customView.frame.size.width - barWidth) / 2;
        bar1Y = (_customView.frame.size.height - barHeight) / 2;
        bar2Y = bar1Y;
    }
    else
    {
        barWidth = _customView.frame.size.height / 4;
        barX = (_customView.frame.size.width - barWidth) / 2 - barWidth / 2;
        bar1Y = (_customView.frame.size.height - barHeight) / 2 + barWidth / 2 * sin(M_PI_4);
        bar2Y = (_customView.frame.size.height - barHeight) / 2 - barWidth / 2 * sin(M_PI_4);
    }
    
    _bar1.transform = CGAffineTransformIdentity;
    _bar2.transform = CGAffineTransformIdentity;
    _bar1.frame = CGRectMake(barX, bar1Y, barWidth, barHeight);
    _bar2.frame = CGRectMake(barX, bar2Y, barWidth, barHeight);
    
    _bar1.transform = CGAffineTransformMakeRotation(M_PI_4);
    _bar2.transform = CGAffineTransformMakeRotation(-M_PI_4);
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    _bar1.backgroundColor = tintColor;
    _bar2.backgroundColor = tintColor;
}

@end




























