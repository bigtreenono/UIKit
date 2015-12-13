//
//  UIButton+NSPTools.m
//  Demo
//
//  Created by Jeff on 12/12/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "UIButton+NSPTools.h"

@implementation UIButton (NSPTools)

- (void)centerImageAndButton:(CGFloat)gap imageOnTop:(BOOL)imageOnTop
{
    NSInteger sign = imageOnTop ? 1 : -1;
    
    CGSize imageSize = self.imageView.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake((imageSize.height + gap) * sign, -imageSize.width, 0, 0);
    
    CGSize titleSize = self.titleLabel.bounds.size;
    self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + gap) * sign, 0, 0, -titleSize.width);
}

@end
