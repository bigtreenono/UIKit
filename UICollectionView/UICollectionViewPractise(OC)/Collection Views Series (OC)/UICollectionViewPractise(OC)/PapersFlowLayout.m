//
//  PapersFlowLayout.m
//  UICollectionViewPractise(OC)
//
//  Created by FNNishipu on 8/20/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import "PapersFlowLayout.h"

@implementation PapersFlowLayout

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    if (itemIndexPath == _appearingIndexPath)
    {
        CGFloat width = CGRectGetWidth(self.collectionView.frame);
        layoutAttributes.alpha = 1;
        layoutAttributes.center = CGPointMake(width - 23.5, -24.5);
        layoutAttributes.transform = CGAffineTransformMakeScale(0.15, 0.15);
        layoutAttributes.zIndex = 99;
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if ([_disappearingItemsIndexPaths containsObject:itemIndexPath])
    {
        layoutAttributes.alpha = 1.0;
        layoutAttributes.transform = CGAffineTransformMakeScale(0.1, 0.1);
        layoutAttributes.zIndex = -1;
    }
    return layoutAttributes;
}

@end
