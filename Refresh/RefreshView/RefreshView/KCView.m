//
//  KCView.m
//  RefreshView
//
//  Created by FNNishipu on 7/11/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import "KCView.h"

@implementation KCView

- (void)drawRect:(CGRect)rect
{    
    NSString *str=_title;
    UIFont *font=[UIFont fontWithName:@"Marker Felt" size:_fontSize];
    UIColor *foreignColor = [UIColor redColor];
    [str drawInRect:CGRectMake(100, 120, 300, 200) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:foreignColor}];
}

@end
