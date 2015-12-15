//
//  RefreshHeaderView.h
//  RefreshDemo
//
//  Created by Jeff on 12/13/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat RefreshHeaderHeight;

@interface RefreshHeaderView : UIView

@property (nonatomic, assign) CGFloat dragHeight;

- (void)startRefresh;

- (void)endRefresh;

@end
