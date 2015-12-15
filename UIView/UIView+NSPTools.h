//
//  UIView+NSPTools.h
//  Demo
//
//  Created by FNNishipu on 11/4/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NSPTools)

- (UIViewController *)viewController;

- (UIImageView *)snapshot;

- (void)addCornerMaskLayerWithRadius:(CGFloat)radius;

+ (void)registerNibForCellToTableView:(UITableView *)tableView;
+ (void)registerNibForHeaderFooterToTableView:(UITableView *)tableView;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;

@end
