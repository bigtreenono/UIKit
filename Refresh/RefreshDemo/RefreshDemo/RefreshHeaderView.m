//
//  RefreshHeaderView.m
//  RefreshDemo
//
//  Created by Jeff on 12/13/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "RefreshHeaderView.h"

typedef NS_ENUM(NSInteger, LDRefreshState) {
    LDRefreshStateNormal  = 1,
    LDRefreshStatePulling = 2,
    LDRefreshStateLoading = 3,
};

typedef void(^LDRefreshedHandler)(void);

const CGFloat LDRefreshHeaderHeight = 60;

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define TextColor   [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]
#define TextFont    [UIFont systemFontOfSize:12.0f]

@interface RefreshHeaderView ()

@property (nonatomic, strong) UIScrollView            *scrollView;
@property (nonatomic, strong) UILabel                 *statusLab;
@property (nonatomic, strong) UIImageView             *arrowImage;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, assign) UIEdgeInsets            initEdgeInset;
@property (nonatomic, strong) NSDictionary            *stateTextDic;

@property (nonatomic, copy  ) LDRefreshedHandler      refreshHandler;
@property (nonatomic, assign) LDRefreshState          refreshState;
@end

@implementation RefreshHeaderView

- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, -LDRefreshHeaderHeight, ScreenWidth, LDRefreshHeaderHeight);
        
        _statusLab = ({
            UILabel *lab        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, LDRefreshHeaderHeight)];
            lab.font            = TextFont;
            lab.textColor       = TextColor;
            lab.backgroundColor = [UIColor clearColor];
            lab.textAlignment   = NSTextAlignmentCenter;
            [self addSubview:lab];
            lab;
        });
        
        _arrowImage = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_pull_refresh"]];
            imageView.frame        = CGRectMake(ScreenWidth / 2.0 - 60, (LDRefreshHeaderHeight - 32) / 2.0, 32, 32);
            [self addSubview:imageView];
            imageView;
        });
        
        _indicatorView = ({
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView.color                    = TextColor;
            indicatorView.frame                    = _arrowImage.frame;
            [self addSubview:indicatorView];
            indicatorView;
        });
        
        _stateTextDic = @{ @"normalText" : @"下拉刷新",
                           @"pullingText" : @"释放更新",
                           @"loadingText" : @"加载中..." };
        
        self.refreshState = LDRefreshStateNormal;
    }
    return self;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (_scrollView != scrollView)
    {
        _scrollView    = scrollView;
//        _initEdgeInset = scrollView.contentInset;
        _initEdgeInset = UIEdgeInsetsMake(scrollView.contentInset.top + 64, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
        NSLog(@"scrollView.contentInset %@", NSStringFromUIEdgeInsets(scrollView.contentInset));
        [_scrollView addSubview:self];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
//        NSLog(@"dragHeight %f, dragHeightThreshold %f, refreshState %zd, isDragging %d", self.dragHeight, self.dragHeightThreshold, _refreshState, _scrollView.isDragging);
        if (self.dragHeight < 0 || _refreshState == LDRefreshStateLoading)
        {
            return;
        }
        
        if (_scrollView.isDragging)
        {
            if (self.dragHeight < self.dragHeightThreshold)
            {
                self.refreshState = LDRefreshStateNormal;
            }
            else
            {
                self.refreshState = LDRefreshStatePulling;
            }
        }
        else if (_refreshState == LDRefreshStatePulling)
        {
            self.refreshState = LDRefreshStateLoading;
        }
    }
}

- (CGFloat)dragHeight
{
    return (_scrollView.contentOffset.y + _initEdgeInset.top) * -1.0;
}

- (CGFloat)dragHeightThreshold
{
    return LDRefreshHeaderHeight;
}

- (void)setRefreshState:(LDRefreshState)refreshState
{
    _refreshState = refreshState;
    switch (_refreshState)
    {
        case LDRefreshStateNormal:
        {
            [self normalAnimation];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentInset = _initEdgeInset;
            }];
        }
            break;
            
        case LDRefreshStatePulling:
            [self pullingAnimation];
            break;
            
        case LDRefreshStateLoading:
        {
            [self loadingAnimation];
            
            [UIView animateWithDuration:0.3 animations:^{
                UIEdgeInsets inset           = _initEdgeInset;
                inset.top                    += LDRefreshHeaderHeight;
                self.scrollView.contentInset = inset;
            }];
            
            !_refreshHandler ?: _refreshHandler();
        }
            break;
    }
}

- (void)normalAnimation
{
    _statusLab.text    = _stateTextDic[@"normalText"];
    _arrowImage.hidden = NO;
    [_indicatorView stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        _arrowImage.transform = CGAffineTransformIdentity;
    }];
}

- (void)pullingAnimation
{
    _statusLab.text = _stateTextDic[@"pullingText"];
    [UIView animateWithDuration:0.3 animations:^{
        _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (void)loadingAnimation
{
    _statusLab.text    = _stateTextDic[@"loadingText"];
    _arrowImage.hidden = YES;
    _arrowImage.transform = CGAffineTransformIdentity;
    [_indicatorView startAnimating];
}

- (void)startRefresh
{
    self.refreshState = LDRefreshStateLoading;
}

- (void)endRefresh
{
    self.refreshState = LDRefreshStateNormal;
}

@end




























