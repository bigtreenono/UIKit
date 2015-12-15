//
//  UIScrollView+Refresh.h
//  RefreshDemo
//
//  Created by Jeff on 12/13/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshedHandler)(void);

@class RefreshHeaderView, RefreshFooterView;

@interface UIScrollView (Refresh)

@property (strong, nonatomic) RefreshHeaderView *refreshHeader;

- (RefreshHeaderView *)addRefreshHeaderWithHandler:(RefreshedHandler)refreshHandler;

- (RefreshHeaderView *)addRefreshHeader:(RefreshHeaderView *)refreshHeaderView handler:(RefreshedHandler)refreshHandler;


@property (strong, nonatomic) RefreshFooterView *refreshFooter;

- (RefreshFooterView *)addRefreshFooterWithHandler:(RefreshedHandler)refreshHandler;

- (RefreshFooterView *)addRefreshFooter:(RefreshFooterView *)refreshFooterView handler:(RefreshedHandler)refreshHandler;

@end
