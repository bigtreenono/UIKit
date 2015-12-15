//
//  UIView+NSPTools.m
//  Demo
//
//  Created by FNNishipu on 11/4/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "UIView+NSPTools.h"

@implementation UIView (NSPTools)

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (UIImageView *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (void)addCornerMaskLayerWithRadius:(CGFloat)radius
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath;
    self.layer.mask = layer;
}

+ (void)registerNibForCellToTableView:(UITableView *)tableView
{
    [tableView registerNib:[self nib] forCellReuseIdentifier:[self reuseIdentifier]];
}

+ (void)registerNibForHeaderFooterToTableView:(UITableView *)tableView
{
    [tableView registerNib:[self nib] forHeaderFooterViewReuseIdentifier:[self reuseIdentifier]];
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:[self reuseIdentifier] bundle:nil];
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

#pragma mark - setters getters
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frameT = self.frame;
    frameT.origin.y = y;
    self.frame = frameT;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setX:(CGFloat)x
{
    CGRect frameT = self.frame;
    frameT.origin.x = x;
    self.frame = frameT;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frameT = self.frame;
    frameT.size.width = width;
    self.frame = frameT;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frameT = self.frame;
    frameT.size.height = height;
    self.frame = frameT;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frameT = self.frame;
    frameT.size = size;
    self.frame = frameT;
}

- (CGSize)size
{
    return self.frame.size;
}

@end


























