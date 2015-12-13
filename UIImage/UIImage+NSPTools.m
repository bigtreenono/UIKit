//
//  UIImage+NSPTools.m
//  Demo
//
//  Created by FNNishipu on 11/1/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "UIImage+NSPTools.h"

@implementation UIImage (NSPTools)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)snapshotImageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);

//    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
