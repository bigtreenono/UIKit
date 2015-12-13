//
//  NSPStickyFooterView.m
//  Demo
//
//  Created by Jeff on 12/11/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "NSPStickyFooterView.h"
#import "UIView+NSPTools.h"

@interface NSPStickyFooterView()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) CGPoint beganContentOffset;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) UIColor *topBorderColor;

@end

@implementation NSPStickyFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _isShow = YES;
    
    self.topBorderColor = [UIColor lightGrayColor];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.zPosition = 999;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [self.superview removeObserver:self forKeyPath:@"frame" context:nil];
    [((UIScrollView *)self.superview).panGestureRecognizer removeTarget:self action:@selector(gestureRecognizerStateUpdate:)];
    
    if (newSuperview)
    {
        assert([newSuperview isKindOfClass:[UIScrollView class]]);
        _scrollView = (UIScrollView *)newSuperview;
        
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [_scrollView.panGestureRecognizer addTarget:self action:@selector(gestureRecognizerStateUpdate:)];
        
        _scrollView.contentInset = UIEdgeInsetsMake(_scrollView.contentInset.top, _scrollView.contentInset.left, self.height, _scrollView.contentInset.right);
        _scrollView.scrollIndicatorInsets = _scrollView.contentInset;
        
        self.width = _scrollView.width;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self updateY];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGFloat newOffsetY = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue].y;
        CGFloat oldOffsetY = [[change valueForKey:NSKeyValueChangeOldKey] CGPointValue].y;
        CGFloat delta = newOffsetY - oldOffsetY;
        
        CGFloat totalDelta = _beganContentOffset.y - newOffsetY;
        NSLog(@"newOffsetY %f, oldOffsetY %f, delta %f, totalDelta %f", newOffsetY, oldOffsetY, delta, totalDelta);
        [self updateY];
        
        if (ABS(totalDelta) < 20 || ABS(delta) <= 0.5)
        {
            return;
        }
        
        if (delta > 0 && _scrollView.contentOffset.y > 0.0
            && _scrollView.contentOffset.y + _scrollView.height < _scrollView.contentSize.height)
        {
            if (_isShow)
            {
                _isShow = NO;
            }
        }
        else
        {
            if (!_isShow)
            {
                _isShow = YES;
            }
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [self updateY];
        }];
    }
    else if ([keyPath isEqualToString:@"frame"])
    {
        if (!_isShow)
        {
            [self updateY];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)gestureRecognizerStateUpdate:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        _beganContentOffset = self.scrollView.contentOffset;
        NSLog(@"_beganContentOffset11 %@", NSStringFromCGPoint(_beganContentOffset));
    }
    else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"_beganContentOffset22 %@", NSStringFromCGPoint(_beganContentOffset));
        _beganContentOffset = CGPointZero;
    }
}

- (void)updateY
{
    if (_isShow)
    {
        self.y = _scrollView.contentOffset.y + _scrollView.height - self.height;
    }
    else
    {
        self.y = _scrollView.contentOffset.y + _scrollView.height;
    }
}

- (void)setTopBorderColor:(UIColor *)topBorderColor
{
    _topBorderColor = topBorderColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, 0.25);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), 0.25);
    
    CGContextSetStrokeColorWithColor(context, self.topBorderColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    
    CGContextStrokePath(context);
}

@end


























