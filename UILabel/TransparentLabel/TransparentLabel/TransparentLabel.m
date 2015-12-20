//
//  TransparentLabel.m
//  TransparentLabel
//
//  Created by Jeff on 12/20/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "TransparentLabel.h"

@implementation TransparentLabel

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect viewBounds = self.bounds;
    CGContextTranslateCTM(ctx, 0, viewBounds.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextSetBlendMode(ctx, kCGBlendModeCopy);
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 0.0);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSelectFont(ctx, "Helvetica", 17.0, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(ctx, 1.7);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextShowTextAtPoint(ctx, 0, 50, "big tree", 9);
}


@end
