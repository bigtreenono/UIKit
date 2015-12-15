//
//  UIScrollView+Refresh.m
//  RefreshDemo
//
//  Created by Jeff on 12/13/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "RefreshHeaderView.h"
#import "RefreshFooterView.h"
#import <objc/runtime.h>

@implementation UIScrollView (Refresh)

- (void)setRefreshHeader:(RefreshHeaderView *)refreshHeader
{
    if (refreshHeader != self.refreshHeader)
    {
        [self.refreshHeader removeFromSuperview];
        [self addSubview:refreshHeader];
        objc_setAssociatedObject(self, @selector(refreshHeader), refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (RefreshHeaderView *)refreshHeader
{
    return objc_getAssociatedObject(self, _cmd);
}

- (RefreshHeaderView *)addRefreshHeaderWithHandler:(RefreshedHandler)refreshHandler
{
    return [self addRefreshHeader:[[RefreshHeaderView alloc] init] handler:refreshHandler];
}

- (RefreshHeaderView *)addRefreshHeader:(RefreshHeaderView *)refreshHeader handler:(RefreshedHandler)refreshHandler
{
    [refreshHeader setValue:refreshHandler forKey:@"refreshHandler"];
    [refreshHeader setValue:self forKey:@"scrollView"];
    return refreshHeader;
}

- (void)setRefreshFooter:(RefreshFooterView *)refreshFooter
{
    if (refreshFooter != self.refreshFooter)
    {
        [self.refreshFooter removeFromSuperview];
        [self addSubview:refreshFooter];
        objc_setAssociatedObject(self, @selector(refreshFooter), refreshFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (RefreshFooterView *)refreshFooter
{
    return objc_getAssociatedObject(self, _cmd);
}

- (RefreshFooterView *)addRefreshFooterWithHandler:(RefreshedHandler)refreshHandler
{
    return [self addRefreshFooter:[[RefreshFooterView alloc] init] handler:refreshHandler];
}

- (RefreshFooterView *)addRefreshFooter:(RefreshFooterView *)refreshFooter handler:(RefreshedHandler)refreshHandler
{
    [refreshFooter setValue:refreshHandler forKey:@"refreshHandler"];
    [refreshFooter setValue:self forKey:@"scrollView"];
    return refreshFooter;
}

@end

























