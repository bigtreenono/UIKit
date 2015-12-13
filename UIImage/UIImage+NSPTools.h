//
//  UIImage+NSPTools.h
//  Demo
//
//  Created by FNNishipu on 11/1/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NSPTools)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)snapshotImageWithView:(UIView *)view;

@end
