//
//  NSPStickyHeaderView.m
//  Demo
//
//  Created by Jeff on 12/11/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "NSPStickyHeaderView.h"
#import "UIView+NSPTools.h"

@implementation NSPStickyHeaderView
{
    CGFloat _minimunHeight;
}

- (instancetype)initWithMinimunHeight:(CGFloat)minimunHeight
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 0, minimunHeight)])
    {
        _minimunHeight = minimunHeight;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    if (newSuperview)
    {
        NSAssert([newSuperview isKindOfClass:[UIScrollView class]], @"superview must be UIScrollView!");
        self.frame = CGRectMake(self.x, self.y, newSuperview.width, self.height);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        CGFloat delta = 0.0;
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY < 0)
        {
            delta = fabs(offsetY);
        }
        self.frame = CGRectMake(self.x, -delta, self.width, _minimunHeight + delta);
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end





















